import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_file_operations/xue_hua_file_operations.dart';

import '../../core/services/media_service.dart';

/// 账号封禁申诉页（对接 `ReportAppealManager`）。
///
/// Account ban appeal page powered by `ReportAppealManager`.
class AppealPage extends StatefulWidget {
  /// 创建账号申诉页。
  const AppealPage({super.key});

  @override
  State<AppealPage> createState() => _AppealPageState();
}

class _AppealPageState extends State<AppealPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();

  late final Signal<AppealCaptcha?> _captcha = signal<AppealCaptcha?>(null);
  late final Signal<List<String>> _evidenceUrls = signal<List<String>>(
    <String>[],
  );
  late final Signal<bool> _submitting = signal<bool>(false);

  @override
  void initState() {
    super.initState();
    _loadCaptcha();
  }

  @override
  void dispose() {
    _accountController.dispose();
    _contactController.dispose();
    _reasonController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  Future<void> _loadCaptcha() async {
    try {
      final AppealCaptcha? result = await OpenIM.iMManager.reportAppealManager
          .getAppealCaptcha();
      if (mounted) {
        _captcha.value = result;
      }
    } on Object catch (error) {
      await FlutterToastPro.error('加载图形验证码失败：$error');
    }
  }

  Future<void> _pickEvidence() async {
    final PlatformFile? file = await Wire.find<MediaService>()
        .pickSingleImage();
    if (file == null || (file.path ?? '').isEmpty) {
      return;
    }
    FlutterToastPro.loading(message: '正在上传申诉证据...');
    try {
      final AppealUploadResp? uploaded = await OpenIM
          .iMManager
          .reportAppealManager
          .uploadAppealEvidence(
            appealToken: _captcha.value?.captchaID ?? '',
            filePath: file.path!,
            fileName: file.name,
          );
      FlutterToastPro.hideLoading();
      if (uploaded != null && uploaded.url.isNotEmpty && mounted) {
        _evidenceUrls.value = <String>[..._evidenceUrls.value, uploaded.url];
        await FlutterToastPro.success('证据上传成功');
      }
    } on Object catch (error) {
      FlutterToastPro.hideLoading();
      await FlutterToastPro.error('上传失败：$error');
    }
  }

  Future<void> _submit() async {
    if (_accountController.text.trim().isEmpty ||
        _reasonController.text.trim().isEmpty) {
      await FlutterToastPro.warning('请填写账号和申诉理由');
      return;
    }
    _submitting.value = true;
    try {
      await OpenIM.iMManager.reportAppealManager.submitAppeal(
        account: _accountController.text.trim(),
        contact: _contactController.text.trim(),
        reason: _reasonController.text.trim(),
        captchaID: _captcha.value?.captchaID ?? '',
        captchaAnswer: _captchaController.text.trim(),
      );
      await FlutterToastPro.success('申诉已提交，请留意联系邮箱');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('提交申诉失败：$error');
    } finally {
      if (mounted) {
        _submitting.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('账号申诉')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: SignalBuilder(
              builder: (BuildContext _) {
                final AppealCaptcha? captcha = _captcha.value;
                final List<String> evidenceUrls = _evidenceUrls.value;
                final bool submitting = _submitting.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextField(
                      controller: _accountController,
                      decoration: const InputDecoration(labelText: '申诉账号 / 邮箱'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _contactController,
                      decoration: const InputDecoration(labelText: '联系邮箱或手机号'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _reasonController,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: '申诉说明'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _captchaController,
                            decoration: const InputDecoration(
                              labelText: '图形验证码',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: _loadCaptcha,
                          child: Text(captcha == null ? '获取验证码' : '换一张'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _pickEvidence,
                      icon: const Icon(Icons.upload_file),
                      label: Text('上传截图证据（已上传 ${evidenceUrls.length} 张）'),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: submitting ? null : _submit,
                      child: Text(submitting ? '提交中...' : '提交申诉'),
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
