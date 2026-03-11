import 'package:json_annotation/json_annotation.dart';

/// Group Member Filter
enum GroupMemberFilter {
  @JsonValue(0)
  all(0),

  @JsonValue(1)
  owner(1),

  @JsonValue(2)
  admin(2),

  @JsonValue(3)
  member(3),

  @JsonValue(4)
  adminAndMember(4);

  const GroupMemberFilter(this.value);

  final int value;

  /// Alias for adminAndMember
  static GroupMemberFilter get superAndAdmin => adminAndMember;
}
