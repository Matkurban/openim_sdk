import '../../api/friend_api.dart';
import '../../core/base_syncer.dart';
import '../../db/db_engine.dart';
import '../../models/api_response.dart';
import '../../models/conversation_info.dart';
import '../../models/user_info.dart';
import '../../utils/open_im_utils.dart';

/// 好友增量/全量同步器（继承 [BaseSyncer]），供启动同步与好友通知共用。
final class FriendSyncer extends BaseSyncer {
  final DbEngine db;
  final FriendApi friendApi;
  final void Function(FriendInfo info)? onFriendInfoChanged;
  final void Function(List<ConversationInfo> conversations)? onConversationChanged;

  FriendSyncer({
    required this.db,
    required this.friendApi,
    this.onFriendInfoChanged,
    this.onConversationChanged,
  }) : super('FriendSyncer');

  @override
  String get syncTableName => 'friends';

  @override
  Future<({int version, String versionID})> readLocalVersion(String entityID) async {
    final Map<String, dynamic>? row = await db.syncMeta.getVersionSync(syncTableName, entityID);
    return (
      version: (row?['version'] as num?)?.toInt() ?? 0,
      versionID: row?['versionID']?.toString() ?? '',
    );
  }

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

  @override
  Future<IncrementalSyncResponse?> fetchIncremental({
    required String entityID,
    required int version,
    required String versionID,
  }) async {
    final ApiResponse resp = await friendApi.getIncrementalFriends(
      req: <String, dynamic>{'userID': entityID, 'version': version, 'versionID': versionID},
    );
    if (resp.errCode != 0) {
      logger.warning('getIncrementalFriends failed: ${resp.errMsg}');
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

  @override
  Future<void> applyIncremental({
    required String entityID,
    required List<String> deleteIDs,
    required List<Map<String, dynamic>> insertItems,
    required List<Map<String, dynamic>> updateItems,
  }) async {
    for (final String id in deleteIDs) {
      await db.friends.deleteFriend(id);
    }

    if (insertItems.isNotEmpty) {
      final List<Map<String, dynamic>> normalized = insertItems
          .map<Map<String, dynamic>>(
            (Map<String, dynamic> item) => _normalizeRecord(entityID, item),
          )
          .toList();
      await db.friends.batchUpsertFriends(normalized);
    }

    for (final Map<String, dynamic> item in updateItems) {
      final Map<String, dynamic> record = _normalizeRecord(entityID, item);
      final String? friendUserID = record['friendUserID']?.toString();
      if (friendUserID == null || friendUserID.isEmpty) {
        continue;
      }
      await db.friends.updateFriend(friendUserID, <String, dynamic>{
        'nickname': record['nickname'],
        'faceURL': record['faceURL'],
        'remark': record['remark'],
        'ex': record['ex'],
        'addSource': record['addSource'],
        'operatorUserID': record['operatorUserID'],
        'isPinned': record['isPinned'],
      });
      await _propagateFriendDisplayUpdate(entityID, record);
    }
  }

  @override
  Future<void> syncFull(String entityID) async {
    final List<FriendInfo> oldFriends = await db.friends.getAllFriends();
    final Map<String, FriendInfo> localMap = <String, FriendInfo>{
      for (final FriendInfo f in oldFriends)
        if (f.friendUserID != null) f.friendUserID!: f,
    };

    int pageNumber = 1;
    const int pageSize = 100;
    final List<Map<String, dynamic>> allServerFriends = <Map<String, dynamic>>[];
    while (true) {
      final ApiResponse resp = await friendApi.getFriendList(
        userID: entityID,
        offset: (pageNumber - 1) * pageSize,
        count: pageSize,
      );
      if (resp.errCode != 0) {
        break;
      }
      final List<dynamic> friends =
          resp.data?['friendsInfo'] as List<dynamic>? ?? const <dynamic>[];
      if (friends.isEmpty) {
        break;
      }
      for (final dynamic f in friends) {
        if (f is Map<String, dynamic>) {
          allServerFriends.add(_normalizeRecord(entityID, f));
        }
      }
      if (friends.length < pageSize) {
        break;
      }
      pageNumber++;
    }

    final Set<String> serverIDs = <String>{};
    final List<Map<String, dynamic>> toInsert = <Map<String, dynamic>>[];

    for (final Map<String, dynamic> record in allServerFriends) {
      final String? friendUserID = record['friendUserID']?.toString();
      if (friendUserID == null || friendUserID.isEmpty) {
        continue;
      }
      serverIDs.add(friendUserID);
      final FriendInfo? local = localMap[friendUserID];
      if (local == null) {
        toInsert.add(record);
        continue;
      }
      final bool changed =
          (record['nickname']?.toString() ?? '') != (local.nickname ?? '') ||
          (record['faceURL']?.toString() ?? '') != (local.faceURL ?? '') ||
          (record['remark']?.toString() ?? '') != (local.remark ?? '');
      if (changed) {
        await db.friends.updateFriend(friendUserID, <String, dynamic>{
          'nickname': record['nickname'],
          'faceURL': record['faceURL'],
          'remark': record['remark'],
          'ex': record['ex'],
          'addSource': record['addSource'],
          'operatorUserID': record['operatorUserID'],
          'isPinned': record['isPinned'],
        });
        await _propagateFriendDisplayUpdate(entityID, record);
      }
    }

    if (toInsert.isNotEmpty) {
      await db.friends.batchUpsertFriends(toInsert);
    }
    for (final FriendInfo local in oldFriends) {
      if (local.friendUserID != null && !serverIDs.contains(local.friendUserID)) {
        await db.friends.deleteFriend(local.friendUserID!);
      }
    }
    logger.info('syncFull completed: ${allServerFriends.length} friends');
  }

  /// 同步黑名单列表。
  Future<void> syncBlackList(String userID) async {
    final ApiResponse resp = await friendApi.getBlackList(userID: userID);
    if (resp.errCode != 0) {
      return;
    }
    final List<dynamic> rawBlacks = resp.data?['blacks'] as List<dynamic>? ?? const <dynamic>[];
    final List<Map<String, dynamic>> normalized = <Map<String, dynamic>>[];
    for (final dynamic item in rawBlacks) {
      if (item is Map<String, dynamic>) {
        final Map<String, dynamic> blackUser =
            item['blackUserInfo'] as Map<String, dynamic>? ?? const <String, dynamic>{};
        normalized.add(<String, dynamic>{
          'ownerUserID': item['ownerUserID'] ?? userID,
          'blockUserID': blackUser['userID'] ?? item['blockUserID'] ?? item['userID'],
          'userID': blackUser['userID'] ?? item['userID'],
          'nickname': blackUser['nickname'] ?? item['nickname'],
          'faceURL': blackUser['faceURL'] ?? item['faceURL'],
          'createTime': item['createTime'],
          'addSource': item['addSource'],
          'operatorUserID': item['operatorUserID'],
          'ex': item['ex'],
        });
      }
    }
    await db.friends.batchUpsertBlacks(normalized);
  }

  Map<String, dynamic> _normalizeRecord(String ownerUserID, Map<String, dynamic> item) {
    final Map<String, dynamic> friendUser =
        item['friendUser'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    return <String, dynamic>{
      'friendUserID': friendUser['userID'] ?? item['friendUserID'] ?? item['userID'],
      'ownerUserID': item['ownerUserID'] ?? ownerUserID,
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

  Future<void> _propagateFriendDisplayUpdate(String selfUserID, Map<String, dynamic> record) async {
    final String friendUserID = record['friendUserID']?.toString() ?? '';
    if (friendUserID.isEmpty) {
      return;
    }
    final FriendInfo updated = FriendInfo(
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
    onFriendInfoChanged?.call(updated);

    final String showName = updated.getShowName();
    final String convID = OpenImUtils.genSingleConversationID(selfUserID, friendUserID);
    final ConversationInfo? conv = await db.conversations.getConversation(convID);
    if (conv != null) {
      final Map<String, dynamic> convUpdates = <String, dynamic>{'showName': showName};
      if (updated.faceURL != null) {
        convUpdates['faceURL'] = updated.faceURL;
      }
      await db.conversations.updateConversation(convID, convUpdates);
      final ConversationInfo? refreshed = await db.conversations.getConversation(convID);
      if (refreshed != null) {
        onConversationChanged?.call(<ConversationInfo>[refreshed]);
      }
    }
    await db.messages.updateSingleChatMessageSenderInfo(
      friendUserID,
      senderNickname: showName,
      senderFaceUrl: updated.faceURL,
    );
  }
}
