/// SDK 后台 Isolate 入口（L1 "大 Isolate"）
///
/// 运行在后台 Isolate 中，负责：
/// 1. 初始化通信通道（via `SendPort` / `ReceivePort` 双向）
/// 2. 接收主线程的方法调用请求
/// 3. 通过 [SdkMethodDispatcher] 分发到实际的 Manager 方法
/// 4. 将结果序列化后返回主线程，并把监听器事件实时推送回主线程
///
/// 设计说明：
/// - 该层使用原生 `dart:isolate` 的双向 `SendPort` 通道，而不是 `isolate_manager`
///   的 `IsolateManager.createCustom`。原因：`isolate_manager` 采用 compute /
///   callback 的请求-响应模型，主线程只在某个 compute 活跃时才能接收后台消息，
///   而 L1 需要在任意时刻（WebSocket 推送到达时）向主线程推 onRecvNewMessage
///   等监听器事件。L2 纯 CPU 任务则完整使用 `isolate_manager` 获得 Web Worker
///   支持（见 [SdkWorkers]）。
/// - 后台 Isolate 本身只在 native 5 端启用；Web 端全部降级主线程（`ToStore`
///   数据库与 `path_provider` 平台通道不支持 Web Worker）。
library;

import 'dart:isolate';
import 'dart:ui' show RootIsolateToken;

import 'package:flutter/services.dart' show BackgroundIsolateBinaryMessenger;
import 'package:openim_sdk/openim_sdk.dart';

import 'sdk_method_dispatcher.dart';

/// 后台 Isolate 入口函数
///
/// 由 [SdkIsolateManager._spawn] 通过 `Isolate.spawn` 调用。
void sdkIsolateEntry((RootIsolateToken, SendPort) params) {
  final (rootToken, mainSendPort) = params;

  SdkIsolateManager.markAsBackgroundIsolate();
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);

  final receivePort = ReceivePort();

  mainSendPort.send(receivePort.sendPort);

  final dispatcher = SdkMethodDispatcher(sendEvent: (event) => mainSendPort.send(event.toMap()));

  receivePort.listen((message) async {
    if (message is! Map) return;
    final map = Map<String, dynamic>.from(message);
    final call = SdkMethodCall.fromMap(map);
    try {
      final result = await dispatcher.dispatch(call.method, call.args);
      mainSendPort.send(SdkMethodResult(id: call.id, result: result).toMap());
    } catch (e, s) {
      if (e is OpenIMException) {
        mainSendPort.send(
          SdkMethodResult(id: call.id, error: e.message, errorCode: e.code).toMap(),
        );
      } else {
        mainSendPort.send(
          SdkMethodResult(id: call.id, error: e.toString(), stackTrace: s.toString()).toMap(),
        );
      }
    }
  });
}
