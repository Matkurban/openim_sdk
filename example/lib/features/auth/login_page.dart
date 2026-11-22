import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_qr_code/xue_hua_qr_code.dart';

import '../../app/router/app_routes.dart';
import '../../core/services/qr_login_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/server_config_dialog.dart';
import 'login_controller.dart';

/// 登录页：支持「邮箱 + 密码」/「账号 + 密码」登录，桌面端额外支持手机扫码登录。
///
/// Login page with Email/Account password modes plus desktop QR code sign-in.
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

  bool get _isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  late final Signal<bool> _showQrLogin = signal<bool>(_isDesktop);

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
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.login),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.serverConfig,
            icon: const Icon(Icons.dns_outlined),
            onPressed: () => ServerConfigDialog.show(context),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SignalBuilder(
              builder: (BuildContext _) {
                final bool qrMode = _showQrLogin.value;
                if (qrMode && _isDesktop) {
                  return _DesktopQrLoginPanel(
                    onSwitchToPassword: () => _showQrLogin.value = false,
                  );
                }
                final bool isEmail = controller.useEmailLogin.value;
                final bool loading = controller.submitting.value;
                final bool obscure = controller.obscurePassword.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      isEmail ? l10n.emailLogin : l10n.accountLogin,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<bool>(
                      segments: <ButtonSegment<bool>>[
                        ButtonSegment<bool>(
                          value: true,
                          label: Text(l10n.emailLogin),
                          icon: const Icon(Icons.email_outlined),
                        ),
                        ButtonSegment<bool>(
                          value: false,
                          label: Text(l10n.accountLogin),
                          icon: const Icon(Icons.person_outline),
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
                        labelText: isEmail ? l10n.email : l10n.account,
                        prefixIcon: Icon(
                          isEmail ? Icons.email_outlined : Icons.badge_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _passwordController,
                      obscureText: obscure,
                      onSubmitted: (String _) => _onLogin(),
                      decoration: InputDecoration(
                        labelText: l10n.password,
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
                      child: Text(loading ? '...' : l10n.login),
                    ),
                    if (_isDesktop) ...<Widget>[
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _showQrLogin.value = true,
                        icon: const Icon(Icons.qr_code_2),
                        label: Text(l10n.switchToQrLogin),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          onPressed: () =>
                              AdaptiveRouter.of(context)
                                  .pushNamed(AppRoutes.forgotPassword),
                          child: Text(l10n.forgotPassword),
                        ),
                        TextButton(
                          onPressed: () =>
                              AdaptiveRouter.of(context)
                                  .pushNamed(AppRoutes.appeal),
                          child: Text(l10n.accountAppeal),
                        ),
                        TextButton(
                          onPressed: () =>
                              AdaptiveRouter.of(context)
                                  .pushNamed(AppRoutes.register),
                          child: Text(l10n.register),
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
    );
  }
}

class _DesktopQrLoginPanel extends StatefulWidget {
  final VoidCallback onSwitchToPassword;

  const _DesktopQrLoginPanel({required this.onSwitchToPassword});

  @override
  State<_DesktopQrLoginPanel> createState() => _DesktopQrLoginPanelState();
}

class _DesktopQrLoginPanelState extends State<_DesktopQrLoginPanel> {
  late final Signal<String> _state = signal<String>('loading');
  late final Signal<String> _qrContent = signal<String>('');
  String? _sessionId;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_createQr());
  }

  Future<void> _createQr() async {
    _pollTimer?.cancel();
    _state.value = 'loading';
    try {
      final (String sessionId, int _, String qrContent) =
          await Wire.find<QrLoginService>().createSession();
      _sessionId = sessionId;
      batch(() {
        _qrContent.value = qrContent;
        _state.value = 'pending';
      });
      _startPolling();
    } on Object catch (_) {
      _state.value = 'expired';
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (Timer _) {
      unawaited(_pollOnce());
    });
  }

  Future<void> _pollOnce() async {
    final String? id = _sessionId;
    if (id == null || id.isEmpty) {
      return;
    }
    try {
      final Map<String, dynamic> data = await Wire.find<QrLoginService>()
          .pollStatus(id);
      final String status = (data['status'] as String?) ?? 'expired';
      switch (status) {
        case 'pending':
          _state.value = 'pending';
        case 'scanned':
          _state.value = 'scanned';
        case 'confirmed':
          _pollTimer?.cancel();
          _state.value = 'loggingIn';
          await Wire.find<QrLoginService>().completeDesktopLogin(data);
          if (mounted) {
            await AdaptiveRouter.of(context).pushNamedAndRemoveUntil(
              AppRoutes.conversations,
              (AdaptiveRouteMatch _) => false,
            );
          }
        case 'cancelled':
          await _createQr();
        default:
          _pollTimer?.cancel();
          _state.value = 'expired';
      }
    } on Object catch (_) {}
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    if (_sessionId != null && _state.value != 'loggingIn') {
      unawaited(Wire.find<QrLoginService>().cancelSession(_sessionId!));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    return SignalBuilder(
      builder: (BuildContext _) {
        final String st = _state.value;
        final String qr = _qrContent.value;
        final String statusText = switch (st) {
          'loading' => l10n.qrLoginLoading,
          'scanned' => l10n.qrLoginScanned,
          'expired' => l10n.qrLoginExpired,
          'loggingIn' => '${l10n.login}...',
          _ => l10n.qrLoginHint,
        };
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              l10n.qrLoginTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              width: 224,
              height: 224,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: st == 'loading'
                  ? const Center(child: CircularProgressIndicator())
                  : st == 'expired' && qr.isEmpty
                  ? Center(
                      child: FilledButton.icon(
                        onPressed: _createQr,
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.qrLoginRefresh),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        XueHuaQrCode(
                          value: qr,
                          size: 200,
                          errorBuilder: (
                            BuildContext _,
                            Object _,
                            StackTrace? _,
                          ) => const Icon(Icons.qr_code_2, size: 64),
                        ),
                        if (st == 'expired')
                          Positioned.fill(
                            child: ColoredBox(
                              color: Colors.white.withValues(alpha: 0.88),
                              child: Center(
                                child: FilledButton.icon(
                                  onPressed: _createQr,
                                  icon: const Icon(Icons.refresh),
                                  label: Text(l10n.qrLoginRefresh),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              statusText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                FlutterToastPro.dismissAll();
                widget.onSwitchToPassword();
              },
              child: Text(l10n.switchToPasswordLogin),
            ),
          ],
        );
      },
    );
  }
}
