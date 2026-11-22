import 'package:json_annotation/json_annotation.dart';

/// 用户社交关系类型枚举。
///
/// User social relationship type enum.
enum Relationship {
  /// 黑名单关系 / Blocked (blacklisted) user.
  @JsonValue(0)
  black(0),

  /// 好友关系 / Friend relationship.
  @JsonValue(1)
  friend(1);

  /// 创建用户关系类型枚举值。
  ///
  /// Creates a [Relationship] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const Relationship(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;
}
