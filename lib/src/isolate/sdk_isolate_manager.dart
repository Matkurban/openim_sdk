/// SDK 多线程管理器（L1 "大 Isolate"）
///
/// 在 native 平台上将整个 SDK 引擎运行在独立的后台 Isolate 中，
/// 所有 Future 方法通过消息传递调用，彻底避免 UI 卡顿。
/// 在 Web / WASM 上直接在主线程执行（数据库与 `path_provider`
/// 必须主线程运行，且 `dart:isolate` 不能进入 WASM 编译图）。
///
/// 后台通道由条件导入的传输层提供：
/// - 主线程 → 后台 Isolate：方法调用请求（序列化为 Map）
/// - 后台 Isolate → 主线程：方法调用结果 + 任意时刻的监听器事件（带 envelope 标签）
/// - Web / WASM：[sdkIsolateSupportsBackground] 为 false，本管理器不启动
///
/// 纯 CPU 型的辅助计算（MD5、图片尺寸解码、消息过滤等）则使用
/// `worker_manager` 插件，见 [SdkWorkers]。
library;

import 'dart:async';

import 'package:openim_sdk/src/models/openim_exception.dart';

import 'sdk_isolate_protocol.dart';
import 'sdk_isolate_transport.dart';
import 'sdk_isolate_transport_stub.dart' if (dart.library.io) 'sdk_isolate_transport_io.dart';

/// SDK Isolate 管理器 — 单例
class SdkIsolateManager {
  SdkIsolateManager._();

  static SdkIsolateManager? _instance;

  /// 标记当前是否运行在后台 Isolate 中，防止嵌套 spawn
  static bool _isBackgroundIsolate = false;

  /// 由后台 Isolate 入口在启动时调用，防止嵌套 spawn
  static void markAsBackgroundIsolate() => _isBackgroundIsolate = true;

  /// 后台 Isolate 是否正在运行
  static bool get isActive => _instance?._running ?? false;

  /// 获取单例（必须在 [initialize] 之后使用）
  static SdkIsolateManager get instance {
    assert(_instance != null, 'SdkIsolateManager 尚未初始化，请先调用 initialize()');
    return _instance!;
  }

  SdkIsolateTransport? _transport;
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
  /// 在 Web / WASM 上自动降级为主线程模式。
  /// 多次调用是安全的，只有首次会创建 Isolate。
  static Future<void> initialize() async {
    // 后台 Isolate 中不允许再 spawn 子 Isolate，防止无限递归
    if (_isBackgroundIsolate) return;

    if (_instance != null) {
      if (_instance!._running) return;
      // hot restart 后 Isolate 可能已死亡，需要重新创建
      await dispose();
    }

    if (!sdkIsolateSupportsBackground) {
      // Web / WASM 无后台 Isolate，isActive 保持 false，Manager 直接执行
      return;
    }

    _instance = SdkIsolateManager._();
    await _instance!._connect();
  }

  Future<void> _connect() async {
    final transport = createSdkIsolateTransport();
    _transport = transport;
    await transport.start((map) {
      if (isSdkMethodResult(map)) {
        _handleResult(SdkMethodResult.fromMap(map));
      } else if (isSdkListenerEvent(map)) {
        _eventController.add(SdkListenerEvent.fromMap(map));
      }
    });
    _running = true;
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

    _transport!.send(SdkMethodCall(id: id, method: method, args: args ?? const {}).toMap());

    return completer.future;
  }

  // --------------------------------------------------------------------------
  // 销毁
  // --------------------------------------------------------------------------

  /// 销毁后台 Isolate 并释放资源
  static Future<void> dispose() async {
    final inst = _instance;
    if (inst == null) return;

    // L2 池活在 L1 Isolate 自己的 workerManager 单例里，kill 之前先拆掉，避免孤儿 Isolate。
    // 主 Isolate 上的池只在 [IMManager.unInitSDK] 里拆，避免热重启重建 Isolate 时误伤。
    if (inst._running) {
      try {
        await inst.invoke('im.disposeWorkers').timeout(const Duration(seconds: 2));
      } catch (_) {}
    }

    inst._running = false;
    inst._transport?.kill();
    inst._transport = null;

    for (final c in inst._completers.values) {
      c.completeError(StateError('SDK Isolate 已销毁'));
    }
    inst._completers.clear();

    await inst._eventController.close();
    _instance = null;
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
