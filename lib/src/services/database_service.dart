import 'dart:convert';

import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/utils/im_utils.dart';
import 'package:tostore/tostore.dart';

import '../db/db_schema.dart';

/// 数据库服务层
class DatabaseService {
  final ToStore toStore;

  DatabaseService({required this.toStore});

  String? _currentUserID;

  String get currentUserID => _currentUserID!;

  Future<bool> switchSpace({required String userID}) async {
    _currentUserID = userID;
    return toStore.switchSpace(spaceName: ImUtils.generateSpaceName(userID));
  }

  /// 关闭数据库
  Future<void> close() async {
    await toStore.close();
    _currentUserID = null;
  }

  /// 插入一条记录
  Future<DbResult> insert(String table, Map<String, dynamic> data) {
    return toStore.insert(table, data);
  }

  /// 批量插入记录
  Future<DbResult> batchInsert(String table, List<Map<String, dynamic>> dataList) {
    return toStore.batchInsert(table, dataList);
  }

  /// 插入或更新记录（upsert）
  Future<DbResult> upsert(String table, Map<String, dynamic> data) {
    return toStore.upsert(table, data);
  }

  /// 批量插入或更新记录
  Future<DbResult> batchUpsert(String table, List<Map<String, dynamic>> dataList) {
    return toStore.batchUpsert(table, dataList);
  }

  /// 根据主键查询单条记录（主键字段名 + 值）
  Future<Map<String, dynamic>?> queryByPrimaryKey(String table, String pkField, dynamic pk) async {
    return toStore.query(table).whereEqual(pkField, pk).first();
  }

  /// 查询表中所有记录
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final result = await toStore.query(table);
    return result.data;
  }

  /// 根据主键删除记录
  Future<void> deleteByPrimaryKey(String table, String pkField, dynamic pkValue) async {
    await toStore.delete(table).whereEqual(pkField, pkValue);
  }

  /// 在事务中执行操作
  Future<TransactionResult> transaction(Future<void> Function() action) {
    return toStore.transaction(action);
  }

  // ---------------------------------------------------------------------------
  // User 操作 - 对应 Go SDK UserModel
  // ---------------------------------------------------------------------------

  /// 插入或更新本地用户信息
  Future<void> insertOrUpdateUser(Map<String, dynamic> userData) async {
    await toStore.upsert(DbTableName.localUser, userData);
  }

  /// 获取当前登录用户信息
  Future<UserInfo?> getLoginUser() async {
    final data = await toStore
        .query(DbTableName.localUser)
        .whereEqual('userID', currentUserID)
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
  Future<void> upsertFriend(Map<String, dynamic> friendData) async {
    await toStore.upsert(DbTableName.localFriend, friendData);
  }

  /// 获取所有好友列表
  Future<List<FriendInfo>> getAllFriends() async {
    final result = await toStore
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', currentUserID);
    return result.data.map(_convertFriendInfo).toList();
  }

  /// 分页获取好友列表
  Future<List<FriendInfo>> getFriendsPage(int offset, int count) async {
    final result = await toStore
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map(_convertFriendInfo).toList();
  }

  /// 根据好友用户ID获取好友信息
  Future<FriendInfo?> getFriendByUserID(String friendUserID) async {
    final data = await toStore
        .query(DbTableName.localFriend)
        .whereEqual('friendUserID', friendUserID)
        .first();
    return data != null ? _convertFriendInfo(data) : null;
  }

  /// 批量根据好友用户ID获取好友信息
  Future<List<FriendInfo>> getFriendsByUserIDs(List<String> userIDs) async {
    if (userIDs.isEmpty) return [];
    final result = await toStore.query(DbTableName.localFriend).whereIn('friendUserID', userIDs);
    return result.data.map(_convertFriendInfo).toList();
  }

  /// 删除好友
  Future<void> deleteFriend(String friendUserID) async {
    await toStore.delete(DbTableName.localFriend).whereEqual('friendUserID', friendUserID);
  }

  /// 批量插入或更新好友
  Future<void> batchUpsertFriends(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) return;
    await toStore.batchUpsert(DbTableName.localFriend, dataList);
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
        .whereEqual('ownerUserID', currentUserID)
        .condition(cond);
    return result.data.map(_convertFriendInfo).toList();
  }

  // ---------------------------------------------------------------------------
  // FriendRequest 操作
  // ---------------------------------------------------------------------------

  /// 插入或更新好友申请
  Future<void> upsertFriendRequest(Map<String, dynamic> data) async {
    await toStore.upsert(DbTableName.localFriendRequest, data);
  }

  /// 获取收到的好友申请列表
  Future<List<FriendApplicationInfo>> getFriendRequestsAsRecipient({
    int offset = 0,
    int count = 40,
  }) async {
    final result = await toStore
        .query(DbTableName.localFriendRequest)
        .whereEqual('toUserID', currentUserID)
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
        .whereEqual('fromUserID', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map(_convertFriendApplicationInfo).toList();
  }

  // ---------------------------------------------------------------------------
  // Black 操作 - 对应 Go SDK FriendModel(黑名单部分)
  // ---------------------------------------------------------------------------

  /// 插入黑名单
  Future<void> insertBlack(Map<String, dynamic> data) async {
    await toStore.upsert(DbTableName.localBlack, data);
  }

  /// 获取黑名单列表
  Future<List<BlacklistInfo>> getBlackList() async {
    final result = await toStore
        .query(DbTableName.localBlack)
        .whereEqual('ownerUserID', currentUserID);
    return result.data.map((d) => BlacklistInfo.fromJson(d)).toList();
  }

  /// 移除黑名单
  Future<void> removeBlack(String blockUserID) async {
    await toStore
        .delete(DbTableName.localBlack)
        .whereEqual('ownerUserID', currentUserID)
        .whereEqual('blockUserID', blockUserID);
  }

  // ---------------------------------------------------------------------------
  // Group 操作 - 对应 Go SDK GroupModel
  // ---------------------------------------------------------------------------

  /// 插入或更新群组
  Future<void> upsertGroup(Map<String, dynamic> data) async {
    await toStore.upsert(DbTableName.localGroup, data);
  }

  /// 批量插入或更新群组
  Future<void> batchUpsertGroups(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) return;
    await toStore.batchUpsert(DbTableName.localGroup, dataList);
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
  Future<void> deleteGroup(String groupID) async {
    await toStore.delete(DbTableName.localGroup).whereEqual('groupID', groupID);
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
  Future<void> upsertGroupMember(Map<String, dynamic> data) async {
    await toStore.upsert(DbTableName.localGroupMember, data);
  }

  /// 批量插入或更新群成员
  Future<void> batchUpsertGroupMembers(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) return;
    await toStore.batchUpsert(DbTableName.localGroupMember, dataList);
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
    final data = await toStore
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .whereEqual('userID', userID)
        .first();
    return data != null ? _convertGroupMembersInfo(data) : null;
  }

  /// 删除群成员
  Future<void> deleteGroupMember(String groupID, String userID) async {
    await toStore
        .delete(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .whereEqual('userID', userID);
  }

  /// 删除群组的所有成员
  Future<void> deleteGroupAllMembers(String groupID) async {
    await toStore.delete(DbTableName.localGroupMember).whereEqual('groupID', groupID);
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
  Future<void> upsertGroupRequest(Map<String, dynamic> data) async {
    await toStore.upsert(DbTableName.localGroupRequest, data);
  }

  /// 获取作为接收者的群申请列表
  Future<List<GroupApplicationInfo>> getGroupRequestsAsRecipient({
    int offset = 0,
    int count = 40,
  }) async {
    // 查找当前用户是群主或管理员的群组ID
    final adminGroups = await toStore
        .query(DbTableName.localGroupMember)
        .whereEqual('userID', currentUserID)
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
        .whereEqual('userID', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data.map(_convertGroupApplicationInfo).toList();
  }

  /// 获取未处理的好友申请数量
  Future<int> getFriendRequestUnhandledCount() async {
    return toStore
        .query(DbTableName.localFriendRequest)
        .whereEqual('toUserID', currentUserID)
        .whereEqual('handleResult', 0)
        .count();
  }

  /// 获取未处理的群申请数量
  Future<int> getGroupRequestUnhandledCount() async {
    final adminGroups = await toStore
        .query(DbTableName.localGroupMember)
        .whereEqual('userID', currentUserID)
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
  Future<void> upsertConversation(Map<String, dynamic> data) async {
    await toStore.upsert(DbTableName.localConversation, data);
  }

  /// 批量插入或更新会话
  Future<void> batchUpsertConversations(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) return;
    await toStore.batchUpsert(DbTableName.localConversation, dataList);
  }

  /// 删除所有会话
  Future<void> deleteAllConversations() async {
    await toStore.delete(DbTableName.localConversation).allowDeleteAll();
  }

  /// 获取所有会话列表
  Future<List<ConversationInfo>> getAllConversations() async {
    final result = await toStore.query(DbTableName.localConversation);
    return result.data.map(_convertConversation).toList();
  }

  /// 分页获取会话列表
  Future<List<ConversationInfo>> getConversationsPage(int offset, int count) async {
    final result = await toStore.query(DbTableName.localConversation).limit(count).offset(offset);
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

  /// 删除会话
  Future<void> deleteConversation(String conversationID) async {
    await toStore
        .delete(DbTableName.localConversation)
        .whereEqual('conversationID', conversationID);
  }

  /// 更新会话属性
  Future<void> updateConversation(String conversationID, Map<String, dynamic> data) async {
    await toStore
        .update(DbTableName.localConversation, data)
        .whereEqual('conversationID', conversationID);
  }

  /// 获取未读消息总数
  Future<int> getTotalUnreadCount() async {
    // ToStore sum() 对 integer 字段有 bug，手动聚合
    final result = await toStore.query(DbTableName.localConversation);
    int total = 0;
    for (final row in result.data) {
      total += (row['unreadCount'] as int?) ?? 0;
    }
    return total;
  }

  /// 更新会话草稿
  Future<void> setConversationDraft(String conversationID, String draftText) async {
    await toStore
        .update(DbTableName.localConversation, {
          'draftText': draftText,
          'draftTextTime': DateTime.now().millisecondsSinceEpoch,
        })
        .whereEqual('conversationID', conversationID);
  }

  /// 清空会话未读数
  Future<void> clearConversationUnreadCount(String conversationID) async {
    await toStore
        .update(DbTableName.localConversation, {'unreadCount': 0})
        .whereEqual('conversationID', conversationID);
  }

  /// 清空所有会话未读数
  Future<void> clearAllUnreadCounts() async {
    await toStore.update(DbTableName.localConversation, {'unreadCount': 0});
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
  Future<void> insertMessage(Map<String, dynamic> msgData) async {
    await toStore.upsert(DbTableName.localChatLog, msgData);
  }

  /// 批量插入消息
  Future<void> batchInsertMessages(List<Map<String, dynamic>> msgList) async {
    if (msgList.isEmpty) return;
    await toStore.batchUpsert(DbTableName.localChatLog, msgList);
  }

  /// 根据 clientMsgID 获取消息
  Future<Message?> getMessage(String clientMsgID) async {
    final data = await toStore
        .query(DbTableName.localChatLog)
        .whereEqual('clientMsgID', clientMsgID)
        .first();
    return data != null ? _convertMessage(data) : null;
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

    // 根据 Go 客户端逻辑，严格在 Dart 端过滤掉包括 startMsg 及时间更新的消息：
    // 条件：send_time < ? OR (send_time = ? AND (seq < ? OR (seq = 0 AND client_msg_id != ?)))
    if (startTime > 0 && dataList.isNotEmpty) {
      dataList = dataList.where((record) {
        final int sendTime = record['sendTime'] ?? 0;
        final int seq = record['seq'] ?? 0;
        final String clientMsgID = record['clientMsgID'] ?? '';

        if (sendTime < startTime) return true;
        if (sendTime == startTime) {
          if (startSeq > 0) return seq < startSeq;
          return seq == 0 && clientMsgID != startClientMsgID;
        }
        return false;
      }).toList();
    }

    return dataList.take(count).toList().map(_convertMessage).toList();
  }

  /// 更新消息状态
  Future<void> updateMessageStatus(String clientMsgID, int status) async {
    await toStore
        .update(DbTableName.localChatLog, {'status': status})
        .whereEqual('clientMsgID', clientMsgID);
  }

  /// 更新消息（通用）
  Future<void> updateMessage(String clientMsgID, Map<String, dynamic> data) async {
    await toStore.update(DbTableName.localChatLog, data).whereEqual('clientMsgID', clientMsgID);
  }

  /// 删除消息
  Future<void> deleteMessage(String clientMsgID) async {
    await toStore.delete(DbTableName.localChatLog).whereEqual('clientMsgID', clientMsgID);
  }

  /// 删除会话所有消息（按 conversationID 单条件删除）
  Future<void> deleteConversationAllMessages(String conversationID) async {
    await toStore.delete(DbTableName.localChatLog).whereEqual('conversationID', conversationID);
  }

  /// 删除所有本地消息
  Future<void> deleteAllMessages() async {
    await toStore.delete(DbTableName.localChatLog).allowDeleteAll();
  }

  /// 搜索本地消息
  /// 始终以 conversationID 作为首要过滤条件（单索引），其余条件在 Dart 层过滤，
  /// 避免 Tostore 多索引优化器 bug。
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

    if (keyword != null && keyword.isNotEmpty) {
      query = query.whereLike('content', '%$keyword%');
    }

    if (messageTypes != null && messageTypes.isNotEmpty) {
      query = query.whereIn('contentType', messageTypes);
    }

    if (startTime != null && startTime > 0) {
      query = query.whereGreaterThanOrEqualTo('sendTime', startTime);
    }

    if (endTime != null && endTime > 0) {
      query = query.whereLessThanOrEqualTo('sendTime', endTime);
    }

    final result = await query.orderByDesc('sendTime').offset(offset).limit(count);
    return result.data.map(_convertMessage).toList();
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
  Future<void> markMessagesAsRead(List<String> clientMsgIDs) async {
    if (clientMsgIDs.isEmpty) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    await toStore
        .update(DbTableName.localChatLog, {'isRead': true, 'hasReadTime': now})
        .whereIn('clientMsgID', clientMsgIDs);
  }

  // ---------------------------------------------------------------------------
  // SendingMessage 操作 - 对应 Go SDK SendingMessagesModel
  // ---------------------------------------------------------------------------

  /// 插入发送中消息
  Future<void> insertSendingMessage(String clientMsgID, String conversationID) async {
    await toStore.upsert(DbTableName.localSendingMessage, {
      'clientMsgID': clientMsgID,
      'conversationID': conversationID,
    });
  }

  /// 删除发送中消息
  Future<void> deleteSendingMessage(String clientMsgID) async {
    await toStore.delete(DbTableName.localSendingMessage).whereEqual('clientMsgID', clientMsgID);
  }

  /// 获取会话的发送中消息列表
  Future<List<Map<String, dynamic>>> getSendingMessages(String conversationID) async {
    final result = await toStore
        .query(DbTableName.localSendingMessage)
        .whereEqual('conversationID', conversationID);
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
  Future<void> updateGroup(String groupID, Map<String, dynamic> data) async {
    await toStore.update(DbTableName.localGroup, data).whereEqual('groupID', groupID);
  }

  /// 更新群成员部分字段
  Future<void> updateGroupMember(String groupID, String userID, Map<String, dynamic> data) async {
    await toStore
        .update(DbTableName.localGroupMember, data)
        .whereEqual('groupID', groupID)
        .whereEqual('userID', userID);
  }

  /// 更新好友部分字段
  Future<void> updateFriend(String friendUserID, Map<String, dynamic> data) async {
    await toStore.update(DbTableName.localFriend, data).whereEqual('friendUserID', friendUserID);
  }

  /// 获取会话的 maxSeq（不在 ConversationInfo 模型中的 DB 字段）
  Future<int> getConversationMaxSeq(String conversationID) async {
    final data = await toStore
        .query(DbTableName.localConversation)
        .whereEqual('conversationID', conversationID)
        .first();
    return (data?['maxSeq'] as int?) ?? 0;
  }

  /// 保存会话对象到数据库
  Future<void> saveConversation(ConversationInfo conversation) async {
    await toStore.upsert(DbTableName.localConversation, conversationToDbMap(conversation));
  }

  /// 批量保存会话对象到数据库
  Future<void> batchSaveConversations(List<ConversationInfo> conversations) async {
    if (conversations.isEmpty) return;
    await toStore.batchUpsert(
      DbTableName.localConversation,
      conversations.map(conversationToDbMap).toList(),
    );
  }

  /// 保存消息对象到数据库
  Future<void> saveMessage(Message message) async {
    await toStore.upsert(DbTableName.localChatLog, messageToDbMap(message));
  }

  /// 批量保存消息对象到数据库
  Future<void> batchSaveMessages(List<Message> messages) async {
    if (messages.isEmpty) return;
    await toStore.batchUpsert(DbTableName.localChatLog, messages.map(messageToDbMap).toList());
  }

  // ---------------------------------------------------------------------------
  // 模型转换：数据库 Map ↔ 模型对象
  // ---------------------------------------------------------------------------

  /// 数据库 Map 转 FriendInfo
  FriendInfo _convertFriendInfo(Map<String, dynamic> data) {
    return FriendInfo(
      ownerUserID: data['ownerUserID'] as String?,
      userID: data['friendUserID'] as String?,
      nickname: data['nickname'] as String?,
      faceURL: data['faceURL'] as String?,
      friendUserID: data['friendUserID'] as String?,
      remark: data['remark'] as String?,
      ex: data['ex'] as String?,
      createTime: data['createTime'] as int?,
      addSource: data['addSource'] as int?,
      operatorUserID: data['operatorUserID'] as String?,
    );
  }

  /// 数据库 Map 转 FriendApplicationInfo
  FriendApplicationInfo _convertFriendApplicationInfo(Map<String, dynamic> data) {
    return FriendApplicationInfo(
      fromUserID: data['fromUserID'] as String?,
      fromNickname: data['fromNickname'] as String?,
      fromFaceURL: data['fromFaceURL'] as String?,
      toUserID: data['toUserID'] as String?,
      toNickname: data['toNickname'] as String?,
      toFaceURL: data['toFaceURL'] as String?,
      handleResult: data['handleResult'] as int?,
      reqMsg: data['reqMsg'] as String?,
      createTime: data['createTime'] as int?,
      handlerUserID: data['handlerUserID'] as String?,
      handleMsg: data['handleMsg'] as String?,
      handleTime: data['handleTime'] as int?,
      ex: data['ex'] as String?,
    );
  }

  /// 数据库 Map 转 GroupInfo
  GroupInfo _convertGroupInfo(Map<String, dynamic> data) {
    return GroupInfo(
      groupID: (data['groupID'] as String?) ?? '',
      groupName: data['groupName'] as String?,
      notification: data['notification'] as String?,
      introduction: data['introduction'] as String?,
      faceURL: data['faceURL'] as String?,
      ownerUserID: data['ownerUserID'] as String?,
      createTime: data['createTime'] as int?,
      memberCount: data['memberCount'] as int?,
      status: _intToGroupStatus(data['status'] as int?),
      creatorUserID: data['creatorUserID'] as String?,
      groupType: _intToGroupType(data['groupType'] as int?),
      ex: data['ex'] as String?,
      needVerification: _intToGroupVerification(data['needVerification'] as int?),
      lookMemberInfo: data['lookMemberInfo'] as int?,
      applyMemberFriend: data['applyMemberFriend'] as int?,
      notificationUpdateTime: data['notificationUpdateTime'] as int?,
      notificationUserID: data['notificationUserID'] as String?,
    );
  }

  /// 数据库 Map 转 GroupMembersInfo
  GroupMembersInfo _convertGroupMembersInfo(Map<String, dynamic> data) {
    return GroupMembersInfo(
      groupID: data['groupID'] as String?,
      userID: data['userID'] as String?,
      nickname: data['nickname'] as String?,
      faceURL: data['faceURL'] as String?,
      roleLevel: _intToGroupRoleLevel(data['roleLevel'] as int?),
      joinTime: data['joinTime'] as int?,
      joinSource: _intToJoinSource(data['joinSource'] as int?),
      muteEndTime: data['muteEndTime'] as int?,
      inviterUserID: data['inviterUserID'] as String?,
      operatorUserID: data['operatorUserID'] as String?,
      ex: data['ex'] as String?,
    );
  }

  /// 数据库 Map 转 GroupApplicationInfo
  GroupApplicationInfo _convertGroupApplicationInfo(Map<String, dynamic> data) {
    return GroupApplicationInfo(
      groupID: data['groupID'] as String?,
      groupName: data['groupName'] as String?,
      groupFaceURL: data['groupFaceURL'] as String?,
      userID: data['userID'] as String?,
      nickname: data['nickname'] as String?,
      userFaceURL: data['userFaceURL'] as String?,
      handleResult: data['handleResult'] as int?,
      reqMsg: data['reqMsg'] as String?,
      reqTime: data['reqTime'] as int?,
      handleUserID: data['handleUserID'] as String?,
      handledMsg: data['handledMsg'] as String?,
      handledTime: data['handledTime'] as int?,
      ex: data['ex'] as String?,
      joinSource: _intToJoinSource(data['joinSource'] as int?),
      inviterUserID: data['inviterUserID'] as String?,
    );
  }

  /// 数据库 Map 转 ConversationInfo
  ConversationInfo _convertConversation(Map<String, dynamic> data) {
    final latestMsgStr = data['latestMsg'] as String?;
    Message? latestMsg;
    if (latestMsgStr != null && latestMsgStr.isNotEmpty) {
      try {
        final rawMap = jsonDecode(latestMsgStr) as Map<String, dynamic>;
        latestMsg = _convertMessage(_normalizeRawMsg(rawMap));
      } catch (_) {}
    }

    return ConversationInfo(
      conversationID: data['conversationID'] as String,
      conversationType: _intToConversationType(data['conversationType'] as int?),
      userID: data['userID'] as String?,
      groupID: data['groupID'] as String?,
      showName: data['showName'] as String?,
      faceURL: data['faceURL'] as String?,
      recvMsgOpt: _intToReceiveMessageOpt(data['recvMsgOpt'] as int?),
      unreadCount: (data['unreadCount'] as int?) ?? 0,
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
      groupAtType: _intToGroupAtType(data['groupAtType'] as int?),
    );
  }

  /// ConversationInfo 转数据库 Map
  static Map<String, dynamic> conversationToDbMap(ConversationInfo c) {
    return {
      'conversationID': c.conversationID,
      'conversationType': c.conversationType?.value,
      'userID': c.userID,
      'groupID': c.groupID,
      'showName': c.showName,
      'faceURL': c.faceURL,
      'recvMsgOpt': c.recvMsgOpt?.value,
      'unreadCount': c.unreadCount,
      'latestMsg': c.latestMsg != null ? jsonEncode(c.latestMsg!.toJson()) : null,
      'latestMsgSendTime': c.latestMsgSendTime,
      'draftText': c.draftText,
      'draftTextTime': c.draftTextTime,
      'isPinned': c.isPinned,
      'isPrivateChat': c.isPrivateChat,
      'burnDuration': c.burnDuration,
      'isMsgDestruct': c.isMsgDestruct,
      'msgDestructTime': c.msgDestructTime,
      'ex': c.ex,
      'isNotInGroup': c.isNotInGroup,
      'groupAtType': c.groupAtType?.value,
    };
  }

  /// 数据库 Map 转 Message 对象
  Message _convertMessage(Map<String, dynamic> data) {
    final contentTypeValue = data['contentType'] as int?;
    final content = data['content'] as String?;
    Map<String, dynamic>? contentMap;
    if (content != null && content.isNotEmpty) {
      try {
        contentMap = jsonDecode(content) as Map<String, dynamic>;
      } catch (_) {
        try {
          contentMap = jsonDecode(utf8.decode(base64Decode(content))) as Map<String, dynamic>;
        } catch (_) {}
      }
    }

    return Message(
      clientMsgID: data['clientMsgID'] as String?,
      serverMsgID: data['serverMsgID'] as String?,
      createTime: data['createTime'] as int?,
      sendTime: data['sendTime'] as int?,
      sessionType: _intToConversationType(data['sessionType'] as int?),
      sendID: data['sendID'] as String?,
      recvID: data['recvID'] as String?,
      msgFrom: data['msgFrom'] as int?,
      contentType: _intToMessageType(contentTypeValue),
      senderPlatformID: _intToIMPlatform(data['senderPlatformID'] as int?),
      senderNickname: data['senderNickname'] as String?,
      senderFaceUrl: data['senderFaceUrl'] as String?,
      groupID: data['groupID'] as String?,
      localEx: data['localEx'] as String?,
      seq: data['seq'] as int?,
      isRead: data['isRead'] as bool?,
      hasReadTime: data['hasReadTime'] as int?,
      status: _intToMessageStatus(data['status'] as int?),
      isReact: data['isReact'] as bool?,
      isExternalExtensions: data['isExternalExtensions'] as bool?,
      attachedInfo: data['attachedInfo'] as String?,
      ex: data['ex'] as String?,
      textElem: contentTypeValue == MessageType.text.value && contentMap != null
          ? TextElem.fromJson(contentMap)
          : null,
      pictureElem: contentTypeValue == MessageType.picture.value && contentMap != null
          ? PictureElem.fromJson(contentMap)
          : null,
      soundElem: contentTypeValue == MessageType.voice.value && contentMap != null
          ? SoundElem.fromJson(contentMap)
          : null,
      videoElem: contentTypeValue == MessageType.video.value && contentMap != null
          ? VideoElem.fromJson(contentMap)
          : null,
      fileElem: contentTypeValue == MessageType.file.value && contentMap != null
          ? FileElem.fromJson(contentMap)
          : null,
      locationElem: contentTypeValue == MessageType.location.value && contentMap != null
          ? LocationElem.fromJson(contentMap)
          : null,
      customElem: contentTypeValue == MessageType.custom.value && contentMap != null
          ? CustomElem.fromJson(contentMap)
          : null,
      quoteElem: contentTypeValue == MessageType.quote.value && contentMap != null
          ? QuoteElem.fromJson(contentMap)
          : null,
      mergeElem: contentTypeValue == MessageType.merger.value && contentMap != null
          ? MergeElem.fromJson(contentMap)
          : null,
      faceElem: contentTypeValue == MessageType.customFace.value && contentMap != null
          ? FaceElem.fromJson(contentMap)
          : null,
      cardElem: contentTypeValue == MessageType.card.value && contentMap != null
          ? CardElem.fromJson(contentMap)
          : null,
      atTextElem: contentTypeValue == MessageType.atText.value && contentMap != null
          ? AtTextElem.fromJson(contentMap)
          : null,
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

  // ---------------------------------------------------------------------------
  // 枚举转换辅助方法
  // ---------------------------------------------------------------------------

  static ConversationType? _intToConversationType(int? value) {
    if (value == null) return null;
    return ConversationType.values.cast<ConversationType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  static ReceiveMessageOpt? _intToReceiveMessageOpt(int? value) {
    if (value == null) return null;
    return ReceiveMessageOpt.values.cast<ReceiveMessageOpt?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  static GroupAtType? _intToGroupAtType(int? value) {
    if (value == null) return null;
    return GroupAtType.values.cast<GroupAtType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  static GroupType? _intToGroupType(int? value) {
    if (value == null) return null;
    return GroupType.values.cast<GroupType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  static GroupStatus? _intToGroupStatus(int? value) {
    if (value == null) return null;
    return GroupStatus.values.cast<GroupStatus?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  static GroupVerification? _intToGroupVerification(int? value) {
    if (value == null) return null;
    return GroupVerification.values.cast<GroupVerification?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  static GroupRoleLevel? _intToGroupRoleLevel(int? value) {
    if (value == null) return null;
    return GroupRoleLevel.values.cast<GroupRoleLevel?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  static JoinSource? _intToJoinSource(int? value) {
    if (value == null) return null;
    return JoinSource.values.cast<JoinSource?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  static MessageType? _intToMessageType(int? value) {
    if (value == null) return null;
    return MessageType.values.cast<MessageType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  static MessageStatus? _intToMessageStatus(int? value) {
    if (value == null) return null;
    return MessageStatus.values.cast<MessageStatus?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  static IMPlatform? _intToIMPlatform(int? value) {
    if (value == null) return null;
    return IMPlatform.values.cast<IMPlatform?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
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
}
