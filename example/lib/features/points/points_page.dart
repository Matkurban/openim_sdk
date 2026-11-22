import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/events/im_event_bus.dart';

/// 积分中心主页（展示积分余额、实时订阅变更、明细入口与支付密码管理入口）。
///
/// Points wallet hub showing live balance, transaction history, and payment password entry.
class PointsPage extends StatefulWidget {
  /// 创建积分中心页。
  const PointsPage({super.key});

  @override
  State<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  double _balance = 0;
  bool _hasPayPwd = false;
  bool _loading = true;
  StreamSubscription<double>? _balanceSub;

  @override
  void initState() {
    super.initState();
    final ImEventBus bus = Wire.find<ImEventBus>();
    _balanceSub = bus.pointsBalanceStream.listen((double next) {
      if (mounted) {
        setState(() => _balance = next);
      }
    });
    _load();
  }

  Future<void> _load() async {
    try {
      final double bal = await OpenIM.iMManager.redPacketManager
          .getPointsBalance();
      final bool hasPwd = await OpenIM.iMManager.userManager
          .checkPaymentPasswordSet();
      Wire.find<ImEventBus>().updatePointsBalance(bal);
      if (mounted) {
        setState(() {
          _balance = bal;
          _hasPayPwd = hasPwd;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _balanceSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('积分中心')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          AppColors.primary,
                          AppColors.primaryDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          '当前可用积分',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _balance.toStringAsFixed(2),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.receipt_long_outlined),
                          title: const Text('积分收支明细'),
                          subtitle: const Text('查看全部 / 收入 / 支出流水'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () =>
                              router.pushNamed(AppRoutes.pointsTransactions),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.password_outlined),
                          title: const Text('支付密码管理'),
                          subtitle: Text(
                            _hasPayPwd ? '已设置支付密码' : '未设置（发红包需先设置）',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            await router.pushNamed(AppRoutes.paymentPassword);
                            await _load();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
