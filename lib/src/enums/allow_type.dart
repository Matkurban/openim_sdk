import 'package:json_annotation/json_annotation.dart';

/// 权限允许类型枚举。
///
/// Permission allow/disallow type enum.
enum AllowType {
  /// 允许 / Allowed.
  @JsonValue(0)
  allow(0),

  /// 不允许 / Not allowed.
  @JsonValue(1)
  notAllow(1);

  /// 创建权限允许类型枚举值。
  ///
  /// Creates an [AllowType] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const AllowType(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;
}
