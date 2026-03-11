import 'package:json_annotation/json_annotation.dart';

/// Group Status
enum GroupStatus {
  @JsonValue(0)
  normal(0),

  @JsonValue(1)
  banned(1),

  @JsonValue(2)
  dismissed(2),

  @JsonValue(3)
  muted(3);

  const GroupStatus(this.value);

  final int value;

  factory GroupStatus.fromValue(int value) {
    return GroupStatus.values.firstWhere((e) => e.value == value, orElse: () => GroupStatus.normal);
  }
}
