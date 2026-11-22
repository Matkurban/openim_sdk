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

  /// 消息发送进度监听器。
  ///
  /// Message send progress listener.
  OnMsgSendProgressListener? msgSendProgressListener;

  /// 自定义Business监听器。
  ///
  /// Custom business listener.
  OnCustomBusinessListener? customBusinessListener;

  /// 创建 `MessageManager` 实例。
  ///
  /// Creates a `MessageManager` instance.
  ///
  /// - [_context] context / Context.
  /// - [_fileUploader] 文件上传器 / File uploader.
  /// - [_conversationListenerProvider] 会话监听器Provider / Conversation listener provider.
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

  /// 消息监听器。
  ///
  /// Message listener.
  OnAdvancedMsgListener? get msgListener => listener;

  /// 设置消息发送进度监听器。
  ///
  /// Set message send progress listener.
  ///
  /// - [listener] 监听器 / Listener.
  void setMsgSendProgressListener(OnMsgSendProgressListener listener) {
    msgSendProgressListener = listener;
  }

  /// 设置消息监听器。
  ///
  /// Set message listener.
  ///
  /// - [listener] 监听器 / Listener.
  void setMessageListener(OnAdvancedMsgListener listener) {
    setPrimaryListener(listener);
  }

  /// 设置自定义Business监听器。
  ///
  /// Set custom business listener.
  ///
  /// - [listener] 监听器 / Listener.
  void setCustomBusinessListener(OnCustomBusinessListener listener) {
    customBusinessListener = listener;
  }

  /// on登出。
  ///
  /// On logout.
  @override
  @internal
  void onLogout() {
    _factory.clearPendingBytes();
    super.onLogout();
  }

  // ---- 消息创建委托至 MessageFactory ----

  /// 创建文本消息。
  ///
  /// Create text message.
  ///
  /// - [text] 文本 / Text.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createTextMessage({required String text}) => _factory.createTextMessage(text: text);

  /// 创建文本@提及消息。
  ///
  /// Create text @-mention message.
  ///
  /// - [text] 文本 / Text.
  /// - [atUserIDList] @提及用户ID列表 / @-mention user ID list.
  /// - [atUserInfoList] @提及用户信息列表 / @-mention user info list.
  /// - [quoteMessage] 引用消息 / Quote message.
  /// - Returns: `Message` 结果 / Resulting `Message`.
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

  /// 创建图片消息。
  ///
  /// Create image message.
  ///
  /// - [imagePath] 图片路径 / Image path.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createImageMessage({required String imagePath}) =>
      _factory.createImageMessage(imagePath: imagePath);

  /// 创建语音消息。
  ///
  /// Create voice audio message.
  ///
  /// - [soundPath] 语音路径 / Voice audio path.
  /// - [duration] 时长 / Duration.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createSoundMessage({required String soundPath, required int duration}) =>
      _factory.createSoundMessage(soundPath: soundPath, duration: duration);

  /// 创建视频消息。
  ///
  /// Create video message.
  ///
  /// - [videoPath] 视频路径 / Video path.
  /// - [videoType] 视频类型 / Video type.
  /// - [duration] 时长 / Duration.
  /// - [snapshotPath] 缩略图路径 / Snapshot path.
  /// - Returns: `Message` 结果 / Resulting `Message`.
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

  /// 创建文件消息。
  ///
  /// Create file message.
  ///
  /// - [filePath] 文件路径 / File path.
  /// - [fileName] 文件名称 / File name.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createFileMessage({required String filePath, required String fileName}) =>
      _factory.createFileMessage(filePath: filePath, fileName: fileName);

  /// 创建合并消息。
  ///
  /// Create merge message.
  ///
  /// - [messageList] 消息列表 / Message list.
  /// - [title] 标题 / Title.
  /// - [summaryList] 摘要列表 / Summary list.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createMergeMessage({
    required List<Message> messageList,
    required String title,
    required List<String> summaryList,
  }) =>
      _factory.createMergeMessage(messageList: messageList, title: title, summaryList: summaryList);

  /// 创建转发消息。
  ///
  /// Create forward message.
  ///
  /// - [message] 消息 / Message.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createForwardMessage({required Message message}) =>
      _factory.createForwardMessage(message: message);

  /// 创建地理位置消息。
  ///
  /// Create location message.
  ///
  /// - [latitude] 纬度 / Latitude.
  /// - [longitude] 经度 / Longitude.
  /// - [description] 描述 / Description.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createLocationMessage({
    required double latitude,
    required double longitude,
    required String description,
  }) => _factory.createLocationMessage(
    latitude: latitude,
    longitude: longitude,
    description: description,
  );

  /// 创建自定义消息。
  ///
  /// Create custom message.
  ///
  /// - [data] 数据 / Data.
  /// - [extension] extension / Extension.
  /// - [description] 描述 / Description.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createCustomMessage({
    required String data,
    required String extension,
    required String description,
  }) => _factory.createCustomMessage(data: data, extension: extension, description: description);

  /// 创建通话信令消息。
  ///
  /// Create call signaling message.
  ///
  /// - [elem] 元素 / Element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createCallSignalMessage({required CallSignalElem elem}) =>
      _factory.createCallSignalMessage(elem: elem);

  /// 创建红包消息。
  ///
  /// Create red packet message.
  ///
  /// - [elem] 元素 / Element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createRedPacketMessage({required RedPacketElem elem}) =>
      _factory.createRedPacketMessage(elem: elem);

  /// 创建引用消息。
  ///
  /// Create quote message.
  ///
  /// - [text] 文本 / Text.
  /// - [quoteMsg] 引用消息 / Quote message.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createQuoteMessage({required String text, required Message quoteMsg}) =>
      _factory.createQuoteMessage(text: text, quoteMsg: quoteMsg);

  /// 创建名片消息。
  ///
  /// Create contact card message.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createCardMessage({
    required String userID,
    required String nickname,
    String? faceURL,
    String? ex,
  }) => _factory.createCardMessage(userID: userID, nickname: nickname, faceURL: faceURL, ex: ex);

  /// 创建头像消息。
  ///
  /// Create avatar message.
  ///
  /// - [index] 索引 / Index.
  /// - [data] 数据 / Data.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createFaceMessage({int index = -1, String? data}) =>
      _factory.createFaceMessage(index: index, data: data);

  /// 创建高级文本消息。
  ///
  /// Create advanced text message.
  ///
  /// - [text] 文本 / Text.
  /// - [list] 列表 / List.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createAdvancedTextMessage({
    required String text,
    List<RichMessageInfo> list = const <RichMessageInfo>[],
  }) => _factory.createAdvancedTextMessage(text: text, list: list);

  /// 创建高级引用消息。
  ///
  /// Create advanced quote message.
  ///
  /// - [text] 文本 / Text.
  /// - [quoteMsg] 引用消息 / Quote message.
  /// - [list] 列表 / List.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createAdvancedQuoteMessage({
    required String text,
    required Message quoteMsg,
    List<RichMessageInfo> list = const <RichMessageInfo>[],
  }) => _factory.createAdvancedQuoteMessage(text: text, quoteMsg: quoteMsg, list: list);

  /// 创建图片消息ByURL 地址。
  ///
  /// Create image message by URL.
  ///
  /// - [sourcePicture] 来源图片 / Source picture.
  /// - [bigPicture] big图片 / Big picture.
  /// - [snapshotPicture] 缩略图图片 / Snapshot picture.
  /// - [sourcePath] 来源路径 / Source path.
  /// - Returns: `Message` 结果 / Resulting `Message`.
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

  /// 创建语音消息ByURL 地址。
  ///
  /// Create voice audio message by URL.
  ///
  /// - [soundElem] 语音元素 / Voice audio element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createSoundMessageByURL({required SoundElem soundElem}) =>
      _factory.createSoundMessageByURL(soundElem: soundElem);

  /// 创建视频消息ByURL 地址。
  ///
  /// Create video message by URL.
  ///
  /// - [videoElem] 视频元素 / Video element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createVideoMessageByURL({required VideoElem videoElem}) =>
      _factory.createVideoMessageByURL(videoElem: videoElem);

  /// 创建文件消息ByURL 地址。
  ///
  /// Create file message by URL.
  ///
  /// - [fileElem] 文件元素 / File element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createFileMessageByURL({required FileElem fileElem}) =>
      _factory.createFileMessageByURL(fileElem: fileElem);

  /// 创建图片消息从全量路径。
  ///
  /// Create image message from full path.
  ///
  /// - [imagePath] 图片路径 / Image path.
  /// - [operationID] operationID / Operation ID.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
  Future<Message> createImageMessageFromFullPath({
    required String imagePath,
    String? operationID,
  }) => _factory.createImageMessageFromFullPath(imagePath: imagePath);

  /// 创建语音消息从全量路径。
  ///
  /// Create voice audio message from full path.
  ///
  /// - [soundPath] 语音路径 / Voice audio path.
  /// - [duration] 时长 / Duration.
  /// - [operationID] operationID / Operation ID.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createSoundMessageFromFullPath({
    required String soundPath,
    required int duration,
    String? operationID,
  }) => _factory.createSoundMessageFromFullPath(soundPath: soundPath, duration: duration);

  /// 创建视频消息从全量路径。
  ///
  /// Create video message from full path.
  ///
  /// - [videoPath] 视频路径 / Video path.
  /// - [videoType] 视频类型 / Video type.
  /// - [duration] 时长 / Duration.
  /// - [snapshotPath] 缩略图路径 / Snapshot path.
  /// - [operationID] operationID / Operation ID.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
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

  /// 创建文件消息从全量路径。
  ///
  /// Create file message from full path.
  ///
  /// - [filePath] 文件路径 / File path.
  /// - [fileName] 文件名称 / File name.
  /// - [operationID] operationID / Operation ID.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createFileMessageFromFullPath({
    required String filePath,
    required String fileName,
    String? operationID,
  }) => _factory.createFileMessageFromFullPath(filePath: filePath, fileName: fileName);

  /// 创建图片消息按文件。
  ///
  /// Create image message by file.
  ///
  /// - [bytes] 字节数据 / Bytes.
  /// - [fileName] 文件名称 / File name.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
  Future<Message> createImageMessageByFile({required Uint8List bytes, required String fileName}) =>
      _factory.createImageMessageByFile(bytes: bytes, fileName: fileName);

  /// 创建视频消息按文件。
  ///
  /// Create video message by file.
  ///
  /// - [bytes] 字节数据 / Bytes.
  /// - [fileName] 文件名称 / File name.
  /// - [duration] 时长 / Duration.
  /// - [videoType] 视频类型 / Video type.
  /// - [snapshotBytes] 缩略图字节数据 / Snapshot bytes.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
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

  /// 创建文件消息按文件。
  ///
  /// Create file message by file.
  ///
  /// - [bytes] 字节数据 / Bytes.
  /// - [fileName] 文件名称 / File name.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createFileMessageByFile({required Uint8List bytes, required String fileName}) =>
      _factory.createFileMessageByFile(bytes: bytes, fileName: fileName);

  // ---- 消息发送与恢复 ----

  /// 恢复Sending消息列表。
  ///
  /// Recover sending messages.
  Future<void> recoverSendingMessages() => _sender.recoverSendingMessages();

  /// 发送消息。
  ///
  /// Send message.
  ///
  /// - [message] 消息 / Message.
  /// - [offlinePushInfo] 离线推送信息 / Offline push info.
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - [isOnlineOnly] 是否在线Only / Whether online only.
  /// - [messageOptions] 消息选项 / Message options.
  /// - [uploadMedia] 上传媒体 / Upload media.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
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

  /// 发送消息NotOss。
  ///
  /// Send message not oss.
  ///
  /// - [message] 消息 / Message.
  /// - [offlinePushInfo] 离线推送信息 / Offline push info.
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - [isOnlineOnly] 是否在线Only / Whether online only.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
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

  /// 获取高级历史消息列表。
  ///
  /// Get advanced history message list.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [startMsg] 开始消息 / Start message.
  /// - [viewType] view类型 / View type.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<AdvancedMessage>` 结果 / Resulting `Future<AdvancedMessage>`.
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
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [startMsg] 开始消息 / Start message.
  /// - [viewType] view类型 / View type.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<AdvancedMessage>` 结果 / Resulting `Future<AdvancedMessage>`.
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

  /// 查找消息列表。
  ///
  /// Find message list.
  ///
  /// - [searchParams] 搜索Params / Search params.
  /// - Returns: `Future<SearchResult>` 结果 / Resulting `Future<SearchResult>`.
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

  /// 搜索本地消息列表。
  ///
  /// Search local messages.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [keywordList] 关键词列表 / Keyword list.
  /// - [keywordListMatchType] 关键词列表Match类型 / Keyword list match type.
  /// - [senderUserIDList] 发送器用户ID列表 / Sender user ID list.
  /// - [messageTypeList] 消息类型列表 / Message type list.
  /// - [searchTimePosition] 搜索时间戳Position / Search timestamp position.
  /// - [searchTimePeriod] 搜索时间戳Period / Search timestamp period.
  /// - [pageIndex] 分页索引 / Paged index.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<SearchResult>` 结果 / Resulting `Future<SearchResult>`.
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

  /// 撤回消息。
  ///
  /// Revoke message.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [clientMsgID] 客户端消息ID / Client message ID.
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

  /// 删除消息从本地存储。
  ///
  /// Delete message from local storage.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [clientMsgID] 客户端消息ID / Client message ID.
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

  /// 删除消息从本地并服务端。
  ///
  /// Delete message from local and server.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [clientMsgID] 客户端消息ID / Client message ID.
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
  ///
  /// Delete all message from local.
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

  /// 删除全部消息从本地并服务端。
  ///
  /// Delete all message from local and server.
  Future<void> deleteAllMsgFromLocalAndSvr() async {
    await deleteAllMsgFromLocal();
    final ApiResponse resp = await _context.apis.message.clearAllMsg(userID: currentUserID);
    if (resp.errCode != 0) {
      logger.warning('clearAllMsg server sync failed: ${resp.errMsg}');
    }
  }

  /// 设置消息本地扩展字段。
  ///
  /// Set message local extension.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - [localEx] 本地扩展字段 / Local extension.
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
  ///
  /// - [receiverID] 接收者ID / Receiver ID.
  /// - [senderID] 发送器ID / Sender ID.
  /// - [message] 消息 / Message.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
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

  /// 插入群组消息转为本地存储。
  ///
  /// Insert group message to local storage.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [senderID] 发送器ID / Sender ID.
  /// - [message] 消息 / Message.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
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
