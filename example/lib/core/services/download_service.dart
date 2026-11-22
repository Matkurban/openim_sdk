import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_navite_background_downloader/xue_hua_navite_background_downloader.dart';

/// 后台下载任务管理服务（基于 `xue_hua_navite_background_downloader`）。
///
/// Native background download task service powered by `xue_hua_navite_background_downloader`.
class DownloadService extends WireService {
  static final Logger _logger = Logger('DownloadService');

  /// 当前全部下载任务列表信号。
  late final Signal<List<DownloadTask>> tasks =
      createSignal<List<DownloadTask>>(<DownloadTask>[]);

  StreamSubscription<DownloadTask>? _taskSub;

  /// 初始化下载器配置并恢复历史持久化任务。
  Future<void> initialize() async {
    if (kIsWeb) {
      return;
    }
    try {
      final XueHuaNaviteBackgroundDownloader downloader =
          XueHuaNaviteBackgroundDownloader.instance;
      await downloader.configure(
        const DownloaderConfig(
          maxConcurrentTasks: 3,
          enableNotifications: true,
        ),
      );
      await downloader.requestNotificationPermission();
      final List<DownloadTask> restored = await downloader.getAllTasks();
      tasks.value = restored;

      _taskSub?.cancel();
      _taskSub = downloader.taskUpdates.listen((DownloadTask updated) {
        final List<DownloadTask> next = List<DownloadTask>.from(tasks.value);
        final int idx = next.indexWhere(
          (DownloadTask t) => t.taskId == updated.taskId,
        );
        if (idx >= 0) {
          next[idx] = updated;
        } else {
          next.insert(0, updated);
        }
        tasks.value = next;
      });
    } on Object catch (error, stackTrace) {
      _logger.warning('DownloadService initialize failed', error, stackTrace);
    }
  }

  /// 创建并加入下载队列。
  Future<DownloadTask?> enqueue({
    required String url,
    required String fileName,
    String group = 'chat_files',
    String? expectedSha256,
  }) async {
    try {
      final XueHuaNaviteBackgroundDownloader downloader =
          XueHuaNaviteBackgroundDownloader.instance;
      final DownloadTask task = await downloader.enqueue(
        DownloadRequest(
          url: url,
          fileName: fileName,
          saveDirectory: '',
          group: group,
          expectedChecksum: expectedSha256,
          checksumAlgorithm: ChecksumAlgorithm.sha256,
        ),
      );
      final List<DownloadTask> next = List<DownloadTask>.from(tasks.value);
      next.removeWhere((DownloadTask t) => t.taskId == task.taskId);
      next.insert(0, task);
      tasks.value = next;
      return task;
    } on Object catch (error, stackTrace) {
      _logger.warning('enqueue download failed: $url', error, stackTrace);
      return null;
    }
  }

  /// 暂停任务。
  Future<void> pause(String taskId) async {
    await XueHuaNaviteBackgroundDownloader.instance.pause(taskId);
  }

  /// 恢复任务。
  Future<void> resume(String taskId) async {
    await XueHuaNaviteBackgroundDownloader.instance.resume(taskId);
  }

  /// 取消任务。
  Future<void> cancel(String taskId) async {
    await XueHuaNaviteBackgroundDownloader.instance.cancel(taskId);
  }

  /// 重试失败任务。
  Future<void> retry(String taskId) async {
    await XueHuaNaviteBackgroundDownloader.instance.retry(taskId);
  }

  /// 移除任务记录。
  Future<void> removeTask(String taskId) async {
    await XueHuaNaviteBackgroundDownloader.instance.removeTask(taskId);
    tasks.value = tasks.value
        .where((DownloadTask t) => t.taskId != taskId)
        .toList();
  }

  /// 根据 URL 查找已存在任务。
  DownloadTask? findByUrl(String url) {
    for (final DownloadTask task in tasks.value) {
      if (task.url == url) {
        return task;
      }
    }
    return null;
  }

  @override
  void onClose() {
    _taskSub?.cancel();
    super.onClose();
  }
}
