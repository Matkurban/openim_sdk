import 'package:json_annotation/json_annotation.dart';

/// Login Status
enum LoginStatus {
  @JsonValue(1)
  logout(1),

  @JsonValue(2)
  logging(2),

  @JsonValue(3)
  logged(3);

  const LoginStatus(this.value);

  final int value;
}
