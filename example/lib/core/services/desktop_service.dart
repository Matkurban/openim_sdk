import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_navite_auto_update/xue_hua_navite_auto_update.dart';
import 'package:xue_hua_navite_system_tray/xue_hua_navite_system_tray.dart';
import 'package:xue_hua_navite_window_manager/xue_hua_navite_window_manager.dart';

import '../events/im_event_bus.dart';
import '../events/im_message_event.dart';
import 'download_service.dart';

/// 桌面端增强服务（窗口管理、系统托盘与一键自动更新）。
///
/// Desktop enhancement service integrating window manager, system tray, and auto-update.
class DesktopService extends WireService with WindowListener {
  static final Logger _logger = Logger('DesktopService');

  /// 是否支持桌面端能力（macOS / Windows / Linux）。
  bool get isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  /// 托盘新消息通知开关。
  late final Signal<bool> trayNotificationsEnabled = createSignal<bool>(true);

  StreamSubscription<int>? _unreadSub;
  StreamSubscription<ImMessageEvent>? _msgSub;
  bool _trayInitialized = false;

  /// 初始化桌面窗口监听与系统托盘。
  Future<void> initialize() async {
    if (!isDesktop) {
      return;
    }
    try {
      XueHuaNaviteWindowManager.instance.addListener(this);
      await _initSystemTray();
      _bindTrayReactiveUpdates();
    } on Object catch (error, stackTrace) {
      _logger.warning('DesktopService initialize failed', error, stackTrace);
    }
  }

  Future<void> _initSystemTray() async {
    if (_trayInitialized) {
      return;
    }
    final XueHuaNaviteSystemTray tray = XueHuaNaviteSystemTray.instance;
    await tray.initSystemTray(
      TrayConfig(
        icon: TrayIconSource.system('message'),
        title: '',
        toolTip: 'OpenIM 聊天',
        menuItems: <TrayMenuItem>[
          TrayMenuItem.action(
            id: 'show_window',
            label: '显示主窗口',
            onTap: () {
              unawaited(tray.showMainWindow(focus: true));
            },
          ),
          TrayMenuItem.checkbox(
            id: 'toggle_notify',
            label: '新消息桌面提醒',
            checked: trayNotificationsEnabled.value,
            onChanged: (bool checked) {
              trayNotificationsEnabled.value = checked;
            },
          ),
          TrayMenuItem.separator(),
          TrayMenuItem.action(
            id: 'quit_app',
            label: '退出 OpenIM',
            onTap: () async {
              await tray.destroy();
              await XueHuaNaviteWindowManager.instance.destroy();
            },
          ),
        ],
      ),
    );
    _trayInitialized = true;
  }

  void _bindTrayReactiveUpdates() {
    final ImEventBus bus = Wire.find<ImEventBus>();
    _unreadSub?.cancel();
    _unreadSub = bus.totalUnreadStream.listen((int count) {
      if (!_trayInitialized) {
        return;
      }
      final String title = count > 0 ? ' ($count)' : '';
      unawaited(XueHuaNaviteSystemTray.instance.setTitle(title));
    });

    _msgSub?.cancel();
    _msgSub = bus.messageStream.listen((ImMessageEvent event) {
      if (!_trayInitialized || !trayNotificationsEnabled.value) {
        return;
      }
      if (event.kind == 'newMessage' && event.message != null) {
        final Message msg = event.message!;
        if (msg.sendID == OpenIM.iMManager.userID) {
          return;
        }
        unawaited(
          XueHuaNaviteSystemTray.instance.showNotification(
            TrayNotification(
              title: msg.senderNickname ?? '新消息',
              message: msg.textElem?.content ?? '[新消息]',
            ),
          ),
        );
      }
    });
  }

  /// 检查服务端最新版本并在桌面端执行自动更新流程。
  Future<void> checkForUpdates() async {
    FlutterToastPro.loading(message: '正在检查更新...');
    try {
      final String platform = switch (defaultTargetPlatform) {
        TargetPlatform.macOS => 'macos',
        TargetPlatform.windows => 'windows',
        TargetPlatform.linux => 'linux',
        TargetPlatform.iOS => 'ios',
        TargetPlatform.android => 'android',
        _ => 'web',
      };
      final ApplicationVersionInfo? latest = await OpenIM
          .iMManager
          .applicationManager
          .getLatestVersion(platform: platform);
      FlutterToastPro.hideLoading();

      if (latest == null || latest.url.isEmpty) {
        await FlutterToastPro.info('当前已是最新版本');
        return;
      }

      if (!isDesktop) {
        await FlutterToastPro.info('发现新版本 ${latest.version}，请前往应用商店更新');
        return;
      }

      final XueHuaNaviteAutoUpdate updater = XueHuaNaviteAutoUpdate.instance;
      final UpdateEnvironmentInfo env = await updater.checkEnvironment();
      if (!env.canAutoUpdate) {
        final String hint =
            env.blockReason == UpdateBlockReason.runningOnReadOnlyVolume ||
                env.blockReason == UpdateBlockReason.runningInAppTranslocation
            ? '请先将应用拖入 /Applications 目录后再执行自动更新'
            : '当前运行环境不支持自动更新（${env.blockReason.name}）';
        await FlutterToastPro.warning(hint);
        return;
      }

      final DownloadService downloader = Wire.find<DownloadService>();
      await downloader.enqueue(
        url: latest.url,
        fileName: 'openim_update_${latest.version}',
        group: 'app_updates',
      );
      await FlutterToastPro.success('发现新版本 ${latest.version}，已加入后台下载队列');
    } on Object catch (error, stackTrace) {
      FlutterToastPro.hideLoading();
      _logger.warning('checkForUpdates failed', error, stackTrace);
      await FlutterToastPro.error('检查更新失败：$error');
    }
  }

  /// 校验已下载安装包并触发桌面端脱离进程更新重启。
  Future<void> installDownloadedPackage({
    required String packagePath,
    String? expectedSha256,
  }) async {
    if (!isDesktop) {
      return;
    }
    final XueHuaNaviteAutoUpdate updater = XueHuaNaviteAutoUpdate.instance;
    if (expectedSha256 != null && expectedSha256.isNotEmpty) {
      final bool valid = await updater.verifyPackageChecksum(
        filePath: packagePath,
        expectedSha256: expectedSha256,
      );
      if (!valid) {
        await FlutterToastPro.error('安装包 SHA-256 校验未通过，已取消安装');
        return;
      }
    }
    await updater.installAndRelaunch(
      packagePath: packagePath,
      showProgressDialog: true,
      strings: const UpdateProgressStrings.zhCN(),
      relaunchArgs: const <String>['--updated'],
    );
  }

  @override
  void onWindowCloseRequested() {
    if (_trayInitialized) {
      unawaited(XueHuaNaviteSystemTray.instance.hideMainWindow());
    } else {
      unawaited(XueHuaNaviteWindowManager.instance.destroy());
    }
  }

  @override
  void onClose() {
    _unreadSub?.cancel();
    _msgSub?.cancel();
    if (isDesktop) {
      XueHuaNaviteWindowManager.instance.removeListener(this);
    }
    super.onClose();
  }
}
