/// SDK L2 工具 Worker 协调器
///
/// - 维护一个共享的 `IsolateManagerShared` 实例，承载所有 `@isolateManagerSharedWorker`
///   注解的纯 Dart 函数（MD5、图片尺寸解码、消息过滤等），在 6 端通用。
/// - 对需要 `dart:io` 的 worker 提供一个 `runNative` 辅助方法，只在 native 平台使用。
/// - 统一维护函数到 Worker 名称的映射，避免每次调用都传 `workerName`。
library;

import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:isolate_manager/isolate_manager.dart';

import '../utils/sdk_isolate_workers_core.dart' as core;

/// L2 工具 Worker 协调器
abstract class SdkWorkers {
  SdkWorkers._();

  static IsolateManagerShared? _shared;
  static bool _mappingsRegistered = false;

  /// 共享多函数 Isolate / JS Worker 实例
  ///
  /// 第一次访问时懒初始化。`IsolateManagerShared` 内部会在首次 compute 时自动启动。
  static IsolateManagerShared get shared {
    _registerWorkerMappings();
    return _shared ??= IsolateManager.createShared(
      concurrent: 2,
      useWorker: true,
      debugName: 'openim-sdk-shared',
    );
  }

  /// 在 native VM Isolate 中运行一个一次性 worker 函数（用于涉及 `dart:io` 的函数）。
  ///
  /// Web 平台直接在主线程执行，因为 `dart:io` 在 Web 上不可用。
  static Future<R> runNative<R, P>(IsolateFunction<R, P> function, P params) {
    if (kIsWeb) {
      // 调用方应提前用 !kIsWeb 守卫；这里兜底同步执行。
      return Future<R>.sync(() => function(params));
    }
    return IsolateManager.runFunction<R, P>(function, params);
  }

  /// 确保 L2 共享 Worker 已注册映射。幂等。
  static void _registerWorkerMappings() {
    if (_mappingsRegistered) return;
    _mappingsRegistered = true;

    // Web 使用 `$shared_worker.js` 时，shared manager 会按函数名字符串匹配 worker
    // 内部的 case 分支。这里把 Dart 函数引用映射到对应的 worker 函数名。
    IsolateManager.addWorkerMapping(core.md5Worker, 'md5Worker');
    IsolateManager.addWorkerMapping(core.combinedMd5Worker, 'combinedMd5Worker');
    IsolateManager.addWorkerMapping(core.partMd5sFromBytesWorker, 'partMd5sFromBytesWorker');
    IsolateManager.addWorkerMapping(core.imageDimensionsWorker, 'imageDimensionsWorker');
    IsolateManager.addWorkerMapping(core.searchFilterWorker, 'searchFilterWorker');
    IsolateManager.addWorkerMapping(core.historyFilterWorker, 'historyFilterWorker');
  }

  /// 停止并释放共享 Worker。通常只在测试或 App 完全退出时调用。
  static Future<void> dispose() async {
    final s = _shared;
    _shared = null;
    if (s != null) {
      await s.stop();
    }
  }
}
