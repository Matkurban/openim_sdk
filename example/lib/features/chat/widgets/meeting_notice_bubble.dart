import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/date_time_formatter.dart';
import '../../../core/utils/message_summary_parser.dart';

/// 会议开始提醒（128）与日程变更通知（129）卡片气泡。
///
/// Meeting reminder (`128`) and schedule change notification (`129`) bubble.
class MeetingNoticeBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 是否为我方发送。
  final bool isSelf;

  /// 创建会议提醒/日程通知气泡。
  const MeetingNoticeBubble({
    super.key,
    required this.message,
    required this.isSelf,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isReminder = message.contentType == MessageType.meetingReminder;
    final Map<String, dynamic> data =
        MessageSummaryParser.parseStructuredPayload(message);
    final String title =
        (data['title'] as String?) ??
        (data['meetingName'] as String?) ??
        (isReminder ? '预约会议提醒' : '会议日程通知');
    final int startTime = (data['startTime'] as num?)?.toInt() ?? 0;
    final String summary = isReminder
        ? MessageSummaryParser.formatMeetingReminderSummary(message)
        : MessageSummaryParser.formatMeetingScheduleSummary(message);
    final Color fg = isSelf
        ? AppColors.bodyOnDark
        : theme.colorScheme.onSurface;
    final Color subtle = isSelf
        ? AppColors.bodyOnDark.withValues(alpha: 0.8)
        : theme.hintColor;

    return SizedBox(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                isReminder ? Icons.alarm : Icons.event_note_outlined,
                size: 18,
                color: fg,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(summary, style: TextStyle(fontSize: 13, color: subtle)),
          if (startTime > 0) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              '开始时间：${DateTimeFormatter.formatFullDateTime(startTime)}',
              style: TextStyle(fontSize: 12, color: subtle),
            ),
          ],
        ],
      ),
    );
  }
}
