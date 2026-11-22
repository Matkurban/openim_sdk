import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_navite_cache_manager/xue_hua_navite_cache_manager.dart';
import 'package:xue_hua_navite_volume_controller/xue_hua_navite_volume_controller.dart';

import '../config/sdk_server_config.dart';
import '../events/im_event_bus.dart';
import 'auth_session_service.dart';
import 'badge_service.dart';
import 'desktop_service.dart';
import 'download_service.dart';
import 'media_service.dart';
import 'settings_service.dart';
import 'sharing_receive_service.dart';

/// 应用冷启动全局初始化编排服务。
///
/// Cold-start global bootstrap orchestrator service.
class AppBootstrapService extends WireService {
  static final Logger _logger = Logger('AppBootstrapService');

  bool _bootstrapped = false;

  /// 注册全部全局常驻 `WireService` 实例（幂等）。
  static void registerCoreServices() {
    if (!Wire.isRegistered<ImEventBus>()) {
      Wire.put<ImEventBus>(ImEventBus());
    }
    if (!Wire.isRegistered<SettingsService>()) {
      Wire.put<SettingsService>(SettingsService());
    }
    if (!Wire.isRegistered<BadgeService>()) {
      Wire.put<BadgeService>(BadgeService());
    }
    if (!Wire.isRegistered<DownloadService>()) {
      Wire.put<DownloadService>(DownloadService());
    }
    if (!Wire.isRegistered<SharingReceiveService>()) {
      Wire.put<SharingReceiveService>(SharingReceiveService());
    }
    if (!Wire.isRegistered<MediaService>()) {
      Wire.put<MediaService>(MediaService());
    }
    if (!Wire.isRegistered<DesktopService>()) {
      Wire.put<DesktopService>(DesktopService());
    }
    if (!Wire.isRegistered<AuthSessionService>()) {
      Wire.put<AuthSessionService>(AuthSessionService());
    }
    if (!Wire.isRegistered<AppBootstrapService>()) {
      Wire.put<AppBootstrapService>(AppBootstrapService());
    }
  }

  /// 执行启动页全链路初始化并返回是否已自动登录。
  Future<bool> bootstrap() async {
    if (_bootstrapped) {
      return Wire.find<AuthSessionService>().isLoggedIn.value;
    }

    await _initCacheManager();
    await _initVolumeController();
    await _initOpenImSdk(Wire.find<SettingsService>().serverConfig.value);

    await Wire.find<SettingsService>().loadSavedSettings();
    await Wire.find<AuthSessionService>().initialize();
    await Wire.find<BadgeService>().initialize();
    await Wire.find<DownloadService>().initialize();
    await Wire.find<MediaService>().initialize();
    await Wire.find<DesktopService>().initialize();
    await Wire.find<SharingReceiveService>().initialize();

    _bootstrapped = true;
    final bool restored = await Wire.find<AuthSessionService>()
        .tryRestoreSession();
    _logger.info('Bootstrap completed (restored=$restored)');
    return restored;
  }

  /// 修改服务器配置后重新初始化 SDK。
  Future<void> reinitializeSdk(SdkServerConfig config) async {
    await Wire.find<SettingsService>().updateServerConfig(config);
    if (OpenIM.iMManager.isInitialized) {
      await OpenIM.iMManager.unInitSDK();
    }
    await _initOpenImSdk(config);
  }

  Future<void> _initCacheManager() async {
    try {
      await XueHuaNaviteCacheManager.instance.configure(
        const CacheManagerConfig(
          maxDiskCacheBytes: 500 * 1024 * 1024,
          maxEntries: 20000,
          defaultTtlSeconds: 7 * 24 * 3600,
          evictionPolicy: CacheEvictionPolicy.lru,
          cacheSubdirectory: 'openim_example_cache',
          respectHttpCacheHeaders: true,
          autoTrimOnWrite: true,
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.warning('CacheManager configure failed', error, stackTrace);
    }
  }

  Future<void> _initVolumeController() async {
    try {
      await XueHuaNaviteVolumeController.instance.initialize(
        const VolumeControllerConfig(),
      );
    } on Object catch (error, stackTrace) {
      _logger.fine('VolumeController init skipped', error, stackTrace);
    }
  }

  Future<void> _initOpenImSdk(SdkServerConfig config) async {
    final ImEventBus bus = Wire.find<ImEventBus>();
    if (!OpenIM.iMManager.isInitialized) {
      await OpenIM.iMManager.initSDK(
        apiAddr: config.apiAddr,
        wsAddr: config.wsAddr,
        authAddr: config.authAddr,
        adminAddr: config.adminAddr,
        listener: bus.createConnectListener(),
        logLevel: Level.INFO,
      );
    }
    bus.bindSdkListeners();
  }
}
