import 'package:meta/meta.dart';

/// WebSocket 连接状态
@internal
enum WebSocketStatus {
  /// 未连接
  notConnected,

  /// 已关闭
  closed,

  /// 正在连接
  connecting,

  /// 已连接
  connected,
}
