import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_navite_background_downloader/xue_hua_navite_background_downloader.dart';
import 'package:xue_hua_navite_share/xue_hua_navite_share.dart';

import '../../core/services/download_service.dart';
import '../../core/services/media_service.dart';
import '../../core/utils/date_time_formatter.dart';

/// 文件详情与下载预览页（集成后台断点续传下载、系统打开、另存为与外部分享）。
///
/// File preview and download page powered by background downloader and file operations.
class FilePreviewPage extends StatelessWidget {
  /// 文件名。
  final String fileName;

  /// 文件下载地址。
  final String fileUrl;

  /// 文件体积（字节）。
  final int fileSize;

  /// 本地已有路径（可选）。
  final String? localPath;

  /// 创建文件预览页。
  const FilePreviewPage({
    super.key,
    required this.fileName,
    required this.fileUrl,
    this.fileSize = 0,
    this.localPath,
  });

  @override
  Widget build(BuildContext context) {
    final DownloadService downloadService = Wire.find<DownloadService>();
    final MediaService mediaService = Wire.find<MediaService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('文件预览'),
        actions: <Widget>[
          IconButton(
            tooltip: '外部分享',
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              if ((localPath ?? '').isNotEmpty) {
                await XueHuaNaviteShare.instance.shareFiles(<String>[
                  localPath!,
                ]);
              } else if (fileUrl.isNotEmpty) {
                await XueHuaNaviteShare.instance.shareUri(
                  Uri.parse(fileUrl),
                  subject: fileName,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SignalBuilder(
              builder: (BuildContext _) {
                final DownloadTask? task = downloadService.findByUrl(fileUrl);
                final String? readyPath =
                    (task?.status == DownloadStatus.completed &&
                        (task?.savePath ?? '').isNotEmpty)
                    ? task!.savePath
                    : localPath;
                final double progress = task?.progress ?? 0;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.insert_drive_file_outlined, size: 72),
                    const SizedBox(height: 16),
                    Text(
                      fileName,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateTimeFormatter.formatBytes(fileSize),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    if (task != null &&
                        (task.status == DownloadStatus.running ||
                            task.status == DownloadStatus.paused)) ...<Widget>[
                      LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
                      const SizedBox(height: 8),
                      Text('${(progress * 100).toStringAsFixed(1)}%'),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlinedButton(
                            onPressed: () =>
                                task.status == DownloadStatus.running
                                ? downloadService.pause(task.taskId)
                                : downloadService.resume(task.taskId),
                            child: Text(
                              task.status == DownloadStatus.running
                                  ? '暂停'
                                  : '继续',
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () =>
                                downloadService.cancel(task.taskId),
                            child: const Text('取消'),
                          ),
                        ],
                      ),
                    ] else if ((readyPath ?? '').isNotEmpty) ...<Widget>[
                      FilledButton.icon(
                        onPressed: () async {
                          final bool ok = await mediaService.openLocalFile(
                            path: readyPath,
                          );
                          if (!ok) {
                            await FlutterToastPro.error('无法调用系统程序打开此文件');
                          }
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('使用其他应用打开'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final String? saved = await mediaService.saveFileAs(
                            fileName: fileName,
                            sourcePath: readyPath,
                          );
                          if (saved != null) {
                            await FlutterToastPro.success('已另存为：$saved');
                          }
                        },
                        icon: const Icon(Icons.save_alt),
                        label: const Text('另存到本地'),
                      ),
                    ] else
                      FilledButton.icon(
                        onPressed: fileUrl.isEmpty
                            ? null
                            : () async {
                                await downloadService.enqueue(
                                  url: fileUrl,
                                  fileName: fileName,
                                );
                                await FlutterToastPro.info('已开始后台下载');
                              },
                        icon: const Icon(Icons.download),
                        label: const Text('后台下载文件'),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
