import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_navite_window_manager/xue_hua_navite_window_manager.dart';

/// 桌面端自定义无边框窗口标题栏（严格遵循 `xue_hua_navite_window_manager` 的 `WindowCaption` 规范）。
///
/// Desktop custom frameless window title bar built directly with `WindowCaption`
/// (without nesting duplicate `DragArea` or duplicating macOS traffic-light insets).
class DesktopTitleBar extends StatelessWidget {
  /// 标题文字。
  final String title;

  /// 标题栏右侧扩展操作按钮（位于 Windows/Linux 窗口控制按钮左侧）。
  final List<Widget> actions;

  /// 创建桌面标题栏组件。
  const DesktopTitleBar({
    super.key,
    this.title = 'OpenIM',
    this.actions = const <Widget>[],
  });

  bool get _isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  @override
  Widget build(BuildContext context) {
    if (!_isDesktop) {
      return const SizedBox.shrink();
    }
    final ThemeData theme = Theme.of(context);
    final bool isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        WindowCaption(
          height: 40.0,
          macosTrafficLightsReservedWidth: 78.0,
          backgroundColor: theme.appBarTheme.backgroundColor,
          foregroundColor: theme.appBarTheme.foregroundColor,
          title: Padding(
            padding: EdgeInsets.only(left: isMacOS ? 4.0 : 12.0),
            child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          actions: actions,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
