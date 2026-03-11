import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/db/database_service.dart';

/// 会话管理器
/// 对应 open-im-sdk-flutter 中 ConversationManager。
/// 负责会话的增删改查、未读计数、草稿管理和监听回调。
class ConversationManager {
  static final Logger _log = Logger('ConversationManager');

  DatabaseService get _db => GetIt.instance.get<DatabaseService>();

  /// 会话变更监听器
  OnConversationListener? listener;

  /// 设置会话监听器
  void setConversationListener(OnConversationListener listener) {
    this.listener = listener;
  }

  // ---------------------------------------------------------------------------
  // 会话 ID 生成规则
  // ---------------------------------------------------------------------------

  /// 根据会话类型生成会话ID
  /// [sourceID] 单聊为用户ID，群聊为群组ID
  /// [sessionType] 会话类型
  Future<String> getConversationIDBySessionType({
    required String sourceID,
    required int sessionType,
  }) async {
    if (sessionType == ConversationType.single.value) {
      return genSingleConversationID(_db.currentUserID, sourceID);
    } else if (sessionType == ConversationType.superGroup.value) {
      return genGroupConversationID(sourceID);
    } else {
      return genNotificationConversationID(_db.currentUserID, sourceID);
    }
  }

  /// 生成单聊会话ID
  static String genSingleConversationID(String userID1, String userID2) {
    final sorted = [userID1, userID2]..sort();
    return 'si_${sorted[0]}_${sorted[1]}';
  }

  /// 生成群聊会话ID
  static String genGroupConversationID(String groupID) {
    return 'sg_$groupID';
  }

  /// 生成通知会话ID
  static String genNotificationConversationID(String userID1, String userID2) {
    final sorted = [userID1, userID2]..sort();
    return 'sn_${sorted[0]}_${sorted[1]}';
  }

  /// 获取 @所有人 标识
  Future<String> getAtAllTag() async => 'AtAllTag';

  /// @所有人 标识
  String get atAllTag => 'AtAllTag';

  // ---------------------------------------------------------------------------
  // 会话查询操作
  // ---------------------------------------------------------------------------

  /// 获取所有会话列表
  Future<List<ConversationInfo>> getAllConversationList() async {
    final dataList = await _db.getAllConversations();
    return _batchConvertConversations(dataList);
  }

  /// 分页获取会话列表
  /// [offset] 起始索引
  /// [count] 每页数量
  Future<List<ConversationInfo>> getConversationListSplit({int offset = 0, int count = 20}) async {
    final dataList = await _db.getConversationsPage(offset, count);
    return _batchConvertConversations(dataList);
  }

  /// 查询会话，如果不存在则创建
  /// [sourceID] 单聊为用户ID，群聊为群组ID
  /// [sessionType] 参考 [ConversationType]
  Future<ConversationInfo> getOneConversation({
    required String sourceID,
    required int sessionType,
  }) async {
    final conversationID = await getConversationIDBySessionType(
      sourceID: sourceID,
      sessionType: sessionType,
    );
    final data = await _db.getConversation(conversationID);
    if (data != null) {
      return _convertConversation(data);
    }
    // 不存在则自动创建
    final newConv = <String, dynamic>{
      'conversationID': conversationID,
      'conversationType': sessionType,
      'userID': sessionType == ConversationType.single.value ? sourceID : null,
      'groupID': sessionType != ConversationType.single.value ? sourceID : null,
      'unreadCount': 0,
    };
    await _db.upsertConversation(newConv);
    return _convertConversation(newConv);
  }

  /// 根据会话ID列表获取多个会话
  /// [conversationIDList] 会话ID列表
  Future<List<ConversationInfo>> getMultipleConversation({
    required List<String> conversationIDList,
  }) async {
    final dataList = await _db.getMultipleConversations(conversationIDList);
    return _batchConvertConversations(dataList);
  }

  /// 搜索会话
  /// [name] 搜索关键字
  Future<List<ConversationInfo>> searchConversations(String name) async {
    final dataList = await _db.searchConversations(name);
    return _batchConvertConversations(dataList);
  }

  /// 自定义会话列表排序
  /// 置顶会话优先，然后按最新消息时间或草稿时间排序
  List<ConversationInfo> simpleSort(List<ConversationInfo> list) => list
    ..sort((a, b) {
      if ((a.isPinned == true && b.isPinned == true) ||
          (a.isPinned != true && b.isPinned != true)) {
        final aCompare = (a.draftTextTime ?? 0) > (a.latestMsgSendTime ?? 0)
            ? (a.draftTextTime ?? 0)
            : (a.latestMsgSendTime ?? 0);
        final bCompare = (b.draftTextTime ?? 0) > (b.latestMsgSendTime ?? 0)
            ? (b.draftTextTime ?? 0)
            : (b.latestMsgSendTime ?? 0);
        if (aCompare > bCompare) {
          return -1;
        } else if (aCompare < bCompare) {
          return 1;
        } else {
          return 0;
        }
      } else if (a.isPinned == true && b.isPinned != true) {
        return -1;
      } else {
        return 1;
      }
    });

  // ---------------------------------------------------------------------------
  // 会话修改操作
  // ---------------------------------------------------------------------------

  /// 设置会话属性（免打扰、置顶等）
  /// [conversationID] 会话ID
  /// [req] 会话修改请求
  Future<void> setConversation({
    required String conversationID,
    required ConversationReq req,
  }) async {
    final updateData = req.toJson()..removeWhere((_, v) => v == null);
    if (updateData.isNotEmpty) {
      await _db.updateConversation(conversationID, updateData);
    }
    _log.info('会话属性已更新: $conversationID');
    await _notifyConversationChanged([conversationID]);
  }

  /// 置顶会话
  /// [conversationID] 会话ID
  /// [isPinned] true: 置顶, false: 取消置顶
  Future<void> pinConversation({required String conversationID, required bool isPinned}) {
    final req = ConversationReq(isPinned: isPinned);
    return setConversation(conversationID: conversationID, req: req);
  }

  /// 隐藏会话
  /// [conversationID] 会话ID
  Future<void> hideConversation({required String conversationID}) async {
    await _db.deleteConversation(conversationID);
    _log.info('会话已隐藏: $conversationID');
  }

  /// 隐藏所有会话
  Future<void> hideAllConversations() async {
    await _db.deleteAllConversations();
    _log.info('所有会话已隐藏');
  }

  /// 设置会话草稿
  /// [conversationID] 会话ID
  /// [draftText] 草稿内容
  Future<void> setConversationDraft({
    required String conversationID,
    required String draftText,
  }) async {
    await _db.setConversationDraft(conversationID, draftText);
    _log.info('会话草稿已设置: $conversationID');
    await _notifyConversationChanged([conversationID]);
  }

  // ---------------------------------------------------------------------------
  // 未读消息计数
  // ---------------------------------------------------------------------------

  /// 获取未读消息总数
  Future<int> getTotalUnreadMsgCount() async {
    return _db.getTotalUnreadCount();
  }

  /// 标记会话消息已读
  /// [conversationID] 会话ID
  Future<void> markConversationMessageAsRead({required String conversationID}) async {
    await _db.clearConversationUnreadCount(conversationID);
    _log.info('会话已标记已读: $conversationID');

    final total = await getTotalUnreadMsgCount();
    listener?.totalUnreadMessageCountChanged(total);
    await _notifyConversationChanged([conversationID]);
  }

  /// 标记所有会话消息已读
  Future<void> markAllConversationMessageAsRead() async {
    await _db.clearAllUnreadCounts();
    _log.info('所有会话已标记已读');
    listener?.totalUnreadMessageCountChanged(0);
  }

  // ---------------------------------------------------------------------------
  // 会话删除操作
  // ---------------------------------------------------------------------------

  /// 删除会话及其所有消息（本地和服务器）
  /// [conversationID] 会话ID
  Future<void> deleteConversationAndDeleteAllMsg({required String conversationID}) async {
    await _clearConversationMessages(conversationID);
    await _db.deleteConversation(conversationID);
    _log.info('会话及消息已删除: $conversationID');

    // TODO: 同步到服务器
  }

  /// 清空会话消息
  /// [conversationID] 会话ID
  Future<void> clearConversationAndDeleteAllMsg({required String conversationID}) async {
    await _clearConversationMessages(conversationID);
    await _db.deleteConversation(conversationID);
    _log.info('会话及消息已清空: $conversationID');

    // TODO: 同步到服务器
  }

  // ---------------------------------------------------------------------------
  // 输入状态
  // ---------------------------------------------------------------------------

  /// 更新输入状态
  /// [conversationID] 会话ID
  /// [focus] 是否正在输入
  Future<void> changeInputStates({required String conversationID, required bool focus}) async {
    // TODO: 通过 WebSocket 发送输入状态通知
    _log.fine('输入状态变更: $conversationID, focus=$focus');
  }

  /// 获取对方输入状态
  /// [conversationID] 会话ID
  /// [userID] 对方用户ID
  Future<List<int>?> getInputStates(String conversationID, String userID) async {
    // TODO: 返回对方正在输入的平台列表
    return [];
  }

  // ---------------------------------------------------------------------------
  // 本地数据操作（供内部模块调用）
  // ---------------------------------------------------------------------------

  /// 保存或更新会话到本地
  Future<void> saveConversationToLocal(ConversationInfo conversation) async {
    final data = _conversationToDbMap(conversation);
    await _db.upsertConversation(data);
  }

  /// 批量保存或更新会话到本地
  Future<void> batchSaveConversationsToLocal(List<ConversationInfo> conversations) async {
    final dataList = conversations.map(_conversationToDbMap).toList();
    await _db.batchUpsertConversations(dataList);
  }

  /// 通知新会话创建
  void notifyNewConversation(List<ConversationInfo> conversations) {
    if (conversations.isNotEmpty) {
      listener?.newConversation(conversations);
    }
  }

  // ---------------------------------------------------------------------------
  // 私有辅助方法
  // ---------------------------------------------------------------------------

  /// 清空指定会话的所有消息
  Future<void> _clearConversationMessages(String conversationID) async {
    final conv = await _db.getConversation(conversationID);
    if (conv != null) {
      final sessionType = conv['conversationType'] as int?;
      final groupID = conv['groupID'] as String?;
      final userID = conv['userID'] as String?;
      await _db.deleteConversationAllMessages(
        groupID: groupID,
        sendID: _db.currentUserID,
        recvID: userID,
        sessionType: sessionType,
      );
    }
  }

  /// 通知会话变更
  Future<void> _notifyConversationChanged(List<String> conversationIDs) async {
    final conversations = await getMultipleConversation(conversationIDList: conversationIDs);
    if (conversations.isNotEmpty) {
      listener?.conversationChanged(conversations);
    }
  }

  /// 数据库 Map 转 ConversationInfo
  ConversationInfo _convertConversation(Map<String, dynamic> data) {
    final latestMsgStr = data['latestMsg'] as String?;
    Message? latestMsg;
    if (latestMsgStr != null && latestMsgStr.isNotEmpty) {
      try {
        latestMsg = Message.fromJson(jsonDecode(latestMsgStr) as Map<String, dynamic>);
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

  /// 批量转换会话数据
  List<ConversationInfo> _batchConvertConversations(List<Map<String, dynamic>> dataList) {
    return dataList.map(_convertConversation).toList();
  }

  /// ConversationInfo 转数据库 Map
  Map<String, dynamic> _conversationToDbMap(ConversationInfo c) {
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

  /// int 转 ConversationType 枚举
  static ConversationType? _intToConversationType(int? value) {
    if (value == null) return null;
    return ConversationType.values.cast<ConversationType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  /// int 转 ReceiveMessageOpt 枚举
  static ReceiveMessageOpt? _intToReceiveMessageOpt(int? value) {
    if (value == null) return null;
    return ReceiveMessageOpt.values.cast<ReceiveMessageOpt?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  /// int 转 GroupAtType 枚举
  static GroupAtType? _intToGroupAtType(int? value) {
    if (value == null) return null;
    return GroupAtType.values.cast<GroupAtType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }
}
