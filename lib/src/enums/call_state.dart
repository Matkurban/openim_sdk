/// 音视频通话会话状态枚举。
///
/// Audio/video call session lifecycle state enum.
enum CallState {
  /// 空闲状态 / Idle (no active call).
  idle,

  /// 呼叫中（等待对方接听） / Outgoing call ringing, waiting for answer.
  calling,

  /// 被呼叫（收到来电） / Incoming call ringing.
  incoming,

  /// 通话已接通 / Call connected and in progress.
  connected,

  /// 通话已结束 / Call ended.
  ended,
}
