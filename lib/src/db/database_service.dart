import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:tostore/tostore.dart';

import 'db_schema.dart';

/// 数据库服务层
/// 封装 Tostore 操作，提供统一的本地数据库访问接口。
/// 对应 Go SDK 中 pkg/db/ 下的数据库接口抽象。
class DatabaseService {
  static final Logger _log = Logger('DatabaseService');

  ToStore? _db;
  String? _currentUserID;

  /// 获取数据库实例，未初始化时抛出异常
  ToStore get db {
    if (_db == null) {
      throw StateError('数据库未初始化，请先调用 init()');
    }
    return _db!;
  }

  /// 当前登录用户ID
  String get currentUserID {
    if (_currentUserID == null) {
      throw StateError('用户未登录');
    }
    return _currentUserID!;
  }

  /// 数据库是否已初始化
  bool get isInitialized => _db != null;

  /// 初始化数据库
  /// [userID] 用户ID，用于数据空间隔离
  /// [dataDir] 数据存储目录
  Future<void> init({required String userID, String? dataDir}) async {
    _currentUserID = userID;
    _db = await ToStore.open(
      dbPath: dataDir,
      dbName: 'openim_$userID',
      schemas: DbSchema.allSchemas,
    );
    _log.info('数据库初始化完成: userID=$userID');
  }

  /// 关闭数据库
  Future<void> close() async {
    await _db?.close();
    _db = null;
    _currentUserID = null;
    _log.info('数据库已关闭');
  }

  // ---------------------------------------------------------------------------
  // 通用 CRUD 操作
  // ---------------------------------------------------------------------------

  /// 插入一条记录
  Future<DbResult> insert(String table, Map<String, dynamic> data) {
    return db.insert(table, data);
  }

  /// 批量插入记录
  Future<DbResult> batchInsert(String table, List<Map<String, dynamic>> dataList) {
    return db.batchInsert(table, dataList);
  }

  /// 插入或更新记录（upsert）
  Future<DbResult> upsert(String table, Map<String, dynamic> data) {
    return db.upsert(table, data);
  }

  /// 批量插入或更新记录
  Future<DbResult> batchUpsert(String table, List<Map<String, dynamic>> dataList) {
    return db.batchUpsert(table, dataList);
  }

  /// 根据主键查询单条记录
  Future<Map<String, dynamic>?> queryByPrimaryKey(String table, dynamic pk) async {
    return db.query(table).where('', '=', pk).first();
  }

  /// 查询表中所有记录
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final result = await db.query(table);
    return result.data;
  }

  /// 根据条件删除记录
  Future<void> deleteByPrimaryKey(String table, String pkField, dynamic pkValue) async {
    await db.delete(table).where(pkField, '=', pkValue);
  }

  /// 在事务中执行操作
  Future<TransactionResult> transaction(Future<void> Function() action) {
    return db.transaction(action);
  }

  // ---------------------------------------------------------------------------
  // User 操作 - 对应 Go SDK UserModel
  // ---------------------------------------------------------------------------

  /// 插入或更新本地用户信息
  Future<void> insertOrUpdateUser(Map<String, dynamic> userData) async {
    await db.upsert(DbTableName.localUser, userData);
  }

  /// 获取当前登录用户信息
  Future<Map<String, dynamic>?> getLoginUser() async {
    return db.query(DbTableName.localUser).where('userID', '=', currentUserID).first();
  }

  /// 批量获取用户信息
  Future<List<Map<String, dynamic>>> getUsersByIDs(List<String> userIDs) async {
    if (userIDs.isEmpty) return [];
    final result = await db.query(DbTableName.localUser).where('userID', 'IN', userIDs);
    return result.data;
  }

  // ---------------------------------------------------------------------------
  // Friend 操作 - 对应 Go SDK FriendModel
  // ---------------------------------------------------------------------------

  /// 插入或更新好友
  Future<void> upsertFriend(Map<String, dynamic> friendData) async {
    await db.upsert(DbTableName.localFriend, friendData);
  }

  /// 获取所有好友列表
  Future<List<Map<String, dynamic>>> getAllFriends() async {
    final result = await db.query(DbTableName.localFriend).where('ownerUserID', '=', currentUserID);
    return result.data;
  }

  /// 分页获取好友列表
  Future<List<Map<String, dynamic>>> getFriendsPage(int offset, int count) async {
    final result = await db
        .query(DbTableName.localFriend)
        .where('ownerUserID', '=', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data;
  }

  /// 根据好友用户ID获取好友信息
  Future<Map<String, dynamic>?> getFriendByUserID(String friendUserID) async {
    return db.query(DbTableName.localFriend).where('friendUserID', '=', friendUserID).first();
  }

  /// 删除好友
  Future<void> deleteFriend(String friendUserID) async {
    await db.delete(DbTableName.localFriend).where('friendUserID', '=', friendUserID);
  }

  /// 批量插入或更新好友
  Future<void> batchUpsertFriends(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) return;
    await db.batchUpsert(DbTableName.localFriend, dataList);
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

    var cond = QueryCondition().where(fields.first, 'LIKE', pattern);
    for (int i = 1; i < fields.length; i++) {
      cond = cond.or().where(fields[i], 'LIKE', pattern);
    }

    final result = await db
        .query(DbTableName.localFriend)
        .where('ownerUserID', '=', currentUserID)
        .condition(cond);
    return result.data;
  }

  // ---------------------------------------------------------------------------
  // FriendRequest 操作
  // ---------------------------------------------------------------------------

  /// 插入或更新好友申请
  Future<void> upsertFriendRequest(Map<String, dynamic> data) async {
    await db.upsert(DbTableName.localFriendRequest, data);
  }

  /// 获取收到的好友申请列表
  Future<List<Map<String, dynamic>>> getFriendRequestsAsRecipient({
    int offset = 0,
    int count = 40,
  }) async {
    final result = await db
        .query(DbTableName.localFriendRequest)
        .where('toUserID', '=', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data;
  }

  /// 获取已发送的好友申请列表
  Future<List<Map<String, dynamic>>> getFriendRequestsAsApplicant({
    int offset = 0,
    int count = 40,
  }) async {
    final result = await db
        .query(DbTableName.localFriendRequest)
        .where('fromUserID', '=', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data;
  }

  // ---------------------------------------------------------------------------
  // Black 操作 - 对应 Go SDK FriendModel(黑名单部分)
  // ---------------------------------------------------------------------------

  /// 插入黑名单
  Future<void> insertBlack(Map<String, dynamic> data) async {
    await db.upsert(DbTableName.localBlack, data);
  }

  /// 获取黑名单列表
  Future<List<Map<String, dynamic>>> getBlackList() async {
    final result = await db.query(DbTableName.localBlack).where('ownerUserID', '=', currentUserID);
    return result.data;
  }

  /// 移除黑名单
  Future<void> removeBlack(String blockUserID) async {
    await db
        .delete(DbTableName.localBlack)
        .where('ownerUserID', '=', currentUserID)
        .where('blockUserID', '=', blockUserID);
  }

  // ---------------------------------------------------------------------------
  // Group 操作 - 对应 Go SDK GroupModel
  // ---------------------------------------------------------------------------

  /// 插入或更新群组
  Future<void> upsertGroup(Map<String, dynamic> data) async {
    await db.upsert(DbTableName.localGroup, data);
  }

  /// 批量插入或更新群组
  Future<void> batchUpsertGroups(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) return;
    await db.batchUpsert(DbTableName.localGroup, dataList);
  }

  /// 获取已加入的群组列表
  Future<List<Map<String, dynamic>>> getJoinedGroupList() async {
    final result = await db.query(DbTableName.localGroup);
    return result.data;
  }

  /// 分页获取已加入的群组列表
  Future<List<Map<String, dynamic>>> getJoinedGroupListPage(int offset, int count) async {
    final result = await db.query(DbTableName.localGroup).limit(count).offset(offset);
    return result.data;
  }

  /// 根据群组ID获取群组信息
  Future<Map<String, dynamic>?> getGroupByID(String groupID) async {
    return db.query(DbTableName.localGroup).where('groupID', '=', groupID).first();
  }

  /// 根据群组ID列表获取群组信息
  Future<List<Map<String, dynamic>>> getGroupsByIDs(List<String> groupIDs) async {
    if (groupIDs.isEmpty) return [];
    final result = await db.query(DbTableName.localGroup).where('groupID', 'IN', groupIDs);
    return result.data;
  }

  /// 删除群组
  Future<void> deleteGroup(String groupID) async {
    await db.delete(DbTableName.localGroup).where('groupID', '=', groupID);
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

    var cond = QueryCondition().where(fields.first, 'LIKE', pattern);
    for (int i = 1; i < fields.length; i++) {
      cond = cond.or().where(fields[i], 'LIKE', pattern);
    }

    final result = await db.query(DbTableName.localGroup).condition(cond);
    return result.data;
  }

  // ---------------------------------------------------------------------------
  // GroupMember 操作
  // ---------------------------------------------------------------------------

  /// 插入或更新群成员
  Future<void> upsertGroupMember(Map<String, dynamic> data) async {
    await db.upsert(DbTableName.localGroupMember, data);
  }

  /// 批量插入或更新群成员
  Future<void> batchUpsertGroupMembers(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) return;
    await db.batchUpsert(DbTableName.localGroupMember, dataList);
  }

  /// 获取群成员列表
  Future<List<Map<String, dynamic>>> getGroupMembers(String groupID) async {
    final result = await db.query(DbTableName.localGroupMember).where('groupID', '=', groupID);
    return result.data;
  }

  /// 分页获取群成员列表
  Future<List<Map<String, dynamic>>> getGroupMembersPage(
    String groupID, {
    int offset = 0,
    int count = 40,
    int? filter,
  }) async {
    var query = db.query(DbTableName.localGroupMember).where('groupID', '=', groupID);
    if (filter != null && filter > 0) {
      query = query.where('roleLevel', '=', filter);
    }
    final result = await query.limit(count).offset(offset);
    return result.data;
  }

  /// 获取群组 Owner 和 Admin
  Future<List<Map<String, dynamic>>> getGroupOwnerAndAdmin(String groupID) async {
    final result = await db
        .query(DbTableName.localGroupMember)
        .where('groupID', '=', groupID)
        .where('roleLevel', 'IN', [60, 100]);
    return result.data;
  }

  /// 获取指定群成员信息
  Future<Map<String, dynamic>?> getGroupMember(String groupID, String userID) async {
    final result = await db
        .query(DbTableName.localGroupMember)
        .where('groupID', '=', groupID)
        .where('userID', '=', userID);
    return result.data.isEmpty ? null : result.data.first;
  }

  /// 删除群成员
  Future<void> deleteGroupMember(String groupID, String userID) async {
    await db
        .delete(DbTableName.localGroupMember)
        .where('groupID', '=', groupID)
        .where('userID', '=', userID);
  }

  /// 删除群组的所有成员
  Future<void> deleteGroupAllMembers(String groupID) async {
    await db.delete(DbTableName.localGroupMember).where('groupID', '=', groupID);
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

    var cond = QueryCondition().where(fields.first, 'LIKE', pattern);
    for (int i = 1; i < fields.length; i++) {
      cond = cond.or().where(fields[i], 'LIKE', pattern);
    }

    final result = await db
        .query(DbTableName.localGroupMember)
        .where('groupID', '=', groupID)
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
    await db.upsert(DbTableName.localGroupRequest, data);
  }

  /// 获取作为接收者的群申请列表
  Future<List<Map<String, dynamic>>> getGroupRequestsAsRecipient({
    int offset = 0,
    int count = 40,
  }) async {
    // 查找当前用户是群主或管理员的群组ID
    final adminGroups = await db
        .query(DbTableName.localGroupMember)
        .where('userID', '=', currentUserID)
        .where('roleLevel', 'IN', [60, 100]);
    final myGroupIDs = adminGroups.data.map((m) => m['groupID'] as String).toList();

    if (myGroupIDs.isEmpty) return [];

    final result = await db
        .query(DbTableName.localGroupRequest)
        .where('groupID', 'IN', myGroupIDs)
        .offset(offset)
        .limit(count);
    return result.data;
  }

  /// 获取作为申请者的群申请列表
  Future<List<Map<String, dynamic>>> getGroupRequestsAsApplicant({
    int offset = 0,
    int count = 40,
  }) async {
    final result = await db
        .query(DbTableName.localGroupRequest)
        .where('userID', '=', currentUserID)
        .limit(count)
        .offset(offset);
    return result.data;
  }

  /// 获取未处理的好友申请数量
  Future<int> getFriendRequestUnhandledCount() async {
    return db
        .query(DbTableName.localFriendRequest)
        .where('toUserID', '=', currentUserID)
        .where('handleResult', '=', 0)
        .count();
  }

  /// 获取未处理的群申请数量
  Future<int> getGroupRequestUnhandledCount() async {
    final adminGroups = await db
        .query(DbTableName.localGroupMember)
        .where('userID', '=', currentUserID)
        .where('roleLevel', 'IN', [60, 100]);
    final myGroupIDs = adminGroups.data.map((m) => m['groupID'] as String).toList();
    if (myGroupIDs.isEmpty) return 0;

    return db
        .query(DbTableName.localGroupRequest)
        .where('groupID', 'IN', myGroupIDs)
        .where('handleResult', '=', 0)
        .count();
  }

  // ---------------------------------------------------------------------------
  // Conversation 操作 - 对应 Go SDK ConversationModel
  // ---------------------------------------------------------------------------

  /// 插入或更新会话
  Future<void> upsertConversation(Map<String, dynamic> data) async {
    await db.upsert(DbTableName.localConversation, data);
  }

  /// 批量插入或更新会话
  Future<void> batchUpsertConversations(List<Map<String, dynamic>> dataList) async {
    if (dataList.isEmpty) return;
    await db.batchUpsert(DbTableName.localConversation, dataList);
  }

  /// 删除所有会话
  Future<void> deleteAllConversations() async {
    await db.delete(DbTableName.localConversation);
  }

  /// 获取所有会话列表
  Future<List<Map<String, dynamic>>> getAllConversations() async {
    final result = await db.query(DbTableName.localConversation);
    return result.data;
  }

  /// 分页获取会话列表
  Future<List<Map<String, dynamic>>> getConversationsPage(int offset, int count) async {
    final result = await db.query(DbTableName.localConversation).limit(count).offset(offset);
    return result.data;
  }

  /// 根据会话ID获取单个会话
  Future<Map<String, dynamic>?> getConversation(String conversationID) async {
    return db
        .query(DbTableName.localConversation)
        .where('conversationID', '=', conversationID)
        .first();
  }

  /// 根据会话ID列表获取多个会话
  Future<List<Map<String, dynamic>>> getMultipleConversations(List<String> conversationIDs) async {
    if (conversationIDs.isEmpty) return [];
    final result = await db
        .query(DbTableName.localConversation)
        .where('conversationID', 'IN', conversationIDs);
    return result.data;
  }

  /// 删除会话
  Future<void> deleteConversation(String conversationID) async {
    await db.delete(DbTableName.localConversation).where('conversationID', '=', conversationID);
  }

  /// 更新会话属性
  Future<void> updateConversation(String conversationID, Map<String, dynamic> data) async {
    await db
        .update(DbTableName.localConversation, data)
        .where('conversationID', '=', conversationID);
  }

  /// 获取未读消息总数
  Future<int> getTotalUnreadCount() async {
    final total = await db.query(DbTableName.localConversation).sum('unreadCount');
    return total?.toInt() ?? 0;
  }

  /// 更新会话草稿
  Future<void> setConversationDraft(String conversationID, String draftText) async {
    await db
        .update(DbTableName.localConversation, {
          'draftText': draftText,
          'draftTextTime': DateTime.now().millisecondsSinceEpoch,
        })
        .where('conversationID', '=', conversationID);
  }

  /// 清空会话未读数
  Future<void> clearConversationUnreadCount(String conversationID) async {
    await db
        .update(DbTableName.localConversation, {'unreadCount': 0})
        .where('conversationID', '=', conversationID);
  }

  /// 清空所有会话未读数
  Future<void> clearAllUnreadCounts() async {
    await db.update(DbTableName.localConversation, {'unreadCount': 0});
  }

  /// 搜索会话（利用 Tostore LIKE 查询）
  Future<List<Map<String, dynamic>>> searchConversations(String keyword) async {
    if (keyword.isEmpty) return [];
    final result = await db
        .query(DbTableName.localConversation)
        .where('showName', 'LIKE', '%$keyword%');
    return result.data;
  }

  // ---------------------------------------------------------------------------
  // ChatLog (Message) 操作 - 对应 Go SDK MessageModel
  // ---------------------------------------------------------------------------

  /// 插入消息
  Future<void> insertMessage(Map<String, dynamic> msgData) async {
    await db.upsert(DbTableName.localChatLog, msgData);
  }

  /// 批量插入消息
  Future<void> batchInsertMessages(List<Map<String, dynamic>> msgList) async {
    if (msgList.isEmpty) return;
    await db.batchUpsert(DbTableName.localChatLog, msgList);
  }

  /// 根据 clientMsgID 获取消息
  Future<Map<String, dynamic>?> getMessage(String clientMsgID) async {
    return db.query(DbTableName.localChatLog).where('clientMsgID', '=', clientMsgID).first();
  }

  /// 获取会话的历史消息（按发送时间倒序）
  /// [startTime] 起始时间戳（毫秒），0 表示从最新开始
  /// [count] 获取条数
  Future<List<Map<String, dynamic>>> getHistoryMessages({
    required String sendID,
    required String recvID,
    String? groupID,
    required int sessionType,
    int startTime = 0,
    int count = 20,
  }) async {
    var query = db.query(DbTableName.localChatLog).where('sessionType', '=', sessionType);

    if (groupID != null && groupID.isNotEmpty) {
      query = query.where('groupID', '=', groupID);
    } else {
      // 单聊：sendID/recvID 互换都要查，使用 OR 条件下推到查询层
      query = query.condition(
        QueryCondition()
            .where('sendID', '=', sendID)
            .where('recvID', '=', recvID)
            .or()
            .where('sendID', '=', recvID)
            .where('recvID', '=', sendID),
      );
    }

    if (startTime > 0) {
      query = query.where('sendTime', '<', startTime);
    }

    final result = await query.orderByDesc('sendTime').limit(count);
    return result.data;
  }

  /// 更新消息状态
  Future<void> updateMessageStatus(String clientMsgID, int status) async {
    await db
        .update(DbTableName.localChatLog, {'status': status})
        .where('clientMsgID', '=', clientMsgID);
  }

  /// 更新消息（通用）
  Future<void> updateMessage(String clientMsgID, Map<String, dynamic> data) async {
    await db.update(DbTableName.localChatLog, data).where('clientMsgID', '=', clientMsgID);
  }

  /// 删除消息
  Future<void> deleteMessage(String clientMsgID) async {
    await db.delete(DbTableName.localChatLog).where('clientMsgID', '=', clientMsgID);
  }

  /// 删除会话所有消息
  Future<void> deleteConversationAllMessages({
    String? groupID,
    String? sendID,
    String? recvID,
    int? sessionType,
  }) async {
    if (groupID != null && groupID.isNotEmpty) {
      await db.delete(DbTableName.localChatLog).where('groupID', '=', groupID);
    } else if (sendID != null && recvID != null) {
      // 单聊：双向删除（发送方/接收方互换）
      await db
          .delete(DbTableName.localChatLog)
          .where('sendID', '=', sendID)
          .where('recvID', '=', recvID);
      await db
          .delete(DbTableName.localChatLog)
          .where('sendID', '=', recvID)
          .where('recvID', '=', sendID);
    }
  }

  /// 删除所有本地消息
  Future<void> deleteAllMessages() async {
    await db.delete(DbTableName.localChatLog);
  }

  /// 搜索本地消息（利用 Tostore 查询条件下推）
  Future<List<Map<String, dynamic>>> searchMessages({
    String? conversationID,
    String? keyword,
    List<int>? messageTypes,
    int? startTime,
    int? endTime,
    int offset = 0,
    int count = 40,
  }) async {
    var query = db.query(DbTableName.localChatLog);

    if (keyword != null && keyword.isNotEmpty) {
      query = query.where('content', 'LIKE', '%$keyword%');
    }

    if (messageTypes != null && messageTypes.isNotEmpty) {
      query = query.where('contentType', 'IN', messageTypes);
    }

    if (startTime != null && startTime > 0) {
      query = query.where('sendTime', '>=', startTime);
    }

    if (endTime != null && endTime > 0) {
      query = query.where('sendTime', '<=', endTime);
    }

    if (conversationID != null && conversationID.isNotEmpty) {
      if (conversationID.startsWith('sg_')) {
        query = query.where('groupID', '=', conversationID.substring(3));
      }
    }

    final result = await query.offset(offset).limit(count);
    return result.data;
  }

  /// 标记消息已读
  Future<void> markMessageAsRead(String clientMsgID) async {
    await db
        .update(DbTableName.localChatLog, {
          'isRead': true,
          'hasReadTime': DateTime.now().millisecondsSinceEpoch,
        })
        .where('clientMsgID', '=', clientMsgID);
  }

  /// 批量标记消息已读
  Future<void> markMessagesAsRead(List<String> clientMsgIDs) async {
    if (clientMsgIDs.isEmpty) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    await db
        .update(DbTableName.localChatLog, {'isRead': true, 'hasReadTime': now})
        .where('clientMsgID', 'IN', clientMsgIDs);
  }

  // ---------------------------------------------------------------------------
  // SendingMessage 操作 - 对应 Go SDK SendingMessagesModel
  // ---------------------------------------------------------------------------

  /// 插入发送中消息
  Future<void> insertSendingMessage(String clientMsgID, String conversationID) async {
    await db.insert(DbTableName.localSendingMessage, {
      'clientMsgID': clientMsgID,
      'conversationID': conversationID,
    });
  }

  /// 删除发送中消息
  Future<void> deleteSendingMessage(String clientMsgID) async {
    await db.delete(DbTableName.localSendingMessage).where('clientMsgID', '=', clientMsgID);
  }

  /// 获取会话的发送中消息列表
  Future<List<Map<String, dynamic>>> getSendingMessages(String conversationID) async {
    final result = await db
        .query(DbTableName.localSendingMessage)
        .where('conversationID', '=', conversationID);
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
