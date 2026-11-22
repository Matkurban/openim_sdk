import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/message_summary_parser.dart';

/// 引用回复消息气泡（复用统一消息摘要解析器解析任意类型被引用消息）。
///
/// Quoted-reply message bubble showing full summary for any quoted message type.
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
    final ThemeData theme = Theme.of(context);
    final QuoteElem? quote = message.quoteElem;
    final Message? quotedMsg = quote?.quoteMessage;
    final String quotedSummary = quotedMsg == null
        ? '引用消息'
        : '${quotedMsg.senderNickname ?? quotedMsg.sendID ?? ''}: '
              '${MessageSummaryParser.summarizeMessage(quotedMsg, selfUserId: OpenIM.iMManager.userID)}';
    final Color textColor = isSelf
        ? AppColors.bodyOnDark
        : theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          quote?.text ?? '',
          style: TextStyle(
            fontSize: 16,
            height: 1.44,
            letterSpacing: -0.32,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelf
                ? Colors.white.withValues(alpha: 0.16)
                : theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            quotedSummary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: isSelf
                  ? Colors.white.withValues(alpha: 0.85)
                  : theme.hintColor,
            ),
          ),
        ),
      ],
    );
  }
}
