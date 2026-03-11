import 'package:json_annotation/json_annotation.dart';

/// Group Types
enum GroupType {
  /// General group (Deprecated in v3)
  @Deprecated('Use work instead')
  @JsonValue(0)
  general(0),

  /// Work group
  @JsonValue(2)
  work(2);

  const GroupType(this.value);

  final int value;
}
