import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' show min;

import 'package:logging/logging.dart';

import '../../protocol_gen/sdkws/sdkws.pb.dart' as sdkws;
import '../api/message_api.dart';
import '../concurrency/serial_task_queue.dart';
import '../db/db_engine.dart';
import '../enums/message_status.dart';
import '../enums/message_type.dart';
import '../listener/advanced_msg_listener.dart';
import '../listener/conversation_listener.dart';
import '../listener/listener_for_service.dart';
import '../models/api_response.dart';
import '../models/conversation_info.dart';
import '../models/input_status_changed_data.dart';
import '../models/message.dart';
import '../models/web_socket_codec.dart';
import '../utils/im_convert.dart';
import 'entity_syncers/conversation_syncer.dart';
import 'entity_syncers/friend_syncer.dart';
import 'entity_syncers/group_syncer.dart';
import 'entity_syncers/user_syncer.dart';
import 'handlers/notification_router.dart';
import 'notification_classifier.dart';
import 'typing_state_tracker.dart';

class _HistorySyncTask {
  final String conversationID;
  final int begin;
  final int end;
  final int pullNum;

  const _HistorySyncTask({
    required this.conversationID,
    required this.begin,
    required this.end,
    required this.pullNum,
  });
}

class _ConvPushBatch {
  Map<String, dynamic>? latestMsg;
  int latestMsgSendTime = 0;
  int latestMsgSeq = 0;
  int maxSeq = 0;
  int newUnreadCount = 0;
  final List<Map<String, dynamic>> messagesToPersist = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> messagesToEmit = <Map<String, dynamic>>[];
  final Set<int> incomingSeqs = <int>{};
  final Map<String, dynamic> firstMsg;

  _ConvPushBatch({required this.firstMsg});
}

/// 统一数据同步与实时推送协调器（替代原 2,327 行 `MsgSyncer`）。
///
/// 关键修复：
/// - B-16：推送队列使用 [SerialTaskQueue] 严格串行；**先事务落库并推进水位，再触发 UI 回调**；
///   通知消息不再 `unawaited` 并发乱序执行；`doConnectedSync` 的 `finally` 检查 `_pendingConnectedSync`。
/// - B-17：通过 [NotificationClassifier] 过滤隐藏控制通知与 `2101` 撤回包，避免污染 `local_chat_logs`。
/// - B-27：复用 `db.conversations.getTotalUnreadCount()`，不拉全表会话。
class SyncCoordinator {
  final Logger _logger = Logger('openim_sdk.SyncCoordinator');

  final String loginUserID;
  final DbEngine db;
  final MessageApi messageApi;
  final FriendSyncer friendSyncer;
  final GroupSyncer groupSyncer;
  final ConversationSyncer conversationSyncer;
  final UserSyncer userSyncer;
  final NotificationRouter notificationRouter;
  final TypingStateTracker typingTracker;
  final OnAdvancedMsgListener? Function() msgListenerProvider;
  final OnConversationListener? Function() conversationListenerProvider;
  final OnListenerForService? Function() serviceListenerProvider;
  final bool Function(String senderUserID, String customData)? callSignalingInterceptor;
  final Future<void> Function()? onLowPrioritySync;

  final Map<String, int> _syncedMaxSeqs = <String, int>{};
  final SerialTaskQueue _pushQueue = SerialTaskQueue();

  bool _isSyncing = false;
  bool _reinstalled = false;
  bool _pendingConnectedSync = false;
  bool _disposed = false;

  SyncCoordinator({
    required this.loginUserID,
    required this.db,
    required this.messageApi,
    required this.friendSyncer,
    required this.groupSyncer,
    required this.conversationSyncer,
    required this.userSyncer,
    required this.notificationRouter,
    required this.typingTracker,
    required this.msgListenerProvider,
    required this.conversationListenerProvider,
    required this.serviceListenerProvider,
    this.callSignalingInterceptor,
    this.onLowPrioritySync,
  });

  /// 连接成功或重连成功后触发完整同步。
  Future<void> doConnectedSync() async {
    if (_disposed) {
      return;
    }
    if (_isSyncing) {
      _pendingConnectedSync = true;
      return;
    }
    _pendingConnectedSync = false;
    _isSyncing = true;

    try {
      await _loadSeqs();
      conversationListenerProvider()?.syncServerStart(_reinstalled);
      conversationListenerProvider()?.syncServerProgress(0);

      await Future.wait<void>(<Future<void>>[
        friendSyncer.sync(loginUserID),
        groupSyncer.sync(loginUserID),
      ]);
      conversationListenerProvider()?.syncServerProgress(30);

      await conversationSyncer.syncConversationsAndSeqs(loginUserID, reinstalled: _reinstalled);
      conversationListenerProvider()?.syncServerProgress(70);

      await Future.wait<void>(<Future<void>>[
        _syncMessages(),
        userSyncer.syncSelfUserInfo(loginUserID),
      ]);
      conversationListenerProvider()?.syncServerProgress(100);
      conversationListenerProvider()?.syncServerFinish(_reinstalled);

      await db.syncMeta.setVersionSync(
        tableName: 'app_sdk_version',
        entityID: 'app',
        versionID: 'installed',
        version: 1,
        uidList: const <String>[],
      );

      if (onLowPrioritySync != null) {
        unawaited(
          onLowPrioritySync!().catchError((Object error, StackTrace stackTrace) {
            _logger.warning('Low-priority sync error', error, stackTrace);
          }),
        );
      }
    } on Object catch (error, stackTrace) {
      _logger.severe('doConnectedSync failed', error, stackTrace);
      conversationListenerProvider()?.syncServerFailed(_reinstalled);
    } finally {
      _finishSyncCycle();
    }
  }

  /// 前台唤醒后的轻量缺口同步。
  Future<void> doWakeupSync() async {
    if (_disposed || _isSyncing) {
      return;
    }
    _isSyncing = true;
    try {
      await _loadSeqs();
      _reinstalled = false;
      conversationListenerProvider()?.syncServerStart(false);
      conversationListenerProvider()?.syncServerProgress(10);
      await conversationSyncer.syncConversationsAndSeqs(loginUserID, reinstalled: false);
      conversationListenerProvider()?.syncServerProgress(70);
      await _syncMessages();
      conversationListenerProvider()?.syncServerProgress(100);
      conversationListenerProvider()?.syncServerFinish(false);
    } on Object catch (error, stackTrace) {
      _logger.severe('doWakeupSync failed', error, stackTrace);
      conversationListenerProvider()?.syncServerFailed(false);
    } finally {
      _finishSyncCycle();
    }
  }

  /// 接收 WebSocket 推送包，通过 [SerialTaskQueue] 严格串行处理（修复 B-16）。
  void handlePushMsg(WebSocketResponse resp) {
    if (_disposed || resp.data.isEmpty) {
      return;
    }
    unawaited(_pushQueue.enqueue<void>(() => _processSinglePushResponse(resp)));
  }

  void dispose() {
    _disposed = true;
    notificationRouter.dispose();
    typingTracker.clear();
  }

  void _finishSyncCycle() {
    if (_pendingConnectedSync && !_disposed) {
      _pendingConnectedSync = false;
      _isSyncing = false;
      unawaited(doConnectedSync());
      return;
    }
    Future<void>.delayed(const Duration(seconds: 3), () {
      _isSyncing = false;
    });
  }

  Future<void> _loadSeqs() async {
    final List<Object?> results = await Future.wait<Object?>(<Future<Object?>>[
      db.syncMeta.getVersionSync('app_sdk_version', 'app'),
      db.conversations.getAllConversations(),
      db.syncMeta.getAllNotificationSeqs(),
    ]);
    final Map<String, dynamic>? installedInfo = results[0] as Map<String, dynamic>?;
    final bool installed = (installedInfo?['version'] as num?)?.toInt() == 1;
    _reinstalled = !installed;

    final List<ConversationInfo> conversations = results[1]! as List<ConversationInfo>;
    final Map<String, int> notificationSeqs = results[2]! as Map<String, int>;

    final Map<String, int> nextSeqs = <String, int>{};
    if (conversations.isNotEmpty) {
      final List<String> convIDs = conversations
          .map<String>((ConversationInfo c) => c.conversationID)
          .toList();
      final Map<String, int> maxSeqMap = await db.messages.getAllConversationNormalMsgMaxSeqs(
        convIDs,
      );
      for (final String convID in convIDs) {
        nextSeqs[convID] = maxSeqMap[convID] ?? 0;
      }
    }
    nextSeqs.addAll(notificationSeqs);

    _syncedMaxSeqs
      ..clear()
      ..addAll(nextSeqs);
    conversationSyncer.serverMaxSeqs.clear();
  }

  Future<void> _syncMessages() async {
    if (conversationSyncer.serverMaxSeqs.isEmpty) {
      return;
    }
    final Map<String, List<int>> needSyncSeqs = <String, List<int>>{};
    for (final MapEntry<String, int> entry in conversationSyncer.serverMaxSeqs.entries) {
      final String convID = entry.key;
      final int serverMaxSeq = entry.value;
      final int localMaxSeq = _syncedMaxSeqs[convID] ?? 0;
      if (_reinstalled) {
        if (convID.startsWith('n_')) {
          if (serverMaxSeq > 0) {
            _syncedMaxSeqs[convID] = serverMaxSeq;
            await db.syncMeta.upsertNotificationSeq(convID, serverMaxSeq);
          }
          continue;
        }
        if (serverMaxSeq > 0) {
          needSyncSeqs[convID] = <int>[0, serverMaxSeq];
        }
      } else if (serverMaxSeq > localMaxSeq) {
        needSyncSeqs[convID] = <int>[localMaxSeq + 1, serverMaxSeq];
      }
    }
    if (needSyncSeqs.isEmpty) {
      return;
    }
    final Set<String> updatedConvIDs = _reinstalled
        ? await _syncReinstallMsgs(needSyncSeqs)
        : await _syncHistoryByQueue(needSyncSeqs: needSyncSeqs, pullNum: 20);
    if (updatedConvIDs.isNotEmpty) {
      await _fireConversationChanged(updatedConvIDs);
    }
  }

  Future<Set<String>> _syncReinstallMsgs(Map<String, List<int>> needSyncSeqs) async {
    const int maxBatch = 50;
    final Set<String> updatedConvIDs = <String>{};
    final List<MapEntry<String, List<int>>> entries = needSyncSeqs.entries.toList();

    for (int i = 0; i < entries.length; i += maxBatch) {
      final List<MapEntry<String, List<int>>> batch = entries.sublist(
        i,
        min(i + maxBatch, entries.length),
      );
      final List<Map<String, dynamic>> seqRanges = batch
          .map<Map<String, dynamic>>(
            (MapEntry<String, List<int>> e) => <String, dynamic>{
              'conversationID': e.key,
              'begin': e.value[0],
              'end': e.value[1],
              'num': 1,
            },
          )
          .toList();
      final ApiResponse resp = await messageApi.pullMsgBySeqs(
        userID: loginUserID,
        seqRanges: seqRanges,
      );
      if (resp.errCode != 0) {
        continue;
      }
      final Map<String, dynamic> data = resp.data as Map<String, dynamic>? ?? <String, dynamic>{};
      final Map<String, dynamic> msgsByConv =
          data['msgs'] as Map<String, dynamic>? ?? <String, dynamic>{};
      await _processPulledMsgs(msgsByConv, updatedConvIDs, isReinstall: true);
      for (final MapEntry<String, List<int>> e in batch) {
        _syncedMaxSeqs[e.key] = e.value[1];
      }
    }
    return updatedConvIDs;
  }

  Future<Set<String>> _syncHistoryByQueue({
    required Map<String, List<int>> needSyncSeqs,
    required int pullNum,
  }) async {
    const int maxBatch = 50;
    final Set<String> updatedConvIDs = <String>{};
    final Queue<_HistorySyncTask> queue = Queue<_HistorySyncTask>();

    for (final MapEntry<String, List<int>> entry in needSyncSeqs.entries) {
      if (entry.value[1] >= entry.value[0]) {
        queue.add(
          _HistorySyncTask(
            conversationID: entry.key,
            begin: entry.value[0],
            end: entry.value[1],
            pullNum: pullNum,
          ),
        );
      }
    }

    while (queue.isNotEmpty) {
      final List<_HistorySyncTask> batchTasks = <_HistorySyncTask>[];
      while (queue.isNotEmpty && batchTasks.length < maxBatch) {
        batchTasks.add(queue.removeFirst());
      }
      final List<Map<String, dynamic>> seqRanges = batchTasks
          .map<Map<String, dynamic>>(
            (_HistorySyncTask t) => <String, dynamic>{
              'conversationID': t.conversationID,
              'begin': t.begin,
              'end': t.end,
              'num': t.pullNum,
            },
          )
          .toList();
      final ApiResponse resp = await messageApi.pullMsgBySeqs(
        userID: loginUserID,
        seqRanges: seqRanges,
        order: 1,
      );
      if (resp.errCode != 0) {
        continue;
      }
      final Map<String, dynamic> data = resp.data as Map<String, dynamic>? ?? <String, dynamic>{};
      final Map<String, dynamic> msgs =
          data['msgs'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final Map<String, dynamic> notifications =
          data['notificationMsgs'] as Map<String, dynamic>? ?? <String, dynamic>{};

      await _processPulledMsgs(msgs, updatedConvIDs, isReinstall: false);
      await _processPulledNotifications(notifications);

      for (final _HistorySyncTask task in batchTasks) {
        final List<int> validSeqs = _extractReturnedSeqs(task.conversationID, msgs, notifications);
        if (validSeqs.isEmpty) {
          continue;
        }
        validSeqs.sort();
        final int minSeq = validSeqs.first;
        final int maxSeq = validSeqs.last;
        if (maxSeq > (_syncedMaxSeqs[task.conversationID] ?? 0)) {
          _syncedMaxSeqs[task.conversationID] = maxSeq;
        }
        if (minSeq > task.begin) {
          queue.add(
            _HistorySyncTask(
              conversationID: task.conversationID,
              begin: task.begin,
              end: minSeq - 1,
              pullNum: task.pullNum,
            ),
          );
        }
        if (maxSeq < task.end) {
          queue.add(
            _HistorySyncTask(
              conversationID: task.conversationID,
              begin: maxSeq + 1,
              end: task.end,
              pullNum: task.pullNum,
            ),
          );
        }
      }
    }
    return updatedConvIDs;
  }

  List<int> _extractReturnedSeqs(
    String conversationID,
    Map<String, dynamic> msgs,
    Map<String, dynamic> notifications,
  ) {
    final List<int> seqs = <int>[];
    for (final Map<String, dynamic> bucket in <Map<String, dynamic>>[msgs, notifications]) {
      final dynamic convBucket = bucket[conversationID];
      if (convBucket is! Map<String, dynamic>) {
        continue;
      }
      final List<dynamic> list =
          (convBucket['Msgs'] ?? convBucket['msgs']) as List<dynamic>? ?? const <dynamic>[];
      for (final dynamic item in list) {
        if (item is Map<String, dynamic>) {
          final int seq = (item['seq'] as num?)?.toInt() ?? 0;
          if (seq > 0) {
            seqs.add(seq);
          }
        }
      }
    }
    return seqs;
  }

  Future<void> _processPulledMsgs(
    Map<String, dynamic> msgsByConv,
    Set<String> updatedConvIDs, {
    required bool isReinstall,
  }) async {
    for (final MapEntry<String, dynamic> entry in msgsByConv.entries) {
      final String convID = entry.key;
      final Map<String, dynamic> pullMsgs =
          entry.value as Map<String, dynamic>? ?? <String, dynamic>{};
      final List<dynamic> msgList =
          (pullMsgs['Msgs'] ?? pullMsgs['msgs']) as List<dynamic>? ?? const <dynamic>[];
      if (msgList.isEmpty) {
        continue;
      }

      final List<Map<String, dynamic>> toPersist = <Map<String, dynamic>>[];
      final Set<int> unreadCandidateSeqs = <int>{};
      Map<String, dynamic>? latestMsg;
      int latestSendTime = 0;
      int latestSeq = 0;
      int maxSeq = 0;

      for (final dynamic item in msgList) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final int contentType = (item['contentType'] as num?)?.toInt() ?? 0;
        final int seq = (item['seq'] as num?)?.toInt() ?? 0;
        final int sendTime = (item['sendTime'] as num?)?.toInt() ?? 0;
        final String sendID = item['sendID'] as String? ?? '';
        if (seq > maxSeq) {
          maxSeq = seq;
        }
        if (NotificationClassifier.isNotification(contentType) && !isReinstall) {
          await notificationRouter.dispatch(contentType, item['content'] as String? ?? '');
        }
        if (!NotificationClassifier.shouldPersistInChatLog(contentType)) {
          continue;
        }

        final Map<String, dynamic> row = <String, dynamic>{
          ...item,
          'conversationID': convID,
          'status': ((item['status'] as num?)?.toInt() ?? 0) == 0
              ? MessageStatus.succeeded.value
              : item['status'],
        };
        toPersist.add(row);

        if (sendTime > latestSendTime || (sendTime == latestSendTime && seq > latestSeq)) {
          latestSendTime = sendTime;
          latestSeq = seq;
          latestMsg = row;
        }

        final dynamic options = item['options'];
        final bool isUnreadOpt = options is Map<dynamic, dynamic>
            ? (options['unreadCount'] is bool ? options['unreadCount'] as bool : true)
            : true;
        if (sendID != loginUserID && seq > 0 && isUnreadOpt && contentType < 1000) {
          unreadCandidateSeqs.add(seq);
        }
      }

      if (toPersist.isNotEmpty) {
        await db.messages.batchInsertMessages(toPersist);
        if (!isReinstall) {
          final List<Message> converted = toPersist.map<Message>(convertMessage).toList();
          msgListenerProvider()?.recvOfflineNewMessages(converted);
        }
      }

      final ConversationInfo? existing = await db.conversations.getConversation(convID);
      final Map<String, dynamic> updates = <String, dynamic>{};
      if (maxSeq > 0) {
        updates['maxSeq'] = maxSeq;
      }
      if (latestMsg != null) {
        final int oldTime = existing?.latestMsgSendTime ?? 0;
        final int oldSeq = existing?.latestMsg?.seq ?? 0;
        if (isReinstall ||
            latestSendTime > oldTime ||
            (latestSendTime == oldTime && latestSeq > oldSeq)) {
          updates['latestMsg'] = jsonEncode(latestMsg);
          updates['latestMsgSendTime'] = latestSendTime;
        }
      }
      if (existing != null && unreadCandidateSeqs.isNotEmpty && !isReinstall) {
        final int hasReadSeq = await db.conversations.getConversationHasReadSeq(convID);
        int delta = 0;
        for (final int s in unreadCandidateSeqs) {
          if (s > hasReadSeq) {
            delta++;
          }
        }
        if (delta > 0) {
          updates['unreadCount'] = existing.unreadCount + delta;
        }
      }
      if (updates.isNotEmpty) {
        await db.conversations.updateConversation(convID, updates);
        updatedConvIDs.add(convID);
      }
      if (maxSeq > (_syncedMaxSeqs[convID] ?? 0)) {
        _syncedMaxSeqs[convID] = maxSeq;
      }
    }
    if (updatedConvIDs.isNotEmpty) {
      await conversationSyncer.fireTotalUnreadChanged();
    }
  }

  Future<void> _processPulledNotifications(Map<String, dynamic> notifications) async {
    for (final MapEntry<String, dynamic> entry in notifications.entries) {
      final String convID = entry.key;
      final Map<String, dynamic> pullMsgs =
          entry.value as Map<String, dynamic>? ?? <String, dynamic>{};
      final List<dynamic> list =
          (pullMsgs['Msgs'] ?? pullMsgs['msgs']) as List<dynamic>? ?? const <dynamic>[];
      for (final dynamic item in list) {
        if (item is! Map<String, dynamic>) {
          continue;
        }
        final int contentType = (item['contentType'] as num?)?.toInt() ?? 0;
        final String content = item['content'] as String? ?? '';
        final int seq = (item['seq'] as num?)?.toInt() ?? 0;
        if (NotificationClassifier.isNotification(contentType)) {
          await notificationRouter.dispatch(contentType, content);
        }
        if (seq > 0 && seq > (_syncedMaxSeqs[convID] ?? 0)) {
          _syncedMaxSeqs[convID] = seq;
          await db.syncMeta.upsertNotificationSeq(convID, seq);
        }
      }
    }
  }

  Future<void> _processSinglePushResponse(WebSocketResponse resp) async {
    final sdkws.PushMessages pushMessages = sdkws.PushMessages.fromBuffer(resp.data);
    final Map<String, int> preBatchMaxSeqs = Map<String, int>.from(_syncedMaxSeqs);
    final Map<String, _ConvPushBatch> convBatches = <String, _ConvPushBatch>{};
    final Map<String, List<int>> gapSyncRanges = <String, List<int>>{};

    // 1. 解析普通消息推送
    for (final MapEntry<String, sdkws.PullMsgs> entry in pushMessages.msgs.entries) {
      final String convID = entry.key;
      final List<sdkws.MsgData> msgList = entry.value.msgs;
      if (msgList.isEmpty) {
        continue;
      }
      final int localMaxSeq = _syncedMaxSeqs[convID] ?? 0;
      int lastSeq = 0;
      final List<Map<String, dynamic>> storageMsgs = <Map<String, dynamic>>[];

      for (final sdkws.MsgData protoMsg in msgList) {
        final Map<String, dynamic> msgMap = _msgDataToMap(protoMsg);
        final int seq = (msgMap['seq'] as int?) ?? 0;
        if (seq == 0) {
          await _collectPushMsg(msgMap, convID, convBatches);
          continue;
        }
        lastSeq = seq;
        storageMsgs.add(msgMap);
      }
      if (storageMsgs.isEmpty) {
        continue;
      }
      final int expectedLast = localMaxSeq + storageMsgs.length;
      if (lastSeq == expectedLast) {
        for (final Map<String, dynamic> msgMap in storageMsgs) {
          await _collectPushMsg(msgMap, convID, convBatches);
        }
        _syncedMaxSeqs[convID] = lastSeq;
      } else if (lastSeq > localMaxSeq) {
        gapSyncRanges[convID] = <int>[localMaxSeq + 1, lastSeq];
      }
    }

    // 2. 顺序处理通知消息推送（修复 B-16：严格 await，杜绝并发乱序）
    for (final MapEntry<String, sdkws.PullMsgs> entry in pushMessages.notificationMsgs.entries) {
      final String convID = entry.key;
      final int localMaxSeq = _syncedMaxSeqs[convID] ?? 0;
      int lastSeq = 0;
      final List<Map<String, dynamic>> storageMsgs = <Map<String, dynamic>>[];
      for (final sdkws.MsgData protoMsg in entry.value.msgs) {
        final Map<String, dynamic> msgMap = _msgDataToMap(protoMsg);
        final int seq = (msgMap['seq'] as int?) ?? 0;
        if (seq == 0) {
          await _processNotificationMsg(msgMap, convID);
          continue;
        }
        lastSeq = seq;
        storageMsgs.add(msgMap);
      }
      if (storageMsgs.isEmpty) {
        continue;
      }
      if (lastSeq == localMaxSeq + storageMsgs.length) {
        for (final Map<String, dynamic> msgMap in storageMsgs) {
          await _processNotificationMsg(msgMap, convID);
        }
        _syncedMaxSeqs[convID] = lastSeq;
      } else if (lastSeq > localMaxSeq) {
        gapSyncRanges[convID] = <int>[localMaxSeq + 1, lastSeq];
      }
    }

    // 3. 先在事务中批量落库，再触发 UI 回调（修复 B-16）
    await _commitPushBatchesAndNotify(convBatches, gapSyncRanges, preBatchMaxSeqs);
  }

  Future<void> _collectPushMsg(
    Map<String, dynamic> msg,
    String conversationID,
    Map<String, _ConvPushBatch> batches,
  ) async {
    final int seq = msg['seq'] as int? ?? 0;
    final int contentType = msg['contentType'] as int? ?? 0;
    final int sendTime = msg['sendTime'] as int? ?? 0;
    final String sendID = msg['sendID'] as String? ?? '';
    final Map<String, bool> options =
        msg['options'] as Map<String, bool>? ?? const <String, bool>{};
    final bool isHistory = options['history'] ?? true;

    if (!isHistory) {
      if (NotificationClassifier.isNotification(contentType)) {
        await notificationRouter.dispatch(contentType, msg['content'] as String? ?? '');
      }
      if (contentType == 113) {
        _handleTypingPush(msg, conversationID);
      }
      _emitOnlineOnlyMessage(msg);
      return;
    }

    if (seq == 0) {
      _emitNewMessage(msg);
      return;
    }

    if (NotificationClassifier.isNotification(contentType)) {
      await notificationRouter.dispatch(contentType, msg['content'] as String? ?? '');
    }
    if (!NotificationClassifier.shouldPersistInChatLog(contentType)) {
      return;
    }

    final _ConvPushBatch batch = batches.putIfAbsent(
      conversationID,
      () => _ConvPushBatch(firstMsg: msg),
    );
    final Map<String, dynamic> row = <String, dynamic>{
      ...msg,
      'conversationID': conversationID,
      'status': ((msg['status'] as num?)?.toInt() ?? 0) == 0
          ? MessageStatus.succeeded.value
          : msg['status'],
    };
    batch.messagesToPersist.add(row);
    batch.messagesToEmit.add(row);

    if (sendTime > batch.latestMsgSendTime ||
        (sendTime == batch.latestMsgSendTime && seq > batch.latestMsgSeq)) {
      batch.latestMsg = row;
      batch.latestMsgSendTime = sendTime;
      batch.latestMsgSeq = seq;
    }
    if (seq > batch.maxSeq) {
      batch.maxSeq = seq;
    }
    final bool isUnreadCount = options['unreadCount'] ?? true;
    if (sendID != loginUserID && seq > 0 && isUnreadCount && contentType < 1000) {
      batch.incomingSeqs.add(seq);
    }
  }

  Future<void> _commitPushBatchesAndNotify(
    Map<String, _ConvPushBatch> batches,
    Map<String, List<int>> gapSyncRanges,
    Map<String, int> preBatchMaxSeqs,
  ) async {
    final Set<String> changedConvIDs = <String>{};
    final Set<String> newConvIDs = <String>{};
    final List<Map<String, dynamic>> messagesToEmit = <Map<String, dynamic>>[];

    for (final MapEntry<String, _ConvPushBatch> entry in batches.entries) {
      final String convID = entry.key;
      final _ConvPushBatch batch = entry.value;
      final int oldSyncedSeq = preBatchMaxSeqs[convID] ?? 0;
      batch.newUnreadCount = batch.incomingSeqs.where((int s) => s > oldSyncedSeq).length;

      final ConversationInfo? existing = await db.conversations.getConversation(convID);
      final int oldMaxSeq = existing != null
          ? await db.conversations.getConversationMaxSeq(convID)
          : 0;

      await db.transaction(() async {
        if (batch.messagesToPersist.isNotEmpty) {
          await db.messages.batchInsertMessages(batch.messagesToPersist);
        }
        if (existing != null) {
          final Map<String, dynamic> updates = <String, dynamic>{};
          final int oldTime = existing.latestMsgSendTime ?? 0;
          final int oldSeq = existing.latestMsg?.seq ?? 0;
          if (batch.latestMsg != null &&
              (batch.latestMsgSendTime > oldTime ||
                  (batch.latestMsgSendTime == oldTime && batch.latestMsgSeq > oldSeq))) {
            updates['latestMsg'] = jsonEncode(batch.latestMsg);
            updates['latestMsgSendTime'] = batch.latestMsgSendTime;
          }
          if (batch.newUnreadCount > 0) {
            updates['unreadCount'] = existing.unreadCount + batch.newUnreadCount;
          }
          if (batch.maxSeq > oldMaxSeq) {
            updates['maxSeq'] = batch.maxSeq;
          }
          if (updates.isNotEmpty) {
            await db.conversations.updateConversation(convID, updates);
            changedConvIDs.add(convID);
          }
        } else {
          final Map<String, dynamic> first = batch.firstMsg;
          final int sessionType = first['sessionType'] as int? ?? 1;
          final String recvID = first['recvID'] as String? ?? '';
          final String groupID = first['groupID'] as String? ?? '';
          final String sendID = first['sendID'] as String? ?? '';
          final String? peerUserID = (sessionType == 1 || sessionType == 4)
              ? (sendID == loginUserID ? recvID : sendID)
              : null;
          final String? convGroupID = (sessionType == 2 || sessionType == 3) ? groupID : null;
          final Map<String, dynamic> convRow = <String, dynamic>{
            'conversationID': convID,
            'conversationType': sessionType,
            'userID': peerUserID,
            'groupID': convGroupID,
            'showName': first['senderNickname'] as String? ?? '',
            'faceURL': first['senderFaceUrl'] as String? ?? '',
            'latestMsg': jsonEncode(batch.latestMsg),
            'latestMsgSendTime': batch.latestMsgSendTime,
            'unreadCount': batch.newUnreadCount,
            'maxSeq': batch.maxSeq,
          };
          await db.conversations.upsertConversation(convRow);
          newConvIDs.add(convID);
        }
      });

      messagesToEmit.addAll(batch.messagesToEmit);
      if (batch.maxSeq > (_syncedMaxSeqs[convID] ?? 0)) {
        _syncedMaxSeqs[convID] = batch.maxSeq;
      }
    }

    // 落库完成后再派发消息回调
    for (final Map<String, dynamic> msg in messagesToEmit) {
      _emitNewMessage(msg);
    }

    if (gapSyncRanges.isNotEmpty) {
      final Set<String> gapUpdated = await _syncHistoryByQueue(
        needSyncSeqs: gapSyncRanges,
        pullNum: 20,
      );
      changedConvIDs.addAll(gapUpdated);
      for (final MapEntry<String, List<int>> entry in gapSyncRanges.entries) {
        if (entry.value[1] > (_syncedMaxSeqs[entry.key] ?? 0)) {
          _syncedMaxSeqs[entry.key] = entry.value[1];
        }
      }
    }

    if (changedConvIDs.isNotEmpty) {
      await _fireConversationChanged(changedConvIDs);
    }
    if (newConvIDs.isNotEmpty) {
      final List<ConversationInfo> convs = await db.conversations.getMultipleConversations(
        newConvIDs.toList(),
      );
      if (convs.isNotEmpty) {
        conversationListenerProvider()?.newConversation(convs);
      }
    }
    if (changedConvIDs.isNotEmpty || newConvIDs.isNotEmpty) {
      await conversationSyncer.fireTotalUnreadChanged();
    }
  }

  Future<void> _processNotificationMsg(Map<String, dynamic> msg, String conversationID) async {
    final int seq = msg['seq'] as int? ?? 0;
    final int contentType = msg['contentType'] as int? ?? 0;
    if (seq > 0 && seq > (_syncedMaxSeqs[conversationID] ?? 0)) {
      _syncedMaxSeqs[conversationID] = seq;
      await db.syncMeta.upsertNotificationSeq(conversationID, seq);
    }
    await notificationRouter.dispatch(contentType, msg['content'] as String? ?? '');
  }

  void _emitNewMessage(Map<String, dynamic> msg) {
    final Message message = convertMessage(msg);
    if (message.contentType == MessageType.custom) {
      final String? customData = message.customElem?.data;
      if (customData != null &&
          callSignalingInterceptor != null &&
          callSignalingInterceptor!(message.sendID ?? '', customData)) {
        return;
      }
    }
    msgListenerProvider()?.recvNewMessage(message);
    serviceListenerProvider()?.recvNewMessage(message);
  }

  void _emitOnlineOnlyMessage(Map<String, dynamic> msg) {
    final Message message = convertMessage(msg);
    if (message.contentType == MessageType.custom ||
        message.contentType == MessageType.customMsgOnlineOnly) {
      final String? customData = message.customElem?.data;
      if (customData != null &&
          callSignalingInterceptor != null &&
          callSignalingInterceptor!(message.sendID ?? '', customData)) {
        return;
      }
    }
    msgListenerProvider()?.recvOnlineOnlyMessage(message);
    serviceListenerProvider()?.recvOnlineOnlyMessage(message);
  }

  void _handleTypingPush(Map<String, dynamic> msg, String conversationID) {
    final String sendID = msg['sendID'] as String? ?? '';
    final int platformID = (msg['senderPlatformID'] as num?)?.toInt() ?? 0;
    final String content = msg['content'] as String? ?? '';
    String msgTips = '';
    try {
      final Map<String, dynamic> decoded = jsonDecode(content) as Map<String, dynamic>;
      msgTips = decoded['msgTips'] as String? ?? '';
    } catch (_) {}
    final List<int> activePlatforms = typingTracker.update(
      conversationID: conversationID,
      userID: sendID,
      platformID: platformID,
      isTyping: msgTips == 'yes',
    );
    conversationListenerProvider()?.conversationUserInputStatusChanged(
      InputStatusChangedData(
        conversationID: conversationID,
        userID: sendID,
        platformIDs: activePlatforms,
      ),
    );
  }

  Future<void> _fireConversationChanged(Set<String> convIDs) async {
    final List<ConversationInfo> list = await db.conversations.getMultipleConversations(
      convIDs.toList(),
    );
    if (list.isNotEmpty) {
      conversationListenerProvider()?.conversationChanged(list);
    }
  }

  Map<String, dynamic> _msgDataToMap(sdkws.MsgData msg) {
    return <String, dynamic>{
      'sendID': msg.sendID,
      'recvID': msg.recvID,
      'groupID': msg.groupID,
      'clientMsgID': msg.clientMsgID,
      'serverMsgID': msg.serverMsgID,
      'senderPlatformID': msg.senderPlatformID,
      'senderNickname': msg.senderNickname,
      'senderFaceUrl': msg.senderFaceURL,
      'sessionType': msg.sessionType,
      'msgFrom': msg.msgFrom,
      'contentType': msg.contentType,
      'content': utf8.decode(msg.content, allowMalformed: true),
      'seq': msg.seq.toInt(),
      'sendTime': msg.sendTime.toInt(),
      'createTime': msg.createTime.toInt(),
      'status': msg.status,
      'isRead': msg.isRead,
      'options': Map<String, bool>.from(msg.options),
      'attachedInfo': msg.attachedInfo,
      'ex': msg.ex,
    };
  }
}
