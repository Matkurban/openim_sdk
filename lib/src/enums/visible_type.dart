/// 朋友圈动态可见范围枚举。
///
/// Visibility scope enum for Moments posts.
enum VisibleType {
  /// 好友可见（1） / Visible to friends (`1`).
  friend(1),

  /// 仅自己可见（3） / Visible only to self (`3`).
  self(3);

  /// 协议整数值 / Protocol integer value.
  final int value;

  /// 创建朋友圈可见范围枚举值。
  ///
  /// Creates a [VisibleType] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const VisibleType(this.value);
}
