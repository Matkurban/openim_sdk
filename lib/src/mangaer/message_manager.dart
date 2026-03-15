import 'dart:convert';
import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/models/web_socket_identifier.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:openim_sdk/src/services/web_socket_service.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';
import 'package:openim_sdk/protocol_gen/sdkws/sdkws.pb.dart' as sdkws;

class MessageManager {
  static final Logger _log = Logger('MessageManager');

  final GetIt _getIt = GetIt.instance;

  /// 会话管理器引用，用于发送消息后触发会话变更回调
  ConversationManager? _conversationManager;

  DatabaseService get _database {
    return _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  ImApiService get _api {
    return _getIt.get<ImApiService>(instanceName: InstanceName.imApiService);
  }

  WebSocketService get _webSocketService {
    return _getIt.get<WebSocketService>(instanceName: InstanceName.webSocketService);
  }

  OnMsgSendProgressListener? msgSendProgressListener;

  OnAdvancedMsgListener? msgListener;

  OnCustomBusinessListener? customBusinessListener;

  late String _currentUserID;

  void setMsgSendProgressListener(OnMsgSendProgressListener listener) {
    msgSendProgressListener = listener;
  }

  void setAdvancedMsgListener(OnAdvancedMsgListener listener) {
    msgListener = listener;
  }

  void setCustomBusinessListener(OnCustomBusinessListener listener) {
    customBusinessListener = listener;
  }

  @internal
  void setConversationManager(ConversationManager manager) {
    _conversationManager = manager;
  }

  @internal
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  /// 创建文本消息
  /// [text] 文本内容
  Message createTextMessage({required String text}) {
    _log.info('createTextMessage: text=$text');
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
    _log.info('createTextAtMessage: text=$text, atUserIDList=$atUserIDList');
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
    _log.info('createImageMessage: imagePath=$imagePath');
    return _createMessage(
      contentType: MessageType.picture,
      pictureElem: PictureElem(sourcePath: imagePath),
    );
  }

  /// 创建语音消息
  /// [soundPath] 语音文件路径
  /// [duration] 时长（秒）
  Message createSoundMessage({required String soundPath, required int duration}) {
    _log.info('createSoundMessage: soundPath=$soundPath, duration=$duration');
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
    _log.info('createVideoMessage: videoPath=$videoPath, videoType=$videoType, duration=$duration');
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
    _log.info('createFileMessage: filePath=$filePath, fileName=$fileName');
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
    _log.info('createMergerMessage: title=$title, messageCount=${messageList.length}');
    return _createMessage(
      contentType: MessageType.merger,
      mergeElem: MergeElem(title: title, abstractList: summaryList, multiMessage: messageList),
    );
  }

  /// 创建转发消息
  /// [message] 被转发的消息
  Message createForwardMessage({required Message message}) {
    _log.info('createForwardMessage: clientMsgID=${message.clientMsgID}');
    return message.copyWith(
      clientMsgID: OpenImUtils.generateClientMsgID(_currentUserID),
      createTime: _nowMillis(),
      sendTime: 0,
      status: MessageStatus.sending,
      sendID: _currentUserID,
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
    _log.info(
      'createLocationMessage: latitude=$latitude, longitude=$longitude, description=$description',
    );
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
    _log.info('createCustomMessage: description=$description');
    return _createMessage(
      contentType: MessageType.custom,
      customElem: CustomElem(data: data, extension: extension, description: description),
    );
  }

  /// 创建引用消息
  /// [text] 回复内容
  /// [quoteMsg] 被引用的消息
  Message createQuoteMessage({required String text, required Message quoteMsg}) {
    _log.info('createQuoteMessage: text=$text, quoteMsgID=${quoteMsg.clientMsgID}');
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
    _log.info('createCardMessage: userID=$userID, nickname=$nickname');
    return _createMessage(
      contentType: MessageType.card,
      cardElem: CardElem(userID: userID, nickname: nickname, faceURL: faceURL, ex: ex),
    );
  }

  /// 创建自定义表情消息
  /// [index] 位置表情，根据index匹配
  /// [data] URL表情，直接使用URL展示
  Message createFaceMessage({int index = -1, String? data}) {
    _log.info('createFaceMessage: index=$index');
    return _createMessage(
      contentType: MessageType.customFace,
      faceElem: FaceElem(index: index, data: data ?? ''),
    );
  }

  /// 创建高级文本消息（富文本）
  /// [text] 输入内容
  /// [list] 富文本消息详情
  Message createAdvancedTextMessage({required String text, List<RichMessageInfo> list = const []}) {
    _log.info('createAdvancedTextMessage: text=$text, listCount=${list.length}');
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
    _log.info('createAdvancedQuoteMessage: text=$text, quoteMsgID=${quoteMsg.clientMsgID}');
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
    _log.info('createImageMessageByURL: sourcePath=$sourcePath');
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
    _log.info('createSoundMessageByURL: duration=${soundElem.duration}');
    return _createMessage(contentType: MessageType.voice, soundElem: soundElem);
  }

  /// 通过URL创建视频消息
  /// [videoElem] 视频消息元素
  Message createVideoMessageByURL({required VideoElem videoElem}) {
    _log.info(
      'createVideoMessageByURL: videoType=${videoElem.videoType}, duration=${videoElem.duration}',
    );
    return _createMessage(contentType: MessageType.video, videoElem: videoElem);
  }

  /// 通过URL创建文件消息
  /// [fileElem] 文件消息元素
  Message createFileMessageByURL({required FileElem fileElem}) {
    _log.info('createFileMessageByURL: fileName=${fileElem.fileName}');
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
    _log.info(
      'sendMessage: clientMsgID=${message.clientMsgID}, contentType=${message.contentType}, userID=$userID, groupID=$groupID, isOnlineOnly=$isOnlineOnly',
    );
    final isGroupMsg = groupID != null && groupID.isNotEmpty;
    final sessionType = isGroupMsg ? ConversationType.superGroup : ConversationType.single;

    final sendMsg = message.copyWith(
      sendID: _currentUserID,
      recvID: userID,
      groupID: groupID,
      sessionType: sessionType,
      status: MessageStatus.sending,
      offlinePush: offlinePushInfo,
    );

    final conversationID = isGroupMsg
        ? OpenImUtils.genGroupConversationID(groupID)
        : OpenImUtils.genSingleConversationID(_currentUserID, userID!);

    // 仅在线消息不存储到本地
    if (!isOnlineOnly) {
      await _database.insertMessage(DatabaseService.messageToDbMap(sendMsg));
      await _database.insertSendingMessage(sendMsg.clientMsgID!, conversationID);
      // 立即更新会话（对应 Go SDK 发送前的 AddConOrUpLatMsg）
      // 让 UI 立即看到"发送中"的最新消息
      await _updateConversationLatestMsg(conversationID, sendMsg, sessionType);
    }

    _log.info('消息已发送${isOnlineOnly ? "(仅在线)" : "到本地"}: ${sendMsg.clientMsgID}');

    // 通过 WebSocket 发送消息（使用 protobuf 编码，与 Go SDK 保持一致）
    try {
      final sentMsg = await _sendMsgViaWebSocket(
        sendMsg,
        conversationID,
        sessionType,
        isOnlineOnly,
      );
      return sentMsg;
    } on OpenIMException {
      // 服务端返回错误（如不是好友等），DB 已在 _sendMsgViaWebSocket 中更新为失败状态
      rethrow;
    } catch (e) {
      _log.warning('消息发送异常: $e');
      final failedMsg = sendMsg.copyWith(status: MessageStatus.failed);
      if (!isOnlineOnly) {
        await _database.updateMessage(failedMsg.clientMsgID!, {
          'status': MessageStatus.failed.value,
        });
        await _database.deleteSendingMessage(failedMsg.clientMsgID!);
        // 更新会话最新消息为失败状态
        await _updateConversationLatestMsg(conversationID, failedMsg, sessionType);
      }
      rethrow;
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
    _log.info(
      'getAdvancedHistoryMessageList: conversationID=$conversationID, startMsgID=${startMsg?.clientMsgID}, viewType=$viewType, count=$count',
    );
    final queryCount = count ?? 40;
    int startTime = startMsg?.sendTime ?? 0;

    if (startMsg?.clientMsgID != null && startMsg!.clientMsgID!.isNotEmpty) {
      final existingMsg = await _database.getMessage(startMsg.clientMsgID!);
      final dbSendTime = existingMsg?.sendTime ?? 0;
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
    if (dataList.length <= queryCount) {
      final convMaxSeq = await _database.getConversationMaxSeq(conversationID ?? '');
      if (convMaxSeq > 0) {
        // 确定从哪个 seq 开始向前拉取
        int currentSeq;
        if (startMsg != null && (startMsg.seq ?? 0) > 1) {
          currentSeq = startMsg.seq!;
          if (dataList.isNotEmpty) {
            currentSeq = dataList.last.seq ?? currentSeq;
          }
        } else if (dataList.isNotEmpty) {
          // 有本地数据但不足，从最早一条的 seq 向前拉取
          currentSeq = dataList.last.seq ?? convMaxSeq;
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
                userID: _currentUserID,
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
                    final contentType = m['contentType'] as int? ?? 0;
                    final sessionType = m['sessionType'] as int? ?? 0;
                    // 普通消息 + 通知会话(sessionType=4)的 OA 消息 都要存储
                    if (contentType < 1000 || sessionType == 4) {
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
    }

    final isEnd = dataList.length <= queryCount;
    final actualData = isEnd ? dataList : dataList.sublist(0, queryCount);

    return AdvancedMessage(messageList: actualData, isEnd: isEnd);
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
    _log.info(
      'getAdvancedHistoryMessageListReverse: conversationID=$conversationID, startMsgID=${startMsg?.clientMsgID}, count=$count',
    );
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
    _log.info('findMessageList: searchParamsCount=${searchParams.length}');
    final resultItems = <SearchResultItems>[];
    int totalCount = 0;

    for (final param in searchParams) {
      if (param.clientMsgIDList == null || param.clientMsgIDList!.isEmpty) continue;
      final messages = await _database.getMessagesByClientMsgIDs(param.clientMsgIDList!);
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
    _log.info(
      'searchLocalMessages: conversationID=$conversationID, keywordList=$keywordList, pageIndex=$pageIndex, count=$count',
    );
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

    final messages = dataList;
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
    _log.info('revokeMessage: conversationID=$conversationID, clientMsgID=$clientMsgID');
    // 获取消息的 seq 用于服务端撤回
    final msg = await _database.getMessage(clientMsgID);
    final seq = msg?.seq ?? 0;

    await _database.updateMessage(clientMsgID, {
      'contentType': MessageType.revokeMessageNotification.value,
    });
    _log.info('消息已撤回: $clientMsgID');

    msgListener?.newRecvMessageRevoked(
      RevokedInfo(clientMsgID: clientMsgID, revokerID: _currentUserID, revokeTime: _nowMillis()),
    );

    // 如果撤回的消息是会话的最新消息，更新会话 latestMsg（对应 Go SDK revoke.go）
    await _updateConversationIfLatestMsg(conversationID, clientMsgID);

    // 同步到服务器
    if (seq > 0) {
      final resp = await _api.revokeMsg(
        userID: _currentUserID,
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
    _log.info(
      'deleteMessageFromLocalStorage: conversationID=$conversationID, clientMsgID=$clientMsgID',
    );
    final deletedMsg = await _database.getMessage(clientMsgID);
    await _database.deleteMessage(clientMsgID);
    _log.info('消息已从本地删除: $clientMsgID');

    // 如果删除的是未读消息（非自己发送），减少未读数（对应 Go SDK delete.go）
    if (deletedMsg != null && !(deletedMsg.isRead ?? true) && deletedMsg.sendID != _currentUserID) {
      await _database.decrConversationUnreadCount(conversationID, 1);
      _notifyConversationAndUnread(conversationID);
    }

    // 如果删除的是会话最新消息，更新 latestMsg
    await _updateConversationIfLatestMsg(conversationID, clientMsgID);

    if (deletedMsg != null) {
      msgListener?.msgDeleted(deletedMsg);
    }
  }

  /// 删除消息（本地和服务器）
  /// [conversationID] 会话ID
  /// [clientMsgID] 消息ID
  Future<void> deleteMessageFromLocalAndSvr({
    required String conversationID,
    required String clientMsgID,
  }) async {
    _log.info(
      'deleteMessageFromLocalAndSvr: conversationID=$conversationID, clientMsgID=$clientMsgID',
    );
    // 获取消息的 seq 用于服务端删除
    final msg = await _database.getMessage(clientMsgID);
    final seq = msg?.seq ?? 0;

    await _database.deleteMessage(clientMsgID);
    _log.info('消息已从本地和服务器删除: $clientMsgID');

    // 如果删除的是未读消息（非自己发送），减少未读数
    if (msg != null && !(msg.isRead ?? true) && msg.sendID != _currentUserID) {
      await _database.decrConversationUnreadCount(conversationID, 1);
      _notifyConversationAndUnread(conversationID);
    }

    // 如果删除的是会话最新消息，更新 latestMsg
    await _updateConversationIfLatestMsg(conversationID, clientMsgID);

    if (msg != null) {
      msgListener?.msgDeleted(msg);
    }

    // 同步到服务器
    if (seq > 0) {
      final resp = await _api.deleteMsgs(
        userID: _currentUserID,
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
    _log.info('deleteAllMsgFromLocal');
    // 先获取所有会话用于回调
    final allConvs = await _database.getAllConversations();
    final affectedIDs = allConvs.map((c) => c.conversationID).toList();

    await _database.deleteAllMessages();
    _log.info('所有本地消息已删除');

    // 清理会话并触发回调（对应 Go SDK deleteAllMsgFromLocal）
    if (affectedIDs.isNotEmpty) {
      final listener = _conversationManager?.listener;
      final convList = await _database.getMultipleConversations(affectedIDs);
      if (convList.isNotEmpty) {
        listener?.conversationChanged(convList);
      }
      final total = await _database.getTotalUnreadCount();
      listener?.totalUnreadMessageCountChanged(total);
    }
  }

  /// 删除所有消息（本地和服务器）
  Future<void> deleteAllMsgFromLocalAndSvr() async {
    _log.info('deleteAllMsgFromLocalAndSvr');
    await _database.deleteAllMessages();
    _log.info('所有消息已从本地和服务器删除');

    // 触发 totalUnreadChanged（对应 Go SDK deleteAllMsgFromLocalAndServer）
    final total = await _database.getTotalUnreadCount();
    _conversationManager?.listener?.totalUnreadMessageCountChanged(total);

    // 同步到服务器
    final resp = await _api.clearAllMsg(userID: _currentUserID);
    if (resp.errCode != 0) {
      _log.warning('清空所有消息同步服务器失败: ${resp.errMsg}');
    }
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
    _log.info('setMessageLocalEx: conversationID=$conversationID, clientMsgID=$clientMsgID');
    await _database.updateMessage(clientMsgID, {'localEx': localEx});

    // 如果修改的是会话的最新消息，更新会话 latestMsg（对应 Go SDK SetMessageLocalEx）
    final conv = await _database.getConversation(conversationID);
    if (conv?.latestMsg != null && conv!.latestMsg!.clientMsgID == clientMsgID) {
      final updatedMsg = conv.latestMsg!.copyWith(localEx: localEx);
      await _database.updateConversation(conversationID, {
        'latestMsg': jsonEncode(updatedMsg.toJson()),
      });
      final updated = await _database.getConversation(conversationID);
      if (updated != null) {
        _conversationManager?.listener?.conversationChanged([updated]);
      }
    }
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
    _log.info('insertSingleMessageToLocalStorage: receiverID=$receiverID, senderID=$senderID');
    final msg = (message ?? _createMessage(contentType: MessageType.text)).copyWith(
      sendID: senderID,
      recvID: receiverID,
      sessionType: ConversationType.single,
      status: MessageStatus.succeeded,
      sendTime: _nowMillis(),
    );
    final conversationID = OpenImUtils.genSingleConversationID(
      senderID == _currentUserID ? _currentUserID : (senderID ?? ''),
      senderID == _currentUserID ? (receiverID ?? '') : (senderID ?? ''),
    );
    await _database.insertMessage(DatabaseService.messageToDbMap(msg));
    // 触发会话更新（对应 Go SDK InsertSingleMessageToLocalStorage 的 AddConOrUpLatMsg）
    await _updateConversationLatestMsg(conversationID, msg, ConversationType.single);
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
    _log.info('insertGroupMessageToLocalStorage: groupID=$groupID, senderID=$senderID');
    final msg = (message ?? _createMessage(contentType: MessageType.text)).copyWith(
      sendID: senderID,
      groupID: groupID,
      sessionType: ConversationType.superGroup,
      status: MessageStatus.succeeded,
      sendTime: _nowMillis(),
    );
    final conversationID = OpenImUtils.genGroupConversationID(groupID ?? '');
    await _database.insertMessage(DatabaseService.messageToDbMap(msg));
    // 触发会话更新（对应 Go SDK InsertGroupMessageToLocalStorage 的 AddConOrUpLatMsg）
    await _updateConversationLatestMsg(conversationID, msg, ConversationType.superGroup);
    return msg;
  }

  /// 创建图片消息（通过完整文件路径）
  /// [imagePath] 图片的完整路径
  Message createImageMessageFromFullPath({required String imagePath, String? operationID}) {
    _log.info('createImageMessageFromFullPath: imagePath=$imagePath');
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
    _log.info('createSoundMessageFromFullPath: soundPath=$soundPath, duration=$duration');
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
    _log.info(
      'createVideoMessageFromFullPath: videoPath=$videoPath, videoType=$videoType, duration=$duration',
    );
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
    _log.info('createFileMessageFromFullPath: filePath=$filePath, fileName=$fileName');
    return createFileMessage(filePath: filePath, fileName: fileName);
  }

  /// 处理收到的新消息
  void onRecvNewMessage(Message message) {
    msgListener?.recvNewMessage(message);
  }

  /// 处理收到的离线消息
  void onRecvOfflineNewMessage(Message message) {
    msgListener?.recvOfflineNewMessage(message);
  }

  /// 处理收到的仅在线消息
  void onRecvOnlineOnlyMessage(Message message) {
    msgListener?.recvOnlineOnlyMessage(message);
  }

  // ---------------------------------------------------------------------------
  // 私有辅助方法
  // ---------------------------------------------------------------------------

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
      clientMsgID: OpenImUtils.generateClientMsgID(_currentUserID),
      createTime: _nowMillis(),
      sendTime: 0,
      sendID: _currentUserID,
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

  /// 更新会话的最新消息并触发会话变更回调
  ///
  /// 对应 Go SDK 的 doUpdateConversation(AddConOrUpLatMsg):
  /// - 会话已存在 → 更新 latestMsg → 触发 OnConversationChanged
  /// - 会话不存在 → 创建新会话 → 触发 OnNewConversation
  Future<void> _updateConversationLatestMsg(
    String conversationID,
    Message message,
    ConversationType sessionType,
  ) async {
    final conv = await _database.getConversation(conversationID);
    final listener = _conversationManager?.listener;
    if (conv != null) {
      // 仅当新消息时间 >= 现有最新消息时间时才更新（对应 Go SDK 判断）
      final existingTime = conv.latestMsgSendTime ?? 0;
      if ((message.sendTime ?? 0) >= existingTime) {
        await _database.updateConversation(conversationID, {
          'latestMsg': jsonEncode(message.toJson()),
          'latestMsgSendTime': message.sendTime,
        });
        // 触发 OnConversationChanged
        final updated = await _database.getConversation(conversationID);
        if (updated != null) {
          listener?.conversationChanged([updated]);
        }
      }
    } else {
      // 新会话
      await _database.upsertConversation({
        'conversationID': conversationID,
        'conversationType': sessionType.value,
        'userID': message.recvID,
        'groupID': message.groupID,
        'latestMsg': jsonEncode(message.toJson()),
        'latestMsgSendTime': message.sendTime,
        'unreadCount': 0,
      });
      // 触发 OnNewConversation
      final newConv = await _database.getConversation(conversationID);
      if (newConv != null) {
        listener?.newConversation([newConv]);
      }
    }
  }

  /// 如果被删除/撤回的消息是会话的 latestMsg，则更新 latestMsg 为次新消息
  /// 对应 Go SDK delete.go / revoke.go 中的 latestMsg 判断更新逻辑
  Future<void> _updateConversationIfLatestMsg(String conversationID, String clientMsgID) async {
    final conv = await _database.getConversation(conversationID);
    if (conv?.latestMsg == null) return;
    if (conv!.latestMsg!.clientMsgID != clientMsgID) return;

    // latestMsg 被删除/撤回，查找次新消息
    try {
      final msgs = await _database.getHistoryMessages(conversationID: conversationID, count: 1);
      if (msgs.isNotEmpty) {
        await _database.updateConversation(conversationID, {
          'latestMsg': jsonEncode(msgs.first.toJson()),
          'latestMsgSendTime': msgs.first.sendTime,
        });
      } else {
        await _database.updateConversation(conversationID, {
          'latestMsg': '',
          'latestMsgSendTime': 0,
        });
      }
      final updated = await _database.getConversation(conversationID);
      if (updated != null) {
        _conversationManager?.listener?.conversationChanged([updated]);
      }
    } catch (_) {}
  }

  /// 触发 conversationChanged + totalUnreadChanged（删除未读消息后使用）
  Future<void> _notifyConversationAndUnread(String conversationID) async {
    final listener = _conversationManager?.listener;
    final conv = await _database.getConversation(conversationID);
    if (conv != null) {
      listener?.conversationChanged([conv]);
    }
    final total = await _database.getTotalUnreadCount();
    listener?.totalUnreadMessageCountChanged(total);
  }

  /// 通过 WebSocket 发送消息（使用 protobuf）
  Future<Message> _sendMsgViaWebSocket(
    Message message,
    String conversationID,
    ConversationType sessionType,
    bool isOnlineOnly,
  ) async {
    // 1. 构建 MsgData protobuf
    final msgData = _buildMsgData(message, isOnlineOnly);

    // 2. 序列化为 protobuf 字节
    final msgDataBytes = msgData.writeToBuffer();

    // 3. 通过 WebSocket 发送
    if (!_webSocketService.isConnected) {
      throw StateError('WebSocket 未连接');
    }

    try {
      final resp = await _webSocketService.sendRequestWaitResponse(
        reqIdentifier: WebSocketIdentifier.sendMsg,
        data: msgDataBytes,
      );

      if (resp.errCode == 0) {
        // 解析响应：服务器返回修改后的消息或发送结果
        final sentMsg = message.copyWith(status: MessageStatus.succeeded, sendTime: _nowMillis());

        // 仅在线消息不更新本地存储和会话
        if (!isOnlineOnly) {
          await _database.updateMessage(sentMsg.clientMsgID!, {
            'status': MessageStatus.succeeded.value,
            'sendTime': sentMsg.sendTime,
          });
          await _database.deleteSendingMessage(sentMsg.clientMsgID!);
          await _updateConversationLatestMsg(conversationID, sentMsg, sessionType);
        }
        return sentMsg;
      } else {
        _log.warning('消息发送失败: errCode=${resp.errCode}, errMsg=${resp.errMsg}');
        final failedMsg = message.copyWith(status: MessageStatus.failed);
        if (!isOnlineOnly) {
          await _database.updateMessage(failedMsg.clientMsgID!, {
            'status': MessageStatus.failed.value,
          });
          await _database.deleteSendingMessage(failedMsg.clientMsgID!);
          await _updateConversationLatestMsg(conversationID, failedMsg, sessionType);
        }
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
    } catch (e) {
      _log.warning('WebSocket 发送失败: $e');
      rethrow;
    }
  }

  /// 构建 MsgData protobuf
  /// 对应 sdkws.proto 中的 MsgData 消息
  sdkws.MsgData _buildMsgData(Message msg, bool isOnlineOnly) {
    // 提取消息内容为字节（JSON 编码的 Elem）
    final contentJson = _extractContent(msg);
    final contentBytes = utf8.encode(contentJson);

    final msgData = sdkws.MsgData(
      sendID: msg.sendID ?? '',
      recvID: msg.recvID ?? '',
      groupID: msg.groupID ?? '',
      clientMsgID: msg.clientMsgID ?? '',
      senderPlatformID: msg.senderPlatformID?.value ?? PlatformUtils.currentPlatform.value,
      senderNickname: msg.senderNickname ?? '',
      senderFaceURL: msg.senderFaceUrl ?? '',
      sessionType: msg.sessionType?.value ?? ConversationType.single.value,
      msgFrom: 1, // 默认为用户消息
      contentType: msg.contentType?.value ?? MessageType.text.value,
      content: contentBytes,
      createTime: Int64(msg.createTime ?? _nowMillis()),
      ex: msg.ex ?? '',
    );

    // 添加离线推送信息
    if (msg.offlinePush != null && !isOnlineOnly) {
      msgData.offlinePushInfo = _buildOfflinePushInfo(msg.offlinePush!);
    }

    // 仅在线消息：设置 options 标记，服务端不持久化、不推离线、不更新会话
    if (isOnlineOnly) {
      msgData.options.addEntries(const [
        MapEntry('history', false),
        MapEntry('persistent', false),
        MapEntry('senderSync', false),
        MapEntry('conversationUpdate', false),
        MapEntry('senderConversationUpdate', false),
        MapEntry('unreadCount', false),
        MapEntry('offlinePush', false),
      ]);
    }

    return msgData;
  }

  /// 构建 OfflinePushInfo protobuf
  sdkws.OfflinePushInfo _buildOfflinePushInfo(OfflinePushInfo push) {
    return sdkws.OfflinePushInfo(
      title: push.title ?? '',
      desc: push.desc ?? '',
      ex: push.ex ?? '',
      iOSPushSound: push.iOSPushSound ?? '',
      iOSBadgeCount: push.iOSBadgeCount ?? false,
    );
  }
}
