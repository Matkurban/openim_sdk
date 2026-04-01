/// SDK 后台 Isolate 入口
///
/// 此文件运行在后台 Isolate 中，负责：
/// 1. 初始化通信通道
/// 2. 接收主线程的方法调用请求
/// 3. 通过 [SdkMethodDispatcher] 分发到实际的 Manager 方法
/// 4. 将结果序列化后返回主线程
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

  // 标记当前为后台 Isolate，防止 Manager 内部再次 spawn
  SdkIsolateManager.markAsBackgroundIsolate();

  // 初始化 BackgroundIsolateBinaryMessenger，使 platform channel 可用
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);

  final receivePort = ReceivePort();

  // 将后台 Isolate 的 SendPort 发送给主线程
  mainSendPort.send(receivePort.sendPort);

  // 创建方法分发器
  final dispatcher = SdkMethodDispatcher(mainSendPort: mainSendPort);

  // 监听主线程的方法调用请求
  receivePort.listen((message) async {
    if (message is SdkMethodCall) {
      try {
        final result = await dispatcher.dispatch(message.method, message.args);
        mainSendPort.send(SdkMethodResult(id: message.id, result: result));
      } catch (e, s) {
        if (e is OpenIMException) {
          mainSendPort.send(SdkMethodResult(id: message.id, error: e.message, errorCode: e.code));
        } else {
          mainSendPort.send(
            SdkMethodResult(id: message.id, error: e.toString(), stackTrace: s.toString()),
          );
        }
      }
    }
  });
}
