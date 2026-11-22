import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_navite_background_downloader/xue_hua_navite_background_downloader.dart';

import '../../core/services/desktop_service.dart';
import '../../core/services/download_service.dart';
import '../../core/services/media_service.dart';
import '../../shared/widgets/empty_state_view.dart';

/// 后台下载任务管理中心页（暂停/继续/重试/删除/打开文件/桌面更新包一键安装）。
///
/// Background download tasks manager page.
class DownloadManagerPage extends StatelessWidget {
  /// 创建下载管理页。
  const DownloadManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DownloadService downloader = Wire.find<DownloadService>();
    final MediaService media = Wire.find<MediaService>();
    final DesktopService desktop = Wire.find<DesktopService>();

    return Scaffold(
      appBar: AppBar(title: const Text('后台下载管理')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final List<DownloadTask> list = downloader.tasks.value;
          if (list.isEmpty) {
            return const EmptyStateView(title: '暂无后台下载任务');
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (BuildContext _, int _) =>
                const Divider(height: 1),
            itemBuilder: (BuildContext _, int index) {
              final DownloadTask task = list[index];
              final bool isUpdate = task.group == 'app_updates';
              return ListTile(
                leading: Icon(
                  isUpdate
                      ? Icons.system_update_alt
                      : Icons.insert_drive_file_outlined,
                ),
                title: Text(task.fileName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${task.status.name} · ${(task.progress * 100).toStringAsFixed(1)}%',
                    ),
                    if (task.status == DownloadStatus.running)
                      LinearProgressIndicator(
                        value: task.progress.clamp(0.0, 1.0),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (task.status == DownloadStatus.running)
                      IconButton(
                        icon: const Icon(Icons.pause),
                        onPressed: () => downloader.pause(task.taskId),
                      )
                    else if (task.status == DownloadStatus.paused)
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () => downloader.resume(task.taskId),
                      )
                    else if (task.status == DownloadStatus.failed)
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => downloader.retry(task.taskId),
                      )
                    else if (task.status == DownloadStatus.completed &&
                        task.savePath.isNotEmpty)
                      IconButton(
                        tooltip: isUpdate ? '安装更新' : '打开文件',
                        icon: Icon(
                          isUpdate ? Icons.install_desktop : Icons.open_in_new,
                        ),
                        onPressed: () {
                          if (isUpdate && desktop.isDesktop) {
                            desktop.installDownloadedPackage(
                              packagePath: task.savePath,
                            );
                          } else {
                            media.openLocalFile(path: task.savePath);
                          }
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => downloader.removeTask(task.taskId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
