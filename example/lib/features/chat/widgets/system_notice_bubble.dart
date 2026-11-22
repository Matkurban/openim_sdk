import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import '../../../core/utils/message_summary_parser.dart';

/// 系统通知、群事件、撤回与红包领取提示条（居中胶囊展示）。
///
/// Centered pill notification banner covering all 20+ system, group, revoke, and red-packet events.
class SystemNoticeBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建系统通知提示条。
  const SystemNoticeBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final String selfId = OpenIM.iMManager.userID;
    final String label = message.contentType == MessageType.redPacketGrabNotify
        ? MessageSummaryParser.formatRedPacketGrab(message, selfUserId: selfId)
        : MessageSummaryParser.formatNotification(message, selfUserId: selfId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Theme.of(context).hintColor),
          ),
        ),
      ),
    );
  }
}
