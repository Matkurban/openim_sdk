import 'package:json_annotation/json_annotation.dart';

/// 加入群组或添加好友的来源方式枚举。
///
/// Source channel enum describing how a user joined a group or added a friend.
enum JoinSource {
  /// 通过群成员邀请加入 / Joined via invitation.
  @JsonValue(2)
  invited(2),

  /// 通过搜索群号/用户 ID 加入 / Joined via search.
  @JsonValue(3)
  search(3),

  /// 通过扫描二维码加入 / Joined via QR code scan.
  @JsonValue(4)
  qrCode(4);

  /// 创建加入来源枚举值。
  ///
  /// Creates a [JoinSource] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const JoinSource(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;
}
