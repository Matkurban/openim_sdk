import 'package:json_annotation/json_annotation.dart';

/// 群成员角色等级枚举。
///
/// Group member role level enum.
enum GroupRoleLevel {
  /// 普通群成员 / Regular group member.
  @JsonValue(20)
  member(20),

  /// 群管理员 / Group administrator.
  @JsonValue(60)
  admin(60),

  /// 群主 / Group owner.
  @JsonValue(100)
  owner(100);

  /// 创建群成员角色枚举值。
  ///
  /// Creates a [GroupRoleLevel] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const GroupRoleLevel(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;
}
