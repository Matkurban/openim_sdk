import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../core/base_manager.dart';
import '../../core/sdk_context.dart';
import '../../db/repositories/message_repository.dart';
import '../../enums/conversation_type.dart';
import '../../enums/group_role_level.dart';
import '../../enums/message_status.dart';
import '../../enums/message_type.dart';
import '../../enums/sdk_error_code.dart';
import '../../listener/advanced_msg_listener.dart';
import '../../listener/conversation_listener.dart';
import '../../listener/custom_business_listener.dart';
import '../../listener/msg_send_progress_listener.dart';
import '../../models/api_response.dart';
import '../../models/call_signal_elem.dart';
import '../../models/conversation_info.dart';
import '../../models/group_info.dart';
import '../../models/message.dart';
import '../../models/openim_exception.dart';
import '../../models/red_packet_elem.dart';
import '../../models/search_info.dart';
import '../../models/user_info.dart';
import '../../utils/open_im_utils.dart';
import '../file_uploader.dart';
import 'message_factory.dart';
import 'message_sender.dart';

/// 消息管理器（继承 [BaseManager]），协调 [MessageFactory]、[MessageSender] 及历史/搜索/撤回/删除操作。
final class MessageManager extends BaseManager<OnAdvancedMsgListener> {
  final SdkContext _context;
  final FileUploader _fileUploader;
  final OnConversationListener? Function() _conversationListenerProvider;

  late final MessageFactory _factory;
  late final MessageSender _sender;

  OnMsgSendProgressListener? msgSendProgressListener;
  OnCustomBusinessListener? customBusinessListener;

  MessageManager({
    required this._context,
    required this._fileUploader,
    required this._conversationListenerProvider,
  }) : super('MessageManager') {
    _factory = MessageFactory(userIDProvider: () => currentUserID);
    _sender = MessageSender(
      context: _context,
      fileUploader: _fileUploader,
      factory: _factory,
      userIDProvider: () => currentUserID,
      msgListenerProvider: () => msgListener,
      progressListenerProvider: () => msgSendProgressListener,
      conversationListenerProvider: _conversationListenerProvider,
    );
  }

  OnAdvancedMsgListener? get msgListener => listener;

  void setMsgSendProgressListener(OnMsgSendProgressListener listener) {
    msgSendProgressListener = listener;
  }

  void setMessageListener(OnAdvancedMsgListener listener) {
    setPrimaryListener(listener);
  }

  void setCustomBusinessListener(OnCustomBusinessListener listener) {
    customBusinessListener = listener;
  }

  @override
  @internal
  void onLogout() {
    _factory.clearPendingBytes();
    super.onLogout();
  }

  // ---- 消息创建委托至 MessageFactory ----

  Message createTextMessage({required String text}) => _factory.createTextMessage(text: text);

  Message createTextAtMessage({
    required String text,
    required List<String> atUserIDList,
    List<AtUserInfo> atUserInfoList = const <AtUserInfo>[],
    Message? quoteMessage,
  }) => _factory.createTextAtMessage(
    text: text,
    atUserIDList: atUserIDList,
    atUserInfoList: atUserInfoList,
    quoteMessage: quoteMessage,
  );

  Message createImageMessage({required String imagePath}) =>
      _factory.createImageMessage(imagePath: imagePath);

  Message createSoundMessage({required String soundPath, required int duration}) =>
      _factory.createSoundMessage(soundPath: soundPath, duration: duration);

  Message createVideoMessage({
    required String videoPath,
    required String videoType,
    required int duration,
    required String snapshotPath,
  }) => _factory.createVideoMessage(
    videoPath: videoPath,
    videoType: videoType,
    duration: duration,
    snapshotPath: snapshotPath,
  );

  Message createFileMessage({required String filePath, required String fileName}) =>
      _factory.createFileMessage(filePath: filePath, fileName: fileName);

  Message createMergeMessage({
    required List<Message> messageList,
    required String title,
    required List<String> summaryList,
  }) =>
      _factory.createMergeMessage(messageList: messageList, title: title, summaryList: summaryList);

  Message createForwardMessage({required Message message}) =>
      _factory.createForwardMessage(message: message);

  Message createLocationMessage({
    required double latitude,
    required double longitude,
    required String description,
  }) => _factory.createLocationMessage(
    latitude: latitude,
    longitude: longitude,
    description: description,
  );

  Message createCustomMessage({
    required String data,
    required String extension,
    required String description,
  }) => _factory.createCustomMessage(data: data, extension: extension, description: description);

  Message createCallSignalMessage({required CallSignalElem elem}) =>
      _factory.createCallSignalMessage(elem: elem);

  Message createRedPacketMessage({required RedPacketElem elem}) =>
      _factory.createRedPacketMessage(elem: elem);

  Message createQuoteMessage({required String text, required Message quoteMsg}) =>
      _factory.createQuoteMessage(text: text, quoteMsg: quoteMsg);

  Message createCardMessage({
    required String userID,
    required String nickname,
    String? faceURL,
    String? ex,
  }) => _factory.createCardMessage(userID: userID, nickname: nickname, faceURL: faceURL, ex: ex);

  Message createFaceMessage({int index = -1, String? data}) =>
      _factory.createFaceMessage(index: index, data: data);

  Message createAdvancedTextMessage({
    required String text,
    List<RichMessageInfo> list = const <RichMessageInfo>[],
  }) => _factory.createAdvancedTextMessage(text: text, list: list);

  Message createAdvancedQuoteMessage({
    required String text,
    required Message quoteMsg,
    List<RichMessageInfo> list = const <RichMessageInfo>[],
  }) => _factory.createAdvancedQuoteMessage(text: text, quoteMsg: quoteMsg, list: list);

  Message createImageMessageByURL({
    required PictureInfo sourcePicture,
    required PictureInfo bigPicture,
    required PictureInfo snapshotPicture,
    String? sourcePath,
  }) => _factory.createImageMessageByURL(
    sourcePicture: sourcePicture,
    bigPicture: bigPicture,
    snapshotPicture: snapshotPicture,
    sourcePath: sourcePath,
  );

  Message createSoundMessageByURL({required SoundElem soundElem}) =>
      _factory.createSoundMessageByURL(soundElem: soundElem);

  Message createVideoMessageByURL({required VideoElem videoElem}) =>
      _factory.createVideoMessageByURL(videoElem: videoElem);

  Message createFileMessageByURL({required FileElem fileElem}) =>
      _factory.createFileMessageByURL(fileElem: fileElem);

  Future<Message> createImageMessageFromFullPath({
    required String imagePath,
    String? operationID,
  }) => _factory.createImageMessageFromFullPath(imagePath: imagePath);

  Message createSoundMessageFromFullPath({
    required String soundPath,
    required int duration,
    String? operationID,
  }) => _factory.createSoundMessageFromFullPath(soundPath: soundPath, duration: duration);

  Future<Message> createVideoMessageFromFullPath({
    required String videoPath,
    required String videoType,
    required int duration,
    required String snapshotPath,
    String? operationID,
  }) => _factory.createVideoMessageFromFullPath(
    videoPath: videoPath,
    videoType: videoType,
    duration: duration,
    snapshotPath: snapshotPath,
  );

  Message createFileMessageFromFullPath({
    required String filePath,
    required String fileName,
    String? operationID,
  }) => _factory.createFileMessageFromFullPath(filePath: filePath, fileName: fileName);

  Future<Message> createImageMessageByFile({required Uint8List bytes, required String fileName}) =>
      _factory.createImageMessageByFile(bytes: bytes, fileName: fileName);

  Future<Message> createVideoMessageByFile({
    required Uint8List bytes,
    required String fileName,
    required int duration,
    String? videoType,
    Uint8List? snapshotBytes,
  }) => _factory.createVideoMessageByFile(
    bytes: bytes,
    fileName: fileName,
    duration: duration,
    videoType: videoType,
    snapshotBytes: snapshotBytes,
  );

  Message createFileMessageByFile({required Uint8List bytes, required String fileName}) =>
      _factory.createFileMessageByFile(bytes: bytes, fileName: fileName);

  // ---- 消息发送与恢复 ----

  Future<void> recoverSendingMessages() => _sender.recoverSendingMessages();

  Future<Message> sendMessage({
    required Message message,
    required OfflinePushInfo offlinePushInfo,
    String? userID,
    String? groupID,
    bool isOnlineOnly = false,
    Map<String, bool>? messageOptions,
    bool uploadMedia = true,
  }) => _sender.sendMessage(
    message: message,
    offlinePushInfo: offlinePushInfo,
    userID: userID,
    groupID: groupID,
    isOnlineOnly: isOnlineOnly,
    messageOptions: messageOptions,
    uploadMedia: uploadMedia,
  );

  Future<Message> sendMessageNotOss({
    required Message message,
    required OfflinePushInfo offlinePushInfo,
    String? userID,
    String? groupID,
    bool isOnlineOnly = false,
  }) => _sender.sendMessage(
    message: message,
    offlinePushInfo: offlinePushInfo,
    userID: userID,
    groupID: groupID,
    isOnlineOnly: isOnlineOnly,
    uploadMedia: false,
  );

  // ---- 历史消息查询（正向与反向） ----

  Future<AdvancedMessage> getAdvancedHistoryMessageList({
    String? conversationID,
    Message? startMsg,
    GetHistoryViewType viewType = GetHistoryViewType.history,
    int? count,
  }) async {
    final String convID = conversationID ?? '';
    final int queryCount = count ?? 40;
    int startTime = startMsg?.sendTime ?? 0;

    if (startMsg?.clientMsgID != null && startMsg!.clientMsgID!.isNotEmpty) {
      final Message? existing = await _context.db.messages.getMessage(startMsg.clientMsgID!);
      if ((existing?.sendTime ?? 0) > 0) {
        startTime = existing!.sendTime!;
      }
    }

    final ConversationInfo? conv = await _context.db.conversations.getConversation(convID);
    if (conv == null) {
      return AdvancedMessage(messageList: const <Message>[], isEnd: true);
    }

    List<Message> dataList = await _context.db.messages.getHistoryMessages(
      conversationID: convID,
      startTime: startTime,
      startSeq: startMsg?.seq ?? 0,
      startClientMsgID: startMsg?.clientMsgID ?? '',
      count: queryCount + 1,
    );

    if (dataList.length <= queryCount) {
      final int convMaxSeq = await _context.db.conversations.getConversationMaxSeq(convID);
      int currentSeq;
      if (startMsg != null && (startMsg.seq ?? 0) > 1) {
        currentSeq = dataList.isNotEmpty ? (dataList.last.seq ?? startMsg.seq!) : startMsg.seq!;
      } else if (dataList.isNotEmpty) {
        currentSeq = dataList.last.seq ?? convMaxSeq;
      } else {
        currentSeq = convMaxSeq > 0 ? convMaxSeq + 1 : 1;
      }
      if (currentSeq >= 1) {
        final int beginSeq = (currentSeq - queryCount).clamp(1, currentSeq);
        final int endSeq = currentSeq - 1;
        if (endSeq >= beginSeq) {
          await _pullAndPersistRange(
            convID,
            beginSeq: beginSeq,
            endSeq: endSeq,
            count: queryCount,
            order: 1,
          );
          dataList = await _context.db.messages.getHistoryMessages(
            conversationID: convID,
            startTime: startTime,
            startSeq: startMsg?.seq ?? 0,
            startClientMsgID: startMsg?.clientMsgID ?? '',
            count: queryCount + 1,
          );
        }
      }
    }

    final bool isEnd = dataList.length <= queryCount;
    final List<Message> actual = isEnd ? dataList : dataList.sublist(0, queryCount);
    return AdvancedMessage(messageList: actual, isEnd: isEnd);
  }

  /// 反向获取历史消息（查询 `startMsg` 之后接收的更新消息，修复 B-08）。
  Future<AdvancedMessage> getAdvancedHistoryMessageListReverse({
    String? conversationID,
    Message? startMsg,
    GetHistoryViewType viewType = GetHistoryViewType.history,
    int? count,
  }) async {
    final String convID = conversationID ?? '';
    final int queryCount = count ?? 40;
    int startTime = startMsg?.sendTime ?? 0;

    if (startMsg?.clientMsgID != null && startMsg!.clientMsgID!.isNotEmpty) {
      final Message? existing = await _context.db.messages.getMessage(startMsg.clientMsgID!);
      if ((existing?.sendTime ?? 0) > 0) {
        startTime = existing!.sendTime!;
      }
    }

    final ConversationInfo? conv = await _context.db.conversations.getConversation(convID);
    if (conv == null) {
      return AdvancedMessage(messageList: const <Message>[], isEnd: true);
    }

    List<Message> dataList = await _context.db.messages.getHistoryMessagesReverse(
      conversationID: convID,
      startTime: startTime,
      startSeq: startMsg?.seq ?? 0,
      startClientMsgID: startMsg?.clientMsgID ?? '',
      count: queryCount + 1,
    );

    if (dataList.length <= queryCount && startMsg != null && (startMsg.seq ?? 0) > 0) {
      final int convMaxSeq = await _context.db.conversations.getConversationMaxSeq(convID);
      final int beginSeq =
          (dataList.isNotEmpty ? (dataList.last.seq ?? startMsg.seq!) : startMsg.seq!) + 1;
      if (convMaxSeq >= beginSeq) {
        final int endSeq = (beginSeq + queryCount - 1).clamp(beginSeq, convMaxSeq);
        await _pullAndPersistRange(
          convID,
          beginSeq: beginSeq,
          endSeq: endSeq,
          count: queryCount,
          order: 0,
        );
        dataList = await _context.db.messages.getHistoryMessagesReverse(
          conversationID: convID,
          startTime: startTime,
          startSeq: startMsg.seq ?? 0,
          startClientMsgID: startMsg.clientMsgID ?? '',
          count: queryCount + 1,
        );
      }
    }

    final bool isEnd = dataList.length <= queryCount;
    final List<Message> actual = isEnd ? dataList : dataList.sublist(0, queryCount);
    return AdvancedMessage(messageList: actual, isEnd: isEnd);
  }

  Future<void> _pullAndPersistRange(
    String conversationID, {
    required int beginSeq,
    required int endSeq,
    required int count,
    required int order,
  }) async {
    try {
      final ApiResponse resp = await _context.apis.message.pullMsgBySeqs(
        userID: currentUserID,
        seqRanges: <Map<String, dynamic>>[
          <String, dynamic>{
            'conversationID': conversationID,
            'begin': beginSeq,
            'end': endSeq,
            'num': count,
          },
        ],
        order: order,
      );
      if (resp.errCode != 0) {
        return;
      }
      final Map<String, dynamic> data = resp.data as Map<String, dynamic>? ?? <String, dynamic>{};
      final Map<String, dynamic> msgsJson =
          data['msgs'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final Map<String, dynamic> convMsgs =
          msgsJson[conversationID] as Map<String, dynamic>? ?? <String, dynamic>{};
      final List<dynamic> pulled =
          (convMsgs['Msgs'] ?? convMsgs['msgs']) as List<dynamic>? ?? const <dynamic>[];
      final List<Map<String, dynamic>> batchInsert = <Map<String, dynamic>>[];
      for (final dynamic netMsg in pulled) {
        if (netMsg is Map<dynamic, dynamic>) {
          final Map<String, dynamic> row = Map<String, dynamic>.from(netMsg);
          row['conversationID'] = conversationID;
          final int rawStatus = (row['status'] as num?)?.toInt() ?? 0;
          if (rawStatus == 0) {
            row['status'] = MessageStatus.succeeded.value;
          }
          batchInsert.add(row);
        }
      }
      if (batchInsert.isNotEmpty) {
        await _context.db.messages.batchInsertMessages(batchInsert);
      }
    } on Object catch (error, stackTrace) {
      logger.warning('Pull cloud history failed', error, stackTrace);
    }
  }

  // ---- 搜索与查找（修复 B-19） ----

  Future<SearchResult> findMessageList({required List<SearchParams> searchParams}) async {
    final List<SearchResultItems> resultItems = <SearchResultItems>[];
    int totalCount = 0;
    for (final SearchParams param in searchParams) {
      final List<String>? ids = param.clientMsgIDList;
      if (ids == null || ids.isEmpty) {
        continue;
      }
      final List<Message> messages = await _context.db.messages.getMessagesByClientMsgIDs(ids);
      if (messages.isNotEmpty) {
        totalCount += messages.length;
        resultItems.add(
          SearchResultItems(
            conversationID: param.conversationID,
            messageCount: messages.length,
            messageList: messages,
          ),
        );
      }
    }
    return SearchResult(totalCount: totalCount, findResultItems: resultItems);
  }

  Future<SearchResult> searchLocalMessages({
    String? conversationID,
    List<String> keywordList = const <String>[],
    int keywordListMatchType = 0,
    List<String> senderUserIDList = const <String>[],
    List<int> messageTypeList = const <int>[],
    int searchTimePosition = 0,
    int searchTimePeriod = 0,
    int pageIndex = 1,
    int count = 40,
  }) async {
    final int safePage = pageIndex < 1 ? 1 : pageIndex;
    final int offset = (safePage - 1) * count;
    // 修复 B-19：searchTimePeriod 单位为秒，从 searchTimePosition 往过去推算时间窗
    final int? endTime = searchTimePosition > 0 ? searchTimePosition : null;
    final int? startTime = (searchTimePosition > 0 && searchTimePeriod > 0)
        ? (searchTimePosition - searchTimePeriod * 1000).clamp(0, searchTimePosition)
        : null;

    final ({List<Message> messages, int totalCount}) result = await _context.db.messages
        .searchMessages(
          conversationID: conversationID,
          keywords: keywordList,
          matchAllKeywords: keywordListMatchType == 1,
          senderUserIDs: senderUserIDList,
          messageTypes: messageTypeList,
          startTime: startTime,
          endTime: endTime,
          offset: offset,
          count: count,
        );

    if (conversationID != null && conversationID.isNotEmpty) {
      return SearchResult(
        totalCount: result.totalCount,
        searchResultItems: <SearchResultItems>[
          SearchResultItems(
            conversationID: conversationID,
            messageCount: result.messages.length,
            messageList: result.messages,
          ),
        ],
      );
    }

    // 全局搜索按 conversationID 分组返回
    final Map<String, List<Message>> grouped = <String, List<Message>>{};
    for (final Message msg in result.messages) {
      final String cid = msg.groupID != null && msg.groupID!.isNotEmpty
          ? OpenImUtils.genGroupConversationID(msg.groupID!)
          : OpenImUtils.genSingleConversationID(
              currentUserID,
              msg.sendID == currentUserID ? (msg.recvID ?? '') : (msg.sendID ?? ''),
            );
      grouped.putIfAbsent(cid, () => <Message>[]).add(msg);
    }
    final List<SearchResultItems> items = grouped.entries
        .map<SearchResultItems>(
          (MapEntry<String, List<Message>> e) => SearchResultItems(
            conversationID: e.key,
            messageCount: e.value.length,
            messageList: e.value,
          ),
        )
        .toList();
    return SearchResult(totalCount: result.totalCount, searchResultItems: items);
  }

  // ---- 撤回 / 删除 / 本地插入 ----

  Future<void> revokeMessage({required String conversationID, required String clientMsgID}) async {
    final Message? msg = await _context.db.messages.getMessage(clientMsgID);
    if (msg == null) {
      throw OpenIMException(
        code: SDKErrorCode.databaseRecordNotFound.code,
        message: 'message not found',
      );
    }
    final int seq = msg.seq ?? 0;
    if (seq > 0) {
      final ApiResponse resp = await _context.apis.message.revokeMsg(
        userID: currentUserID,
        conversationID: conversationID,
        seq: seq,
      );
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
    }

    final int revokeTime = DateTime.now().millisecondsSinceEpoch;
    final ConversationInfo? conv = await _context.db.conversations.getConversation(conversationID);
    final ConversationType? sessionType = msg.sessionType ?? conv?.conversationType;
    String? revokerNickname;
    GroupRoleLevel? revokerRole;

    if (sessionType == ConversationType.single) {
      final UserInfo? loginUser = await _context.db.users.getLoginUser();
      revokerNickname = loginUser?.nickname;
    } else if (sessionType == ConversationType.superGroup && conv?.groupID != null) {
      final GroupMembersInfo? gm = await _context.db.groups.getGroupMember(
        conv!.groupID!,
        currentUserID,
      );
      revokerNickname = gm?.nickname ?? 'unknown';
      revokerRole = gm?.roleLevel;
    }

    final RevokedInfo revokedInfo = RevokedInfo(
      revokerID: currentUserID,
      revokerRole: revokerRole,
      revokerNickname: revokerNickname,
      clientMsgID: clientMsgID,
      revokeTime: revokeTime,
      sourceMessageSendTime: msg.sendTime,
      sourceMessageSendID: msg.sendID,
      sourceMessageSenderNickname: msg.senderNickname,
      sessionType: sessionType,
    );
    final Map<String, dynamic> detail = <String, dynamic>{
      ...revokedInfo.toJson(),
      'seq': seq,
      'ex': msg.ex ?? '',
      'isAdminRevoke': false,
    };
    final String notificationContent = jsonEncode(
      NotificationElem(detail: jsonEncode(detail)).toJson(),
    );

    await _context.db.messages.updateMessage(clientMsgID, <String, dynamic>{
      'contentType': MessageType.revokeMessageNotification.value,
      'content': notificationContent,
    });
    msgListener?.newRecvMessageRevoked(revokedInfo);
    await _updateConversationIfLatestMsg(conversationID, clientMsgID);
  }

  Future<void> deleteMessageFromLocalStorage({
    required String conversationID,
    required String clientMsgID,
  }) async {
    final Message? deletedMsg = await _context.db.messages.getMessage(clientMsgID);
    await _context.db.messages.deleteMessage(clientMsgID);

    if (deletedMsg != null && !(deletedMsg.isRead ?? true) && deletedMsg.sendID != currentUserID) {
      await _context.db.conversations.decrConversationUnreadCount(conversationID, 1);
      await _notifyConversationAndUnread(conversationID);
    }
    await _updateConversationIfLatestMsg(conversationID, clientMsgID);
    if (deletedMsg != null) {
      msgListener?.msgDeleted(deletedMsg);
    }
  }

  Future<void> deleteMessageFromLocalAndSvr({
    required String conversationID,
    required String clientMsgID,
  }) async {
    final Message? msg = await _context.db.messages.getMessage(clientMsgID);
    if (msg == null) {
      throw OpenIMException(
        code: SDKErrorCode.databaseRecordNotFound.code,
        message: 'message not found',
      );
    }
    final int seq = msg.seq ?? 0;
    if (seq == 0 || msg.status == MessageStatus.failed) {
      await deleteMessageFromLocalStorage(conversationID: conversationID, clientMsgID: clientMsgID);
      return;
    }
    final ApiResponse resp = await _context.apis.message.deleteMsgs(
      userID: currentUserID,
      conversationID: conversationID,
      seqs: <int>[seq],
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    await deleteMessageFromLocalStorage(conversationID: conversationID, clientMsgID: clientMsgID);
  }

  /// 删除所有本地消息并同步清空会话摘要与未读数（修复 B-20）。
  Future<void> deleteAllMsgFromLocal() async {
    final List<ConversationInfo> allConvs = await _context.db.conversations.getAllConversations();
    final List<String> affectedIDs = allConvs
        .map<String>((ConversationInfo c) => c.conversationID)
        .toList();
    await _context.db.transaction(() async {
      await _context.db.messages.deleteAllMessages();
      await _context.db.conversations.clearAllConversationsMessages();
    });
    if (affectedIDs.isNotEmpty) {
      final OnConversationListener? convListener = _conversationListenerProvider();
      final List<ConversationInfo> refreshed = await _context.db.conversations
          .getMultipleConversations(affectedIDs);
      if (refreshed.isNotEmpty) {
        convListener?.conversationChanged(refreshed);
      }
      convListener?.totalUnreadMessageCountChanged(0);
    }
  }

  Future<void> deleteAllMsgFromLocalAndSvr() async {
    await deleteAllMsgFromLocal();
    final ApiResponse resp = await _context.apis.message.clearAllMsg(userID: currentUserID);
    if (resp.errCode != 0) {
      logger.warning('clearAllMsg server sync failed: ${resp.errMsg}');
    }
  }

  Future<void> setMessageLocalEx({
    required String conversationID,
    required String clientMsgID,
    required String localEx,
  }) async {
    await _context.db.messages.updateMessage(clientMsgID, <String, dynamic>{'localEx': localEx});
    final ConversationInfo? conv = await _context.db.conversations.getConversation(conversationID);
    if (conv?.latestMsg != null && conv!.latestMsg!.clientMsgID == clientMsgID) {
      final Message updatedMsg = conv.latestMsg!.copyWith(localEx: localEx);
      await _context.db.conversations.updateConversation(conversationID, <String, dynamic>{
        'latestMsg': jsonEncode(updatedMsg.toJson()),
      });
      final ConversationInfo? updated = await _context.db.conversations.getConversation(
        conversationID,
      );
      if (updated != null) {
        _conversationListenerProvider()?.conversationChanged(<ConversationInfo>[updated]);
      }
    }
  }

  /// 插入单聊消息到本地（修复 B-09：正确计算 `(_currentUserID, peerID)` 会话 ID）。
  Future<Message> insertSingleMessageToLocalStorage({
    String? receiverID,
    String? senderID,
    Message? message,
  }) async {
    final Message msg = (message ?? createTextMessage(text: '')).copyWith(
      sendID: senderID,
      recvID: receiverID,
      sessionType: ConversationType.single,
      status: MessageStatus.succeeded,
      sendTime: DateTime.now().millisecondsSinceEpoch,
    );
    final String peerID = senderID == currentUserID ? (receiverID ?? '') : (senderID ?? '');
    final String conversationID = OpenImUtils.genSingleConversationID(currentUserID, peerID);
    await _context.db.messages.insertMessage(
      MessageRepository.messageToDbMap(msg, conversationID: conversationID),
    );
    await _sender.updateConversationLatestMsg(conversationID, msg, ConversationType.single);
    return msg;
  }

  Future<Message> insertGroupMessageToLocalStorage({
    String? groupID,
    String? senderID,
    Message? message,
  }) async {
    final Message msg = (message ?? createTextMessage(text: '')).copyWith(
      sendID: senderID,
      groupID: groupID,
      sessionType: ConversationType.superGroup,
      status: MessageStatus.succeeded,
      sendTime: DateTime.now().millisecondsSinceEpoch,
    );
    final String conversationID = OpenImUtils.genGroupConversationID(groupID ?? '');
    await _context.db.messages.insertMessage(
      MessageRepository.messageToDbMap(msg, conversationID: conversationID),
    );
    await _sender.updateConversationLatestMsg(conversationID, msg, ConversationType.superGroup);
    return msg;
  }

  Future<void> _updateConversationIfLatestMsg(String conversationID, String clientMsgID) async {
    final ConversationInfo? conv = await _context.db.conversations.getConversation(conversationID);
    if (conv?.latestMsg == null || conv!.latestMsg!.clientMsgID != clientMsgID) {
      return;
    }
    final List<Message> latest = await _context.db.messages.getHistoryMessages(
      conversationID: conversationID,
      count: 1,
    );
    if (latest.isNotEmpty) {
      await _context.db.conversations.updateConversation(conversationID, <String, dynamic>{
        'latestMsg': jsonEncode(latest.first.toJson()),
        'latestMsgSendTime': latest.first.sendTime,
      });
    } else {
      await _context.db.conversations.updateConversation(conversationID, <String, dynamic>{
        'latestMsg': '',
        'latestMsgSendTime': 0,
      });
    }
    final ConversationInfo? updated = await _context.db.conversations.getConversation(
      conversationID,
    );
    if (updated != null) {
      _conversationListenerProvider()?.conversationChanged(<ConversationInfo>[updated]);
    }
  }

  Future<void> _notifyConversationAndUnread(String conversationID) async {
    final OnConversationListener? convListener = _conversationListenerProvider();
    final ConversationInfo? conv = await _context.db.conversations.getConversation(conversationID);
    if (conv != null) {
      convListener?.conversationChanged(<ConversationInfo>[conv]);
    }
    final int total = await _context.db.conversations.getTotalUnreadCount();
    convListener?.totalUnreadMessageCountChanged(total);
  }
}
