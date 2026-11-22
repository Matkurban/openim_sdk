import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

/// 支付密码设置与修改页（对接 `UserManager` 支付密码全套 API）。
///
/// Payment password setup and modification page.
class PaymentPasswordPage extends StatefulWidget {
  /// 创建支付密码页。
  const PaymentPasswordPage({super.key});

  @override
  State<PaymentPasswordPage> createState() => _PaymentPasswordPageState();
}

class _PaymentPasswordPageState extends State<PaymentPasswordPage> {
  final TextEditingController _oldOrLoginCtrl = TextEditingController();
  final TextEditingController _newCtrl = TextEditingController();
  late final Signal<bool> _alreadySet = signal<bool>(false);
  late final Signal<bool> _loading = signal<bool>(true);
  late final Signal<bool> _saving = signal<bool>(false);

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    try {
      final bool isSet = await OpenIM.iMManager.userManager
          .checkPaymentPasswordSet();
      if (mounted) {
        _alreadySet.value = isSet;
      }
    } finally {
      if (mounted) {
        _loading.value = false;
      }
    }
  }

  @override
  void dispose() {
    _oldOrLoginCtrl.dispose();
    _newCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String first = _oldOrLoginCtrl.text.trim();
    final String next = _newCtrl.text.trim();
    if (first.isEmpty || next.length < 6) {
      await FlutterToastPro.warning('请输入完整密码（新支付密码至少 6 位）');
      return;
    }
    _saving.value = true;
    try {
      if (_alreadySet.value) {
        await OpenIM.iMManager.userManager.changePaymentPassword(
          currentPaymentPassword: first,
          newPaymentPassword: next,
        );
      } else {
        await OpenIM.iMManager.userManager.setPaymentPassword(
          loginPassword: first,
          paymentPassword: next,
        );
      }
      await FlutterToastPro.success('支付密码已更新');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('操作失败：$error');
    } finally {
      if (mounted) {
        _saving.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext _) {
        final bool alreadySet = _alreadySet.value;
        final bool loading = _loading.value;
        final bool saving = _saving.value;
        return Scaffold(
          appBar: AppBar(title: Text(alreadySet ? '修改支付密码' : '设置支付密码')),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    TextField(
                      controller: _oldOrLoginCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: alreadySet ? '原支付密码' : '当前登录密码',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _newCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '新支付密码（6位及以上）',
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: saving ? null : _submit,
                      child: Text(saving ? '保存中...' : '确认保存'),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
