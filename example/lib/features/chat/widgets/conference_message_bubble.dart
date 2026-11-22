import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/message_summary_parser.dart';

/// 会议邀请卡片气泡（`MessageType.conference` 127，支持展示会议状态与一键复制会议号）。
///
/// Conference invitation card bubble with live/ended state and one-tap room ID copy.
class ConferenceMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 是否为我方发送。
  final bool isSelf;

  /// 创建会议邀请卡片气泡。
  const ConferenceMessageBubble({
    super.key,
    required this.message,
    required this.isSelf,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<String, dynamic> data =
        MessageSummaryParser.parseStructuredPayload(message);
    final String title =
        (data['title'] as String?) ??
        (data['meetingName'] as String?) ??
        '视频会议';
    final String roomId =
        (data['roomId'] as String?) ??
        (data['roomID'] as String?) ??
        (data['meetingID'] as String?) ??
        '';
    final bool isEnded = data['isEnded'] == true || data['status'] == 'ended';
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
                Icons.groups_outlined,
                size: 20,
                color: isEnded ? subtle : fg,
              ),
              const SizedBox(width: 8),
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
          Text(
            isEnded ? '会议已结束' : '会议进行中',
            style: TextStyle(fontSize: 13, color: subtle),
          ),
          if (roomId.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              '会议号：$roomId',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: subtle),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () async {
                await XueHuaNaviteClipboard.instance.writeText(roomId);
                await FlutterToastPro.success('已复制会议号');
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                foregroundColor: fg,
                side: BorderSide(color: fg.withValues(alpha: 0.45)),
              ),
              child: const Text('复制会议号', style: TextStyle(fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}
