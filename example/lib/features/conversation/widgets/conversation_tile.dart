import 'package:chat_context_menu/chat_context_menu.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../../shared/widgets/cached_avatar.dart';
import '../../../shared/widgets/unread_badge.dart';
import '../conversation_controller.dart';

/// 单条会话列表项（支持移动端长按与桌面端右键弹出 `chat_context_menu` 竖向操作面板）。
///
/// Conversation list tile with long-press and desktop right-click vertical context menu.
class ConversationTile extends StatelessWidget {
  /// 会话模型。
  final ConversationInfo conversation;

  /// 点击进入聊天页回调。
  final VoidCallback onTap;

  /// 置顶/取消置顶回调。
  final VoidCallback onTogglePin;

  /// 免打扰/取消免打扰回调。
  final VoidCallback onToggleMute;

  /// 标为已读回调。
  final VoidCallback onMarkRead;

  /// 隐藏会话回调。
  final VoidCallback onHide;

  /// 清空聊天记录回调。
  final VoidCallback onClearHistory;

  /// 删除会话回调。
  final VoidCallback onDelete;

  /// 创建会话列表项。
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onTogglePin,
    required this.onToggleMute,
    required this.onMarkRead,
    required this.onHide,
    required this.onClearHistory,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isPinned = conversation.isPinned ?? false;
    final bool isMuted = conversation.recvMsgOpt == ReceiveMessageOpt.notNotify;
    final String summary = ConversationController.formatLatestSummary(
      conversation,
    );
    final String timeStr = DateTimeFormatter.formatConversationTime(
      conversation.latestMsgSendTime,
    );

    return ChatContextMenuWrapper(
      barrierColor: Colors.black26,
      excludeAnchorFromBarrier: true,
      widgetBuilder: (BuildContext _, VoidCallback showMenu, VoidCallback _) {
        return Material(
          color: isPinned
              ? theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.45,
                )
              : theme.colorScheme.surface,
          child: InkWell(
            onTap: onTap,
            onLongPress: showMenu,
            onSecondaryTap: showMenu,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: <Widget>[
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      CachedAvatar(
                        imageUrl: conversation.faceURL,
                        fallbackName: conversation.showName,
                        size: 48,
                      ),
                      if (conversation.unreadCount > 0)
                        Positioned(
                          right: -5,
                          top: -5,
                          child: UnreadBadge(
                            count: conversation.unreadCount,
                            dotOnly: isMuted,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                conversation.showName ??
                                    conversation.conversationID,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              timeStr,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                summary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: summary.startsWith('[草稿]')
                                      ? AppColors.danger
                                      : theme.hintColor,
                                ),
                              ),
                            ),
                            if (isMuted)
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.notifications_off_outlined,
                                  size: 14,
                                  color: theme.hintColor,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      menuBuilder: (BuildContext _, VoidCallback hideMenu) {
        return _ConversationVerticalMenu(
          isPinned: isPinned,
          isMuted: isMuted,
          hasUnread: conversation.unreadCount > 0,
          onTogglePin: () {
            hideMenu();
            onTogglePin();
          },
          onToggleMute: () {
            hideMenu();
            onToggleMute();
          },
          onMarkRead: () {
            hideMenu();
            onMarkRead();
          },
          onHide: () {
            hideMenu();
            onHide();
          },
          onClearHistory: () {
            hideMenu();
            onClearHistory();
          },
          onDelete: () {
            hideMenu();
            onDelete();
          },
        );
      },
    );
  }
}

class _ConversationVerticalMenu extends StatelessWidget {
  final bool isPinned;
  final bool isMuted;
  final bool hasUnread;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleMute;
  final VoidCallback onMarkRead;
  final VoidCallback onHide;
  final VoidCallback onClearHistory;
  final VoidCallback onDelete;

  const _ConversationVerticalMenu({
    required this.isPinned,
    required this.isMuted,
    required this.hasUnread,
    required this.onTogglePin,
    required this.onToggleMute,
    required this.onMarkRead,
    required this.onHide,
    required this.onClearHistory,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      elevation: 6,
      borderRadius: BorderRadius.circular(10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 168, maxWidth: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _MenuActionRow(
              icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              label: isPinned ? '取消置顶' : '置顶会话',
              onTap: onTogglePin,
            ),
            _MenuActionRow(
              icon: isMuted
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_off_outlined,
              label: isMuted ? '取消免打扰' : '消息免打扰',
              onTap: onToggleMute,
            ),
            if (hasUnread)
              _MenuActionRow(
                icon: Icons.mark_chat_read_outlined,
                label: '标为已读',
                onTap: onMarkRead,
              ),
            _MenuActionRow(
              icon: Icons.visibility_off_outlined,
              label: '不显示该聊天',
              onTap: onHide,
            ),
            _MenuActionRow(
              icon: Icons.cleaning_services_outlined,
              label: '清空聊天记录',
              onTap: onClearHistory,
            ),
            const Divider(height: 1),
            _MenuActionRow(
              icon: Icons.delete_outline,
              label: '删除该聊天',
              color: AppColors.danger,
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _MenuActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 14, color: color)),
            ),
          ],
        ),
      ),
    );
  }
}
