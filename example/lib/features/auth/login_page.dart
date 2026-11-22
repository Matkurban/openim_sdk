import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/desktop_title_bar.dart';
import '../../shared/widgets/server_config_dialog.dart';
import 'login_controller.dart';

/// 登录页：支持「邮箱 + 密码」与「账号 + 密码」二选一登录。
///
/// Login page with Email+Password and Account+Password mode switcher.
class LoginPage extends StatefulWidget {
  /// 创建登录页。
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with WireStateMixin<LoginPage, LoginController> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  LoginController? wire() => LoginController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final bool ok = await controller.submit(
      identifier: _identifierController.text,
      password: _passwordController.text,
    );
    if (ok && mounted) {
      await AdaptiveRouter.of(context).pushNamedAndRemoveUntil(
        AppRoutes.conversations,
        (AdaptiveRouteMatch _) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
        actions: <Widget>[
          IconButton(
            tooltip: '服务器设置',
            icon: const Icon(Icons.dns_outlined),
            onPressed: () => ServerConfigDialog.show(context),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const DesktopTitleBar(title: '登录 OpenIM'),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: SignalBuilder(
                    builder: (BuildContext _) {
                      final bool isEmail = controller.useEmailLogin.value;
                      final bool loading = controller.submitting.value;
                      final bool obscure = controller.obscurePassword.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            isEmail ? '邮箱密码登录' : '账号密码登录',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SegmentedButton<bool>(
                            segments: const <ButtonSegment<bool>>[
                              ButtonSegment<bool>(
                                value: true,
                                label: Text('邮箱 + 密码'),
                                icon: Icon(Icons.email_outlined),
                              ),
                              ButtonSegment<bool>(
                                value: false,
                                label: Text('账号 + 密码'),
                                icon: Icon(Icons.person_outline),
                              ),
                            ],
                            selected: <bool>{isEmail},
                            onSelectionChanged: (Set<bool> next) {
                              controller.useEmailLogin.value = next.first;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _identifierController,
                            keyboardType: isEmail
                                ? TextInputType.emailAddress
                                : TextInputType.text,
                            decoration: InputDecoration(
                              labelText: isEmail ? '邮箱地址' : '登录账号',
                              prefixIcon: Icon(
                                isEmail
                                    ? Icons.email_outlined
                                    : Icons.badge_outlined,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _passwordController,
                            obscureText: obscure,
                            onSubmitted: (String _) => _onLogin(),
                            decoration: InputDecoration(
                              labelText: '密码',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  controller.obscurePassword.value = !obscure;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: loading ? null : _onLogin,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(loading ? '登录中...' : '立即登录'),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    AdaptiveRouter.of(context)
                                        .pushNamed(AppRoutes.forgotPassword),
                                child: const Text('忘记密码'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    AdaptiveRouter.of(context)
                                        .pushNamed(AppRoutes.appeal),
                                child: const Text('账号申诉'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    AdaptiveRouter.of(context)
                                        .pushNamed(AppRoutes.register),
                                child: const Text('邮箱注册'),
                              ),
                            ],
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
