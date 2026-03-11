import 'package:json_annotation/json_annotation.dart';

/// Group Member Roles
enum GroupRoleLevel {
  /// Regular member
  @JsonValue(20)
  member(20),

  /// Administrator
  @JsonValue(60)
  admin(60),

  /// Group owner
  @JsonValue(100)
  owner(100);

  const GroupRoleLevel(this.value);

  final int value;
}
