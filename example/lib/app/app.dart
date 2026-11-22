import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../core/services/settings_service.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// OpenIM 示例应用根组件（挂载 `AdaptiveRouter`、`ToastScope`、动态主题与多语言）。
///
/// Root widget mounting `AdaptiveRouter`, `ToastScope`, dynamic theme, and locale.
class OpenImExampleApp extends StatefulWidget {
  /// 创建应用根组件。
  const OpenImExampleApp({super.key});

  @override
  State<OpenImExampleApp> createState() => _OpenImExampleAppState();
}

class _OpenImExampleAppState extends State<OpenImExampleApp> {
  late final AdaptiveRouter _router = AppRouter.create();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsService settings = Wire.find<SettingsService>();
    return SignalBuilder(
      builder: (BuildContext _) {
        return MaterialApp.router(
          title: settings.tr('app_name'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settings.themeMode.value,
          locale: settings.locale.value.toLocale(),
          routerConfig: _router,
          builder: (BuildContext _, Widget? child) {
            return ToastScope(child: child ?? const SizedBox.shrink());
          },
        );
      },
    );
  }
}
