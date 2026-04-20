/// SDK 多线程通信协议
///
/// 定义主线程 ↔ 后台 Isolate 之间的消息类型。
/// 所有消息都可与 `Map<String, dynamic>` 双向转换，便于通过 `isolate_manager`
/// 在 VM Isolate / JS Worker 之间透明传输。
library;

/// 消息信封标签，区分方法调用结果 vs 后台 Isolate 推送的监听器事件。
const String kSdkEnvelopeKey = '_t';
const String kSdkEnvelopeResult = 'result';
const String kSdkEnvelopeEvent = 'event';

/// 初始化消息（主线程 → 后台 Isolate）
///
/// 用于在正式通信前传递 `RootIsolateToken` 等启动参数。
class SdkInitMessage {
  /// 原始 `RootIsolateToken.instance`（只能在 native 平台传递，Web 不涉及）。
  final Object? rootToken;

  const SdkInitMessage({this.rootToken});
}

/// 方法调用请求（主线程 → 后台 Isolate）
class SdkMethodCall {
  final int id;
  final String method;
  final Map<String, dynamic> args;

  const SdkMethodCall({required this.id, required this.method, required this.args});

  Map<String, dynamic> toMap() => <String, dynamic>{'id': id, 'method': method, 'args': args};

  factory SdkMethodCall.fromMap(Map<String, dynamic> map) => SdkMethodCall(
    id: (map['id'] as num).toInt(),
    method: map['method'] as String,
    args: Map<String, dynamic>.from(map['args'] as Map),
  );
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

  Map<String, dynamic> toMap() => <String, dynamic>{
    kSdkEnvelopeKey: kSdkEnvelopeResult,
    'id': id,
    'result': result,
    'error': error,
    'stackTrace': stackTrace,
    'errorCode': errorCode,
  };

  factory SdkMethodResult.fromMap(Map<String, dynamic> map) => SdkMethodResult(
    id: (map['id'] as num).toInt(),
    result: map['result'],
    error: map['error'] as String?,
    stackTrace: map['stackTrace'] as String?,
    errorCode: (map['errorCode'] as num?)?.toInt(),
  );
}

/// 监听器事件（后台 Isolate → 主线程）
class SdkListenerEvent {
  final String listenerType;
  final String method;
  final dynamic data;

  const SdkListenerEvent({required this.listenerType, required this.method, this.data});

  Map<String, dynamic> toMap() => <String, dynamic>{
    kSdkEnvelopeKey: kSdkEnvelopeEvent,
    'listenerType': listenerType,
    'method': method,
    'data': data,
  };

  factory SdkListenerEvent.fromMap(Map<String, dynamic> map) => SdkListenerEvent(
    listenerType: map['listenerType'] as String,
    method: map['method'] as String,
    data: map['data'],
  );
}

/// 判断 payload 是否为监听器事件
bool isSdkListenerEvent(Map<String, dynamic> map) => map[kSdkEnvelopeKey] == kSdkEnvelopeEvent;

/// 判断 payload 是否为方法调用结果
bool isSdkMethodResult(Map<String, dynamic> map) => map[kSdkEnvelopeKey] == kSdkEnvelopeResult;
