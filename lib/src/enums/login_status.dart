import 'package:json_annotation/json_annotation.dart';

/// SDK 登录状态枚举。
///
/// SDK login lifecycle status enum.
enum LoginStatus {
  /// 未登录 / Logged out.
  @JsonValue(1)
  logout(1),

  /// 正在登录中 / Login in progress.
  @JsonValue(2)
  logging(2),

  /// 已登录 / Logged in.
  @JsonValue(3)
  logged(3);

  /// 创建登录状态枚举值。
  ///
  /// Creates a [LoginStatus] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const LoginStatus(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;
}
