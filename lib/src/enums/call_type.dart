/// 通话类型
enum CallType {
  /// 语音通话
  audio('audio', 1, '语音'),

  /// 视频通话
  video('video', 2, '视频');

  const CallType(this.value, this.intValue, this.label);

  /// 字符串值（用于信令协议）
  final String value;

  /// 整数值（用于通话记录序列化）
  final int intValue;

  /// 显示标签
  final String label;

  factory CallType.fromValue(String value) {
    return values.firstWhere((item) => item.value == value, orElse: () => audio);
  }

  factory CallType.fromIntValue(int value) {
    return values.firstWhere((item) => item.intValue == value, orElse: () => audio);
  }
}
