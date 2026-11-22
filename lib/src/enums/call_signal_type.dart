/// 通话信令类型枚举（用于通话记录消息）。
///
/// Call signaling action type enum used in call record messages.
enum CallSignalType {
  /// 发起邀请 / Call invitation.
  invite(1),

  /// 接听通话 / Call accepted.
  accept(2),

  /// 拒绝来电 / Call rejected.
  reject(3),

  /// 取消呼叫 / Call cancelled.
  cancel(4),

  /// 挂断通话 / Call hung up.
  hungup(5),

  /// 超时无响应 / No response (timeout).
  noResponse(6);

  /// 创建通话信令类型枚举值。
  ///
  /// Creates a [CallSignalType] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const CallSignalType(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;

  /// 根据整数值解析 [CallSignalType]，未匹配时默认返回 [invite]。
  ///
  /// Resolves [CallSignalType] from integer [value], defaulting to [invite] if unmatched.
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  /// - Returns: 对应的 [CallSignalType] 枚举值 / Matching [CallSignalType] enum value.
  factory CallSignalType.fromValue(int value) {
    return values.firstWhere((CallSignalType e) => e.value == value, orElse: () => invite);
  }
}
