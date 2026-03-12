import 'package:flutter/material.dart';
import 'package:openim_sdk/openim_sdk.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final String content;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.content,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) _buildAvatar(context),
            if (!isMe) const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isMe && message.senderNickname != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2, left: 4),
                      child: Text(
                        message.senderNickname!,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ),
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                    ),
                    child: _buildContent(context, colorScheme),
                  ),
                  if (message.status == MessageStatus.failed)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(Icons.error_outline, size: 14, color: Colors.red[400]),
                    ),
                ],
              ),
            ),
            if (isMe) const SizedBox(width: 8),
            if (isMe) _buildAvatar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final url = message.senderFaceUrl;
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(radius: 18, backgroundImage: NetworkImage(url));
    }
    return CircleAvatar(
      radius: 18,
      child: Text(
        (message.senderNickname ?? message.sendID ?? '?')[0].toUpperCase(),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme colorScheme) {
    final textColor = isMe ? colorScheme.onPrimary : colorScheme.onSurface;

    // Special rendering for different message types
    switch (message.contentType) {
      case MessageType.picture:
        return _buildImageContent();
      case MessageType.location:
        return _buildLocationContent(textColor);
      case MessageType.card:
        return _buildCardContent(textColor);
      case MessageType.voice:
        return _buildVoiceContent(textColor);
      case MessageType.file:
        return _buildFileContent(textColor);
      default:
        return Text(content, style: TextStyle(color: textColor, fontSize: 15));
    }
  }

  Widget _buildImageContent() {
    final url = message.pictureElem?.sourcePicture?.url ?? message.pictureElem?.bigPicture?.url;
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          width: 200,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const Icon(Icons.broken_image, size: 48),
        ),
      );
    }
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(Icons.image, size: 20), SizedBox(width: 4), Text('[图片]')],
    );
  }

  Widget _buildLocationContent(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on, size: 20, color: textColor),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            message.locationElem?.description ?? '位置',
            style: TextStyle(color: textColor, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.contact_page, size: 20, color: textColor),
        const SizedBox(width: 4),
        Text('[名片]', style: TextStyle(color: textColor, fontSize: 15)),
      ],
    );
  }

  Widget _buildVoiceContent(Color textColor) {
    final dur = message.soundElem?.duration ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.mic, size: 20, color: textColor),
        const SizedBox(width: 4),
        Text('${dur}s', style: TextStyle(color: textColor, fontSize: 15)),
      ],
    );
  }

  Widget _buildFileContent(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.insert_drive_file, size: 20, color: textColor),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            message.fileElem?.fileName ?? '文件',
            style: TextStyle(color: textColor, fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
