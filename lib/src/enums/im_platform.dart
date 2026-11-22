import 'package:json_annotation/json_annotation.dart';

/// OpenIM 客户端运行平台枚举。
///
/// OpenIM client platform identifier enum.
enum IMPlatform {
  /// iOS 移动端 / iOS mobile platform.
  @JsonValue(1)
  ios(1),

  /// Android 移动端 / Android mobile platform.
  @JsonValue(2)
  android(2),

  /// Windows 桌面端 / Windows desktop platform.
  @JsonValue(3)
  windows(3),

  /// macOS 桌面端 / macOS desktop platform.
  @JsonValue(4)
  xos(4),

  /// Web 浏览器端 / Web browser platform.
  @JsonValue(5)
  web(5),

  /// 移动端 Web / 小程序端 / Mobile Web / Mini-program platform.
  @JsonValue(6)
  miniWeb(6),

  /// Linux 桌面端 / Linux desktop platform.
  @JsonValue(7)
  linux(7),

  /// Android 平板端 / Android tablet platform.
  @JsonValue(8)
  androidPad(8),

  /// iPad 平板端 / iPadOS tablet platform.
  @JsonValue(9)
  ipad(9);

  /// 创建平台类型枚举值。
  ///
  /// Creates an [IMPlatform] with its protocol integer [value].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  const IMPlatform(this.value);

  /// 协议整数值 / Protocol integer value.
  final int value;

  /// 根据整数值解析 [IMPlatform]，未匹配时默认返回 [web]。
  ///
  /// Resolves [IMPlatform] from integer [value], defaulting to [web].
  ///
  /// - [value] 协议整数值 / Protocol integer value.
  /// - Returns: 对应的 [IMPlatform] 枚举值 / Matching [IMPlatform] enum value.
  factory IMPlatform.fromValue(int value) {
    return values.firstWhere((IMPlatform item) => item.value == value, orElse: () => web);
  }
}
