import 'dart:async';
import 'dart:convert';

import 'package:openim_sdk/src/logger/logger.dart';
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
  final Logger _log = Logger('MsgSyncer');

  final DatabaseService database;

  final ImApiService api;

  final NotificationDispatcher notificationDispatcher;

  final MessageManager messageManager;

  final ConversationManager conversationManager;

  final MomentsManager momentsManager;

  final FavoriteManager favoriteManager;

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

  /// 每个会话已同步的最大 seq
  final Map<String, int> _syncedMaxSeqs = {};

  /// 同步前本地已有的 maxSeq（用于计算消息缺口）
  final Map<String, int> _localMaxSeqsBeforeSync = {};

  /// 是否正在同步
  bool _isSyncing = false;

  /// 是否为重新安装（本地无数据）
  bool _reinstalled = false;

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
      _log.info('正在同步中，忽略重复触发', methodName: 'doConnectedSync');
      return;
    }
    _isSyncing = true;

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
      // 5 秒冷却期后才允许下次同步（对应 Go SDK startSync 的防重入机制）
      Future.delayed(const Duration(seconds: 5), () {
        _isSyncing = false;
      });
    }
  }

  /// 从本地数据库加载已同步的 seq
  Future<void> _loadSeqs() async {
    _log.info('called', methodName: '_loadSeqs');
    try {
      _syncedMaxSeqs.clear();
      _localMaxSeqsBeforeSync.clear();

      final conversations = await database.getAllConversations();
      if (conversations.isEmpty) {
        _reinstalled = true;
        return;
      }
      _reinstalled = false;

      // 批量获取所有会话的 maxSeq（一次查询代替 N 次逐个查询）
      final allSeqs = await database.getAllConversationMaxSeqs();
      for (final conv in conversations) {
        final conversationID = conv.conversationID;
        final maxSeq = allSeqs[conversationID] ?? 0;
        _syncedMaxSeqs[conversationID] = maxSeq;
        _localMaxSeqsBeforeSync[conversationID] = maxSeq;
      }
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
  Future<void> _syncConversationsAndSeqs() async {
    _log.info('called', methodName: '_syncConversationsAndSeqs');
    try {
      // 1. 先获取本地所有会话 ID（用于比较哪些是新增的）
      final localConvs = await database.getAllConversations();
      final localConvIDs = localConvs.map((c) => c.conversationID).toSet();
      _log.info(
        '本地会话数: ${localConvIDs.length}, reinstalled: $_reinstalled',
        methodName: '_syncConversationsAndSeqs',
      );

      // 2. 初次安装或非首次：不同处理逻辑
      Map<String, dynamic> serverSeqs = {};
      final bool isFirstInstall = localConvIDs.isEmpty || _reinstalled;

      if (isFirstInstall) {
        // 初次安装：从服务端获取完整会话列表
        final resp = await api.getAllConversations(ownerUserID: _userID);
        if (resp.errCode == 0) {
          final conversations = resp.data?['conversations'] as List? ?? [];
          if (conversations.isNotEmpty) {
            // 跳过自己和自己的单聊会话
            final convMaps = <Map<String, dynamic>>[];
            for (final conv in conversations) {
              if (conv is Map<String, dynamic>) {
                final convType = conv['conversationType'] as int?;
                final uid = conv['userID'] as String?;
                if (convType == 1 && uid == _userID) continue;

                final map = Map<String, dynamic>.from(conv);
                if (map['latestMsg'] is Map) {
                  map['latestMsg'] = jsonEncode(map['latestMsg']);
                }
                convMaps.add(map);

                // 从会话中提取 seq 信息
                final cid = conv['conversationID'] as String?;
                if (cid != null) {
                  final maxSeq = (conv['maxSeq'] as num?)?.toInt() ?? 0;
                  final hasReadSeq = (conv['hasReadSeq'] as num?)?.toInt() ?? 0;
                  serverSeqs[cid] = {'maxSeq': maxSeq, 'hasReadSeq': hasReadSeq};
                }
              }
            }

            // 补充 showName/faceURL
            await _batchAddFaceURLAndName(convMaps);

            // 计算未读数并设置 seq
            for (final conv in convMaps) {
              final convID = conv['conversationID'] as String?;
              if (convID == null) continue;

              final seqInfo = serverSeqs[convID];
              if (seqInfo != null) {
                final maxSeq = (seqInfo['maxSeq'] as num?)?.toInt() ?? 0;
                final hasReadSeq = (seqInfo['hasReadSeq'] as num?)?.toInt() ?? 0;
                final unread = (maxSeq - hasReadSeq).clamp(0, maxSeq);
                conv['unreadCount'] = unread;
                conv['maxSeq'] = maxSeq;
                conv['hasReadSeq'] = hasReadSeq;
                _syncedMaxSeqs[convID] = maxSeq;
              }
            }

            // 批量写入本地
            if (convMaps.isNotEmpty) {
              await database.batchUpsertConversations(convMaps);
            }
            _log.info('初次安装：已同步 ${convMaps.length} 个会话', methodName: '_syncConversationsAndSeqs');
          }
        }
      } else {
        // 非初次安装：获取服务端 seqs，比较本地会话，只获取新增会话
        // 对应 Go SDK: GetConvMaxReadSeq
        if (localConvIDs.isNotEmpty) {
          final seqResp = await api.getConversationsHasReadAndMaxSeq(
            userID: _userID,
            conversationIDs: localConvIDs.toList(),
          );
          if (seqResp.errCode == 0) {
            serverSeqs = seqResp.data?['seqs'] as Map<String, dynamic>? ?? {};
          }
        }
        _log.info('服务端 seq 数: ${serverSeqs.length}', methodName: '_syncConversationsAndSeqs');

        // 3. 找出需要同步的会话 ID（服务端有但本地没有的会话）
        final newConvIDs = serverSeqs.keys.where((id) => !localConvIDs.contains(id)).toList();
        _log.info('新增会话数: ${newConvIDs.length}', methodName: '_syncConversationsAndSeqs');

        // 4. 只获取新增会话的完整信息（按需获取，效率更高）
        // 对应 Go SDK: getConversationsByIDsFromServer
        final convMaps = <Map<String, dynamic>>[];
        if (newConvIDs.isNotEmpty) {
          final resp = await api.getConversations(
            ownerUserID: _userID,
            conversationIDs: newConvIDs,
          );
          if (resp.errCode == 0) {
            final conversations = resp.data?['conversations'] as List? ?? [];
            for (final conv in conversations) {
              if (conv is Map<String, dynamic>) {
                final map = Map<String, dynamic>.from(conv);
                if (map['latestMsg'] is Map) {
                  map['latestMsg'] = jsonEncode(map['latestMsg']);
                }
                convMaps.add(map);
              }
            }
          }

          // 补充 showName/faceURL
          await _batchAddFaceURLAndName(convMaps);

          // 5. 计算未读数并设置 seq
          for (final conv in convMaps) {
            final convID = conv['conversationID'] as String?;
            if (convID == null) continue;

            final seqInfo = serverSeqs[convID];
            if (seqInfo != null) {
              final maxSeq = (seqInfo['maxSeq'] as num?)?.toInt() ?? 0;
              final hasReadSeq = (seqInfo['hasReadSeq'] as num?)?.toInt() ?? 0;
              final unread = (maxSeq - hasReadSeq).clamp(0, maxSeq);
              conv['unreadCount'] = unread;
              conv['maxSeq'] = maxSeq;
              conv['hasReadSeq'] = hasReadSeq;
              _syncedMaxSeqs[convID] = maxSeq;
            }
          }

          // 6. 批量写入新增会话到本地数据库
          if (convMaps.isNotEmpty) {
            await database.batchUpsertConversations(convMaps);
          }
        }

        // 7. 更新已存在会话的 seq 和未读数
        final existingConvIDs = serverSeqs.keys.where((id) => localConvIDs.contains(id)).toList();
        for (final convID in existingConvIDs) {
          final seqInfo = serverSeqs[convID];
          if (seqInfo is Map<String, dynamic>) {
            final maxSeq = (seqInfo['maxSeq'] as num?)?.toInt() ?? 0;
            final hasReadSeq = (seqInfo['hasReadSeq'] as num?)?.toInt() ?? 0;
            final localMaxSeq = _syncedMaxSeqs[convID] ?? 0;

            if (maxSeq != localMaxSeq) {
              final unread = (maxSeq - hasReadSeq).clamp(0, maxSeq);
              await database.updateConversation(convID, {
                'maxSeq': maxSeq,
                'hasReadSeq': hasReadSeq,
                'unreadCount': unread,
              });
              _syncedMaxSeqs[convID] = maxSeq;
            }
          }
        }

        _log.info('会话同步完成，新增: ${convMaps.length}', methodName: '_syncConversationsAndSeqs');
      }
    } catch (e, s) {
      _log.error('同步会话异常: $e', error: e, stackTrace: s, methodName: '_syncConversationsAndSeqs');
    }
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
        } else if (type == 3) {
          // 超级群
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
          if (uid != null) userMap[uid] = u;
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
              final netGroups = resp.data?['groupInfoList'] as List? ?? [];
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
            final remark = friend.remark ?? '';
            conv['showName'] = remark.isNotEmpty ? remark : (friend.nickname ?? '');
            conv['faceURL'] = friend.faceURL ?? '';
          } else {
            final user = userMap[uid];
            if (user != null) {
              conv['showName'] = user.nickname ?? '';
              conv['faceURL'] = user.faceURL ?? '';
            }
          }
        } else if (type == 3) {
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

  /// 同步好友列表
  Future<void> _syncFriends() async {
    _log.info('called', methodName: '_syncFriends');
    try {
      int pageNumber = 1;
      const pageSize = 100;
      final allFriends = <Map<String, dynamic>>[];
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
            // 服务端返回的好友信息中，对方的详细信息在嵌套的 friendUser 字段中
            // 需要将其扁平化为 DB 表格的结构（主键 friendUserID = friendUser.userID）
            final friendUser = f['friendUser'] as Map<String, dynamic>? ?? {};
            allFriends.add({
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
        if (friends.length < pageSize) break;
        pageNumber++;
      }
      if (allFriends.isNotEmpty) await database.batchUpsertFriends(allFriends);
      _log.info('好友同步完成', methodName: '_syncFriends');
    } catch (e, s) {
      _log.error('同步好友异常: $e', error: e, stackTrace: s, methodName: '_syncFriends');
    }
  }

  /// 同步已加入的群组及其成员
  Future<void> _syncJoinedGroups() async {
    _log.info('called', methodName: '_syncJoinedGroups');
    try {
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
      _log.info('群组同步完成，共 ${allGroups.length} 个群', methodName: '_syncJoinedGroups');

      // 同步每个群的成员列表
      for (final group in allGroups) {
        final groupID = group['groupID'] as String?;
        if (groupID == null || groupID.isEmpty) continue;
        await _syncGroupMembersForGroup(groupID);
      }
      _log.info('群成员同步完成', methodName: '_syncJoinedGroups');
    } catch (e, s) {
      _log.error('同步群组异常: $e', error: e, stackTrace: s, methodName: '_syncJoinedGroups');
    }
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
  /// 对应 Go SDK 的 compareSeqsAndBatchSync → syncAndTriggerMsgs / syncAndTriggerReinstallMsgs：
  /// - connectPullNums = 1：每个会话拉最新 1 条（用于 latestMsg）
  /// - SplitPullMsgNum = 100：累计超过 100 条时分批拉取
  /// - 重装时跳过 n_ 通知会话(Go SDK: 直接记录 seq 不拉取)
  Future<void> _syncMessages() async {
    _log.info('called', methodName: '_syncMessages');
    try {
      if (_syncedMaxSeqs.isEmpty) return;

      // 对比服务端 maxSeq（_syncedMaxSeqs 已被 _syncConversationsAndSeqs 更新）
      // 与同步前的本地 maxSeq，找出需要拉取的会话
      final needSyncSeqs = <String, List<int>>{}; // convID -> [begin, end]

      for (final entry in _syncedMaxSeqs.entries) {
        final convID = entry.key;
        final serverMaxSeq = entry.value;
        final localMaxSeq = _localMaxSeqsBeforeSync[convID] ?? 0;

        // 初次安装时，无论 seq 是否为 0 都拉取 1 条消息用于 latestMsg
        // 对应 Go SDK connectPullNums = 1，确保会话列表显示最新消息
        if (_reinstalled && !convID.startsWith('n_')) {
          // 跳过通知会话，重装时只拉取普通会话的最新消息
          // begin 从 1 开始（seq 从 1 计数），serverMaxSeq 为 0 时也拉取（会返回空）
          needSyncSeqs[convID] = [1, serverMaxSeq > 0 ? serverMaxSeq : 1];
        } else if (serverMaxSeq > localMaxSeq) {
          // 重装时跳过 n_ 通知会话（对应 Go SDK compareSeqsAndBatchSync）
          if (convID.startsWith('n_')) {
            continue;
          }
          needSyncSeqs[convID] = [localMaxSeq + 1, serverMaxSeq];
        }
      }

      if (needSyncSeqs.isEmpty) {
        _log.info('所有会话消息已是最新', methodName: '_syncMessages');
        return;
      }

      // 初次安装时记录日志
      if (_reinstalled) {
        _log.info('初次安装：准备拉取 ${needSyncSeqs.length} 个会话的消息', methodName: '_syncMessages');
      }

      // 对应 Go SDK connectPullNums = 1
      const connectPullNums = 1;

      // 分批拉取，每批最多 100 个 SeqRange
      const splitPullMsgNum = 100;
      final seqRanges = <Map<String, dynamic>>[];
      final batchConvIDs = <String>[];
      final updatedConvIDs = <String>{};

      for (final entry in needSyncSeqs.entries) {
        seqRanges.add({
          'conversationID': entry.key,
          'begin': entry.value[0],
          'end': entry.value[1],
          'num': connectPullNums,
        });
        batchConvIDs.add(entry.key);

        if (seqRanges.length >= splitPullMsgNum) {
          await _pullAndStoreMsgs(List.from(seqRanges), List.from(batchConvIDs), updatedConvIDs);
          seqRanges.clear();
          batchConvIDs.clear();
        }
      }

      // 处理剩余
      if (seqRanges.isNotEmpty) {
        await _pullAndStoreMsgs(seqRanges, batchConvIDs, updatedConvIDs);
      }

      // 同步完成后通知 UI 刷新（latestMsg 已更新）
      if (updatedConvIDs.isNotEmpty) {
        _fireConversationChanged(updatedConvIDs);
      }

      _log.info('消息同步完成，共处理 ${needSyncSeqs.length} 个会话', methodName: '_syncMessages');
    } catch (e, s) {
      _log.error('同步消息异常: $e', error: e, stackTrace: s, methodName: '_syncMessages');
    }
  }

  /// 通过 HTTP API 拉取消息并存储到本地
  Future<void> _pullAndStoreMsgs(
    List<Map<String, dynamic>> seqRanges,
    List<String> convIDs,
    Set<String> updatedConvIDs,
  ) async {
    _log.info('called', methodName: '_pullAndStoreMsgs');
    try {
      final resp = await api.pullMsgBySeqs(
        userID: _userID,
        seqRanges: seqRanges,
        order: 1, // 降序，拉最新的
      );
      if (resp.errCode != 0) {
        _log.error('拉取消息失败: ${resp.errMsg}', methodName: '_pullAndStoreMsgs');
        return;
      }
      final data = resp.data as Map<String, dynamic>? ?? {};
      // 处理普通消息（对应 Go SDK triggerConversation / triggerReinstallConversation）
      await _processPulledMsgs(data['msgs'] as Map<String, dynamic>? ?? {}, updatedConvIDs);
      // 处理通知消息（对应 Go SDK triggerNotification）
      await _processPulledNotifications(data['notificationMsgs'] as Map<String, dynamic>? ?? {});
    } catch (e, s) {
      _log.error('拉取消息批次失败: $e', error: e, stackTrace: s, methodName: '_pullAndStoreMsgs');
    }
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
        Map<String, dynamic>? latestMsg;
        int maxSeq = 0;
        int latestSendTime = 0;

        for (final msg in msgList) {
          if (msg is Map<String, dynamic>) {
            _decodeContentIfBase64(msg);

            final contentType = (msg['contentType'] as num?)?.toInt() ?? 0;
            final seq = (msg['seq'] as num?)?.toInt() ?? 0;
            final sendTime = (msg['sendTime'] as num?)?.toInt() ?? 0;

            if (seq > maxSeq) maxSeq = seq;

            // 通知消息（contentType >= 1000）：路由到通知分发器
            // 对应 Go SDK doMsgNew 中的 doNotification 分支
            // 重装时跳过：好友/群组等已通过 _syncFriends/_syncJoinedGroups 全量同步
            // 避免数百条 1201 等通知逐条触发回调（对应 Go SDK doMsgSyncByReinstalled 行为）
            if (contentType >= 1000 && !_reinstalled) {
              final content = msg['content'] as String? ?? '';
              notificationDispatcher.dispatch(contentType, content);
            }

            // Go SDK 在 triggerConversation 中存储所有消息（含通知），
            // 通知/普通分流在 conversation 层（n_ 前缀）而非 contentType 层。
            // data['msgs'] 只包含普通会话消息，所以全部存入 chatLog。
            msgMaps.add(msg);

            // 任何消息都可以作为 latestMsg（对应 Go SDK doMsgSyncByReinstalled 行为）
            // Go SDK 在重装时会将所有消息（含通知）都设为 latestMsg
            if (sendTime >= latestSendTime) {
              latestSendTime = sendTime;
              latestMsg = msg;
            }
          }
        }

        // 批量存入消息表（注入 conversationID 以支持单条件查询）
        if (msgMaps.isNotEmpty) {
          for (final m in msgMaps) {
            m['conversationID'] = convID;
            // 云端拉取的消息默认为已成功发送状态
            // （protobuf status 默认为 0，MessageStatus.fromValue(0) 会 fallback 为 failed）
            final rawStatus = m['status'];
            if (rawStatus == null || rawStatus == 0) {
              m['status'] = MessageStatus.succeeded.value;
            }
          }
          await database.batchInsertMessages(msgMaps);
        }

        // 更新会话的 latestMsg、latestMsgSendTime 和 maxSeq
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
          // 只有被删除的消息，仍需更新 maxSeq
          await database.updateConversation(convID, {'maxSeq': maxSeq});
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

  /// 处理拉取到的通知消息：路由到通知分发器
  ///
  /// 对应 Go SDK 的 triggerNotification，将 notificationMsgs 中的
  /// 通知消息分发给 NotificationDispatcher 进行处理（好友/群组/会话变更等）。
  Future<void> _processPulledNotifications(Map<String, dynamic> msgsByConv) async {
    _log.info('called', methodName: '_processPulledNotifications');
    try {
      for (final entry in msgsByConv.entries) {
        final convID = entry.key;
        final pullMsgs = entry.value as Map<String, dynamic>? ?? {};
        final msgList = (pullMsgs['Msgs'] ?? pullMsgs['msgs']) as List? ?? [];

        for (final msg in msgList) {
          if (msg is Map<String, dynamic>) {
            _decodeContentIfBase64(msg);
            final contentType = (msg['contentType'] as num?)?.toInt() ?? 0;
            final content = msg['content'] as String? ?? '';
            final seq = (msg['seq'] as num?)?.toInt() ?? 0;
            if (contentType >= 1000) {
              notificationDispatcher.dispatch(contentType, content);
            }
            if (seq > 0 && seq > (_syncedMaxSeqs[convID] ?? 0)) {
              _syncedMaxSeqs[convID] = seq;
              database.updateConversation(convID, {'maxSeq': seq});
            }
          }
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

  /// 同步自身用户信息
  Future<void> _syncSelfUserInfo() async {
    _log.info('called', methodName: '_syncSelfUserInfo');
    try {
      final resp = await api.getUsersInfo(userIDs: [_userID]);
      if (resp.errCode != 0) return;
      final users = resp.data?['usersInfo'] as List? ?? [];
      if (users.isNotEmpty && users.first is Map<String, dynamic>) {
        await database.upsertUser(users.first as Map<String, dynamic>);
      }
    } catch (e, s) {
      _log.error('同步自身用户信息异常: $e', error: e, stackTrace: s, methodName: '_syncSelfUserInfo');
    }
  }

  // ---------------------------------------------------------------------------
  // 推送消息处理
  // ---------------------------------------------------------------------------

  /// 处理来自 WebSocket 的推送消息
  ///
  /// 对应 Go SDK 的 doPushMsg：
  /// 1. 解析推送体中的 msgs 和 notificationMsgs（protobuf 解码）
  /// 2. 验证 SEQ 连续性，发现缺口时触发同步
  /// 3. 存储消息并更新会话（latestMsg, unreadCount, maxSeq）
  /// 4. 触发回调通知上层
  void handlePushMsg(WebSocketResponse resp) {
    _log.info('called', methodName: 'handlePushMsg');
    if (resp.data.isEmpty) return;

    try {
      // resp.data 是 base64 解码后的 protobuf 字节（PushMessages）
      final pushMessages = sdkws.PushMessages.fromBuffer(resp.data);

      // 收集需要检测 SEQ 缺口的会话
      final gapConvIDs = <String>{};

      // 按 conversationID 聚合的会话更新信息
      final convUpdates = <String, ConvBatchUpdate>{};

      // 处理普通消息
      for (final entry in pushMessages.msgs.entries) {
        final convID = entry.key;
        final pullMsgs = entry.value;
        final msgList = pullMsgs.msgs;
        if (msgList.isEmpty) continue;

        // 检测 SEQ 连续性（对应 Go SDK pushTriggerAndSync）
        final localMaxSeq = _syncedMaxSeqs[convID] ?? 0;
        int batchMaxSeq = 0;
        int batchMinSeq = 0;
        for (final msg in msgList) {
          final seq = msg.seq.toInt();
          if (seq > 0) {
            if (batchMinSeq == 0 || seq < batchMinSeq) batchMinSeq = seq;
            if (seq > batchMaxSeq) batchMaxSeq = seq;
          }
        }

        // SEQ 连续性校验
        if (batchMinSeq > localMaxSeq + 1 && localMaxSeq > 0) {
          _log.warning(
            '检测到 SEQ 缺口: conv=$convID, local=$localMaxSeq, '
            'pushMin=$batchMinSeq, pushMax=$batchMaxSeq',
            methodName: 'handlePushMsg',
          );
          gapConvIDs.add(convID);
        }

        // 处理每条消息，聚合到 convUpdates
        for (final msg in msgList) {
          final msgMap = _msgDataToMap(msg);
          _collectMessageUpdate(msgMap, convID, convUpdates);
        }
      }

      // 处理通知消息
      for (final entry in pushMessages.notificationMsgs.entries) {
        final convID = entry.key;
        final pullMsgs = entry.value;
        for (final msg in pullMsgs.msgs) {
          final msgMap = _msgDataToMap(msg);
          _processNotificationMessage(msgMap, convID);
        }
      }

      // 批量写入会话更新 + 触发缺口同步和 UI 通知
      _applyBatchUpdatesAndNotify(convUpdates, gapConvIDs);
    } catch (e, s) {
      _log.error('处理推送消息失败: $e', error: e, stackTrace: s, methodName: 'handlePushMsg');
    }
  }

  /// 将 protobuf MsgData 转为 [Map<String, dynamic>]（供数据库和回调使用）
  Map<String, dynamic> _msgDataToMap(sdkws.MsgData msg) {
    try {
      return {
        'sendID': msg.sendID,
        'recvID': msg.recvID,
        'groupID': msg.groupID,
        'clientMsgID': msg.clientMsgID,
        'serverMsgID': msg.serverMsgID,
        'senderPlatformID': msg.senderPlatformID,
        'senderNickname': msg.senderNickname,
        'senderFaceURL': msg.senderFaceURL,
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
    } catch (e, s) {
      _log.error('转换MsgData失败: $e', error: e, stackTrace: s, methodName: '_msgDataToMap');
      throw Exception('MsgDataToMap failed');
    }
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
      // protobuf status 默认为 0，需设为 succeeded
      final msgToInsert = {...msg, 'conversationID': conversationID};
      final rawStatus = msgToInsert['status'];
      if (rawStatus == null || rawStatus == 0) {
        msgToInsert['status'] = MessageStatus.succeeded.value;
      }
      database.insertMessage(msgToInsert);

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
      _fireNewMessage(msg);
    } catch (e, s) {
      _log.error('收集消息更新失败: $e', error: e, stackTrace: s, methodName: '_collectMessageUpdate');
    }
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
        final existing = await database.getConversation(convID);
        if (existing != null) {
          // 更新已有会话
          final updates = <String, dynamic>{};
          final existingLatestTime = existing.latestMsgSendTime ?? 0;
          if (update.latestMsgSendTime >= existingLatestTime) {
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

    // 缺口同步
    if (gapConvIDs.isNotEmpty) {
      _syncMissingMessages(gapConvIDs);
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
          final remark = friend.remark ?? '';
          updates['showName'] = remark.isNotEmpty ? remark : (friend.nickname ?? '');
          updates['faceURL'] = friend.faceURL ?? '';
        } else {
          // 从用户表查
          final users = await database.getUsersByIDs([userID]);
          if (users.isNotEmpty) {
            updates['showName'] = users.first.nickname ?? '';
            updates['faceURL'] = users.first.faceURL ?? '';
          }
        }
      } else if (sessionType == 3 && groupID != null && groupID.isNotEmpty) {
        // 群聊：用群组名称
        final group = await database.getGroupByID(groupID);
        if (group != null) {
          updates['showName'] = group.groupName ?? '';
          updates['faceURL'] = group.faceURL ?? '';
        }
      }

      if (updates.isNotEmpty) {
        await database.updateConversation(conversationID, updates);
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
  void _processNotificationMessage(Map<String, dynamic> msg, String conversationID) {
    try {
      final seq = msg['seq'] as int? ?? 0;
      final contentType = msg['contentType'] as int? ?? 0;

      // 更新 seq
      if (seq > 0 && seq > (_syncedMaxSeqs[conversationID] ?? 0)) {
        _syncedMaxSeqs[conversationID] = seq;
        database.updateConversation(conversationID, {'maxSeq': seq});
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

  /// 检测并同步 SEQ 缺口（对应 Go SDK compareSeqsAndBatchSync 的部分逻辑）
  Future<void> _syncMissingMessages(Set<String> convIDs) async {
    _log.info('called', methodName: '_syncMissingMessages');
    try {
      // 获取这些会话的服务端最新 maxSeq
      final seqRanges = <Map<String, dynamic>>[];
      for (final convID in convIDs) {
        final localMax = _syncedMaxSeqs[convID] ?? 0;
        // 向服务端请求该会话的 maxSeq → 拉取缺失区间
        // 简化实现：拉取 localMax+1 到 localMax+200 的消息
        seqRanges.add({'conversationID': convID, 'begin': localMax + 1, 'end': localMax + 200});
      }

      if (seqRanges.isNotEmpty) {
        final updatedConvIDs = <String>{};
        await _pullAndStoreMsgs(seqRanges, convIDs.toList(), updatedConvIDs);
        if (updatedConvIDs.isNotEmpty) {
          _fireConversationChanged(updatedConvIDs);
        }
        _log.info('缺口同步完成: ${convIDs.length} 个会话', methodName: '_syncMissingMessages');
      }
    } catch (e, s) {
      _log.error('缺口同步失败: $e', error: e, stackTrace: s, methodName: '_syncMissingMessages');
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
    msgListener?.recvNewMessage(message);
    listenerForService?.recvNewMessage(message);
  }

  /// 仅在线消息：不存储到本地，仅触发 onRecvOnlineOnlyMessage
  void _fireOnlineOnlyMessage(Map<String, dynamic> msg) {
    final message = convertMessage(msg);
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
