import 'package:meta/meta.dart';

/// WebSocket 长连接内部状态枚举。
///
/// Internal WebSocket transport connection status enum.
@internal
enum WebSocketStatus {
  /// 未连接 / Not connected.
  notConnected,

  /// 已关闭 / Closed.
  closed,

  /// 正在连接 / Connecting in progress.
  connecting,

  /// 已连接 / Connected.
  connected,
}
