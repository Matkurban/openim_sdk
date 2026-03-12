import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/network/ws_constants.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:openim_sdk/src/services/web_socket_service.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';

/// 消息管理器
/// 对应 open-im-sdk-flutter 中 MessageManager。
/// 负责消息的创建、发送、接收、查询、删除和监听回调。
class MessageManager {
  static final Logger _log = Logger('MessageManager');

  DatabaseService get _database =>
      GetIt.instance.get<DatabaseService>(instanceName: InstanceName.databaseService);

  ImApiService get _api =>
      GetIt.instance.get<ImApiService>(instanceName: InstanceName.imApiService);

  WebSocketService get _ws =>
      GetIt.instance.get<WebSocketService>(instanceName: InstanceName.webSocketService);

  /// 消息监听器
  OnAdvancedMsgListener? msgListener;

  /// 消息发送进度监听器
  OnMsgSendProgressListener? msgSendProgressListener;

  /// 自定义业务消息监听器
  OnCustomBusinessListener? customBusinessListener;

  /// 设置消息监听器
  void setAdvancedMsgListener(OnAdvancedMsgListener listener) {
    msgListener = listener;
  }

  /// 设置消息发送进度监听器
  void setMsgSendProgressListener(OnMsgSendProgressListener listener) {
    msgSendProgressListener = listener;
  }

  /// 设置自定义业务消息监听器
  void setCustomBusinessListener(OnCustomBusinessListener listener) {
    customBusinessListener = listener;
  }

  // ---------------------------------------------------------------------------
  // 消息创建方法族
  // ---------------------------------------------------------------------------

  /// 创建文本消息
  /// [text] 文本内容
  Message createTextMessage({required String text}) {
    return _createMessage(
      contentType: MessageType.text,
      textElem: TextElem(content: text),
    );
  }

  /// 创建 @ 消息
  /// [text] 输入内容
  /// [atUserIDList] 被 @ 的用户ID集合
  /// [atUserInfoList] 用户ID到昵称的映射，用于在界面上展示昵称而非ID
  /// [quoteMessage] 被引用的消息（即被回复的消息）
  Message createTextAtMessage({
    required String text,
    required List<String> atUserIDList,
    List<AtUserInfo> atUserInfoList = const [],
    Message? quoteMessage,
  }) {
    return _createMessage(
      contentType: MessageType.atText,
      atTextElem: AtTextElem(
        text: text,
        atUserList: atUserIDList,
        atUsersInfo: atUserInfoList,
        quoteMessage: quoteMessage,
      ),
    );
  }

  /// 创建图片消息（本地文件路径）
  /// [imagePath] 图片路径
  Message createImageMessage({required String imagePath}) {
    return _createMessage(
      contentType: MessageType.picture,
      pictureElem: PictureElem(sourcePath: imagePath),
    );
  }

  /// 创建语音消息
  /// [soundPath] 语音文件路径
  /// [duration] 时长（秒）
  Message createSoundMessage({required String soundPath, required int duration}) {
    return _createMessage(
      contentType: MessageType.voice,
      soundElem: SoundElem(soundPath: soundPath, duration: duration),
    );
  }

  /// 创建视频消息
  /// [videoPath] 视频文件路径
  /// [videoType] 视频MIME类型
  /// [duration] 时长（秒）
  /// [snapshotPath] 缩略图路径
  Message createVideoMessage({
    required String videoPath,
    required String videoType,
    required int duration,
    required String snapshotPath,
  }) {
    return _createMessage(
      contentType: MessageType.video,
      videoElem: VideoElem(
        videoPath: videoPath,
        videoType: videoType,
        duration: duration,
        snapshotPath: snapshotPath,
      ),
    );
  }

  /// 创建文件消息
  /// [filePath] 文件路径
  /// [fileName] 文件名
  Message createFileMessage({required String filePath, required String fileName}) {
    return _createMessage(
      contentType: MessageType.file,
      fileElem: FileElem(filePath: filePath, fileName: fileName),
    );
  }

  /// 创建合并消息
  /// [messageList] 选中的消息列表
  /// [title] 摘要标题
  /// [summaryList] 摘要内容列表
  Message createMergerMessage({
    required List<Message> messageList,
    required String title,
    required List<String> summaryList,
  }) {
    return _createMessage(
      contentType: MessageType.merger,
      mergeElem: MergeElem(title: title, abstractList: summaryList, multiMessage: messageList),
    );
  }

  /// 创建转发消息
  /// [message] 被转发的消息
  Message createForwardMessage({required Message message}) {
    return message.copyWith(
      clientMsgID: _generateClientMsgID(),
      createTime: _nowMillis(),
      sendTime: 0,
      status: MessageStatus.sending,
      sendID: _database.currentUserID,
    );
  }

  /// 创建位置消息
  /// [latitude] 纬度
  /// [longitude] 经度
  /// [description] 描述
  Message createLocationMessage({
    required double latitude,
    required double longitude,
    required String description,
  }) {
    return _createMessage(
      contentType: MessageType.location,
      locationElem: LocationElem(
        description: description,
        longitude: longitude,
        latitude: latitude,
      ),
    );
  }

  /// 创建自定义消息
  /// [data] 自定义数据
  /// [extension] 自定义扩展内容
  /// [description] 自定义描述内容
  Message createCustomMessage({
    required String data,
    required String extension,
    required String description,
  }) {
    return _createMessage(
      contentType: MessageType.custom,
      customElem: CustomElem(data: data, extension: extension, description: description),
    );
  }

  /// 创建引用消息
  /// [text] 回复内容
  /// [quoteMsg] 被引用的消息
  Message createQuoteMessage({required String text, required Message quoteMsg}) {
    return _createMessage(
      contentType: MessageType.quote,
      quoteElem: QuoteElem(text: text, quoteMessage: quoteMsg),
    );
  }

  /// 创建名片消息
  /// [userID] 用户ID
  /// [nickname] 昵称
  /// [faceURL] 头像URL
  /// [ex] 扩展信息
  Message createCardMessage({
    required String userID,
    required String nickname,
    String? faceURL,
    String? ex,
  }) {
    return _createMessage(
      contentType: MessageType.card,
      cardElem: CardElem(userID: userID, nickname: nickname, faceURL: faceURL, ex: ex),
    );
  }

  /// 创建自定义表情消息
  /// [index] 位置表情，根据index匹配
  /// [data] URL表情，直接使用URL展示
  Message createFaceMessage({int index = -1, String? data}) {
    return _createMessage(
      contentType: MessageType.customFace,
      faceElem: FaceElem(index: index, data: data ?? ''),
    );
  }

  /// 创建高级文本消息（富文本）
  /// [text] 输入内容
  /// [list] 富文本消息详情
  Message createAdvancedTextMessage({required String text, List<RichMessageInfo> list = const []}) {
    return _createMessage(
      contentType: MessageType.advancedText,
      advancedTextElem: AdvancedTextElem(
        text: text,
        messageEntityList: list
            .map(
              (e) => MessageEntity(
                type: e.type,
                offset: e.offset,
                length: e.length,
                url: e.url,
                ex: e.info,
              ),
            )
            .toList(),
      ),
    );
  }

  /// 创建高级引用消息（富文本引用）
  /// [text] 回复内容
  /// [quoteMsg] 被引用的消息
  /// [list] 富文本消息详情
  Message createAdvancedQuoteMessage({
    required String text,
    required Message quoteMsg,
    List<RichMessageInfo> list = const [],
  }) {
    final entities = list
        .map(
          (e) => MessageEntity(
            type: e.type,
            offset: e.offset,
            length: e.length,
            url: e.url,
            ex: e.info,
          ),
        )
        .toList();

    return _createMessage(
      contentType: MessageType.quote,
      quoteElem: QuoteElem(text: text, quoteMessage: quoteMsg),
      advancedTextElem: AdvancedTextElem(text: text, messageEntityList: entities),
    );
  }

  /// 通过URL创建图片消息
  /// [sourcePicture] 原图信息
  /// [bigPicture] 大图信息
  /// [snapshotPicture] 缩略图信息
  /// [sourcePath] 原图路径
  Message createImageMessageByURL({
    required PictureInfo sourcePicture,
    required PictureInfo bigPicture,
    required PictureInfo snapshotPicture,
    String? sourcePath,
  }) {
    return _createMessage(
      contentType: MessageType.picture,
      pictureElem: PictureElem(
        sourcePath: sourcePath,
        sourcePicture: sourcePicture,
        bigPicture: bigPicture,
        snapshotPicture: snapshotPicture,
      ),
    );
  }

  /// 通过URL创建语音消息
  /// [soundElem] 语音消息元素
  Message createSoundMessageByURL({required SoundElem soundElem}) {
    return _createMessage(contentType: MessageType.voice, soundElem: soundElem);
  }

  /// 通过URL创建视频消息
  /// [videoElem] 视频消息元素
  Message createVideoMessageByURL({required VideoElem videoElem}) {
    return _createMessage(contentType: MessageType.video, videoElem: videoElem);
  }

  /// 通过URL创建文件消息
  /// [fileElem] 文件消息元素
  Message createFileMessageByURL({required FileElem fileElem}) {
    return _createMessage(contentType: MessageType.file, fileElem: fileElem);
  }

  // ---------------------------------------------------------------------------
  // 消息发送
  // ---------------------------------------------------------------------------

  /// 发送消息
  /// [message] 消息内容
  /// [offlinePushInfo] 离线消息显示内容
  /// [userID] 接收者用户ID
  /// [groupID] 接收群组ID
  /// [isOnlineOnly] 是否仅在线发送
  Future<Message> sendMessage({
    required Message message,
    required OfflinePushInfo offlinePushInfo,
    String? userID,
    String? groupID,
    bool isOnlineOnly = false,
  }) async {
    final isGroupMsg = groupID != null && groupID.isNotEmpty;
    final sessionType = isGroupMsg ? ConversationType.superGroup : ConversationType.single;

    final sendMsg = message.copyWith(
      sendID: _database.currentUserID,
      recvID: userID,
      groupID: groupID,
      sessionType: sessionType,
      status: MessageStatus.sending,
      offlinePush: offlinePushInfo,
    );

    final conversationID = isGroupMsg
        ? ConversationManager.genGroupConversationID(groupID)
        : ConversationManager.genSingleConversationID(_database.currentUserID, userID!);

    await _database.insertMessage(_messageToDbMap(sendMsg));
    await _database.insertSendingMessage(sendMsg.clientMsgID!, conversationID);

    _log.info('消息已发送到本地: ${sendMsg.clientMsgID}');

    // 通过 REST API 发送消息（避免 WebSocket protobuf 编码问题）
    final apiMsgData = _buildRestApiMsgData(sendMsg, isOnlineOnly: isOnlineOnly);

    try {
      final resp = await _api.sendMsg(msgData: apiMsgData);

      if (resp.errCode == 0) {
        final respData = resp.data as Map<String, dynamic>? ?? {};
        final serverMsgID = respData['serverMsgID'] as String?;
        final serverSendTime = respData['sendTime'] as int? ?? _nowMillis();

        final sentMsg = sendMsg.copyWith(
          status: MessageStatus.succeeded,
          sendTime: serverSendTime,
          serverMsgID: serverMsgID,
        );
        await _database.updateMessage(sentMsg.clientMsgID!, {
          'status': MessageStatus.succeeded.value,
          'sendTime': sentMsg.sendTime,
          'serverMsgID': serverMsgID,
        });
        await _database.deleteSendingMessage(sentMsg.clientMsgID!);
        await _updateConversationLatestMsg(conversationID, sentMsg, sessionType);
        return sentMsg;
      } else {
        _log.warning('消息发送失败: ${resp.errMsg}');
        final failedMsg = sendMsg.copyWith(status: MessageStatus.failed);
        await _database.updateMessage(failedMsg.clientMsgID!, {
          'status': MessageStatus.failed.value,
        });
        await _database.deleteSendingMessage(failedMsg.clientMsgID!);
        return failedMsg;
      }
    } catch (e) {
      _log.warning('消息发送异常: $e');
      final failedMsg = sendMsg.copyWith(status: MessageStatus.failed);
      await _database.updateMessage(failedMsg.clientMsgID!, {'status': MessageStatus.failed.value});
      await _database.deleteSendingMessage(failedMsg.clientMsgID!);
      return failedMsg;
    }
  }

  /// 发送消息（不通过OSS上传）
  /// [message] 消息体（使用 createXxxByURL 创建）
  /// [offlinePushInfo] 离线消息显示内容
  /// [userID] 接收者用户ID
  /// [groupID] 接收群组ID
  /// [isOnlineOnly] 是否仅在线发送
  Future<Message> sendMessageNotOss({
    required Message message,
    required OfflinePushInfo offlinePushInfo,
    String? userID,
    String? groupID,
    bool isOnlineOnly = false,
  }) {
    return sendMessage(
      message: message,
      offlinePushInfo: offlinePushInfo,
      userID: userID,
      groupID: groupID,
      isOnlineOnly: isOnlineOnly,
    );
  }

  // ---------------------------------------------------------------------------
  // 消息查询
  // ---------------------------------------------------------------------------

  /// 获取历史消息列表（startMsg之前的消息）
  /// [conversationID] 会话ID
  /// [startMsg] 从此消息开始查询，null 则从最新开始
  /// [viewType] 查看类型
  /// [count] 获取条数
  Future<AdvancedMessage> getAdvancedHistoryMessageList({
    String? conversationID,
    Message? startMsg,
    GetHistoryViewType viewType = GetHistoryViewType.history,
    int? count,
  }) async {
    final queryCount = count ?? 40;
    int startTime = startMsg?.sendTime ?? 0;

    if (startMsg?.clientMsgID != null && startMsg!.clientMsgID!.isNotEmpty) {
      final data = await _database.getMessage(startMsg.clientMsgID!);
      final dbSendTime = (data?['sendTime'] as int?) ?? 0;
      if (dbSendTime > 0) {
        startTime = dbSendTime;
      }
    }

    final conv = await _database.getConversation(conversationID ?? '');
    if (conv == null) {
      return AdvancedMessage(messageList: [], isEnd: true);
    }

    var dataList = await _database.getHistoryMessages(
      conversationID: conversationID ?? '',
      startTime: startTime,
      startSeq: startMsg?.seq ?? 0,
      startClientMsgID: startMsg?.clientMsgID ?? '',
      count: queryCount + 1,
    );

    // 如果本地数据不足，尝试从云端拉取
    // 对应 Go SDK 的 fetchMessagesWithGapCheck：先本地后云端
    final convMaxSeq = conv['maxSeq'] as int? ?? 0;
    if (dataList.length <= queryCount && convMaxSeq > 0) {
      // 确定从哪个 seq 开始向前拉取
      int currentSeq;
      if (startMsg != null && (startMsg.seq ?? 0) > 1) {
        currentSeq = startMsg.seq!;
        if (dataList.isNotEmpty) {
          currentSeq = dataList.last['seq'] as int? ?? currentSeq;
        }
      } else if (dataList.isNotEmpty) {
        // 有本地数据但不足，从最早一条的 seq 向前拉取
        currentSeq = dataList.last['seq'] as int? ?? convMaxSeq;
      } else {
        // 无本地数据，从会话 maxSeq 开始拉取最新消息
        currentSeq = convMaxSeq + 1;
      }

      if (currentSeq > 1) {
        final beginSeq = (currentSeq - queryCount).clamp(1, currentSeq);
        final endSeq = currentSeq - 1;
        if (endSeq >= beginSeq) {
          try {
            final resp = await _api.pullMsgBySeqs(
              userID: _database.currentUserID,
              seqRanges: [
                {
                  'conversationID': conversationID,
                  'begin': beginSeq,
                  'end': endSeq,
                  'num': queryCount,
                },
              ],
              order: 1, // 降序
            );
            if (resp.errCode == 0) {
              final data = resp.data as Map<String, dynamic>? ?? {};
              final msgsJson = data['msgs'] as Map<String, dynamic>? ?? {};
              final convMsgs = msgsJson[conversationID] as Map<String, dynamic>? ?? {};
              final pulledMsgs = (convMsgs['Msgs'] ?? convMsgs['msgs']) as List? ?? [];

              final batchInsert = <Map<String, dynamic>>[];
              for (final netMsg in pulledMsgs) {
                if (netMsg is Map) {
                  final m = Map<String, dynamic>.from(netMsg);
                  m['conversationID'] = conversationID;
                  if ((m['contentType'] as int? ?? 0) < 1000) {
                    batchInsert.add(m);
                  }
                }
              }
              if (batchInsert.isNotEmpty) {
                await _database.batchInsertMessages(batchInsert);
                // 重新查询使得本地有序并拼接新数据
                dataList = await _database.getHistoryMessages(
                  conversationID: conversationID ?? '',
                  startTime: startTime,
                  startSeq: startMsg?.seq ?? 0,
                  startClientMsgID: startMsg?.clientMsgID ?? '',
                  count: queryCount + 1,
                );
              }
            }
          } catch (e) {
            _log.warning('云端历史消息拉取失败: $e');
          }
        }
      }
    }

    final isEnd = dataList.length <= queryCount;
    final actualData = isEnd ? dataList : dataList.sublist(0, queryCount);

    return AdvancedMessage(messageList: actualData.map(_convertMessage).toList(), isEnd: isEnd);
  }

  /// 反向获取历史消息（startMsg之后接收的消息）
  /// [conversationID] 会话ID
  /// [startMsg] 从此消息开始查询
  /// [viewType] 查看类型
  /// [count] 获取条数
  Future<AdvancedMessage> getAdvancedHistoryMessageListReverse({
    String? conversationID,
    Message? startMsg,
    GetHistoryViewType viewType = GetHistoryViewType.history,
    int? count,
  }) async {
    final result = await getAdvancedHistoryMessageList(
      conversationID: conversationID,
      startMsg: startMsg,
      viewType: viewType,
      count: count,
    );
    return result.copyWith(messageList: result.messageList?.reversed.toList());
  }

  /// 根据消息ID列表查找消息
  /// [searchParams] 搜索参数列表
  Future<SearchResult> findMessageList({required List<SearchParams> searchParams}) async {
    final resultItems = <SearchResultItems>[];
    int totalCount = 0;

    for (final param in searchParams) {
      if (param.clientMsgIDList == null || param.clientMsgIDList!.isEmpty) continue;
      final messages = <Message>[];
      for (final id in param.clientMsgIDList!) {
        final data = await _database.getMessage(id);
        if (data != null) messages.add(_convertMessage(data));
      }
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

  /// 搜索本地消息
  /// [conversationID] 根据会话查询，传null则全局搜索
  /// [keywordList] 搜索关键字列表
  /// [keywordListMatchType] 关键字匹配模式，1为AND，2为OR
  /// [senderUserIDList] 指定发送者ID列表
  /// [messageTypeList] 消息类型列表
  /// [searchTimePosition] 搜索起始时间点，默认0即从当前开始
  /// [searchTimePeriod] 从起始时间点往过去的时间范围，秒
  /// [pageIndex] 当前页码
  /// [count] 每页消息数
  Future<SearchResult> searchLocalMessages({
    String? conversationID,
    List<String> keywordList = const [],
    int keywordListMatchType = 0,
    List<String> senderUserIDList = const [],
    List<int> messageTypeList = const [],
    int searchTimePosition = 0,
    int searchTimePeriod = 0,
    int pageIndex = 1,
    int count = 40,
  }) async {
    final keyword = keywordList.isNotEmpty ? keywordList.first : null;
    final offset = (pageIndex - 1) * count;

    final dataList = await _database.searchMessages(
      conversationID: conversationID,
      keyword: keyword,
      messageTypes: messageTypeList.isEmpty ? null : messageTypeList,
      startTime: searchTimePosition > 0 ? searchTimePosition : null,
      endTime: searchTimePeriod > 0 ? searchTimePosition + searchTimePeriod : null,
      offset: offset,
      count: count,
    );

    final messages = dataList.map(_convertMessage).toList();
    return SearchResult(
      totalCount: messages.length,
      searchResultItems: [
        SearchResultItems(
          conversationID: conversationID,
          messageCount: messages.length,
          messageList: messages,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 消息操作
  // ---------------------------------------------------------------------------

  /// 撤回消息
  /// [conversationID] 会话ID
  /// [clientMsgID] 消息ID
  Future<void> revokeMessage({required String conversationID, required String clientMsgID}) async {
    // 获取消息的 seq 用于服务端撤回
    final msgData = await _database.getMessage(clientMsgID);
    final seq = msgData?['seq'] as int? ?? 0;

    await _database.updateMessage(clientMsgID, {
      'contentType': MessageType.revokeNotification.value,
    });
    _log.info('消息已撤回: $clientMsgID');

    msgListener?.newRecvMessageRevoked(
      RevokedInfo(
        clientMsgID: clientMsgID,
        revokerID: _database.currentUserID,
        revokeTime: _nowMillis(),
      ),
    );

    // 同步到服务器
    if (seq > 0) {
      final resp = await _api.revokeMsg(
        userID: _database.currentUserID,
        conversationID: conversationID,
        seq: seq,
      );
      if (resp.errCode != 0) {
        _log.warning('撤回消息同步服务器失败: ${resp.errMsg}');
      }
    }
  }

  /// 删除消息（仅从本地存储删除）
  /// [conversationID] 会话ID
  /// [clientMsgID] 消息ID
  Future<void> deleteMessageFromLocalStorage({
    required String conversationID,
    required String clientMsgID,
  }) async {
    await _database.deleteMessage(clientMsgID);
    _log.info('消息已从本地删除: $clientMsgID');
  }

  /// 删除消息（本地和服务器）
  /// [conversationID] 会话ID
  /// [clientMsgID] 消息ID
  Future<void> deleteMessageFromLocalAndSvr({
    required String conversationID,
    required String clientMsgID,
  }) async {
    // 获取消息的 seq 用于服务端删除
    final msgData = await _database.getMessage(clientMsgID);
    final seq = msgData?['seq'] as int? ?? 0;

    await _database.deleteMessage(clientMsgID);
    _log.info('消息已从本地和服务器删除: $clientMsgID');

    // 同步到服务器
    if (seq > 0) {
      final resp = await _api.deleteMsgs(
        userID: _database.currentUserID,
        conversationID: conversationID,
        seqs: [seq],
      );
      if (resp.errCode != 0) {
        _log.warning('删除消息同步服务器失败: ${resp.errMsg}');
      }
    }
  }

  /// 删除所有本地消息
  Future<void> deleteAllMsgFromLocal() async {
    await _database.deleteAllMessages();
    _log.info('所有本地消息已删除');
  }

  /// 删除所有消息（本地和服务器）
  Future<void> deleteAllMsgFromLocalAndSvr() async {
    await _database.deleteAllMessages();
    _log.info('所有消息已从本地和服务器删除');

    // 同步到服务器
    final resp = await _api.clearAllMsg(userID: _database.currentUserID);
    if (resp.errCode != 0) {
      _log.warning('清空所有消息同步服务器失败: ${resp.errMsg}');
    }
  }

  /// 标记消息已读
  /// [conversationID] 会话ID
  /// [messageIDList] 消息clientMsgID列表
  @Deprecated('Use markConversationMessageAsRead instead')
  Future<void> markMessagesAsReadByMsgID({
    required String conversationID,
    required List<String> messageIDList,
  }) async {
    await _database.markMessagesAsRead(messageIDList);
    _log.info('消息已标记已读: ${messageIDList.length}条');
  }

  /// 设置消息本地扩展信息
  /// [conversationID] 会话ID
  /// [clientMsgID] 消息ID
  /// [localEx] 本地扩展信息
  Future<void> setMessageLocalEx({
    required String conversationID,
    required String clientMsgID,
    required String localEx,
  }) async {
    await _database.updateMessage(clientMsgID, {'localEx': localEx});
  }

  /// 插入单聊消息到本地存储
  /// [receiverID] 接收者ID
  /// [senderID] 发送者ID
  /// [message] 消息内容
  Future<Message> insertSingleMessageToLocalStorage({
    String? receiverID,
    String? senderID,
    Message? message,
  }) async {
    final msg = (message ?? _createMessage(contentType: MessageType.text)).copyWith(
      sendID: senderID,
      recvID: receiverID,
      sessionType: ConversationType.single,
    );
    await _database.insertMessage(_messageToDbMap(msg));
    return msg;
  }

  /// 插入群聊消息到本地存储
  /// [groupID] 群组ID
  /// [senderID] 发送者ID
  /// [message] 消息内容
  Future<Message> insertGroupMessageToLocalStorage({
    String? groupID,
    String? senderID,
    Message? message,
  }) async {
    final msg = (message ?? _createMessage(contentType: MessageType.text)).copyWith(
      sendID: senderID,
      groupID: groupID,
      sessionType: ConversationType.superGroup,
    );
    await _database.insertMessage(_messageToDbMap(msg));
    return msg;
  }

  /// 设置应用角标
  /// [count] 角标数量
  Future<void> setAppBadge(int count, {String? operationID}) async {
    // TODO: 调用原生平台设置角标
    _log.info('设置应用角标: $count');
  }

  // ---------------------------------------------------------------------------
  // 兼容 open-im-sdk-flutter 的 FullPath 方法
  // ---------------------------------------------------------------------------

  /// 创建图片消息（通过完整文件路径）
  /// [imagePath] 图片的完整路径
  Message createImageMessageFromFullPath({required String imagePath, String? operationID}) {
    return createImageMessage(imagePath: imagePath);
  }

  /// 创建语音消息（通过完整文件路径）
  /// [soundPath] 语音文件的完整路径
  /// [duration] 时长（秒）
  Message createSoundMessageFromFullPath({
    required String soundPath,
    required int duration,
    String? operationID,
  }) {
    return createSoundMessage(soundPath: soundPath, duration: duration);
  }

  /// 创建视频消息（通过完整文件路径）
  /// [videoPath] 视频文件的完整路径
  /// [videoType] 视频MIME类型
  /// [duration] 时长（秒）
  /// [snapshotPath] 缩略图完整路径
  Message createVideoMessageFromFullPath({
    required String videoPath,
    required String videoType,
    required int duration,
    required String snapshotPath,
    String? operationID,
  }) {
    return createVideoMessage(
      videoPath: videoPath,
      videoType: videoType,
      duration: duration,
      snapshotPath: snapshotPath,
    );
  }

  /// 创建文件消息（通过完整文件路径）
  /// [filePath] 文件的完整路径
  /// [fileName] 文件名
  Message createFileMessageFromFullPath({
    required String filePath,
    required String fileName,
    String? operationID,
  }) {
    return createFileMessage(filePath: filePath, fileName: fileName);
  }

  /// 输入状态更新
  /// [userID] 用户ID
  /// [msgTip] 提示消息
  @Deprecated('Use ConversationManager.changeInputStates instead')
  Future typingStatusUpdate({required String userID, String? msgTip, String? operationID}) async {
    final focus = msgTip != null && msgTip.isNotEmpty && msgTip != 'no';
    final msgData = _buildTypingMsgData(
      conversationID: '',
      focus: focus,
      recvID: userID,
      sessionType: ConversationType.single,
    );
    try {
      final wsData = Uint8List.fromList(utf8.encode(jsonEncode(msgData)));
      await _ws.sendReqWaitResp(reqIdentifier: WsReqIdentifier.sendMsg, data: wsData);
    } catch (e) {
      _log.warning('发送输入状态失败: $e');
    }
  }

  /// 创建图片消息通过URL（兼容 open-im-sdk-flutter 3参数签名）
  /// [sourcePicture] 原图信息
  /// [bigPicture] 大图信息
  /// [snapshotPicture] 缩略图信息
  /// [sourcePath] 原图路径
  @Deprecated('Use [createImageMessageByURL] instead')
  Message createImageMessageByURLCompat({
    required PictureInfo sourcePicture,
    required PictureInfo bigPicture,
    required PictureInfo snapshotPicture,
    String? sourcePath,
    String? operationID,
  }) {
    return createImageMessageByURL(
      sourcePicture: sourcePicture,
      bigPicture: bigPicture,
      snapshotPicture: snapshotPicture,
      sourcePath: sourcePath,
    );
  }

  // ---------------------------------------------------------------------------
  // 消息接收处理（供内部模块调用）
  // ---------------------------------------------------------------------------

  /// 处理收到的新消息
  void onRecvNewMessage(Message message) {
    msgListener?.recvNewMessage(message);
  }

  /// 处理收到的离线消息
  void onRecvOfflineNewMessage(Message message) {
    msgListener?.recvOfflineNewMessage(message);
  }

  // ---------------------------------------------------------------------------
  // 私有辅助方法
  // ---------------------------------------------------------------------------

  /// 构造 REST API 发送消息的请求体
  ///
  /// 对应 Go SDK api_msg_sender.go 中的 SendMsgReq 结构，
  /// content 字段为 Map，内含 JSON 序列化后的元素内容。
  Map<String, dynamic> _buildRestApiMsgData(Message msg, {bool isOnlineOnly = false}) {
    final content = _extractContent(msg);

    final data = <String, dynamic>{
      'sendID': msg.sendID,
      'recvID': msg.recvID ?? '',
      'groupID': msg.groupID ?? '',
      'senderNickname': msg.senderNickname ?? '',
      'senderFaceURL': msg.senderFaceUrl ?? '',
      'senderPlatformID': msg.senderPlatformID?.value ?? PlatformUtils.currentPlatform.value,
      'contentType': msg.contentType?.value ?? MessageType.text.value,
      'sessionType': msg.sessionType?.value ?? ConversationType.single.value,
      'content': {'content': content},
      'isOnlineOnly': isOnlineOnly,
    };

    // 离线推送信息
    if (msg.offlinePush != null) {
      data['offlinePushInfo'] = msg.offlinePush!.toJson();
    }

    return data;
  }

  /// 从消息对象中提取 content 字符串（JSON 编码的 Elem）
  String _extractContent(Message msg) {
    if (msg.textElem != null) return jsonEncode(msg.textElem!.toJson());
    if (msg.pictureElem != null) return jsonEncode(msg.pictureElem!.toJson());
    if (msg.soundElem != null) return jsonEncode(msg.soundElem!.toJson());
    if (msg.videoElem != null) return jsonEncode(msg.videoElem!.toJson());
    if (msg.fileElem != null) return jsonEncode(msg.fileElem!.toJson());
    if (msg.locationElem != null) return jsonEncode(msg.locationElem!.toJson());
    if (msg.customElem != null) return jsonEncode(msg.customElem!.toJson());
    if (msg.quoteElem != null) return jsonEncode(msg.quoteElem!.toJson());
    if (msg.mergeElem != null) return jsonEncode(msg.mergeElem!.toJson());
    if (msg.faceElem != null) return jsonEncode(msg.faceElem!.toJson());
    if (msg.cardElem != null) return jsonEncode(msg.cardElem!.toJson());
    if (msg.atTextElem != null) return jsonEncode(msg.atTextElem!.toJson());
    if (msg.advancedTextElem != null) return jsonEncode(msg.advancedTextElem!.toJson());
    return '';
  }

  /// 构造输入状态（Typing）消息的 MsgData
  Map<String, dynamic> _buildTypingMsgData({
    required String conversationID,
    required bool focus,
    String? recvID,
    String? groupID,
    ConversationType sessionType = ConversationType.single,
  }) {
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
    return {
      'sendID': _database.currentUserID,
      'recvID': recvID ?? '',
      'groupID': groupID ?? '',
      'clientMsgID': _generateClientMsgID(),
      'sessionType': sessionType.value,
      'msgFrom': 100,
      'contentType': 113, // Typing
      'content': jsonEncode(typingElem),
      'senderPlatformID': PlatformUtils.currentPlatform.value,
      'createTime': _nowMillis(),
      'sendTime': 0,
      'options': options,
    };
  }

  /// 生成唯一消息 ID
  String _generateClientMsgID() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = Random.secure().nextInt(999999999);
    final raw = '$timestamp-$random-${_database.currentUserID}';
    return md5.convert(utf8.encode(raw)).toString();
  }

  /// 获取当前时间戳（毫秒）
  int _nowMillis() => DateTime.now().millisecondsSinceEpoch;

  /// 创建消息的通用工厂方法
  Message _createMessage({
    required MessageType contentType,
    TextElem? textElem,
    PictureElem? pictureElem,
    SoundElem? soundElem,
    VideoElem? videoElem,
    FileElem? fileElem,
    AtTextElem? atTextElem,
    LocationElem? locationElem,
    CustomElem? customElem,
    QuoteElem? quoteElem,
    MergeElem? mergeElem,
    FaceElem? faceElem,
    CardElem? cardElem,
    AdvancedTextElem? advancedTextElem,
  }) {
    return Message(
      clientMsgID: _generateClientMsgID(),
      createTime: _nowMillis(),
      sendTime: 0,
      sendID: _database.currentUserID,
      contentType: contentType,
      senderPlatformID: PlatformUtils.currentPlatform,
      status: MessageStatus.sending,
      textElem: textElem,
      pictureElem: pictureElem,
      soundElem: soundElem,
      videoElem: videoElem,
      fileElem: fileElem,
      atTextElem: atTextElem,
      locationElem: locationElem,
      customElem: customElem,
      quoteElem: quoteElem,
      mergeElem: mergeElem,
      faceElem: faceElem,
      cardElem: cardElem,
      advancedTextElem: advancedTextElem,
    );
  }

  /// 更新会话的最新消息
  Future<void> _updateConversationLatestMsg(
    String conversationID,
    Message message,
    ConversationType sessionType,
  ) async {
    final conv = await _database.getConversation(conversationID);
    if (conv != null) {
      await _database.updateConversation(conversationID, {
        'latestMsg': jsonEncode(message.toJson()),
        'latestMsgSendTime': message.sendTime,
      });
    } else {
      await _database.upsertConversation({
        'conversationID': conversationID,
        'conversationType': sessionType.value,
        'userID': message.recvID,
        'groupID': message.groupID,
        'latestMsg': jsonEncode(message.toJson()),
        'latestMsgSendTime': message.sendTime,
        'unreadCount': 0,
      });
    }
  }

  /// 数据库 Map 转 Message 对象
  Message _convertMessage(Map<String, dynamic> data) {
    final contentTypeValue = data['contentType'] as int?;
    final content = data['content'] as String?;
    Map<String, dynamic>? contentMap;
    if (content != null && content.isNotEmpty) {
      try {
        contentMap = jsonDecode(content) as Map<String, dynamic>;
      } catch (_) {}
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
  Map<String, dynamic> _messageToDbMap(Message msg) {
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

  /// int 转 ConversationType
  static ConversationType? _intToConversationType(int? value) {
    if (value == null) return null;
    return ConversationType.values.cast<ConversationType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  /// int 转 MessageType
  static MessageType? _intToMessageType(int? value) {
    if (value == null) return null;
    return MessageType.values.cast<MessageType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  /// int 转 MessageStatus
  static MessageStatus? _intToMessageStatus(int? value) {
    if (value == null) return null;
    return MessageStatus.values.cast<MessageStatus?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  /// int 转 IMPlatform
  static IMPlatform? _intToIMPlatform(int? value) {
    if (value == null) return null;
    return IMPlatform.values.cast<IMPlatform?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }
}
