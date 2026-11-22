import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../core/config/sdk_server_config.dart';
import '../../core/services/app_bootstrap_service.dart';
import '../../core/services/settings_service.dart';

/// SDK 服务器地址配置弹窗（默认 `localhost`，支持随时修改并重初始化 SDK）。
///
/// Dialog for editing and persisting [SdkServerConfig] endpoints.
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
  late final TextEditingController _apiController;
  late final TextEditingController _wsController;
  late final TextEditingController _authController;
  late final TextEditingController _adminController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final SdkServerConfig current =
        Wire.find<SettingsService>().serverConfig.value;
    _apiController = TextEditingController(text: current.apiAddr);
    _wsController = TextEditingController(text: current.wsAddr);
    _authController = TextEditingController(text: current.authAddr);
    _adminController = TextEditingController(text: current.adminAddr);
  }

  @override
  void dispose() {
    _apiController.dispose();
    _wsController.dispose();
    _authController.dispose();
    _adminController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
    });
    try {
      final SdkServerConfig next = SdkServerConfig(
        apiAddr: _apiController.text.trim(),
        wsAddr: _wsController.text.trim(),
        authAddr: _authController.text.trim(),
        adminAddr: _adminController.text.trim(),
      );
      await Wire.find<AppBootstrapService>().reinitializeSdk(next);
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      await FlutterToastPro.success('服务器地址已更新并重新初始化 SDK');
    } on Object catch (error) {
      await FlutterToastPro.error('保存失败：$error');
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('服务器地址配置'),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _apiController,
                decoration: const InputDecoration(labelText: 'API Addr'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _wsController,
                decoration: const InputDecoration(labelText: 'WebSocket Addr'),
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
          onPressed: _saving
              ? null
              : () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? '保存中...' : '保存并重连'),
        ),
      ],
    );
  }
}
