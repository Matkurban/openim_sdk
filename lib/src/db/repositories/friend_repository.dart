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

  /// 创建 `FriendRepository` 实例。
  ///
  /// Creates a `FriendRepository` instance.
  ///
  /// - [store] 存储 / Store.
  FriendRepository({required super.store})
    : super(
        tableName: DbTableName.localFriend,
        primaryKeyName: 'friendUserID',
        name: 'FriendRepository',
      );

  /// 设置Current用户ID。
  ///
  /// Set current user ID.
  ///
  /// - [userID] 用户ID / User ID.
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  /// 从行数据。
  ///
  /// From row.
  ///
  /// - [row] 行数据 / Row.
  /// - Returns: `FriendInfo` 结果 / Resulting `FriendInfo`.
  @override
  FriendInfo fromRow(Map<String, dynamic> row) => FriendInfo.fromJson(row);

  /// 写入或更新好友。
  ///
  /// Upsert friend.
  ///
  /// - [friendData] 好友数据 / Friend data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> upsertFriend(Map<String, dynamic> friendData) => upsertRow(friendData);

  /// 批量写入或更新好友列表。
  ///
  /// Batch upsert friends.
  ///
  /// - [dataList] 数据列表 / Data list.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> batchUpsertFriends(List<Map<String, dynamic>> dataList) =>
      batchUpsertRows(dataList);

  /// 更新好友。
  ///
  /// Update friend.
  ///
  /// - [friendUserID] 好友用户ID / Friend user ID.
  /// - [data] 数据 / Data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> updateFriend(String friendUserID, Map<String, dynamic> data) =>
      updateByPrimaryKey(friendUserID, data);

  /// 删除好友。
  ///
  /// Delete friend.
  ///
  /// - [friendUserID] 好友用户ID / Friend user ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteFriend(String friendUserID) => deleteByPrimaryKey(friendUserID);

  /// 获取好友按用户ID。
  ///
  /// Get friend by user ID.
  ///
  /// - [friendUserID] 好友用户ID / Friend user ID.
  /// - Returns: `Future<FriendInfo?>` 结果 / Resulting `Future<FriendInfo?>`.
  Future<FriendInfo?> getFriendByUserID(String friendUserID) => findByPrimaryKey(friendUserID);

  /// 获取好友列表按用户ID 列表。
  ///
  /// Get friends by user i ds.
  ///
  /// - [userIDs] 用户ID 列表 / User i ds.
  /// - Returns: `Future<List<FriendInfo>>` 列表结果 / Resulting `Future<List<FriendInfo>>` list.
  Future<List<FriendInfo>> getFriendsByUserIDs(List<String> userIDs) => findByPrimaryKeys(userIDs);

  /// 获取全部好友列表。
  ///
  /// Get all friends.
  ///
  /// - [limit] 条数上限 / Limit.
  /// - Returns: `Future<List<FriendInfo>>` 列表结果 / Resulting `Future<List<FriendInfo>>` list.
  Future<List<FriendInfo>> getAllFriends({int limit = 2000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID)
        .limit(limit);
    return result.data.map<FriendInfo>(fromRow).toList();
  }

  /// 获取好友列表分页。
  ///
  /// Get friends paged.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<FriendInfo>>` 列表结果 / Resulting `Future<List<FriendInfo>>` list.
  Future<List<FriendInfo>> getFriendsPage(int offset, int count) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map<FriendInfo>(fromRow).toList();
  }

  /// 获取好友列表分页Excluding。
  ///
  /// Get friends paged excluding.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - [excludeUserIDs] exclude用户ID 列表 / Exclude user i ds.
  /// - Returns: `Future<List<FriendInfo>>` 列表结果 / Resulting `Future<List<FriendInfo>>` list.
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

  /// 搜索好友列表。
  ///
  /// Search friends.
  ///
  /// - [keyword] 关键词 / Keyword.
  /// - [searchUserID] 搜索用户ID / Search user ID.
  /// - [searchNickname] 搜索昵称 / Search nickname.
  /// - [searchRemark] 搜索备注 / Search remark.
  /// - [limit] 条数上限 / Limit.
  /// - Returns: `Future<List<FriendInfo>>` 列表结果 / Resulting `Future<List<FriendInfo>>` list.
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

  /// 写入或更新好友申请/请求。
  ///
  /// Upsert friend request.
  ///
  /// - [data] 数据 / Data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
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

  /// 获取好友申请/请求列表作为接收方。
  ///
  /// Get friend requests as recipient.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<FriendApplicationInfo>>` 列表结果 / Resulting `Future<List<FriendApplicationInfo>>` list.
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

  /// 获取好友申请/请求列表作为申请方。
  ///
  /// Get friend requests as applicant.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<FriendApplicationInfo>>` 列表结果 / Resulting `Future<List<FriendApplicationInfo>>` list.
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

  /// 获取好友申请/请求未处理数量。
  ///
  /// Get friend request unhandled count.
  ///
  /// - Returns: 整数结果 / Integer result.
  Future<int> getFriendRequestUnhandledCount() {
    return store
        .query(DbTableName.localFriendRequest)
        .whereEqual('toUserID', _currentUserID)
        .whereEqual('handleResult', 0)
        .count();
  }

  // ---- BlackList (O(1) 复合主键) ----

  /// 插入黑名单。
  ///
  /// Insert blacklist.
  ///
  /// - [data] 数据 / Data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
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

  /// 批量写入或更新Blacks。
  ///
  /// Batch upsert blacks.
  ///
  /// - [blacks] blacks / Blacks.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
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

  /// 获取黑名单列表。
  ///
  /// Get blacklist list.
  ///
  /// - [limit] 条数上限 / Limit.
  /// - Returns: `Future<List<BlacklistInfo>>` 列表结果 / Resulting `Future<List<BlacklistInfo>>` list.
  Future<List<BlacklistInfo>> getBlackList({int limit = 1000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localBlack)
        .whereEqual('ownerUserID', _currentUserID)
        .limit(limit);
    return result.data.map<BlacklistInfo>(BlacklistInfo.fromJson).toList();
  }

  /// 仅投影 `blockUserID` 单列，避免反序列化整行黑名单信息。
  ///
  /// - [limit] 条数上限 / Limit.
  /// - Returns: `Future<Set<String>>` 结果 / Resulting `Future<Set<String>>`.
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
  ///
  /// Remove blacklist.
  ///
  /// - [blockUserID] block用户ID / Block user ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> removeBlack(String blockUserID) async {
    final String pk = DbSchema.compositeKey(_currentUserID, blockUserID);
    final DbResult result = await store.delete(DbTableName.localBlack).whereEqual('id', pk);
    logIfErrors('removeBlack($blockUserID)', result);
    return result;
  }
}
