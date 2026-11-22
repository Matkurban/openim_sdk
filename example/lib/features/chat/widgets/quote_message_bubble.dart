import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

/// 引用回复消息气泡。
///
/// Quoted-reply message bubble showing original message preview and reply text.
class QuoteMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 是否为我方发送。
  final bool isSelf;

  /// 创建引用消息气泡。
  const QuoteMessageBubble({
    super.key,
    required this.message,
    required this.isSelf,
  });

  @override
  Widget build(BuildContext context) {
    final QuoteElem? quote = message.quoteElem;
    final Message? quotedMsg = quote?.quoteMessage;
    final String quotedSummary = quotedMsg == null
        ? '引用消息'
        : '${quotedMsg.senderNickname ?? quotedMsg.sendID ?? ''}: '
              '${quotedMsg.textElem?.content ?? '[${quotedMsg.contentType?.name ?? '消息'}]'}';
    final Color textColor =
        isSelf && Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF191919)
        : Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          quote?.text ?? '',
          style: TextStyle(fontSize: 15, height: 1.4, color: textColor),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            quotedSummary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
          ),
        ),
      ],
    );
  }
}
