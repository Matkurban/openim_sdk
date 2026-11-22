import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_navite_window_manager/xue_hua_navite_window_manager.dart';

/// 桌面端自定义无边框窗口标题栏（基于 `xue_hua_navite_window_manager`）。
///
/// Desktop custom frameless window title bar powered by `xue_hua_navite_window_manager`.
class DesktopTitleBar extends StatelessWidget {
  /// 标题文字。
  final String title;

  /// 创建桌面标题栏组件。
  const DesktopTitleBar({super.key, this.title = 'OpenIM'});

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
    return WindowCaption(
      backgroundColor: theme.appBarTheme.backgroundColor,
      height: 72,
      title: DragArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: defaultTargetPlatform == TargetPlatform.macOS ? 76 : 12,
            ),
            child: Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
