import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../core/services/settings_service.dart';
import '../l10n/app_localizations.dart';
import '../shared/widgets/desktop_title_bar.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// OpenIM 示例应用根组件（挂载 `AdaptiveRouter`、`DesktopTitleBar`、`ToastScope`、标准 `AppLocalizations` 与动态主题）。
///
/// Root widget mounting `AdaptiveRouter`, global `DesktopTitleBar`, `ToastScope`,
/// standard `AppLocalizations`, and dynamic theme.
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
          onGenerateTitle: (BuildContext ctx) =>
              AppLocalizations.of(ctx)?.appName ?? 'OpenIM',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settings.themeMode.value,
          locale: settings.locale.value.toLocale(),
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            ...GlobalMaterialLocalizations.delegates,
            ...AppLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
          builder: (BuildContext ctx, Widget? child) {
            return ToastScope(
              child: Column(
                children: <Widget>[
                  DesktopTitleBar(
                    title: AppLocalizations.of(ctx)?.appName ?? 'OpenIM 聊天',
                  ),
                  Expanded(child: child ?? const SizedBox.shrink()),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
