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

  /// 创建 `GroupRepository` 实例。
  ///
  /// Creates a `GroupRepository` instance.
  ///
  /// - [store] 存储 / Store.
  GroupRepository({required super.store})
    : super(tableName: DbTableName.localGroup, primaryKeyName: 'groupID', name: 'GroupRepository');

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
  /// - Returns: `GroupInfo` 结果 / Resulting `GroupInfo`.
  @override
  GroupInfo fromRow(Map<String, dynamic> row) => GroupInfo.fromJson(row);

  // ---- Group ----

  /// 写入或更新群组。
  ///
  /// Upsert group.
  ///
  /// - [data] 数据 / Data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> upsertGroup(Map<String, dynamic> data) => upsertRow(data);

  /// 批量写入或更新群组列表。
  ///
  /// Batch upsert groups.
  ///
  /// - [dataList] 数据列表 / Data list.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> batchUpsertGroups(List<Map<String, dynamic>> dataList) =>
      batchUpsertRows(dataList);

  /// 更新群组。
  ///
  /// Update group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [data] 数据 / Data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> updateGroup(String groupID, Map<String, dynamic> data) =>
      updateByPrimaryKey(groupID, data);

  /// 删除群组。
  ///
  /// Delete group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteGroup(String groupID) => deleteByPrimaryKey(groupID);

  /// 获取群组ByID。
  ///
  /// Get group by ID.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - Returns: `Future<GroupInfo?>` 结果 / Resulting `Future<GroupInfo?>`.
  Future<GroupInfo?> getGroupByID(String groupID) => findByPrimaryKey(groupID);

  /// 获取群组列表ByID 列表。
  ///
  /// Get groups by i ds.
  ///
  /// - [groupIDs] 群组ID 列表 / Group i ds.
  /// - Returns: `Future<List<GroupInfo>>` 列表结果 / Resulting `Future<List<GroupInfo>>` list.
  Future<List<GroupInfo>> getGroupsByIDs(List<String> groupIDs) => findByPrimaryKeys(groupIDs);

  /// 获取Joined群组列表。
  ///
  /// Get joined group list.
  ///
  /// - [limit] 条数上限 / Limit.
  /// - Returns: `Future<List<GroupInfo>>` 列表结果 / Resulting `Future<List<GroupInfo>>` list.
  Future<List<GroupInfo>> getJoinedGroupList({int limit = 1000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroup)
        .limit(limit);
    return result.data.map<GroupInfo>(fromRow).toList();
  }

  /// 获取Joined群组列表分页。
  ///
  /// Get joined group list paged.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<GroupInfo>>` 列表结果 / Resulting `Future<List<GroupInfo>>` list.
  Future<List<GroupInfo>> getJoinedGroupListPage(int offset, int count) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroup)
        .limit(count)
        .offset(offset);
    return result.data.map<GroupInfo>(fromRow).toList();
  }

  /// 搜索群组列表。
  ///
  /// Search groups.
  ///
  /// - [keyword] 关键词 / Keyword.
  /// - [searchGroupID] 搜索群组ID / Search group ID.
  /// - [searchGroupName] 搜索群组名称 / Search group name.
  /// - [limit] 条数上限 / Limit.
  /// - Returns: `Future<List<GroupInfo>>` 列表结果 / Resulting `Future<List<GroupInfo>>` list.
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

  /// 写入或更新群组成员。
  ///
  /// Upsert group member.
  ///
  /// - [data] 数据 / Data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> upsertGroupMember(Map<String, dynamic> data) async {
    final DbResult result = await store.upsert(
      DbTableName.localGroupMember,
      _normalizeMember(data),
    );
    logIfErrors('upsertGroupMember', result);
    return result;
  }

  /// 安全增量批量写入/更新群成员（不删除同群其他既有成员，修复 B-01）。
  ///
  /// Batch upsert group members.
  ///
  /// - [dataList] 数据列表 / Data list.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
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
  ///
  /// Replace group members.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [members] 成员列表 / Members.
  /// - Returns: `Future<TransactionResult>` 结果 / Resulting `Future<TransactionResult>`.
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

  /// 更新群组成员。
  ///
  /// Update group member.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - [data] 数据 / Data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
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
  ///
  /// Get group member.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - Returns: `Future<GroupMembersInfo?>` 结果 / Resulting `Future<GroupMembersInfo?>`.
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

  /// 获取群组成员列表。
  ///
  /// Get group members.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [limit] 条数上限 / Limit.
  /// - Returns: `Future<List<GroupMembersInfo>>` 列表结果 / Resulting `Future<List<GroupMembersInfo>>` list.
  Future<List<GroupMembersInfo>> getGroupMembers(String groupID, {int limit = 2000}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .limit(limit);
    return result.data.map<GroupMembersInfo>(GroupMembersInfo.fromJson).toList();
  }

  /// 获取群组成员列表分页。
  ///
  /// Get group members paged.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - [filter] 筛选 / Filter.
  /// - Returns: `Future<List<GroupMembersInfo>>` 列表结果 / Resulting `Future<List<GroupMembersInfo>>` list.
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

  /// 获取群组群主/拥有者并管理员。
  ///
  /// Get group owner and administrator.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - Returns: `Future<List<GroupMembersInfo>>` 列表结果 / Resulting `Future<List<GroupMembersInfo>>` list.
  Future<List<GroupMembersInfo>> getGroupOwnerAndAdmin(String groupID) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .whereIn('roleLevel', <int>[60, 100])
        .limit(100);
    return result.data.map<GroupMembersInfo>(GroupMembersInfo.fromJson).toList();
  }

  /// 获取群组成员列表按用户ID 列表。
  ///
  /// Get group members by user i ds.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userIDs] 用户ID 列表 / User i ds.
  /// - Returns: `Future<List<GroupMembersInfo>>` 列表结果 / Resulting `Future<List<GroupMembersInfo>>` list.
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
  ///
  /// Delete group member.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteGroupMember(String groupID, String userID) async {
    final String pk = DbSchema.compositeKey(groupID, userID);
    final DbResult result = await store.delete(DbTableName.localGroupMember).whereEqual('id', pk);
    logIfErrors('deleteGroupMember($groupID,$userID)', result);
    return result;
  }

  /// 删除群组全部成员列表。
  ///
  /// Delete group all members.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteGroupAllMembers(String groupID) async {
    final DbResult result = await store
        .delete(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID);
    logIfErrors('deleteGroupAllMembers($groupID)', result);
    return result;
  }

  /// 搜索群组成员列表。
  ///
  /// Search group members.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [keyword] 关键词 / Keyword.
  /// - [searchUserID] 搜索用户ID / Search user ID.
  /// - [searchNickname] 搜索昵称 / Search nickname.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<GroupMembersInfo>>` 列表结果 / Resulting `Future<List<GroupMembersInfo>>` list.
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

  /// 写入或更新群组申请/请求。
  ///
  /// Upsert group request.
  ///
  /// - [data] 数据 / Data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
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

  /// 获取群组申请/请求列表作为接收方。
  ///
  /// Get group requests as recipient.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<GroupApplicationInfo>>` 列表结果 / Resulting `Future<List<GroupApplicationInfo>>` list.
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

  /// 获取群组申请/请求列表作为申请方。
  ///
  /// Get group requests as applicant.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<GroupApplicationInfo>>` 列表结果 / Resulting `Future<List<GroupApplicationInfo>>` list.
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

  /// 获取群组申请/请求未处理数量。
  ///
  /// Get group request unhandled count.
  ///
  /// - Returns: 整数结果 / Integer result.
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
