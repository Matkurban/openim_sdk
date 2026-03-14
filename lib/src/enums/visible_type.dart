/// 朋友圈动态可见类型
/// 1-好友可见，3-仅自己可见
enum VisibleType {
  friend(1),
  self(3);

  final int value;
  const VisibleType(this.value);
}
