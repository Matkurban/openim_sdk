import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_cache_manager/xue_hua_navite_cache_manager.dart';

import '../../app/l10n/app_locale.dart';
import '../../app/router/app_routes.dart';
import '../../core/services/desktop_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/utils/date_time_formatter.dart';
import '../../shared/widgets/server_config_dialog.dart';

/// 通用与安全设置页（主题、语言、屏幕保护、缓存管理、检查更新、设备信息、下载管理、账号安全）。
///
/// General & security settings page.
class SettingsPage extends StatefulWidget {
  /// 创建设置页。
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final Signal<String> _cacheSummary = signal<String>('统计中...');

  @override
  void initState() {
    super.initState();
    _loadCacheStats();
  }

  Future<void> _loadCacheStats() async {
    try {
      final CacheStats stats = await XueHuaNaviteCacheManager.instance
          .getStats();
      if (mounted) {
        _cacheSummary.value =
            '${DateTimeFormatter.formatBytes(stats.totalBytes)} (${stats.totalEntries} 条)';
      }
    } on Object catch (_) {
      if (mounted) {
        _cacheSummary.value = '0 B';
      }
    }
  }

  Future<void> _clearCache() async {
    await XueHuaNaviteCacheManager.instance.clearAll();
    await _loadCacheStats();
    await FlutterToastPro.success('缓存已清理完成');
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final SettingsService settings = Wire.find<SettingsService>();
    final DesktopService desktop = Wire.find<DesktopService>();
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('通用与安全设置')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final ThemeMode mode = settings.themeMode.value;
          final AppLocale loc = settings.locale.value;
          final bool protect = settings.screenProtectionEnabled.value;
          final String cacheSummary = _cacheSummary.value;

          return ListView(
            children: <Widget>[
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.brightness_6_outlined),
                title: const Text('主题模式'),
                trailing: SegmentedButton<ThemeMode>(
                  segments: const <ButtonSegment<ThemeMode>>[
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('浅色'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('深色'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text('系统'),
                    ),
                  ],
                  selected: <ThemeMode>{mode},
                  onSelectionChanged: (Set<ThemeMode> next) {
                    settings.setThemeMode(next.first);
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.language_outlined),
                title: const Text('界面语言'),
                trailing: SegmentedButton<AppLocale>(
                  segments: const <ButtonSegment<AppLocale>>[
                    ButtonSegment<AppLocale>(
                      value: AppLocale.zhCN,
                      label: Text('中文'),
                    ),
                    ButtonSegment<AppLocale>(
                      value: AppLocale.enUS,
                      label: Text('EN'),
                    ),
                  ],
                  selected: <AppLocale>{loc},
                  onSelectionChanged: (Set<AppLocale> next) {
                    settings.setLocale(next.first);
                  },
                ),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                tileColor: theme.colorScheme.surface,
                secondary: const Icon(Icons.security_outlined),
                title: const Text('屏幕保护（防截屏 / 录屏与切后台模糊）'),
                value: protect,
                onChanged: (bool v) => settings.setScreenProtection(v),
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.shield_outlined),
                title: const Text('账号与安全'),
                subtitle: const Text('修改密码、支付密码、黑名单、账号申诉、注销'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.accountSecurity,
                  (AdaptiveRouteMatch m) =>
                      m.matchedLocation == AppRoutes.settings,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.cleaning_services_outlined),
                title: const Text('缓存管理与清理'),
                subtitle: Text('当前媒体缓存：$cacheSummary'),
                trailing: TextButton(
                  onPressed: _clearCache,
                  child: const Text('一键清理'),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.download_for_offline_outlined),
                title: const Text('后台下载管理'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.downloads,
                  (AdaptiveRouteMatch m) =>
                      m.matchedLocation == AppRoutes.settings,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.devices_outlined),
                title: const Text('设备信息'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.deviceInfo,
                  (AdaptiveRouteMatch m) =>
                      m.matchedLocation == AppRoutes.settings,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.system_update_outlined),
                title: const Text('检查更新'),
                subtitle: Text(
                  desktop.isDesktop ? '桌面端支持一键校验与自动重启更新' : '检查服务端最新版本',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: desktop.checkForUpdates,
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.dns_outlined),
                title: const Text('服务器地址配置'),
                subtitle: Text(settings.serverConfig.value.apiAddr),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => ServerConfigDialog.show(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
