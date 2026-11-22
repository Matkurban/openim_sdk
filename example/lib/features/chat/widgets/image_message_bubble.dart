import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_cache_manager/xue_hua_navite_cache_manager.dart';

import '../../../app/router/app_routes.dart';

/// 图片消息气泡（直接使用 `CachedNetworkImage.borderRadius`，点击进入全屏预览）。
///
/// Image message bubble using `CachedNetworkImage.borderRadius` directly.
class ImageMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建图片消息气泡。
  const ImageMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final String thumbUrl =
        message.pictureElem?.snapshotPicture?.url ??
        message.pictureElem?.sourcePicture?.url ??
        '';
    final String fullUrl = message.pictureElem?.sourcePicture?.url ?? thumbUrl;

    return GestureDetector(
      onTap: fullUrl.isEmpty
          ? null
          : () => AdaptiveRouter.of(context).pushNamed(
              AppRoutes.imagePreview,
              arguments: <String, Object>{
                'urls': <String>[fullUrl],
                'index': 0,
              },
            ),
      child: thumbUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: thumbUrl,
              tag: 'chat_images',
              width: 180,
              height: 180,
              memCacheWidth: 360,
              borderRadius: BorderRadius.circular(8),
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext _, String _, Object _, StackTrace? _) =>
                      const SizedBox(
                        width: 140,
                        height: 120,
                        child: Center(child: Icon(Icons.broken_image_outlined)),
                      ),
            )
          : Container(
              width: 140,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Icon(Icons.image_outlined, size: 36)),
            ),
    );
  }
}
