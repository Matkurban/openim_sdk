import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_cache_manager/xue_hua_navite_cache_manager.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/utils/date_time_formatter.dart';

/// 视频消息气泡（使用 `CachedNetworkImage.borderRadius`，点击进入 `VideoPreviewPage`）。
///
/// Video message bubble opening `VideoPreviewPage` on tap.
class VideoMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建视频消息气泡。
  const VideoMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final VideoElem? elem = message.videoElem;
    final String coverUrl = elem?.snapshotUrl ?? '';
    final String videoUrl = elem?.videoUrl ?? elem?.videoPath ?? '';
    final int duration = elem?.duration ?? 0;

    return GestureDetector(
      onTap: videoUrl.isEmpty
          ? null
          : () => AdaptiveRouter.of(context).pushNamed(
              AppRoutes.videoPreview,
              arguments: <String, String?>{'url': videoUrl, 'title': '视频消息'},
            ),
      child: SizedBox(
        width: 190,
        height: 130,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (coverUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: coverUrl,
                tag: 'video_covers',
                memCacheWidth: 380,
                borderRadius: BorderRadius.circular(8),
                fit: BoxFit.cover,
                errorBuilder:
                    (BuildContext _, String _, Object _, StackTrace? _) =>
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            const Center(
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.black54,
                child: Icon(Icons.play_arrow, color: Colors.white, size: 28),
              ),
            ),
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  DateTimeFormatter.formatDurationSeconds(duration),
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
