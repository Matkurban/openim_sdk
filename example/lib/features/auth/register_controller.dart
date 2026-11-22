import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../core/services/auth_session_service.dart';

/// 邮箱注册页控制器。
///
/// Email registration controller with verification code countdown.
class RegisterController extends WireController {
  static final Logger _logger = Logger('RegisterController');

  /// 发送验证码倒计时（秒）。
  late final Signal<int> countdown = createSignal<int>(0);

  /// 是否正在提交注册。
  late final Signal<bool> submitting = createSignal<bool>(false);

  Timer? _timer;

  /// 发送注册邮箱验证码（`usedFor: 1`）。
  Future<void> sendCode(String email) async {
    final String trimmed = email.trim();
    if (trimmed.isEmpty || !trimmed.contains('@')) {
      await FlutterToastPro.warning('请输入有效的邮箱地址');
      return;
    }
    try {
      await Wire.find<AuthSessionService>().sendEmailCode(
        email: trimmed,
        usedFor: 1,
      );
      await FlutterToastPro.success('验证码已发送至邮箱');
      countdown.value = 60;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (countdown.value <= 1) {
          countdown.value = 0;
          timer.cancel();
        } else {
          countdown.value = countdown.value - 1;
        }
      });
    } on Object catch (error, stackTrace) {
      _logger.warning('sendCode failed', error, stackTrace);
      await FlutterToastPro.error('发送验证码失败：$error');
    }
  }

  /// 提交邮箱注册，返回是否已自动登录进入主页。
  Future<bool?> submit({
    required String email,
    required String nickname,
    required String password,
    required String code,
    String? invitationCode,
  }) async {
    if (email.trim().isEmpty ||
        nickname.trim().isEmpty ||
        password.isEmpty ||
        code.trim().isEmpty) {
      await FlutterToastPro.warning('请填写完整的注册信息');
      return null;
    }
    submitting.value = true;
    FlutterToastPro.loading(message: '正在注册账号...');
    try {
      final AuthSessionService auth = Wire.find<AuthSessionService>();
      await auth.registerByEmail(
        email: email,
        nickname: nickname,
        password: password,
        verificationCode: code,
        invitationCode: invitationCode,
        autoLogin: true,
      );
      FlutterToastPro.hideLoading();
      await FlutterToastPro.success('注册成功');
      return OpenIM.iMManager.getLoginStatus == LoginStatus.logged;
    } on Object catch (error, stackTrace) {
      FlutterToastPro.hideLoading();
      _logger.warning('Register failed', error, stackTrace);
      await FlutterToastPro.error('注册失败：$error');
      return null;
    } finally {
      submitting.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
