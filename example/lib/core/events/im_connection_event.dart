/// IM 连接与鉴权状态事件。
///
/// IM connection and authentication status event.
class ImConnectionEvent {
  /// 事件类型标识：`connecting`、`connected`、`failed`、`kickedOffline`、`tokenExpired`、`tokenInvalid`。
  final String kind;

  /// 错误码（可选）。
  final int? code;

  /// 错误信息（可选）。
  final String? message;

  /// 创建连接事件。
  const ImConnectionEvent({required this.kind, this.code, this.message});
}
