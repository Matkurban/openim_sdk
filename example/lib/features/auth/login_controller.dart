import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:logging/logging.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../core/services/auth_session_service.dart';

/// 登录页控制器：支持「邮箱 + 密码」与「账号 + 密码」二选一登录。
///
/// Login controller supporting Email+Password or Account+Password authentication.
class LoginController extends WireController {
  static final Logger _logger = Logger('LoginController');

  /// 是否使用邮箱登录（`true` 为邮箱+密码，`false` 为账号+密码）。
  late final Signal<bool> useEmailLogin = createSignal<bool>(true);

  /// 是否正在提交登录请求。
  late final Signal<bool> submitting = createSignal<bool>(false);

  /// 密码可见性开关。
  late final Signal<bool> obscurePassword = createSignal<bool>(true);

  /// 执行登录。
  Future<bool> submit({
    required String identifier,
    required String password,
  }) async {
    final String id = identifier.trim();
    if (id.isEmpty || password.isEmpty) {
      await FlutterToastPro.warning('请输入完整的登录信息');
      return false;
    }
    submitting.value = true;
    FlutterToastPro.loading(message: '正在登录...');
    try {
      final AuthSessionService auth = Wire.find<AuthSessionService>();
      if (useEmailLogin.value) {
        await auth.loginByEmail(email: id, password: password);
      } else {
        await auth.loginByAccount(account: id, password: password);
      }
      FlutterToastPro.hideLoading();
      await FlutterToastPro.success('登录成功');
      return true;
    } on Object catch (error, stackTrace) {
      FlutterToastPro.hideLoading();
      _logger.warning('Login failed', error, stackTrace);
      await FlutterToastPro.error('登录失败：$error');
      return false;
    } finally {
      submitting.value = false;
    }
  }
}
