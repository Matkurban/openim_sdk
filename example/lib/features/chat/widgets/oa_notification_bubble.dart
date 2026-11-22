import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/message_summary_parser.dart';

/// OA 系统通知卡片（`MessageType.oaNotification` 1400）。
///
/// Structured OA / system announcement card bubble.
class OaNotificationBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建 OA 系统通知卡片。
  const OaNotificationBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, dynamic> detail =
        MessageSummaryParser.parseStructuredPayload(message);
    final String title =
        (detail['notificationName'] as String?)?.trim().isNotEmpty == true
        ? (detail['notificationName'] as String).trim()
        : '系统通知';
    final String body = (detail['text'] as String?)?.trim().isNotEmpty == true
        ? (detail['text'] as String).trim()
        : (message.notificationElem?.defaultTips ?? '');
    final String externalUrl = (detail['externalUrl'] as String?)?.trim() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.campaign_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (body.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Text(body, style: theme.textTheme.bodyMedium),
              ],
              if (externalUrl.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  externalUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
