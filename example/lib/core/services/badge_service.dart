import 'dart:async';

import 'package:logging/logging.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_app_badge/xue_hua_app_badge.dart';

import '../events/im_event_bus.dart';

/// 应用未读角标同步服务（订阅 [ImEventBus] 总未读数并同步至 `xue_hua_app_badge`）。
///
/// Application icon badge sync service powered by `xue_hua_app_badge`.
class BadgeService extends WireService {
  static final Logger _logger = Logger('BadgeService');

  StreamSubscription<int>? _unreadSub;
  bool _supported = false;

  /// 初始化角标能力并订阅全局总未读数。
  Future<void> initialize() async {
    try {
      final XueHuaAppBadge badge = XueHuaAppBadge.instance;
      _supported = await badge.isSupported();
      if (_supported) {
        final bool granted = await badge.isPermissionGranted();
        if (!granted) {
          await badge.requestPermission();
        }
      }
    } on Object catch (error, stackTrace) {
      _logger.fine('App badge init skipped', error, stackTrace);
    }

    final ImEventBus bus = Wire.find<ImEventBus>();
    _unreadSub?.cancel();
    _unreadSub = bus.totalUnreadStream.listen((int count) {
      unawaited(syncCount(count));
    });
  }

  /// 更新或清空应用图标未读数。
  Future<void> syncCount(int count) async {
    if (!_supported) {
      return;
    }
    try {
      final XueHuaAppBadge badge = XueHuaAppBadge.instance;
      if (count <= 0) {
        await badge.remove();
      } else {
        await badge.set(count);
      }
    } on Object catch (error, stackTrace) {
      _logger.fine('syncCount failed', error, stackTrace);
    }
  }

  @override
  void onClose() {
    _unreadSub?.cancel();
    super.onClose();
  }
}
