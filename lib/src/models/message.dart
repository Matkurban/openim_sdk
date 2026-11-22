import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'message.g.dart';
part 'message/media_elems.dart';
part 'message/rich_elems.dart';
part 'message/message_meta.dart';

/// 消息。
///
/// Message
@JsonSerializable()
class Message extends Equatable {
  /// 客户端消息ID。
  ///
  /// Message ID, a unique identifier.
  final String? clientMsgID;

  /// 服务端消息ID。
  ///
  /// Server-generated ID.
  final String? serverMsgID;

  /// 创建时间戳。
  ///
  /// Creation time.
  final int? createTime;

  /// 发送时间戳。
  ///
  /// Sending time.
  final int? sendTime;

  /// 会话类型。
  ///
  /// Conversation type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? sessionType;

  /// 发送ID。
  ///
  /// Sender's ID.
  final String? sendID;

  /// 接收ID。
  ///
  /// Receiver's ID.
  final String? recvID;

  /// 消息从。
  ///
  /// Source.
  final int? msgFrom;

  /// 内容类型。
  ///
  /// Message type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final MessageType? contentType;

  /// 发送端平台 ID。
  ///
  /// Platform.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final IMPlatform? senderPlatformID;

  /// 发送器昵称。
  ///
  /// Sender's nickname.
  final String? senderNickname;

  /// 发送器头像URL 地址。
  ///
  /// Sender's avatar.
  final String? senderFaceUrl;

  /// 群组ID。
  ///
  /// Group ID.
  final String? groupID;

  /// 本地扩展字段。
  ///
  /// Message localEx.
  final String? localEx;

  /// 序列号。
  ///
  /// Message sequence number.
  final int? seq;

  /// 是否读取。
  ///
  /// Whether it's read.
  final bool? isRead;

  /// 是否包含读取时间戳。
  ///
  /// Read time.
  final int? hasReadTime;

  /// 状态。
  ///
  /// Message sending status.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final MessageStatus? status;

  /// 是否React。
  ///
  /// Is it a reaction.
  final bool? isReact;

  /// 是否ExternalExtensions。
  ///
  /// Is it an external extension.
  final bool? isExternalExtensions;

  /// 离线推送。
  ///
  /// Offline display content.
  final OfflinePushInfo? offlinePush;

  /// 附加信息。
  ///
  /// Additional information.
  final String? attachedInfo;

  /// 扩展字段。
  ///
  /// Extended information.
  final String? ex;

  /// 扩展字段映射。
  ///
  /// Custom extended information.
  final Map<String, dynamic> exMap;

  /// 图片元素。
  ///
  /// Image.
  final PictureElem? pictureElem;

  /// 语音元素。
  ///
  /// Voice.
  final SoundElem? soundElem;

  /// 视频元素。
  ///
  /// Video.
  final VideoElem? videoElem;

  /// 文件元素。
  ///
  /// File.
  final FileElem? fileElem;

  /// @提及文本元素。
  ///
  /// @ Information.
  final AtTextElem? atTextElem;

  /// 地理位置元素。
  ///
  /// Location.
  final LocationElem? locationElem;

  /// 自定义元素。
  ///
  /// Custom.
  final CustomElem? customElem;

  /// 引用元素。
  ///
  /// Quote.
  final QuoteElem? quoteElem;

  /// 合并元素。
  ///
  /// Merge.
  final MergeElem? mergeElem;

  /// 通知元素。
  ///
  /// Notification.
  final NotificationElem? notificationElem;

  /// 头像元素。
  ///
  /// Custom emoji.
  final FaceElem? faceElem;

  /// 附加信息元素。
  ///
  /// Additional information.
  final AttachedInfoElem? attachedInfoElem;

  /// 文本元素。
  ///
  /// Text content.
  final TextElem? textElem;

  /// 名片元素。
  ///
  /// Business card.
  final CardElem? cardElem;

  /// 高级文本元素。
  ///
  /// Advanced text.
  final AdvancedTextElem? advancedTextElem;

  /// 正在输入元素。
  ///
  /// Typing.
  final TypingElem? typingElem;

  /// 通话信令 (contentType=124).
  final CallSignalElem? callSignalElem;

  /// 红包 (contentType=125).
  final RedPacketElem? redPacketElem;

  /// 红包领取提示 (contentType=126).
  final RedPacketGrabNotifyElem? redPacketGrabNotifyElem;

  /// 创建 `Message` 实例。
  ///
  /// Creates a `Message` instance.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - [serverMsgID] 服务端消息ID / Server message ID.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [sendTime] 发送时间戳 / Send timestamp.
  /// - [sessionType] 会话类型 / Session type.
  /// - [sendID] 发送ID / Send ID.
  /// - [recvID] 接收ID / Receive ID.
  /// - [msgFrom] 消息从 / Message from.
  /// - [contentType] 内容类型 / Content type.
  /// - [senderPlatformID] 发送端平台 ID / Sender platform ID.
  /// - [senderNickname] 发送器昵称 / Sender nickname.
  /// - [senderFaceUrl] 发送器头像URL 地址 / Sender avatar URL.
  /// - [groupID] 群组ID / Group ID.
  /// - [localEx] 本地扩展字段 / Local extension.
  /// - [seq] 序列号 / Sequence number.
  /// - [isRead] 是否读取 / Whether read.
  /// - [hasReadTime] 是否包含读取时间戳 / Whether has read timestamp.
  /// - [status] 状态 / Status.
  /// - [isReact] 是否React / Whether react.
  /// - [isExternalExtensions] 是否ExternalExtensions / Whether external extensions.
  /// - [offlinePush] 离线推送 / Offline push.
  /// - [attachedInfo] 附加信息 / Attached info.
  /// - [ex] 扩展字段 / Extension.
  /// - [exMap] 扩展字段映射 / Extension map.
  /// - [pictureElem] 图片元素 / Picture element.
  /// - [soundElem] 语音元素 / Voice audio element.
  /// - [videoElem] 视频元素 / Video element.
  /// - [fileElem] 文件元素 / File element.
  /// - [atTextElem] @提及文本元素 / @-mention text element.
  /// - [locationElem] 地理位置元素 / Location element.
  /// - [customElem] 自定义元素 / Custom element.
  /// - [quoteElem] 引用元素 / Quote element.
  /// - [mergeElem] 合并元素 / Merge element.
  /// - [notificationElem] 通知元素 / Notification element.
  /// - [faceElem] 头像元素 / Avatar element.
  /// - [attachedInfoElem] 附加信息元素 / Attached info element.
  /// - [textElem] 文本元素 / Text element.
  /// - [cardElem] 名片元素 / Contact card element.
  /// - [advancedTextElem] 高级文本元素 / Advanced text element.
  /// - [typingElem] 正在输入元素 / Typing element.
  /// - [callSignalElem] 通话信令元素 / Call signaling element.
  /// - [redPacketElem] 红包元素 / Red packet element.
  /// - [redPacketGrabNotifyElem] 红包领取Notify元素 / Red packet grab notify element.
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

  /// 从 JSON 字典反序列化实例（`Message.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`Message.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `Message` 结果 / Resulting `Message`.
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  /// 是否为单聊。
  ///
  /// Single chat message
  bool get isSingleChat => sessionType == ConversationType.single;

  /// 是否为群聊。
  ///
  /// Group chat message
  bool get isGroupChat => sessionType == ConversationType.superGroup;

  /// 是否为通知会话。
  ///
  /// Whether notification chat.
  bool get isNotificationChat => sessionType == ConversationType.notification;

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - [serverMsgID] 服务端消息ID / Server message ID.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [sendTime] 发送时间戳 / Send timestamp.
  /// - [sessionType] 会话类型 / Session type.
  /// - [sendID] 发送ID / Send ID.
  /// - [recvID] 接收ID / Receive ID.
  /// - [msgFrom] 消息从 / Message from.
  /// - [contentType] 内容类型 / Content type.
  /// - [senderPlatformID] 发送端平台 ID / Sender platform ID.
  /// - [senderNickname] 发送器昵称 / Sender nickname.
  /// - [senderFaceUrl] 发送器头像URL 地址 / Sender avatar URL.
  /// - [groupID] 群组ID / Group ID.
  /// - [localEx] 本地扩展字段 / Local extension.
  /// - [seq] 序列号 / Sequence number.
  /// - [isRead] 是否读取 / Whether read.
  /// - [hasReadTime] 是否包含读取时间戳 / Whether has read timestamp.
  /// - [status] 状态 / Status.
  /// - [isReact] 是否React / Whether react.
  /// - [isExternalExtensions] 是否ExternalExtensions / Whether external extensions.
  /// - [offlinePush] 离线推送 / Offline push.
  /// - [attachedInfo] 附加信息 / Attached info.
  /// - [ex] 扩展字段 / Extension.
  /// - [exMap] 扩展字段映射 / Extension map.
  /// - [pictureElem] 图片元素 / Picture element.
  /// - [soundElem] 语音元素 / Voice audio element.
  /// - [videoElem] 视频元素 / Video element.
  /// - [fileElem] 文件元素 / File element.
  /// - [atTextElem] @提及文本元素 / @-mention text element.
  /// - [locationElem] 地理位置元素 / Location element.
  /// - [customElem] 自定义元素 / Custom element.
  /// - [quoteElem] 引用元素 / Quote element.
  /// - [mergeElem] 合并元素 / Merge element.
  /// - [notificationElem] 通知元素 / Notification element.
  /// - [faceElem] 头像元素 / Avatar element.
  /// - [attachedInfoElem] 附加信息元素 / Attached info element.
  /// - [textElem] 文本元素 / Text element.
  /// - [cardElem] 名片元素 / Contact card element.
  /// - [advancedTextElem] 高级文本元素 / Advanced text element.
  /// - [typingElem] 正在输入元素 / Typing element.
  /// - [callSignalElem] 通话信令元素 / Call signaling element.
  /// - [redPacketElem] 红包元素 / Red packet element.
  /// - [redPacketGrabNotifyElem] 红包领取Notify元素 / Red packet grab notify element.
  /// - Returns: `Message` 结果 / Resulting `Message`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
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
