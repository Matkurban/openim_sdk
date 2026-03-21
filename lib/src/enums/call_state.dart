/// 通话状态
enum CallState {
  /// 空闲状态
  idle,

  /// 呼叫中（等待对方接听）
  calling,

  /// 被呼叫（收到来电）
  incoming,

  /// 通话中
  connected,

  /// 通话结束
  ended,
}
