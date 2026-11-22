import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'message.g.dart';
part 'message/media_elems.dart';
part 'message/rich_elems.dart';
part 'message/message_meta.dart';

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

  /// 通话信令 (contentType=124).
  final CallSignalElem? callSignalElem;

  /// 红包 (contentType=125).
  final RedPacketElem? redPacketElem;

  /// 红包领取提示 (contentType=126).
  final RedPacketGrabNotifyElem? redPacketGrabNotifyElem;

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
    this.exMap = const <String, dynamic>{},
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
    this.callSignalElem,
    this.redPacketElem,
    this.redPacketGrabNotifyElem,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  /// Single chat message
  bool get isSingleChat => sessionType == ConversationType.single;

  /// Group chat message
  bool get isGroupChat => sessionType == ConversationType.superGroup;

  bool get isNotificationChat => sessionType == ConversationType.notification;

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
    CallSignalElem? callSignalElem,
    RedPacketElem? redPacketElem,
    RedPacketGrabNotifyElem? redPacketGrabNotifyElem,
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
      callSignalElem: callSignalElem ?? this.callSignalElem,
      redPacketElem: redPacketElem ?? this.redPacketElem,
      redPacketGrabNotifyElem: redPacketGrabNotifyElem ?? this.redPacketGrabNotifyElem,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    clientMsgID,
    serverMsgID,
    createTime,
    sendTime,
    sessionType,
    sendID,
    recvID,
    msgFrom,
    contentType,
    senderPlatformID,
    senderNickname,
    senderFaceUrl,
    groupID,
    localEx,
    seq,
    isRead,
    hasReadTime,
    status,
    isReact,
    isExternalExtensions,
    offlinePush,
    attachedInfo,
    ex,
    exMap,
    pictureElem,
    soundElem,
    videoElem,
    fileElem,
    atTextElem,
    locationElem,
    customElem,
    quoteElem,
    mergeElem,
    notificationElem,
    faceElem,
    attachedInfoElem,
    textElem,
    cardElem,
    advancedTextElem,
    typingElem,
    callSignalElem,
    redPacketElem,
    redPacketGrabNotifyElem,
  ];
}
