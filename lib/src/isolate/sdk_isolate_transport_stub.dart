/// Web / WASM 传输层：不启动后台 Isolate。
///
/// 本文件不能导入 `dart:isolate`。WASM 编译图以它为终点。
library;

import 'sdk_isolate_transport.dart';

/// Web / WASM 没有可用的后台引擎 Isolate。
const bool sdkIsolateSupportsBackground = false;

/// 创建当前平台的传输层。Web / WASM 上管理器不会真正启动它。
SdkIsolateTransport createSdkIsolateTransport() => _StubSdkIsolateTransport();

class _StubSdkIsolateTransport implements SdkIsolateTransport {
  @override
  bool get supportsBackground => sdkIsolateSupportsBackground;

  @override
  Future<void> start(void Function(Map<String, dynamic> message) onMessage) {
    throw UnsupportedError('Web / WASM 不启动后台 SDK Isolate');
  }

  @override
  void send(Map<String, dynamic> message) {
    throw UnsupportedError('Web / WASM 不启动后台 SDK Isolate');
  }

  @override
  void kill() {}
}
