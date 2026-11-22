import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../core/services/qr_login_service.dart';
import '../../l10n/app_localizations.dart';

/// 移动端扫描桌面二维码后的登录授权确认页（纯 `signal_wire` 响应式实现，零 `setState`）。
///
/// Mobile confirmation page for authorizing a desktop QR code login session.
class QrDesktopLoginConfirmPage extends StatefulWidget {
  /// 桌面端生成的扫码登录会话 ID。
  final String sessionId;

  /// 创建桌面扫码登录确认页。
  const QrDesktopLoginConfirmPage({super.key, required this.sessionId});

  @override
  State<QrDesktopLoginConfirmPage> createState() =>
      _QrDesktopLoginConfirmPageState();
}

class _QrDesktopLoginConfirmPageState extends State<QrDesktopLoginConfirmPage> {
  static final Logger _logger = Logger('QrDesktopLoginConfirmPage');

  late final Signal<Map<String, dynamic>?> _info =
      signal<Map<String, dynamic>?>(null);
  late final Signal<bool> _loading = signal<bool>(true);
  late final Signal<bool> _confirming = signal<bool>(false);
  late final Signal<bool> _confirmed = signal<bool>(false);

  @override
  void initState() {
    super.initState();
    unawaited(_notifyScanned());
  }

  Future<void> _notifyScanned() async {
    try {
      final Map<String, dynamic> data = await Wire.find<QrLoginService>()
          .scanSession(widget.sessionId);
      batch(() {
        _info.value = data;
        _loading.value = false;
      });
    } on Object catch (error, stackTrace) {
      _logger.warning('scanSession failed', error, stackTrace);
      _loading.value = false;
      await FlutterToastPro.error('二维码无效或已过期');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    }
  }

  String _platformLabel(AppLocalizations l10n, int? platform) {
    return switch (platform) {
      3 => l10n.qrLoginPlatformWindows,
      4 => l10n.qrLoginPlatformMac,
      7 => l10n.qrLoginPlatformLinux,
      _ => l10n.qrLoginPlatformDesktop,
    };
  }

  Future<void> _confirm() async {
    if (_confirming.value) {
      return;
    }
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    _confirming.value = true;
    FlutterToastPro.loading(message: l10n.qrLoginConfirming);
    try {
      await Wire.find<QrLoginService>().confirmSession(widget.sessionId);
      _confirmed.value = true;
      FlutterToastPro.hideLoading();
      await FlutterToastPro.success(l10n.qrLoginConfirmSuccess);
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error, stackTrace) {
      _logger.warning('confirmSession failed', error, stackTrace);
      FlutterToastPro.hideLoading();
      await FlutterToastPro.error('授权登录失败：$error');
      _confirming.value = false;
    }
  }

  Future<void> _cancel() async {
    if (!_confirmed.value) {
      await Wire.find<QrLoginService>().cancelSession(widget.sessionId);
    }
    if (mounted) {
      AdaptiveRouter.of(context).pop();
    }
  }

  @override
  void dispose() {
    if (!_confirmed.value) {
      unawaited(Wire.find<QrLoginService>().cancelSession(widget.sessionId));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.qrLoginConfirmTitle)),
      body: SignalBuilder(
        builder: (BuildContext _) {
          if (_loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final Map<String, dynamic> info =
              _info.value ?? const <String, dynamic>{};
          final int? platform = (info['platform'] as num?)?.toInt();
          final String clientIp = (info['clientIp'] as String?) ?? '';
          final bool busy = _confirming.value;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Spacer(),
                    Icon(
                      Icons.desktop_windows_outlined,
                      size: 76,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.qrLoginConfirmMessage(
                        _platformLabel(l10n, platform),
                      ),
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    if (clientIp.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 10),
                      Text(
                        l10n.qrLoginConfirmIp(clientIp),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const Spacer(),
                    FilledButton(
                      onPressed: busy ? null : _confirm,
                      child: Text(l10n.qrLoginConfirmButton),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: busy ? null : _cancel,
                      child: Text(l10n.cancel),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
