import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/message_summary_parser.dart';

/// `@` 提及消息气泡（将 `@userID` 解析为高亮 `@昵称`/`@所有人`，并支持附带引用预览）。
///
/// `@`-mention message bubble resolving user IDs to highlighted display names with optional quote block.
class AtTextMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 是否为我方发送。
  final bool isSelf;

  /// 创建 `@` 提及消息气泡。
  const AtTextMessageBubble({
    super.key,
    required this.message,
    required this.isSelf,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final AtTextElem? elem = message.atTextElem;
    final String resolved = MessageSummaryParser.resolveAtText(elem);
    final Color baseColor = isSelf
        ? AppColors.bodyOnDark
        : theme.colorScheme.onSurface;
    final Color mentionColor = isSelf
        ? AppColors.bodyOnDark
        : (isDark ? AppColors.primaryOnDark : AppColors.primary);

    final List<TextSpan> spans = <TextSpan>[];
    final RegExp mentionPattern = RegExp(r'@[^\s@]+');
    int cursor = 0;
    for (final RegExpMatch match in mentionPattern.allMatches(resolved)) {
      if (match.start > cursor) {
        spans.add(
          TextSpan(
            text: resolved.substring(cursor, match.start),
            style: TextStyle(color: baseColor),
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(
            color: mentionColor,
            fontWeight: FontWeight.w600,
            decoration: isSelf ? TextDecoration.underline : null,
            decorationColor: isSelf
                ? AppColors.bodyOnDark.withValues(alpha: 0.7)
                : null,
          ),
        ),
      );
      cursor = match.end;
    }
    if (cursor < resolved.length) {
      spans.add(
        TextSpan(
          text: resolved.substring(cursor),
          style: TextStyle(color: baseColor),
        ),
      );
    }

    final Message? quoted = elem?.quoteMessage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 16,
              height: 1.44,
              letterSpacing: -0.32,
            ),
            children: spans,
          ),
        ),
        if (quoted != null) ...<Widget>[
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
              '${quoted.senderNickname ?? quoted.sendID ?? ''}: '
              '${MessageSummaryParser.summarizeMessage(quoted, selfUserId: OpenIM.iMManager.userID)}',
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
      ],
    );
  }
}
