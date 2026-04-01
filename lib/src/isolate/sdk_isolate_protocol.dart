/// SDK 多线程通信协议
///
/// 定义主线程 ↔ 后台 Isolate 之间的消息类型。
library;

/// 方法调用请求（主线程 → 后台 Isolate）
class SdkMethodCall {
  final int id;
  final String method;
  final Map<String, dynamic> args;

  const SdkMethodCall({required this.id, required this.method, required this.args});
}

/// 方法调用结果（后台 Isolate → 主线程）
class SdkMethodResult {
  final int id;
  final dynamic result;
  final String? error;
  final String? stackTrace;
  final int? errorCode;

  const SdkMethodResult({
    required this.id,
    this.result,
    this.error,
    this.stackTrace,
    this.errorCode,
  });
}

/// 监听器事件（后台 Isolate → 主线程）
class SdkListenerEvent {
  final String listenerType;
  final String method;
  final dynamic data;

  const SdkListenerEvent({required this.listenerType, required this.method, this.data});
}
