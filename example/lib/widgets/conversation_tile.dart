import 'package:flutter/material.dart';
import 'package:openim_sdk/openim_sdk.dart';

class ConversationTile extends StatelessWidget {
  final ConversationInfo conversation;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isPinned = conversation.isPinned ?? false;

    return Container(
      color: isPinned
          ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
          : null,
      child: ListTile(
        leading: _buildAvatar(),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversation.showName ?? '未知',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            if (conversation.latestMsgSendTime != null && conversation.latestMsgSendTime! > 0)
              Text(
                _formatTime(conversation.latestMsgSendTime!),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            if (conversation.draftText != null && conversation.draftText!.isNotEmpty)
              Text('[草稿] ', style: TextStyle(color: Colors.red[400], fontSize: 13)),
            Expanded(
              child: Text(
                _getLastMsgContent(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
            if (conversation.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      (conversation.recvMsgOpt != null &&
                          conversation.recvMsgOpt != ReceiveMessageOpt.receive)
                      ? Colors.grey
                      : Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  conversation.unreadCount > 99 ? '99+' : '${conversation.unreadCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
          ],
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  Widget _buildAvatar() {
    if (conversation.faceURL != null && conversation.faceURL!.isNotEmpty) {
      return CircleAvatar(backgroundImage: NetworkImage(conversation.faceURL!));
    }
    if (conversation.isGroupChat) {
      return CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: const Icon(Icons.group, color: Colors.blue),
      );
    }
    return CircleAvatar(child: Text((conversation.showName ?? '?')[0].toUpperCase()));
  }

  String _getLastMsgContent() {
    if (conversation.draftText != null && conversation.draftText!.isNotEmpty) {
      return conversation.draftText!;
    }
    final msg = conversation.latestMsg;
    if (msg == null) return '';

    switch (msg.contentType) {
      case MessageType.text:
        return msg.textElem?.content ?? '';
      case MessageType.atText:
        return msg.atTextElem?.text ?? '';
      case MessageType.picture:
        return '[图片]';
      case MessageType.voice:
        return '[语音]';
      case MessageType.video:
        return '[视频]';
      case MessageType.file:
        return '[文件]';
      case MessageType.location:
        return '[位置]';
      case MessageType.card:
        return '[名片]';
      case MessageType.merger:
        return '[聊天记录]';
      case MessageType.quote:
        return msg.quoteElem?.text ?? '[引用消息]';
      case MessageType.custom:
        return '[自定义消息]';
      case MessageType.customFace:
        return '[表情]';
      case MessageType.typing:
        return '对方正在输入...';
      default:
        if (msg.contentType != null && msg.contentType!.value >= 1000) {
          return '[系统通知]';
        }
        return '[消息]';
    }
  }

  String _formatTime(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inHours < 1) return '${diff.inMinutes}分钟前';

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (dt.year == yesterday.year && dt.month == yesterday.month && dt.day == yesterday.day) {
      return '昨天';
    }

    if (dt.year == now.year) {
      return '${dt.month}/${dt.day}';
    }

    return '${dt.year}/${dt.month}/${dt.day}';
  }
}
