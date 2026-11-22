import 'package:json_annotation/json_annotation.dart';

/// 群组类型枚举。
///
/// Group category type enum.
enum GroupType {
  /// 工作群 / Work group.
  @JsonValue(2)
  work(2);

  /// 创建群组类型枚举值。
  ///
  /// Creates a [GroupType] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const GroupType(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;
}
