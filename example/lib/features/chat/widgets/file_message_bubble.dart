import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_background_downloader/xue_hua_navite_background_downloader.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/services/download_service.dart';
import '../../../core/utils/date_time_formatter.dart';

/// 文件消息气泡（展示文件名/大小/后台下载进度，点击进入 `FilePreviewPage`）。
///
/// File message bubble with live background download progress and preview link.
class FileMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建文件消息气泡。
  const FileMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final FileElem? elem = message.fileElem;
    final String name = elem?.fileName ?? '未知文件';
    final int size = elem?.fileSize ?? 0;
    final String url = elem?.sourceUrl ?? '';
    final DownloadService downloadService = Wire.find<DownloadService>();

    return InkWell(
      onTap: () => AdaptiveRouter.of(context).pushNamed(
        AppRoutes.filePreview,
        arguments: <String, Object?>{
          'fileName': name,
          'fileUrl': url,
          'fileSize': size,
          'localPath': elem?.filePath,
        },
      ),
      child: SizedBox(
        width: 220,
        child: SignalBuilder(
          builder: (BuildContext _) {
            final DownloadTask? task = url.isNotEmpty
                ? downloadService.findByUrl(url)
                : null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateTimeFormatter.formatBytes(size),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.insert_drive_file_outlined, size: 36),
                  ],
                ),
                if (task != null &&
                    task.status == DownloadStatus.running) ...<Widget>[
                  const SizedBox(height: 6),
                  LinearProgressIndicator(value: task.progress.clamp(0.0, 1.0)),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
