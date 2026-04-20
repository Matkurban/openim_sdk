/// SDK 多线程管理器（L1 "大 Isolate"）
///
/// 在 native 平台上将整个 SDK 引擎运行在独立的后台 Isolate 中，
/// 所有 Future 方法通过消息传递调用，彻底避免 UI 卡顿。
/// 在 Web 平台上直接在主线程执行（JS 单线程模型 + 数据库 / path_provider
/// 等必须主线程运行）。
///
/// 这一层使用原生 `dart:isolate` 的双向 `SendPort` 通道：
/// - 主线程 → 后台 Isolate：方法调用请求（序列化为 Map）
/// - 后台 Isolate → 主线程：方法调用结果 + 任意时刻的监听器事件（带 envelope 标签）
///
/// 纯 CPU 型的辅助计算（MD5、图片尺寸解码、消息过滤等）则完整使用
/// `isolate_manager` 插件，见 [SdkWorkers]，在 Web 端真正跑在 JS Worker 中。
library;

import 'dart:async';
import 'dart:isolate';
import 'dart:ui' show RootIsolateToken;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:openim_sdk/src/isolate/sdk_workers.dart';
import 'package:openim_sdk/src/models/openim_exception.dart';

import 'sdk_isolate_entry.dart';
import 'sdk_isolate_protocol.dart';

/// SDK Isolate 管理器 — 单例
class SdkIsolateManager {
  SdkIsolateManager._();

  static SdkIsolateManager? _instance;

  /// 标记当前是否运行在后台 Isolate 中，防止嵌套 spawn
  static bool _isBackgroundIsolate = false;

  /// 由 [sdkIsolateEntry] 在后台 Isolate 启动时调用
  static void markAsBackgroundIsolate() => _isBackgroundIsolate = true;

  /// 后台 Isolate 是否正在运行
  static bool get isActive => _instance?._running ?? false;

  /// 获取单例（必须在 [initialize] 之后使用）
  static SdkIsolateManager get instance {
    assert(_instance != null, 'SdkIsolateManager 尚未初始化，请先调用 initialize()');
    return _instance!;
  }

  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;
  bool _running = false;
  int _nextId = 0;

  final Map<int, Completer<dynamic>> _completers = {};

  final StreamController<SdkListenerEvent> _eventController =
      StreamController<SdkListenerEvent>.broadcast();

  /// 监听 SDK 后台事件（新消息、会话变更、好友变更等）
  Stream<SdkListenerEvent> get events => _eventController.stream;

  // --------------------------------------------------------------------------
  // 生命周期
  // --------------------------------------------------------------------------

  /// 初始化 SDK Isolate
  ///
  /// 在 Web 上自动降级为主线程模式。
  /// 多次调用是安全的，只有首次会创建 Isolate。
  static Future<void> initialize() async {
    // 后台 Isolate 中不允许再 spawn 子 Isolate，防止无限递归
    if (_isBackgroundIsolate) return;

    if (_instance != null) {
      if (_instance!._running) return;
      // hot restart 后 Isolate 可能已死亡，需要重新创建
      await dispose();
    }

    _instance = SdkIsolateManager._();

    if (kIsWeb) {
      // Web 平台无 Isolate 支持，isActive 保持 false，Manager 直接执行
      _instance = null;
      return;
    }

    await _instance!._spawn();
  }

  Future<void> _spawn() async {
    _receivePort = ReceivePort();

    final rootToken = RootIsolateToken.instance!;
    _isolate = await Isolate.spawn(
      sdkIsolateEntry,
      (rootToken, _receivePort!.sendPort),
      debugName: 'openim-sdk-engine',
      errorsAreFatal: false,
    );

    final readyCompleter = Completer<void>();

    _receivePort!.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        _running = true;
        readyCompleter.complete();
      } else if (message is Map) {
        final map = Map<String, dynamic>.from(message);
        if (isSdkMethodResult(map)) {
          _handleResult(SdkMethodResult.fromMap(map));
        } else if (isSdkListenerEvent(map)) {
          _eventController.add(SdkListenerEvent.fromMap(map));
        }
      }
    });

    await readyCompleter.future;
  }

  void _handleResult(SdkMethodResult result) {
    final completer = _completers.remove(result.id);
    if (completer == null) return;
    if (result.error != null) {
      if (result.errorCode != null) {
        completer.completeError(OpenIMException(code: result.errorCode!, message: result.error!));
      } else {
        completer.completeError(SdkIsolateException(result.error!, result.stackTrace));
      }
    } else {
      completer.complete(result.result);
    }
  }

  // --------------------------------------------------------------------------
  // 方法调用
  // --------------------------------------------------------------------------

  /// 向后台 Isolate 发送方法调用并等待结果
  ///
  /// [method] 格式为 `managerName.methodName`
  /// [args]   序列化后的参数 Map
  Future<dynamic> invoke(String method, [Map<String, dynamic>? args]) {
    if (!_running) {
      throw StateError('SDK Isolate 未运行');
    }

    final id = _nextId++;
    final completer = Completer<dynamic>();
    _completers[id] = completer;

    _sendPort!.send(SdkMethodCall(id: id, method: method, args: args ?? const {}).toMap());

    return completer.future;
  }

  // --------------------------------------------------------------------------
  // 销毁
  // --------------------------------------------------------------------------

  /// 销毁后台 Isolate 并释放资源
  static Future<void> dispose() async {
    final inst = _instance;
    if (inst == null) return;

    inst._running = false;
    inst._isolate?.kill(priority: Isolate.beforeNextEvent);
    inst._isolate = null;
    inst._sendPort = null;
    inst._receivePort?.close();
    inst._receivePort = null;

    for (final c in inst._completers.values) {
      c.completeError(StateError('SDK Isolate 已销毁'));
    }
    inst._completers.clear();

    await inst._eventController.close();
    _instance = null;

    // L2 workers 也一并回收
    await SdkWorkers.dispose();
  }
}

/// SDK Isolate 异常
class SdkIsolateException implements Exception {
  final String message;
  final String? stackTrace;

  SdkIsolateException(this.message, [this.stackTrace]);

  @override
  String toString() => 'SdkIsolateException: $message';
}
