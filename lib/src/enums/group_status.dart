import 'package:json_annotation/json_annotation.dart';

/// 群组当前状态枚举。
///
/// Group operational status enum.
enum GroupStatus {
  /// 正常 / Normal active group.
  @JsonValue(0)
  normal(0),

  /// 已封禁 / Banned group.
  @JsonValue(1)
  banned(1),

  /// 已解散 / Dismissed group.
  @JsonValue(2)
  dismissed(2),

  /// 全体禁言中 / All members muted.
  @JsonValue(3)
  muted(3);

  /// 创建群组状态枚举值。
  ///
  /// Creates a [GroupStatus] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const GroupStatus(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;

  /// 根据整数值解析 [GroupStatus]，未匹配时默认返回 [normal]。
  ///
  /// Resolves [GroupStatus] from integer [value], defaulting to [normal].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  /// - Returns: 对应的 [GroupStatus] 枚举值 / Matching [GroupStatus] enum value.
  factory GroupStatus.fromValue(int value) {
    return GroupStatus.values.firstWhere(
      (GroupStatus e) => e.value == value,
      orElse: () => GroupStatus.normal,
    );
  }
}
