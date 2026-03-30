import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' show max, min;

import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/protocol_gen/sdkws/sdkws.pb.dart' as sdkws;
import 'package:openim_sdk/src/network/notification_dispatcher.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/models/web_socket_codec.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';

import '../utils/im_convert.dart';

/// 会话批量更新信息（聚合同一会话的多条推送消息）
class ConvBatchUpdate {
  Map<String, dynamic>? latestMsg;
  int latestMsgSendTime = 0;
  int latestMsgSeq = 0;
  int maxSeq = 0;
  int newUnreadCount = 0;
  final List<Map<String, dynamic>> pendingMessages = [];
  final Set<int> incomingSeqs = <int>{};
  final Map<String, dynamic> firstMsg;
  ConvBatchUpdate({required this.firstMsg});
}

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

/// 消息同步器
///
/// 对应 Go SDK 的 MsgSyncer，负责：
/// - 登录后拉取最新 seq
/// - 同步消息缺口
/// - 处理推送消息
/// - 会话已读状态同步
/// - 收到推送时更新会话（latestMsg, unreadCount, maxSeq）
class MsgSyncer {
  final AoiweLogger _log = AoiweLogger('MsgSyncer');

  final DatabaseService database;

  final ImApiService api;

  final NotificationDispatcher notificationDispatcher;

  final MessageManager messageManager;

  final ConversationManager conversationManager;

  final MomentsManager momentsManager;

  final FavoriteManager favoriteManager;

  CallManager? callManager;

  OnListenerForService? listenerForService;

  OnAdvancedMsgListener? get msgListener => messageManager.msgListener;

  OnConversationListener? get conversationListener => conversationManager.listener;

  MsgSyncer({
    required this.database,
    required this.api,
    required this.notificationDispatcher,
    required this.messageManager,
    required this.conversationManager,
    required this.momentsManager,
    required this.favoriteManager,
  });

  late String _userID;

  /// 每个会话已同步的最大 seq（从消息表加载，对齐 Go SDK syncedMaxSeqs）
  final Map<String, int> _syncedMaxSeqs = {};

  /// 服务端各会话的最大 seq（由 _syncConversationsAndSeqs 填充，对齐 Go SDK GetMaxSeq 返回值）
  final Map<String, int> _serverMaxSeqs = {};

  /// 是否正在同步
  bool _isSyncing = false;

  /// 是否为重新安装（本地无数据）
  bool _reinstalled = false;

  /// 同步锁：doConnectedSync / doWakeupSync 运行期间为 true，
  /// 推送队列消费会暂停直到同步完成，对齐 Go SDK DoListener 的串行语义。
  bool _isSyncLocked = false;

  /// 当 doConnectedSync 被 _isSyncing 阻挡时置为 true，
  /// 当前同步完成后自动触发 doConnectedSync，避免重连同步被丢弃。
  bool _pendingConnectedSync = false;

  // ---- 推送消息处理队列 ----
  /// 推送消息队列：保证顺序处理，避免并发 DB 写入竞争
  final Queue<WebSocketResponse> _pushMsgQueue = Queue<WebSocketResponse>();

  /// 队列是否正在消费中
  bool _isDrainingPushQueue = false;

  /// 设置当前用户 ID
  void setLoginUserID(String userID) {
    _log.info('userID=$userID', methodName: 'setLoginUserID');
    try {
      _userID = userID;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setLoginUserID');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 初始同步
  // ---------------------------------------------------------------------------

  /// 连接成功后触发的数据同步
  Future<void> doConnectedSync() async {
    _log.info('called', methodName: 'doConnectedSync');
    if (_isSyncing) {
      _log.info('正在同步中，标记待执行', methodName: 'doConnectedSync');
      _pendingConnectedSync = true;
      return;
    }
    _pendingConnectedSync = false;
    _isSyncing = true;
    _isSyncLocked = true;

    try {
      // 检测是否为重新安装
      await _loadSeqs();
      conversationListener?.syncServerStart(_reinstalled);
      conversationListener?.syncServerProgress(0);

      // 1. 同步好友/群组（先同步，后续补充会话名称需要用到）
      await Future.wait([_syncFriends(), _syncJoinedGroups()]);
      conversationListener?.syncServerProgress(30);

      // 2. 同步会话列表 + seq + 未读计数 + showName/faceURL
      await _syncConversationsAndSeqs();
      conversationListener?.syncServerProgress(70);

      // 3. 同步消息缺口 + 自身用户信息（并行，互不依赖）
      await Future.wait([_syncMessages(), _syncSelfUserInfo()]);
      conversationListener?.syncServerProgress(100);

      conversationListener?.syncServerFinish(_reinstalled);
      // 对齐 Go SDK：安装标记在成功首次同步后置为 Installed
      await database.setVersionSync(
        tableName: 'app_sdk_version',
        entityID: 'app',
        versionID: 'installed',
        version: 1,
        uidList: const [],
      );
      _log.info('数据同步完成', methodName: 'doConnectedSync');

      // 4. 低优先级同步：朋友圈 + 收藏夹（不阻塞主同步，后台并行）
      unawaited(
        Future.wait([
          momentsManager.syncFromServer(),
          favoriteManager.syncFromServer(),
        ]).then((_) {}).catchError((Object e, StackTrace s) {
          _log.error('朋友圈/收藏夹同步异常: $e', error: e, stackTrace: s, methodName: 'doConnectedSync');
        }),
      );
    } catch (e, s) {
      _log.error('数据同步失败', error: e, stackTrace: s, methodName: 'doConnectedSync');
      conversationListener?.syncServerFailed(_reinstalled);
    } finally {
      _isSyncLocked = false;
      // 同步完成后立即排空暂停期间积累的推送消息
      _triggerDrainIfNeeded();
      // 5 秒冷却期后才允许下次同步（对应 Go SDK startSync 的防重入机制）
      Future.delayed(const Duration(seconds: 5), () {
        _isSyncing = false;
      });
    }
  }

  /// 前台唤醒后的轻量同步（对齐 Go SDK doWakeupDataSync）
  ///
  /// Go SDK 的 doWakeupDataSync 不调用 LoadSeq、不重新判断 reinstalled，
  /// 仅获取服务端最新 maxSeq 后做缺口补偿。
  /// Dart 实现对齐：刷新本地 seq（但强制 _reinstalled=false），
  /// 始终走 gap-filling 路径而非 reinstall 路径。
  Future<void> doWakeupSync() async {
    _log.info('called', methodName: 'doWakeupSync');
    if (_isSyncing) return;
    _isSyncing = true;
    _isSyncLocked = true;

    try {
      await _loadSeqs();
      // 对齐 Go SDK doWakeupDataSync：唤醒同步永远不是重装场景。
      // Go SDK 在首次 doConnected 后就将 reinstalled 置 false，
      // 后续 doWakeupDataSync 始终走 gap-filling 路径。
      _reinstalled = false;

      conversationListener?.syncServerStart(false);
      conversationListener?.syncServerProgress(10);

      await _syncConversationsAndSeqs();
      conversationListener?.syncServerProgress(70);

      await _syncMessages();
      conversationListener?.syncServerProgress(100);

      conversationListener?.syncServerFinish(false);
    } catch (e, s) {
      _log.error('前台唤醒同步失败: $e', error: e, stackTrace: s, methodName: 'doWakeupSync');
      conversationListener?.syncServerFailed(false);
    } finally {
      _isSyncLocked = false;
      _triggerDrainIfNeeded();
      // 如果唤醒期间 WS 重连触发了 doConnectedSync 但被阻塞，
      // 现在立即执行，确保重连同步不被丢弃。
      if (_pendingConnectedSync) {
        _pendingConnectedSync = false;
        _isSyncing = false;
        unawaited(doConnectedSync());
      } else {
        Future.delayed(const Duration(seconds: 5), () {
          _isSyncing = false;
        });
      }
    }
  }

  /// 从本地数据库加载已同步的 seq
  ///
  /// 对齐 Go SDK LoadSeq：从消息表读取 MAX(seq) 作为 syncedMaxSeqs，
  /// 而非会话表的 maxSeq。后者是服务端声明值，可能在消息拉取不完整时已提前推进，
  /// 导致后续同步无法检测到缺口。
  ///
  /// 使用原子替换（构建新 map 后一次性覆写），避免 clear() 后 await 期间
  /// 并发推送读到空 map 导致误判 seq 缺口。
  Future<void> _loadSeqs() async {
    _log.info('called', methodName: '_loadSeqs');
    try {
      // 并行加载互不依赖的 DB 数据：安装标记、所有会话、通知 seq
      final results = await Future.wait([
        database.getVersionSync('app_sdk_version', 'app'),
        database.getAllConversations(),
        database.getAllNotificationSeqs(),
      ]);

      // 对齐 Go：使用持久化 Installed 标记判定重装
      final installedInfo = results[0] as Map<String, dynamic>?;
      final bool installed = (installedInfo?['version'] as num?)?.toInt() == 1;
      _reinstalled = !installed;

      final conversations = results[1] as List<ConversationInfo>;
      final notificationSeqs = results[2] as Map<String, int>;

      final newSyncedMaxSeqs = <String, int>{};

      // 对齐 Go SDK CheckConversationNormalMsgSeq：从消息表读取实际已存储的 MAX(seq)
      if (conversations.isNotEmpty) {
        final convIDs = conversations.map((c) => c.conversationID).toList();
        final allSeqs = await database.getAllConversationNormalMsgMaxSeqs(convIDs);
        for (final conv in conversations) {
          final conversationID = conv.conversationID;
          final maxSeq = allSeqs[conversationID] ?? 0;
          newSyncedMaxSeqs[conversationID] = maxSeq;
        }
      }

      // 通知会话 seq 独立持久化恢复（对齐 Go notification_seqs 语义）
      for (final entry in notificationSeqs.entries) {
        newSyncedMaxSeqs[entry.key] = entry.value;
      }

      // 原子替换：一次性覆写，消除 clear() 后 await 间隙的空窗
      _syncedMaxSeqs.clear();
      _syncedMaxSeqs.addAll(newSyncedMaxSeqs);
      _serverMaxSeqs.clear();
      _log.info('已加载 ${_syncedMaxSeqs.length} 个会话的 seq', methodName: '_loadSeqs');
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_loadSeqs');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 各模块同步
  // ---------------------------------------------------------------------------

  /// 同步会话列表 + seq + 未读计数 + showName/faceURL
  ///
  /// 对应 Go SDK 的 SyncAllConversationHashReadSeqs + batchAddFaceURLAndName
  /// 优化：先获取服务端 seqs，比较本地会话，只获取/更新有变化的会话
  /// 初次安装时：获取所有会话
  /// 同步会话及 seq（版本增量，对齐 Go SDK IncrSyncConversations）
  ///
  /// 使用 getIncrementalConversation 接口按版本增量同步会话列表，
  /// 之后调用 getConversationsHasReadAndMaxSeq 更新 seq / 未读数。
  Future<void> _syncConversationsAndSeqs() async {
    _log.info('called', methodName: '_syncConversationsAndSeqs');
    try {
      // ---------- Step 1: 版本增量同步会话结构 ----------
      final versionInfo = await database.getVersionSync('conversations', _userID);
      final localVersion = (versionInfo?['version'] as num?)?.toInt() ?? 0;
      final localVersionID = versionInfo?['versionID']?.toString() ?? '';
      _log.info(
        'version=$localVersion versionID=$localVersionID reinstalled=$_reinstalled',
        methodName: '_syncConversationsAndSeqs',
      );

      final incrResp = await api.getIncrementalConversation(
        req: {'userID': _userID, 'version': localVersion, 'versionID': localVersionID},
      );

      if (incrResp.errCode == 0) {
        final respData = incrResp.data as Map<String, dynamic>? ?? {};
        final isFull = respData['full'] as bool? ?? false;
        final newVersionID = respData['versionID']?.toString() ?? localVersionID;
        final newVersion = (respData['version'] as num?)?.toInt() ?? localVersion;

        if (isFull || localVersion == 0 || _reinstalled) {
          // 全量路径（首次安装、重装或服务端要求全量）
          _log.info(
            '会话全量同步（full=$isFull, localVersion=$localVersion, reinstalled=$_reinstalled）',
            methodName: '_syncConversationsAndSeqs',
          );
          await _syncConversationsFull();
        } else {
          // 增量路径
          final deleteIDs = (respData['delete'] as List?)?.cast<String>() ?? [];
          final insertList = (respData['insert'] as List?) ?? [];
          final updateList = (respData['update'] as List?) ?? [];

          // 删除
          for (final convID in deleteIDs) {
            await database.deleteConversation(convID);
            _log.info('会话删除: $convID', methodName: '_syncConversationsAndSeqs');
          }

          // 新增
          final toInsert = <Map<String, dynamic>>[];
          for (final item in insertList) {
            if (item is Map<String, dynamic>) {
              final map = Map<String, dynamic>.from(item);
              if (map['latestMsg'] is Map) map['latestMsg'] = jsonEncode(map['latestMsg']);
              toInsert.add(map);
            }
          }
          if (toInsert.isNotEmpty) {
            await _batchAddFaceURLAndName(toInsert);
            await database.batchUpsertConversations(toInsert);
          }

          // 更新
          final toUpdate = <Map<String, dynamic>>[];
          for (final item in updateList) {
            if (item is Map<String, dynamic>) {
              final map = Map<String, dynamic>.from(item);
              if (map['latestMsg'] is Map) map['latestMsg'] = jsonEncode(map['latestMsg']);
              toUpdate.add(map);
            }
          }
          if (toUpdate.isNotEmpty) {
            await database.batchUpsertConversations(toUpdate);
            conversationListener?.conversationChanged(
              toUpdate.map((m) => ConversationInfo.fromJson(m)).toList(),
            );
          }

          _log.info(
            '会话增量同步完成，del=${deleteIDs.length} ins=${toInsert.length} upd=${toUpdate.length}',
            methodName: '_syncConversationsAndSeqs',
          );
        }

        // 保存新版本
        if (newVersion > 0 || newVersionID.isNotEmpty) {
          await database.setVersionSync(
            tableName: 'conversations',
            entityID: _userID,
            versionID: newVersionID,
            version: newVersion,
            uidList: const [],
          );
        }
      } else {
        _log.warning(
          'getIncrementalConversation 失败: ${incrResp.errMsg}，降级为全量',
          methodName: '_syncConversationsAndSeqs',
        );
        await _syncConversationsFull();
      }

      // ---------- Step 2: 始终更新 seq / 未读数（独立于会话结构同步）----------
      // 对应 Go SDK GetConvMaxReadSeq，确保 _serverMaxSeqs 始终最新
      final localConvs = await database.getAllConversations();
      final localConvIDs = localConvs.map((c) => c.conversationID).whereType<String>().toList();

      // 加载本地 hasReadSeq，防止服务端滞后值覆盖本地已读状态：
      // 若本地 hasReadSeq >= 服务端 hasReadSeq，说明本地标记已读的请求可能还未到服务端，
      // 用本地值计算 unreadCount 可避免"刚读完的消息重新变成未读"的问题。
      final localHasReadSeqs = await database.getAllConversationHasReadSeqs();

      final seqResp = await api.getConversationsHasReadAndMaxSeq(
        userID: _userID,
        conversationIDs: const [],
      );
      if (seqResp.errCode == 0) {
        final serverSeqs = seqResp.data?['seqs'] as Map<String, dynamic>? ?? {};
        _log.info('服务端 seq 数: ${serverSeqs.length}', methodName: '_syncConversationsAndSeqs');

        // 收集所有更新任务并并行执行，消除 N 次串行 DB 往返
        final updateFutures = <Future>[];
        for (final convID in localConvIDs) {
          final seqInfo = serverSeqs[convID];
          if (seqInfo is Map<String, dynamic>) {
            final maxSeq = (seqInfo['maxSeq'] as num?)?.toInt() ?? 0;
            final serverHasReadSeq = (seqInfo['hasReadSeq'] as num?)?.toInt() ?? 0;
            // 取本地与服务端中较大的 hasReadSeq：
            // 本地 > 服务端说明标记已读请求尚未被服务端处理，使用本地值防止倒退
            final localHasReadSeq = localHasReadSeqs[convID] ?? 0;
            final effectiveHasReadSeq = localHasReadSeq > serverHasReadSeq
                ? localHasReadSeq
                : serverHasReadSeq;
            final unread = (maxSeq - effectiveHasReadSeq).clamp(0, maxSeq);
            _serverMaxSeqs[convID] = maxSeq;
            updateFutures.add(
              database.updateConversation(convID, {
                'maxSeq': maxSeq,
                'hasReadSeq': effectiveHasReadSeq,
                'unreadCount': unread,
              }),
            );
          }
        }
        if (updateFutures.isNotEmpty) {
          await Future.wait(updateFutures);
        }
      }
    } catch (e, s) {
      _log.error('同步会话异常: $e', error: e, stackTrace: s, methodName: '_syncConversationsAndSeqs');
    }
  }

  /// 全量同步会话（降级路径）
  Future<void> _syncConversationsFull() async {
    final resp = await api.getAllConversations(ownerUserID: _userID);
    if (resp.errCode != 0) return;

    final conversations = resp.data?['conversations'] as List? ?? [];
    if (conversations.isEmpty) return;

    final convMaps = <Map<String, dynamic>>[];
    for (final conv in conversations) {
      if (conv is Map<String, dynamic>) {
        final convType = conv['conversationType'] as int?;
        final uid = conv['userID'] as String?;
        if (convType == 1 && uid == _userID) continue;
        final map = Map<String, dynamic>.from(conv);
        if (map['latestMsg'] is Map) map['latestMsg'] = jsonEncode(map['latestMsg']);
        convMaps.add(map);
      }
    }

    await _batchAddFaceURLAndName(convMaps);

    final seqResp = await api.getConversationsHasReadAndMaxSeq(
      userID: _userID,
      conversationIDs: const [],
    );
    Map<String, dynamic> serverSeqs;
    if (seqResp.errCode == 0) {
      serverSeqs = seqResp.data?['seqs'] as Map<String, dynamic>? ?? {};
    } else {
      serverSeqs = {};
    }

    for (final conv in convMaps) {
      final convID = conv['conversationID'] as String?;
      if (convID == null) continue;
      final seqInfo = serverSeqs[convID];
      if (seqInfo is Map<String, dynamic>) {
        final maxSeq = (seqInfo['maxSeq'] as num?)?.toInt() ?? 0;
        final hasReadSeq = (seqInfo['hasReadSeq'] as num?)?.toInt() ?? 0;
        conv['unreadCount'] = (maxSeq - hasReadSeq).clamp(0, maxSeq);
        conv['maxSeq'] = maxSeq;
        conv['hasReadSeq'] = hasReadSeq;
        _serverMaxSeqs[convID] = maxSeq;
      }
    }

    if (convMaps.isNotEmpty) {
      await database.batchUpsertConversations(convMaps);
    }
    // 清除旧版本，下次重新用增量
    await database.deleteVersionSync('conversations', _userID);
    _log.info('会话全量同步完成，共 ${convMaps.length} 个', methodName: '_syncConversationsFull');
  }

  /// 批量为会话填充 showName 和 faceURL
  ///
  /// 对应 Go SDK 的 batchAddFaceURLAndName:
  /// - 单聊/通知: 优先用好友备注，否则用好友昵称，否则从用户表取
  /// - 群聊: 用群组名称和群组头像
  Future<void> _batchAddFaceURLAndName(List<Map<String, dynamic>> conversations) async {
    _log.info('called', methodName: '_batchAddFaceURLAndName');
    try {
      final userIDs = <String>{};
      final groupIDs = <String>{};

      for (final conv in conversations) {
        final type = conv['conversationType'] as int?;
        if (type == 1 || type == 4) {
          // 单聊 / 通知
          final uid = conv['userID'] as String?;
          if (uid != null && uid.isNotEmpty) userIDs.add(uid);
        } else if (type == 2 || type == 3) {
          // 群聊（兼容旧 conversationType=2 与 superGroup=3）
          final gid = conv['groupID'] as String?;
          if (gid != null && gid.isNotEmpty) groupIDs.add(gid);
        }
      }

      // 批量查好友信息（优先使用备注）
      final friendMap = <String, FriendInfo>{};
      if (userIDs.isNotEmpty) {
        final friends = await database.getFriendsByUserIDs(userIDs.toList());
        for (final f in friends) {
          final fid = f.friendUserID;
          if (fid != null) friendMap[fid] = f;
        }
      }

      // 不在好友中的 userID，从用户表查
      final userMap = <String, UserInfo>{};
      final notInFriendIDs = userIDs.where((id) => !friendMap.containsKey(id)).toList();
      if (notInFriendIDs.isNotEmpty) {
        final users = await database.getUsersByIDs(notInFriendIDs);
        for (final u in users) {
          final uid = u.userID;
          userMap[uid] = u;
        }

        // Fallback: Fetch missing users from network
        final notInAnyMap = notInFriendIDs.where((id) => !userMap.containsKey(id)).toList();
        if (notInAnyMap.isNotEmpty) {
          try {
            final resp = await api.getUsersInfo(userIDs: notInAnyMap);
            if (resp.errCode == 0) {
              final netUsers = resp.data?['usersInfo'] as List? ?? [];
              for (final u in netUsers) {
                if (u is Map<String, dynamic>) {
                  final uid = u['userID'] as String?;
                  if (uid != null) {
                    userMap[uid] = UserInfo.fromJson(u);
                    // Cache it so future syncs have it
                    await database.upsertUser(u);
                  }
                }
              }
            }
          } catch (e, s) {
            _log.error(
              '补充缺失用户信息失败: $e',
              error: e,
              stackTrace: s,
              methodName: '_batchAddFaceURLAndName',
            );
          }
        }
      }

      // 批量查群组信息
      final groupMap = <String, GroupInfo>{};
      if (groupIDs.isNotEmpty) {
        final groups = await database.getGroupsByIDs(groupIDs.toList());
        for (final g in groups) {
          groupMap[g.groupID] = g;
        }

        final notInGroupMap = groupIDs.where((id) => !groupMap.containsKey(id)).toList();
        if (notInGroupMap.isNotEmpty) {
          try {
            final resp = await api.getGroupsInfo(groupIDs: notInGroupMap.toList());
            if (resp.errCode == 0) {
              final netGroups = resp.data?['groupInfos'] as List? ?? [];
              for (final g in netGroups) {
                if (g is Map<String, dynamic>) {
                  final gid = g['groupID'] as String?;
                  if (gid != null) {
                    groupMap[gid] = GroupInfo.fromJson(g);
                    await database.upsertGroup(g);
                  }
                }
              }
            }
          } catch (e, s) {
            _log.error(
              '补充缺失群组信息失败: $e',
              error: e,
              stackTrace: s,
              methodName: '_batchAddFaceURLAndName',
            );
          }
        }
      }

      // 填充
      for (final conv in conversations) {
        final type = conv['conversationType'] as int?;
        if (type == 1 || type == 4) {
          final uid = conv['userID'] as String? ?? '';
          final friend = friendMap[uid];
          if (friend != null) {
            conv['showName'] = friend.getShowName();
            conv['faceURL'] = friend.faceURL ?? '';
          } else {
            final user = userMap[uid];
            if (user != null) {
              conv['showName'] = user.getShowName();
              conv['faceURL'] = user.faceURL ?? '';
            }
          }
        } else if (type == 2 || type == 3) {
          final gid = conv['groupID'] as String? ?? '';
          final group = groupMap[gid];
          if (group != null) {
            conv['showName'] = group.groupName ?? '';
            conv['faceURL'] = group.faceURL ?? '';
          }
        }
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_batchAddFaceURLAndName');
      rethrow;
    }
  }

  /// 同步好友列表（版本增量，对齐 Go SDK IncrSyncFriends）
  ///
  /// 优先使用 getIncrementalFriends 接口（version 增量），避免每次全量拉取。
  /// 服务端返回 full=true 时自动降级为全量同步（首次安装或版本号不连续）。
  Future<void> _syncFriends() async {
    _log.info('called', methodName: '_syncFriends');
    try {
      // 读取本地保存的版本信息
      final versionInfo = await database.getVersionSync('friends', _userID);
      final localVersion = (versionInfo?['version'] as num?)?.toInt() ?? 0;
      final localVersionID = versionInfo?['versionID']?.toString() ?? '';

      _log.info('version=$localVersion versionID=$localVersionID', methodName: '_syncFriends');

      // 请求增量好友数据
      final incrResp = await api.getIncrementalFriends(
        req: {'userID': _userID, 'version': localVersion, 'versionID': localVersionID},
      );

      if (incrResp.errCode != 0) {
        _log.warning('getIncrementalFriends 失败: ${incrResp.errMsg}', methodName: '_syncFriends');
        return;
      }

      final respData = incrResp.data as Map<String, dynamic>? ?? {};
      final isFull = respData['full'] as bool? ?? false;
      final newVersionID = respData['versionID']?.toString() ?? localVersionID;
      final newVersion = (respData['version'] as num?)?.toInt() ?? localVersion;

      if (isFull || localVersion == 0) {
        // 全量路径（首次安装或服务端要求全量）：全量拉取后保存版本
        _log.info('好友全量同步（full=$isFull, localVersion=$localVersion）', methodName: '_syncFriends');
        await _syncFriendsFull();
      } else {
        // 增量路径：处理 delete / insert / update
        final listener = notificationDispatcher.friendshipListener;

        // 删除
        final deleteIDs = (respData['delete'] as List?)?.cast<String>() ?? [];
        for (final id in deleteIDs) {
          await database.deleteFriend(id);
          _log.info('好友删除: $id', methodName: '_syncFriends');
        }

        // 新增
        final insertList = (respData['insert'] as List?) ?? [];
        final toInsert = <Map<String, dynamic>>[];
        for (final item in insertList) {
          if (item is Map<String, dynamic>) {
            final friendUser = item['friendUser'] as Map<String, dynamic>? ?? {};
            toInsert.add(_normalizeFriendRecord(item, friendUser));
          }
        }
        if (toInsert.isNotEmpty) {
          await database.batchUpsertFriends(toInsert);
        }

        // 更新
        final updateList = (respData['update'] as List?) ?? [];
        for (final item in updateList) {
          if (item is Map<String, dynamic>) {
            final friendUser = item['friendUser'] as Map<String, dynamic>? ?? {};
            final record = _normalizeFriendRecord(item, friendUser);
            final friendUserID = record['friendUserID']?.toString();
            if (friendUserID == null || friendUserID.isEmpty) continue;

            await database.updateFriend(friendUserID, {
              'nickname': record['nickname'],
              'faceURL': record['faceURL'],
              'remark': record['remark'],
              'ex': record['ex'],
              'addSource': record['addSource'],
              'operatorUserID': record['operatorUserID'],
              'isPinned': record['isPinned'],
            });

            // 触发回调
            final updated = FriendInfo(
              ownerUserID: record['ownerUserID']?.toString(),
              friendUserID: friendUserID,
              nickname: record['nickname']?.toString(),
              faceURL: record['faceURL']?.toString(),
              remark: record['remark']?.toString(),
              ex: record['ex']?.toString(),
              createTime: (record['createTime'] as num?)?.toInt(),
              addSource: (record['addSource'] as num?)?.toInt(),
              operatorUserID: record['operatorUserID']?.toString(),
            );
            listener?.friendInfoChanged(updated);

            // 同步更新对应单聊会话的 showName / faceURL（对齐 Go SDK）
            final showName = updated.getShowName();
            final convID = OpenImUtils.genSingleConversationID(_userID, friendUserID);
            final conv = await database.getConversation(convID);
            if (conv != null) {
              final convUpdates = <String, dynamic>{'showName': showName};
              if (updated.faceURL != null) convUpdates['faceURL'] = updated.faceURL;
              await database.updateConversation(convID, convUpdates);
              // 用本地数据构建更新后的会话，无需再次读取 DB
              final updatedConv = ConversationInfo.fromJson({...conv.toJson(), ...convUpdates});
              conversationListener?.conversationChanged([updatedConv]);
            }
            await database.updateSingleChatMessageSenderInfo(
              friendUserID,
              senderNickname: showName,
              senderFaceUrl: updated.faceURL,
            );
          }
        }

        _log.info(
          '好友增量同步完成，del=${deleteIDs.length} ins=${toInsert.length} upd=${updateList.length}',
          methodName: '_syncFriends',
        );
      }

      // 保存新版本号（全量和增量路径均更新）
      if (newVersion > 0 || newVersionID.isNotEmpty) {
        await database.setVersionSync(
          tableName: 'friends',
          entityID: _userID,
          versionID: newVersionID,
          version: newVersion,
          uidList: const [],
        );
      }
    } catch (e, s) {
      _log.error('同步好友异常: $e', error: e, stackTrace: s, methodName: '_syncFriends');
    }
  }

  /// 全量同步好友（降级路径，对齐旧逻辑）
  Future<void> _syncFriendsFull() async {
    final oldFriends = await database.getAllFriends();
    final localMap = <String, FriendInfo>{};
    for (final f in oldFriends) {
      if (f.friendUserID != null) localMap[f.friendUserID!] = f;
    }

    int pageNumber = 1;
    const pageSize = 100;
    final allServerFriends = <Map<String, dynamic>>[];
    while (true) {
      final resp = await api.getFriendList(
        userID: _userID,
        offset: (pageNumber - 1) * pageSize,
        count: pageSize,
      );
      if (resp.errCode != 0) break;
      final friends = resp.data?['friendsInfo'] as List? ?? [];
      if (friends.isEmpty) break;
      for (final f in friends) {
        if (f is Map<String, dynamic>) {
          final friendUser = f['friendUser'] as Map<String, dynamic>? ?? {};
          allServerFriends.add(_normalizeFriendRecord(f, friendUser));
        }
      }
      if (friends.length < pageSize) break;
      pageNumber++;
    }

    final serverIDSet = <String>{};
    final toInsert = <Map<String, dynamic>>[];
    final listener = notificationDispatcher.friendshipListener;

    for (final record in allServerFriends) {
      final friendUserID = record['friendUserID']?.toString();
      if (friendUserID == null || friendUserID.isEmpty) continue;
      serverIDSet.add(friendUserID);

      final local = localMap[friendUserID];
      if (local == null) {
        toInsert.add(record);
        continue;
      }

      final changed =
          (record['nickname']?.toString() ?? '') != (local.nickname ?? '') ||
          (record['faceURL']?.toString() ?? '') != (local.faceURL ?? '') ||
          (record['remark']?.toString() ?? '') != (local.remark ?? '');

      if (changed) {
        await database.updateFriend(friendUserID, {
          'nickname': record['nickname'],
          'faceURL': record['faceURL'],
          'remark': record['remark'],
          'ex': record['ex'],
          'addSource': record['addSource'],
          'operatorUserID': record['operatorUserID'],
          'isPinned': record['isPinned'],
        });

        final updated = FriendInfo(
          ownerUserID: record['ownerUserID']?.toString(),
          friendUserID: friendUserID,
          nickname: record['nickname']?.toString(),
          faceURL: record['faceURL']?.toString(),
          remark: record['remark']?.toString(),
          ex: record['ex']?.toString(),
          createTime: (record['createTime'] as num?)?.toInt(),
          addSource: (record['addSource'] as num?)?.toInt(),
          operatorUserID: record['operatorUserID']?.toString(),
        );
        listener?.friendInfoChanged(updated);

        final showName = updated.getShowName();
        final convID = OpenImUtils.genSingleConversationID(_userID, friendUserID);
        final conv = await database.getConversation(convID);
        if (conv != null) {
          final convUpdates = <String, dynamic>{'showName': showName};
          if (updated.faceURL != null) convUpdates['faceURL'] = updated.faceURL;
          await database.updateConversation(convID, convUpdates);
          // 用本地数据构建更新后的会话，无需再次读取 DB
          final updatedConv = ConversationInfo.fromJson({...conv.toJson(), ...convUpdates});
          conversationListener?.conversationChanged([updatedConv]);
        }
        await database.updateSingleChatMessageSenderInfo(
          friendUserID,
          senderNickname: showName,
          senderFaceUrl: updated.faceURL,
        );
      }
    }

    if (toInsert.isNotEmpty) {
      await database.batchUpsertFriends(toInsert);
    }

    for (final local in oldFriends) {
      if (local.friendUserID != null && !serverIDSet.contains(local.friendUserID)) {
        await database.deleteFriend(local.friendUserID!);
      }
    }

    _log.info('好友全量同步完成，共 ${allServerFriends.length} 个', methodName: '_syncFriendsFull');
  }

  /// 将服务端好友记录标准化为 DB 写入格式
  Map<String, dynamic> _normalizeFriendRecord(
    Map<String, dynamic> item,
    Map<String, dynamic> friendUser,
  ) {
    return {
      'friendUserID': friendUser['userID'] ?? item['friendUserID'] ?? item['userID'],
      'ownerUserID': item['ownerUserID'] ?? _userID,
      'nickname': friendUser['nickname'] ?? item['nickname'],
      'faceURL': friendUser['faceURL'] ?? item['faceURL'],
      'remark': item['remark'],
      'createTime': item['createTime'],
      'addSource': item['addSource'],
      'operatorUserID': item['operatorUserID'],
      'ex': item['ex'],
      'isPinned': item['isPinned'],
    };
  }

  /// 同步已加入的群组及其成员
  /// 同步已加入群组（版本增量，对齐 Go SDK IncrSyncJoinGroup）
  ///
  /// 使用 getIncrementalJoinGroup 接口按版本增量同步群组列表，
  /// 仅对新增/变更的群组重新拉取群成员。
  Future<void> _syncJoinedGroups() async {
    _log.info('called', methodName: '_syncJoinedGroups');
    try {
      final versionInfo = await database.getVersionSync('groups', _userID);
      final localVersion = (versionInfo?['version'] as num?)?.toInt() ?? 0;
      final localVersionID = versionInfo?['versionID']?.toString() ?? '';

      _log.info('version=$localVersion versionID=$localVersionID', methodName: '_syncJoinedGroups');

      final incrResp = await api.getIncrementalJoinGroup(
        req: {'userID': _userID, 'version': localVersion, 'versionID': localVersionID},
      );

      if (incrResp.errCode != 0) {
        _log.warning(
          'getIncrementalJoinGroup 失败: ${incrResp.errMsg}',
          methodName: '_syncJoinedGroups',
        );
        return;
      }

      final respData = incrResp.data as Map<String, dynamic>? ?? {};
      final isFull = respData['full'] as bool? ?? false;
      final newVersionID = respData['versionID']?.toString() ?? localVersionID;
      final newVersion = (respData['version'] as num?)?.toInt() ?? localVersion;

      if (isFull || localVersion == 0) {
        _log.info(
          '群组全量同步（full=$isFull, localVersion=$localVersion）',
          methodName: '_syncJoinedGroups',
        );
        await _syncJoinedGroupsFull();
      } else {
        // 增量路径
        final deleteIDs = (respData['delete'] as List?)?.cast<String>() ?? [];
        final insertList = (respData['insert'] as List?) ?? [];
        final updateList = (respData['update'] as List?) ?? [];

        // 删除
        for (final groupID in deleteIDs) {
          await database.deleteGroup(groupID);
          _log.info('群组删除: $groupID', methodName: '_syncJoinedGroups');
        }

        // 新增（需要同步成员）
        final toInsert = <Map<String, dynamic>>[];
        for (final item in insertList) {
          if (item is Map<String, dynamic>) toInsert.add(item);
        }
        if (toInsert.isNotEmpty) {
          await database.batchUpsertGroups(toInsert);
          // 并行同步所有新增群的成员，消除 N 次串行网络请求
          await Future.wait(
            toInsert
                .map((g) => g['groupID']?.toString())
                .whereType<String>()
                .where((gid) => gid.isNotEmpty)
                .map(_syncGroupMembersForGroup),
          );
        }

        // 更新（仅更新群信息，成员不一定变化）
        final toUpdate = <Map<String, dynamic>>[];
        for (final item in updateList) {
          if (item is Map<String, dynamic>) toUpdate.add(item);
        }
        if (toUpdate.isNotEmpty) {
          await database.batchUpsertGroups(toUpdate);
        }

        _log.info(
          '群组增量同步完成，del=${deleteIDs.length} ins=${toInsert.length} upd=${toUpdate.length}',
          methodName: '_syncJoinedGroups',
        );
      }

      // 保存新版本
      if (newVersion > 0 || newVersionID.isNotEmpty) {
        await database.setVersionSync(
          tableName: 'groups',
          entityID: _userID,
          versionID: newVersionID,
          version: newVersion,
          uidList: const [],
        );
      }
    } catch (e, s) {
      _log.error('同步群组异常: $e', error: e, stackTrace: s, methodName: '_syncJoinedGroups');
    }
  }

  /// 全量同步已加入群组（降级路径）
  Future<void> _syncJoinedGroupsFull() async {
    int pageNumber = 1;
    const pageSize = 100;
    final allGroups = <Map<String, dynamic>>[];
    while (true) {
      final resp = await api.getJoinedGroupList(
        fromUserID: _userID,
        offset: (pageNumber - 1) * pageSize,
        count: pageSize,
      );
      if (resp.errCode != 0) break;
      final groups = resp.data?['groups'] as List? ?? [];
      if (groups.isEmpty) break;
      for (final g in groups) {
        if (g is Map<String, dynamic>) allGroups.add(g);
      }
      if (groups.length < pageSize) break;
      pageNumber++;
    }
    if (allGroups.isNotEmpty) await database.batchUpsertGroups(allGroups);
    _log.info('群组全量同步完成，共 ${allGroups.length} 个群', methodName: '_syncJoinedGroupsFull');

    for (final group in allGroups) {
      final groupID = group['groupID'] as String?;
      if (groupID == null || groupID.isEmpty) continue;
      await _syncGroupMembersForGroup(groupID);
    }
    // 清除旧版本，下次重新走增量路径
    await database.deleteVersionSync('groups', _userID);
  }

  /// 从服务器同步指定群组的所有成员到本地数据库
  Future<void> _syncGroupMembersForGroup(String groupID) async {
    _log.info('groupID=$groupID', methodName: '_syncGroupMembersForGroup');
    try {
      int offset = 0;
      const pageSize = 100;
      final allMembers = <Map<String, dynamic>>[];
      while (true) {
        final resp = await api.getGroupMemberList(
          groupID: groupID,
          offset: offset,
          count: pageSize,
        );
        if (resp.errCode != 0) break;
        final members = resp.data?['members'] as List? ?? [];
        if (members.isEmpty) break;
        for (final m in members) {
          if (m is Map<String, dynamic>) allMembers.add(m);
        }
        if (members.length < pageSize) break;
        offset += pageSize;
      }
      if (allMembers.isNotEmpty) {
        await database.batchUpsertGroupMembers(allMembers);
      }
    } catch (e, s) {
      _log.error(
        '同步群[$groupID]成员异常: $e',
        error: e,
        stackTrace: s,
        methodName: '_syncGroupMembersForGroup',
      );
    }
  }

  /// 同步消息（拉取缺口）
  ///
  /// 对齐 Go SDK 的 compareSeqsAndBatchSync → syncAndTriggerMsgs / syncAndTriggerReinstallMsgs：
  /// - _serverMaxSeqs 来自 _syncConversationsAndSeqs（对应 Go SDK GetMaxSeq 返回值）
  /// - _syncedMaxSeqs 来自 _loadSeqs（从消息表读取，对应 Go SDK syncedMaxSeqs）
  /// - 比较两者差异确定需要拉取的消息范围
  /// - 重装时跳过 n_ 通知会话(Go SDK: 直接记录 seq 不拉取)
  Future<void> _syncMessages() async {
    _log.info('called', methodName: '_syncMessages');
    try {
      if (_serverMaxSeqs.isEmpty) return;

      final needSyncSeqs = <String, List<int>>{};

      for (final entry in _serverMaxSeqs.entries) {
        final convID = entry.key;
        final serverMaxSeq = entry.value;
        final localMaxSeq = _syncedMaxSeqs[convID] ?? 0;

        if (_reinstalled) {
          if (convID.startsWith('n_')) {
            if (serverMaxSeq > 0) {
              _syncedMaxSeqs[convID] = serverMaxSeq;
              await database.upsertNotificationSeq(convID, serverMaxSeq);
            }
            continue;
          }
          // 对齐 Go SDK：maxSeq=0 的会话跳过（无消息），begin=0 由服务端调整为 minSeq
          if (serverMaxSeq > 0) {
            needSyncSeqs[convID] = [0, serverMaxSeq];
          }
        } else if (serverMaxSeq > localMaxSeq) {
          needSyncSeqs[convID] = [localMaxSeq + 1, serverMaxSeq];
        }
      }

      if (needSyncSeqs.isEmpty) {
        _log.info('所有会话消息已是最新', methodName: '_syncMessages');
        return;
      }

      Set<String> updatedConvIDs;

      if (_reinstalled) {
        // 对齐 Go SDK syncAndTriggerReinstallMsgs：
        // 每个会话只拉 1 条最新消息用于 latestMsg，不做 gap-filling 循环
        _log.info('初次安装：准备拉取 ${needSyncSeqs.length} 个会话的消息', methodName: '_syncMessages');
        updatedConvIDs = await _syncReinstallMsgs(needSyncSeqs);
      } else {
        updatedConvIDs = await _syncHistoryByQueue(needSyncSeqs: needSyncSeqs, pullNum: 10);
      }

      if (updatedConvIDs.isNotEmpty) {
        _fireConversationChanged(updatedConvIDs);
      }

      _log.info('消息同步完成，共处理 ${needSyncSeqs.length} 个会话', methodName: '_syncMessages');
    } catch (e, s) {
      _log.error('同步消息异常: $e', error: e, stackTrace: s, methodName: '_syncMessages');
    }
  }

  /// 重装时消息同步（对齐 Go SDK syncAndTriggerReinstallMsgs）
  ///
  /// 每个会话只拉 1 条最新消息（connectPullNums=1），用于设置 latestMsg。
  /// 不做 gap-filling 循环，不用 notificationMsgs 更新 latestMsg。
  Future<Set<String>> _syncReinstallMsgs(Map<String, List<int>> needSyncSeqs) async {
    const int maxBatchRanges = 50;
    final updatedConvIDs = <String>{};
    final entries = needSyncSeqs.entries.toList();

    for (var i = 0; i < entries.length; i += maxBatchRanges) {
      final batch = entries.sublist(i, (i + maxBatchRanges).clamp(0, entries.length));

      final seqRanges = batch
          .map((e) => {'conversationID': e.key, 'begin': e.value[0], 'end': e.value[1], 'num': 1})
          .toList();

      // 对齐 Go SDK pullMsgBySeqRange：不设 order（默认 0/Asc），
      // 服务端 GetMsgBySeqsRange 在 Num=1 时返回 end seq 的消息（即最新一条）
      final resp = await api.pullMsgBySeqs(userID: _userID, seqRanges: seqRanges);
      if (resp.errCode != 0) {
        _log.warning('重装消息拉取失败: ${resp.errMsg}', methodName: '_syncReinstallMsgs');
        continue;
      }

      final data = resp.data as Map<String, dynamic>? ?? {};
      final msgs = data['msgs'] as Map<String, dynamic>? ?? {};
      final notificationMsgs = data['notificationMsgs'] as Map<String, dynamic>? ?? {};

      // 对齐 Go SDK triggerReinstallConversation：只用 msgs 更新 latestMsg
      await _processReinstallMsgs(msgs, updatedConvIDs);

      // 通知消息仅分发，不更新 latestMsg（对齐 Go SDK triggerNotification）
      for (final entry in notificationMsgs.entries) {
        final pullMsgs = entry.value as Map<String, dynamic>? ?? {};
        final msgList = (pullMsgs['Msgs'] ?? pullMsgs['msgs']) as List? ?? [];
        for (final msg in msgList) {
          if (msg is Map<String, dynamic>) {
            _decodeContentIfBase64(msg);
            final contentType = (msg['contentType'] as num?)?.toInt() ?? 0;
            final seq = (msg['seq'] as num?)?.toInt() ?? 0;
            if (seq > 0 && seq > (_syncedMaxSeqs[entry.key] ?? 0)) {
              _syncedMaxSeqs[entry.key] = seq;
              await database.upsertNotificationSeq(entry.key, seq);
            }
            // 重装时不分发通知（已通过 _syncFriends/_syncJoinedGroups 全量同步）
            if (contentType >= 1000) {
              // skip dispatch
            }
          }
        }
      }

      // 推进 syncedMaxSeqs
      for (final e in batch) {
        _syncedMaxSeqs[e.key] = e.value[1];
      }
    }

    return updatedConvIDs;
  }

  /// 处理重装拉取的消息（对齐 Go SDK doMsgSyncByReinstalled）
  ///
  /// 与 _processPulledMsgs 区别：
  /// - 直接用本批最后一条消息作为 latestMsg（Go SDK 行为），不做时间比较
  /// - 不分发通知（重装时好友/群组已全量同步）
  Future<void> _processReinstallMsgs(
    Map<String, dynamic> msgsByConv,
    Set<String> updatedConvIDs,
  ) async {
    for (final entry in msgsByConv.entries) {
      final convID = entry.key;
      final pullMsgs = entry.value as Map<String, dynamic>? ?? {};
      final msgList = (pullMsgs['Msgs'] ?? pullMsgs['msgs']) as List? ?? [];
      if (msgList.isEmpty) continue;

      final msgMaps = <Map<String, dynamic>>[];
      Map<String, dynamic>? latestMsg;
      int maxSeq = 0;

      for (final msg in msgList) {
        if (msg is Map<String, dynamic>) {
          _decodeContentIfBase64(msg);
          final seq = (msg['seq'] as num?)?.toInt() ?? 0;
          if (seq > maxSeq) maxSeq = seq;
          msgMaps.add(msg);
          // 对齐 Go SDK doMsgSyncByReinstalled：最后一条即为 latestMsg
          latestMsg = msg;
        }
      }

      if (msgMaps.isNotEmpty) {
        for (final m in msgMaps) {
          m['conversationID'] = convID;
          final rawStatus = m['status'];
          if (rawStatus == null || rawStatus == 0) {
            m['status'] = MessageStatus.succeeded.value;
          }
        }
        await database.batchInsertMessages(msgMaps);
      }

      if (latestMsg != null) {
        final sendTime = (latestMsg['sendTime'] as num?)?.toInt() ?? 0;
        final updates = <String, dynamic>{
          'latestMsg': jsonEncode(latestMsg),
          'latestMsgSendTime': sendTime,
        };
        if (maxSeq > 0) {
          updates['maxSeq'] = maxSeq;
        }
        await database.updateConversation(convID, updates);
        updatedConvIDs.add(convID);
      } else if (maxSeq > 0) {
        await database.updateConversation(convID, {'maxSeq': maxSeq});
      }

      if (maxSeq > (_syncedMaxSeqs[convID] ?? 0)) {
        _syncedMaxSeqs[convID] = maxSeq;
      }
    }
  }

  Future<Set<String>> _syncHistoryByQueue({
    required Map<String, List<int>> needSyncSeqs,
    required int pullNum,
  }) async {
    const int maxBatchRanges = 50;
    final updatedConvIDs = <String>{};
    final queue = Queue<_HistorySyncTask>();

    for (final entry in needSyncSeqs.entries) {
      final begin = entry.value[0];
      final end = entry.value[1];
      if (end >= begin) {
        queue.add(
          _HistorySyncTask(conversationID: entry.key, begin: begin, end: end, pullNum: pullNum),
        );
      }
    }

    while (queue.isNotEmpty) {
      final batchTasks = <_HistorySyncTask>[];
      while (queue.isNotEmpty && batchTasks.length < maxBatchRanges) {
        batchTasks.add(queue.removeFirst());
      }

      final seqRanges = batchTasks
          .map(
            (task) => {
              'conversationID': task.conversationID,
              'begin': task.begin,
              'end': task.end,
              'num': task.pullNum,
            },
          )
          .toList();

      final resp = await api.pullMsgBySeqs(userID: _userID, seqRanges: seqRanges, order: 1);
      if (resp.errCode != 0) {
        _log.warning('队列同步拉取失败: ${resp.errMsg}', methodName: '_syncHistoryByQueue');
        continue;
      }

      final data = resp.data as Map<String, dynamic>? ?? {};
      final msgs = data['msgs'] as Map<String, dynamic>? ?? {};
      final notificationMsgs = data['notificationMsgs'] as Map<String, dynamic>? ?? {};

      await _processPulledMsgs(msgs, updatedConvIDs);
      await _processPulledNotifications(notificationMsgs);

      for (final task in batchTasks) {
        final allSeqs = <int>[];
        final m1 = msgs[task.conversationID] as Map<String, dynamic>?;
        final l1 = (m1?['Msgs'] ?? m1?['msgs']) as List? ?? const [];
        for (final msg in l1) {
          if (msg is Map<String, dynamic>) {
            allSeqs.add((msg['seq'] as num?)?.toInt() ?? 0);
          }
        }
        final m2 = notificationMsgs[task.conversationID] as Map<String, dynamic>?;
        final l2 = (m2?['Msgs'] ?? m2?['msgs']) as List? ?? const [];
        for (final msg in l2) {
          if (msg is Map<String, dynamic>) {
            allSeqs.add((msg['seq'] as num?)?.toInt() ?? 0);
          }
        }

        final validSeqs = allSeqs.where((e) => e > 0).toList();
        if (validSeqs.isEmpty) {
          _log.warning(
            '同步区间返回空数据，保持本地 seq 不推进: conv=${task.conversationID}, range=[${task.begin}, ${task.end}]',
            methodName: '_syncHistoryByQueue',
          );
          continue;
        }
        validSeqs.sort();
        final minSeq = validSeqs.first;
        final maxSeq = validSeqs.last;
        if (maxSeq > (_syncedMaxSeqs[task.conversationID] ?? 0)) {
          _syncedMaxSeqs[task.conversationID] = maxSeq;
        }
        // 向前补拉：返回的最小 seq > 请求的 begin，说明前面还有消息
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
        // 向后补拉：返回的最大 seq < 请求的 end，说明服务端部分返回，
        // 尾部消息可能被 num 限制截断，需要补建 follow-up task
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

  /// 处理拉取到的普通消息：存入 DB 并更新会话 latestMsg
  ///
  /// 对应 Go SDK 的 doMsgNew（非重装）和 doMsgSyncByReinstalled（重装）。
  /// Go SDK 的 doMsgSyncByReinstalled 会将所有消息（含通知）都设为 latestMsg，
  /// 所以这里也对所有消息统一处理 latestMsg，确保会话列表不为空。
  Future<void> _processPulledMsgs(
    Map<String, dynamic> msgsByConv,
    Set<String> updatedConvIDs,
  ) async {
    _log.info('called', methodName: '_processPulledMsgs');
    try {
      for (final entry in msgsByConv.entries) {
        final convID = entry.key;
        final pullMsgs = entry.value as Map<String, dynamic>? ?? {};
        final msgList = (pullMsgs['Msgs'] ?? pullMsgs['msgs']) as List? ?? [];

        if (msgList.isEmpty) continue;

        final msgMaps = <Map<String, dynamic>>[];
        Map<String, dynamic>? batchLatestMsg;
        int maxSeq = 0;
        int batchLatestSendTime = 0;
        int batchLatestSeq = 0;

        for (final msg in msgList) {
          if (msg is Map<String, dynamic>) {
            _decodeContentIfBase64(msg);

            final contentType = (msg['contentType'] as num?)?.toInt() ?? 0;
            final seq = (msg['seq'] as num?)?.toInt() ?? 0;
            final sendTime = (msg['sendTime'] as num?)?.toInt() ?? 0;

            if (seq > maxSeq) maxSeq = seq;

            if (contentType >= 1000 && !_reinstalled) {
              final content = msg['content'] as String? ?? '';
              notificationDispatcher.dispatch(contentType, content);
            }

            msgMaps.add(msg);

            if (sendTime > batchLatestSendTime ||
                (sendTime == batchLatestSendTime && seq > batchLatestSeq)) {
              batchLatestSendTime = sendTime;
              batchLatestSeq = seq;
              batchLatestMsg = msg;
            }
          }
        }

        if (msgMaps.isNotEmpty) {
          for (final m in msgMaps) {
            m['conversationID'] = convID;
            final rawStatus = m['status'];
            if (rawStatus == null || rawStatus == 0) {
              m['status'] = MessageStatus.succeeded.value;
            }
          }
          await database.batchInsertMessages(msgMaps);
          // 补拉消息批量分发离线消息事件，对齐 Go SDK batchNewMessages 设计：
          // 每个会话只触发一次回调（而非逐条触发），避免上层对同一会话重复 DB 查询。
          final convertedMsgs = msgMaps.map((m) => convertMessage(m)).toList();
          try {
            messageManager.onRecvOfflineNewMessages(convertedMsgs);
          } catch (e, s) {
            _log.warning(
              '批量分发离线消息事件失败: $e',
              error: e,
              stackTrace: s,
              methodName: '_processPulledMsgs',
            );
          }
        }

        // 与已有会话的 latestMsg 比较，只在本批消息更新时才写入
        // 避免分批拉取时旧消息覆盖新消息（对齐 _processPulledNotifications 逻辑）
        final updates = <String, dynamic>{};
        if (maxSeq > 0) {
          updates['maxSeq'] = maxSeq;
        }

        if (batchLatestMsg != null) {
          final existingConv = await database.getConversation(convID);
          final existingLatestSendTime = existingConv?.latestMsgSendTime ?? 0;
          final existingLatestSeq = existingConv?.latestMsg?.seq ?? 0;

          if (batchLatestSendTime > existingLatestSendTime ||
              (batchLatestSendTime == existingLatestSendTime &&
                  batchLatestSeq > existingLatestSeq)) {
            updates['latestMsg'] = jsonEncode(batchLatestMsg);
            updates['latestMsgSendTime'] = batchLatestSendTime;
          }
        }

        if (updates.isNotEmpty) {
          await database.updateConversation(convID, updates);
          updatedConvIDs.add(convID);
        }

        // 更新本地已同步 seq
        if (maxSeq > (_syncedMaxSeqs[convID] ?? 0)) {
          _syncedMaxSeqs[convID] = maxSeq;
        }
      }
    } catch (e, s) {
      _log.error('处理普通消息失败: $e', error: e, stackTrace: s, methodName: '_processPulledMsgs');
    }
  }

  /// 处理拉取到的通知消息：仅分发通知事件和推进 seq
  ///
  /// 对齐 Go SDK triggerNotification：不更新会话 latestMsg，
  /// latestMsg 只由 _processPulledMsgs / _processReinstallMsgs 负责。
  Future<void> _processPulledNotifications(Map<String, dynamic> msgsByConv) async {
    _log.info('called', methodName: '_processPulledNotifications');
    try {
      // 收集 contentType=2200（已读回执）通知用于预聚合
      // key = conversationID (from detail), value = {content, hasReadSeq}
      final readReceiptBest = <String, _ReadReceiptEntry>{};

      for (final entry in msgsByConv.entries) {
        final convID = entry.key;
        final pullMsgs = entry.value as Map<String, dynamic>? ?? {};
        final msgList = (pullMsgs['Msgs'] ?? pullMsgs['msgs']) as List? ?? [];
        if (msgList.isEmpty) continue;

        for (final msg in msgList) {
          if (msg is Map<String, dynamic>) {
            _decodeContentIfBase64(msg);
            final contentType = (msg['contentType'] as num?)?.toInt() ?? 0;
            final content = msg['content'] as String? ?? '';
            final seq = (msg['seq'] as num?)?.toInt() ?? 0;

            if (contentType >= 1000) {
              if (contentType == 2200) {
                // 预聚合已读回执：只保留每个会话中 hasReadSeq 最大的通知
                _aggregateReadReceipt(readReceiptBest, content);
              } else {
                notificationDispatcher.dispatch(contentType, content);
              }
            }

            if (seq > 0 && seq > (_syncedMaxSeqs[convID] ?? 0)) {
              _syncedMaxSeqs[convID] = seq;
              await database.upsertNotificationSeq(convID, seq);
            }
          }
        }
      }

      // 批量分发去重后的已读回执
      if (readReceiptBest.isNotEmpty) {
        _log.info(
          '已读回执预聚合: ${readReceiptBest.length} 个会话（已去重）',
          methodName: '_processPulledNotifications',
        );
        for (final entry in readReceiptBest.values) {
          notificationDispatcher.dispatch(2200, entry.content);
        }
      }
    } catch (e, s) {
      _log.error(
        '处理通知消息失败: $e',
        error: e,
        stackTrace: s,
        methodName: '_processPulledNotifications',
      );
    }
  }

  /// 预聚合已读回执：解析 content 提取 conversationID + hasReadSeq，
  /// 只保留每个会话中 hasReadSeq 最大的通知。
  void _aggregateReadReceipt(Map<String, _ReadReceiptEntry> best, String content) {
    try {
      if (content.isEmpty) return;
      final map = jsonDecode(content) as Map<String, dynamic>;
      final detailStr = map['detail'] as String?;
      final detail = detailStr != null && detailStr.isNotEmpty
          ? jsonDecode(detailStr) as Map<String, dynamic>
          : map;
      final conversationID = detail['conversationID'] as String?;
      final hasReadSeq = (detail['hasReadSeq'] as num?)?.toInt() ?? 0;
      if (conversationID == null) return;
      final existing = best[conversationID];
      if (existing == null || hasReadSeq > existing.hasReadSeq) {
        best[conversationID] = _ReadReceiptEntry(content, hasReadSeq);
      }
    } catch (_) {
      // 解析失败则作为普通通知直接分发
      notificationDispatcher.dispatch(2200, content);
    }
  }

  /// 同步自身用户信息
  Future<void> _syncSelfUserInfo() async {
    _log.info('called', methodName: '_syncSelfUserInfo');
    try {
      final resp = await api.getUsersInfo(userIDs: [_userID]);
      if (resp.errCode != 0) return;
      final users = resp.data?['usersInfo'] as List? ?? [];
      if (users.isNotEmpty && users.first is Map<String, dynamic>) {
        final newInfo = users.first as Map<String, dynamic>;
        final oldUser = await database.getLoginUser();
        final oldNickname = oldUser?.nickname ?? '';
        final oldFaceUrl = oldUser?.faceURL ?? '';

        await database.upsertUser(newInfo);

        final newNickname = newInfo['nickname'] as String? ?? '';
        final newFaceUrl = newInfo['faceURL'] as String? ?? '';

        if ((newNickname != oldNickname || newFaceUrl != oldFaceUrl) && newNickname.isNotEmpty) {
          await database.updateAllMessageSenderInfo(
            _userID,
            senderNickname: newNickname,
            senderFaceUrl: newFaceUrl.isNotEmpty ? newFaceUrl : null,
          );
        }
      }
    } catch (e, s) {
      _log.error('同步自身用户信息异常: $e', error: e, stackTrace: s, methodName: '_syncSelfUserInfo');
    }
  }

  // ---------------------------------------------------------------------------
  // 推送消息处理（队列模式，保证顺序处理）
  // ---------------------------------------------------------------------------

  /// 处理来自 WebSocket 的推送消息
  ///
  /// 将推送消息加入队列，由 [_drainPushMsgQueue] 按顺序消费。
  /// 这样即使消息到达速度超过处理速度，也不会产生并发 DB 写入竞争，
  /// 且高负载时自然聚合多条推送为一次批量 DB 更新。
  void handlePushMsg(WebSocketResponse resp) {
    if (resp.data.isEmpty) return;
    _pushMsgQueue.add(resp);
    _triggerDrainIfNeeded();
  }

  /// 如果推送队列非空且未在消费中，且同步锁未持有，则启动消费。
  void _triggerDrainIfNeeded() {
    if (_pushMsgQueue.isEmpty) return;
    if (_isDrainingPushQueue) return;
    if (_isSyncLocked) return;
    _isDrainingPushQueue = true;
    unawaited(_drainPushMsgQueue());
  }

  /// 队列消费循环：取出所有已排队的推送消息，合并为一个批次处理
  ///
  /// 每轮循环处理当前队列中全部消息（自然批量）；
  /// 处理完成后若有新消息入队，则继续下一轮。
  Future<void> _drainPushMsgQueue() async {
    try {
      while (_pushMsgQueue.isNotEmpty) {
        // 同步锁持有时暂停消费（不丢弃消息），同步完成后会重新触发
        if (_isSyncLocked) {
          _log.info('同步锁持有，暂停推送队列消费', methodName: '_drainPushMsgQueue');
          return;
        }

        final gapSyncRanges = <String, List<int>>{};
        final convUpdates = <String, ConvBatchUpdate>{};

        // 关键：在所有 _parsePushMsg 调用之前拍摄 seq 快照。
        // _parsePushMsg 在连续推送时会立即推进 _syncedMaxSeqs（用于同批次多推送的缺口检测），
        // 因此如果在 _parsePushMsg 之后读取 _syncedMaxSeqs，
        // oldSyncedSeq 将等于最新消息的 seq，导致 newUnreadCount 永远为 0。
        // 使用快照可确保 _applyBatchUpdatesAndNotify 使用推送前的基线 seq 计算未读数。
        final preBatchMaxSeqs = Map<String, int>.from(_syncedMaxSeqs);

        // 取出当前队列中所有消息，合并解析
        while (_pushMsgQueue.isNotEmpty) {
          final resp = _pushMsgQueue.removeFirst();
          try {
            _parsePushMsg(resp, convUpdates, gapSyncRanges);
          } catch (e, s) {
            _log.error('解析推送消息失败: $e', error: e, stackTrace: s, methodName: '_drainPushMsgQueue');
          }
        }

        // 顺序执行批量 DB 更新（await 保证完成后才处理下一批）
        if (convUpdates.isNotEmpty || gapSyncRanges.isNotEmpty) {
          await _applyBatchUpdatesAndNotify(convUpdates, gapSyncRanges, preBatchMaxSeqs);
        }
      }
    } catch (e, s) {
      _log.error('推送队列消费异常: $e', error: e, stackTrace: s, methodName: '_drainPushMsgQueue');
    } finally {
      _isDrainingPushQueue = false;
    }
  }

  /// 解析单条推送消息，将结果聚合到共享的 [convUpdates] 和 [gapSyncRanges]
  ///
  /// 对应 Go SDK 的 doPushMsg / pushTriggerAndSync：
  /// 1. 解析推送体中的 msgs 和 notificationMsgs（protobuf 解码）
  /// 2. 验证 SEQ 连续性，发现缺口时记录 [localMaxSeq+1, lastSeq] 同步范围
  ///    （直接使用推送中的 lastSeq，不依赖服务端 maxSeq，对齐 Go SDK）
  /// 3. 存储消息并更新会话（latestMsg, unreadCount, maxSeq）
  /// 4. 触发回调通知上层
  void _parsePushMsg(
    WebSocketResponse resp,
    Map<String, ConvBatchUpdate> convUpdates,
    Map<String, List<int>> gapSyncRanges,
  ) {
    final pushMessages = sdkws.PushMessages.fromBuffer(resp.data);

    // 处理普通消息（对齐 Go SDK pushTriggerAndSync）
    for (final entry in pushMessages.msgs.entries) {
      final convID = entry.key;
      final pullMsgs = entry.value;
      final msgList = pullMsgs.msgs;
      if (msgList.isEmpty) continue;

      final localMaxSeq = _syncedMaxSeqs[convID] ?? 0;
      int lastSeq = 0;
      final storageMsgs = <Map<String, dynamic>>[];

      for (final msg in msgList) {
        final msgMap = _msgDataToMap(msg);
        final seq = (msgMap['seq'] as int?) ?? 0;

        // seq=0 消息不参与连续性计算，直接触发（Go 同步逻辑同样如此）
        if (seq == 0) {
          _collectMessageUpdate(msgMap, convID, convUpdates);
          continue;
        }

        lastSeq = seq;
        storageMsgs.add(msgMap);
      }

      if (storageMsgs.isEmpty) continue;

      final expectedLast = localMaxSeq + storageMsgs.length;
      if (lastSeq == expectedLast) {
        for (final msgMap in storageMsgs) {
          _collectMessageUpdate(msgMap, convID, convUpdates);
        }
        // 对齐 Go SDK pushTriggerAndSync：连续推送时立即推进 syncedMaxSeqs，
        // 确保同批次后续推送的连续性校验使用正确的基线值。
        _syncedMaxSeqs[convID] = lastSeq;
      } else if (lastSeq > localMaxSeq) {
        _log.warning(
          '检测到 SEQ 缺口: conv=$convID, local=$localMaxSeq, lastSeq=$lastSeq, expectedLast=$expectedLast',
          methodName: '_parsePushMsg',
        );
        // 对齐 Go SDK pushTriggerAndSync：记录 [localMaxSeq+1, lastSeq] 作为同步范围，
        // 直接使用推送中的 lastSeq 而非查询服务端 maxSeq（避免最终一致性延迟导致范围不足）。
        final rangeStart = localMaxSeq + 1;
        final existing = gapSyncRanges[convID];
        if (existing != null) {
          gapSyncRanges[convID] = [min(existing[0], rangeStart), max(existing[1], lastSeq)];
        } else {
          gapSyncRanges[convID] = [rangeStart, lastSeq];
        }
      }
    }

    // 处理通知消息（同样对齐 Go SDK pushTriggerAndSync）
    for (final entry in pushMessages.notificationMsgs.entries) {
      final convID = entry.key;
      final pullMsgs = entry.value;
      final localMaxSeq = _syncedMaxSeqs[convID] ?? 0;
      int lastSeq = 0;
      final storageMsgs = <Map<String, dynamic>>[];

      for (final msg in pullMsgs.msgs) {
        final msgMap = _msgDataToMap(msg);
        final seq = (msgMap['seq'] as int?) ?? 0;
        if (seq == 0) {
          unawaited(_processNotificationMessage(msgMap, convID));
          continue;
        }
        lastSeq = seq;
        storageMsgs.add(msgMap);
      }

      if (storageMsgs.isEmpty) continue;

      final expectedLast = localMaxSeq + storageMsgs.length;
      if (lastSeq == expectedLast) {
        for (final msgMap in storageMsgs) {
          unawaited(_processNotificationMessage(msgMap, convID));
        }
        // 对齐 Go SDK：通知消息同样立即推进 syncedMaxSeqs
        _syncedMaxSeqs[convID] = lastSeq;
      } else if (lastSeq > localMaxSeq) {
        _log.warning(
          '检测到通知 SEQ 缺口: conv=$convID, local=$localMaxSeq, lastSeq=$lastSeq, expectedLast=$expectedLast',
          methodName: '_parsePushMsg',
        );
        final rangeStart = localMaxSeq + 1;
        final existing = gapSyncRanges[convID];
        if (existing != null) {
          gapSyncRanges[convID] = [min(existing[0], rangeStart), max(existing[1], lastSeq)];
        } else {
          gapSyncRanges[convID] = [rangeStart, lastSeq];
        }
      }
    }
  }

  /// 将 protobuf MsgData 转为 [Map<String, dynamic>]（供数据库和回调使用）
  Map<String, dynamic> _msgDataToMap(sdkws.MsgData msg) {
    return {
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

  /// 将 HTTP API 返回消息中 base64 编码的 content 解码为原始 JSON 字符串。
  ///
  /// proto3 JSON 将 `bytes` 字段编码为 base64，但下游代码和数据库期望
  /// content 是可直接 jsonDecode 的原始 JSON 字符串。
  /// 此方法原地修改 msg map。
  void _decodeContentIfBase64(Map<String, dynamic> msg) {
    try {
      final content = msg['content'];
      if (content is! String || content.isEmpty) return;

      // 如果已经是合法 JSON，无需解码
      try {
        jsonDecode(content);
        return;
      } catch (_) {}

      // 尝试 base64 解码
      try {
        final decoded = utf8.decode(base64Decode(content));
        msg['content'] = decoded;
      } catch (_) {
        // 既非 JSON 也非 base64，保持原值
      }
    } catch (e, s) {
      _log.error('解码失败: $e', error: e, stackTrace: s, methodName: '_decodeContentIfBase64');
    }
  }

  /// 收集单条消息对会话的影响（纯内存操作，不写 DB）
  void _collectMessageUpdate(
    Map<String, dynamic> msg,
    String conversationID,
    Map<String, ConvBatchUpdate> convUpdates,
  ) {
    try {
      final seq = msg['seq'] as int? ?? 0;
      final contentType = msg['contentType'] as int? ?? 0;
      final sendTime = msg['sendTime'] as int? ?? 0;
      final sendID = msg['sendID'] as String? ?? '';
      final isSelfMsg = sendID == _userID;

      // 检查是否为仅在线消息（options 中 history == false）
      final options = msg['options'] as Map<String, bool>? ?? const {};
      final isHistory = options['history'] ?? true;

      // 仅在线消息：不存储，仅触发 onRecvOnlineOnlyMessage
      if (!isHistory) {
        // 通知消息仍需路由到 NotificationDispatcher（如 BusinessNotification）
        if (contentType >= 1000) {
          final content = msg['content'] as String? ?? '';
          notificationDispatcher.dispatch(contentType, content);
        }
        // Typing 消息（contentType=113）触发输入状态变更回调
        if (contentType == 113) {
          _fireInputStatusChanged(msg, conversationID);
        }
        _fireOnlineOnlyMessage(msg);
        return;
      }

      // seq == 0 的消息是临时消息（如 typing），不存储
      if (seq == 0) {
        _fireNewMessage(msg);
        return;
      }

      // 通知消息（contentType >= 1000）：路由到 NotificationDispatcher
      // Go SDK 在 triggerConversation 中存储所有消息（含通知），
      // 通知/普通分流在 conversation 层（n_ 前缀）而非 contentType 层。
      // pushMessages.msgs 只包含普通会话消息，所以全部存入 chatLog。
      if (contentType >= 1000) {
        final content = msg['content'] as String? ?? '';
        notificationDispatcher.dispatch(contentType, content);
      }

      // 存储消息到 chatLog（注入 conversationID 和默认 status）
      // 聚合会话更新
      final update = convUpdates.putIfAbsent(conversationID, () => ConvBatchUpdate(firstMsg: msg));
      // protobuf status 默认为 0，需设为 succeeded
      final msgToInsert = {...msg, 'conversationID': conversationID};
      final rawStatus = msgToInsert['status'];
      if (rawStatus == null || rawStatus == 0) {
        msgToInsert['status'] = MessageStatus.succeeded.value;
      }
      update.pendingMessages.add(msgToInsert);

      final candidateSeq = seq;
      if (sendTime > update.latestMsgSendTime ||
          (sendTime == update.latestMsgSendTime && candidateSeq > update.latestMsgSeq)) {
        update.latestMsg = msg;
        update.latestMsgSendTime = sendTime;
        update.latestMsgSeq = candidateSeq;
      }
      if (seq > update.maxSeq) update.maxSeq = seq;
      // 对齐 Go SDK doMsgNew：仅当消息的 IsUnreadCount 选项为 true 时才计入未读
      // （召回通知、typing 等系统消息不计入未读）
      final isUnreadCount = options['unreadCount'] ?? true;
      if (!isSelfMsg && seq > 0 && isUnreadCount) {
        update.incomingSeqs.add(seq);
      }

      // 触发新消息回调
      _fireNewMessage(msg);
    } catch (e, s) {
      _log.error('收集消息更新失败: $e', error: e, stackTrace: s, methodName: '_collectMessageUpdate');
    }
  }

  /// 批量应用会话更新到 DB，并触发通知
  ///
  /// [preBatchMaxSeqs] 是在本批 _parsePushMsg 调用之前拍摄的 _syncedMaxSeqs 快照。
  /// 必须用快照而非实时 _syncedMaxSeqs 计算 oldSyncedSeq，
  /// 因为 _parsePushMsg 在处理连续推送时会提前推进 _syncedMaxSeqs，
  /// 导致若使用实时值，所有 incomingSeqs 都不大于 oldSyncedSeq，newUnreadCount 始终为 0。
  Future<void> _applyBatchUpdatesAndNotify(
    Map<String, ConvBatchUpdate> convUpdates,
    Map<String, List<int>> gapSyncRanges,
    Map<String, int> preBatchMaxSeqs,
  ) async {
    final changedConvIDs = <String>{};
    final newConvIDs = <String>{};

    for (final entry in convUpdates.entries) {
      final convID = entry.key;
      final update = entry.value;

      try {
        if (update.pendingMessages.isNotEmpty) {
          await database.batchInsertMessages(update.pendingMessages);
          // 使用推送前快照（preBatchMaxSeqs）而非实时 _syncedMaxSeqs，
          // 确保未读数计算基于正确的历史基线（对齐 Go SDK maxSeqRecorder.IsNewMsg 语义）。
          final oldSyncedSeq = preBatchMaxSeqs[convID] ?? 0;
          if (update.maxSeq > (_syncedMaxSeqs[convID] ?? 0)) {
            _syncedMaxSeqs[convID] = update.maxSeq;
          }
          if (update.incomingSeqs.isNotEmpty) {
            update.newUnreadCount = update.incomingSeqs.where((seq) => seq > oldSyncedSeq).length;
          }
        }

        final existing = await database.getConversation(convID);
        if (existing != null) {
          // 更新已有会话
          final updates = <String, dynamic>{};
          final existingLatestTime = existing.latestMsgSendTime ?? 0;
          final existingLatestSeq = existing.latestMsg?.seq ?? 0;
          final shouldUpdateLatest =
              update.latestMsgSendTime > existingLatestTime ||
              (update.latestMsgSendTime == existingLatestTime &&
                  update.latestMsgSeq > existingLatestSeq);
          if (shouldUpdateLatest && update.latestMsg != null) {
            updates['latestMsg'] = jsonEncode(update.latestMsg);
            updates['latestMsgSendTime'] = update.latestMsgSendTime;
          }
          if (update.newUnreadCount > 0) {
            final oldUnread = existing.unreadCount;
            updates['unreadCount'] = oldUnread + update.newUnreadCount;
          }
          final oldMaxSeq = await database.getConversationMaxSeq(convID);
          if (update.maxSeq > oldMaxSeq) {
            updates['maxSeq'] = update.maxSeq;
          }
          if (updates.isNotEmpty) {
            await database.updateConversation(convID, updates);
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

          await database.upsertConversation({
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

    // 缺口同步（直接使用推送的 seq 范围，对齐 Go SDK pushTriggerAndSync → syncAndTriggerMsgs）
    if (gapSyncRanges.isNotEmpty) {
      try {
        _log.info(
          '推送缺口同步: ${gapSyncRanges.entries.map((e) => '${e.key}=[${e.value[0]},${e.value[1]}]').join(', ')}',
          methodName: '_applyBatchUpdatesAndNotify',
        );
        final gapUpdatedConvIDs = await _syncHistoryByQueue(
          needSyncSeqs: gapSyncRanges,
          pullNum: 10,
        );
        changedConvIDs.addAll(gapUpdatedConvIDs);

        // 对齐 Go SDK syncAndTriggerMsgs：无论实际拉取多少条，
        // 都将 syncedMaxSeqs 推进到请求范围的末尾，避免后续推送反复触发同样的缺口同步。
        for (final entry in gapSyncRanges.entries) {
          final endSeq = entry.value[1];
          if (endSeq > (_syncedMaxSeqs[entry.key] ?? 0)) {
            _syncedMaxSeqs[entry.key] = endSeq;
          }
        }
      } catch (e, s) {
        _log.error(
          '推送缺口同步失败: $e',
          error: e,
          stackTrace: s,
          methodName: '_applyBatchUpdatesAndNotify',
        );
        // 即使同步失败，也推进 syncedMaxSeqs 避免无限重试（对齐 Go SDK 行为）
        for (final entry in gapSyncRanges.entries) {
          final endSeq = entry.value[1];
          if (endSeq > (_syncedMaxSeqs[entry.key] ?? 0)) {
            _syncedMaxSeqs[entry.key] = endSeq;
          }
        }
      }
    }

    // 通知 UI：通过 Listener 回调
    if (changedConvIDs.isNotEmpty) {
      _fireConversationChanged(changedConvIDs);
    }
    if (newConvIDs.isNotEmpty) {
      _fireNewConversation(newConvIDs);
    }
    if (changedConvIDs.isNotEmpty || newConvIDs.isNotEmpty) {
      _fireTotalUnreadCountChanged();
    }
  }

  /// 异步补充新会话的 showName 和 faceURL
  Future<void> _enrichNewConversation(
    String conversationID,
    int sessionType,
    String? userID,
    String? groupID,
  ) async {
    _log.info('conversationID=$conversationID', methodName: '_enrichNewConversation');
    try {
      final updates = <String, dynamic>{};

      if ((sessionType == 1 || sessionType == 4) && userID != null && userID.isNotEmpty) {
        // 单聊/通知：优先用好友备注
        final friend = await database.getFriendByUserID(userID);
        if (friend != null) {
          updates['showName'] = friend.getShowName();
          updates['faceURL'] = friend.faceURL ?? '';
        } else {
          // 从用户表查
          final users = await database.getUsersByIDs([userID]);
          if (users.isNotEmpty) {
            updates['showName'] = users.first.getShowName();
            updates['faceURL'] = users.first.faceURL ?? '';
          } else {
            // 网络兜底
            try {
              final resp = await api.getUsersInfo(userIDs: [userID]);
              if (resp.errCode == 0) {
                final netUsers = resp.data?['usersInfo'] as List? ?? [];
                if (netUsers.isNotEmpty && netUsers.first is Map<String, dynamic>) {
                  final u = netUsers.first as Map<String, dynamic>;
                  updates['showName'] = u['nickname'] as String? ?? '';
                  updates['faceURL'] = u['faceURL'] as String? ?? '';
                  await database.upsertUser(u);
                }
              }
            } catch (_) {}
          }
        }
      } else if (sessionType == 3 && groupID != null && groupID.isNotEmpty) {
        // 群聊：用群组名称
        final group = await database.getGroupByID(groupID);
        if (group != null) {
          updates['showName'] = group.groupName ?? '';
          updates['faceURL'] = group.faceURL ?? '';
        } else {
          // 网络兜底
          try {
            final resp = await api.getGroupsInfo(groupIDs: [groupID]);
            if (resp.errCode == 0) {
              final netGroups = resp.data?['groupInfos'] as List? ?? [];
              if (netGroups.isNotEmpty && netGroups.first is Map<String, dynamic>) {
                final g = netGroups.first as Map<String, dynamic>;
                updates['showName'] = g['groupName'] as String? ?? '';
                updates['faceURL'] = g['faceURL'] as String? ?? '';
                await database.upsertGroup(g);
              }
            }
          } catch (_) {}
        }
      }

      if (updates.isNotEmpty) {
        await database.updateConversation(conversationID, updates);

        final updated = await database.getConversation(conversationID);
        if (updated != null) {
          conversationListener?.conversationChanged([updated]);
        }
      }
    } catch (e, s) {
      _log.error(
        '补充会话信息失败: $conversationID, $e',
        error: e,
        stackTrace: s,
        methodName: '_enrichNewConversation',
      );
    }
  }

  /// 处理通知消息（好友/群组/会话变更等系统通知）
  ///
  /// 通知消息不存入 chatLog，但需要：
  /// 1. 更新 seq 追踪
  /// 2. 路由到 NotificationDispatcher 进行解析和回调
  Future<void> _processNotificationMessage(Map<String, dynamic> msg, String conversationID) async {
    try {
      final seq = msg['seq'] as int? ?? 0;
      final contentType = msg['contentType'] as int? ?? 0;

      // 更新 seq
      if (seq > 0 && seq > (_syncedMaxSeqs[conversationID] ?? 0)) {
        _syncedMaxSeqs[conversationID] = seq;
        await database.upsertNotificationSeq(conversationID, seq);
        await database.updateConversation(conversationID, {'maxSeq': seq});
      }

      // 路由到通知分发器
      final content = msg['content'] as String? ?? '';
      notificationDispatcher.dispatch(contentType, content);
    } catch (e, s) {
      _log.error(
        '处理通知消息失败: $e',
        error: e,
        stackTrace: s,
        methodName: '_processNotificationMessage',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Listener 回调辅助
  // ---------------------------------------------------------------------------

  /// 将消息 Map 转为 Message 对象并触发消息监听
  ///
  /// 使用 DatabaseService.convertMessage 统一解析 content → 对应 Elem，
  /// 与从数据库加载消息走同一条路径，确保 textElem 等字段正确填充。
  void _fireNewMessage(Map<String, dynamic> msg) {
    final message = convertMessage(msg);
    // 拦截通话信令消息（invite 使用 persistent=true 发送，
    // 离线用户上线后会通过此路径收到）
    if (message.contentType == MessageType.custom) {
      final customData = message.customElem?.data;
      if (customData != null && callManager != null) {
        final handled = callManager!.handleSignalingMessage(message.sendID ?? '', customData);
        if (handled) return; // 信令消息已处理，不传递给普通监听器
      }
    }
    msgListener?.recvNewMessage(message);
    listenerForService?.recvNewMessage(message);
  }

  /// 仅在线消息：不存储到本地，仅触发 onRecvOnlineOnlyMessage
  void _fireOnlineOnlyMessage(Map<String, dynamic> msg) {
    final message = convertMessage(msg);
    // 拦截通话信令消息
    if (message.contentType == MessageType.custom ||
        message.contentType == MessageType.customMsgOnlineOnly) {
      final customData = message.customElem?.data;
      if (customData != null && callManager != null) {
        final handled = callManager!.handleSignalingMessage(message.sendID ?? '', customData);
        if (handled) return; // 信令消息已处理，不传递给普通监听器
      }
    }
    msgListener?.recvOnlineOnlyMessage(message);
    listenerForService?.recvOnlineOnlyMessage(message);
  }

  /// Typing 消息触发输入状态变更回调
  ///
  /// 对应 Go SDK 的 entering.go，收到 contentType=113 的在线消息时
  /// 解析 content 中的 msgTips 字段，触发 OnConversationUserInputStatusChanged
  void _fireInputStatusChanged(Map<String, dynamic> msg, String conversationID) {
    try {
      final sendID = msg['sendID'] as String? ?? '';
      final content = msg['content'] as String? ?? '';
      final platformID = msg['senderPlatformID'] as int? ?? 0;
      Map<String, dynamic>? contentMap;
      try {
        contentMap = jsonDecode(content) as Map<String, dynamic>?;
      } catch (_) {}
      final msgTips = contentMap?['msgTips'] as String? ?? '';
      final platformIDs = msgTips == 'yes' && platformID > 0 ? [platformID] : <int>[];
      conversationListener?.conversationUserInputStatusChanged(
        InputStatusChangedData(
          conversationID: conversationID,
          userID: sendID,
          platformIDs: platformIDs,
        ),
      );
    } catch (e, s) {
      _log.error('处理输入状态变更失败: $e', error: e, stackTrace: s, methodName: '_fireInputStatusChanged');
    }
  }

  /// 从 DB 加载会话并触发 conversationChanged
  Future<void> _fireConversationChanged(Set<String> convIDs) async {
    final convList = <ConversationInfo>[];
    for (final id in convIDs) {
      final conv = await database.getConversation(id);
      if (conv != null) convList.add(conv);
    }
    if (convList.isNotEmpty) {
      conversationListener?.conversationChanged(convList);
    }
  }

  /// 从 DB 加载会话并触发 newConversation
  Future<void> _fireNewConversation(Set<String> convIDs) async {
    final convList = <ConversationInfo>[];
    for (final id in convIDs) {
      final conv = await database.getConversation(id);
      if (conv != null) convList.add(conv);
    }
    if (convList.isNotEmpty) {
      conversationListener?.newConversation(convList);
    }
  }

  /// 计算总未读数并触发回调
  Future<void> _fireTotalUnreadCountChanged() async {
    final conversations = await database.getAllConversations();
    int total = 0;
    for (final c in conversations) {
      total += c.unreadCount;
    }
    conversationListener?.totalUnreadMessageCountChanged(total);
  }
}

/// 已读回执预聚合条目
class _ReadReceiptEntry {
  final String content;
  final int hasReadSeq;

  _ReadReceiptEntry(this.content, this.hasReadSeq);
}
