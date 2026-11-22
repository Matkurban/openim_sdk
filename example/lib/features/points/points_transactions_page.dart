import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../core/utils/date_time_formatter.dart';
import '../../shared/widgets/empty_state_view.dart';

/// 积分明细页（全部 / 收入 / 支出三 Tab 分页列表）。
///
/// Points transactions history page with All / Income / Expense tabs.
class PointsTransactionsPage extends StatefulWidget {
  /// 创建积分明细页。
  const PointsTransactionsPage({super.key});

  @override
  State<PointsTransactionsPage> createState() => _PointsTransactionsPageState();
}

class _PointsTransactionsPageState extends State<PointsTransactionsPage> {
  late final Signal<List<PointsTransaction>> _all =
      signal<List<PointsTransaction>>(<PointsTransaction>[]);
  late final Signal<List<PointsTransaction>> _income =
      signal<List<PointsTransaction>>(<PointsTransaction>[]);
  late final Signal<List<PointsTransaction>> _expense =
      signal<List<PointsTransaction>>(<PointsTransaction>[]);
  late final Signal<bool> _loading = signal<bool>(true);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final (int _, List<PointsTransaction> all) = await OpenIM
          .iMManager
          .redPacketManager
          .getPointsTransactions(pageNumber: 1, showNumber: 50);
      final (int _, List<PointsTransaction> inc) = await OpenIM
          .iMManager
          .redPacketManager
          .getIncomeTransactions(pageNumber: 1, showNumber: 50);
      final (int _, List<PointsTransaction> exp) = await OpenIM
          .iMManager
          .redPacketManager
          .getExpenseTransactions(pageNumber: 1, showNumber: 50);
      if (mounted) {
        batch(() {
          _all.value = all;
          _income.value = inc;
          _expense.value = exp;
        });
      }
    } finally {
      if (mounted) {
        _loading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('积分明细'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: '全部'),
              Tab(text: '收入'),
              Tab(text: '支出'),
            ],
          ),
        ),
        body: SignalBuilder(
          builder: (BuildContext _) {
            if (_loading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return TabBarView(
              children: <Widget>[
                _TransactionListView(items: _all.value),
                _TransactionListView(items: _income.value),
                _TransactionListView(items: _expense.value),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TransactionListView extends StatelessWidget {
  final List<PointsTransaction> items;

  const _TransactionListView({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyStateView(title: '暂无积分流水');
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (BuildContext _, int _) => const Divider(height: 1),
      itemBuilder: (BuildContext _, int index) {
        final PointsTransaction tx = items[index];
        final bool positive = tx.amount >= 0;
        return ListTile(
          title: Text(tx.remark.isNotEmpty ? tx.remark : '类型 #${tx.txType}'),
          subtitle: Text(
            DateTimeFormatter.formatFullDateTime(
              tx.createTime.millisecondsSinceEpoch,
            ),
          ),
          trailing: Text(
            '${positive ? '+' : ''}${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: positive ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
}
