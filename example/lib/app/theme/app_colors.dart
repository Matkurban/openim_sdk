import 'package:flutter/widgets.dart';

/// 类微信语义色板常量。
///
/// WeChat-inspired semantic color palette constants.
abstract final class AppColors {
  /// 品牌主色（微信绿）。
  static const Color primary = Color(0xFF07C160);

  /// 品牌按压深绿。
  static const Color primaryDark = Color(0xFF06AD56);

  /// 浅色页面背景。
  static const Color lightBackground = Color(0xFFEDEDED);

  /// 浅色卡片/列表表面。
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// 浅色气泡（我方）。
  static const Color selfBubbleLight = Color(0xFF95EC69);

  /// 浅色气泡（对方）。
  static const Color peerBubbleLight = Color(0xFFFFFFFF);

  /// 深色页面背景。
  static const Color darkBackground = Color(0xFF111111);

  /// 深色卡片/列表表面。
  static const Color darkSurface = Color(0xFF1C1C1E);

  /// 深色气泡（我方）。
  static const Color selfBubbleDark = Color(0xFF2B6F4B);

  /// 深色气泡（对方）。
  static const Color peerBubbleDark = Color(0xFF2C2C2E);

  /// 未读角标红。
  static const Color badgeRed = Color(0xFFFA5151);

  /// 红包橙金。
  static const Color redPacketOrange = Color(0xFFFA9D3B);

  /// 红包已领取浅橙。
  static const Color redPacketClaimed = Color(0xFFF6D2A7);

  /// 桌面端左侧导航栏背景。
  static const Color desktopRailBackground = Color(0xFF2E2E2E);

  /// 危险操作红。
  static const Color danger = Color(0xFFFA5151);

  /// 链接蓝。
  static const Color linkBlue = Color(0xFF576B95);
}
