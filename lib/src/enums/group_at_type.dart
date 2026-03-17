import 'package:json_annotation/json_annotation.dart';

/// Conversation Strong Hint Content
enum GroupAtType {
  /// Cancel all hints, equivalent to calling the resetConversationGroupAtType method
  @JsonValue(0)
  atNormal(0),

  /// @ me hint
  @JsonValue(1)
  atMe(1),

  /// @ all hint
  @JsonValue(2)
  atAll(2),

  /// @ all and @ me hint
  @JsonValue(3)
  atAllAtMe(3),

  /// Group notification hint
  @JsonValue(4)
  groupNotification(4);

  const GroupAtType(this.value);

  final int value;

  factory GroupAtType.fromValue(int value) {
    return values.firstWhere((item) => item.value == value, orElse: () => atNormal);
  }
}
