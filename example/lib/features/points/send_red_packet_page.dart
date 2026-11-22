import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/theme/app_colors.dart';

/// 发送积分红包页（支持单聊普通红包与群聊拼手气/普通红包）。
///
/// Send points red packet page for single or group conversations.
class SendRedPacketPage extends StatefulWidget {
  /// 目标会话。
  final ConversationInfo? conversation;

  /// 创建发红包页。
  const SendRedPacketPage({super.key, required this.conversation});

  @override
  State<SendRedPacketPage> createState() => _SendRedPacketPageState();
}

class _SendRedPacketPageState extends State<SendRedPacketPage> {
  final TextEditingController _amountController = TextEditingController(
    text: '10',
  );
  final TextEditingController _countController = TextEditingController(
    text: '1',
  );
  final TextEditingController _greetingController = TextEditingController(
    text: '恭喜发财，大吉大利',
  );
  final TextEditingController _payPwdController = TextEditingController();
  late final Signal<bool> _lucky = signal<bool>(true);
  late final Signal<bool> _sending = signal<bool>(false);

  @override
  void dispose() {
    _amountController.dispose();
    _countController.dispose();
    _greetingController.dispose();
    _payPwdController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final ConversationInfo? conv = widget.conversation;
    if (conv == null) {
      return;
    }
    final double amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final int count = int.tryParse(_countController.text.trim()) ?? 1;
    if (amount <= 0 || count <= 0) {
      await FlutterToastPro.warning('请输入有效的积分金额和个数');
      return;
    }
    _sending.value = true;
    try {
      final String pwd = _payPwdController.text.trim();
      if (pwd.isNotEmpty) {
        final bool verified = await OpenIM.iMManager.userManager
            .verifyPaymentPassword(paymentPassword: pwd);
        if (!verified) {
          await FlutterToastPro.error('支付密码校验失败');
          return;
        }
      }
      final int packetType = conv.isGroupChat ? (_lucky.value ? 2 : 1) : 1;
      final int finalCount = conv.isGroupChat ? count : 1;
      final String packetID = await OpenIM.iMManager.redPacketManager
          .sendRedPacket(
            SendRedPacketRequest(
              packetType: packetType,
              totalAmount: amount,
              totalCount: finalCount,
              greeting: _greetingController.text.trim(),
              convID: conv.conversationID,
              targetUserID: conv.isSingleChat ? conv.userID : null,
            ),
          );
      final Message msg = OpenIM.iMManager.messageManager
          .createRedPacketMessage(
            elem: RedPacketElem(
              packetID: packetID,
              packetType: packetType,
              totalAmount: amount,
              totalCount: finalCount,
              greeting: _greetingController.text.trim(),
            ),
          );
      await OpenIM.iMManager.messageManager.sendMessage(
        message: msg,
        userID: conv.isSingleChat ? conv.userID : null,
        groupID: conv.isGroupChat ? conv.groupID : null,
        offlinePushInfo: OfflinePushInfo(title: '[积分红包]'),
      );
      await FlutterToastPro.success('红包已发出');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('发红包失败：$error');
    } finally {
      if (mounted) {
        _sending.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isGroup = widget.conversation?.isGroupChat ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('发积分红包')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final bool lucky = _lucky.value;
          final bool sending = _sending.value;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              if (isGroup) ...<Widget>[
                SegmentedButton<bool>(
                  segments: const <ButtonSegment<bool>>[
                    ButtonSegment<bool>(value: true, label: Text('拼手气红包')),
                    ButtonSegment<bool>(value: false, label: Text('普通红包')),
                  ],
                  selected: <bool>{lucky},
                  onSelectionChanged: (Set<bool> next) {
                    _lucky.value = next.first;
                  },
                ),
                const SizedBox(height: 14),
              ],
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: '总积分金额'),
              ),
              if (isGroup) ...<Widget>[
                const SizedBox(height: 12),
                TextField(
                  controller: _countController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: '红包个数'),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: _greetingController,
                decoration: const InputDecoration(labelText: '祝福语'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _payPwdController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '支付密码（若已设置）'),
              ),
              const SizedBox(height: 24),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.redPacketOrange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: sending ? null : _send,
                child: Text(sending ? '发送中...' : '塞积分进红包'),
              ),
            ],
          );
        },
      ),
    );
  }
}
