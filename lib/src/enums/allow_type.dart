import 'package:json_annotation/json_annotation.dart';

/// Allow Type
enum AllowType {
  @JsonValue(0)
  allow(0),

  @JsonValue(1)
  notAllow(1);

  const AllowType(this.value);

  final int value;
}
