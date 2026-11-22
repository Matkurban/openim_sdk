import 'package:json_annotation/json_annotation.dart';

/// 进群验证方式枚举。
///
/// Group join verification policy enum.
enum GroupVerification {
  /// 申请需要验证，邀请可直接进群 / Join applications require approval; invited users join directly.
  @JsonValue(0)
  applyNeedVerificationInviteDirectly(0),

  /// 所有人进群均需验证（群主和管理员邀请除外） / Everyone requires approval except owner/admin invitations.
  @JsonValue(1)
  allNeedVerification(1),

  /// 允许任何人直接进群，无需验证 / Anyone can join directly without approval.
  @JsonValue(2)
  directly(2);

  /// 创建进群验证方式枚举值。
  ///
  /// Creates a [GroupVerification] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const GroupVerification(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;
}
