import 'package:json_annotation/json_annotation.dart';

/// Join Source
enum JoinSource {
  @JsonValue(2)
  invited(2),

  @JsonValue(3)
  search(3),

  @JsonValue(4)
  qrCode(4);

  const JoinSource(this.value);

  final int value;
}
