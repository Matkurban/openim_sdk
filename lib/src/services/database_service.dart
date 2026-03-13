import 'dart:convert';

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
  Future<Map<String, dynamic>?> getLoginUser() async {
    return toStore.query(DbTableName.localUser).whereEqual('userID', currentUserID).first();
  }

  /// 批量获取用户信息
  Future<List<Map<String, dynamic>>> getUsersByIDs(List<String> userIDs) async {
    if (userIDs.isEmpty) return [];
    final result = await toStore.query(DbTableName.localUser).whereIn('userID', userIDs);
    return result.data;
  }

  // ---------------------------------------------------------------------------
  // Friend 操作 - 对应 Go SDK FriendModel
  // ---------------------------------------------------------------------------

  /// 插入或更新好友
  Future<void> upsertFriend(Map<String, dynamic> friendData) async {
    await toStore.upsert(DbTableName.localFriend, friendData);
  }

  /// 获取所有好友列表
  Future<List<Map<String, dynamic>>> getAllFriends() async {
    final result = await toStore
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', currentUserID);
    return result.data;
  }

  /// 分页获取好友列表
  Future<List<Map<String, dynamic>>> getFriendsPage(int offset, int count) async {
    final result = await toStore
        .query(DbTableName.localFriend)
        .whereEqual('ownerUserID', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data;
  }

  /// 根据好友用户ID获取好友信息
  Future<Map<String, dynamic>?> getFriendByUserID(String friendUserID) async {
    return toStore.query(DbTableName.localFriend).whereEqual('friendUserID', friendUserID).first();
  }

  /// 批量根据好友用户ID获取好友信息
  Future<List<Map<String, dynamic>>> getFriendsByUserIDs(List<String> userIDs) async {
    if (userIDs.isEmpty) return [];
    final result = await toStore.query(DbTableName.localFriend).whereIn('friendUserID', userIDs);
    return result.data;
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
  Future<List<Map<String, dynamic>>> searchFriends(
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
    return result.data;
  }

  // ---------------------------------------------------------------------------
  // FriendRequest 操作
  // ---------------------------------------------------------------------------

  /// 插入或更新好友申请
  Future<void> upsertFriendRequest(Map<String, dynamic> data) async {
    await toStore.upsert(DbTableName.localFriendRequest, data);
  }

  /// 获取收到的好友申请列表
  Future<List<Map<String, dynamic>>> getFriendRequestsAsRecipient({
    int offset = 0,
    int count = 40,
  }) async {
    final result = await toStore
        .query(DbTableName.localFriendRequest)
        .whereEqual('toUserID', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data;
  }

  /// 获取已发送的好友申请列表
  Future<List<Map<String, dynamic>>> getFriendRequestsAsApplicant({
    int offset = 0,
    int count = 40,
  }) async {
    final result = await toStore
        .query(DbTableName.localFriendRequest)
        .whereEqual('fromUserID', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data;
  }

  // ---------------------------------------------------------------------------
  // Black 操作 - 对应 Go SDK FriendModel(黑名单部分)
  // ---------------------------------------------------------------------------

  /// 插入黑名单
  Future<void> insertBlack(Map<String, dynamic> data) async {
    await toStore.upsert(DbTableName.localBlack, data);
  }

  /// 获取黑名单列表
  Future<List<Map<String, dynamic>>> getBlackList() async {
    final result = await toStore
        .query(DbTableName.localBlack)
        .whereEqual('ownerUserID', currentUserID);
    return result.data;
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
  Future<List<Map<String, dynamic>>> getJoinedGroupList() async {
    final result = await toStore.query(DbTableName.localGroup);
    return result.data;
  }

  /// 分页获取已加入的群组列表
  Future<List<Map<String, dynamic>>> getJoinedGroupListPage(int offset, int count) async {
    final result = await toStore.query(DbTableName.localGroup).limit(count).offset(offset);
    return result.data;
  }

  /// 根据群组ID获取群组信息
  Future<Map<String, dynamic>?> getGroupByID(String groupID) async {
    return toStore.query(DbTableName.localGroup).whereEqual('groupID', groupID).first();
  }

  /// 根据群组ID列表获取群组信息
  Future<List<Map<String, dynamic>>> getGroupsByIDs(List<String> groupIDs) async {
    if (groupIDs.isEmpty) return [];
    final result = await toStore.query(DbTableName.localGroup).whereIn('groupID', groupIDs);
    return result.data;
  }

  /// 删除群组
  Future<void> deleteGroup(String groupID) async {
    await toStore.delete(DbTableName.localGroup).whereEqual('groupID', groupID);
  }

  /// 搜索群组（利用 Tostore LIKE 查询）
  Future<List<Map<String, dynamic>>> searchGroups(
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
    return result.data;
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
  Future<List<Map<String, dynamic>>> getGroupMembers(String groupID) async {
    final result = await toStore.query(DbTableName.localGroupMember).whereEqual('groupID', groupID);
    return result.data;
  }

  /// 分页获取群成员列表
  Future<List<Map<String, dynamic>>> getGroupMembersPage(
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
    return result.data;
  }

  /// 获取群组 Owner 和 Admin
  Future<List<Map<String, dynamic>>> getGroupOwnerAndAdmin(String groupID) async {
    final result = await toStore
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .whereIn('roleLevel', [60, 100]);
    return result.data;
  }

  /// 获取指定群成员信息
  Future<Map<String, dynamic>?> getGroupMember(String groupID, String userID) async {
    return toStore
        .query(DbTableName.localGroupMember)
        .whereEqual('groupID', groupID)
        .whereEqual('userID', userID)
        .first();
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
  Future<List<Map<String, dynamic>>> searchGroupMembers(
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
    return result.data;
  }

  // ---------------------------------------------------------------------------
  // GroupRequest 操作
  // ---------------------------------------------------------------------------

  /// 插入或更新群申请
  Future<void> upsertGroupRequest(Map<String, dynamic> data) async {
    await toStore.upsert(DbTableName.localGroupRequest, data);
  }

  /// 获取作为接收者的群申请列表
  Future<List<Map<String, dynamic>>> getGroupRequestsAsRecipient({
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
    return result.data;
  }

  /// 获取作为申请者的群申请列表
  Future<List<Map<String, dynamic>>> getGroupRequestsAsApplicant({
    int offset = 0,
    int count = 40,
  }) async {
    final result = await toStore
        .query(DbTableName.localGroupRequest)
        .whereEqual('userID', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data;
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
  Future<List<Map<String, dynamic>>> getAllConversations() async {
    final result = await toStore.query(DbTableName.localConversation);
    return result.data;
  }

  /// 分页获取会话列表
  Future<List<Map<String, dynamic>>> getConversationsPage(int offset, int count) async {
    final result = await toStore.query(DbTableName.localConversation).limit(count).offset(offset);
    return result.data;
  }

  /// 根据会话ID获取单个会话
  Future<Map<String, dynamic>?> getConversation(String conversationID) async {
    return toStore
        .query(DbTableName.localConversation)
        .whereEqual('conversationID', conversationID)
        .first();
  }

  /// 根据会话ID列表获取多个会话
  Future<List<Map<String, dynamic>>> getMultipleConversations(List<String> conversationIDs) async {
    if (conversationIDs.isEmpty) return [];
    final result = await toStore
        .query(DbTableName.localConversation)
        .whereIn('conversationID', conversationIDs);
    return result.data;
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
  Future<List<Map<String, dynamic>>> searchConversations(String keyword) async {
    if (keyword.isEmpty) return [];
    final result = await toStore
        .query(DbTableName.localConversation)
        .whereLike('showName', '%$keyword%');
    return result.data;
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
  Future<Map<String, dynamic>?> getMessage(String clientMsgID) async {
    return toStore.query(DbTableName.localChatLog).whereEqual('clientMsgID', clientMsgID).first();
  }

  /// 获取会话的历史消息（按发送时间倒序）
  /// [conversationID] 会话ID
  /// [startTime] 起始时间戳（毫秒），0 表示从最新开始
  /// [count] 获取条数
  Future<List<Map<String, dynamic>>> getHistoryMessages({
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

    return dataList.take(count).toList();
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
  Future<List<Map<String, dynamic>>> searchMessages({
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
    return result.data;
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
}
