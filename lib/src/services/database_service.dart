import 'dart:convert';
import 'dart:math';

import 'package:openim_sdk/openim_sdk.dart';

import '../db/db_schema.dart';
import '../utils/im_convert.dart';
import '../utils/sdk_isolate.dart' as isolate_util;

/// 数据库服务层
class DatabaseService {
  final ToStore toStore;

  DatabaseService({required this.toStore});

  String? _currentUserID;

  // 防止同一 (tableName, entityID) 的 version_sync 写入并发导致唯一约束冲突
  final Map<String, Future<DbResult>> _versionSyncInFlight = {};

  Future<bool> switchSpace({required String userID}) async {
    _currentUserID = userID;
    SpaceInfo spaceInfo = await toStore.getSpaceInfo();
    String generateSpaceName = OpenImUtils.generateSpaceName(userID);
    if (spaceInfo.spaceName == generateSpaceName) {
      return true;
    }
    return toStore.switchSpace(spaceName: generateSpaceName);
  }

  /// 关闭数据库
  Future<void> close() async {
    _currentUserID = null;
    return toStore.close();
  }

  // ---------------------------------------------------------------------------
  // User 操作 - 对应 Go SDK UserModel
  // ---------------------------------------------------------------------------

  /// 插入或更新本地用户信息
  Future<DbResult> upsertUser(Map<String, dynamic> userData) async {
    return toStore.upsert(DbTableName.localUser, userData);
  }

  /// 插入或更新本地用户信息
  Future<DbResult> upsertUsers(List<Map<String, dynamic>> userDatas) async {
    return toStore.batchUpsert(DbTableName.localUser, userDatas);
  }

  /// 获取当前登录用户信息
  Future<UserInfo?> getLoginUser() async {
    final data = await toStore
        .query(DbTableName.localUser)
        .whereEqual('userID', _currentUserID)
        .first();
    return data != null ? UserInfo.fromJson(data) : null;
  }

  /// 批量获取用户信息
  Future<List<UserInfo>> getUsersByIDs(List<String> userIDs) async {
    if (userIDs.isEmpty) return [];
    final result = await toStore.query(DbTableName.localUser).whereIn('userID', userIDs);
    return result.data.map((d) => UserInfo.fromJson(d)).toList();
  }

  // ---------------------------------------------------------------------------
  // Friend 操作 - 对应 Go SDK FriendModel
  // ---------------------------------------------------------------------------

  /// 插入或更新好友
  Future<DbResult> upsertFriend(Map<String, dynamic> friendData) async {
    return toStore.upsert(DbTableName.localFriend, friendData);
  }

  /// 获取所有好友列表
  Future<List<FriendInfo>> getAllFriends() async {
    final result = await toStore
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID);
    return result.data.map(_convertFriendInfo).toList();
  }

  /// 分页获取好友列表
  Future<List<FriendInfo>> getFriendsPage(int offset, int count) async {
    final result = await toStore
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map(_convertFriendInfo).toList();
  }

  /// 分页获取好友（排除指定用户ID）
  Future<List<FriendInfo>> getFriendsPageExcluding(
    int offset,
    int count,
    Set<String> excludeUserIDs,
  ) async {
    var query = toStore.query(DbTableName.localFriend).whereEqual('ownerUserID', _currentUserID);
    if (excludeUserIDs.isNotEmpty) {
      query = query.whereNotIn('friendUserID', excludeUserIDs.toList());
    }
    final result = await query.limit(count).offset(offset);
    return result.data.map(_convertFriendInfo).toList();
  }

  /// 根据好友用户ID获取好友信息
  Future<FriendInfo?> getFriendByUserID(String friendUserID) async {
    final data = await toStore
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID)
        .whereEqual('friendUserID', friendUserID)
        .first();
    return data != null ? _convertFriendInfo(data) : null;
  }

  /// 批量根据好友用户ID获取好友信息
  Future<List<FriendInfo>> getFriendsByUserIDs(List<String> userIDs) async {
    if (userIDs.isEmpty) return [];
    final result = await toStore
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID)
        .whereIn('friendUserID', userIDs);
    return result.data.map(_convertFriendInfo).toList();
  }

  /// 删除好友
  Future<DbResult> deleteFriend(String friendUserID) async {
    return toStore
        .delete(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID)
        .whereEqual('friendUserID', friendUserID);
  }

  /// 批量插入或更新好友
  Future<DbResult> batchUpsertFriends(List<Map<String, dynamic>> dataList) async {
    return toStore.batchUpsert(DbTableName.localFriend, dataList);
  }

  /// 搜索好友（利用 Tostore LIKE 查询）
  Future<List<FriendInfo>> searchFriends(
    String keyword, {
    bool searchUserID = false,
    bool searchNickname = true,
    bool searchRemark = true,
  }) async {
    if (keyword.isEmpty) return [];
    final pattern = '%$keyword%';
    final fields = <String>[];
    if (searchUserID) fields.add('friendUserID');
    if (searchNickname) fields.add('nickname');
    if (searchRemark) fields.add('remark');
    if (fields.isEmpty) return [];

    var cond = QueryCondition().whereLike(fields.first, pattern);
    for (int i = 1; i < fields.length; i++) {
      cond = cond.or().whereLike(fields[i], pattern);
    }

    final result = await toStore
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', _currentUserID)
        .condition(cond);
    return result.data.map(_convertFriendInfo).toList();
  }

  // ---------------------------------------------------------------------------
  // FriendRequest 操作
  // ---------------------------------------------------------------------------

  /// 插入或更新好友申请
  Future<DbResult> upsertFriendRequest(Map<String, dynamic> data) async {
    return toStore.upsert(DbTableName.localFriendRequest, data);
  }

  /// 获取收到的好友申请列表
  Future<List<FriendApplicationInfo>> getFriendRequestsAsRecipient({
    int offset = 0,
    int count = 40,
  }) async {
    final result = await toStore
        .query(DbTableName.localFriendRequest)
        .whereEqual('toUserID', _currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map(_convertFriendApplicationInfo).toList();
  }

  /// 获取已发送的好友申请列表
  Future<List<FriendApplicationInfo>> getFriendRequestsAsApplicant({
    int offset = 0,
    int count = 40,
  }) async {
    final result = await toStore
        .query(DbTableName.localFriendRequest)
        .whereEqual('fromUserID', _currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map(_convertFriendApplicationInfo).toList();
  }

  // ---------------------------------------------------------------------------
  // Black 操作 - 对应 Go SDK FriendModel(黑名单部分)
  // ---------------------------------------------------------------------------

  /// 插入黑名单
  Future<DbResult> insertBlack(Map<String, dynamic> data) async {
    return toStore.upsert(DbTableName.localBlack, data);
  }

  /// 获取黑名单列表
  Future<List<BlacklistInfo>> getBlackList() async {
    final result = await toStore
        .query(DbTableName.localBlack)
        .whereEqual('ownerUserID', _currentUserID);
    return result.data.map((d) => BlacklistInfo.fromJson(d)).toList();
  }

  /// 移除黑名单
  ///
  /// ToStore 3.0.8 复合唯一索引 bug 绕过：
  /// 多条件 query/delete 会触发 indexScan，_performIndexScan 仅取第一字段构建复合键，
  /// 导致 normalizeValues(scalar, 2) 返回 null → 空结果。
  /// 解决方法：只用单字段 ownerUserID 查询（走 table scan），在 Dart 层过滤 blockUserID，
  /// 再按主键 id 删除（主键路径不经过 _performIndexScan）。
  Future<DbResult> removeBlack(String blockUserID) async {
    final result = await toStore
        .query(DbTableName.localBlack)
        .whereEqual('ownerUserID', _currentUserID);
    final matching = result.data.where((r) => r['blockUserID'] == blockUserID);
    if (matching.isEmpty) return DbResult.success(message: 'Not found');
    final id = matching.first['id'];
    return toStore.delete(DbTableName.localBlack).whereEqual('id', id);
  }

  /// 批量插入/更新黑名单
  Future<DbResult> batchUpsertBlacks(List<Map<String, dynamic>> blacks) async {
    return toStore.batchUpsert(DbTableName.localBlack, blacks);
  }

  // ---------------------------------------------------------------------------
  // Group 操作 - 对应 Go SDK GroupModel
  // ---------------------------------------------------------------------------

  /// 插入或更新群组
  Future<DbResult> upsertGroup(Map<String, dynamic> data) async {
    return toStore.upsert(DbTableName.localGroup, data);
  }

  /// 批量插入或更新群组
  Future<DbResult> batchUpsertGroups(List<Map<String, dynamic>> dataList) async {
    return toStore.batchUpsert(DbTableName.localGroup, dataList);
  }

  /// 获取已加入的群组列表
  Future<List<GroupInfo>> getJoinedGroupList() async {
    final result = await toStore.query(DbTableName.localGroup);
    return result.data.map(_convertGroupInfo).toList();
  }

  /// 分页获取已加入的群组列表
  Future<List<GroupInfo>> getJoinedGroupListPage(int offset, int count) async {
    final result = await toStore.query(DbTableName.localGroup).limit(count).offset(offset);
    return result.data.map(_convertGroupInfo).toList();
  }

  /// 根据群组ID获取群组信息
  Future<GroupInfo?> getGroupByID(String groupID) async {
    final data = await toStore.query(DbTableName.localGroup).whereEqual('groupID', groupID).first();
    return data != null ? _convertGroupInfo(data) : null;
  }

  /// 根据群组ID列表获取群组信息
  Future<List<GroupInfo>> getGroupsByIDs(List<String> groupIDs) async {
    if (groupIDs.isEmpty) return [];
    final result = await toStore.query(DbTableName.localGroup).whereIn('groupID', groupIDs);
    return result.data.map(_convertGroupInfo).toList();
  }

  /// 删除群组
  Future<DbResult> deleteGroup(String groupID) async {
    return toStore.delete(DbTableName.localGroup).whereEqual('groupID', groupID);
  }

  /// 搜索群组（利用 Tostore LIKE 查询）
  Future<List<GroupInfo>> searchGroups(
    String keyword, {
    bool searchGroupID = false,
    bool searchGroupName = true,
  }) async {
    if (keyword.isEmpty) return [];
    final pattern = '%$keyword%';
    final fields = <String>[];
    if (searchGroupID) fields.add('groupID');
    if (searchGroupName) fields.add('groupName');
    if (fields.isEmpty) return [];

    var cond = QueryCondition().whereLike(fields.first, pattern);
    for (int i = 1; i < fields.length; i++) {
      cond = cond.or().whereLike(fields[i], pattern);
    }

    final result = await toStore.query(DbTableName.localGroup).condition(cond);
    return result.data.map(_convertGroupInfo).toList();
  }

  // ---------------------------------------------------------------------------
  // GroupMember 操作
  // ---------------------------------------------------------------------------

  /// 插入或更新群成员
  Future<DbResult> upsertGroupMember(Map<String, dynamic> data) async {
    return toStore.upsert(DbTableName.localGroupMember, data);
  }

  /// 批量插入或更新群成员
  /// ToStore 3.0.8 复合唯一索引 bug 绕过：
  /// batchUpsert 无法正确检测复合唯一索引 [groupID, userID] 的已有记录，
  /// 导致产生 Unique Constraint Violation 警告。
  /// 解决方法：先按 groupID 删除旧成员，再批量写入。
  /// 各群组间互无依赖，并行执行提升性能。
  Future<DbResult> batchUpsertGroupMembers(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) return DbResult.success(message: 'Empty');
    // 按 groupID 分组
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final data in dataList) {
      final gid = data['groupID'] as String? ?? '';
      if (gid.isEmpty) continue;
      (grouped[gid] ??= []).add(data);
    }
    // 各群间无依赖，并行执行先删后插
    await Future.wait(
      grouped.entries.map((entry) async {
        await toStore.delete(DbTableName.localGroupMember).whereEqual('groupID', entry.key);
        await toStore.batchUpsert(DbTableName.localGroupMember, entry.value);
      }),
    );
    return DbResult.success(message: 'OK');
  }

  /// 获取群成员列表
  Future<List<GroupMembersInfo>> getGroupMembers(String groupID) async {
    final result = await toStore.query(DbTableName.localGroupMember).whereEqual('groupID', groupID);
    return result.data.map(_convertGroupMembersInfo).toList();
  }

  /// 分页获取群成员列表
  Future<List<GroupMembersInfo>> getGroupMembersPage(
    String groupID, {
    int offset = 0,
    int count = 40,
    int? filter,
  }) async {
    var query = toStore.query(DbTableName.localGroupMember).whereEqual('groupID', groupID);
    if (filter != null && filter > 0) {
      query = query.whereEqual('roleLevel', filter);
    }
    final result = await query.limit(count).offset(offset);
    return result.data.map(_convertGroupMembersInfo).toList();
  }

  /// 获取群组 Owner 和 Admin
  Future<List<GroupMembersInfo>> getGroupOwnerAndAdmin(String groupID) async {
    final result = await toStore
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .whereIn('roleLevel', [60, 100]);
    return result.data.map(_convertGroupMembersInfo).toList();
  }

  /// 获取指定群成员信息
  Future<GroupMembersInfo?> getGroupMember(String groupID, String userID) async {
    // ToStore 3.0.8 复合唯一索引 bug 绕过：只用首字段查询，Dart 层过滤第二字段
    final result = await toStore.query(DbTableName.localGroupMember).whereEqual('groupID', groupID);
    final data = result.data.where((r) => r['userID'] == userID).firstOrNull;
    return data != null ? _convertGroupMembersInfo(data) : null;
  }

  /// 批量获取指定群成员信息
  Future<List<GroupMembersInfo>> getGroupMembersByUserIDs(
    String groupID,
    List<String> userIDs,
  ) async {
    if (userIDs.isEmpty) return [];
    final result = await toStore
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .whereIn('userID', userIDs);
    return result.data.map(_convertGroupMembersInfo).toList();
  }

  /// 删除群成员
  Future<DbResult> deleteGroupMember(String groupID, String userID) async {
    // ToStore 3.0.8 复合唯一索引 bug 绕过：先查 PK 再按 PK 删除
    final result = await toStore.query(DbTableName.localGroupMember).whereEqual('groupID', groupID);
    final row = result.data.where((r) => r['userID'] == userID).firstOrNull;
    if (row == null) return DbResult.success(message: 'Not found');
    return toStore.delete(DbTableName.localGroupMember).whereEqual('id', row['id']);
  }

  /// 删除群组的所有成员
  Future<DbResult> deleteGroupAllMembers(String groupID) async {
    return toStore.delete(DbTableName.localGroupMember).whereEqual('groupID', groupID);
  }

  /// 搜索群成员（利用 Tostore LIKE 查询）
  Future<List<GroupMembersInfo>> searchGroupMembers(
    String groupID,
    String keyword, {
    bool searchUserID = true,
    bool searchNickname = true,
    int offset = 0,
    int count = 40,
  }) async {
    if (keyword.isEmpty) return [];
    final pattern = '%$keyword%';
    final fields = <String>[];
    if (searchUserID) fields.add('userID');
    if (searchNickname) fields.add('nickname');
    if (fields.isEmpty) return [];

    var cond = QueryCondition().whereLike(fields.first, pattern);
    for (int i = 1; i < fields.length; i++) {
      cond = cond.or().whereLike(fields[i], pattern);
    }

    final result = await toStore
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .condition(cond)
        .offset(offset)
        .limit(count);
    return result.data.map(_convertGroupMembersInfo).toList();
  }

  // ---------------------------------------------------------------------------
  // GroupRequest 操作
  // ---------------------------------------------------------------------------

  /// 插入或更新群申请
  Future<DbResult> upsertGroupRequest(Map<String, dynamic> data) async {
    return toStore.upsert(DbTableName.localGroupRequest, data);
  }

  /// 获取作为接收者的群申请列表
  Future<List<GroupApplicationInfo>> getGroupRequestsAsRecipient({
    int offset = 0,
    int count = 40,
  }) async {
    // 查找当前用户是群主或管理员的群组ID
    final adminGroups = await toStore
        .query(DbTableName.localGroupMember)
        .whereEqual('userID', _currentUserID)
        .whereIn('roleLevel', [60, 100]);
    final myGroupIDs = adminGroups.data.map((m) => m['groupID'] as String).toList();

    if (myGroupIDs.isEmpty) return [];

    final result = await toStore
        .query(DbTableName.localGroupRequest)
        .whereIn('groupID', myGroupIDs)
        .offset(offset)
        .limit(count);
    return result.data.map(_convertGroupApplicationInfo).toList();
  }

  /// 获取作为申请者的群申请列表
  Future<List<GroupApplicationInfo>> getGroupRequestsAsApplicant({
    int offset = 0,
    int count = 40,
  }) async {
    final result = await toStore
        .query(DbTableName.localGroupRequest)
        .whereEqual('userID', _currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map(_convertGroupApplicationInfo).toList();
  }

  /// 获取未处理的好友申请数量
  Future<int> getFriendRequestUnhandledCount() async {
    return toStore
        .query(DbTableName.localFriendRequest)
        .whereEqual('toUserID', _currentUserID)
        .whereEqual('handleResult', 0)
        .count();
  }

  /// 获取未处理的群申请数量
  Future<int> getGroupRequestUnhandledCount() async {
    final adminGroups = await toStore
        .query(DbTableName.localGroupMember)
        .whereEqual('userID', _currentUserID)
        .whereIn('roleLevel', [60, 100]);
    final myGroupIDs = adminGroups.data.map((m) => m['groupID'] as String).toList();
    if (myGroupIDs.isEmpty) return 0;

    return toStore
        .query(DbTableName.localGroupRequest)
        .whereIn('groupID', myGroupIDs)
        .whereEqual('handleResult', 0)
        .count();
  }

  // ---------------------------------------------------------------------------
  // Conversation 操作 - 对应 Go SDK ConversationModel
  // ---------------------------------------------------------------------------

  /// 插入或更新会话
  Future<DbResult> upsertConversation(Map<String, dynamic> data) async {
    return toStore.upsert(DbTableName.localConversation, data);
  }

  /// 批量插入或更新会话
  Future<DbResult> batchUpsertConversations(List<Map<String, dynamic>> dataList) async {
    return toStore.batchUpsert(DbTableName.localConversation, dataList);
  }

  /// 删除所有会话
  Future<DbResult> deleteAllConversations() async {
    return toStore.delete(DbTableName.localConversation).allowDeleteAll();
  }

  /// 获取所有会话列表（包含隐藏会话，用于内部同步）
  Future<List<ConversationInfo>> getAllConversations() async {
    final result = await toStore.query(DbTableName.localConversation);
    return result.data.map(_convertConversation).toList();
  }

  /// 获取所有会话的本地 hasReadSeq（map: conversationID → hasReadSeq）
  /// 用于 _syncConversationsAndSeqs 防止服务端滞后值覆盖本地已读状态
  Future<Map<String, int>> getAllConversationHasReadSeqs() async {
    // 仅获取需要的两个字段，减少反序列化开销
    final result = await toStore
        .query(DbTableName.localConversation)
        .select(['conversationID', 'hasReadSeq']);
    final map = <String, int>{};
    for (final row in result.data) {
      final convID = row['conversationID'] as String?;
      if (convID != null) {
        map[convID] = (row['hasReadSeq'] as num?)?.toInt() ?? 0;
      }
    }
    return map;
  }

  /// 获取可见会话列表（对齐 Go SDK GetAllConversationListDB：latestMsgSendTime > 0）
  Future<List<ConversationInfo>> getVisibleConversations() async {
    final result = await toStore
        .query(DbTableName.localConversation)
        .whereGreaterThan('latestMsgSendTime', 0);
    return result.data.map(_convertConversation).toList();
  }

  /// 分页获取可见会话列表（对齐 Go SDK GetConversationListSplitDB）
  Future<List<ConversationInfo>> getConversationsPage(int offset, int count) async {
    final result = await toStore
        .query(DbTableName.localConversation)
        .whereGreaterThan('latestMsgSendTime', 0)
        .limit(count)
        .offset(offset);
    return result.data.map(_convertConversation).toList();
  }

  /// 根据会话ID获取单个会话
  Future<ConversationInfo?> getConversation(String conversationID) async {
    final data = await toStore
        .query(DbTableName.localConversation)
        .whereEqual('conversationID', conversationID)
        .first();
    return data != null ? _convertConversation(data) : null;
  }

  /// 根据会话ID列表获取多个会话
  Future<List<ConversationInfo>> getMultipleConversations(List<String> conversationIDs) async {
    if (conversationIDs.isEmpty) return [];
    final result = await toStore
        .query(DbTableName.localConversation)
        .whereIn('conversationID', conversationIDs);
    return result.data.map(_convertConversation).toList();
  }

  /// 物理删除会话（仅用于同步器删除服务端已移除的会话）
  Future<DbResult> deleteConversation(String conversationID) async {
    return toStore
        .delete(DbTableName.localConversation)
        .whereEqual('conversationID', conversationID);
  }

  /// 重置会话（对齐 Go SDK ResetConversation）
  /// 等效于隐藏：latestMsgSendTime=0 使 getVisibleConversations 过滤掉
  Future<DbResult> resetConversation(String conversationID) async {
    return toStore
        .update(DbTableName.localConversation, {
          'unreadCount': 0,
          'latestMsg': '',
          'latestMsgSendTime': 0,
          'draftText': '',
          'draftTextTime': 0,
        })
        .whereEqual('conversationID', conversationID);
  }

  /// 清空会话消息但保留会话（对齐 Go SDK ClearConversation）
  /// 会话仍显示在列表中，但没有最新消息
  Future<DbResult> clearConversation(String conversationID) async {
    return toStore
        .update(DbTableName.localConversation, {
          'unreadCount': 0,
          'latestMsg': '',
          'draftText': '',
          'draftTextTime': 0,
        })
        .whereEqual('conversationID', conversationID);
  }

  /// 重置所有会话（对齐 Go SDK ResetAllConversation）
  Future<DbResult> resetAllConversations() async {
    return toStore.update(DbTableName.localConversation, {
      'unreadCount': 0,
      'latestMsg': '',
      'latestMsgSendTime': 0,
      'draftText': '',
      'draftTextTime': 0,
    }).allowUpdateAll();
  }

  /// 更新会话属性
  Future<DbResult> updateConversation(String conversationID, Map<String, dynamic> data) async {
    return toStore
        .update(DbTableName.localConversation, data)
        .whereEqual('conversationID', conversationID);
  }

  /// 获取未读消息总数（使用聚合 sum 避免加载全部行）
  Future<int> getTotalUnreadCount() async {
    final sum = await toStore
        .query(DbTableName.localConversation)
        .whereGreaterThan('unreadCount', 0)
        .sum('unreadCount');
    return sum?.toInt() ?? 0;
  }

  /// 获取黑名单用户ID集合
  Future<Set<String>> getBlackUserIDSet() async {
    final result = await toStore
        .query(DbTableName.localBlack)
        .whereEqual('ownerUserID', _currentUserID);
    return result.data.map((b) => b['blockUserID'] as String).toSet();
  }

  /// 更新会话草稿
  Future<DbResult> setConversationDraft(String conversationID, String draftText) async {
    // 对齐 Go SDK：draftText 为空时调用 RemoveConversationDraft，设 draftTextTime=0；
    // 否则 draftTextTime 设为当前时间（SetConversationDraftDB 行为）。
    // 这样 simpleSort 不会因空草稿的时间戳误把会话排到最顶部。
    return toStore
        .update(DbTableName.localConversation, {
          'draftText': draftText,
          'draftTextTime': draftText.isEmpty ? 0 : DateTime.now().millisecondsSinceEpoch,
        })
        .whereEqual('conversationID', conversationID);
  }

  /// 清空会话未读数
  Future<DbResult> clearConversationUnreadCount(String conversationID) async {
    return toStore
        .update(DbTableName.localConversation, {'unreadCount': 0})
        .whereEqual('conversationID', conversationID);
  }

  /// 减少会话未读数（使用原子表达式避免 read-modify-write 竞态）
  ///
  /// 利用 Expr.min 实现有界递减：
  ///   unreadCount = unreadCount - min(unreadCount, decrCount)
  /// 等价于 max(0, unreadCount - decrCount)，无需先读再写。
  Future<DbResult> decrConversationUnreadCount(String conversationID, int decrCount) async {
    if (decrCount <= 0) return DbResult.success();
    return toStore
        .update(DbTableName.localConversation, {
          'unreadCount': Expr.field('unreadCount') -
              Expr.min(Expr.field('unreadCount'), Expr.value(decrCount)),
        })
        .whereEqual('conversationID', conversationID);
  }

  /// 批量标记消息已读，返回实际标记的条数
  Future<int> markConversationMessageAsReadDB(
    String conversationID,
    List<String> clientMsgIDs,
  ) async {
    if (clientMsgIDs.isEmpty) return 0;
    final int now = DateTime.now().millisecondsSinceEpoch;
    // 单次批量更新，替代原 O(N) 逐条更新循环
    await toStore
        .update(DbTableName.localChatLog, {'isRead': true, 'hasReadTime': now})
        .whereIn('clientMsgID', clientMsgIDs);
    return clientMsgIDs.length;
  }

  /// 清空所有会话未读数
  Future<DbResult> clearAllUnreadCounts() async {
    return toStore.update(DbTableName.localConversation, {'unreadCount': 0}).allowUpdateAll();
  }

  /// 搜索会话（利用 Tostore LIKE 查询）
  Future<List<ConversationInfo>> searchConversations(String keyword) async {
    if (keyword.isEmpty) return [];
    final result = await toStore
        .query(DbTableName.localConversation)
        .whereLike('showName', '%$keyword%');
    return result.data.map(_convertConversation).toList();
  }

  // ---------------------------------------------------------------------------
  // ChatLog (Message) 操作 - 对应 Go SDK MessageModel
  // ---------------------------------------------------------------------------

  /// 插入消息
  Future<DbResult> insertMessage(Map<String, dynamic> msgData) async {
    return toStore.upsert(DbTableName.localChatLog, msgData);
  }

  /// 批量插入消息
  Future<DbResult> batchInsertMessages(List<Map<String, dynamic>> msgList) async {
    return toStore.batchUpsert(DbTableName.localChatLog, msgList);
  }

  /// 根据 clientMsgID 获取消息
  Future<Message?> getMessage(String clientMsgID) async {
    final data = await toStore
        .query(DbTableName.localChatLog)
        .whereEqual('clientMsgID', clientMsgID)
        .first();
    return data != null ? convertMessage(data) : null;
  }

  /// 批量根据 clientMsgID 列表获取消息
  Future<List<Message>> getMessagesByClientMsgIDs(List<String> clientMsgIDs) async {
    if (clientMsgIDs.isEmpty) return [];
    final result = await toStore
        .query(DbTableName.localChatLog)
        .whereIn('clientMsgID', clientMsgIDs);
    return result.data.map(convertMessage).toList();
  }

  /// 获取会话的历史消息（按发送时间倒序）
  /// [conversationID] 会话ID
  /// [startTime] 起始时间戳（毫秒），0 表示从最新开始
  /// [count] 获取条数
  Future<List<Message>> getHistoryMessages({
    required String conversationID,
    int startTime = 0,
    int startSeq = 0,
    String startClientMsgID = '',
    int count = 20,
  }) async {
    var query = toStore
        .query(DbTableName.localChatLog)
        .whereEqual('conversationID', conversationID);

    if (startTime > 0) {
      // 避免 whereCustom() 导致全表扫描遍历而在主线程发生 ANR，
      // 使用带宽限制的时间检索，然后在 Dart 内存中精准切片
      query = query.whereLessThanOrEqualTo('sendTime', startTime);
    }

    // 多取几十条容错以应对同一毫秒 (sendTime 重叠) 的大批量消息
    int limitCount = (startTime > 0) ? (count + 100) : count;
    final result = await query.orderByDesc('sendTime').orderByDesc('seq').limit(limitCount);

    List<Map<String, dynamic>> dataList = result.data;

    // 首次加载时 (startTime == 0)，需要额外获取发送中/失败的消息
    // 这些消息按 sendTime 排序会排在最后，但它们应该是最新消息的一部分
    // 注意：使用 ListView(reverse: true) 时，index 0 = 底部（最新消息位置）
    if (startTime == 0 && count > 0) {
      // 查询状态为发送中(sending=1)或失败(failed=3)的消息
      final pendingResult = await toStore
          .query(DbTableName.localChatLog)
          .whereEqual('conversationID', conversationID)
          .whereIn('status', [1, 3]) // 1=sending, 3=failed
          .orderByDesc('seq')
          .limit(count);
      if (pendingResult.data.isNotEmpty) {
        // 将 pending 消息插入到结果开头（在最新消息位置）
        // 这样失败消息会显示在底部（符合用户最新操作的位置）
        final pendingMsgs = pendingResult.data;
        // 去重：根据 clientMsgID 合并
        final existingIds = dataList.map((m) => m['clientMsgID'] as String?).toSet();
        // 先收集所有需要添加的消息
        final msgsToAdd = <Map<String, dynamic>>[];
        for (final msg in pendingMsgs) {
          final id = msg['clientMsgID'] as String?;
          if (id != null && !existingIds.contains(id)) {
            msgsToAdd.add(msg);
          }
        }
        // 将失败消息插入到列表开头（最新消息位置）
        dataList.insertAll(0, msgsToAdd);
      }
    }

    // 根据 Go 客户端逻辑，严格在 Isolate 中过滤掉包括 startMsg 及时间更新的消息：
    if (startTime > 0 && dataList.isNotEmpty) {
      dataList = await isolate_util.computeHistoryFilter(
        isolate_util.HistoryFilterParam(
          data: dataList,
          startTime: startTime,
          startSeq: startSeq,
          startClientMsgID: startClientMsgID,
          count: count,
        ),
      );
      return dataList.map(convertMessage).toList();
    }

    return dataList.take(count).map(convertMessage).toList();
  }

  /// 更新消息状态
  Future<DbResult> updateMessageStatus(String clientMsgID, int status) async {
    return toStore
        .update(DbTableName.localChatLog, {'status': status})
        .whereEqual('clientMsgID', clientMsgID);
  }

  /// 更新消息（通用）
  Future<DbResult> updateMessage(String clientMsgID, Map<String, dynamic> data) async {
    return toStore.update(DbTableName.localChatLog, data).whereEqual('clientMsgID', clientMsgID);
  }

  /// 删除消息
  Future<DbResult> deleteMessage(String clientMsgID) async {
    return toStore.delete(DbTableName.localChatLog).whereEqual('clientMsgID', clientMsgID);
  }

  /// 删除会话所有消息（按 conversationID 单条件删除）
  Future<DbResult> deleteConversationAllMessages(String conversationID) async {
    return toStore.delete(DbTableName.localChatLog).whereEqual('conversationID', conversationID);
  }

  /// 删除所有本地消息
  Future<DbResult> deleteAllMessages() async {
    return toStore.delete(DbTableName.localChatLog).allowDeleteAll();
  }

  /// 搜索本地消息
  /// 只用 conversationID 作为 ToStore 索引条件，其余条件在 Dart 层过滤，
  /// 避免 ToStore 多索引优化器 bug 导致 conversationID 过滤失效。
  Future<List<Message>> searchMessages({
    String? conversationID,
    String? keyword,
    List<int>? messageTypes,
    int? startTime,
    int? endTime,
    int offset = 0,
    int count = 40,
  }) async {
    var query = toStore.query(DbTableName.localChatLog);

    if (conversationID != null && conversationID.isNotEmpty) {
      if (conversationID.startsWith('sg_')) {
        query = query.whereEqual('groupID', conversationID.substring(3));
      } else {
        query = query.whereEqual('conversationID', conversationID);
      }
    }

    // 只用 conversationID 做 DB 查询，多取数据后在 Dart 层做二次过滤
    final batchSize = (count + offset) * 3 + 200;
    final result = await query.orderByDesc('sendTime').limit(batchSize);

    // 在后台 Isolate 中执行消息搜索过滤（字符串匹配 + 类型/时间过滤）
    final filterResult = await isolate_util.computeSearchFilter(
      isolate_util.SearchFilterParam(
        data: result.data,
        keyword: keyword,
        messageTypes: messageTypes,
        startTime: startTime,
        endTime: endTime,
        offset: offset,
        count: count,
      ),
    );

    return filterResult.filtered.map(convertMessage).toList();
  }

  /// 标记消息已读
  Future<void> markMessageAsRead(String clientMsgID) async {
    await toStore
        .update(DbTableName.localChatLog, {
          'isRead': true,
          'hasReadTime': DateTime.now().millisecondsSinceEpoch,
        })
        .whereEqual('clientMsgID', clientMsgID);
  }

  /// 批量标记消息已读
  Future<DbResult> markMessagesAsRead(List<String> clientMsgIDs) async {
    final int now = DateTime.now().millisecondsSinceEpoch;
    return toStore
        .update(DbTableName.localChatLog, {'isRead': true, 'hasReadTime': now})
        .whereIn('clientMsgID', clientMsgIDs);
  }

  // ---------------------------------------------------------------------------
  // SendingMessage 操作 - 对应 Go SDK SendingMessagesModel
  // ---------------------------------------------------------------------------

  /// 插入发送中消息
  Future<DbResult> insertSendingMessage(String clientMsgID, String conversationID) async {
    return toStore.upsert(DbTableName.localSendingMessage, {
      'clientMsgID': clientMsgID,
      'conversationID': conversationID,
    });
  }

  /// 删除发送中消息
  Future<DbResult> deleteSendingMessage(String clientMsgID) async {
    return toStore.delete(DbTableName.localSendingMessage).whereEqual('clientMsgID', clientMsgID);
  }

  /// 获取会话的发送中消息列表
  Future<List<Map<String, dynamic>>> getSendingMessages(String conversationID) async {
    final result = await toStore
        .query(DbTableName.localSendingMessage)
        .whereEqual('conversationID', conversationID);
    return result.data;
  }

  /// 获取所有发送中消息列表（用于 App 启动后恢复）
  Future<List<Map<String, dynamic>>> getAllSendingMessages() async {
    final result = await toStore.query(DbTableName.localSendingMessage);
    return result.data;
  }

  // ---------------------------------------------------------------------------
  // 序列化辅助方法
  // ---------------------------------------------------------------------------

  /// 将 JSON 字符串安全解析为 Map
  static Map<String, dynamic>? safeDecodeJson(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// 将 Map 安全编码为 JSON 字符串
  static String? safeEncodeJson(Map<String, dynamic>? map) {
    if (map == null) return null;
    try {
      return jsonEncode(map);
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 局部更新方法（避免 read-modify-write 模式丢失字段）
  // ---------------------------------------------------------------------------

  /// 更新群组部分字段
  Future<DbResult> updateGroup(String groupID, Map<String, dynamic> data) async {
    return toStore.update(DbTableName.localGroup, data).whereEqual('groupID', groupID);
  }

  /// 更新群成员部分字段
  Future<DbResult> updateGroupMember(
    String groupID,
    String userID,
    Map<String, dynamic> data,
  ) async {
    return toStore
        .update(DbTableName.localGroupMember, data)
        .whereEqual('groupID', groupID)
        .whereEqual('userID', userID);
  }

  /// 更新好友部分字段
  Future<DbResult> updateFriend(String friendUserID, Map<String, dynamic> data) async {
    return toStore
        .update(DbTableName.localFriend, data)
        .whereEqual('ownerUserID', _currentUserID)
        .whereEqual('friendUserID', friendUserID);
  }

  /// 更新单聊消息中的发送者展示信息
  Future<DbResult> updateSingleChatMessageSenderInfo(
    String userID, {
    required String senderNickname,
    String? senderFaceUrl,
  }) async {
    final data = <String, dynamic>{'senderNickname': senderNickname};
    if (senderFaceUrl != null) {
      data['senderFaceUrl'] = senderFaceUrl;
    }
    return toStore
        .update(DbTableName.localChatLog, data)
        .whereEqual('sessionType', ConversationType.single.value)
        .whereEqual('sendID', userID);
  }

  /// 更新所有会话类型消息中的发送者展示信息（用于自身昵称/头像变更后回溯更新）
  Future<DbResult> updateAllMessageSenderInfo(
    String userID, {
    required String senderNickname,
    String? senderFaceUrl,
  }) async {
    final data = <String, dynamic>{'senderNickname': senderNickname};
    if (senderFaceUrl != null) {
      data['senderFaceUrl'] = senderFaceUrl;
    }
    return toStore.update(DbTableName.localChatLog, data).whereEqual('sendID', userID);
  }

  /// 根据会话ID + seq列表获取消息（按 sendTime 倒序）
  Future<List<Message>> getMessagesBySeqs(String conversationID, List<int> seqs) async {
    if (seqs.isEmpty) return [];
    final result = await toStore
        .query(DbTableName.localChatLog)
        .whereEqual('conversationID', conversationID)
        .whereIn('seq', seqs)
        .orderByDesc('sendTime');
    return result.data.map(convertMessage).toList();
  }

  /// 按 seq 批量标记会话消息已读
  Future<DbResult> markMessagesAsReadBySeqs(String conversationID, List<int> seqs) async {
    if (seqs.isEmpty) return DbResult.success();
    final now = DateTime.now().millisecondsSinceEpoch;
    return toStore
        .update(DbTableName.localChatLog, {'isRead': true, 'hasReadTime': now})
        .whereEqual('conversationID', conversationID)
        .whereIn('seq', seqs);
  }

  /// 按 seq 批量标记会话消息已删除
  Future<DbResult> markMessagesDeletedBySeqs(String conversationID, List<int> seqs) async {
    if (seqs.isEmpty) return DbResult.success();
    return toStore
        .update(DbTableName.localChatLog, {'status': MessageStatus.deleted.value})
        .whereEqual('conversationID', conversationID)
        .whereIn('seq', seqs);
  }

  /// 获取会话的 maxSeq（不在 ConversationInfo 模型中的 DB 字段）
  Future<int> getConversationMaxSeq(String conversationID) async {
    final data = await toStore
        .query(DbTableName.localConversation)
        .whereEqual('conversationID', conversationID)
        .first();
    return (data?['maxSeq'] as num?)?.toInt() ?? 0;
  }

  /// 从消息表查询会话的最大 seq（对齐 Go SDK GetConversationNormalMsgSeq）
  Future<int> getConversationNormalMsgMaxSeq(String conversationID) async {
    final result = await toStore
        .query(DbTableName.localChatLog)
        .whereEqual('conversationID', conversationID)
        .orderByDesc('seq')
        .limit(1);
    if (result.data.isEmpty) return 0;
    return (result.data.first['seq'] as num?)?.toInt() ?? 0;
  }

  /// 批量获取所有会话的 maxSeq（单次查询，仅取需要的字段）
  Future<Map<String, int>> getAllConversationMaxSeqs() async {
    // 仅获取 conversationID 和 maxSeq 两个字段，减少反序列化开销
    final result = await toStore
        .query(DbTableName.localConversation)
        .select(['conversationID', 'maxSeq']);
    final seqs = <String, int>{};
    for (final row in result.data) {
      final convID = row['conversationID'] as String?;
      if (convID != null) {
        seqs[convID] = (row['maxSeq'] as num?)?.toInt() ?? 0;
      }
    }
    return seqs;
  }

  /// 批量从消息表获取每个会话实际已存储的最大 seq
  ///
  /// 对齐 Go SDK CheckConversationNormalMsgSeq：从消息表读取 MAX(seq)，
  /// 而非会话表的 maxSeq（后者可能在消息拉取失败时已提前推进）。
  Future<Map<String, int>> getAllConversationNormalMsgMaxSeqs(List<String> conversationIDs) async {
    if (conversationIDs.isEmpty) return {};
    try {
      // 优先使用聚合查询（高效）
      final result = await toStore
          .query(DbTableName.localChatLog)
          .whereIn('conversationID', conversationIDs)
          .select(['conversationID', Agg.max('seq', alias: 'maxSeq')])
          .groupBy(['conversationID']);
      final seqs = <String, int>{};
      for (final row in result.data) {
        final convID = row['conversationID'] as String?;
        if (convID != null) {
          seqs[convID] = (row['maxSeq'] as num?)?.toInt() ?? 0;
        }
      }
      return seqs;
    } catch (e) {
      // DDC 热重启时 `is QueryAggregation` 类型检查可能因模块身份问题失败，
      // 回退为逐批读取原始数据并在 Dart 侧计算最大值。
      const batchSize = 100;
      final seqs = <String, int>{};
      for (var i = 0; i < conversationIDs.length; i += batchSize) {
        final batch = conversationIDs.sublist(i, min(i + batchSize, conversationIDs.length));
        final rows = await toStore
            .query(DbTableName.localChatLog)
            .whereIn('conversationID', batch)
            .select(['conversationID', 'seq']);
        for (final row in rows.data) {
          final convID = row['conversationID'] as String?;
          final seq = (row['seq'] as num?)?.toInt() ?? 0;
          if (convID != null && seq > (seqs[convID] ?? 0)) {
            seqs[convID] = seq;
          }
        }
      }
      return seqs;
    }
  }

  // ---------------------------------------------------------------------------
  // 模型转换：数据库 Map ↔ 模型对象
  // ---------------------------------------------------------------------------

  /// 数据库 Map 转 FriendInfo
  FriendInfo _convertFriendInfo(Map<String, dynamic> data) {
    return FriendInfo.fromJson(data);
  }

  /// 数据库 Map 转 FriendApplicationInfo
  FriendApplicationInfo _convertFriendApplicationInfo(Map<String, dynamic> data) {
    return FriendApplicationInfo.fromJson(data);
  }

  /// 数据库 Map 转 GroupInfo
  GroupInfo _convertGroupInfo(Map<String, dynamic> data) {
    return GroupInfo.fromJson(data);
  }

  /// 数据库 Map 转 GroupMembersInfo
  GroupMembersInfo _convertGroupMembersInfo(Map<String, dynamic> data) {
    return GroupMembersInfo.fromJson(data);
  }

  /// 数据库 Map 转 GroupApplicationInfo
  GroupApplicationInfo _convertGroupApplicationInfo(Map<String, dynamic> data) {
    return GroupApplicationInfo.fromJson(data);
  }

  /// 数据库 Map 转 ConversationInfo
  ConversationInfo _convertConversation(Map<String, dynamic> data) {
    final latestMsgStr = data['latestMsg'] as String?;
    Message? latestMsg;
    if (latestMsgStr != null && latestMsgStr.isNotEmpty) {
      try {
        final rawMap = jsonDecode(latestMsgStr) as Map<String, dynamic>;
        latestMsg = convertMessage(_normalizeRawMsg(rawMap));
      } catch (_) {}
    }

    return ConversationInfo(
      conversationID: data['conversationID'] as String,
      conversationType: (data['conversationType'] as int?) == null
          ? null
          : ConversationType.fromValue(data['conversationType']),
      userID: data['userID'] as String?,
      groupID: data['groupID'] as String?,
      showName: data['showName'] as String?,
      faceURL: data['faceURL'] as String?,
      recvMsgOpt: (data['recvMsgOpt'] as int?) == null
          ? null
          : ReceiveMessageOpt.fromValue(data['recvMsgOpt']),
      unreadCount: (data['unreadCount'] as num?)?.toInt() ?? 0,
      latestMsg: latestMsg,
      latestMsgSendTime: data['latestMsgSendTime'] as int?,
      draftText: data['draftText'] as String?,
      draftTextTime: data['draftTextTime'] as int?,
      isPinned: data['isPinned'] as bool?,
      isPrivateChat: data['isPrivateChat'] as bool?,
      burnDuration: data['burnDuration'] as int?,
      isMsgDestruct: data['isMsgDestruct'] as bool?,
      msgDestructTime: data['msgDestructTime'] as int?,
      ex: data['ex'] as String?,
      isNotInGroup: data['isNotInGroup'] as bool?,
      groupAtType: (data['groupAtType'] as int?) == null
          ? null
          : GroupAtType.fromValue(data['groupAtType']),
    );
  }

  /// Message 转数据库 Map
  static Map<String, dynamic> messageToDbMap(Message msg) {
    String? content;
    if (msg.textElem != null) {
      content = jsonEncode(msg.textElem!.toJson());
    } else if (msg.pictureElem != null) {
      content = jsonEncode(msg.pictureElem!.toJson());
    } else if (msg.soundElem != null) {
      content = jsonEncode(msg.soundElem!.toJson());
    } else if (msg.videoElem != null) {
      content = jsonEncode(msg.videoElem!.toJson());
    } else if (msg.fileElem != null) {
      content = jsonEncode(msg.fileElem!.toJson());
    } else if (msg.locationElem != null) {
      content = jsonEncode(msg.locationElem!.toJson());
    } else if (msg.customElem != null) {
      content = jsonEncode(msg.customElem!.toJson());
    } else if (msg.quoteElem != null) {
      content = jsonEncode(msg.quoteElem!.toJson());
    } else if (msg.mergeElem != null) {
      content = jsonEncode(msg.mergeElem!.toJson());
    } else if (msg.faceElem != null) {
      content = jsonEncode(msg.faceElem!.toJson());
    } else if (msg.cardElem != null) {
      content = jsonEncode(msg.cardElem!.toJson());
    } else if (msg.atTextElem != null) {
      content = jsonEncode(msg.atTextElem!.toJson());
    } else if (msg.advancedTextElem != null) {
      content = jsonEncode(msg.advancedTextElem!.toJson());
    }

    return {
      'clientMsgID': msg.clientMsgID,
      'serverMsgID': msg.serverMsgID,
      'sendID': msg.sendID,
      'recvID': msg.recvID,
      'senderPlatformID': msg.senderPlatformID?.value,
      'senderNickname': msg.senderNickname,
      'senderFaceUrl': msg.senderFaceUrl,
      'groupID': msg.groupID,
      'sessionType': msg.sessionType?.value,
      'msgFrom': msg.msgFrom,
      'contentType': msg.contentType?.value,
      'content': content,
      'isRead': msg.isRead ?? false,
      'status': msg.status?.value,
      'seq': msg.seq ?? 0,
      'sendTime': msg.sendTime,
      'createTime': msg.createTime,
      'attachedInfo': msg.attachedInfo,
      'ex': msg.ex,
      'localEx': msg.localEx,
      'isReact': msg.isReact ?? false,
      'isExternalExtensions': msg.isExternalExtensions ?? false,
      'hasReadTime': msg.hasReadTime,
    };
  }

  /// 规范化原始服务端消息 Map
  static Map<String, dynamic> _normalizeRawMsg(Map<String, dynamic> msg) {
    final ct = msg['contentType'] as int? ?? 0;
    final elemKey = _contentTypeToElemKey(ct);
    if (elemKey == null || msg[elemKey] != null) return msg;

    final rawContent = msg['content'] as String?;
    if (rawContent == null || rawContent.isEmpty) return msg;

    Map<String, dynamic>? contentMap;
    try {
      contentMap = jsonDecode(rawContent) as Map<String, dynamic>;
    } catch (_) {}
    if (contentMap == null) {
      try {
        contentMap = jsonDecode(utf8.decode(base64Decode(rawContent))) as Map<String, dynamic>;
      } catch (_) {}
    }
    if (contentMap == null) return msg;
    return {...msg, elemKey: contentMap};
  }

  /// contentType → Message.fromJson 对应 elem 字段名
  static String? _contentTypeToElemKey(int ct) {
    switch (ct) {
      case 101:
        return 'textElem';
      case 102:
        return 'pictureElem';
      case 103:
        return 'soundElem';
      case 104:
        return 'videoElem';
      case 105:
        return 'fileElem';
      case 106:
        return 'atTextElem';
      case 107:
        return 'mergeElem';
      case 108:
        return 'cardElem';
      case 109:
        return 'locationElem';
      case 110:
      case 119:
      case 120:
        return 'customElem';
      case 114:
        return 'quoteElem';
      case 115:
        return 'faceElem';
      case 117:
        return 'advancedTextElem';
      default:
        return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Moment 操作 - 朋友圈动态本地存储
  // ---------------------------------------------------------------------------

  /// 插入或更新单条动态
  Future<DbResult> upsertMoment(MomentInfo moment) async {
    return toStore.upsert(DbTableName.localMoment, moment.toJson());
  }

  /// 批量插入或更新动态
  Future<DbResult> batchUpsertMoments(List<MomentInfo> moments) async {
    return toStore.batchUpsert(DbTableName.localMoment, moments.map((m) => m.toJson()).toList());
  }

  /// 分页获取动态列表（按 createTime 降序）
  Future<List<MomentInfo>> getMoments({int offset = 0, int count = 20}) async {
    final result = await toStore
        .query(DbTableName.localMoment)
        .orderByDesc('createTime')
        .limit(count)
        .offset(offset);
    return result.data.map((r) => MomentInfo.fromJson(r)).toList();
  }

  /// 获取某用户的动态列表
  Future<List<MomentInfo>> getMomentsByUserID(
    String userID, {
    int offset = 0,
    int count = 20,
  }) async {
    final result = await toStore
        .query(DbTableName.localMoment)
        .whereEqual('userID', userID)
        .orderByDesc('createTime')
        .limit(count)
        .offset(offset);
    return result.data.map((r) => MomentInfo.fromJson(r)).toList();
  }

  /// 根据 momentID 获取单条动态
  Future<MomentInfo?> getMomentByID(String momentID) async {
    final row = await toStore
        .query(DbTableName.localMoment)
        .whereEqual('momentID', momentID)
        .first();
    return row != null ? MomentInfo.fromJson(row) : null;
  }

  /// 删除本地动态
  Future<DbResult> deleteMoment(String momentID) async {
    return toStore.delete(DbTableName.localMoment).whereEqual('momentID', momentID);
  }

  // ---------------------------------------------------------------------------
  // Favorite 操作 - 收藏夹本地存储
  // ---------------------------------------------------------------------------

  /// 插入或更新单条收藏
  Future<DbResult> upsertFavorite(FavoriteItem item) async {
    return toStore.upsert(DbTableName.localFavorite, item.toJson());
  }

  /// 批量插入或更新收藏
  Future<DbResult> batchUpsertFavorites(List<FavoriteItem> items) async {
    return toStore.batchUpsert(DbTableName.localFavorite, items.map((f) => f.toJson()).toList());
  }

  /// 分页获取收藏列表（按 createTime 降序）
  Future<List<FavoriteItem>> getFavorites({int offset = 0, int count = 20}) async {
    final result = await toStore
        .query(DbTableName.localFavorite)
        .whereEqual('userID', _currentUserID)
        .orderByDesc('createTime')
        .limit(count)
        .offset(offset);
    return result.data.map((r) => FavoriteItem.fromJson(r)).toList();
  }

  /// 根据 targetType + targetID 查找收藏（检查是否已收藏）
  Future<FavoriteItem?> getFavoriteByTarget(String targetType, String targetID) async {
    final row = await toStore
        .query(DbTableName.localFavorite)
        .whereEqual('userID', _currentUserID)
        .whereEqual('targetType', targetType)
        .whereEqual('targetID', targetID)
        .first();
    return row != null ? FavoriteItem.fromJson(row) : null;
  }

  /// 按 targetType + targetID 删除收藏
  Future<DbResult> deleteFavoriteByTarget(String targetType, String targetID) async {
    return toStore
        .delete(DbTableName.localFavorite)
        .whereEqual('userID', _currentUserID)
        .whereEqual('targetType', targetType)
        .whereEqual('targetID', targetID);
  }

  // ---------------------------------------------------------------------------
  // Upload 任务操作 - 对齐 Go SDK upload_model 语义
  // ---------------------------------------------------------------------------

  Future<DbResult> upsertUploadTask(Map<String, dynamic> data) async {
    return toStore.upsert(DbTableName.localUpload, data);
  }

  Future<Map<String, dynamic>?> getUploadTask(String uploadID) async {
    return toStore.query(DbTableName.localUpload).whereEqual('uploadID', uploadID).first();
  }

  Future<Map<String, dynamic>?> getUploadTaskByHashAndName(String hash, String name) async {
    return toStore
        .query(DbTableName.localUpload)
        .whereEqual('hash', hash)
        .whereEqual('name', name)
        .first();
  }

  Future<DbResult> deleteUploadTask(String uploadID) async {
    return toStore.delete(DbTableName.localUpload).whereEqual('uploadID', uploadID);
  }

  // ---------------------------------------------------------------------------
  // VersionSync 操作 - 对齐 Go SDK version_sync 语义
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>?> getVersionSync(String tableName, String entityID) async {
    // ToStore 3.0.8 复合唯一索引 bug 绕过
    final result = await toStore
        .query(DbTableName.localVersionSync)
        .whereEqual('tableName', tableName);
    return result.data.where((r) => r['entityID'] == entityID).firstOrNull;
  }

  Future<DbResult> setVersionSync({
    required String tableName,
    required String entityID,
    String? versionID,
    int? version,
    List<String>? uidList,
  }) async {
    final lockKey = '$tableName|$entityID';
    final prev = _versionSyncInFlight[lockKey];
    if (prev != null) {
      await prev;
    }

    Future<DbResult> run() async {
      final data = {
        'tableName': tableName,
        'entityID': entityID,
        'versionID': versionID,
        'version': version,
        'uidList': uidList,
        'updateTime': DateTime.now().millisecondsSinceEpoch,
      };

      // 由于 localVersionSync 使用 timestampBased 的主键（id），toStore.upsert 不能可靠地按唯一索引
      // (tableName, entityID) 合并。为避免反复触发 unique constraint（且确保版本能正确推进），
      // 这里显式做存在性判断：存在则 update，不存在才 upsert。
      // ToStore 3.0.8 复合唯一索引 bug 绕过
      final queryResult = await toStore
          .query(DbTableName.localVersionSync)
          .whereEqual('tableName', tableName);
      final existing = queryResult.data.where((r) => r['entityID'] == entityID).firstOrNull;

      if (existing != null) {
        return toStore.update(DbTableName.localVersionSync, data).whereEqual('id', existing['id']);
      }

      return toStore.upsert(DbTableName.localVersionSync, data);
    }

    final future = run();
    _versionSyncInFlight[lockKey] = future;
    try {
      return await future;
    } finally {
      if (_versionSyncInFlight[lockKey] == future) {
        _versionSyncInFlight.remove(lockKey);
      }
    }
  }

  Future<DbResult> deleteVersionSync(String tableName, String entityID) async {
    // ToStore 3.0.8 复合唯一索引 bug 绕过
    final result = await toStore
        .query(DbTableName.localVersionSync)
        .whereEqual('tableName', tableName);
    final row = result.data.where((r) => r['entityID'] == entityID).firstOrNull;
    if (row == null) return DbResult.success(message: 'Not found');
    return toStore.delete(DbTableName.localVersionSync).whereEqual('id', row['id']);
  }

  // ---------------------------------------------------------------------------
  // NotificationSeq 操作 - 对齐 Go SDK notification seq 语义
  // ---------------------------------------------------------------------------

  Future<DbResult> upsertNotificationSeq(String conversationID, int seq) async {
    return toStore.upsert(DbTableName.localNotificationSeq, {
      'conversationID': conversationID,
      'seq': seq,
      'updateTime': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<Map<String, int>> getAllNotificationSeqs() async {
    final result = await toStore.query(DbTableName.localNotificationSeq);
    final map = <String, int>{};
    for (final row in result.data) {
      final conversationID = row['conversationID'] as String?;
      if (conversationID == null) continue;
      map[conversationID] = (row['seq'] as num?)?.toInt() ?? 0;
    }
    return map;
  }

  // ---------------------------------------------------------------------------
  // 已领取红包记录操作
  // ---------------------------------------------------------------------------

  /// 记录红包已被领取
  Future<DbResult> markRedPacketGrabbed(String packetID) async {
    return toStore.upsert(DbTableName.localGrabbedRedPacket, {
      'packetID': packetID,
      'grabTime': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 查询单个红包是否已领取
  Future<bool> isRedPacketGrabbed(String packetID) async {
    final data = await toStore
        .query(DbTableName.localGrabbedRedPacket)
        .whereEqual('packetID', packetID)
        .first();
    return data != null;
  }

  /// 批量查询红包是否已领取，返回已领取的 packetID 集合
  Future<Set<String>> getGrabbedRedPacketIDs(List<String> packetIDs) async {
    if (packetIDs.isEmpty) return {};
    final result = await toStore
        .query(DbTableName.localGrabbedRedPacket)
        .whereIn('packetID', packetIDs);
    return result.data.map((r) => r['packetID'] as String).toSet();
  }
}
