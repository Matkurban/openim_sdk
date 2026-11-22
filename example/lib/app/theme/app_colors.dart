import 'package:flutter/widgets.dart';

/// Apple 设计规范色板常量（严格对齐 `DESIGN-apple.md`）。
///
/// Apple design system color tokens strictly aligned with `DESIGN-apple.md`:
/// single Action Blue (`#0066CC`), zero decorative gradients, alternating light/dark canvases.
abstract final class AppColors {
  /// 品牌交互主色（Action Blue `#0066CC`）。
  static const Color primary = Color(0xFF0066CC);

  /// 聚焦态蓝色（Focus Blue `#0071E3`）。
  static const Color primaryFocus = Color(0xFF0071E3);

  /// 兼容别名：按压/聚焦主色。
  static const Color primaryDark = primaryFocus;

  /// 深色画布上的链接与强调蓝（Sky Link Blue `#2997FF`）。
  static const Color primaryOnDark = Color(0xFF2997FF);

  /// 主墨水文字色（Near-Black Ink `#1D1D1F`）。
  static const Color ink = Color(0xFF1D1D1F);

  /// 80% 柔和墨水色（`#333333`）。
  static const Color inkMuted80 = Color(0xFF333333);

  /// 48% 次级说明/禁用文字色（`#7A7A7A`）。
  static const Color inkMuted48 = Color(0xFF7A7A7A);

  /// 深色画布主文字色（`#FFFFFF`）。
  static const Color bodyOnDark = Color(0xFFFFFFFF);

  /// 深色画布次级文字色（`#CCCCCC`）。
  static const Color bodyMuted = Color(0xFFCCCCCC);

  /// 浅色纯白画布（Canvas `#FFFFFF`）。
  static const Color canvas = Color(0xFFFFFFFF);

  /// 浅色羊皮纸背景（Parchment `#F5F5F7`）。
  static const Color canvasParchment = Color(0xFFF5F5F7);

  /// 珍珠白次级按钮表面（Pearl `#FAFAFC`）。
  static const Color surfacePearl = Color(0xFFFAFAFC);

  /// 深色卡片表面 1（Tile 1 `#272729`）。
  static const Color surfaceTile1 = Color(0xFF272729);

  /// 深色卡片表面 2（Tile 2 `#2A2A2C`）。
  static const Color surfaceTile2 = Color(0xFF2A2A2C);

  /// 深色卡片表面 3（Tile 3 `#252527`）。
  static const Color surfaceTile3 = Color(0xFF252527);

  /// 纯黑画布（Surface Black `#000000`，用于全局导航与深色底色）。
  static const Color surfaceBlack = Color(0xFF000000);

  /// 浮层半透明控制芯片灰（`#D2D2D7`）。
  static const Color surfaceChipTranslucent = Color(0xFFD2D2D7);

  /// 柔和分割线（Divider Soft `#F0F0F0`）。
  static const Color dividerSoft = Color(0xFFF0F0F0);

  /// 1px 细线边框（Hairline `#E0E0E0`）。
  static const Color hairline = Color(0xFFE0E0E0);

  /// 深色模式 1px 细线边框。
  static const Color hairlineDark = Color(0xFF3A3A3C);

  /// 浅色页面背景（Parchment）。
  static const Color lightBackground = canvasParchment;

  /// 浅色卡片/列表表面（Canvas）。
  static const Color lightSurface = canvas;

  /// 浅色气泡（我方：Action Blue）。
  static const Color selfBubbleLight = primary;

  /// 浅色气泡（对方：纯白 Canvas）。
  static const Color peerBubbleLight = canvas;

  /// 深色页面背景（Surface Black）。
  static const Color darkBackground = surfaceBlack;

  /// 深色卡片/列表表面（Tile 1）。
  static const Color darkSurface = surfaceTile1;

  /// 深色气泡（我方：Action Blue）。
  static const Color selfBubbleDark = primary;

  /// 深色气泡（对方：Tile 2）。
  static const Color peerBubbleDark = surfaceTile2;

  /// 桌面端左侧全局导航栏背景（Surface Black `#000000`）。
  static const Color desktopRailBackground = surfaceBlack;

  /// 未读角标红（Apple System Red）。
  static const Color badgeRed = Color(0xFFFF3B30);

  /// 危险操作红（Apple System Red）。
  static const Color danger = Color(0xFFFF3B30);

  /// 红包橙金（功能语义色）。
  static const Color redPacketOrange = Color(0xFFFF9500);

  /// 红包已领取浅橙。
  static const Color redPacketClaimed = Color(0xFFFFD8A8);

  /// 链接蓝（Action Blue）。
  static const Color linkBlue = primary;
}
