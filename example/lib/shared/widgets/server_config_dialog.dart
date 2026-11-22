import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../core/config/sdk_server_config.dart';
import '../../core/services/app_bootstrap_service.dart';
import '../../core/services/settings_service.dart';

/// SDK 服务器地址配置弹窗（支持输入 IP / 域名 / HTTP / HTTPS 自动推导四端地址，零 `setState`）。
///
/// Dialog for editing [SdkServerConfig] with automatic IP/domain/HTTPS endpoint detection.
class ServerConfigDialog extends StatefulWidget {
  /// 创建服务器配置弹窗。
  const ServerConfigDialog({super.key});

  /// 便捷展示弹窗。
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext _) => const ServerConfigDialog(),
    );
  }

  @override
  State<ServerConfigDialog> createState() => _ServerConfigDialogState();
}

class _ServerConfigDialogState extends State<ServerConfigDialog> {
  late final TextEditingController _hostController;
  late final TextEditingController _apiController;
  late final TextEditingController _wsController;
  late final TextEditingController _authController;
  late final TextEditingController _adminController;
  late final Signal<bool> _saving = signal<bool>(false);

  @override
  void initState() {
    super.initState();
    final SdkServerConfig current =
        Wire.find<SettingsService>().serverConfig.value;
    _hostController = TextEditingController(text: current.host);
    _apiController = TextEditingController(text: current.apiAddr);
    _wsController = TextEditingController(text: current.wsAddr);
    _authController = TextEditingController(text: current.authAddr);
    _adminController = TextEditingController(text: current.adminAddr);
  }

  @override
  void dispose() {
    _hostController.dispose();
    _apiController.dispose();
    _wsController.dispose();
    _authController.dispose();
    _adminController.dispose();
    super.dispose();
  }

  void _applyHostDetection(String rawHost) {
    final SdkServerConfig derived = SdkServerConfig.fromHost(rawHost);
    _apiController.text = derived.apiAddr;
    _wsController.text = derived.wsAddr;
    _authController.text = derived.authAddr;
    _adminController.text = derived.adminAddr;
  }

  Future<void> _save() async {
    _saving.value = true;
    try {
      final SdkServerConfig next = SdkServerConfig(
        host: _hostController.text.trim(),
        apiAddr: _apiController.text.trim(),
        wsAddr: _wsController.text.trim(),
        authAddr: _authController.text.trim(),
        adminAddr: _adminController.text.trim(),
      );
      await Wire.find<AppBootstrapService>().reinitializeSdk(next);
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
      await FlutterToastPro.success('服务器地址已更新并重新初始化 SDK');
    } on Object catch (error) {
      await FlutterToastPro.error('保存失败：$error');
    } finally {
      _saving.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext _) {
        final bool busy = _saving.value;
        return AlertDialog(
          title: const Text('服务器地址配置'),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _hostController,
                    onChanged: _applyHostDetection,
                    decoration: const InputDecoration(
                      labelText: '主机 / 域名 / URL（自动识别 IP 或 HTTPS 域名）',
                      hintText:
                          '例如：localhost、im.example.com、https://im.example.com',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _apiController,
                    decoration: const InputDecoration(labelText: 'API Addr'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _wsController,
                    decoration: const InputDecoration(
                      labelText: 'WebSocket Addr',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _authController,
                    decoration: const InputDecoration(labelText: 'Auth Addr'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _adminController,
                    decoration: const InputDecoration(labelText: 'Admin Addr'),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: busy ? null : () => AdaptiveRouter.of(context).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: busy ? null : _save,
              child: Text(busy ? '保存中...' : '保存并重连'),
            ),
          ],
        );
      },
    );
  }
}
