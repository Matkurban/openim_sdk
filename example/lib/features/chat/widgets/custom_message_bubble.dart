import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

/// 自定义消息 / 会议卡片消息气泡。
///
/// Custom / conference / meeting message bubble.
class CustomMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建自定义消息气泡。
  const CustomMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final String title =
        message.customElem?.description ??
        message.customElem?.data ??
        '[自定义消息]';
    return SizedBox(
      width: 210,
      child: Row(
        children: <Widget>[
          const Icon(Icons.extension_outlined, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title, maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
