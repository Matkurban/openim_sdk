import 'package:chat_context_menu/chat_context_menu.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/message_summary_parser.dart';
import '../../../shared/widgets/cached_avatar.dart';
import 'at_text_message_bubble.dart';
import 'call_signal_bubble.dart';
import 'card_message_bubble.dart';
import 'conference_message_bubble.dart';
import 'custom_message_bubble.dart';
import 'face_message_bubble.dart';
import 'file_message_bubble.dart';
import 'group_announcement_bubble.dart';
import 'image_message_bubble.dart';
import 'location_message_bubble.dart';
import 'meeting_notice_bubble.dart';
import 'merge_message_bubble.dart';
import 'oa_notification_bubble.dart';
import 'quote_message_bubble.dart';
import 'red_packet_message_bubble.dart';
import 'system_notice_bubble.dart';
import 'text_message_bubble.dart';
import 'video_message_bubble.dart';
import 'voice_message_bubble.dart';

/// 统一消息气泡外框（分发全类型气泡 + 移动端长按 / 桌面端右键 `chat_context_menu` 操作面板）。
///
/// Unified message bubble shell dispatching all OpenIM message types with Apple styling.
class MessageBubbleShell extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 所属会话 ID。
  final String conversationId;

  /// 是否为群聊。
  final bool isGroup;

  /// 是否处于多选模式。
  final bool multiSelectMode;

  /// 多选模式下是否被选中。
  final bool selected;

  /// 切换选中回调。
  final VoidCallback onToggleSelect;

  /// 复制消息回调。
  final VoidCallback onCopy;

  /// 回复/引用回调。
  final VoidCallback onReply;

  /// 转发回调。
  final VoidCallback onForward;

  /// 撤回回调。
  final VoidCallback onRevoke;

  /// 收藏回调。
  final VoidCallback onFavorite;

  /// 进入多选回调。
  final VoidCallback onEnterMultiSelect;

  /// 保存到本地回调。
  final VoidCallback onSaveLocal;

  /// 外部分享回调。
  final VoidCallback onExternalShare;

  /// 删除回调。
  final VoidCallback onDelete;

  /// 创建消息气泡外框。
  const MessageBubbleShell({
    super.key,
    required this.message,
    required this.conversationId,
    required this.isGroup,
    required this.multiSelectMode,
    required this.selected,
    required this.onToggleSelect,
    required this.onCopy,
    required this.onReply,
    required this.onForward,
    required this.onRevoke,
    required this.onFavorite,
    required this.onEnterMultiSelect,
    required this.onSaveLocal,
    required this.onExternalShare,
    required this.onDelete,
  });

  bool _isSystemMessage() {
    final int code = message.contentType?.value ?? 0;
    return code >= 1000 ||
        message.contentType == MessageType.redPacketGrabNotify ||
        message.contentType == MessageType.revokeMessageNotification;
  }

  bool _usesRawCard() {
    return message.contentType == MessageType.picture ||
        message.contentType == MessageType.video ||
        message.contentType == MessageType.customFace ||
        message.contentType == MessageType.redPacket ||
        message.contentType == MessageType.file ||
        message.contentType == MessageType.card ||
        message.contentType == MessageType.location ||
        message.contentType == MessageType.merger;
  }

  @override
  Widget build(BuildContext context) {
    if (message.contentType == MessageType.oaNotification) {
      return OaNotificationBubble(message: message);
    }
    if (message.contentType ==
        MessageType.groupInfoSetAnnouncementNotification) {
      return GroupAnnouncementBubble(message: message);
    }
    if (_isSystemMessage()) {
      return SystemNoticeBubble(message: message);
    }

    final bool isSelf = message.sendID == OpenIM.iMManager.userID;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isBurn = MessageSummaryParser.isBurnAfterReading(message);
    final Color bubbleColor = isSelf
        ? (isDark ? AppColors.selfBubbleDark : AppColors.selfBubbleLight)
        : (isDark ? AppColors.peerBubbleDark : AppColors.peerBubbleLight);
    final Color hairline = isDark ? AppColors.hairlineDark : AppColors.hairline;
    final AdaptiveRouter router = AdaptiveRouter.of(context);

    return InkWell(
      onTap: multiSelectMode ? onToggleSelect : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: isSelf
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: <Widget>[
            if (multiSelectMode)
              Padding(
                padding: const EdgeInsets.only(right: 6, top: 8),
                child: Checkbox(
                  value: selected,
                  onChanged: (bool? _) => onToggleSelect(),
                ),
              ),
            if (!isSelf) ...<Widget>[
              GestureDetector(
                onTap: () {
                  final String uid = message.sendID ?? '';
                  if (uid.isNotEmpty) {
                    router.pushNamed(AppRoutes.contactProfile(uid));
                  }
                },
                child: CachedAvatar(
                  imageUrl: message.senderFaceUrl,
                  fallbackName: message.senderNickname ?? message.sendID,
                  size: 40,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isSelf
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  if (isGroup && !isSelf)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 2),
                      child: Text(
                        message.senderNickname ?? message.sendID ?? '',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (isSelf && message.status == MessageStatus.sending)
                        const Padding(
                          padding: EdgeInsets.only(right: 6, bottom: 8),
                          child: SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      if (isSelf && message.status == MessageStatus.failed)
                        const Padding(
                          padding: EdgeInsets.only(right: 6, bottom: 6),
                          child: Icon(
                            Icons.error_outline,
                            color: AppColors.danger,
                            size: 18,
                          ),
                        ),
                      if (isBurn)
                        Padding(
                          padding: const EdgeInsets.only(right: 6, bottom: 8),
                          child: Icon(
                            Icons.local_fire_department_outlined,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      Flexible(
                        child: ChatContextMenuWrapper(
                          barrierColor: Colors.black26,
                          excludeAnchorFromBarrier: true,
                          barrierAnchorBorderRadius: BorderRadius.circular(14),
                          widgetBuilder:
                              (
                                BuildContext _,
                                VoidCallback showMenu,
                                VoidCallback _,
                              ) {
                                return GestureDetector(
                                  onLongPress: multiSelectMode
                                      ? null
                                      : showMenu,
                                  onSecondaryTap: multiSelectMode
                                      ? null
                                      : showMenu,
                                  child: _usesRawCard()
                                      ? _RawCardContainer(
                                          isCardStyled:
                                              message.contentType ==
                                                  MessageType.file ||
                                              message.contentType ==
                                                  MessageType.card ||
                                              message.contentType ==
                                                  MessageType.location ||
                                              message.contentType ==
                                                  MessageType.merger,
                                          backgroundColor: isDark
                                              ? AppColors.surfaceTile1
                                              : AppColors.canvas,
                                          hairline: hairline,
                                          child: _BubbleContentDispatcher(
                                            message: message,
                                            conversationId: conversationId,
                                            isSelf: isSelf,
                                          ),
                                        )
                                      : Container(
                                          constraints: const BoxConstraints(
                                            maxWidth: 290,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: bubbleColor,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: isSelf
                                                ? null
                                                : Border.all(
                                                    color: hairline,
                                                    width: 1,
                                                  ),
                                          ),
                                          child: _BubbleContentDispatcher(
                                            message: message,
                                            conversationId: conversationId,
                                            isSelf: isSelf,
                                          ),
                                        ),
                                );
                              },
                          menuBuilder: (BuildContext _, VoidCallback hideMenu) {
                            return _MessageActionMenu(
                              isSelf: isSelf,
                              onCopy: () {
                                hideMenu();
                                onCopy();
                              },
                              onReply: () {
                                hideMenu();
                                onReply();
                              },
                              onForward: () {
                                hideMenu();
                                onForward();
                              },
                              onRevoke: () {
                                hideMenu();
                                onRevoke();
                              },
                              onFavorite: () {
                                hideMenu();
                                onFavorite();
                              },
                              onMultiSelect: () {
                                hideMenu();
                                onEnterMultiSelect();
                              },
                              onSave: () {
                                hideMenu();
                                onSaveLocal();
                              },
                              onShare: () {
                                hideMenu();
                                onExternalShare();
                              },
                              onReport: () {
                                hideMenu();
                                router.pushNamed(
                                  AppRoutes.report,
                                  arguments: <String, String>{
                                    'type': 'message',
                                    'targetId': message.clientMsgID ?? '',
                                  },
                                );
                              },
                              onDelete: () {
                                hideMenu();
                                onDelete();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelf) ...<Widget>[
              const SizedBox(width: 8),
              CachedAvatar(
                imageUrl: message.senderFaceUrl,
                fallbackName: message.senderNickname ?? message.sendID,
                size: 40,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RawCardContainer extends StatelessWidget {
  final bool isCardStyled;
  final Color backgroundColor;
  final Color hairline;
  final Widget child;

  const _RawCardContainer({
    required this.isCardStyled,
    required this.backgroundColor,
    required this.hairline,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCardStyled) {
      return child;
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hairline, width: 1),
      ),
      child: child,
    );
  }
}

class _BubbleContentDispatcher extends StatelessWidget {
  final Message message;
  final String conversationId;
  final bool isSelf;

  const _BubbleContentDispatcher({
    required this.message,
    required this.conversationId,
    required this.isSelf,
  });

  @override
  Widget build(BuildContext context) {
    switch (message.contentType) {
      case MessageType.atText:
        return AtTextMessageBubble(message: message, isSelf: isSelf);
      case MessageType.picture:
        return ImageMessageBubble(message: message);
      case MessageType.voice:
        return VoiceMessageBubble(message: message, isSelf: isSelf);
      case MessageType.video:
        return VideoMessageBubble(message: message);
      case MessageType.file:
        return FileMessageBubble(message: message);
      case MessageType.quote:
        return QuoteMessageBubble(message: message, isSelf: isSelf);
      case MessageType.merger:
        return MergeMessageBubble(
          message: message,
          conversationId: conversationId,
        );
      case MessageType.card:
        return CardMessageBubble(message: message);
      case MessageType.location:
        return LocationMessageBubble(message: message);
      case MessageType.customFace:
        return FaceMessageBubble(message: message);
      case MessageType.redPacket:
        return RedPacketMessageBubble(
          message: message,
          conversationId: conversationId,
        );
      case MessageType.callSignal:
        return CallSignalBubble(message: message, isSelf: isSelf);
      case MessageType.conference:
        return ConferenceMessageBubble(message: message, isSelf: isSelf);
      case MessageType.meetingReminder:
      case MessageType.meetingScheduleNotify:
        return MeetingNoticeBubble(message: message, isSelf: isSelf);
      case MessageType.custom:
      case MessageType.customMsgNotTriggerConversation:
      case MessageType.customMsgOnlineOnly:
        return CustomMessageBubble(message: message, isSelf: isSelf);
      default:
        return TextMessageBubble(message: message, isSelf: isSelf);
    }
  }
}

class _MessageActionMenu extends StatelessWidget {
  final bool isSelf;
  final VoidCallback onCopy;
  final VoidCallback onReply;
  final VoidCallback onForward;
  final VoidCallback onRevoke;
  final VoidCallback onFavorite;
  final VoidCallback onMultiSelect;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onReport;
  final VoidCallback onDelete;

  const _MessageActionMenu({
    required this.isSelf,
    required this.onCopy,
    required this.onReply,
    required this.onForward,
    required this.onRevoke,
    required this.onFavorite,
    required this.onMultiSelect,
    required this.onSave,
    required this.onShare,
    required this.onReport,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceTile1,
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: <Widget>[
              _MenuChip(icon: Icons.copy, label: '复制', onTap: onCopy),
              _MenuChip(icon: Icons.reply, label: '回复', onTap: onReply),
              _MenuChip(icon: Icons.forward, label: '转发', onTap: onForward),
              _MenuChip(
                icon: Icons.star_border,
                label: '收藏',
                onTap: onFavorite,
              ),
              _MenuChip(
                icon: Icons.checklist,
                label: '多选',
                onTap: onMultiSelect,
              ),
              _MenuChip(icon: Icons.download, label: '保存', onTap: onSave),
              _MenuChip(icon: Icons.share, label: '分享', onTap: onShare),
              if (isSelf)
                _MenuChip(icon: Icons.undo, label: '撤回', onTap: onRevoke),
              _MenuChip(
                icon: Icons.flag_outlined,
                label: '举报',
                onTap: onReport,
              ),
              _MenuChip(
                icon: Icons.delete_outline,
                label: '删除',
                color: AppColors.danger,
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.bodyOnDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 18, color: color),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: color),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
