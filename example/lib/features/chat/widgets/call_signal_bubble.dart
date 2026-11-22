import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

/// 音视频通话信令消息气泡。
///
/// Audio/video call signaling log bubble.
class CallSignalBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建通话信令气泡。
  const CallSignalBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final CallSignalElem? signal = message.callSignalElem;
    final bool isVideo = signal?.callType == CallType.video;
    final String label = switch (signal?.callSignalType) {
      CallSignalType.invite => isVideo ? '发起视频通话' : '发起语音通话',
      CallSignalType.accept => '已接通通话',
      CallSignalType.reject => '已拒绝通话',
      CallSignalType.cancel => '已取消通话',
      CallSignalType.hungup => '通话已结束',
      CallSignalType.noResponse => '对方无应答',
      null => isVideo ? '视频通话' : '语音通话',
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(isVideo ? Icons.videocam_outlined : Icons.call_outlined, size: 18),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
