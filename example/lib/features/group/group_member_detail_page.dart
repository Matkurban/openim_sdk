import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 群成员个人操作页（查看资料、修改群昵称、设/撤管理员、单人禁言时长、移出群聊）。
///
/// Group member detail and moderation page (nickname, role, mute duration, kick).
class GroupMemberDetailPage extends StatefulWidget {
  /// 所属会话 ID。
  final String conversationId;

  /// 目标成员用户 ID。
  final String userId;

  /// 群信息。
  final GroupInfo? group;

  /// 目标成员对象。
  final GroupMembersInfo? member;

  /// 当前操作者自身成员对象。
  final GroupMembersInfo? selfMember;

  /// 创建群成员详情操作页。
  const GroupMemberDetailPage({
    super.key,
    required this.conversationId,
    required this.userId,
    this.group,
    this.member,
    this.selfMember,
  });

  @override
  State<GroupMemberDetailPage> createState() => _GroupMemberDetailPageState();
}

class _GroupMemberDetailPageState extends State<GroupMemberDetailPage> {
  GroupMembersInfo? _member;

  bool get _isOwner => widget.selfMember?.roleLevel == GroupRoleLevel.owner;
  bool get _canModerate =>
      _isOwner || widget.selfMember?.roleLevel == GroupRoleLevel.admin;
  bool get _isSelf => widget.userId == OpenIM.iMManager.userID;

  @override
  void initState() {
    super.initState();
    _member = widget.member;
  }

  Future<void> _setMuteSeconds(int seconds) async {
    final String gid = widget.group?.groupID ?? _member?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.groupManager.changeGroupMemberMute(
        groupID: gid,
        userID: widget.userId,
        seconds: seconds,
      );
      await FlutterToastPro.success(seconds == 0 ? '已解除禁言' : '已设置禁言');
    } on Object catch (error) {
      await FlutterToastPro.error('禁言设置失败：$error');
    }
  }

  Future<void> _toggleAdmin() async {
    final String gid = widget.group?.groupID ?? _member?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    final bool currentlyAdmin = _member?.roleLevel == GroupRoleLevel.admin;
    try {
      await OpenIM.iMManager.groupManager.setGroupMemberInfo(
        groupMembersInfo: SetGroupMemberInfo(
          groupID: gid,
          userID: widget.userId,
          roleLevel: currentlyAdmin
              ? GroupRoleLevel.member.value
              : GroupRoleLevel.admin.value,
        ),
      );
      await FlutterToastPro.success(currentlyAdmin ? '已撤销管理员' : '已设为管理员');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('操作失败：$error');
    }
  }

  Future<void> _kick() async {
    final String gid = widget.group?.groupID ?? _member?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.groupManager.kickGroupMember(
        groupID: gid,
        userIDList: <String>[widget.userId],
      );
      await FlutterToastPro.success('已移出群聊');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('移出失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final ThemeData theme = Theme.of(context);
    final String name = _member?.nickname ?? widget.userId;
    final bool isAdmin = _member?.roleLevel == GroupRoleLevel.admin;
    final bool targetIsOwner = _member?.roleLevel == GroupRoleLevel.owner;

    return Scaffold(
      appBar: AppBar(title: const Text('群成员管理')),
      body: ListView(
        children: <Widget>[
          Container(
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.all(18),
            child: Row(
              children: <Widget>[
                CachedAvatar(
                  imageUrl: _member?.faceURL,
                  fallbackName: name,
                  size: 56,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${widget.userId}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => router.pushNamedAndRemoveUntil(
                    AppRoutes.chatContactProfile(
                      widget.conversationId,
                      widget.userId,
                    ),
                    (AdaptiveRouteMatch m) =>
                        m.matchedLocation ==
                        AppRoutes.groupMemberDetail(
                          widget.conversationId,
                          widget.userId,
                        ),
                  ),
                  child: const Text('详细资料'),
                ),
              ],
            ),
          ),
          if (_canModerate && !_isSelf && !targetIsOwner) ...<Widget>[
            const SizedBox(height: 12),
            if (_isOwner)
              SwitchListTile(
                tileColor: theme.colorScheme.surface,
                title: const Text('设为群管理员'),
                value: isAdmin,
                onChanged: (bool _) => _toggleAdmin(),
              ),
            const Divider(height: 1),
            ListTile(
              tileColor: theme.colorScheme.surface,
              title: const Text('设置单人禁言时长'),
              subtitle: const Text('支持 10 分钟 / 1 小时 / 12 小时 / 1 天 / 解除禁言'),
              trailing: PopupMenuButton<int>(
                onSelected: _setMuteSeconds,
                itemBuilder: (BuildContext _) => const <PopupMenuEntry<int>>[
                  PopupMenuItem<int>(value: 600, child: Text('禁言 10 分钟')),
                  PopupMenuItem<int>(value: 3600, child: Text('禁言 1 小时')),
                  PopupMenuItem<int>(value: 43200, child: Text('禁言 12 小时')),
                  PopupMenuItem<int>(value: 86400, child: Text('禁言 1 天')),
                  PopupMenuItem<int>(value: 0, child: Text('解除禁言')),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger,
                ),
                onPressed: _kick,
                child: const Text('移出群聊'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
