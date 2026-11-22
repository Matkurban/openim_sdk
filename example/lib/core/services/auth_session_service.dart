import 'dart:async';

import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_device_info/xue_hua_device_info.dart';

import '../events/im_event_bus.dart';
import '../events/im_user_event.dart';
import 'badge_service.dart';

/// 鉴权与当前登录会话服务。
///
/// Authentication and active user session service.
class AuthSessionService extends WireService {
  static final Logger _logger = Logger('AuthSessionService');

  /// 当前登录用户信息信号。
  late final Signal<UserInfo?> currentUser = createSignal<UserInfo?>(null);

  /// 当前设备唯一标识（由 `xue_hua_device_info` 提供）。
  late final Signal<String> deviceID = createSignal<String>('openim_device');

  /// 是否已登录计算信号。
  late final Computed<bool> isLoggedIn = createComputed<bool>(
    () => currentUser.value != null && currentUser.value!.userID.isNotEmpty,
  );

  StreamSubscription<ImUserEvent>? _userSub;

  /// 初始化设备标识并订阅当前用户资料更新事件。
  Future<void> initialize() async {
    try {
      final DeviceInfo info = await XueHuaDeviceInfo.getDeviceInfo();
      final String? id = info.deviceId ?? info.model ?? info.name;
      if (id != null && id.trim().isNotEmpty) {
        deviceID.value = id.trim();
      }
    } on Object catch (error, stackTrace) {
      _logger.fine('getDeviceInfo fallback used', error, stackTrace);
    }

    final ImEventBus bus = Wire.find<ImEventBus>();
    _userSub?.cancel();
    _userSub = bus.userStream.listen((ImUserEvent event) {
      if (event.kind == 'selfInfoUpdated' && event.selfInfo != null) {
        currentUser.value = event.selfInfo;
      }
    });
  }

  /// 检查本地持久化登录态并恢复当前用户信息。
  Future<bool> tryRestoreSession() async {
    try {
      final LoginStatus status = await OpenIM.iMManager.loadLoginConfig();
      if (status == LoginStatus.logged) {
        final UserInfo? self = await OpenIM.iMManager.userManager
            .getSelfUserInfo();
        currentUser.value = self ?? OpenIM.iMManager.userInfo;
        await _refreshUnreadCount();
        return true;
      }
    } on Object catch (error, stackTrace) {
      _logger.warning('tryRestoreSession failed', error, stackTrace);
    }
    return false;
  }

  /// 邮箱 + 密码登录。
  Future<UserInfo> loginByEmail({
    required String email,
    required String password,
  }) async {
    final UserInfo user = await OpenIM.iMManager.loginByEmail(
      email: email.trim(),
      password: password,
    );
    currentUser.value = user;
    await _refreshUnreadCount();
    return user;
  }

  /// 账号 + 密码登录。
  Future<UserInfo> loginByAccount({
    required String account,
    required String password,
  }) async {
    final UserInfo user = await OpenIM.iMManager.loginByAccount(
      account: account.trim(),
      password: password,
    );
    currentUser.value = user;
    await _refreshUnreadCount();
    return user;
  }

  /// 发送邮箱验证码（`usedFor`: 1=注册, 2=重置密码, 3=登录）。
  Future<void> sendEmailCode({
    required String email,
    required int usedFor,
    String? invitationCode,
  }) async {
    await OpenIM.iMManager.userManager.sendVerificationCode(
      email: email.trim(),
      usedFor: usedFor,
      invitationCode: invitationCode,
    );
  }

  /// 邮箱注册。
  Future<AuthCacheData?> registerByEmail({
    required String email,
    required String nickname,
    required String password,
    required String verificationCode,
    String? invitationCode,
    bool autoLogin = true,
  }) async {
    final AuthCacheData? data = await OpenIM.iMManager.userManager.register(
      nickname: nickname.trim(),
      password: password,
      email: email.trim(),
      verificationCode: verificationCode.trim(),
      invitationCode: invitationCode?.trim().isNotEmpty == true
          ? invitationCode!.trim()
          : null,
      autoLogin: autoLogin,
      deviceID: deviceID.value,
    );
    if (autoLogin && OpenIM.iMManager.getLoginStatus == LoginStatus.logged) {
      currentUser.value = OpenIM.iMManager.userInfo;
      await _refreshUnreadCount();
    }
    return data;
  }

  /// 刷新当前登录用户资料。
  Future<void> refreshSelfInfo() async {
    final UserInfo? info = await OpenIM.iMManager.userManager.getSelfUserInfo();
    if (info != null) {
      currentUser.value = info;
    }
  }

  /// 退出登录并重置本地角标与会话态。
  Future<void> logout() async {
    try {
      await OpenIM.iMManager.logout();
    } on Object catch (error, stackTrace) {
      _logger.warning('SDK logout warning', error, stackTrace);
    }
    currentUser.value = null;
    Wire.find<ImEventBus>().updateTotalUnread(0);
    await Wire.find<BadgeService>().syncCount(0);
  }

  Future<void> _refreshUnreadCount() async {
    try {
      final int unread = await OpenIM.iMManager.conversationManager
          .getTotalUnreadMsgCount();
      Wire.find<ImEventBus>().updateTotalUnread(unread);
    } on Object catch (error, stackTrace) {
      _logger.fine('refreshUnreadCount skipped', error, stackTrace);
    }
  }

  @override
  void onClose() {
    _userSub?.cancel();
    super.onClose();
  }
}
