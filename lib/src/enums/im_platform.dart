import 'package:json_annotation/json_annotation.dart';

/// IM Platform
enum IMPlatform {
  /// iOS
  @JsonValue(1)
  ios(1),

  /// Android
  @JsonValue(2)
  android(2),

  @JsonValue(3)
  windows(3),

  @JsonValue(4)
  xos(4),

  @JsonValue(5)
  web(5),

  @JsonValue(6)
  miniWeb(6),

  @JsonValue(7)
  linux(7),

  @JsonValue(8)
  androidPad(8),

  @JsonValue(9)
  ipad(9);

  const IMPlatform(this.value);

  final int value;
}
