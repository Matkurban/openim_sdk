import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/contact_picker_page.dart';

/// 群聊详情设置页（对标微信：5 列群成员网格 + `+`/`-` + 群名/二维码/公告/群管理/群昵称/查记录/画廊/免打扰/定时销毁/退群）。
///
/// WeChat-style group chat detail settings page.
class GroupChatDetailPage extends StatefulWidget {
  /// 会话 ID。
  final String conversationId;

  /// 创建群聊详情页。
  const GroupChatDetailPage({super.key, required this.conversationId});

  @override
  State<GroupChatDetailPage> createState() => _GroupChatDetailPageState();
}

class _GroupChatDetailPageState extends State<GroupChatDetailPage> {
  ConversationInfo? _conversation;
  GroupInfo? _group;
  List<GroupMembersInfo> _members = <GroupMembersInfo>[];
  GroupMembersInfo? _selfMember;
  bool _loading = true;

  bool get _isOwner => _selfMember?.roleLevel == GroupRoleLevel.owner;
  bool get _isAdminOrOwner =>
      _isOwner || _selfMember?.roleLevel == GroupRoleLevel.admin;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final List<ConversationInfo> convs = await OpenIM
          .iMManager
          .conversationManager
          .getMultipleConversation(
            conversationIDList: <String>[widget.conversationId],
          );
      final ConversationInfo? conv = convs.isNotEmpty ? convs.first : null;
      final String gid = conv?.groupID ?? '';
      GroupInfo? group;
      List<GroupMembersInfo> members = <GroupMembersInfo>[];
      GroupMembersInfo? selfMember;
      if (gid.isNotEmpty) {
        final List<GroupInfo> infos = await OpenIM.iMManager.groupManager
            .getGroupsInfo(groupIDList: <String>[gid]);
        if (infos.isNotEmpty) {
          group = infos.first;
        }
        members = await OpenIM.iMManager.groupManager.getGroupMemberList(
          groupID: gid,
          count: 20,
        );
        final List<GroupMembersInfo> selfList = await OpenIM
            .iMManager
            .groupManager
            .getGroupMembersInfo(
              groupID: gid,
              userIDList: <String>[OpenIM.iMManager.userID],
            );
        if (selfList.isNotEmpty) {
          selfMember = selfList.first;
        }
      }
      if (mounted) {
        setState(() {
          _conversation = conv;
          _group = group;
          _members = members;
          _selfMember = selfMember;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _inviteMembers() async {
    final String gid = _group?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    final Set<String> existing = _members
        .map((GroupMembersInfo m) => m.userID ?? '')
        .toSet();
    final List<FriendInfo>? picked = await ContactPickerPage.pick(
      context,
      title: '邀请好友加入群聊',
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
      await FlutterToastPro.success('已发送入群邀请');
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('邀请失败：$error');
    }
  }

  Future<void> _editGroupName() async {
    final GroupInfo? group = _group;
    if (group == null) {
      return;
    }
    final TextEditingController textController = TextEditingController(
      text: group.groupName ?? '',
    );
    final String? nextName = await showDialog<String>(
      context: context,
      useRootNavigator: AdaptivePaneScope.maybeOf(context) != null,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('修改群名称'),
        content: TextField(controller: textController, autofocus: true),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(textController.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    textController.dispose();
    if (nextName == null || nextName.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.groupManager.setGroupInfo(
        groupInfo: GroupInfo(groupID: group.groupID, groupName: nextName),
      );
      await FlutterToastPro.success('群名称已更新');
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('修改失败：$error');
    }
  }

  Future<void> _editMyNickname() async {
    final String gid = _group?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    final TextEditingController textController = TextEditingController(
      text: _selfMember?.nickname ?? '',
    );
    final String? nextNick = await showDialog<String>(
      context: context,
      useRootNavigator: AdaptivePaneScope.maybeOf(context) != null,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('我在本群的昵称'),
        content: TextField(controller: textController, autofocus: true),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(textController.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    textController.dispose();
    if (nextNick == null) {
      return;
    }
    try {
      await OpenIM.iMManager.groupManager.setGroupMemberInfo(
        groupMembersInfo: SetGroupMemberInfo(
          groupID: gid,
          userID: OpenIM.iMManager.userID,
          nickname: nextNick,
        ),
      );
      await FlutterToastPro.success('群昵称已更新');
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('更新失败：$error');
    }
  }

  Future<void> _togglePin(bool pin) async {
    await OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: widget.conversationId,
      isPinned: pin,
    );
    await _load();
  }

  Future<void> _toggleMute(bool mute) async {
    await OpenIM.iMManager.conversationManager.setConversation(
      conversationID: widget.conversationId,
      req: ConversationReq(
        recvMsgOpt: mute
            ? ReceiveMessageOpt.notNotify.value
            : ReceiveMessageOpt.receive.value,
      ),
    );
    await _load();
  }

  Future<void> _toggleMsgDestruct(bool enabled) async {
    await OpenIM.iMManager.conversationManager.setConversation(
      conversationID: widget.conversationId,
      req: ConversationReq(
        isMsgDestruct: enabled,
        msgDestructTime: enabled ? 7 * 24 * 3600 : 0,
      ),
    );
    await _load();
  }

  Future<void> _clearHistory() async {
    await OpenIM.iMManager.conversationManager.clearConversationAndDeleteAllMsg(
      conversationID: widget.conversationId,
    );
    await FlutterToastPro.success('已清空群聊天记录');
  }

  Future<void> _quitOrDismiss() async {
    final String gid = _group?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    try {
      if (_isOwner) {
        await OpenIM.iMManager.groupManager.dismissGroup(groupID: gid);
        await FlutterToastPro.success('已解散群聊');
      } else {
        await OpenIM.iMManager.groupManager.quitGroup(groupID: gid);
        await FlutterToastPro.success('已退出群聊');
      }
      if (mounted) {
        AdaptiveRouter.of(context).popUntil(
          (AdaptiveRouteMatch m) =>
              m.matchedLocation == AppRoutes.conversations,
        );
      }
    } on Object catch (error) {
      await FlutterToastPro.error('操作失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final ThemeData theme = Theme.of(context);
    final int memberCount = _group?.memberCount ?? _members.length;
    final bool isPinned = _conversation?.isPinned ?? false;
    final bool isMuted =
        _conversation?.recvMsgOpt == ReceiveMessageOpt.notNotify;
    final bool isDestruct = _conversation?.isMsgDestruct ?? false;

    return Scaffold(
      appBar: AppBar(title: Text('聊天信息 ($memberCount)')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Container(
                  color: theme.colorScheme.surface,
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: <Widget>[
                      _GroupMembersPreviewGrid(
                        members: _members.take(13).toList(),
                        canKick: _isAdminOrOwner,
                        onTapMember: (GroupMembersInfo m) {
                          router.pushNamed(
                            AppRoutes.groupMemberDetail(
                              widget.conversationId,
                              m.userID ?? '',
                            ),
                            arguments: <String, Object?>{
                              'group': _group,
                              'member': m,
                              'selfMember': _selfMember,
                            },
                          );
                        },
                        onInvite: _inviteMembers,
                        onKick: () => router.pushNamed(
                          AppRoutes.groupMembers(widget.conversationId),
                          arguments: <String, Object?>{
                            'group': _group,
                            'selfMember': _selfMember,
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () async {
                          await router.pushNamed(
                            AppRoutes.groupMembers(widget.conversationId),
                            arguments: <String, Object?>{
                              'group': _group,
                              'selfMember': _selfMember,
                            },
                          );
                          await _load();
                        },
                        child: Text('查看全部群成员 ($memberCount) >'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('群聊名称'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        _group?.groupName ?? '',
                        style: TextStyle(color: theme.hintColor),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: _isAdminOrOwner ? _editGroupName : null,
                ),
                const Divider(height: 1),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('群二维码'),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.qr_code_2, size: 20),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => router.pushNamed(
                    AppRoutes.groupQr(widget.conversationId),
                    arguments: _group,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('群公告'),
                  subtitle: (_group?.notification ?? '').isNotEmpty
                      ? Text(
                          _group!.notification!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await router.pushNamed(
                      AppRoutes.groupAnnouncement(widget.conversationId),
                      arguments: <String, Object?>{
                        'group': _group,
                        'canEdit': _isAdminOrOwner,
                      },
                    );
                    await _load();
                  },
                ),
                if (_isAdminOrOwner) ...<Widget>[
                  const Divider(height: 1),
                  ListTile(
                    tileColor: theme.colorScheme.surface,
                    title: const Text('群管理'),
                    subtitle: const Text('全员禁言、入群验证、管理员、转让群主'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await router.pushNamed(
                        AppRoutes.groupManagement(widget.conversationId),
                        arguments: <String, Object?>{
                          'group': _group,
                          'isOwner': _isOwner,
                        },
                      );
                      await _load();
                    },
                  ),
                ],
                const SizedBox(height: 10),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('我在本群的昵称'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        _selfMember?.nickname ?? '',
                        style: TextStyle(color: theme.hintColor),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: _editMyNickname,
                ),
                const Divider(height: 1),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('查找聊天记录'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => router.pushNamed(
                    AppRoutes.chatSearch(widget.conversationId),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('图片与视频'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => router.pushNamed(
                    AppRoutes.chatGallery(widget.conversationId),
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('置顶聊天'),
                  value: isPinned,
                  onChanged: _togglePin,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('消息免打扰'),
                  value: isMuted,
                  onChanged: _toggleMute,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('消息定时销毁（7天）'),
                  value: isDestruct,
                  onChanged: _toggleMsgDestruct,
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('清空聊天记录'),
                  onTap: _clearHistory,
                ),
                const Divider(height: 1),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('投诉举报'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => router.pushNamed(
                    AppRoutes.report,
                    arguments: <String, String>{
                      'type': 'group',
                      'targetId': _group?.groupID ?? '',
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.danger,
                    ),
                    onPressed: _quitOrDismiss,
                    child: Text(_isOwner ? '解散该群' : '退出群聊'),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
    );
  }
}

class _GroupMembersPreviewGrid extends StatelessWidget {
  final List<GroupMembersInfo> members;
  final bool canKick;
  final ValueChanged<GroupMembersInfo> onTapMember;
  final VoidCallback onInvite;
  final VoidCallback onKick;

  const _GroupMembersPreviewGrid({
    required this.members,
    required this.canKick,
    required this.onTapMember,
    required this.onInvite,
    required this.onKick,
  });

  @override
  Widget build(BuildContext context) {
    final int totalItems = members.length + (canKick ? 2 : 1);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 8,
        childAspectRatio: 0.78,
      ),
      itemCount: totalItems,
      itemBuilder: (BuildContext _, int index) {
        if (index < members.length) {
          final GroupMembersInfo m = members[index];
          return InkWell(
            onTap: () => onTapMember(m),
            child: Column(
              children: <Widget>[
                CachedAvatar(
                  imageUrl: m.faceURL,
                  fallbackName: m.nickname ?? m.userID,
                  size: 46,
                ),
                const SizedBox(height: 4),
                Text(
                  m.nickname ?? m.userID ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          );
        }
        if (index == members.length) {
          return _GridActionButton(
            icon: Icons.add,
            label: '邀请',
            onTap: onInvite,
          );
        }
        return _GridActionButton(
          icon: Icons.remove,
          label: '移除',
          onTap: onKick,
        );
      },
    );
  }
}

class _GridActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _GridActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                style: BorderStyle.solid,
              ),
            ),
            child: Icon(icon, color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
