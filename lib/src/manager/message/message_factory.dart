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
  final Map<String, Uint8List> pendingSnapshotBytes = <String, Uint8List>{};

  MessageFactory({required this._userIDProvider});

  void clearPendingBytes() {
    pendingUploadBytes.clear();
    pendingSnapshotBytes.clear();
  }

  Message createTextMessage({required String text}) {
    return _build(
      contentType: MessageType.text,
      textElem: TextElem(content: text),
    );
  }

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

  Message createImageMessage({required String imagePath}) {
    return _build(
      contentType: MessageType.picture,
      pictureElem: PictureElem(sourcePath: imagePath),
    );
  }

  Message createSoundMessage({required String soundPath, required int duration}) {
    final String ext = soundPath.split('.').last.toLowerCase();
    final String? soundType = ext.isNotEmpty ? 'audio/$ext' : null;
    return _build(
      contentType: MessageType.voice,
      soundElem: SoundElem(soundPath: soundPath, duration: duration, soundType: soundType),
    );
  }

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

  Message createFileMessage({required String filePath, required String fileName}) {
    return _build(
      contentType: MessageType.file,
      fileElem: FileElem(filePath: filePath, fileName: fileName),
    );
  }

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

  Message createCallSignalMessage({required CallSignalElem elem}) {
    return _build(contentType: MessageType.callSignal, callSignalElem: elem);
  }

  Message createRedPacketMessage({required RedPacketElem elem}) {
    return _build(contentType: MessageType.redPacket, redPacketElem: elem);
  }

  Message createQuoteMessage({required String text, required Message quoteMsg}) {
    return _build(
      contentType: MessageType.quote,
      quoteElem: QuoteElem(text: text, quoteMessage: quoteMsg),
    );
  }

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

  Message createFaceMessage({int index = -1, String? data}) {
    return _build(
      contentType: MessageType.customFace,
      faceElem: FaceElem(index: index, data: data ?? ''),
    );
  }

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

  Message createSoundMessageByURL({required SoundElem soundElem}) {
    return _build(contentType: MessageType.voice, soundElem: soundElem);
  }

  Message createVideoMessageByURL({required VideoElem videoElem}) {
    return _build(contentType: MessageType.video, videoElem: videoElem);
  }

  Message createFileMessageByURL({required FileElem fileElem}) {
    return _build(contentType: MessageType.file, fileElem: fileElem);
  }

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

  Message createFileMessageFromFullPath({required String filePath, required String fileName}) {
    final int fileSize = fileExistsSync(filePath) ? fileLengthSync(filePath) : 0;
    return _build(
      contentType: MessageType.file,
      fileElem: FileElem(filePath: filePath, fileName: fileName, fileSize: fileSize),
    );
  }

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
