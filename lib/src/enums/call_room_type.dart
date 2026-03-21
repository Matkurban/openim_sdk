/// 通话房间类型
enum CallRoomType {
  /// 单聊
  single(1),

  /// 群聊
  group(2);

  const CallRoomType(this.value);

  final int value;

  factory CallRoomType.fromValue(int value) {
    return values.firstWhere((e) => e.value == value, orElse: () => single);
  }
}
