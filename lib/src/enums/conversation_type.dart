import 'package:json_annotation/json_annotation.dart';

/// 会话类型枚举。
///
/// Conversation session type enum.
enum ConversationType {
  /// 单聊会话 / Single one-to-one chat.
  @JsonValue(1)
  single(1),

  /// 超级群聊会话 / Super group chat.
  @JsonValue(3)
  superGroup(3),

  /// 系统通知会话 / System notification conversation.
  @JsonValue(4)
  notification(4);

  /// 创建会话类型枚举值。
  ///
  /// Creates a [ConversationType] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const ConversationType(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;

  /// 根据整数值解析 [ConversationType]，未匹配时默认返回 [single]。
  ///
  /// Resolves [ConversationType] from integer [value], defaulting to [single].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  /// - Returns: 对应的 [ConversationType] 枚举值 / Matching [ConversationType] enum value.
  factory ConversationType.fromValue(int value) {
    return values.firstWhere((ConversationType item) => item.value == value, orElse: () => single);
  }
}
