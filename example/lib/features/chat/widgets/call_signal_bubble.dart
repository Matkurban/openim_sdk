import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/message_summary_parser.dart';

/// 音视频通话信令消息气泡（区分音视频、主被叫状态与通话时长）。
///
/// Audio/video call signaling bubble displaying call type, direction, and duration.
class CallSignalBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 是否为我方发送。
  final bool isSelf;

  /// 创建通话信令气泡。
  const CallSignalBubble({
    super.key,
    required this.message,
    this.isSelf = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVideo = message.callSignalElem?.callType == CallType.video;
    final String label = MessageSummaryParser.formatCallSignal(
      message,
      selfUserId: OpenIM.iMManager.userID,
    );
    final Color fg = isSelf
        ? AppColors.bodyOnDark
        : Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          isVideo ? Icons.videocam_outlined : Icons.call_outlined,
          size: 18,
          color: fg,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(label, style: TextStyle(fontSize: 15, color: fg)),
        ),
      ],
    );
  }
}
