import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_navite_window_manager/xue_hua_navite_window_manager.dart';

import 'app/app.dart';
import 'app/theme/app_colors.dart';
import 'core/services/app_bootstrap_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord record) {
    debugPrint(
      '[${record.level.name}] ${record.loggerName}: ${record.message}'
      '${record.error != null ? ' | ${record.error}' : ''}',
    );
  });

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    try {
      await XueHuaNaviteWindowManager.configure(
        const WindowConfig(
          size: Size(1160, 760),
          minSize: Size(840, 600),
          center: true,
          title: 'OpenIM 聊天',
          titleBarStyle: TitleBarStyle.hidden,
          trafficLightsOffset: Offset(14, 13),
          trafficLightsVisible: true,
          backgroundColor: AppColors.lightBackground,
          alwaysOnTop: false,
          resizable: true,
          preventClose: true,
          hasShadow: true,
          resizeBorderWidth: 6.0,
          showWhenReady: true,
        ),
      );
    } on Object catch (error) {
      debugPrint('WindowManager configure skipped: $error');
    }
  }

  AppBootstrapService.registerCoreServices();
  runApp(const OpenImExampleApp());
}
