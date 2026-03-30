import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/models/web_socket_identifier.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:openim_sdk/src/services/web_socket_service.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';
import 'package:openim_sdk/src/utils/sdk_isolate.dart' as isolate_util;
import 'package:openim_sdk/protocol_gen/sdkws/sdkws.pb.dart' as sdkws;

class MessageManager {
  MessageManager._internal();

  static final MessageManager _instance = MessageManager._internal();

  factory MessageManager() => _instance;

  static final AoiweLogger _log = AoiweLogger('MessageManager');

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

  /// Web 平台文件上传的 bytes 暂存区
  /// key = clientMsgID, value = 文件字节数据
  /// 由 createXxxFromBytes 写入，_handleMediaUploadIfNeeded 消费并清理
  final Map<String, Uint8List> _pendingUploadBytes = {};

  /// Web 平台视频缩略图 bytes 暂存
  final Map<String, Uint8List> _pendingSnapshotBytes = {};

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

  /// 恢复发送中的消息
  /// App 启动或重新登录后调用，检查本地存储的发送中消息
  /// 与 Go SDK 行为一致：将发送中消息直接标记为失败（不自动重发）
  /// Go SDK 参考：open_im_sdk/userRelated.go handlerSendingMsg
  Future<void> recoverSendingMessages() async {
    _log.info('Recovering sending messages...', methodName: 'recoverSendingMessages');
    try {
      final allSendingMessages = await _database.getAllSendingMessages();
      if (allSendingMessages.isEmpty) {
        _log.info('No sending messages to recover', methodName: 'recoverSendingMessages');
        return;
      }
      _log.info(
        'Found ${allSendingMessages.length} sending messages to recover',
        methodName: 'recoverSendingMessages',
      );

      // 批量加载所有待恢复消息，避免 N 次串行 DB 读取
      final allClientMsgIDs = allSendingMessages
          .map((m) => m['clientMsgID'] as String?)
          .whereType<String>()
          .toList();
      final loadedMessages = await _database.getMessagesByClientMsgIDs(allClientMsgIDs);
      final messageMap = {for (final m in loadedMessages) if (m.clientMsgID != null) m.clientMsgID!: m};

      for (final msg in allSendingMessages) {
        final clientMsgID = msg['clientMsgID'] as String?;
        final conversationID = msg['conversationID'] as String?;
        if (clientMsgID == null) continue;

        final message = messageMap[clientMsgID];
        if (message == null) {
          // 消息不存在，删除发送记录
          await _database.deleteSendingMessage(clientMsgID);
          _log.info(
            'Message not found, deleted sending record: $clientMsgID',
            methodName: 'recoverSendingMessages',
          );
          continue;
        }

        final status = message.status?.value;

        // 如果已经是成功或失败状态，跳过
        if (status == MessageStatus.succeeded.value || status == MessageStatus.failed.value) {
          await _database.deleteSendingMessage(clientMsgID);
          _log.info(
            'Message already processed (status=$status), deleted sending record: $clientMsgID',
            methodName: 'recoverSendingMessages',
          );
          continue;
        }

        // 如果状态仍然是 sending，按 Go SDK 策略直接置为失败
        if (status == MessageStatus.sending.value) {
          await _database.updateMessageStatus(clientMsgID, MessageStatus.failed.value);

          if (conversationID != null && conversationID.isNotEmpty) {
            final conversation = await _database.getConversation(conversationID);
            if (conversation?.latestMsg?.clientMsgID == clientMsgID) {
              await _database.updateConversation(conversationID, {
                'latestMsg': jsonEncode(
                  DatabaseService.messageToDbMap(message.copyWith(status: MessageStatus.failed)),
                ),
              });
            }
          }
          await _database.deleteSendingMessage(clientMsgID);
          msgListener?.messageStatusChanged(message.copyWith(status: MessageStatus.failed));
        }
      }

      _log.info('Sending messages recovery completed', methodName: 'recoverSendingMessages');
    } catch (e, s) {
      _log.error(
        'Failed to recover sending messages: $e',
        error: e,
        stackTrace: s,
        methodName: 'recoverSendingMessages',
      );
    }
  }

  /// 创建文本消息
  /// [text] 文本内容
  Message createTextMessage({required String text}) {
    _log.info('text=$text', methodName: 'createTextMessage');
    try {
      return _createMessage(
        contentType: MessageType.text,
        textElem: TextElem(content: text),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createTextMessage');
      rethrow;
    }
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
    _log.info('text=$text, atUserIDList=$atUserIDList', methodName: 'createTextAtMessage');
    try {
      return _createMessage(
        contentType: MessageType.atText,
        atTextElem: AtTextElem(
          text: text,
          atUserList: atUserIDList,
          atUsersInfo: atUserInfoList,
          quoteMessage: quoteMessage,
        ),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createTextAtMessage');
      rethrow;
    }
  }

  /// 创建图片消息（本地文件路径）
  /// [imagePath] 图片路径
  Message createImageMessage({required String imagePath}) {
    _log.info('imagePath=$imagePath', methodName: 'createImageMessage');
    try {
      return _createMessage(
        contentType: MessageType.picture,
        pictureElem: PictureElem(sourcePath: imagePath),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createImageMessage');
      rethrow;
    }
  }

  /// 创建语音消息
  /// [soundPath] 语音文件路径
  /// [duration] 时长（秒）
  Message createSoundMessage({required String soundPath, required int duration}) {
    _log.info('soundPath=$soundPath, duration=$duration', methodName: 'createSoundMessage');
    try {
      final ext = soundPath.split('.').last.toLowerCase();
      // 对应 Go SDK CreateSoundMessage: SoundType = "audio/" + strings.ToLower(typ)
      final soundType = ext.isNotEmpty ? 'audio/$ext' : null;
      return _createMessage(
        contentType: MessageType.voice,
        soundElem: SoundElem(soundPath: soundPath, duration: duration, soundType: soundType),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createSoundMessage');
      rethrow;
    }
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
    _log.info(
      'videoPath=$videoPath, videoType=$videoType, duration=$duration',
      methodName: 'createVideoMessage',
    );
    try {
      return _createMessage(
        contentType: MessageType.video,
        videoElem: VideoElem(
          videoPath: videoPath,
          videoType: videoType,
          duration: duration,
          snapshotPath: snapshotPath,
        ),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createVideoMessage');
      rethrow;
    }
  }

  /// 创建文件消息
  /// [filePath] 文件路径
  /// [fileName] 文件名
  Message createFileMessage({required String filePath, required String fileName}) {
    _log.info('filePath=$filePath, fileName=$fileName', methodName: 'createFileMessage');
    try {
      return _createMessage(
        contentType: MessageType.file,
        fileElem: FileElem(filePath: filePath, fileName: fileName),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createFileMessage');
      rethrow;
    }
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
    _log.info(
      'title=$title, messageCount=${messageList.length}',
      methodName: 'createMergerMessage',
    );
    try {
      return _createMessage(
        contentType: MessageType.merger,
        mergeElem: MergeElem(title: title, abstractList: summaryList, multiMessage: messageList),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createMergerMessage');
      rethrow;
    }
  }

  /// 创建转发消息
  /// [message] 被转发的消息
  Message createForwardMessage({required Message message}) {
    _log.info('clientMsgID=${message.clientMsgID}', methodName: 'createForwardMessage');
    try {
      return message.copyWith(
        clientMsgID: OpenImUtils.generateClientMsgID(_currentUserID),
        createTime: _nowMillis(),
        sendTime: 0,
        status: MessageStatus.sending,
        sendID: _currentUserID,
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createForwardMessage');
      rethrow;
    }
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
      'latitude=$latitude, longitude=$longitude, description=$description',
      methodName: 'createLocationMessage',
    );
    try {
      return _createMessage(
        contentType: MessageType.location,
        locationElem: LocationElem(
          description: description,
          longitude: longitude,
          latitude: latitude,
        ),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createLocationMessage');
      rethrow;
    }
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
    _log.info('description=$description', methodName: 'createCustomMessage');
    try {
      return _createMessage(
        contentType: MessageType.custom,
        customElem: CustomElem(data: data, extension: extension, description: description),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createCustomMessage');
      rethrow;
    }
  }

  /// 创建引用消息
  /// [text] 回复内容
  /// [quoteMsg] 被引用的消息
  Message createQuoteMessage({required String text, required Message quoteMsg}) {
    _log.info('text=$text, quoteMsgID=${quoteMsg.clientMsgID}', methodName: 'createQuoteMessage');
    try {
      return _createMessage(
        contentType: MessageType.quote,
        quoteElem: QuoteElem(text: text, quoteMessage: quoteMsg),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createQuoteMessage');
      rethrow;
    }
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
    _log.info('userID=$userID, nickname=$nickname', methodName: 'createCardMessage');
    try {
      return _createMessage(
        contentType: MessageType.card,
        cardElem: CardElem(userID: userID, nickname: nickname, faceURL: faceURL, ex: ex),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createCardMessage');
      rethrow;
    }
  }

  /// 创建自定义表情消息
  /// [index] 位置表情，根据index匹配
  /// [data] URL表情，直接使用URL展示
  Message createFaceMessage({int index = -1, String? data}) {
    _log.info('index=$index', methodName: 'createFaceMessage');
    try {
      return _createMessage(
        contentType: MessageType.customFace,
        faceElem: FaceElem(index: index, data: data ?? ''),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createFaceMessage');
      rethrow;
    }
  }

  /// 创建高级文本消息（富文本）
  /// [text] 输入内容
  /// [list] 富文本消息详情
  Message createAdvancedTextMessage({required String text, List<RichMessageInfo> list = const []}) {
    _log.info('text=$text, listCount=${list.length}', methodName: 'createAdvancedTextMessage');
    try {
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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createAdvancedTextMessage');
      rethrow;
    }
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
    _log.info(
      'text=$text, quoteMsgID=${quoteMsg.clientMsgID}',
      methodName: 'createAdvancedQuoteMessage',
    );
    try {
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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createAdvancedQuoteMessage');
      rethrow;
    }
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
    _log.info('sourcePath=$sourcePath', methodName: 'createImageMessageByURL');
    try {
      return _createMessage(
        contentType: MessageType.picture,
        pictureElem: PictureElem(
          sourcePath: sourcePath,
          sourcePicture: sourcePicture,
          bigPicture: bigPicture,
          snapshotPicture: snapshotPicture,
        ),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createImageMessageByURL');
      rethrow;
    }
  }

  /// 通过URL创建语音消息
  /// [soundElem] 语音消息元素
  Message createSoundMessageByURL({required SoundElem soundElem}) {
    _log.info('duration=${soundElem.duration}', methodName: 'createSoundMessageByURL');
    try {
      return _createMessage(contentType: MessageType.voice, soundElem: soundElem);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createSoundMessageByURL');
      rethrow;
    }
  }

  /// 通过URL创建视频消息
  /// [videoElem] 视频消息元素
  Message createVideoMessageByURL({required VideoElem videoElem}) {
    _log.info(
      'videoType=${videoElem.videoType}, duration=${videoElem.duration}',
      methodName: 'createVideoMessageByURL',
    );
    try {
      return _createMessage(contentType: MessageType.video, videoElem: videoElem);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createVideoMessageByURL');
      rethrow;
    }
  }

  /// 通过URL创建文件消息
  /// [fileElem] 文件消息元素
  Message createFileMessageByURL({required FileElem fileElem}) {
    _log.info('fileName=${fileElem.fileName}', methodName: 'createFileMessageByURL');
    try {
      return _createMessage(contentType: MessageType.file, fileElem: fileElem);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createFileMessageByURL');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 消息发送
  // ---------------------------------------------------------------------------

  /// 内部方法：发送前判断是否包含本地文件路径，若有则进行上传，并且更新Message内容
  /// 对应 Go SDK sendMessage 中的 media file handle（Picture/Sound/Video/File 分支）
  Future<Message> _handleMediaUploadIfNeeded(Message msg) async {
    final clientMsgID = msg.clientMsgID ?? '';
    // 从暂存区取出 bytes（Web 平台由 createXxxFromBytes 存入）
    final pendingBytes = _pendingUploadBytes.remove(clientMsgID);
    final pendingSnapshotBytes = _pendingSnapshotBytes.remove(clientMsgID);

    int lastProgress = -1;

    // 辅助方法：调用消息发送进度回调
    // 对应 Go SDK NewUploadFileCallback.UploadComplete → progress(value)
    void reportProgress(int sent, int total) {
      if (total > 0) {
        final progress = ((sent / total) * 100).round();
        if (progress != lastProgress) {
          lastProgress = progress;
          msgSendProgressListener?.progress(clientMsgID, progress);
        }
      }
    }

    // 辅助方法：获取文件扩展名（对应 Go SDK filepathExt）
    String filepathExt(String? path1, [String? path2]) {
      for (final p in [path1, path2]) {
        if (p != null && p.isNotEmpty) {
          final dotIndex = p.lastIndexOf('.');
          if (dotIndex >= 0 && dotIndex < p.length - 1) {
            return p.substring(dotIndex);
          }
        }
      }
      return '';
    }

    // 辅助方法：生成上传文件名（对应 Go SDK c.fileName(ftype, id)）
    String uploadFileName(String ftype, String id) => 'msg_${ftype}_$id';

    if (msg.contentType == MessageType.picture && msg.pictureElem != null) {
      final elem = msg.pictureElem!;
      // 对应 Go SDK: if s.Status == constant.MsgStatusSendSuccess → skip
      if (elem.sourcePicture?.url != null && elem.sourcePicture!.url!.isNotEmpty) {
        return msg;
      }

      final sourcePath = elem.sourcePath;
      final ext = filepathExt(elem.sourcePicture?.uuid, sourcePath);
      // 对应 Go SDK: c.fileName("picture", s.ClientMsgID) + filepathExt(...)
      final name = '${uploadFileName("picture", clientMsgID)}$ext';
      // 对应 Go SDK: ContentType: s.PictureElem.SourcePicture.Type
      final contentType = elem.sourcePicture?.type ?? _getContentType(ext);
      String? url;
      int fileSize = 0;

      if (pendingBytes != null) {
        fileSize = pendingBytes.length;
        url = await OpenIM.iMManager.uploadFile(
          id: clientMsgID,
          fileBytes: pendingBytes,
          fileName: name,
          contentType: contentType,
          cause: 'msg-picture',
          onProgress: reportProgress,
        );
      } else if (sourcePath != null && sourcePath.isNotEmpty) {
        final file = File(sourcePath);
        if (file.existsSync()) {
          fileSize = file.lengthSync();
          url = await OpenIM.iMManager.uploadFile(
            id: clientMsgID,
            filePath: sourcePath,
            fileName: name,
            contentType: contentType,
            cause: 'msg-picture',
            onProgress: reportProgress,
          );
        }
      }

      if (url != null) {
        final sourcePic = (elem.sourcePicture ?? const PictureInfo()).copyWith(
          url: url,
          size: fileSize,
        );
        // 对应 Go SDK: s.PictureElem.BigPicture = s.PictureElem.SourcePicture
        final bigPic = sourcePic;
        // 对应 Go SDK: 解析 URL 添加 type=image&width=640&height=640 查询参数
        PictureInfo snapshotPic;
        try {
          final u = Uri.parse(url);
          final snapshotQuery = Map<String, String>.from(u.queryParameters);
          snapshotQuery['type'] = 'image';
          snapshotQuery['width'] = '640';
          snapshotQuery['height'] = '640';
          final snapshotUrl = u.replace(queryParameters: snapshotQuery).toString();
          snapshotPic = PictureInfo(width: 640, height: 640, url: snapshotUrl);
        } catch (_) {
          // 解析失败时回退到原始 URL（对应 Go SDK parse url failed 分支）
          snapshotPic = sourcePic;
        }
        return msg.copyWith(
          pictureElem: elem.copyWith(
            sourcePicture: sourcePic,
            bigPicture: bigPic,
            snapshotPicture: snapshotPic,
          ),
        );
      }
    } else if (msg.contentType == MessageType.voice && msg.soundElem != null) {
      final elem = msg.soundElem!;
      if (elem.sourceUrl != null && elem.sourceUrl!.isNotEmpty) {
        return msg;
      }

      final soundPath = elem.soundPath;
      if (soundPath != null && soundPath.isNotEmpty) {
        final file = File(soundPath);
        if (file.existsSync()) {
          final fileSize = file.lengthSync();
          final ext = filepathExt(elem.uuid, soundPath);
          // 对应 Go SDK: c.fileName("voice", s.ClientMsgID) + filepathExt(...)
          final name = '${uploadFileName("voice", clientMsgID)}$ext';
          // 对应 Go SDK: ContentType: s.SoundElem.SoundType
          final contentType = elem.soundType ?? _getContentType(ext);

          final url = await OpenIM.iMManager.uploadFile(
            id: clientMsgID,
            filePath: soundPath,
            fileName: name,
            contentType: contentType,
            cause: 'msg-voice',
            onProgress: reportProgress,
          );

          return msg.copyWith(
            soundElem: elem.copyWith(sourceUrl: url, dataSize: fileSize),
          );
        }
      }
    } else if (msg.contentType == MessageType.video && msg.videoElem != null) {
      final elem = msg.videoElem!;
      var newElem = elem;

      // 对应 Go SDK: 视频和缩略图并行上传（sync.WaitGroup + 两个 goroutine）
      final futures = <Future>[];

      // 上传视频缩略图（对应 Go SDK 的第一个 goroutine）
      if (elem.snapshotUrl == null || elem.snapshotUrl!.isEmpty) {
        futures.add(
          Future(() async {
            try {
              final snapExt = filepathExt(elem.snapshotUUID, elem.snapshotPath);
              // 对应 Go SDK: c.fileName("videoSnapshot", s.ClientMsgID) + filepathExt(...)
              final snapName = '${uploadFileName("videoSnapshot", clientMsgID)}$snapExt';
              // 对应 Go SDK: ContentType: s.VideoElem.SnapshotType
              final snapContentType = elem.snapshotType ?? _getContentType(snapExt);

              if (pendingSnapshotBytes != null) {
                final url = await OpenIM.iMManager.uploadFile(
                  id: '${clientMsgID}_snapshot',
                  fileBytes: pendingSnapshotBytes,
                  fileName: snapName,
                  contentType: snapContentType,
                  cause: 'msg-video-snapshot',
                );
                newElem = newElem.copyWith(
                  snapshotUrl: url,
                  snapshotSize: pendingSnapshotBytes.length,
                );
              } else if (elem.snapshotPath != null && elem.snapshotPath!.isNotEmpty) {
                final file = File(elem.snapshotPath!);
                if (file.existsSync()) {
                  final fileSize = file.lengthSync();
                  final url = await OpenIM.iMManager.uploadFile(
                    id: '${clientMsgID}_snapshot',
                    filePath: elem.snapshotPath!,
                    fileName: snapName,
                    contentType: snapContentType,
                    cause: 'msg-video-snapshot',
                  );
                  newElem = newElem.copyWith(snapshotUrl: url, snapshotSize: fileSize);
                }
              }
            } catch (e) {
              // 对应 Go SDK: 缩略图上传失败只 warn 不 return error
              _log.warning('upload video snapshot failed: $e');
            }
          }),
        );
      }

      // 上传视频文件（对应 Go SDK 的第二个 goroutine）
      if (elem.videoUrl == null || elem.videoUrl!.isEmpty) {
        futures.add(
          Future(() async {
            final videoExt = filepathExt(elem.videoUUID, elem.videoPath);
            // 对应 Go SDK: c.fileName("video", s.ClientMsgID) + filepathExt(...)
            final videoName = '${uploadFileName("video", clientMsgID)}$videoExt';
            // 对应 Go SDK: ContentType: content_type.GetType(s.VideoElem.VideoType, filepath.Ext(...))
            final videoContentType = _getContentType(elem.videoType, videoExt);

            if (pendingBytes != null) {
              final url = await OpenIM.iMManager.uploadFile(
                id: clientMsgID,
                fileBytes: pendingBytes,
                fileName: videoName,
                contentType: videoContentType,
                cause: 'msg-video',
                onProgress: reportProgress,
              );
              newElem = newElem.copyWith(videoUrl: url, videoSize: pendingBytes.length);
            } else if (elem.videoPath != null && elem.videoPath!.isNotEmpty) {
              final file = File(elem.videoPath!);
              if (file.existsSync()) {
                final fileSize = file.lengthSync();
                final url = await OpenIM.iMManager.uploadFile(
                  id: clientMsgID,
                  filePath: elem.videoPath!,
                  fileName: videoName,
                  contentType: videoContentType,
                  cause: 'msg-video',
                  onProgress: reportProgress,
                );
                newElem = newElem.copyWith(videoUrl: url, videoSize: fileSize);
              }
            }
          }),
        );
      }

      // 并行等待所有上传完成（对应 Go SDK wg.Wait()）
      if (futures.isNotEmpty) {
        await Future.wait(futures);
      }
      return msg.copyWith(videoElem: newElem);
    } else if (msg.contentType == MessageType.file && msg.fileElem != null) {
      final elem = msg.fileElem!;
      if (elem.sourceUrl != null && elem.sourceUrl!.isNotEmpty) {
        return msg;
      }

      // 对应 Go SDK: name 为 FileName 或 FilePath，fallback 为默认
      final baseName = elem.fileName ?? (elem.filePath ?? 'file').split('/').last;
      // 对应 Go SDK: c.fileName("file", s.ClientMsgID) + "/" + filepath.Base(name)
      final name =
          '${uploadFileName("file", clientMsgID)}/${baseName.isNotEmpty ? baseName : "file"}';
      // 对应 Go SDK: ContentType: content_type.GetType(s.FileElem.FileType, filepath.Ext(FilePath), filepath.Ext(FileName))
      final contentType = _getContentType(
        elem.fileType,
        filepathExt(elem.filePath),
        filepathExt(elem.fileName),
      );
      String? url;
      int fileSize = 0;

      if (pendingBytes != null) {
        fileSize = pendingBytes.length;
        url = await OpenIM.iMManager.uploadFile(
          id: clientMsgID,
          fileBytes: pendingBytes,
          fileName: name,
          contentType: contentType,
          cause: 'msg-file',
          onProgress: reportProgress,
        );
      } else if (elem.filePath != null && elem.filePath!.isNotEmpty) {
        final file = File(elem.filePath!);
        if (file.existsSync()) {
          fileSize = file.lengthSync();
          url = await OpenIM.iMManager.uploadFile(
            id: clientMsgID,
            filePath: elem.filePath!,
            fileName: name,
            contentType: contentType,
            cause: 'msg-file',
            onProgress: reportProgress,
          );
        }
      }

      if (url != null) {
        return msg.copyWith(
          fileElem: elem.copyWith(sourceUrl: url, fileSize: fileSize, fileName: baseName),
        );
      }
    }

    return msg;
  }

  /// 发送消息
  /// [message] 消息内容
  /// [offlinePushInfo] 离线消息显示内容
  /// [userID] 接收者用户ID
  /// [groupID] 接收群组ID
  /// [isOnlineOnly] 是否仅在线发送
  /// [messageOptions] 自定义消息选项，会在 isOnlineOnly 之后应用，可覆盖单个标志
  Future<Message> sendMessage({
    required Message message,
    required OfflinePushInfo offlinePushInfo,
    String? userID,
    String? groupID,
    bool isOnlineOnly = false,
    Map<String, bool>? messageOptions,
  }) async {
    _log.info(
      'clientMsgID=${message.clientMsgID}, contentType=${message.contentType}, userID=$userID, groupID=$groupID, isOnlineOnly=$isOnlineOnly',
    );
    final isGroupMsg = groupID != null && groupID.isNotEmpty;
    final sessionType = isGroupMsg ? ConversationType.superGroup : ConversationType.single;

    // 填充发送者信息（对应 Go SDK initBasicInfo + checkID）
    String? senderNickname;
    String? senderFaceUrl;
    final loginUser = await _database.getLoginUser();
    if (loginUser != null) {
      senderNickname = loginUser.nickname;
      senderFaceUrl = loginUser.faceURL;
    }
    // 群消息优先使用群成员昵称（对应 Go SDK checkID 中的 GetGroupMemberInfoByGroupIDUserID）
    if (isGroupMsg) {
      try {
        final gm = await _database.getGroupMember(groupID, _currentUserID);
        if (gm != null && gm.nickname != null && gm.nickname!.isNotEmpty) {
          senderNickname = gm.nickname;
        }
      } catch (_) {}
    }

    final sendMsg = message.copyWith(
      sendID: _currentUserID,
      senderNickname: senderNickname,
      senderFaceUrl: senderFaceUrl,
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
      // 检查DB中是否已有该消息（支持重发场景）
      final oldMsg = await _database.getMessage(sendMsg.clientMsgID!);
      if (oldMsg == null) {
        final dbMap = DatabaseService.messageToDbMap(sendMsg);
        dbMap['conversationID'] = conversationID;
        await _database.insertMessage(dbMap);
        await _database.insertSendingMessage(sendMsg.clientMsgID!, conversationID);
      } else {
        if (oldMsg.status?.value != MessageStatus.failed.value &&
            oldMsg.status?.value != MessageStatus.sending.value) {
          throw OpenIMException(code: 1, message: 'Message is repeated');
        }
        await _database.updateMessage(sendMsg.clientMsgID!, {
          'status': MessageStatus.sending.value,
          'conversationID': conversationID,
        });
        await _database.insertSendingMessage(sendMsg.clientMsgID!, conversationID);
      }
      // 立即更新会话，让 UI 立即看到"发送中"的最新消息
      await _updateConversationLatestMsg(conversationID, sendMsg, sessionType);
    }

    try {
      // 处理媒体文件上传并返回更新后的消息
      final finalMsg = await _handleMediaUploadIfNeeded(sendMsg);

      if (!isOnlineOnly && !identical(finalMsg, sendMsg)) {
        // 仅在媒体上传后消息有变化时才更新本地DB（文本消息无需此步骤）
        final finalDbMap = DatabaseService.messageToDbMap(finalMsg);
        finalDbMap['conversationID'] = conversationID;
        await _database.updateMessage(finalMsg.clientMsgID!, finalDbMap);
      }

      _log.info('消息准备发送${isOnlineOnly ? "(仅在线)" : "到本地"}: ${finalMsg.clientMsgID}');

      // 通过 WebSocket 发送消息（使用 protobuf 编码，与 Go SDK 保持一致）
      final sentMsg = await _sendMsgViaWebSocket(
        finalMsg,
        conversationID,
        sessionType,
        isOnlineOnly,
        messageOptions: messageOptions,
      );
      return sentMsg;
    } on OpenIMException {
      // 服务端返回错误（如不是好友等），DB 已在 _sendMsgViaWebSocket 中更新为失败状态
      rethrow;
    } catch (e) {
      _log.warning('消息发送异常: $e');
      if (!isOnlineOnly) {
        // 安全检查：如果消息已经在DB中标记为成功，则不要覆盖为失败
        final currentMsg = await _database.getMessage(sendMsg.clientMsgID!);
        if (currentMsg != null && currentMsg.status == MessageStatus.succeeded) {
          _log.info('消息已发送成功（DB状态=succeeded），忽略后续异常');
          return currentMsg;
        }
        final failedMsg = sendMsg.copyWith(status: MessageStatus.failed);
        await _database.updateMessage(failedMsg.clientMsgID!, {
          'status': MessageStatus.failed.value,
        });
        await _database.deleteSendingMessage(failedMsg.clientMsgID!);
        // 更新会话最新消息为失败状态
        try {
          await _updateConversationLatestMsg(conversationID, failedMsg, sessionType);
        } catch (_) {}
        // 通知 UI 消息状态变更（发送失败）
        msgListener?.messageStatusChanged(failedMsg);
        // 通知 UI 进度监听器发送失败
        msgSendProgressListener?.fail(failedMsg.clientMsgID!, e.toString());
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
  }) async {
    _log.info('isOnlineOnly=$isOnlineOnly', methodName: 'sendMessageNotOss');
    try {
      return await sendMessage(
        message: message,
        offlinePushInfo: offlinePushInfo,
        userID: userID,
        groupID: groupID,
        isOnlineOnly: isOnlineOnly,
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'sendMessageNotOss');
      rethrow;
    }
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
      'conversationID=$conversationID, startMsgID=${startMsg?.clientMsgID}, viewType=$viewType, count=$count',
      methodName: 'getAdvancedHistoryMessageList',
    );
    try {
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
        // 即使 convMaxSeq = 0 也尝试拉取（首次安装时可能为 0），确保能获取历史消息
        // 只有当 seq 为 0 且本地已有消息时才跳过（说明确实没有更多消息）
        if (convMaxSeq >= 0) {
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
            // convMaxSeq = 0 时，currentSeq = 1 表示尝试拉取 seq=1 的消息
            currentSeq = convMaxSeq > 0 ? convMaxSeq + 1 : 1;
          }

          // 始终尝试拉取（currentSeq >= 1），服务器返回空说明没有更多消息
          if (currentSeq >= 1) {
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
                      // 云端拉取的消息默认为已成功发送状态
                      // protobuf int 默认值是 0（不是 null），需要显式处理
                      final rawStatus = m['status'];
                      if (rawStatus == null || rawStatus == 0) {
                        m['status'] = MessageStatus.succeeded.value;
                      }
                      batchInsert.add(m);
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
              } catch (e, s) {
                _log.warning(
                  '云端历史消息拉取失败: $e',
                  error: e,
                  stackTrace: s,
                  methodName: 'getAdvancedHistoryMessageList',
                );
              }
            }
          }
        }
      }

      final isEnd = dataList.length <= queryCount;
      final actualData = isEnd ? dataList : dataList.sublist(0, queryCount);

      return AdvancedMessage(messageList: actualData, isEnd: isEnd);
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'getAdvancedHistoryMessageList',
      );
      rethrow;
    }
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
      'conversationID=$conversationID, startMsgID=${startMsg?.clientMsgID}, count=$count',
      methodName: 'getAdvancedHistoryMessageListReverse',
    );
    try {
      final result = await getAdvancedHistoryMessageList(
        conversationID: conversationID,
        startMsg: startMsg,
        viewType: viewType,
        count: count,
      );
      return result.copyWith(messageList: result.messageList?.reversed.toList());
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'getAdvancedHistoryMessageListReverse',
      );
      rethrow;
    }
  }

  /// 根据消息ID列表查找消息
  /// [searchParams] 搜索参数列表
  Future<SearchResult> findMessageList({required List<SearchParams> searchParams}) async {
    _log.info('searchParamsCount=${searchParams.length}', methodName: 'findMessageList');
    try {
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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'findMessageList');
      rethrow;
    }
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
      'conversationID=$conversationID, keywordList=$keywordList, pageIndex=$pageIndex, count=$count',
      methodName: 'searchLocalMessages',
    );
    try {
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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'searchLocalMessages');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 消息操作
  // ---------------------------------------------------------------------------

  /// 撤回消息
  /// [conversationID] 会话ID
  /// [clientMsgID] 消息ID
  Future<void> revokeMessage({required String conversationID, required String clientMsgID}) async {
    _log.info(
      'conversationID=$conversationID, clientMsgID=$clientMsgID',
      methodName: 'revokeMessage',
    );
    try {
      // 获取消息的 seq 用于服务端撤回
      final msg = await _database.getMessage(clientMsgID);
      final seq = msg?.seq ?? 0;

      await _database.updateMessage(clientMsgID, {
        'contentType': MessageType.revokeMessageNotification.value,
      });
      _log.info('消息已撤回: $clientMsgID', methodName: 'revokeMessage');

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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'revokeMessage');
      rethrow;
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
      'conversationID=$conversationID, clientMsgID=$clientMsgID',
      methodName: 'deleteMessageFromLocalStorage',
    );
    try {
      final deletedMsg = await _database.getMessage(clientMsgID);
      await _database.deleteMessage(clientMsgID);
      _log.info('消息已从本地删除: $clientMsgID', methodName: 'deleteMessageFromLocalStorage');

      // 如果删除的是未读消息（非自己发送），减少未读数（对应 Go SDK delete.go）
      if (deletedMsg != null &&
          !(deletedMsg.isRead ?? true) &&
          deletedMsg.sendID != _currentUserID) {
        await _database.decrConversationUnreadCount(conversationID, 1);
        _notifyConversationAndUnread(conversationID);
      }

      // 如果删除的是会话最新消息，更新 latestMsg
      await _updateConversationIfLatestMsg(conversationID, clientMsgID);

      if (deletedMsg != null) {
        msgListener?.msgDeleted(deletedMsg);
      }
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'deleteMessageFromLocalStorage',
      );
      rethrow;
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
      'conversationID=$conversationID, clientMsgID=$clientMsgID',
      methodName: 'deleteMessageFromLocalAndSvr',
    );
    try {
      // 获取消息的 seq 用于服务端删除
      final msg = await _database.getMessage(clientMsgID);
      final seq = msg?.seq ?? 0;

      await _database.deleteMessage(clientMsgID);
      _log.info('消息已从本地和服务器删除: $clientMsgID', methodName: 'deleteMessageFromLocalAndSvr');

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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'deleteMessageFromLocalAndSvr');
      rethrow;
    }
  }

  /// 删除所有本地消息
  Future<void> deleteAllMsgFromLocal() async {
    _log.info('called', methodName: 'deleteAllMsgFromLocal');
    try {
      // 先获取所有会话用于回调
      final allConvs = await _database.getAllConversations();
      final affectedIDs = allConvs.map((c) => c.conversationID).toList();

      await _database.deleteAllMessages();
      _log.info('所有本地消息已删除', methodName: 'deleteAllMsgFromLocal');

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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'deleteAllMsgFromLocal');
      rethrow;
    }
  }

  /// 删除所有消息（本地和服务器）
  Future<void> deleteAllMsgFromLocalAndSvr() async {
    _log.info('called', methodName: 'deleteAllMsgFromLocalAndSvr');
    try {
      await _database.deleteAllMessages();
      _log.info('所有消息已从本地和服务器删除', methodName: 'deleteAllMsgFromLocalAndSvr');

      // 触发 totalUnreadChanged（对应 Go SDK deleteAllMsgFromLocalAndServer）
      final total = await _database.getTotalUnreadCount();
      _conversationManager?.listener?.totalUnreadMessageCountChanged(total);

      // 同步到服务器
      final resp = await _api.clearAllMsg(userID: _currentUserID);
      if (resp.errCode != 0) {
        _log.warning('清空所有消息同步服务器失败: ${resp.errMsg}');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'deleteAllMsgFromLocalAndSvr');
      rethrow;
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
    _log.info(
      'conversationID=$conversationID, clientMsgID=$clientMsgID',
      methodName: 'setMessageLocalEx',
    );
    try {
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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setMessageLocalEx');
      rethrow;
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
    _log.info(
      'receiverID=$receiverID, senderID=$senderID',
      methodName: 'insertSingleMessageToLocalStorage',
    );
    try {
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
      final dbMap = DatabaseService.messageToDbMap(msg);
      dbMap['conversationID'] = conversationID;
      await _database.insertMessage(dbMap);
      // 触发会话更新（对应 Go SDK InsertSingleMessageToLocalStorage 的 AddConOrUpLatMsg）
      await _updateConversationLatestMsg(conversationID, msg, ConversationType.single);
      return msg;
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'insertSingleMessageToLocalStorage',
      );
      rethrow;
    }
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
    _log.info(
      'groupID=$groupID, senderID=$senderID',
      methodName: 'insertGroupMessageToLocalStorage',
    );
    try {
      final msg = (message ?? _createMessage(contentType: MessageType.text)).copyWith(
        sendID: senderID,
        groupID: groupID,
        sessionType: ConversationType.superGroup,
        status: MessageStatus.succeeded,
        sendTime: _nowMillis(),
      );
      final conversationID = OpenImUtils.genGroupConversationID(groupID ?? '');
      final dbMap = DatabaseService.messageToDbMap(msg);
      dbMap['conversationID'] = conversationID;
      await _database.insertMessage(dbMap);
      // 触发会话更新（对应 Go SDK InsertGroupMessageToLocalStorage 的 AddConOrUpLatMsg）
      await _updateConversationLatestMsg(conversationID, msg, ConversationType.superGroup);
      return msg;
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'insertGroupMessageToLocalStorage',
      );
      rethrow;
    }
  }

  /// 创建图片消息（通过完整文件路径）
  /// [imagePath] 图片的完整路径
  /// 对应 Go SDK CreateImageMessageFromFullPath：
  /// 通过 getImageInfo 获取 width / height / type，填充 SourcePicture
  Future<Message> createImageMessageFromFullPath({
    required String imagePath,
    String? operationID,
  }) async {
    _log.info('imagePath=$imagePath', methodName: 'createImageMessageFromFullPath');
    try {
      final file = File(imagePath);
      final fileSize = file.existsSync() ? file.lengthSync() : 0;
      final ext = imagePath.split('.').last.toLowerCase();
      final imageType = 'image/$ext';

      // 在后台 Isolate 中读取图片宽高（对应 Go SDK 的 getImageInfo）
      int width = 0;
      int height = 0;
      try {
        final dims = await isolate_util.computeImageDimensionsFromFile(imagePath);
        if (dims != null) {
          width = dims.width;
          height = dims.height;
        }
      } catch (e, s) {
        _log.warning(
          '读取图片尺寸失败: $e',
          error: e,
          stackTrace: s,
          methodName: 'createImageMessageFromFullPath',
        );
      }

      return _createMessage(
        contentType: MessageType.picture,
        pictureElem: PictureElem(
          sourcePath: imagePath,
          sourcePicture: PictureInfo(width: width, height: height, type: imageType, size: fileSize),
        ),
      );
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'createImageMessageFromFullPath',
      );
      rethrow;
    }
  }

  /// 创建语音消息（通过完整文件路径）
  /// [soundPath] 语音文件的完整路径
  /// [duration] 时长（秒）
  /// 对应 Go SDK CreateSoundMessageFromFullPath：获取 DataSize
  Message createSoundMessageFromFullPath({
    required String soundPath,
    required int duration,
    String? operationID,
  }) {
    _log.info(
      'soundPath=$soundPath, duration=$duration',
      methodName: 'createSoundMessageFromFullPath',
    );
    try {
      final file = File(soundPath);
      final fileSize = file.existsSync() ? file.lengthSync() : 0;
      // 对应 Go SDK CreateSoundMessageFromFullPath: SoundType = ext (不带点)
      final ext = soundPath.split('.').last.toLowerCase();
      final soundType = ext.isNotEmpty ? 'audio/$ext' : null;

      return _createMessage(
        contentType: MessageType.voice,
        soundElem: SoundElem(
          soundPath: soundPath,
          duration: duration,
          dataSize: fileSize,
          soundType: soundType,
        ),
      );
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'createSoundMessageFromFullPath',
      );
      rethrow;
    }
  }

  /// 创建视频消息（通过完整文件路径）
  /// [videoPath] 视频文件的完整路径
  /// [videoType] 视频MIME类型
  /// [duration] 时长（秒）
  /// [snapshotPath] 缩略图完整路径
  /// 对应 Go SDK CreateVideoMessageFromFullPath：获取 VideoSize、SnapshotSize/Width/Height
  Future<Message> createVideoMessageFromFullPath({
    required String videoPath,
    required String videoType,
    required int duration,
    required String snapshotPath,
    String? operationID,
  }) async {
    _log.info(
      'videoPath=$videoPath, videoType=$videoType, duration=$duration',
      methodName: 'createVideoMessageFromFullPath',
    );
    try {
      final videoFile = File(videoPath);
      final videoSize = videoFile.existsSync() ? videoFile.lengthSync() : 0;

      int snapWidth = 0;
      int snapHeight = 0;
      int snapSize = 0;
      if (snapshotPath.isNotEmpty) {
        final snapFile = File(snapshotPath);
        if (snapFile.existsSync()) {
          snapSize = snapFile.lengthSync();
          // 在后台 Isolate 中解析缩略图尺寸
          try {
            final dims = await isolate_util.computeImageDimensionsFromFile(snapshotPath);
            if (dims != null) {
              snapWidth = dims.width;
              snapHeight = dims.height;
            }
          } catch (e, s) {
            _log.warning(
              '读取视频缩略图尺寸失败: $e',
              error: e,
              stackTrace: s,
              methodName: 'createVideoMessageFromFullPath',
            );
          }
        }
      }

      return _createMessage(
        contentType: MessageType.video,
        videoElem: VideoElem(
          videoPath: videoPath,
          videoType: videoType,
          duration: duration,
          videoSize: videoSize,
          snapshotPath: snapshotPath,
          snapshotWidth: snapWidth,
          snapshotHeight: snapHeight,
          snapshotSize: snapSize,
        ),
      );
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'createVideoMessageFromFullPath',
      );
      rethrow;
    }
  }

  /// 创建文件消息（通过完整文件路径）
  /// [filePath] 文件的完整路径
  /// [fileName] 文件名
  /// 对应 Go SDK CreateFileMessageFromFullPath：获取 FileSize
  Message createFileMessageFromFullPath({
    required String filePath,
    required String fileName,
    String? operationID,
  }) {
    _log.info(
      'filePath=$filePath, fileName=$fileName',
      methodName: 'createFileMessageFromFullPath',
    );
    try {
      final file = File(filePath);
      final fileSize = file.existsSync() ? file.lengthSync() : 0;

      return _createMessage(
        contentType: MessageType.file,
        fileElem: FileElem(filePath: filePath, fileName: fileName, fileSize: fileSize),
      );
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'createFileMessageFromFullPath',
      );
      rethrow;
    }
  }

  /// 创建图片消息（通过字节数据，Web 平台使用）
  /// [bytes] 图片文件的字节数据
  /// [fileName] 文件名（如 "photo.jpg"）
  Future<Message> createImageMessageFromBytes({
    required Uint8List bytes,
    required String fileName,
  }) async {
    _log.info(
      'fileName=$fileName, size=${bytes.length}',
      methodName: 'createImageMessageFromBytes',
    );
    try {
      final ext = fileName.split('.').last.toLowerCase();
      final imageType = 'image/$ext';

      // 在后台 Isolate 中解析图片宽高
      int width = 0;
      int height = 0;
      try {
        final dims = await isolate_util.computeImageDimensions(bytes);
        if (dims != null) {
          width = dims.width;
          height = dims.height;
        }
      } catch (e, s) {
        _log.warning(
          '读取图片尺寸失败: $e',
          error: e,
          stackTrace: s,
          methodName: 'createImageMessageFromBytes',
        );
      }

      final message = _createMessage(
        contentType: MessageType.picture,
        pictureElem: PictureElem(
          sourcePath: fileName, // web 无真实路径，使用文件名作标识
          sourcePicture: PictureInfo(
            width: width,
            height: height,
            type: imageType,
            size: bytes.length,
          ),
        ),
      );
      // 暂存 bytes 供 sendMessage 时上传
      _pendingUploadBytes[message.clientMsgID!] = bytes;
      return message;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createImageMessageFromBytes');
      rethrow;
    }
  }

  /// 创建视频消息（通过字节数据，Web 平台使用）
  /// [bytes] 视频文件的字节数据
  /// [fileName] 文件名（如 "video.mp4"）
  /// [duration] 时长（秒）
  /// [videoType] 视频 MIME 类型
  /// [snapshotBytes] 缩略图字节数据（可选）
  Future<Message> createVideoMessageFromBytes({
    required Uint8List bytes,
    required String fileName,
    required int duration,
    String? videoType,
    Uint8List? snapshotBytes,
  }) async {
    _log.info(
      'fileName=$fileName, size=${bytes.length}, duration=$duration',
      methodName: 'createVideoMessageFromBytes',
    );
    try {
      final ext = fileName.split('.').last.toLowerCase();

      int snapWidth = 0;
      int snapHeight = 0;
      int snapSize = 0;
      if (snapshotBytes != null) {
        snapSize = snapshotBytes.length;
        // 在后台 Isolate 中解析缩略图尺寸
        try {
          final dims = await isolate_util.computeImageDimensions(snapshotBytes);
          if (dims != null) {
            snapWidth = dims.width;
            snapHeight = dims.height;
          }
        } catch (_) {}
      }

      final message = _createMessage(
        contentType: MessageType.video,
        videoElem: VideoElem(
          videoPath: fileName,
          videoType: videoType ?? 'video/$ext',
          duration: duration,
          videoSize: bytes.length,
          snapshotPath: snapshotBytes != null ? 'snapshot_$fileName.jpg' : null,
          snapshotWidth: snapWidth,
          snapshotHeight: snapHeight,
          snapshotSize: snapSize,
        ),
      );
      _pendingUploadBytes[message.clientMsgID!] = bytes;
      if (snapshotBytes != null) {
        _pendingSnapshotBytes[message.clientMsgID!] = snapshotBytes;
      }
      return message;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createVideoMessageFromBytes');
      rethrow;
    }
  }

  /// 创建文件消息（通过字节数据，Web 平台使用）
  /// [bytes] 文件的字节数据
  /// [fileName] 文件名
  Message createFileMessageFromBytes({required Uint8List bytes, required String fileName}) {
    _log.info('fileName=$fileName, size=${bytes.length}', methodName: 'createFileMessageFromBytes');
    try {
      final message = _createMessage(
        contentType: MessageType.file,
        fileElem: FileElem(filePath: fileName, fileName: fileName, fileSize: bytes.length),
      );
      _pendingUploadBytes[message.clientMsgID!] = bytes;
      return message;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createFileMessageFromBytes');
      rethrow;
    }
  }

  /// 处理收到的新消息
  void onRecvNewMessage(Message message) {
    _log.info('called', methodName: 'onRecvNewMessage');
    try {
      msgListener?.recvNewMessage(message);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'onRecvNewMessage');
      rethrow;
    }
  }

  /// 处理收到的离线消息
  void onRecvOfflineNewMessage(Message message) {
    _log.info('called', methodName: 'onRecvOfflineNewMessage');
    try {
      msgListener?.recvOfflineNewMessage(message);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'onRecvOfflineNewMessage');
      rethrow;
    }
  }

  /// 处理批量离线消息（补拉完成后按会话批量分发，对齐 Go SDK batchNewMessages 设计）
  void onRecvOfflineNewMessages(List<Message> messages) {
    _log.info('called, count=${messages.length}', methodName: 'onRecvOfflineNewMessages');
    try {
      msgListener?.recvOfflineNewMessages(messages);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'onRecvOfflineNewMessages');
      rethrow;
    }
  }

  /// 处理收到的仅在线消息
  void onRecvOnlineOnlyMessage(Message message) {
    _log.info('called', methodName: 'onRecvOnlineOnlyMessage');
    try {
      msgListener?.recvOnlineOnlyMessage(message);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'onRecvOnlineOnlyMessage');
      rethrow;
    }
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
    _log.info('conversationID=$conversationID', methodName: '_updateConversationLatestMsg');
    try {
      final conv = await _database.getConversation(conversationID);
      final listener = _conversationManager?.listener;
      if (conv != null) {
        final existingTime = conv.latestMsgSendTime ?? 0;
        final newMsgTime = message.sendTime ?? 0;
        final existingClientMsgID = _getConversationLatestMsgClientID(conv);
        final isSameMessage =
            message.clientMsgID != null && message.clientMsgID == existingClientMsgID;

        if (newMsgTime >= existingTime || isSameMessage) {
          await _database.updateConversation(conversationID, {
            'latestMsg': jsonEncode(DatabaseService.messageToDbMap(message)),
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
          'latestMsg': jsonEncode(DatabaseService.messageToDbMap(message)),
          'latestMsgSendTime': message.sendTime,
          'unreadCount': 0,
        });
        // 触发 OnNewConversation
        final newConv = await _database.getConversation(conversationID);
        if (newConv != null) {
          listener?.newConversation([newConv]);
        }
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_updateConversationLatestMsg');
      rethrow;
    }
  }

  /// 获取会话最新消息的 clientMsgID
  /// 对应 Go SDK getConversationLatestMsgClientID (notification.go:177-183)
  String? _getConversationLatestMsgClientID(ConversationInfo conv) {
    return conv.latestMsg?.clientMsgID;
  }

  /// 如果被删除/撤回的消息是会话的 latestMsg，则更新 latestMsg 为次新消息
  /// 对应 Go SDK delete.go / revoke.go 中的 latestMsg 判断更新逻辑
  Future<void> _updateConversationIfLatestMsg(String conversationID, String clientMsgID) async {
    _log.info(
      'conversationID=$conversationID, clientMsgID=$clientMsgID',
      methodName: '_updateConversationIfLatestMsg',
    );
    try {
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
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: '_updateConversationIfLatestMsg',
      );
      rethrow;
    }
  }

  /// 触发 conversationChanged + totalUnreadChanged（删除未读消息后使用）
  Future<void> _notifyConversationAndUnread(String conversationID) async {
    _log.info('conversationID=$conversationID', methodName: '_notifyConversationAndUnread');
    try {
      final listener = _conversationManager?.listener;
      final conv = await _database.getConversation(conversationID);
      if (conv != null) {
        listener?.conversationChanged([conv]);
      }
      final total = await _database.getTotalUnreadCount();
      listener?.totalUnreadMessageCountChanged(total);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_notifyConversationAndUnread');
      rethrow;
    }
  }

  /// 通过 WebSocket 发送消息（使用 protobuf）
  Future<Message> _sendMsgViaWebSocket(
    Message message,
    String conversationID,
    ConversationType sessionType,
    bool isOnlineOnly, {
    Map<String, bool>? messageOptions,
  }) async {
    _log.info(
      'conversationID=$conversationID, clientMsgID=${message.clientMsgID}',
      methodName: '_sendMsgViaWebSocket',
    );
    try {
      // 1. 构建 MsgData protobuf
      final msgData = _buildMsgData(message, isOnlineOnly, messageOptions: messageOptions);

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
            // 会话更新失败不应影响消息发送成功的状态
            try {
              await _updateConversationLatestMsg(conversationID, sentMsg, sessionType);
            } catch (e) {
              _log.warning('消息已发送成功，但更新会话最新消息失败: $e');
            }
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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_sendMsgViaWebSocket');
      rethrow;
    }
  }

  /// 构建 MsgData protobuf
  /// 对应 sdkws.proto 中的 MsgData 消息
  sdkws.MsgData _buildMsgData(Message msg, bool isOnlineOnly, {Map<String, bool>? messageOptions}) {
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
    if (msg.offlinePush != null && (!isOnlineOnly || messageOptions?['offlinePush'] == true)) {
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

    // 自定义选项覆盖（在 isOnlineOnly 之后应用，可重新开启某些标志）
    if (messageOptions != null) {
      for (final entry in messageOptions.entries) {
        msgData.options[entry.key] = entry.value;
      }
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

  /// 对应 Go SDK content_type.GetType(val ...string) string
  /// 逻辑：遍历每个参数，若含 "/" 则视为已有 MIME 直接返回；
  /// 否则去掉前导 "."，按扩展名查表；全部查不到返回 application/octet-stream
  static const _extMimeMap = <String, String>{
    'html': 'text/html',
    'htm': 'text/html',
    'css': 'text/css',
    'js': 'application/javascript',
    'json': 'application/json',
    'xml': 'application/xml',
    'png': 'image/png',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'gif': 'image/gif',
    'bmp': 'image/bmp',
    'tif': 'image/tiff',
    'tiff': 'image/tiff',
    'ico': 'image/x-icon',
    'svg': 'image/svg+xml',
    'webp': 'image/webp',
    'mp4': 'video/mp4',
    'avi': 'video/x-msvideo',
    'mkv': 'video/x-matroska',
    'mov': 'video/quicktime',
    'wmv': 'video/x-ms-wmv',
    'flv': 'video/x-flv',
    'webm': 'video/webm',
    '3gp': 'video/3gpp',
    'm4a': 'audio/mp4',
    'mp3': 'audio/mpeg',
    'wav': 'audio/wav',
    'ogg': 'audio/ogg',
    'aac': 'audio/aac',
    'wma': 'audio/x-ms-wma',
    'flac': 'audio/flac',
    'mid': 'audio/midi',
    'midi': 'audio/midi',
    'weba': 'audio/webm',
    'pdf': 'application/pdf',
    'doc': 'application/msword',
    'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt': 'application/vnd.ms-powerpoint',
    'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'txt': 'text/plain',
    'csv': 'text/csv',
    'zip': 'application/zip',
    'rar': 'application/x-rar-compressed',
    'tar': 'application/x-tar',
    'gz': 'application/gzip',
    'exe': 'application/x-msdownload',
    'msi': 'application/x-msi',
    'deb': 'application/x-debian-package',
    'rpm': 'application/x-redhat-package-manager',
    'sh': 'application/x-sh',
    'bat': 'application/bat',
    'py': 'application/x-python',
    'java': 'text/x-java-source',
    'c': 'text/x-csrc',
    'cpp': 'text/x-c++src',
    'h': 'text/x-chdr',
    'hpp': 'text/x-c++hdr',
    'php': 'application/x-php',
    'asp': 'application/x-asp',
    'jsp': 'application/x-jsp',
    'dll': 'application/x-msdownload',
    'jar': 'application/java-archive',
    'war': 'application/java-archive',
    'ear': 'application/java-archive',
  };

  String _getContentType([String? val1, String? val2, String? val3]) {
    for (final s in [val1, val2, val3]) {
      if (s == null || s.length <= 1) continue;
      if (s.contains('/')) return s;
      final key = s.startsWith('.') ? s.substring(1) : s;
      final mime = _extMimeMap[key] ?? _extMimeMap[key.toLowerCase()];
      if (mime != null) return mime;
    }
    return 'application/octet-stream';
  }
}
