import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../core/events/im_connection_event.dart';
import '../../core/events/im_event_bus.dart';
import '../../core/events/im_social_event.dart';

/// 主框架控制器：聚合总未读数、连接横幅、待处理申请角标与来电提醒。
///
/// Main shell controller aggregating unread counts, connection state, and incoming calls.
class MainShellController extends WireController {
  static final Logger _logger = Logger('MainShellController');

  /// 会话总未读数信号。
  late final Signal<int> totalUnread = createSignal<int>(0);

  /// 联系人待处理申请总数（好友 + 群通知）。
  late final Signal<int> contactPendingCount = createSignal<int>(0);

  /// 连接状态提示文案（正常连接时为空字符串）。
  late final Signal<String> connectionBanner = createSignal<String>('');

  /// 来电会话信号（非空时提示弹出 `CallOverlayPage`）。
  late final Signal<CallSession?> incomingCall = createSignal<CallSession?>(
    null,
  );

  StreamSubscription<int>? _unreadSub;
  StreamSubscription<ImConnectionEvent>? _connSub;
  StreamSubscription<ImSocialEvent>? _socialSub;

  @override
  void onInit() {
    super.onInit();
    final ImEventBus bus = Wire.find<ImEventBus>();
    totalUnread.value = bus.totalUnreadStream.value;

    _unreadSub = bus.totalUnreadStream.listen((int count) {
      totalUnread.value = count;
    });
    _connSub = bus.connectionStream.listen((ImConnectionEvent event) {
      switch (event.kind) {
        case 'connecting':
          connectionBanner.value = '正在连接服务器...';
        case 'connected':
          connectionBanner.value = '';
        case 'failed':
          connectionBanner.value = '连接失败：${event.message ?? ''}';
        case 'kickedOffline':
          connectionBanner.value = '账号已在其他设备登录';
          FlutterToastPro.warning('账号已在其他设备登录');
        case 'tokenExpired':
        case 'tokenInvalid':
          connectionBanner.value = '登录状态已失效，请重新登录';
          FlutterToastPro.warning('登录凭证失效，请重新登录');
        default:
          break;
      }
    });
    _socialSub = bus.socialStream.listen((ImSocialEvent event) {
      if (event.kind == 'incomingCall' && event.callSession != null) {
        incomingCall.value = event.callSession;
      }
    });
    unawaited(refreshPendingCounts());
  }

  /// 刷新好友申请与入群申请未处理红点数。
  Future<void> refreshPendingCounts() async {
    try {
      final int friendCount = await OpenIM.iMManager.friendshipManager
          .getFriendApplicationUnhandledCount();
      final int groupCount = await OpenIM.iMManager.groupManager
          .getGroupApplicationUnhandledCount(
            GetGroupApplicationUnhandledCountReq(),
          );
      contactPendingCount.value = friendCount + groupCount;
    } on Object catch (error, stackTrace) {
      _logger.fine('refreshPendingCounts skipped', error, stackTrace);
    }
  }

  /// 消费来电弹窗信号。
  void clearIncomingCall() {
    incomingCall.value = null;
  }

  @override
  void onClose() {
    _unreadSub?.cancel();
    _connSub?.cancel();
    _socialSub?.cancel();
    super.onClose();
  }
}
