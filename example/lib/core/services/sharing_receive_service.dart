import 'dart:async';

import 'package:logging/logging.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_navite_accept_sharing/xue_hua_navite_accept_sharing.dart';

/// 接收外部软件分享内容服务（基于 `xue_hua_navite_accept_sharing`）。
///
/// Incoming external OS share payload service powered by `xue_hua_navite_accept_sharing`.
class SharingReceiveService extends WireService {
  static final Logger _logger = Logger('SharingReceiveService');

  /// 待用户选择会话发送的外部分享负载信号。
  late final Signal<SharedPayload?> pendingPayload =
      createSignal<SharedPayload?>(null);

  StreamSubscription<SharedPayload>? _shareSub;

  /// 检查冷启动分享负载并订阅热启动分享流。
  Future<void> initialize() async {
    try {
      const XueHuaNaviteAcceptSharing sharing =
          XueHuaNaviteAcceptSharing.instance;
      final SharedPayload? initial = await sharing.getInitialSharing();
      if (initial != null && initial.items.isNotEmpty) {
        pendingPayload.value = initial;
        await sharing.clearInitialSharing();
      }
      _shareSub?.cancel();
      _shareSub = sharing.onSharingReceived.listen((SharedPayload payload) {
        if (payload.items.isNotEmpty) {
          pendingPayload.value = payload;
        }
      });
    } on Object catch (error, stackTrace) {
      _logger.fine('SharingReceiveService init skipped', error, stackTrace);
    }
  }

  /// 消费当前分享负载并清理临时沙盒文件。
  Future<void> clearPending() async {
    pendingPayload.value = null;
    try {
      await XueHuaNaviteAcceptSharing.instance.cleanupTempFiles();
    } on Object catch (error, stackTrace) {
      _logger.fine('cleanupTempFiles skipped', error, stackTrace);
    }
  }

  @override
  void onClose() {
    _shareSub?.cancel();
    super.onClose();
  }
}
