import 'package:json_annotation/json_annotation.dart';

/// 群会话强提醒（`@` 提及与群公告）类型枚举。
///
/// Group conversation strong-hint (`@` mention and announcement) type enum.
enum GroupAtType {
  /// 无提醒（清除所有强提醒） / No hint (clears all strong hints).
  @JsonValue(0)
  atNormal(0),

  /// 有人 `@我` 提醒 / Someone mentioned me (`@Me`).
  @JsonValue(1)
  atMe(1),

  /// 有人 `@所有人` 提醒 / Someone mentioned everyone (`@All`).
  @JsonValue(2)
  atAll(2),

  /// 同时存在 `@所有人` 与 `@我` 提醒 / Both `@All` and `@Me` hints.
  @JsonValue(3)
  atAllAtMe(3),

  /// 群公告更新提醒 / Group announcement notification hint.
  @JsonValue(4)
  groupNotification(4);

  /// 创建群强提醒类型枚举值。
  ///
  /// Creates a [GroupAtType] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const GroupAtType(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;

  /// 根据整数值解析 [GroupAtType]，未匹配时默认返回 [atNormal]。
  ///
  /// Resolves [GroupAtType] from integer [value], defaulting to [atNormal].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  /// - Returns: 对应的 [GroupAtType] 枚举值 / Matching [GroupAtType] enum value.
  factory GroupAtType.fromValue(int value) {
    return values.firstWhere((GroupAtType item) => item.value == value, orElse: () => atNormal);
  }
}
