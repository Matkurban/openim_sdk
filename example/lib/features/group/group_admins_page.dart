import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../shared/widgets/cached_avatar.dart';

/// 群管理员管理页（查看、新增与撤销群管理员）。
///
/// Group administrators management page.
class GroupAdminsPage extends StatefulWidget {
  /// 群信息。
  final GroupInfo? group;

  /// 当前用户是否为群主。
  final bool isOwner;

  /// 创建群管理员页。
  const GroupAdminsPage({super.key, required this.group, this.isOwner = false});

  @override
  State<GroupAdminsPage> createState() => _GroupAdminsPageState();
}

class _GroupAdminsPageState extends State<GroupAdminsPage> {
  late final Signal<List<GroupMembersInfo>> _admins =
      signal<List<GroupMembersInfo>>(<GroupMembersInfo>[]);
  late final Signal<List<GroupMembersInfo>> _normalMembers =
      signal<List<GroupMembersInfo>>(<GroupMembersInfo>[]);
  late final Signal<bool> _loading = signal<bool>(true);

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
    try {
      final List<GroupMembersInfo> ownersAndAdmins = await OpenIM
          .iMManager
          .groupManager
          .getGroupOwnerAndAdmin(groupID: gid);
      final List<GroupMembersInfo> members = await OpenIM.iMManager.groupManager
          .getGroupMemberList(
            groupID: gid,
            filter: GroupMemberFilter.member.value,
            count: 100,
          );
      if (mounted) {
        batch(() {
          _admins.value = ownersAndAdmins
              .where(
                (GroupMembersInfo m) => m.roleLevel == GroupRoleLevel.admin,
              )
              .toList();
          _normalMembers.value = members;
        });
      }
    } finally {
      if (mounted) {
        _loading.value = false;
      }
    }
  }

  Future<void> _setRole(GroupMembersInfo member, GroupRoleLevel level) async {
    final String gid = widget.group?.groupID ?? '';
    final String uid = member.userID ?? '';
    if (gid.isEmpty || uid.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.groupManager.setGroupMemberInfo(
        groupMembersInfo: SetGroupMemberInfo(
          groupID: gid,
          userID: uid,
          roleLevel: level.value,
        ),
      );
      await FlutterToastPro.success(
        level == GroupRoleLevel.admin ? '已设为管理员' : '已撤销管理员',
      );
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('操作失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('群管理员')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          if (_loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<GroupMembersInfo> admins = _admins.value;
          final List<GroupMembersInfo> normalMembers = _normalMembers.value;
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Text('当前管理员（${admins.length}）'),
              ),
              for (final GroupMembersInfo admin in admins)
                ListTile(
                  leading: CachedAvatar(
                    imageUrl: admin.faceURL,
                    fallbackName: admin.nickname ?? admin.userID,
                  ),
                  title: Text(admin.nickname ?? admin.userID ?? ''),
                  trailing: widget.isOwner
                      ? TextButton(
                          onPressed: () =>
                              _setRole(admin, GroupRoleLevel.member),
                          child: const Text('撤销'),
                        )
                      : null,
                ),
              if (widget.isOwner) ...<Widget>[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: Text('可添加的普通成员（${normalMembers.length}）'),
                ),
                for (final GroupMembersInfo m in normalMembers)
                  ListTile(
                    leading: CachedAvatar(
                      imageUrl: m.faceURL,
                      fallbackName: m.nickname ?? m.userID,
                    ),
                    title: Text(m.nickname ?? m.userID ?? ''),
                    trailing: OutlinedButton(
                      onPressed: () => _setRole(m, GroupRoleLevel.admin),
                      child: const Text('设为管理员'),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
