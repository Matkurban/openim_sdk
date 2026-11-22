import 'package:json_annotation/json_annotation.dart';

/// 群成员列表筛选条件枚举。
///
/// Filter criteria enum for querying group member lists.
enum GroupMemberFilter {
  /// 全部成员 / All members.
  @JsonValue(0)
  all(0),

  /// 仅群主 / Group owner only.
  @JsonValue(1)
  owner(1),

  /// 仅管理员 / Administrators only.
  @JsonValue(2)
  admin(2),

  /// 仅普通成员 / Regular members only.
  @JsonValue(3)
  member(3),

  /// 管理员与普通成员 / Administrators and regular members.
  @JsonValue(4)
  adminAndMember(4);

  /// 创建群成员筛选枚举值。
  ///
  /// Creates a [GroupMemberFilter] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const GroupMemberFilter(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;

  /// [adminAndMember] 的兼容别名 / Legacy alias for [adminAndMember].
  static GroupMemberFilter get superAndAdmin => adminAndMember;
}
