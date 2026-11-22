import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/message_summary_parser.dart';

/// 群公告变更卡片（`MessageType.groupInfoSetAnnouncementNotification` 1519）。
///
/// Dedicated group announcement card inside chat timeline.
class GroupAnnouncementBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建群公告卡片。
  const GroupAnnouncementBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, dynamic> detail =
        MessageSummaryParser.parseStructuredPayload(message);
    final Object? groupRaw = detail['group'];
    final String content = groupRaw is Map<String, dynamic>
        ? ((groupRaw['notification'] as String?)?.trim() ?? '')
        : '';
    final String fallback = MessageSummaryParser.formatNotification(
      message,
      selfUserId: OpenIM.iMManager.userID,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.notifications_active_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '群公告',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                content.isNotEmpty ? content : fallback,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
