/// 音视频通话媒体类型枚举。
///
/// Audio/video call media type enum.
enum CallType {
  /// 语音通话 / Audio-only call.
  audio('audio', 1, '语音'),

  /// 视频通话 / Video call.
  video('video', 2, '视频');

  /// 创建通话类型枚举值。
  ///
  /// Creates a [CallType] with signaling [value], record [intValue], and display [label].
  ///
  /// - [value] 信令协议字符串值 / Signaling protocol string value.
  /// - [intValue] 通话记录整数值 / Call record integer value.
  /// - [label] 默认中文展示标签 / Default display label.
  const CallType(this.value, this.intValue, this.label);

  /// 字符串值（用于信令协议） / String value used in signaling payloads.
  final String value;

  /// 整数值（用于通话记录序列化） / Integer value used in call record serialization.
  final int intValue;

  /// 显示标签 / Human-readable display label.
  final String label;

  /// 根据字符串值解析 [CallType]，未匹配时默认返回 [audio]。
  ///
  /// Resolves [CallType] from string [value], defaulting to [audio].
  ///
  /// - [value] 协议字符串值（如 `audio`、`video`） / Protocol string value.
  /// - Returns: 对应的 [CallType] 枚举值 / Matching [CallType] enum value.
  factory CallType.fromValue(String value) {
    return values.firstWhere((CallType item) => item.value == value, orElse: () => audio);
  }

  /// 根据整数值解析 [CallType]，未匹配时默认返回 [audio]。
  ///
  /// Resolves [CallType] from integer [value], defaulting to [audio].
  ///
  /// - [value] 协议整数值（1 语音，2 视频） / Protocol integer value.
  /// - Returns: 对应的 [CallType] 枚举值 / Matching [CallType] enum value.
  factory CallType.fromIntValue(int value) {
    return values.firstWhere((CallType item) => item.intValue == value, orElse: () => audio);
  }
}
