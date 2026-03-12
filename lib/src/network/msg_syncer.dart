import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/network/ws_codec.dart';
import 'package:openim_sdk/src/services/web_socket_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';

/// 会话批量更新信息（聚合同一会话的多条推送消息）
class ConvBatchUpdate {
  Map<String, dynamic>? latestMsg;
  int latestMsgSendTime = 0;
  int maxSeq = 0;
  int newUnreadCount = 0;
  final Map<String, dynamic> firstMsg;
  ConvBatchUpdate({required this.firstMsg});
}

/// 消息同步器
///
/// 对应 Go SDK 的 MsgSyncer，负责：
/// - 登录后拉取最新 seq
/// - 同步消息缺口
/// - 处理推送消息
/// - 会话已读状态同步
/// - 收到推送时更新会话（latestMsg, unreadCount, maxSeq）
class MsgSyncer {
  final _log = Logger('MsgSyncer');

  final DatabaseService _db;
  final ImApiService _api;
  late String _userID;

  /// 每个会话已同步的最大 seq
  final Map<String, int> _syncedMaxSeqs = {};

  /// 同步前本地已有的 maxSeq（用于计算消息缺口）
  final Map<String, int> _localMaxSeqsBeforeSync = {};

  /// 是否正在同步
  bool _isSyncing = false;

  /// 是否为重新安装（本地无数据）
  bool _reinstalled = false;

  // -- 以下为测试可见的读取器 --

  @visibleForTesting
  Map<String, int> get syncedMaxSeqs => _syncedMaxSeqs;

  @visibleForTesting
  bool get reinstalled => _reinstalled;

  @visibleForTesting
  bool get isSyncing => _isSyncing;

  @visibleForTesting
  DatabaseService get db => _db;

  /// 推送消息处理回调
  void Function(Map<String, dynamic> msg)? onNewMsg;

  /// 会话变更回调（通知上层刷新 UI）
  void Function(List<String> conversationIDs)? onConversationChanged;

  /// 新会话回调
  void Function(List<String> conversationIDs)? onNewConversation;

  /// 未读总数变更回调
  void Function()? onTotalUnreadCountChanged;

  /// 同步开始
  void Function(bool reinstalled)? onSyncStart;

  /// 同步进度 0-100
  void Function(int progress)? onSyncProgress;

  /// 同步完成
  void Function(bool reinstalled)? onSyncFinish;

  /// 同步失败
  void Function(bool reinstalled)? onSyncFailed;

  MsgSyncer({required WebSocketService ws, required DatabaseService db, required ImApiService api})
    : _db = db,
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

      // 1. 同步好友/群组（先同步，后续补充会话名称需要用到）
      await Future.wait([_syncFriends(), _syncJoinedGroups()]);
      onSyncProgress?.call(30);

      // 2. 同步会话列表 + seq + 未读计数 + showName/faceURL
      await _syncConversationsAndSeqs();
      onSyncProgress?.call(70);

      // 3. 同步消息缺口
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
      // 5 秒冷却期后才允许下次同步（对应 Go SDK startSync 的防重入机制）
      Future.delayed(const Duration(seconds: 5), () {
        _isSyncing = false;
      });
    }
  }

  /// 从本地数据库加载已同步的 seq
  Future<void> _loadSeqs() async {
    _syncedMaxSeqs.clear();
    _localMaxSeqsBeforeSync.clear();

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
        _localMaxSeqsBeforeSync[conversationID] = maxSeq;
      }
    }
    _log.info('已加载 ${_syncedMaxSeqs.length} 个会话的 seq');
  }

  // ---------------------------------------------------------------------------
  // 各模块同步
  // ---------------------------------------------------------------------------

  /// 同步会话列表 + seq + 未读计数 + showName/faceURL
  ///
  /// 对应 Go SDK 的 SyncAllConversationHashReadSeqs + batchAddFaceURLAndName
  Future<void> _syncConversationsAndSeqs() async {
    try {
      // 1. 从服务端获取所有会话
      final resp = await _api.getAllConversations(ownerUserID: _userID);
      if (resp.errCode != 0) {
        _log.warning('同步会话失败: ${resp.errMsg}');
        return;
      }
      final conversations = resp.data?['conversations'] as List? ?? [];
      if (conversations.isEmpty) return;

      final convMaps = <Map<String, dynamic>>[];
      final conversationIDs = <String>[];
      for (final conv in conversations) {
        if (conv is Map<String, dynamic>) {
          convMaps.add(Map<String, dynamic>.from(conv));
          if (convMaps.last['latestMsg'] is Map) {
            convMaps.last['latestMsg'] = jsonEncode(convMaps.last['latestMsg']);
          }
          if (convMaps.last["latestMsg"] is Map) {
            convMaps.last["latestMsg"] = jsonEncode(convMaps.last["latestMsg"]);
          }
          final cid = conv['conversationID'] as String?;
          if (cid != null) conversationIDs.add(cid);
        }
      }

      // 2. 获取所有会话的 seq 信息
      Map<String, dynamic> seqs = {};
      if (conversationIDs.isNotEmpty) {
        final seqResp = await _api.getConversationsHasReadAndMaxSeq(
          userID: _userID,
          conversationIDs: conversationIDs,
        );
        if (seqResp.errCode == 0) {
          seqs = seqResp.data?['seqs'] as Map<String, dynamic>? ?? {};
        }
      }

      // 3. 补充 showName/faceURL（从本地好友/用户/群组信息）
      await _batchAddFaceURLAndName(convMaps);

      // 4. 计算未读数并更新 seq 跟踪
      for (final conv in convMaps) {
        final convID = conv['conversationID'] as String?;
        if (convID == null) continue;

        final seqInfo = seqs[convID] as Map<String, dynamic>?;
        if (seqInfo != null) {
          final maxSeq = seqInfo['maxSeq'] as int? ?? 0;
          final hasReadSeq = seqInfo['hasReadSeq'] as int? ?? 0;
          final unread = (maxSeq - hasReadSeq).clamp(0, maxSeq);
          conv['unreadCount'] = unread;
          conv['maxSeq'] = maxSeq;
          conv['hasReadSeq'] = hasReadSeq;
          _syncedMaxSeqs[convID] = maxSeq;
        }
      }

      // 5. 批量写入本地数据库
      if (convMaps.isNotEmpty) {
        await _db.batchUpsertConversations(convMaps);
      }
      _log.info('已同步 ${convMaps.length} 个会话');
    } catch (e) {
      _log.warning('同步会话异常: $e');
    }
  }

  /// 批量为会话填充 showName 和 faceURL
  ///
  /// 对应 Go SDK 的 batchAddFaceURLAndName:
  /// - 单聊/通知: 优先用好友备注，否则用好友昵称，否则从用户表取
  /// - 群聊: 用群组名称和群组头像
  Future<void> _batchAddFaceURLAndName(List<Map<String, dynamic>> conversations) async {
    final userIDs = <String>{};
    final groupIDs = <String>{};

    for (final conv in conversations) {
      final type = conv['conversationType'] as int?;
      if (type == 1 || type == 4) {
        // 单聊 / 通知
        final uid = conv['userID'] as String?;
        if (uid != null && uid.isNotEmpty) userIDs.add(uid);
      } else if (type == 3) {
        // 超级群
        final gid = conv['groupID'] as String?;
        if (gid != null && gid.isNotEmpty) groupIDs.add(gid);
      }
    }

    // 批量查好友信息（优先使用备注）
    final friendMap = <String, Map<String, dynamic>>{};
    if (userIDs.isNotEmpty) {
      final friends = await _db.getFriendsByUserIDs(userIDs.toList());
      for (final f in friends) {
        final fid = f['friendUserID'] as String?;
        if (fid != null) friendMap[fid] = f;
      }
    }

    // 不在好友中的 userID，从用户表查
    final userMap = <String, Map<String, dynamic>>{};
    final notInFriendIDs = userIDs.where((id) => !friendMap.containsKey(id)).toList();
    if (notInFriendIDs.isNotEmpty) {
      final users = await _db.getUsersByIDs(notInFriendIDs);
      for (final u in users) {
        final uid = u['userID'] as String?;
        if (uid != null) userMap[uid] = u;
      }

      // Fallback: Fetch missing users from network
      final notInAnyMap = notInFriendIDs.where((id) => !userMap.containsKey(id)).toList();
      if (notInAnyMap.isNotEmpty) {
        try {
          final resp = await _api.getUsersInfo(userIDs: notInAnyMap);
          if (resp.errCode == 0) {
            final netUsers = resp.data?['usersInfo'] as List? ?? [];
            for (final u in netUsers) {
              if (u is Map<String, dynamic>) {
                final uid = u['userID'] as String?;
                if (uid != null) {
                  userMap[uid] = u;
                  // Cache it so future syncs have it
                  await _db.insertOrUpdateUser(u);
                }
              }
            }
          }
        } catch (_) {}
      }
    }

    // 批量查群组信息
    final groupMap = <String, Map<String, dynamic>>{};
    if (groupIDs.isNotEmpty) {
      final groups = await _db.getGroupsByIDs(groupIDs.toList());
      for (final g in groups) {
        final gid = g['groupID'] as String?;
        if (gid != null) groupMap[gid] = g;
      }

      final notInGroupMap = groupIDs.where((id) => !groupMap.containsKey(id)).toList();
      if (notInGroupMap.isNotEmpty) {
        try {
          final resp = await _api.getGroupsInfo(groupIDs: notInGroupMap.toList());
          if (resp.errCode == 0) {
            final netGroups = resp.data?['groupInfoList'] as List? ?? [];
            for (final g in netGroups) {
              if (g is Map<String, dynamic>) {
                final gid = g['groupID'] as String?;
                if (gid != null) {
                  groupMap[gid] = g;
                  await _db.upsertGroup(g);
                }
              }
            }
          }
        } catch (_) {}
      }
    }

    // 填充
    for (final conv in conversations) {
      final type = conv['conversationType'] as int?;
      if (type == 1 || type == 4) {
        final uid = conv['userID'] as String? ?? '';
        final friend = friendMap[uid];
        if (friend != null) {
          final remark = friend['remark'] as String? ?? '';
          conv['showName'] = remark.isNotEmpty ? remark : (friend['nickname'] as String? ?? '');
          conv['faceURL'] = friend['faceURL'] as String? ?? '';
        } else {
          final user = userMap[uid];
          if (user != null) {
            conv['showName'] = user['nickname'] as String? ?? '';
            conv['faceURL'] = user['faceURL'] as String? ?? '';
          }
        }
      } else if (type == 3) {
        final gid = conv['groupID'] as String? ?? '';
        final group = groupMap[gid];
        if (group != null) {
          conv['showName'] = group['groupName'] as String? ?? '';
          conv['faceURL'] = group['faceURL'] as String? ?? '';
        }
      }
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
            // 服务端返回的好友信息中，对方的详细信息在嵌套的 friendUser 字段中
            // 需要将其扁平化为 DB 表格的结构（主键 friendUserID = friendUser.userID）
            final friendUser = f['friendUser'] as Map<String, dynamic>? ?? {};
            batch.add({
              'friendUserID': friendUser['userID'] ?? f['userID'],
              'ownerUserID': f['ownerUserID'],
              'nickname': friendUser['nickname'],
              'faceURL': friendUser['faceURL'],
              'remark': f['remark'],
              'createTime': f['createTime'],
              'addSource': f['addSource'],
              'operatorUserID': f['operatorUserID'],
              'ex': f['ex'],
              'isPinned': f['isPinned'],
            });
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
  ///
  /// 对应 Go SDK 的 compareSeqsAndBatchSync：
  /// - connectPullNums = 1：初次连接每个会话只拉最新 1 条（用于 latestMsg）
  /// - SplitPullMsgNum = 100：累计超过 100 条时分批拉取
  Future<void> _syncMessages() async {
    try {
      if (_syncedMaxSeqs.isEmpty) return;

      // 对比服务端 maxSeq（_syncedMaxSeqs 已被 _syncConversationsAndSeqs 更新）
      // 与同步前的本地 maxSeq，找出需要拉取的会话
      final needSyncSeqs = <String, List<int>>{}; // convID -> [begin, end]

      for (final entry in _syncedMaxSeqs.entries) {
        final convID = entry.key;
        final serverMaxSeq = entry.value;
        final localMaxSeq = _localMaxSeqsBeforeSync[convID] ?? 0;
        if (serverMaxSeq > localMaxSeq) {
          needSyncSeqs[convID] = [localMaxSeq + 1, serverMaxSeq];
        }
      }

      if (needSyncSeqs.isEmpty) {
        _log.info('所有会话消息已是最新');
        return;
      }

      // 初次连接仅拉取最新 1 条（用于会话列表的 latestMsg 展示）
      const connectPullNums = 1;

      // 分批拉取，每批最多 100 个 SeqRange
      const splitPullMsgNum = 100;
      final seqRanges = <Map<String, dynamic>>[];
      final batchConvIDs = <String>[];

      for (final entry in needSyncSeqs.entries) {
        seqRanges.add({
          'conversationID': entry.key,
          'begin': entry.value[0],
          'end': entry.value[1],
          'num': connectPullNums,
        });
        batchConvIDs.add(entry.key);

        if (seqRanges.length >= splitPullMsgNum) {
          await _pullAndStoreMsgs(List.from(seqRanges), List.from(batchConvIDs));
          seqRanges.clear();
          batchConvIDs.clear();
        }
      }

      // 处理剩余
      if (seqRanges.isNotEmpty) {
        await _pullAndStoreMsgs(seqRanges, batchConvIDs);
      }

      _log.info('消息同步完成，共处理 ${needSyncSeqs.length} 个会话');
    } catch (e) {
      _log.warning('同步消息异常: $e');
    }
  }

  /// 通过 HTTP API 拉取消息并存储到本地
  Future<void> _pullAndStoreMsgs(List<Map<String, dynamic>> seqRanges, List<String> convIDs) async {
    try {
      final resp = await _api.pullMsgBySeqs(
        userID: _userID,
        seqRanges: seqRanges,
        order: 1, // 降序，拉最新的
      );
      if (resp.errCode != 0) {
        _log.warning('拉取消息失败: ${resp.errMsg}');
        return;
      }
      final data = resp.data as Map<String, dynamic>? ?? {};
      // 处理普通消息
      await _processPulledMsgs(data['msgs'] as Map<String, dynamic>? ?? {});
      // 处理通知消息
      await _processPulledMsgs(data['notificationMsgs'] as Map<String, dynamic>? ?? {});
    } catch (e) {
      _log.warning('拉取消息批次失败: $e');
    }
  }

  /// 处理拉取到的消息：存入 DB 并更新会话 latestMsg
  Future<void> _processPulledMsgs(Map<String, dynamic> msgsByConv) async {
    for (final entry in msgsByConv.entries) {
      final convID = entry.key;
      final pullMsgs = entry.value as Map<String, dynamic>? ?? {};
      final msgList = (pullMsgs['Msgs'] ?? pullMsgs['msgs']) as List? ?? [];

      if (msgList.isEmpty) continue;

      final msgMaps = <Map<String, dynamic>>[];
      Map<String, dynamic>? latestMsg;
      int maxSeq = 0;
      int latestSendTime = 0;

      for (final msg in msgList) {
        if (msg is Map<String, dynamic>) {
          // 仅存储 contentType < 1000 的普通消息到 chatLog
          final contentType = msg['contentType'] as int? ?? 0;
          if (contentType < 1000) {
            msgMaps.add(msg);
          }
          final seq = msg['seq'] as int? ?? 0;
          final sendTime = msg['sendTime'] as int? ?? 0;
          if (seq > maxSeq) {
            maxSeq = seq;
          }
          // latestMsg 选 sendTime 最新的普通消息（非通知）
          if (contentType < 1000 && sendTime >= latestSendTime) {
            latestSendTime = sendTime;
            latestMsg = msg;
          }
        }
      }

      // 批量存入消息表（注入 conversationID 以支持单条件查询）
      if (msgMaps.isNotEmpty) {
        for (final m in msgMaps) {
          m['conversationID'] = convID;
        }
        await _db.batchInsertMessages(msgMaps);
      }

      // 更新会话的 latestMsg、latestMsgSendTime 和 maxSeq
      if (latestMsg != null) {
        final sendTime = latestMsg['sendTime'] as int? ?? 0;
        final updates = <String, dynamic>{
          'latestMsg': jsonEncode(latestMsg),
          'latestMsgSendTime': sendTime,
        };
        if (maxSeq > 0) {
          updates['maxSeq'] = maxSeq;
        }
        await _db.updateConversation(convID, updates);
      } else if (maxSeq > 0) {
        // 只有通知消息，仍需更新 maxSeq
        await _db.updateConversation(convID, {'maxSeq': maxSeq});
      }

      // 更新本地已同步 seq
      if (maxSeq > (_syncedMaxSeqs[convID] ?? 0)) {
        _syncedMaxSeqs[convID] = maxSeq;
      }
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
  // 推送消息处理
  // ---------------------------------------------------------------------------

  /// 处理来自 WebSocket 的推送消息
  ///
  /// 对应 Go SDK 的 doPushMsg：
  /// 1. 解析推送体中的 msgs 和 notificationMsgs
  /// 2. 验证 SEQ 连续性，发现缺口时触发同步
  /// 3. 存储消息并更新会话（latestMsg, unreadCount, maxSeq）
  /// 4. 触发回调通知上层
  void handlePushMsg(GeneralWsResp resp) {
    if (resp.data.isEmpty) return;

    try {
      final pushData = jsonDecode(utf8.decode(resp.data)) as Map<String, dynamic>;

      // 收集需要检测 SEQ 缺口的会话
      final gapConvIDs = <String>{};

      // 按 conversationID 聚合的会话更新信息
      // key: conversationID, value: {latestMsg, latestMsgSendTime, maxSeq, newUnread, firstMsg}
      final convUpdates = <String, ConvBatchUpdate>{};

      // 处理普通消息
      final msgs = pushData['msgs'] as Map<String, dynamic>? ?? {};
      for (final entry in msgs.entries) {
        final convID = entry.key;
        final convMsgs = entry.value as Map<String, dynamic>? ?? {};
        final msgList = convMsgs['msgs'] as List? ?? [];
        if (msgList.isEmpty) continue;

        // 检测 SEQ 连续性（对应 Go SDK pushTriggerAndSync）
        final localMaxSeq = _syncedMaxSeqs[convID] ?? 0;
        int batchMaxSeq = 0;
        int batchMinSeq = 0;
        for (final msg in msgList) {
          if (msg is Map<String, dynamic>) {
            final seq = msg['seq'] as int? ?? 0;
            if (seq > 0) {
              if (batchMinSeq == 0 || seq < batchMinSeq) batchMinSeq = seq;
              if (seq > batchMaxSeq) batchMaxSeq = seq;
            }
          }
        }

        // SEQ 连续性校验
        if (batchMinSeq > localMaxSeq + 1 && localMaxSeq > 0) {
          _log.warning(
            '检测到 SEQ 缺口: conv=$convID, local=$localMaxSeq, '
            'pushMin=$batchMinSeq, pushMax=$batchMaxSeq',
          );
          gapConvIDs.add(convID);
        }

        // 处理每条消息，聚合到 convUpdates
        for (final msg in msgList) {
          if (msg is Map<String, dynamic>) {
            _collectMessageUpdate(msg, convID, convUpdates);
          }
        }
      }

      // 处理通知消息
      final notificationMsgs = pushData['notificationMsgs'] as Map<String, dynamic>? ?? {};
      for (final entry in notificationMsgs.entries) {
        final convID = entry.key;
        final convMsgs = entry.value as Map<String, dynamic>? ?? {};
        final msgList = convMsgs['msgs'] as List? ?? [];
        for (final msg in msgList) {
          if (msg is Map<String, dynamic>) {
            _processNotificationMessage(msg, convID);
          }
        }
      }

      // 批量写入会话更新 + 触发缺口同步和 UI 通知
      _applyBatchUpdatesAndNotify(convUpdates, gapConvIDs);
    } catch (e, s) {
      _log.warning('处理推送消息失败: $e', e, s);
    }
  }

  /// 收集单条消息对会话的影响（纯内存操作，不写 DB）
  void _collectMessageUpdate(
    Map<String, dynamic> msg,
    String conversationID,
    Map<String, ConvBatchUpdate> convUpdates,
  ) {
    final seq = msg['seq'] as int? ?? 0;
    final contentType = msg['contentType'] as int? ?? 0;
    final sendTime = msg['sendTime'] as int? ?? 0;
    final sendID = msg['sendID'] as String? ?? '';
    final isSelfMsg = sendID == _userID;

    // seq == 0 的消息是临时消息（如 typing），不存储
    if (seq == 0) {
      onNewMsg?.call(msg);
      return;
    }

    // 通知消息（contentType >= 1000）不存储到 chatLog，只更新 seq 并分发
    if (contentType >= 1000) {
      if (seq > (_syncedMaxSeqs[conversationID] ?? 0)) {
        _syncedMaxSeqs[conversationID] = seq;
        _db.updateConversation(conversationID, {'maxSeq': seq});
      }
      onNewMsg?.call(msg);
      return;
    }

    // 存储普通消息到 chatLog（注入 conversationID）
    _db.insertMessage({...msg, 'conversationID': conversationID});

    // 更新 seq 追踪
    final isNewSeq = seq > (_syncedMaxSeqs[conversationID] ?? 0);
    if (isNewSeq) {
      _syncedMaxSeqs[conversationID] = seq;
    }

    // 聚合会话更新
    final update = convUpdates.putIfAbsent(conversationID, () => ConvBatchUpdate(firstMsg: msg));
    if (sendTime >= update.latestMsgSendTime) {
      update.latestMsg = msg;
      update.latestMsgSendTime = sendTime;
    }
    if (seq > update.maxSeq) update.maxSeq = seq;
    if (!isSelfMsg && isNewSeq) update.newUnreadCount++;

    // 触发新消息回调
    onNewMsg?.call(msg);
  }

  /// 批量应用会话更新到 DB，并触发通知
  Future<void> _applyBatchUpdatesAndNotify(
    Map<String, ConvBatchUpdate> convUpdates,
    Set<String> gapConvIDs,
  ) async {
    final changedConvIDs = <String>{};
    final newConvIDs = <String>{};

    for (final entry in convUpdates.entries) {
      final convID = entry.key;
      final update = entry.value;

      try {
        final existing = await _db.getConversation(convID);
        if (existing != null) {
          // 更新已有会话
          final updates = <String, dynamic>{};
          final existingLatestTime = existing['latestMsgSendTime'] as int? ?? 0;
          if (update.latestMsgSendTime >= existingLatestTime) {
            updates['latestMsg'] = jsonEncode(update.latestMsg);
            updates['latestMsgSendTime'] = update.latestMsgSendTime;
          }
          if (update.newUnreadCount > 0) {
            final oldUnread = existing['unreadCount'] as int? ?? 0;
            updates['unreadCount'] = oldUnread + update.newUnreadCount;
          }
          final oldMaxSeq = existing['maxSeq'] as int? ?? 0;
          if (update.maxSeq > oldMaxSeq) {
            updates['maxSeq'] = update.maxSeq;
          }
          if (updates.isNotEmpty) {
            await _db.updateConversation(convID, updates);
            changedConvIDs.add(convID);
          }
        } else {
          // 创建新会话
          final msg = update.firstMsg;
          final sessionType = msg['sessionType'] as int? ?? 0;
          final recvID = msg['recvID'] as String? ?? '';
          final groupID = msg['groupID'] as String? ?? '';
          final msgSendID = msg['sendID'] as String? ?? '';
          final isSelfMsg = msgSendID == _userID;

          String? userID;
          String? convGroupID;
          if (sessionType == 1) {
            userID = isSelfMsg ? recvID : msgSendID;
          } else if (sessionType == 3) {
            convGroupID = groupID;
          } else if (sessionType == 4) {
            userID = isSelfMsg ? recvID : msgSendID;
          }

          await _db.upsertConversation({
            'conversationID': convID,
            'conversationType': sessionType,
            'userID': userID,
            'groupID': convGroupID,
            'showName': msg['senderNickname'] as String? ?? '',
            'faceURL': msg['senderFaceUrl'] as String? ?? '',
            'latestMsg': jsonEncode(update.latestMsg),
            'latestMsgSendTime': update.latestMsgSendTime,
            'unreadCount': update.newUnreadCount,
            'maxSeq': update.maxSeq,
          });

          newConvIDs.add(convID);
          _enrichNewConversation(convID, sessionType, userID, convGroupID);
        }
      } catch (e) {
        _log.warning('批量更新会话失败: conv=$convID, $e');
      }
    }

    // 缺口同步
    if (gapConvIDs.isNotEmpty) {
      _syncMissingMessages(gapConvIDs);
    }

    // 通知 UI
    if (changedConvIDs.isNotEmpty) {
      onConversationChanged?.call(changedConvIDs.toList());
    }
    if (newConvIDs.isNotEmpty) {
      onNewConversation?.call(newConvIDs.toList());
    }
    if (changedConvIDs.isNotEmpty || newConvIDs.isNotEmpty) {
      onTotalUnreadCountChanged?.call();
    }
  }

  /// 异步补充新会话的 showName 和 faceURL
  Future<void> _enrichNewConversation(
    String conversationID,
    int sessionType,
    String? userID,
    String? groupID,
  ) async {
    try {
      final updates = <String, dynamic>{};

      if ((sessionType == 1 || sessionType == 4) && userID != null && userID.isNotEmpty) {
        // 单聊/通知：优先用好友备注
        final friend = await _db.getFriendByUserID(userID);
        if (friend != null) {
          final remark = friend['remark'] as String? ?? '';
          updates['showName'] = remark.isNotEmpty ? remark : (friend['nickname'] as String? ?? '');
          updates['faceURL'] = friend['faceURL'] as String? ?? '';
        } else {
          // 从用户表查
          final users = await _db.getUsersByIDs([userID]);
          if (users.isNotEmpty) {
            updates['showName'] = users.first['nickname'] as String? ?? '';
            updates['faceURL'] = users.first['faceURL'] as String? ?? '';
          }
        }
      } else if (sessionType == 3 && groupID != null && groupID.isNotEmpty) {
        // 群聊：用群组名称
        final group = await _db.getGroupByID(groupID);
        if (group != null) {
          updates['showName'] = group['groupName'] as String? ?? '';
          updates['faceURL'] = group['faceURL'] as String? ?? '';
        }
      }

      if (updates.isNotEmpty) {
        await _db.updateConversation(conversationID, updates);
      }
    } catch (e) {
      _log.fine('补充会话信息失败: $conversationID, $e');
    }
  }

  /// 处理通知消息（好友/群组/会话变更等系统通知）
  ///
  /// 通知消息不存入 chatLog，但需要：
  /// 1. 更新 seq 追踪
  /// 2. 通过 onNewMsg 分发给 NotificationDispatcher
  void _processNotificationMessage(Map<String, dynamic> msg, String conversationID) {
    final seq = msg['seq'] as int? ?? 0;

    // 更新 seq
    if (seq > 0 && seq > (_syncedMaxSeqs[conversationID] ?? 0)) {
      _syncedMaxSeqs[conversationID] = seq;
      _db.updateConversation(conversationID, {'maxSeq': seq});
    }

    // 通知消息通过 onNewMsg 分发，由上层 NotificationDispatcher 解析
    onNewMsg?.call(msg);
  }

  /// 检测并同步 SEQ 缺口（对应 Go SDK compareSeqsAndBatchSync 的部分逻辑）
  Future<void> _syncMissingMessages(Set<String> convIDs) async {
    try {
      // 获取这些会话的服务端最新 maxSeq
      final seqRanges = <Map<String, dynamic>>[];
      for (final convID in convIDs) {
        final localMax = _syncedMaxSeqs[convID] ?? 0;
        // 向服务端请求该会话的 maxSeq → 拉取缺失区间
        // 简化实现：拉取 localMax+1 到 localMax+200 的消息
        seqRanges.add({
          'conversationID': convID,
          'begin': localMax + 1,
          'end': localMax + 200,
          'num': 0, // 0 表示不限制条数
        });
      }

      if (seqRanges.isNotEmpty) {
        await _pullAndStoreMsgs(seqRanges, convIDs.toList());
        _log.info('缺口同步完成: ${convIDs.length} 个会话');
      }
    } catch (e) {
      _log.warning('缺口同步失败: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 以下方法仅供测试使用
  // ---------------------------------------------------------------------------

  @visibleForTesting
  Future<void> loadSeqs() => _loadSeqs();

  @visibleForTesting
  Future<void> processPulledMsgs(Map<String, dynamic> msgsByConv) => _processPulledMsgs(msgsByConv);

  @visibleForTesting
  Future<void> batchAddFaceURLAndName(List<Map<String, dynamic>> conversations) =>
      _batchAddFaceURLAndName(conversations);

  @visibleForTesting
  void collectMessageUpdate(
    Map<String, dynamic> msg,
    String conversationID,
    Map<String, ConvBatchUpdate> convUpdates,
  ) => _collectMessageUpdate(msg, conversationID, convUpdates);

  @visibleForTesting
  Future<void> applyBatchUpdatesAndNotify(
    Map<String, ConvBatchUpdate> convUpdates,
    Set<String> gapConvIDs,
  ) => _applyBatchUpdatesAndNotify(convUpdates, gapConvIDs);

  @visibleForTesting
  Future<void> enrichNewConversation(
    String conversationID,
    int sessionType,
    String? userID,
    String? groupID,
  ) => _enrichNewConversation(conversationID, sessionType, userID, groupID);

  @visibleForTesting
  void processNotificationMessage(Map<String, dynamic> msg, String conversationID) =>
      _processNotificationMessage(msg, conversationID);
}
