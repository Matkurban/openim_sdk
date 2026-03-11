import 'package:json_annotation/json_annotation.dart';

/// Conversation types
enum ConversationType {
  /// Single chat
  @JsonValue(1)
  single(1),

  /// Group (Deprecated in v3)
  @Deprecated('Use superGroup instead')
  @JsonValue(2)
  group(2),

  /// Super group chat
  @JsonValue(3)
  superGroup(3),

  /// Notification
  @JsonValue(4)
  notification(4);

  const ConversationType(this.value);

  final int value;
}
