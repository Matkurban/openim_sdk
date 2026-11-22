import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

/// 系统通知与撤回提示条（居中灰色小字展示）。
///
/// Centered gray system / revoke notification banner inside chat timeline.
class SystemNoticeBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建系统通知提示条。
  const SystemNoticeBubble({super.key, required this.message});

  String _label() {
    if (message.contentType == MessageType.revokeMessageNotification) {
      return '${message.senderNickname ?? '对方'} 撤回了一条消息';
    }
    if (message.contentType == MessageType.redPacketGrabNotify) {
      return '有人领取了红包';
    }
    return message.notificationElem?.defaultTips ??
        message.textElem?.content ??
        '系统通知';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _label(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: Theme.of(context).hintColor),
          ),
        ),
      ),
    );
  }
}
