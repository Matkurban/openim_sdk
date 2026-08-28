/// L1 RPC 桥接：在后台 Isolate 激活时转发方法调用，否则在本地执行。
///
/// 纯 RPC + 反序列化的 Manager 方法：
/// - 短方法用 [sdkRun] 包住本地实现
/// - 长方法用 `if (SdkIsolateManager.isActive) return sdkInvoke(...)` 提前返回
///
/// 主 Isolate 仍有本地副作用的路径（initSDK / login* / unInitSDK / logout 等）
/// 不要用本 helper 硬套。
library;

export 'sdk_isolate_manager.dart';

import 'sdk_isolate_manager.dart';

/// 若 L1 Isolate 已激活则 RPC，否则执行 [local]。
Future<T> sdkRun<T>({
  required String method,
  Map<String, dynamic> args = const {},
  required Future<T> Function() local,
  T Function(dynamic raw)? decode,
}) async {
  if (!SdkIsolateManager.isActive) return local();
  return sdkInvoke(method, args: args, decode: decode);
}

/// 向后台 Isolate 发起方法调用（调用方须已确认 [SdkIsolateManager.isActive]）。
Future<T> sdkInvoke<T>(
  String method, {
  Map<String, dynamic> args = const {},
  T Function(dynamic raw)? decode,
}) async {
  final raw = await SdkIsolateManager.instance.invoke(method, args);
  return decode != null ? decode(raw) : raw as T;
}

/// 向后台 Isolate 发起无返回值的方法调用。
Future<void> sdkInvokeVoid(String method, [Map<String, dynamic> args = const {}]) async {
  await SdkIsolateManager.instance.invoke(method, args);
}

/// 把 Isolate 回传的 List 反序列化为模型列表。
List<T> sdkDecodeList<T>(dynamic raw, T Function(Map<String, dynamic> json) fromJson) {
  return (raw as List).map((e) => fromJson(Map<String, dynamic>.from(e as Map))).toList();
}

/// 把 Isolate 回传的 Map 反序列化为单个模型。
T sdkDecodeJson<T>(dynamic raw, T Function(Map<String, dynamic> json) fromJson) {
  return fromJson(Map<String, dynamic>.from(raw as Map));
}
