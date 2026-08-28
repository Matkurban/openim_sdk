/// SDK L2 工具 Worker 协调器
///
/// 用 [worker_manager] 维护一个最多 2 个 Isolate 的可复用任务池，承载 MD5、
/// 图片尺寸解码、消息过滤以及 native 文件分片读取等 CPU / IO 任务。
///
/// - 池大小限制为 2，避免作为库默认占满宿主 App 的全部 CPU 核。
/// - `dynamicSpawning: true`：空闲时回收 Isolate。
/// - 若宿主已经调用过 `workerManager.init()`，本库的 init 会被插件忽略。
/// - Web：wasm Isolate 可用时并行；否则与 Flutter `compute` 一样可能落回当前 Isolate。
library;

import 'dart:async';

import 'package:worker_manager/worker_manager.dart';

/// L2 工具 Worker 协调器
abstract class SdkWorkers {
  SdkWorkers._();

  static bool _initialized = false;

  /// 确保 L2 任务池已初始化。幂等。
  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    // 插件在池非空时会忽略后续 init，避免覆盖宿主 App 的配置。
    await workerManager.init(isolatesCount: 2, dynamicSpawning: true);
    _initialized = true;
  }

  /// 在 worker 池中执行任务。
  ///
  /// [task] 必须是顶层函数、静态方法，或只捕获可发送对象的 lambda。
  static Future<R> run<R>(
    FutureOr<R> Function() task, {
    WorkPriority priority = WorkPriority.regular,
  }) async {
    await ensureInitialized();
    return workerManager.execute<R>(task, priority: priority);
  }

  /// 停止并释放 worker 池。业务上只在 [IMManager.unInitSDK] 时调用；测试 tearDown 也可直接调用。
  static Future<void> dispose() async {
    _initialized = false;
    await workerManager.dispose();
  }
}
