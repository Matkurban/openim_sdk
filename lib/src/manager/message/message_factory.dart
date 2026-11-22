import 'dart:typed_data';

import 'package:logging/logging.dart';

import '../../concurrency/sdk_compute_executor.dart';
import '../../enums/message_status.dart';
import '../../enums/message_type.dart';
import '../../models/call_signal_elem.dart';
import '../../models/message.dart';
import '../../models/red_packet_elem.dart';
import '../../models/red_packet_grab_notify_elem.dart';
import '../../utils/file_util.dart';
import '../../utils/open_im_utils.dart';
import '../../utils/platform_utils.dart';

/// 消息构建工厂（从原 2,625 行 `MessageManager` 拆出，专注各类消息体创建）。
class MessageFactory {
  final Logger _logger = Logger('openim_sdk.MessageFactory');
  final String Function() _userIDProvider;

  /// 内存字节暂存区（供 Web / `createXxxByFile` 创建后在 `sendMessage` 时上传消费）。
  final Map<String, Uint8List> pendingUploadBytes = <String, Uint8List>{};

  /// 待处理缩略图字节数据。
  ///
  /// Pending snapshot bytes.
  final Map<String, Uint8List> pendingSnapshotBytes = <String, Uint8List>{};

  /// 创建 `MessageFactory` 实例。
  ///
  /// Creates a `MessageFactory` instance.
  ///
  /// - [_userIDProvider] 用户IDProvider / User ID provider.
  MessageFactory({required this._userIDProvider});

  /// 清空待处理字节数据。
  ///
  /// Clear pending bytes.
  void clearPendingBytes() {
    pendingUploadBytes.clear();
    pendingSnapshotBytes.clear();
  }

  /// 创建文本消息。
  ///
  /// Create text message.
  ///
  /// - [text] 文本 / Text.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createTextMessage({required String text}) {
    return _build(
      contentType: MessageType.text,
      textElem: TextElem(content: text),
    );
  }

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
  }) {
    return _build(
      contentType: MessageType.atText,
      atTextElem: AtTextElem(
        text: text,
        atUserList: atUserIDList,
        atUsersInfo: atUserInfoList,
        quoteMessage: quoteMessage,
      ),
    );
  }

  /// 创建图片消息。
  ///
  /// Create image message.
  ///
  /// - [imagePath] 图片路径 / Image path.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createImageMessage({required String imagePath}) {
    return _build(
      contentType: MessageType.picture,
      pictureElem: PictureElem(sourcePath: imagePath),
    );
  }

  /// 创建语音消息。
  ///
  /// Create voice audio message.
  ///
  /// - [soundPath] 语音路径 / Voice audio path.
  /// - [duration] 时长 / Duration.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createSoundMessage({required String soundPath, required int duration}) {
    final String ext = soundPath.split('.').last.toLowerCase();
    final String? soundType = ext.isNotEmpty ? 'audio/$ext' : null;
    return _build(
      contentType: MessageType.voice,
      soundElem: SoundElem(soundPath: soundPath, duration: duration, soundType: soundType),
    );
  }

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
  }) {
    return _build(
      contentType: MessageType.video,
      videoElem: VideoElem(
        videoPath: videoPath,
        videoType: videoType,
        duration: duration,
        snapshotPath: snapshotPath,
      ),
    );
  }

  /// 创建文件消息。
  ///
  /// Create file message.
  ///
  /// - [filePath] 文件路径 / File path.
  /// - [fileName] 文件名称 / File name.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createFileMessage({required String filePath, required String fileName}) {
    return _build(
      contentType: MessageType.file,
      fileElem: FileElem(filePath: filePath, fileName: fileName),
    );
  }

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
  }) {
    return _build(
      contentType: MessageType.merger,
      mergeElem: MergeElem(title: title, abstractList: summaryList, multiMessage: messageList),
    );
  }

  /// 创建转发消息。
  ///
  /// Create forward message.
  ///
  /// - [message] 消息 / Message.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createForwardMessage({required Message message}) {
    final String uid = _userIDProvider();
    return message.copyWith(
      clientMsgID: OpenImUtils.generateClientMsgID(uid),
      createTime: DateTime.now().millisecondsSinceEpoch,
      sendTime: 0,
      status: MessageStatus.sending,
      sendID: uid,
    );
  }

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
  }) {
    return _build(
      contentType: MessageType.location,
      locationElem: LocationElem(
        description: description,
        longitude: longitude,
        latitude: latitude,
      ),
    );
  }

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
  }) {
    return _build(
      contentType: MessageType.custom,
      customElem: CustomElem(data: data, extension: extension, description: description),
    );
  }

  /// 创建通话信令消息。
  ///
  /// Create call signaling message.
  ///
  /// - [elem] 元素 / Element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createCallSignalMessage({required CallSignalElem elem}) {
    return _build(contentType: MessageType.callSignal, callSignalElem: elem);
  }

  /// 创建红包消息。
  ///
  /// Create red packet message.
  ///
  /// - [elem] 元素 / Element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createRedPacketMessage({required RedPacketElem elem}) {
    return _build(contentType: MessageType.redPacket, redPacketElem: elem);
  }

  /// 创建引用消息。
  ///
  /// Create quote message.
  ///
  /// - [text] 文本 / Text.
  /// - [quoteMsg] 引用消息 / Quote message.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createQuoteMessage({required String text, required Message quoteMsg}) {
    return _build(
      contentType: MessageType.quote,
      quoteElem: QuoteElem(text: text, quoteMessage: quoteMsg),
    );
  }

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
  }) {
    return _build(
      contentType: MessageType.card,
      cardElem: CardElem(userID: userID, nickname: nickname, faceURL: faceURL, ex: ex),
    );
  }

  /// 创建头像消息。
  ///
  /// Create avatar message.
  ///
  /// - [index] 索引 / Index.
  /// - [data] 数据 / Data.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createFaceMessage({int index = -1, String? data}) {
    return _build(
      contentType: MessageType.customFace,
      faceElem: FaceElem(index: index, data: data ?? ''),
    );
  }

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
  }) {
    return _build(
      contentType: MessageType.advancedText,
      advancedTextElem: AdvancedTextElem(
        text: text,
        messageEntityList: list
            .map<MessageEntity>(
              (RichMessageInfo e) => MessageEntity(
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
  }) {
    final List<MessageEntity> entities = list
        .map<MessageEntity>(
          (RichMessageInfo e) => MessageEntity(
            type: e.type,
            offset: e.offset,
            length: e.length,
            url: e.url,
            ex: e.info,
          ),
        )
        .toList();
    return _build(
      contentType: MessageType.quote,
      quoteElem: QuoteElem(text: text, quoteMessage: quoteMsg),
      advancedTextElem: AdvancedTextElem(text: text, messageEntityList: entities),
    );
  }

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
  }) {
    return _build(
      contentType: MessageType.picture,
      pictureElem: PictureElem(
        sourcePath: sourcePath,
        sourcePicture: sourcePicture,
        bigPicture: bigPicture,
        snapshotPicture: snapshotPicture,
      ),
    );
  }

  /// 创建语音消息ByURL 地址。
  ///
  /// Create voice audio message by URL.
  ///
  /// - [soundElem] 语音元素 / Voice audio element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createSoundMessageByURL({required SoundElem soundElem}) {
    return _build(contentType: MessageType.voice, soundElem: soundElem);
  }

  /// 创建视频消息ByURL 地址。
  ///
  /// Create video message by URL.
  ///
  /// - [videoElem] 视频元素 / Video element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createVideoMessageByURL({required VideoElem videoElem}) {
    return _build(contentType: MessageType.video, videoElem: videoElem);
  }

  /// 创建文件消息ByURL 地址。
  ///
  /// Create file message by URL.
  ///
  /// - [fileElem] 文件元素 / File element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createFileMessageByURL({required FileElem fileElem}) {
    return _build(contentType: MessageType.file, fileElem: fileElem);
  }

  /// 创建图片消息从全量路径。
  ///
  /// Create image message from full path.
  ///
  /// - [imagePath] 图片路径 / Image path.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
  Future<Message> createImageMessageFromFullPath({required String imagePath}) async {
    final int fileSize = await fileExists(imagePath) ? await fileLength(imagePath) : 0;
    final String ext = imagePath.split('.').last.toLowerCase();
    int width = 0;
    int height = 0;
    try {
      final ImageDimensions? dims = await SdkComputeExecutor.decodeImageDimensionsFromFile(
        imagePath,
      );
      if (dims != null) {
        width = dims.width;
        height = dims.height;
      }
    } on Object catch (error, stackTrace) {
      _logger.warning('Failed to decode image dimensions from file', error, stackTrace);
    }
    return _build(
      contentType: MessageType.picture,
      pictureElem: PictureElem(
        sourcePath: imagePath,
        sourcePicture: PictureInfo(
          width: width,
          height: height,
          type: 'image/$ext',
          size: fileSize,
        ),
      ),
    );
  }

  /// 创建语音消息从全量路径。
  ///
  /// Create voice audio message from full path.
  ///
  /// - [soundPath] 语音路径 / Voice audio path.
  /// - [duration] 时长 / Duration.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createSoundMessageFromFullPath({required String soundPath, required int duration}) {
    final int fileSize = fileExistsSync(soundPath) ? fileLengthSync(soundPath) : 0;
    final String ext = soundPath.split('.').last.toLowerCase();
    final String? soundType = ext.isNotEmpty ? 'audio/$ext' : null;
    return _build(
      contentType: MessageType.voice,
      soundElem: SoundElem(
        soundPath: soundPath,
        duration: duration,
        dataSize: fileSize,
        soundType: soundType,
      ),
    );
  }

  /// 创建视频消息从全量路径。
  ///
  /// Create video message from full path.
  ///
  /// - [videoPath] 视频路径 / Video path.
  /// - [videoType] 视频类型 / Video type.
  /// - [duration] 时长 / Duration.
  /// - [snapshotPath] 缩略图路径 / Snapshot path.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
  Future<Message> createVideoMessageFromFullPath({
    required String videoPath,
    required String videoType,
    required int duration,
    required String snapshotPath,
  }) async {
    final int videoSize = await fileExists(videoPath) ? await fileLength(videoPath) : 0;
    int snapWidth = 0;
    int snapHeight = 0;
    int snapSize = 0;
    if (snapshotPath.isNotEmpty && await fileExists(snapshotPath)) {
      snapSize = await fileLength(snapshotPath);
      try {
        final ImageDimensions? dims = await SdkComputeExecutor.decodeImageDimensionsFromFile(
          snapshotPath,
        );
        if (dims != null) {
          snapWidth = dims.width;
          snapHeight = dims.height;
        }
      } on Object catch (error, stackTrace) {
        _logger.warning('Failed to decode video snapshot dimensions', error, stackTrace);
      }
    }
    return _build(
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
  }

  /// 创建文件消息从全量路径。
  ///
  /// Create file message from full path.
  ///
  /// - [filePath] 文件路径 / File path.
  /// - [fileName] 文件名称 / File name.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createFileMessageFromFullPath({required String filePath, required String fileName}) {
    final int fileSize = fileExistsSync(filePath) ? fileLengthSync(filePath) : 0;
    return _build(
      contentType: MessageType.file,
      fileElem: FileElem(filePath: filePath, fileName: fileName, fileSize: fileSize),
    );
  }

  /// 创建图片消息按文件。
  ///
  /// Create image message by file.
  ///
  /// - [bytes] 字节数据 / Bytes.
  /// - [fileName] 文件名称 / File name.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
  Future<Message> createImageMessageByFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final String ext = fileName.split('.').last.toLowerCase();
    int width = 0;
    int height = 0;
    try {
      final ImageDimensions? dims = await SdkComputeExecutor.decodeImageDimensions(bytes);
      if (dims != null) {
        width = dims.width;
        height = dims.height;
      }
    } on Object catch (error, stackTrace) {
      _logger.warning('Failed to decode image dimensions from bytes', error, stackTrace);
    }
    final Message msg = _build(
      contentType: MessageType.picture,
      pictureElem: PictureElem(
        sourcePath: fileName,
        sourcePicture: PictureInfo(
          width: width,
          height: height,
          type: 'image/$ext',
          size: bytes.length,
        ),
      ),
    );
    pendingUploadBytes[msg.clientMsgID!] = bytes;
    return msg;
  }

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
  }) async {
    final String ext = fileName.split('.').last.toLowerCase();
    int snapWidth = 0;
    int snapHeight = 0;
    int snapSize = 0;
    if (snapshotBytes != null) {
      snapSize = snapshotBytes.length;
      try {
        final ImageDimensions? dims = await SdkComputeExecutor.decodeImageDimensions(snapshotBytes);
        if (dims != null) {
          snapWidth = dims.width;
          snapHeight = dims.height;
        }
      } catch (_) {}
    }
    final Message msg = _build(
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
    pendingUploadBytes[msg.clientMsgID!] = bytes;
    if (snapshotBytes != null) {
      pendingSnapshotBytes[msg.clientMsgID!] = snapshotBytes;
    }
    return msg;
  }

  /// 创建文件消息按文件。
  ///
  /// Create file message by file.
  ///
  /// - [bytes] 字节数据 / Bytes.
  /// - [fileName] 文件名称 / File name.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  Message createFileMessageByFile({required Uint8List bytes, required String fileName}) {
    final Message msg = _build(
      contentType: MessageType.file,
      fileElem: FileElem(filePath: fileName, fileName: fileName, fileSize: bytes.length),
    );
    pendingUploadBytes[msg.clientMsgID!] = bytes;
    return msg;
  }

  Message _build({
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
    CallSignalElem? callSignalElem,
    RedPacketElem? redPacketElem,
    RedPacketGrabNotifyElem? redPacketGrabNotifyElem,
  }) {
    final String uid = _userIDProvider();
    return Message(
      clientMsgID: OpenImUtils.generateClientMsgID(uid),
      createTime: DateTime.now().millisecondsSinceEpoch,
      sendTime: 0,
      sendID: uid,
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
      callSignalElem: callSignalElem,
      redPacketElem: redPacketElem,
      redPacketGrabNotifyElem: redPacketGrabNotifyElem,
    );
  }
}
