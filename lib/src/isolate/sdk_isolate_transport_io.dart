/// Native 传输层：用 `dart:isolate` 的双向端口跑 SDK 引擎。
///
/// 只在 `dart.library.io` 为真时编进依赖图。Web / WASM 不会编译本文件。
library;

import 'dart:async';
import 'dart:isolate';
import 'dart:ui' show RootIsolateToken;

import 'sdk_isolate_entry.dart';
import 'sdk_isolate_transport.dart';

/// Native 五端可以把 SDK 引擎放到后台 Isolate。
const bool sdkIsolateSupportsBackground = true;

/// 创建当前平台的传输层。
SdkIsolateTransport createSdkIsolateTransport() => _IoSdkIsolateTransport();

class _IoSdkIsolateTransport implements SdkIsolateTransport {
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;

  @override
  bool get supportsBackground => sdkIsolateSupportsBackground;

  @override
  Future<void> start(void Function(Map<String, dynamic> message) onMessage) async {
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
        if (!readyCompleter.isCompleted) readyCompleter.complete();
      } else if (message is Map) {
        onMessage(Map<String, dynamic>.from(message));
      }
    });

    await readyCompleter.future;
  }

  @override
  void send(Map<String, dynamic> message) {
    _sendPort!.send(message);
  }

  @override
  void kill() {
    _isolate?.kill(priority: Isolate.beforeNextEvent);
    _isolate = null;
    _sendPort = null;
    _receivePort?.close();
    _receivePort = null;
  }
}
