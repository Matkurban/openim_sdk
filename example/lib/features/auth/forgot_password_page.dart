import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../core/services/auth_session_service.dart';

/// 忘记密码页：通过邮箱验证码重置登录密码。
///
/// Forgot-password page resetting password via email verification code.
class ForgotPasswordPage extends StatefulWidget {
  /// 创建忘记密码页。
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  late final Signal<bool> _submitting = signal<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      await FlutterToastPro.warning('请输入邮箱');
      return;
    }
    try {
      await Wire.find<AuthSessionService>().sendEmailCode(
        email: email,
        usedFor: 2,
      );
      await FlutterToastPro.success('重置验证码已发送');
    } on Object catch (error) {
      await FlutterToastPro.error('发送失败：$error');
    }
  }

  Future<void> _reset() async {
    _submitting.value = true;
    try {
      await OpenIM.iMManager.userManager.resetPassword(
        email: _emailController.text.trim(),
        verifyCode: _codeController.text.trim(),
        newPassword: _newPasswordController.text,
      );
      await FlutterToastPro.success('密码重置成功，请重新登录');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('重置失败：$error');
    } finally {
      if (mounted) {
        _submitting.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('忘记密码')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: '注册邮箱'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        decoration: const InputDecoration(labelText: '验证码'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: _sendCode,
                      child: const Text('获取验证码'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: '新密码'),
                ),
                const SizedBox(height: 24),
                SignalBuilder(
                  builder: (BuildContext _) {
                    final bool submitting = _submitting.value;
                    return FilledButton(
                      onPressed: submitting ? null : _reset,
                      child: Text(submitting ? '提交中...' : '重置密码'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
