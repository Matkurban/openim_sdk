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
import 'package:openim_sdk/src/utils/open_im_utils.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';
import 'package:meta/meta.dart';

class ConversationManager {
  static final Logger _log = Logger('ConversationManager');

  final GetIt _getIt = GetIt.instance;

  ImApiService get _api {
    return _getIt.get<ImApiService>(instanceName: InstanceName.imApiService);
  }

  DatabaseService get _database {
    return _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  WebSocketService get _webSocketService {
    return _getIt.get<WebSocketService>(instanceName: InstanceName.webSocketService);
  }

  OnConversationListener? listener;

  late String _currentUserID;

  void setConversationListener(OnConversationListener listener) {
    this.listener = listener;
  }

  @internal
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  /// 根据会话类型生成会话ID
  /// [sourceID] 单聊为用户ID，群聊为群组ID
  /// [sessionType] 会话类型
  String getConversationIDBySessionType({required String sourceID, required int sessionType}) {
    _log.info('getConversationIDBySessionType: sourceID=$sourceID, sessionType=$sessionType');
    if (sessionType == ConversationType.single.value) {
      return OpenImUtils.genSingleConversationID(_currentUserID, sourceID);
    } else if (sessionType == ConversationType.superGroup.value) {
      return OpenImUtils.genGroupConversationID(sourceID);
    } else {
      return OpenImUtils.genNotificationConversationID(_currentUserID, sourceID);
    }
  }

  /// 获取 @所有人 标识
  String getAtAllTag() => atAllTag;

  /// @所有人 标识
  String get atAllTag => 'AtAllTag';

  /// 获取所有会话列表
  Future<List<ConversationInfo>> getAllConversationList() async {
    _log.info('getAllConversationList');
    return _database.getAllConversations();
  }

  /// 分页获取会话列表
  /// [offset] 起始索引
  /// [count] 每页数量
  Future<List<ConversationInfo>> getConversationListSplit({int offset = 0, int count = 20}) async {
    _log.info('getConversationListSplit: offset=$offset, count=$count');
    return _database.getConversationsPage(offset, count);
  }

  /// 查询会话，如果不存在则创建
  /// [sourceID] 单聊为用户ID，群聊为群组ID
  /// [sessionType] 参考 [ConversationType]
  Future<ConversationInfo> getOneConversation({
    required String sourceID,
    required int sessionType,
  }) async {
    _log.info('getOneConversation: sourceID=$sourceID, sessionType=$sessionType');
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
    _log.info('getMultipleConversation: conversationIDList=$conversationIDList');
    return _database.getMultipleConversations(conversationIDList);
  }

  /// 搜索会话
  /// [name] 搜索关键字
  Future<List<ConversationInfo>> searchConversations(String name) async {
    _log.info('searchConversations: name=$name');
    return _database.searchConversations(name);
  }

  /// 自定义会话列表排序
  /// 置顶会话优先，然后按最新消息时间或草稿时间排序
  List<ConversationInfo> simpleSort(List<ConversationInfo> list) {
    return list..sort((a, b) {
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
  }

  /// 设置会话属性（免打扰、置顶等）
  /// [conversationID] 会话ID
  /// [req] 会话修改请求
  Future<void> setConversation({
    required String conversationID,
    required ConversationReq req,
  }) async {
    _log.info('setConversation: conversationID=$conversationID, req=$req');
    final updateData = req.toJson()..removeWhere((_, v) => v == null);
    if (updateData.isNotEmpty) {
      await _database.updateConversation(conversationID, updateData);
    }
    _log.info('会话属性已更新: $conversationID');
    await _notifyConversationChanged([conversationID]);

    // 同步到服务器
    final resp = await _api.setConversations(
      req: {'userID': _currentUserID, 'conversationID': conversationID, ...updateData},
    );
    if (resp.errCode != 0) {
      _log.warning('同步会话属性到服务器失败: ${resp.errMsg}');
    }
  }

  /// 置顶会话
  /// [conversationID] 会话ID
  /// [isPinned] true: 置顶, false: 取消置顶
  Future<void> pinConversation({required String conversationID, required bool isPinned}) {
    _log.info('pinConversation: conversationID=$conversationID, isPinned=$isPinned');
    final req = ConversationReq(isPinned: isPinned);
    return setConversation(conversationID: conversationID, req: req);
  }

  /// 隐藏会话
  /// [conversationID] 会话ID
  Future<void> hideConversation({required String conversationID}) async {
    _log.info('hideConversation: conversationID=$conversationID');
    await _database.deleteConversation(conversationID);
    _log.info('会话已隐藏: $conversationID');
  }

  /// 隐藏所有会话
  Future<void> hideAllConversations() async {
    _log.info('hideAllConversations');
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
    _log.info('setConversationDraft: conversationID=$conversationID, draftText=$draftText');
    await _database.setConversationDraft(conversationID, draftText);
    _log.info('会话草稿已设置: $conversationID');
    await _notifyConversationChanged([conversationID]);
  }

  /// 获取未读消息总数
  Future<int> getTotalUnreadMsgCount() async {
    _log.info('getTotalUnreadMsgCount');
    return _database.getTotalUnreadCount();
  }

  /// 标记会话消息已读
  /// [conversationID] 会话ID
  Future<void> markConversationMessageAsRead({required String conversationID}) async {
    _log.info('markConversationMessageAsRead: conversationID=$conversationID');
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
        userID: _currentUserID,
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
    _log.info('markAllConversationMessageAsRead');
    final allConversations = await _database.getAllConversations();
    final affectedIDs = allConversations
        .where((c) => c.unreadCount > 0)
        .map((c) => c.conversationID)
        .toList();
    await _database.clearAllUnreadCounts();
    _log.info('所有会话已标记已读');
    listener?.totalUnreadMessageCountChanged(0);
    if (affectedIDs.isNotEmpty) {
      await _notifyConversationChanged(affectedIDs);
    }
  }

  /// 根据消息ID标记消息已读
  /// 对应 Go SDK MarkMessagesAsReadByMsgID
  /// [conversationID] 会话ID
  /// [clientMsgIDs] 要标记已读的消息clientMsgID列表
  Future<void> markMessagesAsReadByMsgID({
    required String conversationID,
    required List<String> clientMsgIDs,
  }) async {
    _log.info(
      'markMessagesAsReadByMsgID: conversationID=$conversationID, clientMsgIDs=$clientMsgIDs',
    );
    if (clientMsgIDs.isEmpty) return;

    // 1. 验证会话存在
    final conv = await _database.getConversation(conversationID);
    if (conv == null) {
      _log.warning('会话不存在: $conversationID');
      return;
    }

    // 2. 获取消息列表
    final msgs = await _database.getMessagesByClientMsgIDs(clientMsgIDs);
    if (msgs.isEmpty) return;

    // 3. 过滤出未读的、非自己发的消息（对应 Go SDK getAsReadMsgMapAndList）
    final asReadMsgIDs = <String>[];
    final seqs = <int>[];
    for (final msg in msgs) {
      if (!(msg.isRead ?? false) && msg.sendID != _currentUserID) {
        final seq = msg.seq ?? 0;
        if (seq > 0) {
          asReadMsgIDs.add(msg.clientMsgID!);
          seqs.add(seq);
        }
      }
    }

    if (seqs.isEmpty) {
      _log.info('没有需要标记已读的消息');
      return;
    }

    // 4. 同步到服务器
    final resp = await _api.markMsgsAsRead(
      userID: _currentUserID,
      conversationID: conversationID,
      seqs: seqs,
    );
    if (resp.errCode != 0) {
      _log.warning('标记消息已读同步服务器失败: ${resp.errMsg}');
    }

    // 5. 更新本地 DB
    final decrCount = await _database.markConversationMessageAsReadDB(conversationID, asReadMsgIDs);

    // 6. 减少未读数
    await _database.decrConversationUnreadCount(conversationID, decrCount);

    // 7. 触发未读数变更
    final total = await getTotalUnreadMsgCount();
    listener?.totalUnreadMessageCountChanged(total);
    await _notifyConversationChanged([conversationID]);
  }

  /// 删除会话及其所有消息（本地和服务器）
  /// [conversationID] 会话ID
  Future<void> deleteConversationAndDeleteAllMsg({required String conversationID}) async {
    _log.info('deleteConversationAndDeleteAllMsg: conversationID=$conversationID');
    await _clearConversationMessages(conversationID);
    await _database.deleteConversation(conversationID);
    _log.info('会话及消息已删除: $conversationID');

    final resp = await _api.clearConversationMsg(
      userID: _currentUserID,
      conversationIDs: [conversationID],
    );
    if (resp.errCode != 0) {
      _log.warning('删除会话及消息失败: ${resp.errMsg}');
    }
  }

  /// 清空会话消息
  /// [conversationID] 会话ID
  Future<void> clearConversationAndDeleteAllMsg({required String conversationID}) async {
    _log.info('clearConversationAndDeleteAllMsg: conversationID=$conversationID');
    await _clearConversationMessages(conversationID);
    await _database.deleteConversation(conversationID);
    _log.info('会话及消息已清空: $conversationID');

    final resp = await _api.clearConversationMsg(
      userID: _currentUserID,
      conversationIDs: [conversationID],
    );
    if (resp.errCode != 0) {
      _log.warning('清空会话消息失败: ${resp.errMsg}');
    }
  }

  /// 更新输入状态
  /// [conversationID] 会话ID
  /// [focus] 是否正在输入
  Future<void> changeInputStates({required String conversationID, required bool focus}) async {
    _log.info('changeInputStates: conversationID=$conversationID, focus=$focus');
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
      'sendID': _currentUserID,
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
      await _webSocketService.sendRequestWaitResponse(
        reqIdentifier: WebSocketIdentifier.sendMsg,
        data: wsData,
      );
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
