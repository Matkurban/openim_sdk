import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../../models/group_info.dart';
import '../db_schema.dart';

/// 群组、群成员与群申请领域仓储。
///
/// 修复 B-01：`batchUpsertGroupMembers` 不再整群清空后再写入；
/// 通过确定性复合主键 `id = '${groupID}_$userID'` 实现安全增量批量写入，
/// 全量替换场景单独提供事务级 `replaceGroupMembers`。
final class GroupRepository extends BaseRepository<GroupInfo> {
  String _currentUserID = '';

  GroupRepository({required super.store})
    : super(tableName: DbTableName.localGroup, primaryKeyName: 'groupID', name: 'GroupRepository');

  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  @override
  GroupInfo fromRow(Map<String, dynamic> row) => GroupInfo.fromJson(row);

  // ---- Group ----

  Future<DbResult> upsertGroup(Map<String, dynamic> data) => upsertRow(data);

  Future<DbResult> batchUpsertGroups(List<Map<String, dynamic>> dataList) =>
      batchUpsertRows(dataList);

  Future<DbResult> updateGroup(String groupID, Map<String, dynamic> data) =>
      updateByPrimaryKey(groupID, data);

  Future<DbResult> deleteGroup(String groupID) => deleteByPrimaryKey(groupID);

  Future<GroupInfo?> getGroupByID(String groupID) => findByPrimaryKey(groupID);

  Future<List<GroupInfo>> getGroupsByIDs(List<String> groupIDs) => findByPrimaryKeys(groupIDs);

  Future<List<GroupInfo>> getJoinedGroupList({int limit = 1000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroup)
        .limit(limit);
    return result.data.map<GroupInfo>(fromRow).toList();
  }

  Future<List<GroupInfo>> getJoinedGroupListPage(int offset, int count) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroup)
        .limit(count)
        .offset(offset);
    return result.data.map<GroupInfo>(fromRow).toList();
  }

  Future<List<GroupInfo>> searchGroups(
    String keyword, {
    bool searchGroupID = false,
    bool searchGroupName = true,
    int limit = 100,
  }) async {
    if (keyword.isEmpty) {
      return <GroupInfo>[];
    }
    final String pattern = '%$keyword%';
    final List<String> fields = <String>[];
    if (searchGroupID) {
      fields.add('groupID');
    }
    if (searchGroupName) {
      fields.add('groupName');
    }
    if (fields.isEmpty) {
      return <GroupInfo>[];
    }

    QueryCondition condition = QueryCondition().whereLike(fields.first, pattern);
    for (int i = 1; i < fields.length; i++) {
      condition = condition.or().whereLike(fields[i], pattern);
    }

    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroup)
        .condition(condition)
        .limit(limit);
    return result.data.map<GroupInfo>(fromRow).toList();
  }

  // ---- GroupMember (O(1) 复合主键) ----

  Map<String, dynamic> _normalizeMember(Map<String, dynamic> data) {
    final String groupID = data['groupID']?.toString() ?? '';
    final String userID = data['userID']?.toString() ?? '';
    return <String, dynamic>{
      ...data,
      'id': DbSchema.compositeKey(groupID, userID),
      'groupID': groupID,
      'userID': userID,
    };
  }

  Future<DbResult> upsertGroupMember(Map<String, dynamic> data) async {
    final DbResult result = await store.upsert(
      DbTableName.localGroupMember,
      _normalizeMember(data),
    );
    logIfErrors('upsertGroupMember', result);
    return result;
  }

  /// 安全增量批量写入/更新群成员（不删除同群其他既有成员，修复 B-01）。
  Future<DbResult> batchUpsertGroupMembers(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) {
      return DbResult.success(message: 'Empty');
    }
    final List<Map<String, dynamic>> normalized = dataList
        .where((Map<String, dynamic> m) => (m['groupID']?.toString() ?? '').isNotEmpty)
        .map<Map<String, dynamic>>(_normalizeMember)
        .toList();
    if (normalized.isEmpty) {
      return DbResult.success(message: 'Empty');
    }
    final DbResult result = await store.batchUpsert(
      DbTableName.localGroupMember,
      normalized,
      allowPartialErrors: true,
    );
    logIfErrors('batchUpsertGroupMembers', result);
    return result;
  }

  /// 在原子事务内全量替换指定群组的所有成员（适用于全量拉取群成员场景）。
  Future<TransactionResult> replaceGroupMembers(
    String groupID,
    List<Map<String, dynamic>> members,
  ) {
    final List<Map<String, dynamic>> normalized = members
        .map<Map<String, dynamic>>(
          (Map<String, dynamic> m) => _normalizeMember(<String, dynamic>{...m, 'groupID': groupID}),
        )
        .toList();
    return store.transaction(() async {
      await store.delete(DbTableName.localGroupMember).whereEqual('groupID', groupID);
      if (normalized.isNotEmpty) {
        await store.batchUpsert(DbTableName.localGroupMember, normalized, allowPartialErrors: true);
      }
    }, rollbackOnError: true);
  }

  Future<DbResult> updateGroupMember(
    String groupID,
    String userID,
    Map<String, dynamic> data,
  ) async {
    final String pk = DbSchema.compositeKey(groupID, userID);
    final DbResult result = await store
        .update(DbTableName.localGroupMember, data)
        .whereEqual('id', pk);
    logIfErrors('updateGroupMember($groupID,$userID)', result);
    return result;
  }

  /// O(1) 复合主键直接点查群成员（替代历史全群扫描绕过）。
  Future<GroupMembersInfo?> getGroupMember(String groupID, String userID) async {
    final String pk = DbSchema.compositeKey(groupID, userID);
    final QueryBuilder query = store.query(DbTableName.localGroupMember).whereEqual('id', pk);
    final Map<String, dynamic>? cached = query.peekFirst();
    if (cached != null) {
      return GroupMembersInfo.fromJson(cached);
    }
    final Map<String, dynamic>? row = await query.first();
    return row != null ? GroupMembersInfo.fromJson(row) : null;
  }

  Future<List<GroupMembersInfo>> getGroupMembers(String groupID, {int limit = 2000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .limit(limit);
    return result.data.map<GroupMembersInfo>(GroupMembersInfo.fromJson).toList();
  }

  Future<List<GroupMembersInfo>> getGroupMembersPage(
    String groupID, {
    int offset = 0,
    int count = 40,
    int? filter,
  }) async {
    QueryBuilder query = store.query(DbTableName.localGroupMember).whereEqual('groupID', groupID);
    if (filter != null && filter > 0) {
      query = query.whereEqual('roleLevel', filter);
    }
    final QueryResult<Map<String, dynamic>> result = await query.limit(count).offset(offset);
    return result.data.map<GroupMembersInfo>(GroupMembersInfo.fromJson).toList();
  }

  Future<List<GroupMembersInfo>> getGroupOwnerAndAdmin(String groupID) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .whereIn('roleLevel', <int>[60, 100])
        .limit(100);
    return result.data.map<GroupMembersInfo>(GroupMembersInfo.fromJson).toList();
  }

  Future<List<GroupMembersInfo>> getGroupMembersByUserIDs(
    String groupID,
    List<String> userIDs,
  ) async {
    if (userIDs.isEmpty) {
      return <GroupMembersInfo>[];
    }
    final List<String> pks = userIDs
        .map<String>((String uid) => DbSchema.compositeKey(groupID, uid))
        .toList();
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroupMember)
        .whereIn('id', pks);
    return result.data.map<GroupMembersInfo>(GroupMembersInfo.fromJson).toList();
  }

  /// O(1) 复合主键直接删除群成员。
  Future<DbResult> deleteGroupMember(String groupID, String userID) async {
    final String pk = DbSchema.compositeKey(groupID, userID);
    final DbResult result = await store.delete(DbTableName.localGroupMember).whereEqual('id', pk);
    logIfErrors('deleteGroupMember($groupID,$userID)', result);
    return result;
  }

  Future<DbResult> deleteGroupAllMembers(String groupID) async {
    final DbResult result = await store
        .delete(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID);
    logIfErrors('deleteGroupAllMembers($groupID)', result);
    return result;
  }

  Future<List<GroupMembersInfo>> searchGroupMembers(
    String groupID,
    String keyword, {
    bool searchUserID = true,
    bool searchNickname = true,
    int offset = 0,
    int count = 40,
  }) async {
    if (keyword.isEmpty) {
      return <GroupMembersInfo>[];
    }
    final String pattern = '%$keyword%';
    final List<String> fields = <String>[];
    if (searchUserID) {
      fields.add('userID');
    }
    if (searchNickname) {
      fields.add('nickname');
    }
    if (fields.isEmpty) {
      return <GroupMembersInfo>[];
    }

    QueryCondition condition = QueryCondition().whereLike(fields.first, pattern);
    for (int i = 1; i < fields.length; i++) {
      condition = condition.or().whereLike(fields[i], pattern);
    }

    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .condition(condition)
        .offset(offset)
        .limit(count);
    return result.data.map<GroupMembersInfo>(GroupMembersInfo.fromJson).toList();
  }

  // ---- GroupRequest ----

  Future<DbResult> upsertGroupRequest(Map<String, dynamic> data) async {
    final String groupID = data['groupID']?.toString() ?? '';
    final String userID = data['userID']?.toString() ?? '';
    final Map<String, dynamic> normalized = <String, dynamic>{
      ...data,
      'id': DbSchema.compositeKey(groupID, userID),
    };
    final DbResult result = await store.upsert(DbTableName.localGroupRequest, normalized);
    logIfErrors('upsertGroupRequest', result);
    return result;
  }

  Future<List<GroupApplicationInfo>> getGroupRequestsAsRecipient({
    int offset = 0,
    int count = 40,
  }) async {
    final List<String> myGroupIDs = await _getManagedGroupIDs();
    if (myGroupIDs.isEmpty) {
      return <GroupApplicationInfo>[];
    }
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroupRequest)
        .whereIn('groupID', myGroupIDs)
        .offset(offset)
        .limit(count);
    return result.data.map<GroupApplicationInfo>(GroupApplicationInfo.fromJson).toList();
  }

  Future<List<GroupApplicationInfo>> getGroupRequestsAsApplicant({
    int offset = 0,
    int count = 40,
  }) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroupRequest)
        .whereEqual('userID', _currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map<GroupApplicationInfo>(GroupApplicationInfo.fromJson).toList();
  }

  Future<int> getGroupRequestUnhandledCount() async {
    final List<String> myGroupIDs = await _getManagedGroupIDs();
    if (myGroupIDs.isEmpty) {
      return 0;
    }
    return store
        .query(DbTableName.localGroupRequest)
        .whereIn('groupID', myGroupIDs)
        .whereEqual('handleResult', 0)
        .count();
  }

  Future<List<String>> _getManagedGroupIDs() async {
    final QueryResult<Map<String, dynamic>> adminGroups = await store
        .query(DbTableName.localGroupMember)
        .whereEqual('userID', _currentUserID)
        .whereIn('roleLevel', <int>[60, 100])
        .select(<String>['groupID'])
        .limit(500);
    return adminGroups.data
        .map<String?>((Map<String, dynamic> m) => m['groupID'] as String?)
        .whereType<String>()
        .toList();
  }
}
