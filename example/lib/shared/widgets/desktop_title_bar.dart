import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_navite_window_manager/xue_hua_navite_window_manager.dart';

/// 桌面端全局无边框窗口标题栏（挂载在 `MaterialApp.builder` 顶层，避免任何页面的 `AppBar` 与系统红绿灯重叠）。
///
/// Global desktop frameless window title bar mounted in `MaterialApp.builder`
/// so page `AppBar`s never collide with macOS traffic lights or Windows/Linux window controls.
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
    return Material(
      color: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          WindowCaption(
            height: 40.0,
            macosTrafficLightsReservedWidth: 78.0,
            backgroundColor: Colors.transparent,
            foregroundColor: theme.appBarTheme.foregroundColor,
            title: Padding(
              padding: EdgeInsets.only(left: isMacOS ? 4.0 : 12.0),
              child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            actions: actions,
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
