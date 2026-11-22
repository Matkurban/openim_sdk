import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';

/// 群管理独立页（全员禁言、入群验证方式、成员权限开关、群管理员、群主转让、解散群聊）。
///
/// Dedicated group management page for owners and admins.
class GroupManagementPage extends StatefulWidget {
  /// 会话 ID。
  final String conversationId;

  /// 群信息。
  final GroupInfo? initialGroup;

  /// 当前用户是否为群主。
  final bool isOwner;

  /// 创建群管理页。
  const GroupManagementPage({
    super.key,
    required this.conversationId,
    this.initialGroup,
    this.isOwner = false,
  });

  @override
  State<GroupManagementPage> createState() => _GroupManagementPageState();
}

class _GroupManagementPageState extends State<GroupManagementPage> {
  late final Signal<GroupInfo?> _group = signal<GroupInfo?>(
    widget.initialGroup,
  );

  Future<void> _reload() async {
    final String gid = _group.value?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    final List<GroupInfo> infos = await OpenIM.iMManager.groupManager
        .getGroupsInfo(groupIDList: <String>[gid]);
    if (infos.isNotEmpty && mounted) {
      _group.value = infos.first;
    }
  }

  Future<void> _toggleAllMute(bool mute) async {
    final String gid = _group.value?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.groupManager.changeGroupMute(
        groupID: gid,
        mute: mute,
      );
      await FlutterToastPro.success(mute ? '已开启全员禁言' : '已关闭全员禁言');
      await _reload();
    } on Object catch (error) {
      await FlutterToastPro.error('操作失败：$error');
    }
  }

  Future<void> _updateGroupFlag({
    GroupVerification? needVerification,
    int? lookMemberInfo,
    int? applyMemberFriend,
  }) async {
    final String gid = _group.value?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.groupManager.setGroupInfo(
        groupInfo: GroupInfo(
          groupID: gid,
          needVerification: needVerification,
          lookMemberInfo: lookMemberInfo,
          applyMemberFriend: applyMemberFriend,
        ),
      );
      await FlutterToastPro.success('群设置已更新');
      await _reload();
    } on Object catch (error) {
      await FlutterToastPro.error('更新失败：$error');
    }
  }

  Future<void> _dismissGroup() async {
    final String gid = _group.value?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.groupManager.dismissGroup(groupID: gid);
      await FlutterToastPro.success('已解散群聊');
      if (mounted) {
        AdaptiveRouter.of(context).popUntil(
          (AdaptiveRouteMatch m) =>
              m.matchedLocation == AppRoutes.conversations,
        );
      }
    } on Object catch (error) {
      await FlutterToastPro.error('解散失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('群管理')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final GroupInfo? group = _group.value;
          final bool isMuted = group?.status == GroupStatus.muted;
          final GroupVerification verification =
              group?.needVerification ??
              GroupVerification.applyNeedVerificationInviteDirectly;
          final bool allowLookMember = (group?.lookMemberInfo ?? 0) == 0;
          final bool allowAddFriend = (group?.applyMemberFriend ?? 0) == 0;

          return ListView(
            children: <Widget>[
              SwitchListTile(
                tileColor: theme.colorScheme.surface,
                title: const Text('全员禁言'),
                subtitle: const Text('开启后仅群主和管理员可发言'),
                value: isMuted,
                onChanged: _toggleAllMute,
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: theme.colorScheme.surface,
                title: const Text('入群验证方式'),
                subtitle: Text(switch (verification) {
                  GroupVerification.applyNeedVerificationInviteDirectly =>
                    '申请需验证，邀请直接入群',
                  GroupVerification.allNeedVerification => '所有人进群均需验证',
                  GroupVerification.directly => '允许直接进群',
                }),
                trailing: PopupMenuButton<GroupVerification>(
                  onSelected: (GroupVerification v) =>
                      _updateGroupFlag(needVerification: v),
                  itemBuilder: (BuildContext _) =>
                      const <PopupMenuEntry<GroupVerification>>[
                        PopupMenuItem<GroupVerification>(
                          value: GroupVerification
                              .applyNeedVerificationInviteDirectly,
                          child: Text('申请需验证，邀请直接入群'),
                        ),
                        PopupMenuItem<GroupVerification>(
                          value: GroupVerification.allNeedVerification,
                          child: Text('所有人进群均需验证'),
                        ),
                        PopupMenuItem<GroupVerification>(
                          value: GroupVerification.directly,
                          child: Text('允许直接进群'),
                        ),
                      ],
                ),
              ),
              const Divider(height: 1),
              SwitchListTile(
                tileColor: theme.colorScheme.surface,
                title: const Text('允许查看群成员资料'),
                value: allowLookMember,
                onChanged: (bool allow) =>
                    _updateGroupFlag(lookMemberInfo: allow ? 0 : 1),
              ),
              const Divider(height: 1),
              SwitchListTile(
                tileColor: theme.colorScheme.surface,
                title: const Text('允许通过群聊添加好友'),
                value: allowAddFriend,
                onChanged: (bool allow) =>
                    _updateGroupFlag(applyMemberFriend: allow ? 0 : 1),
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: theme.colorScheme.surface,
                title: const Text('群管理员'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => router.pushNamed(
                  AppRoutes.groupAdmins(widget.conversationId),
                  arguments: <String, Object?>{
                    'group': group,
                    'isOwner': widget.isOwner,
                  },
                ),
              ),
              if (widget.isOwner) ...<Widget>[
                const Divider(height: 1),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('群主管理权转让'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => router.pushNamed(
                    AppRoutes.groupTransfer(widget.conversationId),
                    arguments: group,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.danger,
                    ),
                    onPressed: _dismissGroup,
                    child: const Text('解散该群'),
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
