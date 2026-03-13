import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/models/web_socket_identifier.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:openim_sdk/src/services/web_socket_service.dart';
import 'package:openim_sdk/src/utils/im_utils.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';

class ConversationManager {
  static final Logger _log = Logger('ConversationManager');

  ImApiService get _api =>
      GetIt.instance.get<ImApiService>(instanceName: InstanceName.imApiService);
  DatabaseService get _database =>
      GetIt.instance.get<DatabaseService>(instanceName: InstanceName.databaseService);
  WebSocketService get _ws =>
      GetIt.instance.get<WebSocketService>(instanceName: InstanceName.webSocketService);

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
  String getConversationIDBySessionType({required String sourceID, required int sessionType}) {
    if (sessionType == ConversationType.single.value) {
      return ImUtils.genSingleConversationID(_database.currentUserID, sourceID);
    } else if (sessionType == ConversationType.superGroup.value) {
      return ImUtils.genGroupConversationID(sourceID);
    } else {
      return ImUtils.genNotificationConversationID(_database.currentUserID, sourceID);
    }
  }

  /// 获取 @所有人 标识
  String getAtAllTag() => atAllTag;

  /// @所有人 标识
  String get atAllTag => 'AtAllTag';

  // ---------------------------------------------------------------------------
  // 会话查询操作
  // ---------------------------------------------------------------------------

  /// 获取所有会话列表
  Future<List<ConversationInfo>> getAllConversationList() async {
    return _database.getAllConversations();
  }

  /// 分页获取会话列表
  /// [offset] 起始索引
  /// [count] 每页数量
  Future<List<ConversationInfo>> getConversationListSplit({int offset = 0, int count = 20}) async {
    return _database.getConversationsPage(offset, count);
  }

  /// 查询会话，如果不存在则创建
  /// [sourceID] 单聊为用户ID，群聊为群组ID
  /// [sessionType] 参考 [ConversationType]
  Future<ConversationInfo> getOneConversation({
    required String sourceID,
    required int sessionType,
  }) async {
    final conversationID = getConversationIDBySessionType(
      sourceID: sourceID,
      sessionType: sessionType,
    );
    final data = await _database.getConversation(conversationID);
    if (data != null) {
      return data;
    }
    // 不存在则自动创建
    final newConv = <String, dynamic>{
      'conversationID': conversationID,
      'conversationType': sessionType,
      'userID': sessionType == ConversationType.single.value ? sourceID : null,
      'groupID': sessionType != ConversationType.single.value ? sourceID : null,
      'unreadCount': 0,
    };
    await _database.upsertConversation(newConv);
    return (await _database.getConversation(conversationID)) ??
        ConversationInfo(conversationID: conversationID);
  }

  /// 根据会话ID列表获取多个会话
  /// [conversationIDList] 会话ID列表
  Future<List<ConversationInfo>> getMultipleConversation({
    required List<String> conversationIDList,
  }) async {
    return _database.getMultipleConversations(conversationIDList);
  }

  /// 搜索会话
  /// [name] 搜索关键字
  Future<List<ConversationInfo>> searchConversations(String name) async {
    return _database.searchConversations(name);
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
      await _database.updateConversation(conversationID, updateData);
    }
    _log.info('会话属性已更新: $conversationID');
    await _notifyConversationChanged([conversationID]);

    // 同步到服务器
    final resp = await _api.setConversations(
      req: {'userID': _database.currentUserID, 'conversationID': conversationID, ...updateData},
    );
    if (resp.errCode != 0) {
      _log.warning('同步会话属性到服务器失败: ${resp.errMsg}');
    }
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
    await _database.deleteConversation(conversationID);
    _log.info('会话已隐藏: $conversationID');
  }

  /// 隐藏所有会话
  Future<void> hideAllConversations() async {
    await _database.deleteAllConversations();
    _log.info('所有会话已隐藏');
  }

  /// 设置会话草稿
  /// [conversationID] 会话ID
  /// [draftText] 草稿内容
  Future<void> setConversationDraft({
    required String conversationID,
    required String draftText,
  }) async {
    await _database.setConversationDraft(conversationID, draftText);
    _log.info('会话草稿已设置: $conversationID');
    await _notifyConversationChanged([conversationID]);
  }

  // ---------------------------------------------------------------------------
  // 未读消息计数
  // ---------------------------------------------------------------------------

  /// 获取未读消息总数
  Future<int> getTotalUnreadMsgCount() async {
    return _database.getTotalUnreadCount();
  }

  /// 标记会话消息已读
  /// [conversationID] 会话ID
  Future<void> markConversationMessageAsRead({required String conversationID}) async {
    // 获取当前会话的 maxSeq 用于服务端标记已读
    final hasReadSeq = await _database.getConversationMaxSeq(conversationID);

    await _database.clearConversationUnreadCount(conversationID);
    _log.info('会话已标记已读: $conversationID');

    final total = await getTotalUnreadMsgCount();
    listener?.totalUnreadMessageCountChanged(total);
    await _notifyConversationChanged([conversationID]);

    // 同步到服务器
    if (hasReadSeq > 0) {
      final resp = await _api.markConversationAsRead(
        userID: _database.currentUserID,
        conversationID: conversationID,
        hasReadSeq: hasReadSeq,
      );
      if (resp.errCode != 0) {
        _log.warning('标记会话已读同步服务器失败: ${resp.errMsg}');
      }
    }
  }

  /// 标记所有会话消息已读
  Future<void> markAllConversationMessageAsRead() async {
    await _database.clearAllUnreadCounts();
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
    await _database.deleteConversation(conversationID);
    _log.info('会话及消息已删除: $conversationID');

    final resp = await _api.clearConversationMsg(
      userID: _database.currentUserID,
      conversationIDs: [conversationID],
    );
    if (resp.errCode != 0) {
      _log.warning('删除会话及消息失败: ${resp.errMsg}');
    }
  }

  /// 清空会话消息
  /// [conversationID] 会话ID
  Future<void> clearConversationAndDeleteAllMsg({required String conversationID}) async {
    await _clearConversationMessages(conversationID);
    await _database.deleteConversation(conversationID);
    _log.info('会话及消息已清空: $conversationID');

    final resp = await _api.clearConversationMsg(
      userID: _database.currentUserID,
      conversationIDs: [conversationID],
    );
    if (resp.errCode != 0) {
      _log.warning('清空会话消息失败: ${resp.errMsg}');
    }
  }

  // ---------------------------------------------------------------------------
  // 输入状态
  // ---------------------------------------------------------------------------

  /// 更新输入状态
  /// [conversationID] 会话ID
  /// [focus] 是否正在输入
  Future<void> changeInputStates({required String conversationID, required bool focus}) async {
    _log.fine('输入状态变更: $conversationID, focus=$focus');

    // 获取会话信息以确定接收方
    final conv = await _database.getConversation(conversationID);
    if (conv == null) return;

    final recvID = conv.userID ?? '';
    final groupID = conv.groupID ?? '';
    final convType = conv.conversationType?.value ?? 1;

    // 构造 Typing 消息（对应 Go SDK 的 entering.go）
    final typingElem = {'msgTips': focus ? 'yes' : 'no'};
    final options = <String, bool>{
      'history': false,
      'persistent': false,
      'senderSync': false,
      'conversationUpdate': false,
      'senderConversationUpdate': false,
      'unreadCount': false,
      'offlinePush': false,
    };
    final msgData = {
      'sendID': _database.currentUserID,
      'recvID': recvID,
      'groupID': groupID,
      'clientMsgID': '${DateTime.now().microsecondsSinceEpoch}',
      'sessionType': convType,
      'msgFrom': 100,
      'contentType': 113, // Typing
      'content': jsonEncode(typingElem),
      'senderPlatformID': PlatformUtils.currentPlatform.value,
      'createTime': DateTime.now().millisecondsSinceEpoch,
      'sendTime': 0,
      'options': options,
    };

    try {
      final wsData = Uint8List.fromList(utf8.encode(jsonEncode(msgData)));
      await _ws.sendRequestWaitResponse(reqIdentifier: WebSocketIdentifier.sendMsg, data: wsData);
    } catch (e) {
      _log.warning('发送输入状态失败: $e');
    }
  }

  /// 获取对方输入状态
  /// [conversationID] 会话ID
  /// [userID] 对方用户ID
  Future<List<int>?> getInputStates(String conversationID, String userID) async {
    // 监听端提供平台列表，通常为实时响应
    return [];
  }

  /// 获取会话消息接收选项
  /// [conversationIDList] 会话ID列表
  Future<List<dynamic>> getConversationRecvMessageOpt({
    required List<String> conversationIDList,
    String? operationID,
  }) async {
    final convs = await getMultipleConversation(conversationIDList: conversationIDList);
    return convs
        .map((c) => {'conversationID': c.conversationID, 'result': c.recvMsgOpt?.value ?? 0})
        .toList();
  }

  /// 删除所有本地会话
  @Deprecated('Use hideAllConversations instead')
  Future<dynamic> deleteAllConversationFromLocal({String? operationID}) {
    return hideAllConversations();
  }

  // ---------------------------------------------------------------------------
  // 本地数据操作（供内部模块调用）——续
  // ---------------------------------------------------------------------------

  /// 保存或更新会话到本地
  Future<void> saveConversationToLocal(ConversationInfo conversation) async {
    await _database.saveConversation(conversation);
  }

  /// 批量保存或更新会话到本地
  Future<void> batchSaveConversationsToLocal(List<ConversationInfo> conversations) async {
    await _database.batchSaveConversations(conversations);
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
    await _database.deleteConversationAllMessages(conversationID);
  }

  /// 通知会话变更
  Future<void> _notifyConversationChanged(List<String> conversationIDs) async {
    final conversations = await getMultipleConversation(conversationIDList: conversationIDs);
    if (conversations.isNotEmpty) {
      listener?.conversationChanged(conversations);
    }
  }
}
