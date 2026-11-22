import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/message_summary_parser.dart';

/// 通用自定义消息气泡。
///
/// Generic custom message bubble for extensible `CustomElem` payloads.
class CustomMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 是否为我方发送。
  final bool isSelf;

  /// 创建自定义消息气泡。
  const CustomMessageBubble({
    super.key,
    required this.message,
    this.isSelf = false,
  });

  @override
  Widget build(BuildContext context) {
    final String title = MessageSummaryParser.summarizeMessage(
      message,
      selfUserId: OpenIM.iMManager.userID,
    );
    final Color fg = isSelf
        ? AppColors.bodyOnDark
        : Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: 210,
      child: Row(
        children: <Widget>[
          Icon(Icons.extension_outlined, size: 22, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: fg),
            ),
          ),
        ],
      ),
    );
  }
}
