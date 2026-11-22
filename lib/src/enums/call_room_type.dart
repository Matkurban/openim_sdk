/// 通话房间类型枚举。
///
/// Call room type enum.
enum CallRoomType {
  /// 单聊通话 / Single-user call.
  single(1),

  /// 群聊多人通话 / Group multi-party call.
  group(2);

  /// 创建通话房间类型枚举值。
  ///
  /// Creates a [CallRoomType] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const CallRoomType(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;

  /// 根据整数值解析 [CallRoomType]，未匹配时默认返回 [single]。
  ///
  /// Resolves [CallRoomType] from integer [value], defaulting to [single] if unmatched.
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  /// - Returns: 对应的 [CallRoomType] 枚举值 / Matching [CallRoomType] enum value.
  factory CallRoomType.fromValue(int value) {
    return values.firstWhere((CallRoomType e) => e.value == value, orElse: () => single);
  }
}
