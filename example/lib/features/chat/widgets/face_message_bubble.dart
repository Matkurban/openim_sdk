import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_animated_svg/xue_hua_animated_svg.dart';

/// 自定义动画表情气泡（基于 `xue_hua_animated_svg` 渲染矢量动效贴纸）。
///
/// Animated SVG custom face / sticker message bubble.
class FaceMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建动画表情气泡。
  const FaceMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final String assetPath =
        (message.faceElem?.data ?? '').startsWith('assets/svg/')
        ? message.faceElem!.data!
        : 'assets/svg/sticker_smile.svg';
    return SizedBox(
      width: 96,
      height: 96,
      child: AnimatedSvgPicture.asset(assetPath),
    );
  }
}
