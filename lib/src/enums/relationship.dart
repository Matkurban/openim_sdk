import 'package:json_annotation/json_annotation.dart';

/// Relationship Type
enum Relationship {
  @JsonValue(0)
  black(0),

  @JsonValue(1)
  friend(1);

  const Relationship(this.value);

  final int value;
}
