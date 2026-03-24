import 'package:json_annotation/json_annotation.dart';

/// Group Types
enum GroupType {
  /// Work group
  @JsonValue(2)
  work(2);

  const GroupType(this.value);

  final int value;
}
