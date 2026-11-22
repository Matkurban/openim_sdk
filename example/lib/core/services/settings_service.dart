import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_screen_protection/xue_hua_screen_protection.dart';

import '../../app/l10n/app_locale.dart';
import '../config/sdk_server_config.dart';

/// 全局设置服务（主题、多语言、屏幕保护、服务器配置）。
///
/// Global settings service managing theme, locale, screen protection, and server endpoints.
class SettingsService extends WireService {
  static final Logger _logger = Logger('SettingsService');

  static const String _keyTheme = 'example_theme_mode';
  static const String _keyLocale = 'example_locale';
  static const String _keyScreenProtection = 'example_screen_protection';
  static const String _keyServerConfig = 'example_server_config';

  /// 当前主题模式信号。
  late final Signal<ThemeMode> themeMode = createSignal<ThemeMode>(
    ThemeMode.system,
  );

  /// 当前界面语言信号。
  late final Signal<AppLocale> locale = createSignal<AppLocale>(AppLocale.zhCN);

  /// 屏幕保护开关信号。
  late final Signal<bool> screenProtectionEnabled = createSignal<bool>(false);

  /// SDK 服务端连接配置信号。
  late final Signal<SdkServerConfig> serverConfig =
      createSignal<SdkServerConfig>(const SdkServerConfig());

  StreamSubscription<Object>? _captureSub;
  StreamSubscription<bool>? _recordingSub;

  /// 从本地持久层加载设置并绑定屏幕保护事件监听。
  Future<void> loadSavedSettings() async {
    try {
      if (OpenIM.iMManager.isInitialized) {
        final dynamic savedTheme = await OpenIM.iMManager.getValue(
          _keyTheme,
          isGlobal: true,
        );
        if (savedTheme is String) {
          themeMode.value = _parseThemeMode(savedTheme);
        }
        final dynamic savedLocale = await OpenIM.iMManager.getValue(
          _keyLocale,
          isGlobal: true,
        );
        if (savedLocale is String) {
          locale.value = AppLocale.fromCode(savedLocale);
        }
        final dynamic savedProtection = await OpenIM.iMManager.getValue(
          _keyScreenProtection,
          isGlobal: true,
        );
        if (savedProtection is bool) {
          await setScreenProtection(savedProtection, persist: false);
        }
        final dynamic savedServer = await OpenIM.iMManager.getValue(
          _keyServerConfig,
          isGlobal: true,
        );
        if (savedServer is Map) {
          serverConfig.value = SdkServerConfig.fromMap(
            Map<String, dynamic>.from(savedServer),
          );
        }
      }
    } on Object catch (error, stackTrace) {
      _logger.warning('loadSavedSettings failed', error, stackTrace);
    }

    _bindScreenProtectionListeners();
  }

  /// 更新主题模式。
  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    if (OpenIM.iMManager.isInitialized) {
      await OpenIM.iMManager.setValue(_keyTheme, mode.name, isGlobal: true);
    }
  }

  /// 更新界面语言。
  Future<void> setLocale(AppLocale nextLocale) async {
    locale.value = nextLocale;
    if (OpenIM.iMManager.isInitialized) {
      await OpenIM.iMManager.setValue(
        _keyLocale,
        nextLocale.storageCode,
        isGlobal: true,
      );
    }
  }

  /// 开启或关闭屏幕保护（防截屏/录屏 + 切后台模糊遮罩）。
  Future<void> setScreenProtection(bool enabled, {bool persist = true}) async {
    screenProtectionEnabled.value = enabled;
    try {
      final XueHuaScreenProtection protection = XueHuaScreenProtection.instance;
      if (enabled) {
        await protection.enableSecureScreen();
        await protection.configureAppSwitcherProtection(
          const ScreenProtectionMaskConfig(
            enabled: true,
            style: ScreenProtectionMaskStyle.blur,
          ),
        );
        if (kIsWeb) {
          await protection.configureWebProtection(
            const WebProtectionConfig(
              disablePrint: true,
              disableContextMenu: true,
              interceptCaptureShortcuts: true,
            ),
          );
        }
      } else {
        await protection.disableSecureScreen();
        await protection.configureAppSwitcherProtection(
          const ScreenProtectionMaskConfig(enabled: false),
        );
      }
    } on Object catch (error, stackTrace) {
      _logger.warning('setScreenProtection failed', error, stackTrace);
    }
    if (persist && OpenIM.iMManager.isInitialized) {
      await OpenIM.iMManager.setValue(
        _keyScreenProtection,
        enabled,
        isGlobal: true,
      );
    }
  }

  /// 保存新的服务器连接地址。
  Future<void> updateServerConfig(SdkServerConfig nextConfig) async {
    serverConfig.value = nextConfig;
    if (OpenIM.iMManager.isInitialized) {
      await OpenIM.iMManager.setValue(
        _keyServerConfig,
        nextConfig.toMap(),
        isGlobal: true,
      );
    }
  }

  void _bindScreenProtectionListeners() {
    try {
      final XueHuaScreenProtection protection = XueHuaScreenProtection.instance;
      _captureSub?.cancel();
      _captureSub = protection.onScreenCaptured.listen((Object _) {
        FlutterToastPro.warning('检测到屏幕截屏行为，请注意隐私安全');
      });
      _recordingSub?.cancel();
      _recordingSub = protection.onScreenRecordingChanged.listen((
        bool isRecording,
      ) {
        if (isRecording) {
          FlutterToastPro.warning('检测到正在录屏，敏感内容已自动保护');
        }
      });
    } on Object catch (error, stackTrace) {
      _logger.fine(
        'Screen protection listeners unavailable',
        error,
        stackTrace,
      );
    }
  }

  ThemeMode _parseThemeMode(String raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  void onClose() {
    _captureSub?.cancel();
    _recordingSub?.cancel();
    super.onClose();
  }
}
