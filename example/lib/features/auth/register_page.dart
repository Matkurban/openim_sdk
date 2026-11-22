import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/desktop_title_bar.dart';
import 'register_controller.dart';

/// 邮箱注册页（仅支持邮箱 + 验证码 + 昵称 + 密码注册）。
///
/// Email-only registration page.
class RegisterPage extends StatefulWidget {
  /// 创建注册页。
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with WireStateMixin<RegisterPage, RegisterController> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _inviteController = TextEditingController();

  @override
  RegisterController? wire() => RegisterController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    final bool? autoLoggedIn = await controller.submit(
      email: _emailController.text,
      nickname: _nicknameController.text,
      password: _passwordController.text,
      code: _codeController.text,
      invitationCode: _inviteController.text,
    );
    if (autoLoggedIn == null || !mounted) {
      return;
    }
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    if (autoLoggedIn) {
      await router.pushNamedAndRemoveUntil(
        AppRoutes.conversations,
        (AdaptiveRouteMatch _) => false,
      );
    } else {
      await router.pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('邮箱注册')),
      body: Column(
        children: <Widget>[
          const DesktopTitleBar(title: '邮箱注册'),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: SignalBuilder(
                    builder: (BuildContext _) {
                      final int sec = controller.countdown.value;
                      final bool loading = controller.submitting.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: '邮箱地址',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: _codeController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: '邮箱验证码',
                                    prefixIcon: Icon(
                                      Icons.verified_user_outlined,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: sec > 0
                                      ? null
                                      : () => controller.sendCode(
                                          _emailController.text,
                                        ),
                                  child: Text(sec > 0 ? '${sec}s' : '获取验证码'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _nicknameController,
                            decoration: const InputDecoration(
                              labelText: '昵称',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: '设置登录密码',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _inviteController,
                            decoration: const InputDecoration(
                              labelText: '邀请码（选填）',
                              prefixIcon: Icon(Icons.card_giftcard_outlined),
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: loading ? null : _onRegister,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(loading ? '注册中...' : '完成注册'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
