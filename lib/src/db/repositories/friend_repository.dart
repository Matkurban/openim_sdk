import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../../models/user_info.dart';
import '../db_schema.dart';

/// 好友、好友申请与黑名单领域仓储。
///
/// 使用确定性复合主键 `id = '${ownerUserID}_$blockUserID'` / `'${fromUserID}_$toUserID'`，
/// 彻底移除历史 ToStore 3.0.8 全表扫描绕过代码。
final class FriendRepository extends BaseRepository<FriendInfo> {
  String _currentUserID = '';

  FriendRepository({required super.store})
    : super(
        tableName: DbTableName.localFriend,
        primaryKeyName: 'friendUserID',
        name: 'FriendRepository',
      );

  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  @override
  FriendInfo fromRow(Map<String, dynamic> row) => FriendInfo.fromJson(row);

  Future<DbResult> upsertFriend(Map<String, dynamic> friendData) => upsertRow(friendData);

  Future<DbResult> batchUpsertFriends(List<Map<String, dynamic>> dataList) =>
      batchUpsertRows(dataList);

  Future<DbResult> updateFriend(String friendUserID, Map<String, dynamic> data) =>
      updateByPrimaryKey(friendUserID, data);

  Future<DbResult> deleteFriend(String friendUserID) => deleteByPrimaryKey(friendUserID);

  Future<FriendInfo?> getFriendByUserID(String friendUserID) => findByPrimaryKey(friendUserID);

  Future<List<FriendInfo>> getFriendsByUserIDs(List<String> userIDs) => findByPrimaryKeys(userIDs);

  Future<List<FriendInfo>> getAllFriends({int limit = 2000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID)
        .limit(limit);
    return result.data.map<FriendInfo>(fromRow).toList();
  }

  Future<List<FriendInfo>> getFriendsPage(int offset, int count) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map<FriendInfo>(fromRow).toList();
  }

  Future<List<FriendInfo>> getFriendsPageExcluding(
    int offset,
    int count,
    Set<String> excludeUserIDs,
  ) async {
    QueryBuilder query = store
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID);
    if (excludeUserIDs.isNotEmpty) {
      query = query.whereNotIn('friendUserID', excludeUserIDs.toList());
    }
    final QueryResult<Map<String, dynamic>> result = await query.limit(count).offset(offset);
    return result.data.map<FriendInfo>(fromRow).toList();
  }

  Future<List<FriendInfo>> searchFriends(
    String keyword, {
    bool searchUserID = false,
    bool searchNickname = true,
    bool searchRemark = true,
    int limit = 100,
  }) async {
    if (keyword.isEmpty) {
      return <FriendInfo>[];
    }
    final String pattern = '%$keyword%';
    final List<String> fields = <String>[];
    if (searchUserID) {
      fields.add('friendUserID');
    }
    if (searchNickname) {
      fields.add('nickname');
    }
    if (searchRemark) {
      fields.add('remark');
    }
    if (fields.isEmpty) {
      return <FriendInfo>[];
    }

    QueryCondition condition = QueryCondition().whereLike(fields.first, pattern);
    for (int i = 1; i < fields.length; i++) {
      condition = condition.or().whereLike(fields[i], pattern);
    }

    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID)
        .condition(condition)
        .limit(limit);
    return result.data.map<FriendInfo>(fromRow).toList();
  }

  // ---- FriendRequest ----

  Future<DbResult> upsertFriendRequest(Map<String, dynamic> data) async {
    final String fromID = data['fromUserID']?.toString() ?? '';
    final String toID = data['toUserID']?.toString() ?? '';
    final Map<String, dynamic> normalized = <String, dynamic>{
      ...data,
      'id': DbSchema.compositeKey(fromID, toID),
    };
    final DbResult result = await store.upsert(DbTableName.localFriendRequest, normalized);
    logIfErrors('upsertFriendRequest', result);
    return result;
  }

  Future<List<FriendApplicationInfo>> getFriendRequestsAsRecipient({
    int offset = 0,
    int count = 40,
  }) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localFriendRequest)
        .whereEqual('toUserID', _currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map<FriendApplicationInfo>(FriendApplicationInfo.fromJson).toList();
  }

  Future<List<FriendApplicationInfo>> getFriendRequestsAsApplicant({
    int offset = 0,
    int count = 40,
  }) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localFriendRequest)
        .whereEqual('fromUserID', _currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map<FriendApplicationInfo>(FriendApplicationInfo.fromJson).toList();
  }

  Future<int> getFriendRequestUnhandledCount() {
    return store
        .query(DbTableName.localFriendRequest)
        .whereEqual('toUserID', _currentUserID)
        .whereEqual('handleResult', 0)
        .count();
  }

  // ---- BlackList (O(1) 复合主键) ----

  Future<DbResult> insertBlack(Map<String, dynamic> data) async {
    final String ownerID = data['ownerUserID']?.toString() ?? _currentUserID;
    final String blockID = data['blockUserID']?.toString() ?? data['userID']?.toString() ?? '';
    final Map<String, dynamic> normalized = <String, dynamic>{
      ...data,
      'id': DbSchema.compositeKey(ownerID, blockID),
      'ownerUserID': ownerID,
      'blockUserID': blockID,
    };
    final DbResult result = await store.upsert(DbTableName.localBlack, normalized);
    logIfErrors('insertBlack', result);
    return result;
  }

  Future<DbResult> batchUpsertBlacks(List<Map<String, dynamic>> blacks) async {
    if (blacks.isEmpty) {
      return DbResult.success(message: 'Empty');
    }
    final List<Map<String, dynamic>> normalized = blacks.map<Map<String, dynamic>>((
      Map<String, dynamic> item,
    ) {
      final String ownerID = item['ownerUserID']?.toString() ?? _currentUserID;
      final String blockID = item['blockUserID']?.toString() ?? item['userID']?.toString() ?? '';
      return <String, dynamic>{
        ...item,
        'id': DbSchema.compositeKey(ownerID, blockID),
        'ownerUserID': ownerID,
        'blockUserID': blockID,
      };
    }).toList();
    final DbResult result = await store.batchUpsert(
      DbTableName.localBlack,
      normalized,
      allowPartialErrors: true,
    );
    logIfErrors('batchUpsertBlacks', result);
    return result;
  }

  Future<List<BlacklistInfo>> getBlackList({int limit = 1000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localBlack)
        .whereEqual('ownerUserID', _currentUserID)
        .limit(limit);
    return result.data.map<BlacklistInfo>(BlacklistInfo.fromJson).toList();
  }

  /// 仅投影 `blockUserID` 单列，避免反序列化整行黑名单信息。
  Future<Set<String>> getBlackUserIDSet({int limit = 1000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localBlack)
        .whereEqual('ownerUserID', _currentUserID)
        .select(<String>['blockUserID'])
        .limit(limit);
    return result.data
        .map<String?>((Map<String, dynamic> row) => row['blockUserID'] as String?)
        .whereType<String>()
        .toSet();
  }

  /// O(1) 复合主键直接删除，替代历史全表扫描绕过。
  Future<DbResult> removeBlack(String blockUserID) async {
    final String pk = DbSchema.compositeKey(_currentUserID, blockUserID);
    final DbResult result = await store.delete(DbTableName.localBlack).whereEqual('id', pk);
    logIfErrors('removeBlack($blockUserID)', result);
    return result;
  }
}
