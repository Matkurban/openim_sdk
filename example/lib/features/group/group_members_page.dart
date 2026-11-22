import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/contact_picker_page.dart';

/// 群成员管理独立页（搜索、按角色筛选、邀请新成员、批量移出与点击进入单成员操作页）。
///
/// Full group members management page with search, role filter, invite, and kick.
class GroupMembersPage extends StatefulWidget {
  /// 会话 ID。
  final String conversationId;

  /// 群信息。
  final GroupInfo? group;

  /// 当前用户群成员信息。
  final GroupMembersInfo? selfMember;

  /// 创建群成员管理页。
  const GroupMembersPage({
    super.key,
    required this.conversationId,
    required this.group,
    this.selfMember,
  });

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  late final Signal<List<GroupMembersInfo>> _members =
      signal<List<GroupMembersInfo>>(<GroupMembersInfo>[]);
  late final Signal<GroupMemberFilter> _filter = signal<GroupMemberFilter>(
    GroupMemberFilter.all,
  );
  late final Signal<bool> _loading = signal<bool>(true);

  bool get _canManage =>
      widget.selfMember?.roleLevel == GroupRoleLevel.owner ||
      widget.selfMember?.roleLevel == GroupRoleLevel.admin;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final String gid = widget.group?.groupID ?? '';
    if (gid.isEmpty) {
      _loading.value = false;
      return;
    }
    _loading.value = true;
    try {
      final List<GroupMembersInfo> list = await OpenIM.iMManager.groupManager
          .getGroupMemberList(
            groupID: gid,
            filter: _filter.value.value,
            count: 200,
          );
      if (mounted) {
        _members.value = list;
      }
    } finally {
      if (mounted) {
        _loading.value = false;
      }
    }
  }

  Future<void> _search(String keyword) async {
    final String gid = widget.group?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    final String trimmed = keyword.trim();
    if (trimmed.isEmpty) {
      await _load();
      return;
    }
    final List<GroupMembersInfo> list = await OpenIM.iMManager.groupManager
        .searchGroupMembers(
          groupID: gid,
          keywordList: <String>[trimmed],
          isSearchUserID: true,
          isSearchMemberNickname: true,
        );
    if (mounted) {
      _members.value = list;
    }
  }

  Future<void> _invite() async {
    final String gid = widget.group?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    final Set<String> existing = _members.value
        .map((GroupMembersInfo m) => m.userID ?? '')
        .toSet();
    final List<FriendInfo>? picked = await ContactPickerPage.pick(
      context,
      title: '邀请好友入群',
      excludedUserIDs: existing,
    );
    if (picked == null || picked.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.groupManager.inviteUserToGroup(
        groupID: gid,
        userIDList: picked.map((FriendInfo f) => f.friendUserID ?? '').toList(),
      );
      await FlutterToastPro.success('邀请成功');
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('邀请失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    return SignalBuilder(
      builder: (BuildContext _) {
        final List<GroupMembersInfo> members = _members.value;
        final GroupMemberFilter filter = _filter.value;
        final bool loading = _loading.value;
        return Scaffold(
          appBar: AppBar(
            title: Text('群成员 (${members.length})'),
            actions: <Widget>[
              IconButton(
                tooltip: '邀请成员',
                icon: const Icon(Icons.person_add_alt_1_outlined),
                onPressed: _invite,
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                child: TextField(
                  onChanged: _search,
                  decoration: const InputDecoration(
                    hintText: '搜索群成员昵称或用户 ID',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  children: <Widget>[
                    for (final (GroupMemberFilter f, String label)
                        in const <(GroupMemberFilter, String)>[
                          (GroupMemberFilter.all, '全部'),
                          (GroupMemberFilter.owner, '群主'),
                          (GroupMemberFilter.admin, '管理员'),
                          (GroupMemberFilter.member, '普通成员'),
                        ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: filter == f,
                          onSelected: (bool _) {
                            _filter.value = f;
                            _load();
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: members.length,
                        separatorBuilder: (BuildContext _, int _) =>
                            const Divider(height: 1, indent: 68),
                        itemBuilder: (BuildContext _, int index) {
                          final GroupMembersInfo m = members[index];
                          final String roleLabel = switch (m.roleLevel) {
                            GroupRoleLevel.owner => '群主',
                            GroupRoleLevel.admin => '管理员',
                            _ => '成员',
                          };
                          final bool isMuted =
                              (m.muteEndTime ?? 0) >
                              DateTime.now().millisecondsSinceEpoch;
                          return ListTile(
                            leading: CachedAvatar(
                              imageUrl: m.faceURL,
                              fallbackName: m.nickname ?? m.userID,
                            ),
                            title: Text(m.nickname ?? m.userID ?? ''),
                            subtitle: Text(
                              isMuted ? '$roleLabel · 禁言中' : roleLabel,
                            ),
                            trailing: _canManage
                                ? const Icon(Icons.chevron_right)
                                : null,
                            onTap: () async {
                              await router.pushNamed(
                                AppRoutes.groupMemberDetail(
                                  widget.conversationId,
                                  m.userID ?? '',
                                ),
                                arguments: <String, Object?>{
                                  'group': widget.group,
                                  'member': m,
                                  'selfMember': widget.selfMember,
                                },
                              );
                              await _load();
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
