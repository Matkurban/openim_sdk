import 'dart:convert';

import '../../api/conversation_api.dart';
import '../../api/group_api.dart';
import '../../api/message_api.dart';
import '../../api/user_api.dart';
import '../../core/base_syncer.dart';
import '../../db/db_engine.dart';
import '../../models/api_response.dart';
import '../../models/conversation_info.dart';
import '../../models/group_info.dart';
import '../../models/user_info.dart';

/// 会话增量/全量同步与 Seq/未读水位同步器（继承 [BaseSyncer]）。
///
/// 使用 `db.conversations.batchUpdateConversations` 替代原 50 次循环单行更新，
/// 并复用 `db.conversations.getTotalUnreadCount()`（修复 B-27）。
final class ConversationSyncer extends BaseSyncer {
  /// 数据库。
  ///
  /// Database.
  final DbEngine db;

  /// 会话API。
  ///
  /// Conversation API.
  final ConversationApi conversationApi;

  /// 消息API。
  ///
  /// Message API.
  final MessageApi messageApi;

  /// 用户API。
  ///
  /// User API.
  final UserApi userApi;

  /// 群组API。
  ///
  /// Group API.
  final GroupApi groupApi;

  /// on会话Changed。
  ///
  /// On conversation changed.
  final void Function(List<ConversationInfo> conversations)? onConversationChanged;

  /// on总计未读Changed。
  ///
  /// On total unread changed.
  final void Function(int totalUnread)? onTotalUnreadChanged;

  bool _reinstalled = false;

  /// 服务端最大序列号列表。
  ///
  /// Server maximum sequence numbers.
  final Map<String, int> serverMaxSeqs = <String, int>{};

  /// 创建 `ConversationSyncer` 实例。
  ///
  /// Creates a `ConversationSyncer` instance.
  ///
  /// - [db] 数据库 / Database.
  /// - [conversationApi] 会话API / Conversation API.
  /// - [messageApi] 消息API / Message API.
  /// - [userApi] 用户API / User API.
  /// - [groupApi] 群组API / Group API.
  /// - [onConversationChanged] on会话Changed / On conversation changed.
  /// - [onTotalUnreadChanged] on总计未读Changed / On total unread changed.
  ConversationSyncer({
    required this.db,
    required this.conversationApi,
    required this.messageApi,
    required this.userApi,
    required this.groupApi,
    this.onConversationChanged,
    this.onTotalUnreadChanged,
  }) : super('ConversationSyncer');

  /// 同步数据表名称。
  ///
  /// Sync table name.
  @override
  String get syncTableName => 'conversations';

  /// 同步会话结构及所有会话的 `maxSeq` / `hasReadSeq`。
  ///
  /// - [userID] 用户ID / User ID.
  /// - [reinstalled] 是否重装 / Whether reinstalled.
  Future<void> syncConversationsAndSeqs(String userID, {required bool reinstalled}) async {
    _reinstalled = reinstalled;
    await sync(userID, forceFull: reinstalled);
    await _syncSeqsAndUnread(userID, reinstalled: reinstalled);
  }

  /// 读取本地版本。
  ///
  /// Read local version.
  ///
  /// - [entityID] 实体ID / Entity ID.
  /// - Returns: `Future<({int version, String versionID})>` 结果 / Resulting `Future<({int version, String versionID})>`.
  @override
  Future<({int version, String versionID})> readLocalVersion(String entityID) async {
    final Map<String, dynamic>? row = await db.syncMeta.getVersionSync(syncTableName, entityID);
    return (
      version: (row?['version'] as num?)?.toInt() ?? 0,
      versionID: row?['versionID']?.toString() ?? '',
    );
  }

  /// 保存本地版本。
  ///
  /// Save local version.
  ///
  /// - [entityID] 实体ID / Entity ID.
  /// - [version] 版本 / Version.
  /// - [versionID] 版本ID / Version ID.
  @override
  Future<void> saveLocalVersion(
    String entityID, {
    required int version,
    required String versionID,
  }) async {
    await db.syncMeta.setVersionSync(
      tableName: syncTableName,
      entityID: entityID,
      versionID: versionID,
      version: version,
      uidList: const <String>[],
    );
  }

  /// 拉取增量。
  ///
  /// Fetch incremental.
  ///
  /// - [entityID] 实体ID / Entity ID.
  /// - [version] 版本 / Version.
  /// - [versionID] 版本ID / Version ID.
  /// - Returns: `Future<IncrementalSyncResponse?>` 结果 / Resulting `Future<IncrementalSyncResponse?>`.
  @override
  Future<IncrementalSyncResponse?> fetchIncremental({
    required String entityID,
    required int version,
    required String versionID,
  }) async {
    final ApiResponse resp = await conversationApi.getIncrementalConversation(
      req: <String, dynamic>{'userID': entityID, 'version': version, 'versionID': versionID},
    );
    if (resp.errCode != 0) {
      logger.warning('getIncrementalConversation failed: ${resp.errMsg}, falling back to full');
      await syncFull(entityID);
      return null;
    }
    final Map<String, dynamic> data = resp.data as Map<String, dynamic>? ?? <String, dynamic>{};
    return IncrementalSyncResponse(
      isFull: data['full'] as bool? ?? false,
      versionID: data['versionID']?.toString() ?? versionID,
      version: (data['version'] as num?)?.toInt() ?? version,
      deleteIDs: (data['delete'] as List<dynamic>?)?.cast<String>() ?? const <String>[],
      insertItems: ((data['insert'] as List<dynamic>?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .toList(),
      updateItems: ((data['update'] as List<dynamic>?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .toList(),
    );
  }

  /// apply增量。
  ///
  /// Apply incremental.
  ///
  /// - [entityID] 实体ID / Entity ID.
  /// - [deleteIDs] 删除ID 列表 / Delete i ds.
  /// - [insertItems] 插入Items / Insert items.
  /// - [updateItems] 更新Items / Update items.
  @override
  Future<void> applyIncremental({
    required String entityID,
    required List<String> deleteIDs,
    required List<Map<String, dynamic>> insertItems,
    required List<Map<String, dynamic>> updateItems,
  }) async {
    for (final String convID in deleteIDs) {
      await db.conversations.deleteConversation(convID);
    }

    if (insertItems.isNotEmpty) {
      final List<Map<String, dynamic>> toInsert = insertItems
          .map<Map<String, dynamic>>(_normalizeConvRow)
          .toList();
      await batchFillShowNameAndFaceURL(toInsert);
      await db.conversations.batchUpsertConversations(toInsert);
    }

    if (updateItems.isNotEmpty) {
      final List<Map<String, dynamic>> toUpdate = updateItems
          .map<Map<String, dynamic>>(_normalizeConvRow)
          .toList();
      await db.conversations.batchUpsertConversations(toUpdate);
      final List<String> ids = toUpdate
          .map<String?>((Map<String, dynamic> m) => m['conversationID'] as String?)
          .whereType<String>()
          .toList();
      final List<ConversationInfo> refreshed = await db.conversations.getMultipleConversations(ids);
      if (refreshed.isNotEmpty) {
        onConversationChanged?.call(refreshed);
      }
      await fireTotalUnreadChanged();
    }
  }

  /// 同步全量。
  ///
  /// Sync full.
  ///
  /// - [entityID] 实体ID / Entity ID.
  @override
  Future<void> syncFull(String entityID) async {
    final ApiResponse resp = await conversationApi.getAllConversations(ownerUserID: entityID);
    if (resp.errCode != 0) {
      return;
    }
    final List<dynamic> rawList =
        resp.data?['conversations'] as List<dynamic>? ?? const <dynamic>[];
    if (rawList.isEmpty) {
      return;
    }

    final List<Map<String, dynamic>> convMaps = <Map<String, dynamic>>[];
    for (final dynamic item in rawList) {
      if (item is Map<String, dynamic>) {
        final int? convType = (item['conversationType'] as num?)?.toInt();
        final String? uid = item['userID'] as String?;
        if (convType == 1 && uid == entityID) {
          continue;
        }
        convMaps.add(_normalizeConvRow(item));
      }
    }

    await batchFillShowNameAndFaceURL(convMaps);

    final ApiResponse seqResp = await messageApi.getConversationsHasReadAndMaxSeq(
      userID: entityID,
      conversationIDs: const <String>[],
    );
    final Map<String, dynamic> serverSeqs = seqResp.errCode == 0
        ? (seqResp.data?['seqs'] as Map<String, dynamic>? ?? <String, dynamic>{})
        : <String, dynamic>{};

    final List<ConversationInfo> localBefore = await db.conversations.getAllConversations();
    final Map<String, int> localUnreadByID = <String, int>{
      for (final ConversationInfo c in localBefore) c.conversationID: c.unreadCount,
    };

    for (final Map<String, dynamic> conv in convMaps) {
      final String? convID = conv['conversationID'] as String?;
      if (convID == null) {
        continue;
      }
      final dynamic seqInfo = serverSeqs[convID];
      if (seqInfo is Map<String, dynamic>) {
        final int maxSeq = (seqInfo['maxSeq'] as num?)?.toInt() ?? 0;
        final int hasReadSeq = (seqInfo['hasReadSeq'] as num?)?.toInt() ?? 0;
        final int? localUnread = localUnreadByID[convID];
        if (_reinstalled || localUnread == null) {
          conv['unreadCount'] = (maxSeq - hasReadSeq).clamp(0, maxSeq);
        } else {
          conv['unreadCount'] = localUnread;
        }
        conv['maxSeq'] = maxSeq;
        conv['hasReadSeq'] = hasReadSeq;
        serverMaxSeqs[convID] = maxSeq;
      }
    }

    if (convMaps.isNotEmpty) {
      await db.conversations.batchUpsertConversations(convMaps);
    }
    await db.syncMeta.deleteVersionSync(syncTableName, entityID);
    logger.info('syncFull completed: ${convMaps.length} conversations');
  }

  Future<void> _syncSeqsAndUnread(String userID, {required bool reinstalled}) async {
    final List<ConversationInfo> localConvs = await db.conversations.getAllConversations();
    final List<String> localConvIDs = localConvs
        .map<String>((ConversationInfo c) => c.conversationID)
        .toList();
    final Map<String, int> localHasReadSeqs = await db.conversations
        .getAllConversationHasReadSeqs();

    final ApiResponse seqResp = await messageApi.getConversationsHasReadAndMaxSeq(
      userID: userID,
      conversationIDs: const <String>[],
    );
    if (seqResp.errCode != 0) {
      return;
    }
    final Map<String, dynamic> serverSeqs =
        seqResp.data?['seqs'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final List<Map<String, dynamic>> batchUpdates = <Map<String, dynamic>>[];
    for (final String convID in localConvIDs) {
      final dynamic seqInfo = serverSeqs[convID];
      if (seqInfo is Map<String, dynamic>) {
        final int maxSeq = (seqInfo['maxSeq'] as num?)?.toInt() ?? 0;
        final int serverHasReadSeq = (seqInfo['hasReadSeq'] as num?)?.toInt() ?? 0;
        final int localHasReadSeq = localHasReadSeqs[convID] ?? 0;
        final int effectiveHasReadSeq = localHasReadSeq > serverHasReadSeq
            ? localHasReadSeq
            : serverHasReadSeq;
        serverMaxSeqs[convID] = maxSeq;
        final Map<String, dynamic> row = <String, dynamic>{
          'conversationID': convID,
          'maxSeq': maxSeq,
          'hasReadSeq': effectiveHasReadSeq,
        };
        if (reinstalled) {
          row['unreadCount'] = (maxSeq - effectiveHasReadSeq).clamp(0, maxSeq);
        }
        batchUpdates.add(row);
      }
    }

    if (batchUpdates.isNotEmpty) {
      await db.conversations.batchUpdateConversations(batchUpdates);
    }
    await fireTotalUnreadChanged();
  }

  /// 批量为会话填充 `showName` 与 `faceURL`。
  ///
  /// - [conversations] 会话列表 / Conversations.
  Future<void> batchFillShowNameAndFaceURL(List<Map<String, dynamic>> conversations) async {
    final Set<String> userIDs = <String>{};
    final Set<String> groupIDs = <String>{};

    for (final Map<String, dynamic> conv in conversations) {
      final int? type = (conv['conversationType'] as num?)?.toInt();
      if (type == 1 || type == 4) {
        final String? uid = conv['userID'] as String?;
        if (uid != null && uid.isNotEmpty) {
          userIDs.add(uid);
        }
      } else if (type == 2 || type == 3) {
        final String? gid = conv['groupID'] as String?;
        if (gid != null && gid.isNotEmpty) {
          groupIDs.add(gid);
        }
      }
    }

    final Map<String, FriendInfo> friendMap = <String, FriendInfo>{};
    if (userIDs.isNotEmpty) {
      final List<FriendInfo> friends = await db.friends.getFriendsByUserIDs(userIDs.toList());
      for (final FriendInfo f in friends) {
        if (f.friendUserID != null) {
          friendMap[f.friendUserID!] = f;
        }
      }
    }

    final Map<String, UserInfo> userMap = <String, UserInfo>{};
    final List<String> missingFromFriends = userIDs
        .where((String id) => !friendMap.containsKey(id))
        .toList();
    if (missingFromFriends.isNotEmpty) {
      final List<UserInfo> cachedUsers = await db.users.getUsersByIDs(missingFromFriends);
      for (final UserInfo u in cachedUsers) {
        userMap[u.userID] = u;
      }
      final List<String> missingFromDb = missingFromFriends
          .where((String id) => !userMap.containsKey(id))
          .toList();
      if (missingFromDb.isNotEmpty) {
        final ApiResponse resp = await userApi.getUsersInfo(userIDs: missingFromDb);
        if (resp.errCode == 0) {
          final List<dynamic> netUsers =
              resp.data?['usersInfo'] as List<dynamic>? ?? const <dynamic>[];
          final List<Map<String, dynamic>> toCache = <Map<String, dynamic>>[];
          for (final dynamic u in netUsers) {
            if (u is Map<String, dynamic>) {
              final String? uid = u['userID'] as String?;
              if (uid != null) {
                userMap[uid] = UserInfo.fromJson(u);
                toCache.add(u);
              }
            }
          }
          if (toCache.isNotEmpty) {
            await db.users.upsertUsers(toCache);
          }
        }
      }
    }

    final Map<String, GroupInfo> groupMap = <String, GroupInfo>{};
    if (groupIDs.isNotEmpty) {
      final List<GroupInfo> cachedGroups = await db.groups.getGroupsByIDs(groupIDs.toList());
      for (final GroupInfo g in cachedGroups) {
        groupMap[g.groupID] = g;
      }
      final List<String> missingGroups = groupIDs
          .where((String id) => !groupMap.containsKey(id))
          .toList();
      if (missingGroups.isNotEmpty) {
        final ApiResponse resp = await groupApi.getGroupsInfo(groupIDs: missingGroups);
        if (resp.errCode == 0) {
          final List<dynamic> netGroups =
              resp.data?['groupInfos'] as List<dynamic>? ?? const <dynamic>[];
          final List<Map<String, dynamic>> toCache = <Map<String, dynamic>>[];
          for (final dynamic g in netGroups) {
            if (g is Map<String, dynamic>) {
              final String? gid = g['groupID'] as String?;
              if (gid != null) {
                groupMap[gid] = GroupInfo.fromJson(g);
                toCache.add(g);
              }
            }
          }
          if (toCache.isNotEmpty) {
            await db.groups.batchUpsertGroups(toCache);
          }
        }
      }
    }

    for (final Map<String, dynamic> conv in conversations) {
      final int? type = (conv['conversationType'] as num?)?.toInt();
      if (type == 1 || type == 4) {
        final String uid = conv['userID'] as String? ?? '';
        final FriendInfo? friend = friendMap[uid];
        if (friend != null) {
          conv['showName'] = friend.getShowName();
          conv['faceURL'] = friend.faceURL ?? '';
        } else {
          final UserInfo? user = userMap[uid];
          if (user != null) {
            conv['showName'] = user.getShowName();
            conv['faceURL'] = user.faceURL ?? '';
          }
        }
      } else if (type == 2 || type == 3) {
        final String gid = conv['groupID'] as String? ?? '';
        final GroupInfo? group = groupMap[gid];
        if (group != null) {
          conv['showName'] = group.groupName ?? '';
          conv['faceURL'] = group.faceURL ?? '';
        }
      }
    }
  }

  /// fire总计未读Changed。
  ///
  /// Fire total unread changed.
  Future<void> fireTotalUnreadChanged() async {
    final int total = await db.conversations.getTotalUnreadCount();
    onTotalUnreadChanged?.call(total);
  }

  Map<String, dynamic> _normalizeConvRow(Map<String, dynamic> item) {
    final Map<String, dynamic> map = Map<String, dynamic>.from(item);
    if (map['latestMsg'] is Map<dynamic, dynamic>) {
      map['latestMsg'] = jsonEncode(map['latestMsg']);
    }
    return map;
  }
}
