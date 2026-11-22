import 'package:chat_context_menu/chat_context_menu.dart';
import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';

/// 文本 / `@` 文本 / 富文本消息气泡（集成 `ChatSelectableText` 划词复制）。
///
/// Text, `@`-mention, and rich-text message bubble with `ChatSelectableText`.
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
      case MessageType.atText:
        return message.atTextElem?.text ?? '';
      case MessageType.advancedText:
        return message.advancedTextElem?.text ?? '';
      default:
        return message.textElem?.content ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String content = _extractText();
    final Color textColor =
        isSelf && Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF191919)
        : Theme.of(context).colorScheme.onSurface;
    return ChatSelectableText(
      content,
      useRootOverlay: true,
      style: TextStyle(fontSize: 15, height: 1.4, color: textColor),
      menuBuilder:
          (
            BuildContext ctx,
            String selectedText,
            VoidCallback hideMenu,
            VoidCallback selectAll,
          ) {
            return Material(
              color: const Color(0xFF2C2C2E),
              elevation: 6,
              borderRadius: BorderRadius.circular(8),
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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: selectAll,
                    child: const Text(
                      '全选',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}
