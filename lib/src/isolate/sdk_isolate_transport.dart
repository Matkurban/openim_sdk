/// 后台 SDK 引擎的传输层。
///
/// 公开库只依赖这个接口。`dart:isolate` 只出现在 IO 实现中；
/// Web / WASM 走 stub，引擎留在主线程。
library;

/// 主线程与后台 SDK 引擎之间的双向通道。
abstract interface class SdkIsolateTransport {
  /// 当前平台能否把 SDK 引擎放到后台 Isolate。
  bool get supportsBackground;

  /// 启动后台通道。完成后才能 [send]。
  ///
  /// [onMessage] 收到方法结果或监听事件，内容是可序列化的 Map。
  Future<void> start(void Function(Map<String, dynamic> message) onMessage);

  /// 向后台引擎发送一次方法调用。
  void send(Map<String, dynamic> message);

  /// 停止后台引擎并释放通道。可重复调用。
  void kill();
}
