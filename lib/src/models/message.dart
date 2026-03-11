import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'message.g.dart';

/// Message
@JsonSerializable()
class Message extends Equatable {
  /// Message ID, a unique identifier.
  final String? clientMsgID;

  /// Server-generated ID.
  final String? serverMsgID;

  /// Creation time.
  final int? createTime;

  /// Sending time.
  final int? sendTime;

  /// Conversation type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? sessionType;

  /// Sender's ID.
  final String? sendID;

  /// Receiver's ID.
  final String? recvID;

  /// Source.
  final int? msgFrom;

  /// Message type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final MessageType? contentType;

  /// Platform.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final IMPlatform? senderPlatformID;

  /// Sender's nickname.
  final String? senderNickname;

  /// Sender's avatar.
  final String? senderFaceUrl;

  /// Group ID.
  final String? groupID;

  /// Message localEx.
  final String? localEx;

  /// Message sequence number.
  final int? seq;

  /// Whether it's read.
  final bool? isRead;

  /// Read time.
  final int? hasReadTime;

  /// Message sending status.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final MessageStatus? status;

  /// Is it a reaction.
  final bool? isReact;

  /// Is it an external extension.
  final bool? isExternalExtensions;

  /// Offline display content.
  final OfflinePushInfo? offlinePush;

  /// Additional information.
  final String? attachedInfo;

  /// Extended information.
  final String? ex;

  /// Custom extended information.
  final Map<String, dynamic> exMap;

  /// Image.
  final PictureElem? pictureElem;

  /// Voice.
  final SoundElem? soundElem;

  /// Video.
  final VideoElem? videoElem;

  /// File.
  final FileElem? fileElem;

  /// @ Information.
  final AtTextElem? atTextElem;

  /// Location.
  final LocationElem? locationElem;

  /// Custom.
  final CustomElem? customElem;

  /// Quote.
  final QuoteElem? quoteElem;

  /// Merge.
  final MergeElem? mergeElem;

  /// Notification.
  final NotificationElem? notificationElem;

  /// Custom emoji.
  final FaceElem? faceElem;

  /// Additional information.
  final AttachedInfoElem? attachedInfoElem;

  /// Text content.
  final TextElem? textElem;

  /// Business card.
  final CardElem? cardElem;

  /// Advanced text.
  final AdvancedTextElem? advancedTextElem;

  /// Typing.
  final TypingElem? typingElem;

  const Message({
    this.clientMsgID,
    this.serverMsgID,
    this.createTime,
    this.sendTime,
    this.sessionType,
    this.sendID,
    this.recvID,
    this.msgFrom,
    this.contentType,
    this.senderPlatformID,
    this.senderNickname,
    this.senderFaceUrl,
    this.groupID,
    this.localEx,
    this.seq,
    this.isRead,
    this.hasReadTime,
    this.status,
    this.isReact,
    this.isExternalExtensions,
    this.offlinePush,
    this.attachedInfo,
    this.ex,
    this.exMap = const {},
    this.pictureElem,
    this.soundElem,
    this.videoElem,
    this.fileElem,
    this.atTextElem,
    this.locationElem,
    this.customElem,
    this.quoteElem,
    this.mergeElem,
    this.notificationElem,
    this.faceElem,
    this.attachedInfoElem,
    this.textElem,
    this.cardElem,
    this.advancedTextElem,
    this.typingElem,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  /// Single chat message
  bool get isSingleChat => sessionType == ConversationType.single;

  /// Group chat message
  bool get isGroupChat =>
      sessionType == ConversationType.group || sessionType == ConversationType.superGroup;

  Message copyWith({
    String? clientMsgID,
    String? serverMsgID,
    int? createTime,
    int? sendTime,
    ConversationType? sessionType,
    String? sendID,
    String? recvID,
    int? msgFrom,
    MessageType? contentType,
    IMPlatform? senderPlatformID,
    String? senderNickname,
    String? senderFaceUrl,
    String? groupID,
    String? localEx,
    int? seq,
    bool? isRead,
    int? hasReadTime,
    MessageStatus? status,
    bool? isReact,
    bool? isExternalExtensions,
    OfflinePushInfo? offlinePush,
    String? attachedInfo,
    String? ex,
    Map<String, dynamic>? exMap,
    PictureElem? pictureElem,
    SoundElem? soundElem,
    VideoElem? videoElem,
    FileElem? fileElem,
    AtTextElem? atTextElem,
    LocationElem? locationElem,
    CustomElem? customElem,
    QuoteElem? quoteElem,
    MergeElem? mergeElem,
    NotificationElem? notificationElem,
    FaceElem? faceElem,
    AttachedInfoElem? attachedInfoElem,
    TextElem? textElem,
    CardElem? cardElem,
    AdvancedTextElem? advancedTextElem,
    TypingElem? typingElem,
  }) {
    return Message(
      clientMsgID: clientMsgID ?? this.clientMsgID,
      serverMsgID: serverMsgID ?? this.serverMsgID,
      createTime: createTime ?? this.createTime,
      sendTime: sendTime ?? this.sendTime,
      sessionType: sessionType ?? this.sessionType,
      sendID: sendID ?? this.sendID,
      recvID: recvID ?? this.recvID,
      msgFrom: msgFrom ?? this.msgFrom,
      contentType: contentType ?? this.contentType,
      senderPlatformID: senderPlatformID ?? this.senderPlatformID,
      senderNickname: senderNickname ?? this.senderNickname,
      senderFaceUrl: senderFaceUrl ?? this.senderFaceUrl,
      groupID: groupID ?? this.groupID,
      localEx: localEx ?? this.localEx,
      seq: seq ?? this.seq,
      isRead: isRead ?? this.isRead,
      hasReadTime: hasReadTime ?? this.hasReadTime,
      status: status ?? this.status,
      isReact: isReact ?? this.isReact,
      isExternalExtensions: isExternalExtensions ?? this.isExternalExtensions,
      offlinePush: offlinePush ?? this.offlinePush,
      attachedInfo: attachedInfo ?? this.attachedInfo,
      ex: ex ?? this.ex,
      exMap: exMap ?? this.exMap,
      pictureElem: pictureElem ?? this.pictureElem,
      soundElem: soundElem ?? this.soundElem,
      videoElem: videoElem ?? this.videoElem,
      fileElem: fileElem ?? this.fileElem,
      atTextElem: atTextElem ?? this.atTextElem,
      locationElem: locationElem ?? this.locationElem,
      customElem: customElem ?? this.customElem,
      quoteElem: quoteElem ?? this.quoteElem,
      mergeElem: mergeElem ?? this.mergeElem,
      notificationElem: notificationElem ?? this.notificationElem,
      faceElem: faceElem ?? this.faceElem,
      attachedInfoElem: attachedInfoElem ?? this.attachedInfoElem,
      textElem: textElem ?? this.textElem,
      cardElem: cardElem ?? this.cardElem,
      advancedTextElem: advancedTextElem ?? this.advancedTextElem,
      typingElem: typingElem ?? this.typingElem,
    );
  }

  @override
  List<Object?> get props => [clientMsgID];
}

/// Image message content
@JsonSerializable()
class PictureElem extends Equatable {
  final String? sourcePath;
  final PictureInfo? sourcePicture;
  final PictureInfo? bigPicture;
  final PictureInfo? snapshotPicture;

  const PictureElem({this.sourcePath, this.sourcePicture, this.bigPicture, this.snapshotPicture});

  factory PictureElem.fromJson(Map<String, dynamic> json) => _$PictureElemFromJson(json);

  Map<String, dynamic> toJson() => _$PictureElemToJson(this);

  PictureElem copyWith({
    String? sourcePath,
    PictureInfo? sourcePicture,
    PictureInfo? bigPicture,
    PictureInfo? snapshotPicture,
  }) {
    return PictureElem(
      sourcePath: sourcePath ?? this.sourcePath,
      sourcePicture: sourcePicture ?? this.sourcePicture,
      bigPicture: bigPicture ?? this.bigPicture,
      snapshotPicture: snapshotPicture ?? this.snapshotPicture,
    );
  }

  @override
  List<Object?> get props => [sourcePath, sourcePicture, bigPicture, snapshotPicture];
}

/// Image information
@JsonSerializable()
class PictureInfo extends Equatable {
  final String? uuid;
  final String? type;
  final int? size;
  final int? width;
  final int? height;
  final String? url;

  const PictureInfo({this.uuid, this.type, this.size, this.width, this.height, this.url});

  factory PictureInfo.fromJson(Map<String, dynamic> json) => _$PictureInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PictureInfoToJson(this);

  PictureInfo copyWith({
    String? uuid,
    String? type,
    int? size,
    int? width,
    int? height,
    String? url,
  }) {
    return PictureInfo(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      size: size ?? this.size,
      width: width ?? this.width,
      height: height ?? this.height,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [uuid, type, size, width, height, url];
}

/// Voice message content
@JsonSerializable()
class SoundElem extends Equatable {
  final String? uuid;
  final String? soundPath;
  final String? sourceUrl;
  final int? dataSize;
  final int? duration;

  const SoundElem({this.uuid, this.soundPath, this.sourceUrl, this.dataSize, this.duration});

  factory SoundElem.fromJson(Map<String, dynamic> json) => _$SoundElemFromJson(json);

  Map<String, dynamic> toJson() => _$SoundElemToJson(this);

  SoundElem copyWith({
    String? uuid,
    String? soundPath,
    String? sourceUrl,
    int? dataSize,
    int? duration,
  }) {
    return SoundElem(
      uuid: uuid ?? this.uuid,
      soundPath: soundPath ?? this.soundPath,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      dataSize: dataSize ?? this.dataSize,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [uuid, soundPath, sourceUrl, dataSize, duration];
}

/// Video message content
@JsonSerializable()
class VideoElem extends Equatable {
  final String? videoPath;
  final String? videoUUID;
  final String? videoUrl;
  final String? videoType;
  final int? videoSize;
  final int? duration;
  final String? snapshotPath;
  final String? snapshotUUID;
  final int? snapshotSize;
  final String? snapshotUrl;
  final int? snapshotWidth;
  final int? snapshotHeight;

  const VideoElem({
    this.videoPath,
    this.videoUUID,
    this.videoUrl,
    this.videoType,
    this.videoSize,
    this.duration,
    this.snapshotPath,
    this.snapshotUUID,
    this.snapshotSize,
    this.snapshotUrl,
    this.snapshotWidth,
    this.snapshotHeight,
  });

  factory VideoElem.fromJson(Map<String, dynamic> json) => _$VideoElemFromJson(json);

  Map<String, dynamic> toJson() => _$VideoElemToJson(this);

  VideoElem copyWith({
    String? videoPath,
    String? videoUUID,
    String? videoUrl,
    String? videoType,
    int? videoSize,
    int? duration,
    String? snapshotPath,
    String? snapshotUUID,
    int? snapshotSize,
    String? snapshotUrl,
    int? snapshotWidth,
    int? snapshotHeight,
  }) {
    return VideoElem(
      videoPath: videoPath ?? this.videoPath,
      videoUUID: videoUUID ?? this.videoUUID,
      videoUrl: videoUrl ?? this.videoUrl,
      videoType: videoType ?? this.videoType,
      videoSize: videoSize ?? this.videoSize,
      duration: duration ?? this.duration,
      snapshotPath: snapshotPath ?? this.snapshotPath,
      snapshotUUID: snapshotUUID ?? this.snapshotUUID,
      snapshotSize: snapshotSize ?? this.snapshotSize,
      snapshotUrl: snapshotUrl ?? this.snapshotUrl,
      snapshotWidth: snapshotWidth ?? this.snapshotWidth,
      snapshotHeight: snapshotHeight ?? this.snapshotHeight,
    );
  }

  @override
  List<Object?> get props => [
    videoPath,
    videoUUID,
    videoUrl,
    videoType,
    videoSize,
    duration,
    snapshotPath,
    snapshotUUID,
    snapshotSize,
    snapshotUrl,
    snapshotWidth,
    snapshotHeight,
  ];
}

/// File message content
@JsonSerializable()
class FileElem extends Equatable {
  final String? filePath;
  final String? uuid;
  final String? sourceUrl;
  final String? fileName;
  final int? fileSize;

  const FileElem({this.filePath, this.uuid, this.sourceUrl, this.fileName, this.fileSize});

  factory FileElem.fromJson(Map<String, dynamic> json) => _$FileElemFromJson(json);

  Map<String, dynamic> toJson() => _$FileElemToJson(this);

  FileElem copyWith({
    String? filePath,
    String? uuid,
    String? sourceUrl,
    String? fileName,
    int? fileSize,
  }) {
    return FileElem(
      filePath: filePath ?? this.filePath,
      uuid: uuid ?? this.uuid,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  @override
  List<Object?> get props => [filePath, uuid, sourceUrl, fileName, fileSize];
}

/// @ Message Content
@JsonSerializable()
class AtTextElem extends Equatable {
  final String? text;
  final List<String>? atUserList;
  final bool? isAtSelf;
  final List<AtUserInfo>? atUsersInfo;
  final Message? quoteMessage;

  const AtTextElem({
    this.text,
    this.atUserList,
    this.isAtSelf,
    this.atUsersInfo,
    this.quoteMessage,
  });

  factory AtTextElem.fromJson(Map<String, dynamic> json) => _$AtTextElemFromJson(json);

  Map<String, dynamic> toJson() => _$AtTextElemToJson(this);

  AtTextElem copyWith({
    String? text,
    List<String>? atUserList,
    bool? isAtSelf,
    List<AtUserInfo>? atUsersInfo,
    Message? quoteMessage,
  }) {
    return AtTextElem(
      text: text ?? this.text,
      atUserList: atUserList ?? this.atUserList,
      isAtSelf: isAtSelf ?? this.isAtSelf,
      atUsersInfo: atUsersInfo ?? this.atUsersInfo,
      quoteMessage: quoteMessage ?? this.quoteMessage,
    );
  }

  @override
  List<Object?> get props => [text, atUserList, isAtSelf, atUsersInfo, quoteMessage];
}

/// Location Message
@JsonSerializable()
class LocationElem extends Equatable {
  final String? description;
  final double? longitude;
  final double? latitude;

  const LocationElem({this.description, this.longitude, this.latitude});

  factory LocationElem.fromJson(Map<String, dynamic> json) => _$LocationElemFromJson(json);

  Map<String, dynamic> toJson() => _$LocationElemToJson(this);

  LocationElem copyWith({String? description, double? longitude, double? latitude}) {
    return LocationElem(
      description: description ?? this.description,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  @override
  List<Object?> get props => [description, longitude, latitude];
}

/// Custom Message
@JsonSerializable()
class CustomElem extends Equatable {
  final String? data;
  final String? extension;
  final String? description;

  const CustomElem({this.data, this.extension, this.description});

  factory CustomElem.fromJson(Map<String, dynamic> json) => _$CustomElemFromJson(json);

  Map<String, dynamic> toJson() => _$CustomElemToJson(this);

  CustomElem copyWith({String? data, String? extension, String? description}) {
    return CustomElem(
      data: data ?? this.data,
      extension: extension ?? this.extension,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [data, extension, description];
}

/// Quoted Message (Reply to a message)
@JsonSerializable()
class QuoteElem extends Equatable {
  final String? text;
  final Message? quoteMessage;

  const QuoteElem({this.text, this.quoteMessage});

  factory QuoteElem.fromJson(Map<String, dynamic> json) => _$QuoteElemFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteElemToJson(this);

  QuoteElem copyWith({String? text, Message? quoteMessage}) {
    return QuoteElem(text: text ?? this.text, quoteMessage: quoteMessage ?? this.quoteMessage);
  }

  @override
  List<Object?> get props => [text, quoteMessage];
}

/// Merged Message Body
@JsonSerializable()
class MergeElem extends Equatable {
  final String? title;
  final List<String>? abstractList;
  final List<Message>? multiMessage;

  const MergeElem({this.title, this.abstractList, this.multiMessage});

  factory MergeElem.fromJson(Map<String, dynamic> json) => _$MergeElemFromJson(json);

  Map<String, dynamic> toJson() => _$MergeElemToJson(this);

  MergeElem copyWith({String? title, List<String>? abstractList, List<Message>? multiMessage}) {
    return MergeElem(
      title: title ?? this.title,
      abstractList: abstractList ?? this.abstractList,
      multiMessage: multiMessage ?? this.multiMessage,
    );
  }

  @override
  List<Object?> get props => [title, abstractList, multiMessage];
}

/// Notification
@JsonSerializable()
class NotificationElem extends Equatable {
  final String? detail;
  final String? defaultTips;

  const NotificationElem({this.detail, this.defaultTips});

  factory NotificationElem.fromJson(Map<String, dynamic> json) => _$NotificationElemFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationElemToJson(this);

  NotificationElem copyWith({String? detail, String? defaultTips}) {
    return NotificationElem(
      detail: detail ?? this.detail,
      defaultTips: defaultTips ?? this.defaultTips,
    );
  }

  @override
  List<Object?> get props => [detail, defaultTips];
}

/// Emoticon
@JsonSerializable()
class FaceElem extends Equatable {
  final int? index;
  final String? data;

  const FaceElem({this.index, this.data});

  factory FaceElem.fromJson(Map<String, dynamic> json) => _$FaceElemFromJson(json);

  Map<String, dynamic> toJson() => _$FaceElemToJson(this);

  FaceElem copyWith({int? index, String? data}) {
    return FaceElem(index: index ?? this.index, data: data ?? this.data);
  }

  @override
  List<Object?> get props => [index, data];
}

/// Additional Information
@JsonSerializable()
class AttachedInfoElem extends Equatable {
  final GroupHasReadInfo? groupHasReadInfo;
  final bool? isPrivateChat;
  final int? hasReadTime;
  final int? burnDuration;
  final bool? notSenderNotificationPush;
  final UploadProgress? uploadProgress;

  const AttachedInfoElem({
    this.groupHasReadInfo,
    this.isPrivateChat,
    this.hasReadTime,
    this.burnDuration,
    this.notSenderNotificationPush,
    this.uploadProgress,
  });

  factory AttachedInfoElem.fromJson(Map<String, dynamic> json) => _$AttachedInfoElemFromJson(json);

  Map<String, dynamic> toJson() => _$AttachedInfoElemToJson(this);

  AttachedInfoElem copyWith({
    GroupHasReadInfo? groupHasReadInfo,
    bool? isPrivateChat,
    int? hasReadTime,
    int? burnDuration,
    bool? notSenderNotificationPush,
    UploadProgress? uploadProgress,
  }) {
    return AttachedInfoElem(
      groupHasReadInfo: groupHasReadInfo ?? this.groupHasReadInfo,
      isPrivateChat: isPrivateChat ?? this.isPrivateChat,
      hasReadTime: hasReadTime ?? this.hasReadTime,
      burnDuration: burnDuration ?? this.burnDuration,
      notSenderNotificationPush: notSenderNotificationPush ?? this.notSenderNotificationPush,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  @override
  List<Object?> get props => [
    groupHasReadInfo,
    isPrivateChat,
    hasReadTime,
    burnDuration,
    notSenderNotificationPush,
    uploadProgress,
  ];
}

@JsonSerializable()
class UploadProgress extends Equatable {
  final int? total;
  final int? save;
  final int? current;
  final String? uploadID;

  const UploadProgress({this.total, this.save, this.current, this.uploadID});

  factory UploadProgress.fromJson(Map<String, dynamic> json) => _$UploadProgressFromJson(json);

  Map<String, dynamic> toJson() => _$UploadProgressToJson(this);

  UploadProgress copyWith({int? total, int? save, int? current, String? uploadID}) {
    return UploadProgress(
      total: total ?? this.total,
      save: save ?? this.save,
      current: current ?? this.current,
      uploadID: uploadID ?? this.uploadID,
    );
  }

  @override
  List<Object?> get props => [total, save, current, uploadID];
}

@JsonSerializable()
class TextElem extends Equatable {
  final String? content;

  const TextElem({this.content});

  factory TextElem.fromJson(Map<String, dynamic> json) => _$TextElemFromJson(json);

  Map<String, dynamic> toJson() => _$TextElemToJson(this);

  TextElem copyWith({String? content}) {
    return TextElem(content: content ?? this.content);
  }

  @override
  List<Object?> get props => [content];
}

@JsonSerializable()
class CardElem extends Equatable {
  final String? userID;
  final String? nickname;
  final String? faceURL;
  final String? ex;

  const CardElem({this.userID, this.nickname, this.faceURL, this.ex});

  factory CardElem.fromJson(Map<String, dynamic> json) => _$CardElemFromJson(json);

  Map<String, dynamic> toJson() => _$CardElemToJson(this);

  CardElem copyWith({String? userID, String? nickname, String? faceURL, String? ex}) {
    return CardElem(
      userID: userID ?? this.userID,
      nickname: nickname ?? this.nickname,
      faceURL: faceURL ?? this.faceURL,
      ex: ex ?? this.ex,
    );
  }

  @override
  List<Object?> get props => [userID, nickname, faceURL, ex];
}

@JsonSerializable()
class TypingElem extends Equatable {
  final String? msgTips;

  const TypingElem({this.msgTips});

  factory TypingElem.fromJson(Map<String, dynamic> json) => _$TypingElemFromJson(json);

  Map<String, dynamic> toJson() => _$TypingElemToJson(this);

  TypingElem copyWith({String? msgTips}) {
    return TypingElem(msgTips: msgTips ?? this.msgTips);
  }

  @override
  List<Object?> get props => [msgTips];
}

@JsonSerializable()
class AdvancedTextElem extends Equatable {
  final String? text;
  final List<MessageEntity>? messageEntityList;

  const AdvancedTextElem({this.text, this.messageEntityList});

  factory AdvancedTextElem.fromJson(Map<String, dynamic> json) => _$AdvancedTextElemFromJson(json);

  Map<String, dynamic> toJson() => _$AdvancedTextElemToJson(this);

  AdvancedTextElem copyWith({String? text, List<MessageEntity>? messageEntityList}) {
    return AdvancedTextElem(
      text: text ?? this.text,
      messageEntityList: messageEntityList ?? this.messageEntityList,
    );
  }

  @override
  List<Object?> get props => [text, messageEntityList];
}

@JsonSerializable()
class MessageEntity extends Equatable {
  final String? type;
  final int? offset;
  final int? length;
  final String? url;
  final String? ex;

  const MessageEntity({this.type, this.offset, this.length, this.url, this.ex});

  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);

  MessageEntity copyWith({String? type, int? offset, int? length, String? url, String? ex}) {
    return MessageEntity(
      type: type ?? this.type,
      offset: offset ?? this.offset,
      length: length ?? this.length,
      url: url ?? this.url,
      ex: ex ?? this.ex,
    );
  }

  @override
  List<Object?> get props => [type, offset, length, url, ex];
}

/// Group message read information
@JsonSerializable()
class GroupHasReadInfo extends Equatable {
  final int? hasReadCount;
  final int? unreadCount;

  const GroupHasReadInfo({this.hasReadCount, this.unreadCount});

  factory GroupHasReadInfo.fromJson(Map<String, dynamic> json) => _$GroupHasReadInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupHasReadInfoToJson(this);

  GroupHasReadInfo copyWith({int? hasReadCount, int? unreadCount}) {
    return GroupHasReadInfo(
      hasReadCount: hasReadCount ?? this.hasReadCount,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [hasReadCount, unreadCount];
}

/// Message read receipt information
@JsonSerializable()
class ReadReceiptInfo extends Equatable {
  final String? userID;
  final String? groupID;
  final List<String>? msgIDList;
  final int? readTime;
  final int? msgFrom;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final MessageType? contentType;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? sessionType;

  const ReadReceiptInfo({
    this.userID,
    this.groupID,
    this.msgIDList,
    this.readTime,
    this.msgFrom,
    this.contentType,
    this.sessionType,
  });

  factory ReadReceiptInfo.fromJson(Map<String, dynamic> json) => _$ReadReceiptInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ReadReceiptInfoToJson(this);

  ReadReceiptInfo copyWith({
    String? userID,
    String? groupID,
    List<String>? msgIDList,
    int? readTime,
    int? msgFrom,
    MessageType? contentType,
    ConversationType? sessionType,
  }) {
    return ReadReceiptInfo(
      userID: userID ?? this.userID,
      groupID: groupID ?? this.groupID,
      msgIDList: msgIDList ?? this.msgIDList,
      readTime: readTime ?? this.readTime,
      msgFrom: msgFrom ?? this.msgFrom,
      contentType: contentType ?? this.contentType,
      sessionType: sessionType ?? this.sessionType,
    );
  }

  @override
  List<Object?> get props => [
    userID,
    groupID,
    msgIDList,
    readTime,
    msgFrom,
    contentType,
    sessionType,
  ];
}

/// Offline push information
@JsonSerializable()
class OfflinePushInfo extends Equatable {
  final String? title;
  final String? desc;
  final String? ex;
  final String? iOSPushSound;
  final bool? iOSBadgeCount;

  const OfflinePushInfo({this.title, this.desc, this.ex, this.iOSPushSound, this.iOSBadgeCount});

  factory OfflinePushInfo.fromJson(Map<String, dynamic> json) => _$OfflinePushInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OfflinePushInfoToJson(this);

  OfflinePushInfo copyWith({
    String? title,
    String? desc,
    String? ex,
    String? iOSPushSound,
    bool? iOSBadgeCount,
  }) {
    return OfflinePushInfo(
      title: title ?? this.title,
      desc: desc ?? this.desc,
      ex: ex ?? this.ex,
      iOSPushSound: iOSPushSound ?? this.iOSPushSound,
      iOSBadgeCount: iOSBadgeCount ?? this.iOSBadgeCount,
    );
  }

  @override
  List<Object?> get props => [title, desc, ex, iOSPushSound, iOSBadgeCount];
}

/// @ message user ID and nickname relationship object
@JsonSerializable()
class AtUserInfo extends Equatable {
  final String? atUserID;
  final String? groupNickname;

  const AtUserInfo({this.atUserID, this.groupNickname});

  factory AtUserInfo.fromJson(Map<String, dynamic> json) => _$AtUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AtUserInfoToJson(this);

  AtUserInfo copyWith({String? atUserID, String? groupNickname}) {
    return AtUserInfo(
      atUserID: atUserID ?? this.atUserID,
      groupNickname: groupNickname ?? this.groupNickname,
    );
  }

  @override
  List<Object?> get props => [atUserID, groupNickname];
}

/// Message revocation details
@JsonSerializable()
class RevokedInfo extends Equatable {
  final String? revokerID;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupRoleLevel? revokerRole;

  final String? revokerNickname;
  final String? clientMsgID;
  final int? revokeTime;
  final int? sourceMessageSendTime;
  final String? sourceMessageSendID;
  final String? sourceMessageSenderNickname;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? sessionType;

  const RevokedInfo({
    this.revokerID,
    this.revokerRole,
    this.revokerNickname,
    this.clientMsgID,
    this.revokeTime,
    this.sourceMessageSendTime,
    this.sourceMessageSendID,
    this.sourceMessageSenderNickname,
    this.sessionType,
  });

  factory RevokedInfo.fromJson(Map<String, dynamic> json) => _$RevokedInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RevokedInfoToJson(this);

  RevokedInfo copyWith({
    String? revokerID,
    GroupRoleLevel? revokerRole,
    String? revokerNickname,
    String? clientMsgID,
    int? revokeTime,
    int? sourceMessageSendTime,
    String? sourceMessageSendID,
    String? sourceMessageSenderNickname,
    ConversationType? sessionType,
  }) {
    return RevokedInfo(
      revokerID: revokerID ?? this.revokerID,
      revokerRole: revokerRole ?? this.revokerRole,
      revokerNickname: revokerNickname ?? this.revokerNickname,
      clientMsgID: clientMsgID ?? this.clientMsgID,
      revokeTime: revokeTime ?? this.revokeTime,
      sourceMessageSendTime: sourceMessageSendTime ?? this.sourceMessageSendTime,
      sourceMessageSendID: sourceMessageSendID ?? this.sourceMessageSendID,
      sourceMessageSenderNickname: sourceMessageSenderNickname ?? this.sourceMessageSenderNickname,
      sessionType: sessionType ?? this.sessionType,
    );
  }

  @override
  List<Object?> get props => [
    revokerID,
    revokerRole,
    revokerNickname,
    clientMsgID,
    revokeTime,
    sourceMessageSendTime,
    sourceMessageSendID,
    sourceMessageSenderNickname,
    sessionType,
  ];
}

@JsonSerializable()
class AdvancedMessage extends Equatable {
  final List<Message>? messageList;
  final bool? isEnd;
  final int? errCode;
  final String? errMsg;
  final int? lastMinSeq;

  const AdvancedMessage({this.messageList, this.isEnd, this.errCode, this.errMsg, this.lastMinSeq});

  factory AdvancedMessage.fromJson(Map<String, dynamic> json) => _$AdvancedMessageFromJson(json);

  Map<String, dynamic> toJson() => _$AdvancedMessageToJson(this);

  AdvancedMessage copyWith({
    List<Message>? messageList,
    bool? isEnd,
    int? errCode,
    String? errMsg,
    int? lastMinSeq,
  }) {
    return AdvancedMessage(
      messageList: messageList ?? this.messageList,
      isEnd: isEnd ?? this.isEnd,
      errCode: errCode ?? this.errCode,
      errMsg: errMsg ?? this.errMsg,
      lastMinSeq: lastMinSeq ?? this.lastMinSeq,
    );
  }

  @override
  List<Object?> get props => [messageList, isEnd, errCode, errMsg, lastMinSeq];
}

@JsonSerializable()
class RichMessageInfo extends Equatable {
  final String? type;
  final int? offset;
  final int? length;
  final String? url;
  final String? info;

  const RichMessageInfo({this.type, this.offset, this.length, this.url, this.info});

  factory RichMessageInfo.fromJson(Map<String, dynamic> json) => _$RichMessageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RichMessageInfoToJson(this);

  RichMessageInfo copyWith({String? type, int? offset, int? length, String? url, String? info}) {
    return RichMessageInfo(
      type: type ?? this.type,
      offset: offset ?? this.offset,
      length: length ?? this.length,
      url: url ?? this.url,
      info: info ?? this.info,
    );
  }

  @override
  List<Object?> get props => [type, offset, length, url, info];
}

@JsonSerializable()
class UserExInfo extends Equatable {
  final String? userID;
  final String? ex;

  const UserExInfo({this.userID, this.ex});

  factory UserExInfo.fromJson(Map<String, dynamic> json) => _$UserExInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserExInfoToJson(this);

  UserExInfo copyWith({String? userID, String? ex}) {
    return UserExInfo(userID: userID ?? this.userID, ex: ex ?? this.ex);
  }

  @override
  List<Object?> get props => [userID, ex];
}
