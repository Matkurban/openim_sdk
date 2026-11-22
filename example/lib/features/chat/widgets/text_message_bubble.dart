import 'package:chat_context_menu/chat_context_menu.dart';
import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';

import '../../../app/theme/app_colors.dart';

/// 文本 / 富文本 / Markdown 消息气泡（集成 `ChatSelectableText` 划词复制）。
///
/// Plain text, rich text, and Markdown message bubble with `ChatSelectableText`.
class TextMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 是否为我方发送的消息。
  final bool isSelf;

  /// 创建文本消息气泡。
  const TextMessageBubble({
    super.key,
    required this.message,
    required this.isSelf,
  });

  String _extractText() {
    switch (message.contentType) {
      case MessageType.advancedText:
        return message.advancedTextElem?.text ?? '';
      case MessageType.markdownText:
        return message.textElem?.content ??
            message.advancedTextElem?.text ??
            '';
      default:
        return message.textElem?.content ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String content = _extractText();
    final Color textColor = isSelf
        ? AppColors.bodyOnDark
        : Theme.of(context).colorScheme.onSurface;
    return ChatSelectableText(
      content,
      useRootOverlay: true,
      style: TextStyle(
        fontSize: 16,
        height: 1.44,
        letterSpacing: -0.32,
        color: textColor,
      ),
      menuBuilder:
          (
            BuildContext ctx,
            String selectedText,
            VoidCallback hideMenu,
            VoidCallback selectAll,
          ) {
            return Material(
              color: AppColors.surfaceTile1,
              elevation: 0,
              borderRadius: BorderRadius.circular(11),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      await XueHuaNaviteClipboard.instance.writeText(
                        selectedText,
                      );
                      hideMenu();
                      await FlutterToastPro.success('已复制选中文本');
                    },
                    child: const Text(
                      '复制',
                      style: TextStyle(color: AppColors.bodyOnDark),
                    ),
                  ),
                  TextButton(
                    onPressed: selectAll,
                    child: const Text(
                      '全选',
                      style: TextStyle(color: AppColors.bodyOnDark),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}
