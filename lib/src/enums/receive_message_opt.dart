import 'package:json_annotation/json_annotation.dart';

/// 消息免打扰 / 接收选项枚举。
///
/// Message receive and Do-Not-Disturb notification option enum.
enum ReceiveMessageOpt {
  /// 正常接收并推送提醒 / Receive messages normally with notifications.
  @JsonValue(0)
  receive(0),

  /// 不接收消息 / Do not receive messages.
  @JsonValue(1)
  notReceive(1),

  /// 接收消息但不提醒（免打扰） / Receive messages silently without notifications (DND).
  @JsonValue(2)
  notNotify(2);

  /// 创建消息接收选项枚举值。
  ///
  /// Creates a [ReceiveMessageOpt] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const ReceiveMessageOpt(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;

  /// 根据整数值解析 [ReceiveMessageOpt]，未匹配时默认返回 [receive]。
  ///
  /// Resolves [ReceiveMessageOpt] from integer [value], defaulting to [receive].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  /// - Returns: 对应的 [ReceiveMessageOpt] 枚举值 / Matching [ReceiveMessageOpt] enum value.
  factory ReceiveMessageOpt.fromValue(int value) {
    return ReceiveMessageOpt.values.firstWhere(
      (ReceiveMessageOpt e) => e.value == value,
      orElse: () => ReceiveMessageOpt.receive,
    );
  }
}
