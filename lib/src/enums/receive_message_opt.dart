import 'package:json_annotation/json_annotation.dart';

/// Receive Message Option
enum ReceiveMessageOpt {
  @JsonValue(0)
  receive(0),

  @JsonValue(1)
  notReceive(1),

  @JsonValue(2)
  notNotify(2);

  const ReceiveMessageOpt(this.value);

  final int value;

  factory ReceiveMessageOpt.fromValue(int value) {
    return ReceiveMessageOpt.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ReceiveMessageOpt.receive,
    );
  }
}
