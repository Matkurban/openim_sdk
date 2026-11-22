import 'dart:convert';

import 'package:meta/meta.dart';

import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../listener/red_packet_listener.dart';
import '../models/api_response.dart';
import '../models/openim_exception.dart';
import '../models/red_packet.dart';

/// 红包与积分管理器（继承 [BaseManager]）。
final class RedPacketManager extends BaseManager<OnRedPacketListener> {
  final SdkContext _context;

  double _cachedBalance = 0;
  final Set<String> _grabbedPacketIDs = <String>{};

  /// 创建 `RedPacketManager` 实例。
  ///
  /// Creates a `RedPacketManager` instance.
  ///
  /// - [_context] context / Context.
  RedPacketManager({required this._context}) : super('RedPacketManager');

  /// cached余额。
  ///
  /// Cached balance.
  double get cachedBalance => _cachedBalance;

  /// 设置红包监听器。
  ///
  /// Set red packet listener.
  ///
  /// - [listener] 监听器 / Listener.
  void setRedPacketListener(OnRedPacketListener listener) {
    setPrimaryListener(listener);
  }

  /// on登出。
  ///
  /// On logout.
  @override
  void onLogout() {
    _cachedBalance = 0;
    _grabbedPacketIDs.clear();
    super.onLogout();
  }

  /// preload已领取状态。
  ///
  /// Preload grabbed status.
  ///
  /// - [packetIDs] 包ID 列表 / Packet i ds.
  Future<void> preloadGrabbedStatus(List<String> packetIDs) async {
    if (packetIDs.isEmpty) {
      return;
    }
    final List<String> uncached = packetIDs
        .where((String id) => !_grabbedPacketIDs.contains(id))
        .toList();
    if (uncached.isEmpty) {
      return;
    }
    final Set<String> grabbed = await _context.db.social.getGrabbedRedPacketIDs(uncached);
    _grabbedPacketIDs.addAll(grabbed);
  }

  /// 是否已领取。
  ///
  /// Whether grabbed.
  ///
  /// - [packetID] 包ID / Packet ID.
  /// - Returns: 操作结果布尔值 / Boolean result.
  bool isGrabbed(String packetID) => _grabbedPacketIDs.contains(packetID);

  /// 标记已领取。
  ///
  /// Mark grabbed.
  ///
  /// - [packetID] 包ID / Packet ID.
  Future<void> markGrabbed(String packetID) async {
    _grabbedPacketIDs.add(packetID);
    await _context.db.social.markRedPacketGrabbed(packetID);
  }

  /// 发送红包。
  ///
  /// Send red packet.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: 字符串结果 / String result.
  Future<String> sendRedPacket(SendRedPacketRequest req) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/red_packet/send',
      data: req.toJson(),
    );
    if (!resp.isSuccess) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    final String packetID = resp.data['packetID'] as String;
    _cachedBalance = ((_cachedBalance - req.totalAmount) * 100).roundToDouble() / 100;
    listener?.pointsBalanceChanged(_cachedBalance);
    return packetID;
  }

  /// 领取红包。
  ///
  /// Grab red packet.
  ///
  /// - [packetID] 包ID / Packet ID.
  /// - Returns: 数值结果 / Numeric result.
  Future<double> grabRedPacket(String packetID) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/red_packet/grab',
      data: <String, dynamic>{'packetID': packetID},
    );
    if (!resp.isSuccess) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    final double amount = (resp.data['amount'] as num).toDouble();
    _cachedBalance = ((_cachedBalance + amount) * 100).roundToDouble() / 100;
    listener?.pointsBalanceChanged(_cachedBalance);
    await markGrabbed(packetID);
    return amount;
  }

  /// 获取红包详情。
  ///
  /// Get red packet detail.
  ///
  /// - [packetID] 包ID / Packet ID.
  /// - Returns: `Future<RedPacketDetail>` 结果 / Resulting `Future<RedPacketDetail>`.
  Future<RedPacketDetail> getRedPacketDetail(String packetID) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/red_packet/detail',
      data: <String, dynamic>{'packetID': packetID},
    );
    if (!resp.isSuccess) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    return RedPacketDetail.fromJson(resp.data as Map<String, dynamic>);
  }

  /// 获取积分余额。
  ///
  /// Get points balance.
  ///
  /// - Returns: 数值结果 / Numeric result.
  Future<double> getPointsBalance() async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/points/balance',
      data: const <String, dynamic>{},
    );
    if (!resp.isSuccess) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    _cachedBalance = ((resp.data['balance'] as num).toDouble() * 100).roundToDouble() / 100;
    listener?.pointsBalanceChanged(_cachedBalance);
    return _cachedBalance;
  }

  /// 获取积分交易记录列表。
  ///
  /// Get points transactions.
  ///
  /// - [pageNumber] 分页号码 / Paged number.
  /// - [showNumber] 展示号码 / Display number.
  /// - [txType] tx类型 / Tx type.
  /// - [startTime] 开始时间戳 / Start timestamp.
  /// - [endTime] 结束时间戳 / End timestamp.
  /// - [keyword] 关键词 / Keyword.
  /// - Returns: `Future<(int total, List<PointsTransaction> items)>` 结果 / Resulting `Future<(int total, List<PointsTransaction> items)>`.
  Future<(int total, List<PointsTransaction> items)> getPointsTransactions({
    int pageNumber = 1,
    int showNumber = 20,
    int? txType,
    DateTime? startTime,
    DateTime? endTime,
    String? keyword,
  }) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'pageNumber': pageNumber,
      'showNumber': showNumber,
      if (txType != null && txType > 0) 'txType': txType,
      if (startTime != null) 'startTime': startTime.millisecondsSinceEpoch,
      if (endTime != null) 'endTime': endTime.millisecondsSinceEpoch,
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
    };
    final ApiResponse resp = await _context.httpClient.chatPost('/points/transactions', data: data);
    if (!resp.isSuccess) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    final int total = (resp.data['total'] as num?)?.toInt() ?? 0;
    final List<PointsTransaction> items =
        ((resp.data['transactions'] as List<dynamic>?) ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map<PointsTransaction>(PointsTransaction.fromJson)
            .toList();
    return (total, items);
  }

  /// 获取Income交易记录列表。
  ///
  /// Get income transactions.
  ///
  /// - [pageNumber] 分页号码 / Paged number.
  /// - [showNumber] 展示号码 / Display number.
  /// - Returns: `Future<(int total, List<PointsTransaction> items)>` 结果 / Resulting `Future<(int total, List<PointsTransaction> items)>`.
  Future<(int total, List<PointsTransaction> items)> getIncomeTransactions({
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    final (int total, List<PointsTransaction> items) = await getPointsTransactions(
      pageNumber: pageNumber,
      showNumber: showNumber,
    );
    return (total, items.where((PointsTransaction tx) => tx.isIncome).toList());
  }

  /// 获取Expense交易记录列表。
  ///
  /// Get expense transactions.
  ///
  /// - [pageNumber] 分页号码 / Paged number.
  /// - [showNumber] 展示号码 / Display number.
  /// - Returns: `Future<(int total, List<PointsTransaction> items)>` 结果 / Resulting `Future<(int total, List<PointsTransaction> items)>`.
  Future<(int total, List<PointsTransaction> items)> getExpenseTransactions({
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    final (int total, List<PointsTransaction> items) = await getPointsTransactions(
      pageNumber: pageNumber,
      showNumber: showNumber,
    );
    return (total, items.where((PointsTransaction tx) => tx.isExpense).toList());
  }

  /// 派发Business通知。
  ///
  /// Dispatch business notification.
  ///
  /// - [key] 键名 / Key.
  /// - [data] 数据 / Data.
  @internal
  void dispatchBusinessNotification(String key, String data) {
    try {
      switch (key) {
        case 'red_packet_expired':
          String packetID = data;
          try {
            final Map<String, dynamic> decoded = jsonDecode(data) as Map<String, dynamic>;
            packetID = decoded['packetID']?.toString() ?? data;
          } catch (_) {}
          listener?.redPacketExpired(packetID);
        case 'points_adjusted':
          final Map<String, dynamic> map = jsonDecode(data) as Map<String, dynamic>;
          _cachedBalance = ((map['balance'] as num).toDouble() * 100).roundToDouble() / 100;
          listener?.pointsBalanceChanged(_cachedBalance);
      }
    } on Object catch (error, stackTrace) {
      logger.warning('dispatchBusinessNotification failed for key=$key', error, stackTrace);
    }
  }
}
