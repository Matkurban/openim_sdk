import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:openim_sdk/src/db/database_service.dart';
import 'package:openim_sdk/src/network/ws_codec.dart';
import 'package:openim_sdk/src/network/ws_connection_manager.dart';
import 'package:openim_sdk/src/network/ws_constants.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';

/// 消息同步器
///
/// 对应 Go SDK 的 MsgSyncer，负责：
/// - 登录后拉取最新 seq
/// - 同步消息缺口
/// - 处理推送消息
/// - 会话已读状态同步
class MsgSyncer {
  final _log = Logger('MsgSyncer');

  final WsConnectionManager _ws;
  final DatabaseService _db;
  final ImApiService _api;
  late String _userID;

  /// 每个会话已同步的最大 seq
  final Map<String, int> _syncedMaxSeqs = {};

  /// 是否正在同步
  bool _isSyncing = false;

  /// 是否为重新安装（本地无数据）
  bool _reinstalled = false;

  /// 推送消息处理回调
  void Function(Map<String, dynamic> msg)? onNewMsg;

  /// 同步开始
  void Function(bool reinstalled)? onSyncStart;

  /// 同步进度 0-100
  void Function(int progress)? onSyncProgress;

  /// 同步完成
  void Function(bool reinstalled)? onSyncFinish;

  /// 同步失败
  void Function(bool reinstalled)? onSyncFailed;

  MsgSyncer({
    required WsConnectionManager ws,
    required DatabaseService db,
    required ImApiService api,
  }) : _ws = ws,
       _db = db,
       _api = api;

  /// 设置当前用户 ID
  void setLoginUserID(String userID) {
    _userID = userID;
  }

  // ---------------------------------------------------------------------------
  // 初始同步
  // ---------------------------------------------------------------------------

  /// 连接成功后触发的数据同步
  Future<void> doConnectedSync() async {
    if (_isSyncing) {
      _log.info('正在同步中，忽略重复触发');
      return;
    }
    _isSyncing = true;

    try {
      // 检测是否为重新安装
      await _loadSeqs();
      onSyncStart?.call(_reinstalled);
      onSyncProgress?.call(0);

      // 1. 同步会话列表
      await _syncConversations();
      onSyncProgress?.call(30);

      // 2. 同步好友/群组
      await Future.wait([_syncFriends(), _syncJoinedGroups()]);
      onSyncProgress?.call(60);

      // 3. 同步消息 seq 并拉取缺失消息
      await _syncMessages();
      onSyncProgress?.call(90);

      // 4. 同步自身用户信息
      await _syncSelfUserInfo();
      onSyncProgress?.call(100);

      onSyncFinish?.call(_reinstalled);
      _log.info('数据同步完成');
    } catch (e, s) {
      _log.severe('数据同步失败', e, s);
      onSyncFailed?.call(_reinstalled);
    } finally {
      _isSyncing = false;
    }
  }

  /// 从本地数据库加载已同步的 seq
  Future<void> _loadSeqs() async {
    _syncedMaxSeqs.clear();

    final conversations = await _db.getAllConversations();
    if (conversations.isEmpty) {
      _reinstalled = true;
      return;
    }
    _reinstalled = false;

    for (final conv in conversations) {
      final conversationID = conv['conversationID'] as String?;
      final maxSeq = conv['maxSeq'] as int? ?? 0;
      if (conversationID != null) {
        _syncedMaxSeqs[conversationID] = maxSeq;
      }
    }
    _log.info('已加载 ${_syncedMaxSeqs.length} 个会话的 seq');
  }

  // ---------------------------------------------------------------------------
  // 各模块同步
  // ---------------------------------------------------------------------------

  /// 同步会话列表
  Future<void> _syncConversations() async {
    try {
      final resp = await _api.getAllConversations(ownerUserID: _userID);
      if (resp.errCode != 0) {
        _log.warning('同步会话失败: ${resp.errMsg}');
        return;
      }
      final conversations = resp.data?['conversations'] as List? ?? [];
      final batch = <Map<String, dynamic>>[];
      for (final conv in conversations) {
        if (conv is Map<String, dynamic>) {
          batch.add(conv);
        }
      }
      if (batch.isNotEmpty) await _db.batchUpsertConversations(batch);
      _log.info('已同步 ${conversations.length} 个会话');
    } catch (e) {
      _log.warning('同步会话异常: $e');
    }
  }

  /// 同步好友列表
  Future<void> _syncFriends() async {
    try {
      int pageNumber = 1;
      const pageSize = 100;
      while (true) {
        final resp = await _api.getFriendList(
          userID: _userID,
          offset: (pageNumber - 1) * pageSize,
          count: pageSize,
        );
        if (resp.errCode != 0) break;
        final friends = resp.data?['friendsInfo'] as List? ?? [];
        if (friends.isEmpty) break;
        final batch = <Map<String, dynamic>>[];
        for (final f in friends) {
          if (f is Map<String, dynamic>) {
            batch.add(f);
          }
        }
        if (batch.isNotEmpty) await _db.batchUpsertFriends(batch);
        if (friends.length < pageSize) break;
        pageNumber++;
      }
      _log.info('好友同步完成');
    } catch (e) {
      _log.warning('同步好友异常: $e');
    }
  }

  /// 同步已加入的群组
  Future<void> _syncJoinedGroups() async {
    try {
      int pageNumber = 1;
      const pageSize = 100;
      while (true) {
        final resp = await _api.getJoinedGroupList(
          fromUserID: _userID,
          offset: (pageNumber - 1) * pageSize,
          count: pageSize,
        );
        if (resp.errCode != 0) break;
        final groups = resp.data?['groups'] as List? ?? [];
        if (groups.isEmpty) break;
        final batch = <Map<String, dynamic>>[];
        for (final g in groups) {
          if (g is Map<String, dynamic>) {
            batch.add(g);
          }
        }
        if (batch.isNotEmpty) await _db.batchUpsertGroups(batch);
        if (groups.length < pageSize) break;
        pageNumber++;
      }
      _log.info('群组同步完成');
    } catch (e) {
      _log.warning('同步群组异常: $e');
    }
  }

  /// 同步消息（拉取缺口）
  Future<void> _syncMessages() async {
    try {
      // 获取服务端各会话的最新 seq
      final conversationIDs = _syncedMaxSeqs.keys.toList();
      if (conversationIDs.isEmpty) return;

      final resp = await _api.getConversationsHasReadAndMaxSeq(conversationIDs: conversationIDs);
      if (resp.errCode != 0) return;

      final seqMap = resp.data?['maxSeqs'] as Map<String, dynamic>? ?? {};
      for (final entry in seqMap.entries) {
        final convID = entry.key;
        final serverMaxSeq = entry.value as int? ?? 0;
        final localMaxSeq = _syncedMaxSeqs[convID] ?? 0;
        if (serverMaxSeq > localMaxSeq) {
          await _pullMsgsByRange(convID, localMaxSeq + 1, serverMaxSeq);
          _syncedMaxSeqs[convID] = serverMaxSeq;
        }
      }
      _log.info('消息同步完成');
    } catch (e) {
      _log.warning('同步消息异常: $e');
    }
  }

  /// 同步自身用户信息
  Future<void> _syncSelfUserInfo() async {
    try {
      final resp = await _api.getUsersInfo(userIDs: [_userID]);
      if (resp.errCode != 0) return;
      final users = resp.data?['usersInfo'] as List? ?? [];
      if (users.isNotEmpty && users.first is Map<String, dynamic>) {
        await _db.insertOrUpdateUser(users.first as Map<String, dynamic>);
      }
    } catch (e) {
      _log.warning('同步用户信息异常: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // WebSocket 消息拉取
  // ---------------------------------------------------------------------------

  /// 通过 WebSocket 按 seq 范围拉取消息
  Future<void> _pullMsgsByRange(String conversationID, int minSeq, int maxSeq) async {
    const batchSize = 100;
    for (int start = minSeq; start <= maxSeq; start += batchSize) {
      final end = (start + batchSize - 1).clamp(start, maxSeq);
      try {
        final reqData = utf8.encode(
          jsonEncode({'conversationID': conversationID, 'minSeq': start, 'maxSeq': end}),
        );

        final resp = await _ws.sendReqWaitResp(
          reqIdentifier: WsReqIdentifier.pullMsgByRange,
          data: Uint8List.fromList(reqData),
        );

        if (resp.isSuccess && resp.data.isNotEmpty) {
          final msgData = jsonDecode(utf8.decode(resp.data));
          final msgs = msgData['msgs'] as List? ?? [];
          for (final msg in msgs) {
            if (msg is Map<String, dynamic>) {
              await _db.insertMessage(msg);
            }
          }
        }
      } catch (e) {
        _log.warning('拉取消息失败: conversationID=$conversationID, seq=$start-$end, $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // 推送消息处理
  // ---------------------------------------------------------------------------

  /// 处理来自 WebSocket 的推送消息
  void handlePushMsg(GeneralWsResp resp) {
    if (resp.data.isEmpty) return;

    try {
      final pushData = jsonDecode(utf8.decode(resp.data)) as Map<String, dynamic>;

      // 处理普通消息
      final msgs = pushData['msgs'] as Map<String, dynamic>? ?? {};
      for (final entry in msgs.entries) {
        final convMsgs = entry.value as Map<String, dynamic>? ?? {};
        final msgList = convMsgs['msgs'] as List? ?? [];
        for (final msg in msgList) {
          if (msg is Map<String, dynamic>) {
            _processNewMessage(msg);
          }
        }
      }

      // 处理通知消息
      final notificationMsgs = pushData['notificationMsgs'] as Map<String, dynamic>? ?? {};
      for (final entry in notificationMsgs.entries) {
        final convMsgs = entry.value as Map<String, dynamic>? ?? {};
        final msgList = convMsgs['msgs'] as List? ?? [];
        for (final msg in msgList) {
          if (msg is Map<String, dynamic>) {
            _processNotificationMessage(msg);
          }
        }
      }
    } catch (e) {
      _log.warning('处理推送消息失败: $e');
    }
  }

  /// 处理新的普通消息
  Future<void> _processNewMessage(Map<String, dynamic> msg) async {
    // 保存到本地数据库
    await _db.insertMessage(msg);

    // 更新会话 seq
    final conversationID = _getConversationID(msg);
    final seq = msg['seq'] as int? ?? 0;
    if (conversationID != null && seq > (_syncedMaxSeqs[conversationID] ?? 0)) {
      _syncedMaxSeqs[conversationID] = seq;
    }

    // 回调
    onNewMsg?.call(msg);
  }

  /// 处理通知消息（好友/群组/会话变更等系统通知）
  void _processNotificationMessage(Map<String, dynamic> msg) {
    // 通知消息也通过 onNewMsg 分发，由上层 NotificationDispatcher 解析
    onNewMsg?.call(msg);
  }

  String? _getConversationID(Map<String, dynamic> msg) {
    final sessionType = msg['sessionType'] as int? ?? 0;
    final sendID = msg['sendID'] as String? ?? '';
    final recvID = msg['recvID'] as String? ?? '';
    final groupID = msg['groupID'] as String? ?? '';

    switch (sessionType) {
      case 1: // 单聊（排序保证一致性）
        final ids = [sendID, recvID]..sort();
        return 'si_${ids[0]}_${ids[1]}';
      case 3: // 超大群
        return 'sg_$groupID';
      case 4: // 通知（排序保证一致性）
        final ids = [sendID, recvID]..sort();
        return 'sn_${ids[0]}_${ids[1]}';
      default:
        return null;
    }
  }
}
