/// 通话信令类型（用于通话记录消息）
enum CallSignalType {
  /// 邀请
  invite(1),

  /// 接受
  accept(2),

  /// 拒绝
  reject(3),

  /// 取消
  cancel(4),

  /// 挂断
  hungup(5),

  /// 无响应
  noResponse(6);

  const CallSignalType(this.value);

  final int value;

  factory CallSignalType.fromValue(int value) {
    return values.firstWhere((e) => e.value == value, orElse: () => invite);
  }
}
