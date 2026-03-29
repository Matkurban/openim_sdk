import 'dart:async';
import 'dart:convert';

import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/src/listener/red_packet_listener.dart';
import 'package:openim_sdk/src/models/red_packet.dart';
import 'package:openim_sdk/src/network/http_client.dart';
import 'package:openim_sdk/src/services/database_service.dart';

// ─── 红包 Manager ─────────────────────────────────────────────────────────────

/// [RedPacketManager] 封装了所有与积分/红包相关的 API 调用和事件回调。
///
/// 初始化：在登录后调用 [setCurrentUserID]。
/// 监听事件：openim-server 推送的 business-notification 通过
/// [dispatchBusinessNotification] 分发（由 [MessageManager] 调用）。
class RedPacketManager {
  RedPacketManager._internal();

  static final RedPacketManager _instance = RedPacketManager._internal();

  factory RedPacketManager() => _instance;

  static final AoiweLogger _log = AoiweLogger('RedPacketManager');

  OnRedPacketListener? listener;

  void setRedPacketListener(OnRedPacketListener listener) {
    _log.info('设置红包监听器', methodName: 'setRedPacketListener');
    this.listener = listener;
  }

  /// 积分余额（本地缓存，供 UI 直接读取）
  double _cachedBalance = 0;
  double get cachedBalance => _cachedBalance;

  /// 已领取红包 ID 的内存缓存（高性能本地判断）
  final Set<String> _grabbedPacketIDs = {};
  DatabaseService? _database;

  @internal
  void setCurrentUserID(String userID) {
    // userID is managed via auth token; kept for interface compatibility
  }

  /// 设置数据库服务（登录时由 IMManager 调用）
  @internal
  void setDatabase(DatabaseService database) {
    _database = database;
  }

  /// 预加载已领取红包 ID 到内存缓存（批量查询，供消息列表使用）
  Future<void> preloadGrabbedStatus(List<String> packetIDs) async {
    if (packetIDs.isEmpty || _database == null) return;
    // 过滤掉已在缓存中的
    final uncached = packetIDs.where((id) => !_grabbedPacketIDs.contains(id)).toList();
    if (uncached.isEmpty) return;
    final grabbed = await _database!.getGrabbedRedPacketIDs(uncached);
    _grabbedPacketIDs.addAll(grabbed);
  }

  /// 同步判断红包是否已领取（O(1)，纯内存查询）
  bool isGrabbed(String packetID) => _grabbedPacketIDs.contains(packetID);

  /// 标记红包已领取（写入内存缓存 + 持久化到本地数据库）
  Future<void> markGrabbed(String packetID) async {
    _grabbedPacketIDs.add(packetID);
    await _database?.markRedPacketGrabbed(packetID);
  }

  // ─── 发送红包 ─────────────────────────────────────────────────────────────────

  /// 发送红包：扣减积分并在服务端创建红包记录。
  ///
  /// 成功后：客户端再通过 [MessageManager.sendCustomMessage] 将红包消息发到会话。
  Future<String> sendRedPacket(SendRedPacketRequest req) async {
    _log.info(
      'packetType=${req.packetType}, amount=${req.totalAmount}',
      methodName: 'sendRedPacket',
    );
    try {
      final resp = await HttpClient().chatPost('/red_packet/send', data: req.toJson());
      if (!resp.isSuccess) {
        throw Exception('sendRedPacket failed: ${resp.errMsg}');
      }
      final packetID = resp.data['packetID'] as String;
      // 更新本地积分缓存（保留两位小数避免浮点误差）
      _cachedBalance = ((_cachedBalance - req.totalAmount) * 100).roundToDouble() / 100;
      listener?.pointsBalanceChanged(_cachedBalance);
      return packetID;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'sendRedPacket');
      rethrow;
    }
  }

  // ─── 抢红包 ───────────────────────────────────────────────────────────────────

  /// 抢红包，返回实际领取积分数量。
  Future<double> grabRedPacket(String packetID) async {
    _log.info('packetID=$packetID', methodName: 'grabRedPacket');
    try {
      final resp = await HttpClient().chatPost('/red_packet/grab', data: {'packetID': packetID});
      if (!resp.isSuccess) {
        throw Exception('grabRedPacket failed: ${resp.errMsg}');
      }
      final amount = (resp.data['amount'] as num).toDouble();
      // 更新积分缓存（保留两位小数避免浮点误差）
      _cachedBalance = ((_cachedBalance + amount) * 100).roundToDouble() / 100;
      listener?.pointsBalanceChanged(_cachedBalance);
      // 标记已领取（内存 + 本地数据库）
      await markGrabbed(packetID);
      return amount;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'grabRedPacket');
      rethrow;
    }
  }

  // ─── 查询红包详情 ─────────────────────────────────────────────────────────────

  Future<RedPacketDetail> getRedPacketDetail(String packetID) async {
    _log.info('packetID=$packetID', methodName: 'getRedPacketDetail');
    try {
      final resp = await HttpClient().chatPost('/red_packet/detail', data: {'packetID': packetID});
      if (!resp.isSuccess) {
        throw Exception('getRedPacketDetail failed: ${resp.errMsg}');
      }
      return RedPacketDetail.fromJson(resp.data as Map<String, dynamic>);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getRedPacketDetail');
      rethrow;
    }
  }

  // ─── 积分余额 ─────────────────────────────────────────────────────────────────

  /// 拉取当前用户积分余额（同时更新本地缓存）
  Future<double> getPointsBalance() async {
    try {
      final resp = await HttpClient().chatPost('/points/balance', data: {});
      if (!resp.isSuccess) throw Exception('getPointsBalance failed: ${resp.errMsg}');
      _cachedBalance = ((resp.data['balance'] as num).toDouble() * 100).roundToDouble() / 100;
      listener?.pointsBalanceChanged(_cachedBalance);
      return _cachedBalance;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getPointsBalance');
      rethrow;
    }
  }

  // ─── 积分流水 ─────────────────────────────────────────────────────────────────

  /// 查询当前用户积分流水（分页）
  Future<(int total, List<PointsTransaction> items)> getPointsTransactions({
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    try {
      final resp = await HttpClient().chatPost(
        '/points/transactions',
        data: {'pageNumber': pageNumber, 'showNumber': showNumber},
      );
      if (!resp.isSuccess) throw Exception('getPointsTransactions failed: ${resp.errMsg}');
      final total = (resp.data['total'] as num).toInt();
      final list = (resp.data['transactions'] as List<dynamic>)
          .map((e) => PointsTransaction.fromJson(e as Map<String, dynamic>))
          .toList();
      return (total, list);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getPointsTransactions');
      rethrow;
    }
  }

  // ─── Business Notification 分发 ───────────────────────────────────────────────

  /// 由 [MessageManager] 在收到 customBusinessListener 回调时调用；
  /// 根据 key 分发到对应的红包事件回调。
  ///
  /// [key]  - business notification key（如 "red_packet_grabbed"）
  /// [data] - JSON 字符串
  @internal
  void dispatchBusinessNotification(String key, String data) {
    try {
      switch (key) {
        case 'red_packet_expired':
          // data 可能是 packetID 字符串
          String packetID;
          try {
            packetID = (jsonDecode(data) as Map<String, dynamic>)['packetID'] as String;
          } catch (_) {
            packetID = data;
          }
          listener?.redPacketExpired(packetID);
        case 'points_adjusted':
          try {
            final map = jsonDecode(data) as Map<String, dynamic>;
            final newBalance = ((map['balance'] as num).toDouble() * 100).roundToDouble() / 100;
            _cachedBalance = newBalance;
            listener?.pointsBalanceChanged(_cachedBalance);
          } catch (e) {
            _log.error('points_adjusted parse error: $e', methodName: 'dispatch');
          }
        default:
          break;
      }
    } catch (e) {
      _log.error('dispatchBusinessNotification error: $e', methodName: 'dispatch');
    }
  }
}
