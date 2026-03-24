// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  clientMsgID: json['clientMsgID'] as String?,
  serverMsgID: json['serverMsgID'] as String?,
  createTime: (json['createTime'] as num?)?.toInt(),
  sendTime: (json['sendTime'] as num?)?.toInt(),
  sessionType: $enumDecodeNullable(
    _$ConversationTypeEnumMap,
    json['sessionType'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  sendID: json['sendID'] as String?,
  recvID: json['recvID'] as String?,
  msgFrom: (json['msgFrom'] as num?)?.toInt(),
  contentType: $enumDecodeNullable(
    _$MessageTypeEnumMap,
    json['contentType'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  senderPlatformID: $enumDecodeNullable(
    _$IMPlatformEnumMap,
    json['senderPlatformID'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  senderNickname: json['senderNickname'] as String?,
  senderFaceUrl: json['senderFaceUrl'] as String?,
  groupID: json['groupID'] as String?,
  localEx: json['localEx'] as String?,
  seq: (json['seq'] as num?)?.toInt(),
  isRead: json['isRead'] as bool?,
  hasReadTime: (json['hasReadTime'] as num?)?.toInt(),
  status: $enumDecodeNullable(
    _$MessageStatusEnumMap,
    json['status'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  isReact: json['isReact'] as bool?,
  isExternalExtensions: json['isExternalExtensions'] as bool?,
  offlinePush: json['offlinePush'] == null
      ? null
      : OfflinePushInfo.fromJson(json['offlinePush'] as Map<String, dynamic>),
  attachedInfo: json['attachedInfo'] as String?,
  ex: json['ex'] as String?,
  exMap: json['exMap'] as Map<String, dynamic>? ?? const {},
  pictureElem: json['pictureElem'] == null
      ? null
      : PictureElem.fromJson(json['pictureElem'] as Map<String, dynamic>),
  soundElem: json['soundElem'] == null
      ? null
      : SoundElem.fromJson(json['soundElem'] as Map<String, dynamic>),
  videoElem: json['videoElem'] == null
      ? null
      : VideoElem.fromJson(json['videoElem'] as Map<String, dynamic>),
  fileElem: json['fileElem'] == null
      ? null
      : FileElem.fromJson(json['fileElem'] as Map<String, dynamic>),
  atTextElem: json['atTextElem'] == null
      ? null
      : AtTextElem.fromJson(json['atTextElem'] as Map<String, dynamic>),
  locationElem: json['locationElem'] == null
      ? null
      : LocationElem.fromJson(json['locationElem'] as Map<String, dynamic>),
  customElem: json['customElem'] == null
      ? null
      : CustomElem.fromJson(json['customElem'] as Map<String, dynamic>),
  quoteElem: json['quoteElem'] == null
      ? null
      : QuoteElem.fromJson(json['quoteElem'] as Map<String, dynamic>),
  mergeElem: json['mergeElem'] == null
      ? null
      : MergeElem.fromJson(json['mergeElem'] as Map<String, dynamic>),
  notificationElem: json['notificationElem'] == null
      ? null
      : NotificationElem.fromJson(json['notificationElem'] as Map<String, dynamic>),
  faceElem: json['faceElem'] == null
      ? null
      : FaceElem.fromJson(json['faceElem'] as Map<String, dynamic>),
  attachedInfoElem: json['attachedInfoElem'] == null
      ? null
      : AttachedInfoElem.fromJson(json['attachedInfoElem'] as Map<String, dynamic>),
  textElem: json['textElem'] == null
      ? null
      : TextElem.fromJson(json['textElem'] as Map<String, dynamic>),
  cardElem: json['cardElem'] == null
      ? null
      : CardElem.fromJson(json['cardElem'] as Map<String, dynamic>),
  advancedTextElem: json['advancedTextElem'] == null
      ? null
      : AdvancedTextElem.fromJson(json['advancedTextElem'] as Map<String, dynamic>),
  typingElem: json['typingElem'] == null
      ? null
      : TypingElem.fromJson(json['typingElem'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'clientMsgID': instance.clientMsgID,
  'serverMsgID': instance.serverMsgID,
  'createTime': instance.createTime,
  'sendTime': instance.sendTime,
  'sessionType': _$ConversationTypeEnumMap[instance.sessionType],
  'sendID': instance.sendID,
  'recvID': instance.recvID,
  'msgFrom': instance.msgFrom,
  'contentType': _$MessageTypeEnumMap[instance.contentType],
  'senderPlatformID': _$IMPlatformEnumMap[instance.senderPlatformID],
  'senderNickname': instance.senderNickname,
  'senderFaceUrl': instance.senderFaceUrl,
  'groupID': instance.groupID,
  'localEx': instance.localEx,
  'seq': instance.seq,
  'isRead': instance.isRead,
  'hasReadTime': instance.hasReadTime,
  'status': _$MessageStatusEnumMap[instance.status],
  'isReact': instance.isReact,
  'isExternalExtensions': instance.isExternalExtensions,
  'offlinePush': instance.offlinePush,
  'attachedInfo': instance.attachedInfo,
  'ex': instance.ex,
  'exMap': instance.exMap,
  'pictureElem': instance.pictureElem,
  'soundElem': instance.soundElem,
  'videoElem': instance.videoElem,
  'fileElem': instance.fileElem,
  'atTextElem': instance.atTextElem,
  'locationElem': instance.locationElem,
  'customElem': instance.customElem,
  'quoteElem': instance.quoteElem,
  'mergeElem': instance.mergeElem,
  'notificationElem': instance.notificationElem,
  'faceElem': instance.faceElem,
  'attachedInfoElem': instance.attachedInfoElem,
  'textElem': instance.textElem,
  'cardElem': instance.cardElem,
  'advancedTextElem': instance.advancedTextElem,
  'typingElem': instance.typingElem,
};

const _$ConversationTypeEnumMap = {
  ConversationType.single: 1,
  ConversationType.superGroup: 3,
  ConversationType.notification: 4,
};

const _$MessageTypeEnumMap = {
  MessageType.text: 101,
  MessageType.picture: 102,
  MessageType.voice: 103,
  MessageType.video: 104,
  MessageType.file: 105,
  MessageType.atText: 106,
  MessageType.merger: 107,
  MessageType.card: 108,
  MessageType.location: 109,
  MessageType.custom: 110,
  MessageType.typing: 113,
  MessageType.quote: 114,
  MessageType.customFace: 115,
  MessageType.advancedText: 117,
  MessageType.markdownText: 118,
  MessageType.customMsgNotTriggerConversation: 119,
  MessageType.customMsgOnlineOnly: 120,
  MessageType.notificationBegin: 1000,
  MessageType.friendNotificationBegin: 1200,
  MessageType.friendApplicationApprovedNotification: 1201,
  MessageType.friendApplicationRejectedNotification: 1202,
  MessageType.friendApplicationNotification: 1203,
  MessageType.friendAddedNotification: 1204,
  MessageType.friendDeletedNotification: 1205,
  MessageType.friendRemarkSetNotification: 1206,
  MessageType.blackAddedNotification: 1207,
  MessageType.blackDeletedNotification: 1208,
  MessageType.friendInfoUpdatedNotification: 1209,
  MessageType.friendsInfoUpdateNotification: 1210,
  MessageType.friendNotificationEnd: 1299,
  MessageType.conversationChangeNotification: 1300,
  MessageType.userNotificationBegin: 1301,
  MessageType.userInfoUpdatedNotification: 1303,
  MessageType.userStatusChangeNotification: 1304,
  MessageType.userCommandAddNotification: 1305,
  MessageType.userCommandDeleteNotification: 1306,
  MessageType.userCommandUpdateNotification: 1307,
  MessageType.userNotificationEnd: 1399,
  MessageType.oaNotification: 1400,
  MessageType.groupNotificationBegin: 1500,
  MessageType.groupCreatedNotification: 1501,
  MessageType.groupInfoSetNotification: 1502,
  MessageType.joinGroupApplicationNotification: 1503,
  MessageType.memberQuitNotification: 1504,
  MessageType.groupApplicationAcceptedNotification: 1505,
  MessageType.groupApplicationRejectedNotification: 1506,
  MessageType.groupOwnerTransferredNotification: 1507,
  MessageType.memberKickedNotification: 1508,
  MessageType.memberInvitedNotification: 1509,
  MessageType.memberEnterNotification: 1510,
  MessageType.dismissGroupNotification: 1511,
  MessageType.groupMemberMutedNotification: 1512,
  MessageType.groupMemberCancelMutedNotification: 1513,
  MessageType.groupMutedNotification: 1514,
  MessageType.groupCancelMutedNotification: 1515,
  MessageType.groupMemberInfoSetNotification: 1516,
  MessageType.groupMemberSetToAdminNotification: 1517,
  MessageType.groupMemberSetToOrdinaryUserNotification: 1518,
  MessageType.groupInfoSetAnnouncementNotification: 1519,
  MessageType.groupInfoSetNameNotification: 1520,
  MessageType.groupNotificationEnd: 1599,
  MessageType.conversationPrivateChatNotification: 1701,
  MessageType.clearConversationNotification: 1703,
  MessageType.businessNotification: 2001,
  MessageType.revokeMessageNotification: 2101,
  MessageType.deleteMsgsNotification: 2102,
  MessageType.hasReadReceipt: 2200,
  MessageType.notificationEnd: 5000,
};

const _$IMPlatformEnumMap = {
  IMPlatform.ios: 1,
  IMPlatform.android: 2,
  IMPlatform.windows: 3,
  IMPlatform.xos: 4,
  IMPlatform.web: 5,
  IMPlatform.miniWeb: 6,
  IMPlatform.linux: 7,
  IMPlatform.androidPad: 8,
  IMPlatform.ipad: 9,
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 1,
  MessageStatus.succeeded: 2,
  MessageStatus.failed: 3,
  MessageStatus.deleted: 4,
};

PictureElem _$PictureElemFromJson(Map<String, dynamic> json) => PictureElem(
  sourcePath: json['sourcePath'] as String?,
  sourcePicture: json['sourcePicture'] == null
      ? null
      : PictureInfo.fromJson(json['sourcePicture'] as Map<String, dynamic>),
  bigPicture: json['bigPicture'] == null
      ? null
      : PictureInfo.fromJson(json['bigPicture'] as Map<String, dynamic>),
  snapshotPicture: json['snapshotPicture'] == null
      ? null
      : PictureInfo.fromJson(json['snapshotPicture'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PictureElemToJson(PictureElem instance) => <String, dynamic>{
  'sourcePath': instance.sourcePath,
  'sourcePicture': instance.sourcePicture,
  'bigPicture': instance.bigPicture,
  'snapshotPicture': instance.snapshotPicture,
};

PictureInfo _$PictureInfoFromJson(Map<String, dynamic> json) => PictureInfo(
  uuid: json['uuid'] as String?,
  type: json['type'] as String?,
  size: (json['size'] as num?)?.toInt(),
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  url: json['url'] as String?,
);

Map<String, dynamic> _$PictureInfoToJson(PictureInfo instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'type': instance.type,
  'size': instance.size,
  'width': instance.width,
  'height': instance.height,
  'url': instance.url,
};

SoundElem _$SoundElemFromJson(Map<String, dynamic> json) => SoundElem(
  uuid: json['uuid'] as String?,
  soundPath: json['soundPath'] as String?,
  sourceUrl: json['sourceUrl'] as String?,
  dataSize: (json['dataSize'] as num?)?.toInt(),
  duration: (json['duration'] as num?)?.toInt(),
  soundType: json['soundType'] as String?,
);

Map<String, dynamic> _$SoundElemToJson(SoundElem instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'soundPath': instance.soundPath,
  'sourceUrl': instance.sourceUrl,
  'dataSize': instance.dataSize,
  'duration': instance.duration,
  'soundType': instance.soundType,
};

VideoElem _$VideoElemFromJson(Map<String, dynamic> json) => VideoElem(
  videoPath: json['videoPath'] as String?,
  videoUUID: json['videoUUID'] as String?,
  videoUrl: json['videoUrl'] as String?,
  videoType: json['videoType'] as String?,
  videoSize: (json['videoSize'] as num?)?.toInt(),
  duration: (json['duration'] as num?)?.toInt(),
  snapshotPath: json['snapshotPath'] as String?,
  snapshotUUID: json['snapshotUUID'] as String?,
  snapshotSize: (json['snapshotSize'] as num?)?.toInt(),
  snapshotUrl: json['snapshotUrl'] as String?,
  snapshotWidth: (json['snapshotWidth'] as num?)?.toInt(),
  snapshotHeight: (json['snapshotHeight'] as num?)?.toInt(),
  snapshotType: json['snapshotType'] as String?,
);

Map<String, dynamic> _$VideoElemToJson(VideoElem instance) => <String, dynamic>{
  'videoPath': instance.videoPath,
  'videoUUID': instance.videoUUID,
  'videoUrl': instance.videoUrl,
  'videoType': instance.videoType,
  'videoSize': instance.videoSize,
  'duration': instance.duration,
  'snapshotPath': instance.snapshotPath,
  'snapshotUUID': instance.snapshotUUID,
  'snapshotSize': instance.snapshotSize,
  'snapshotUrl': instance.snapshotUrl,
  'snapshotWidth': instance.snapshotWidth,
  'snapshotHeight': instance.snapshotHeight,
  'snapshotType': instance.snapshotType,
};

FileElem _$FileElemFromJson(Map<String, dynamic> json) => FileElem(
  filePath: json['filePath'] as String?,
  uuid: json['uuid'] as String?,
  sourceUrl: json['sourceUrl'] as String?,
  fileName: json['fileName'] as String?,
  fileSize: (json['fileSize'] as num?)?.toInt(),
  fileType: json['fileType'] as String?,
);

Map<String, dynamic> _$FileElemToJson(FileElem instance) => <String, dynamic>{
  'filePath': instance.filePath,
  'uuid': instance.uuid,
  'sourceUrl': instance.sourceUrl,
  'fileName': instance.fileName,
  'fileSize': instance.fileSize,
  'fileType': instance.fileType,
};

AtTextElem _$AtTextElemFromJson(Map<String, dynamic> json) => AtTextElem(
  text: json['text'] as String?,
  atUserList: (json['atUserList'] as List<dynamic>?)?.map((e) => e as String).toList(),
  isAtSelf: json['isAtSelf'] as bool?,
  atUsersInfo: (json['atUsersInfo'] as List<dynamic>?)
      ?.map((e) => AtUserInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  quoteMessage: json['quoteMessage'] == null
      ? null
      : Message.fromJson(json['quoteMessage'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AtTextElemToJson(AtTextElem instance) => <String, dynamic>{
  'text': instance.text,
  'atUserList': instance.atUserList,
  'isAtSelf': instance.isAtSelf,
  'atUsersInfo': instance.atUsersInfo,
  'quoteMessage': instance.quoteMessage,
};

LocationElem _$LocationElemFromJson(Map<String, dynamic> json) => LocationElem(
  description: json['description'] as String?,
  longitude: (json['longitude'] as num?)?.toDouble(),
  latitude: (json['latitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$LocationElemToJson(LocationElem instance) => <String, dynamic>{
  'description': instance.description,
  'longitude': instance.longitude,
  'latitude': instance.latitude,
};

CustomElem _$CustomElemFromJson(Map<String, dynamic> json) => CustomElem(
  data: json['data'] as String?,
  extension: json['extension'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$CustomElemToJson(CustomElem instance) => <String, dynamic>{
  'data': instance.data,
  'extension': instance.extension,
  'description': instance.description,
};

QuoteElem _$QuoteElemFromJson(Map<String, dynamic> json) => QuoteElem(
  text: json['text'] as String?,
  quoteMessage: json['quoteMessage'] == null
      ? null
      : Message.fromJson(json['quoteMessage'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QuoteElemToJson(QuoteElem instance) => <String, dynamic>{
  'text': instance.text,
  'quoteMessage': instance.quoteMessage,
};

MergeElem _$MergeElemFromJson(Map<String, dynamic> json) => MergeElem(
  title: json['title'] as String?,
  abstractList: (json['abstractList'] as List<dynamic>?)?.map((e) => e as String).toList(),
  multiMessage: (json['multiMessage'] as List<dynamic>?)
      ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MergeElemToJson(MergeElem instance) => <String, dynamic>{
  'title': instance.title,
  'abstractList': instance.abstractList,
  'multiMessage': instance.multiMessage,
};

NotificationElem _$NotificationElemFromJson(Map<String, dynamic> json) => NotificationElem(
  detail: json['detail'] as String?,
  defaultTips: json['defaultTips'] as String?,
);

Map<String, dynamic> _$NotificationElemToJson(NotificationElem instance) => <String, dynamic>{
  'detail': instance.detail,
  'defaultTips': instance.defaultTips,
};

FaceElem _$FaceElemFromJson(Map<String, dynamic> json) =>
    FaceElem(index: (json['index'] as num?)?.toInt(), data: json['data'] as String?);

Map<String, dynamic> _$FaceElemToJson(FaceElem instance) => <String, dynamic>{
  'index': instance.index,
  'data': instance.data,
};

AttachedInfoElem _$AttachedInfoElemFromJson(Map<String, dynamic> json) => AttachedInfoElem(
  groupHasReadInfo: json['groupHasReadInfo'] == null
      ? null
      : GroupHasReadInfo.fromJson(json['groupHasReadInfo'] as Map<String, dynamic>),
  isPrivateChat: json['isPrivateChat'] as bool?,
  hasReadTime: (json['hasReadTime'] as num?)?.toInt(),
  burnDuration: (json['burnDuration'] as num?)?.toInt(),
  notSenderNotificationPush: json['notSenderNotificationPush'] as bool?,
  uploadProgress: json['uploadProgress'] == null
      ? null
      : UploadProgress.fromJson(json['uploadProgress'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AttachedInfoElemToJson(AttachedInfoElem instance) => <String, dynamic>{
  'groupHasReadInfo': instance.groupHasReadInfo,
  'isPrivateChat': instance.isPrivateChat,
  'hasReadTime': instance.hasReadTime,
  'burnDuration': instance.burnDuration,
  'notSenderNotificationPush': instance.notSenderNotificationPush,
  'uploadProgress': instance.uploadProgress,
};

UploadProgress _$UploadProgressFromJson(Map<String, dynamic> json) => UploadProgress(
  total: (json['total'] as num?)?.toInt(),
  save: (json['save'] as num?)?.toInt(),
  current: (json['current'] as num?)?.toInt(),
  uploadID: json['uploadID'] as String?,
);

Map<String, dynamic> _$UploadProgressToJson(UploadProgress instance) => <String, dynamic>{
  'total': instance.total,
  'save': instance.save,
  'current': instance.current,
  'uploadID': instance.uploadID,
};

TextElem _$TextElemFromJson(Map<String, dynamic> json) =>
    TextElem(content: json['content'] as String?);

Map<String, dynamic> _$TextElemToJson(TextElem instance) => <String, dynamic>{
  'content': instance.content,
};

CardElem _$CardElemFromJson(Map<String, dynamic> json) => CardElem(
  userID: json['userID'] as String?,
  nickname: json['nickname'] as String?,
  faceURL: json['faceURL'] as String?,
  ex: json['ex'] as String?,
);

Map<String, dynamic> _$CardElemToJson(CardElem instance) => <String, dynamic>{
  'userID': instance.userID,
  'nickname': instance.nickname,
  'faceURL': instance.faceURL,
  'ex': instance.ex,
};

TypingElem _$TypingElemFromJson(Map<String, dynamic> json) =>
    TypingElem(msgTips: json['msgTips'] as String?);

Map<String, dynamic> _$TypingElemToJson(TypingElem instance) => <String, dynamic>{
  'msgTips': instance.msgTips,
};

AdvancedTextElem _$AdvancedTextElemFromJson(Map<String, dynamic> json) => AdvancedTextElem(
  text: json['text'] as String?,
  messageEntityList: (json['messageEntityList'] as List<dynamic>?)
      ?.map((e) => MessageEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AdvancedTextElemToJson(AdvancedTextElem instance) => <String, dynamic>{
  'text': instance.text,
  'messageEntityList': instance.messageEntityList,
};

MessageEntity _$MessageEntityFromJson(Map<String, dynamic> json) => MessageEntity(
  type: json['type'] as String?,
  offset: (json['offset'] as num?)?.toInt(),
  length: (json['length'] as num?)?.toInt(),
  url: json['url'] as String?,
  ex: json['ex'] as String?,
);

Map<String, dynamic> _$MessageEntityToJson(MessageEntity instance) => <String, dynamic>{
  'type': instance.type,
  'offset': instance.offset,
  'length': instance.length,
  'url': instance.url,
  'ex': instance.ex,
};

GroupHasReadInfo _$GroupHasReadInfoFromJson(Map<String, dynamic> json) => GroupHasReadInfo(
  hasReadCount: (json['hasReadCount'] as num?)?.toInt(),
  unreadCount: (json['unreadCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$GroupHasReadInfoToJson(GroupHasReadInfo instance) => <String, dynamic>{
  'hasReadCount': instance.hasReadCount,
  'unreadCount': instance.unreadCount,
};

ReadReceiptInfo _$ReadReceiptInfoFromJson(Map<String, dynamic> json) => ReadReceiptInfo(
  userID: json['userID'] as String?,
  groupID: json['groupID'] as String?,
  msgIDList: (json['msgIDList'] as List<dynamic>?)?.map((e) => e as String).toList(),
  readTime: (json['readTime'] as num?)?.toInt(),
  msgFrom: (json['msgFrom'] as num?)?.toInt(),
  contentType: $enumDecodeNullable(
    _$MessageTypeEnumMap,
    json['contentType'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  sessionType: $enumDecodeNullable(
    _$ConversationTypeEnumMap,
    json['sessionType'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
);

Map<String, dynamic> _$ReadReceiptInfoToJson(ReadReceiptInfo instance) => <String, dynamic>{
  'userID': instance.userID,
  'groupID': instance.groupID,
  'msgIDList': instance.msgIDList,
  'readTime': instance.readTime,
  'msgFrom': instance.msgFrom,
  'contentType': _$MessageTypeEnumMap[instance.contentType],
  'sessionType': _$ConversationTypeEnumMap[instance.sessionType],
};

OfflinePushInfo _$OfflinePushInfoFromJson(Map<String, dynamic> json) => OfflinePushInfo(
  title: json['title'] as String?,
  desc: json['desc'] as String?,
  ex: json['ex'] as String?,
  iOSPushSound: json['iOSPushSound'] as String?,
  iOSBadgeCount: json['iOSBadgeCount'] as bool?,
);

Map<String, dynamic> _$OfflinePushInfoToJson(OfflinePushInfo instance) => <String, dynamic>{
  'title': instance.title,
  'desc': instance.desc,
  'ex': instance.ex,
  'iOSPushSound': instance.iOSPushSound,
  'iOSBadgeCount': instance.iOSBadgeCount,
};

AtUserInfo _$AtUserInfoFromJson(Map<String, dynamic> json) => AtUserInfo(
  atUserID: json['atUserID'] as String?,
  groupNickname: json['groupNickname'] as String?,
);

Map<String, dynamic> _$AtUserInfoToJson(AtUserInfo instance) => <String, dynamic>{
  'atUserID': instance.atUserID,
  'groupNickname': instance.groupNickname,
};

RevokedInfo _$RevokedInfoFromJson(Map<String, dynamic> json) => RevokedInfo(
  revokerID: json['revokerID'] as String?,
  revokerRole: $enumDecodeNullable(
    _$GroupRoleLevelEnumMap,
    json['revokerRole'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  revokerNickname: json['revokerNickname'] as String?,
  clientMsgID: json['clientMsgID'] as String?,
  revokeTime: (json['revokeTime'] as num?)?.toInt(),
  sourceMessageSendTime: (json['sourceMessageSendTime'] as num?)?.toInt(),
  sourceMessageSendID: json['sourceMessageSendID'] as String?,
  sourceMessageSenderNickname: json['sourceMessageSenderNickname'] as String?,
  sessionType: $enumDecodeNullable(
    _$ConversationTypeEnumMap,
    json['sessionType'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
);

Map<String, dynamic> _$RevokedInfoToJson(RevokedInfo instance) => <String, dynamic>{
  'revokerID': instance.revokerID,
  'revokerRole': _$GroupRoleLevelEnumMap[instance.revokerRole],
  'revokerNickname': instance.revokerNickname,
  'clientMsgID': instance.clientMsgID,
  'revokeTime': instance.revokeTime,
  'sourceMessageSendTime': instance.sourceMessageSendTime,
  'sourceMessageSendID': instance.sourceMessageSendID,
  'sourceMessageSenderNickname': instance.sourceMessageSenderNickname,
  'sessionType': _$ConversationTypeEnumMap[instance.sessionType],
};

const _$GroupRoleLevelEnumMap = {
  GroupRoleLevel.member: 20,
  GroupRoleLevel.admin: 60,
  GroupRoleLevel.owner: 100,
};

AdvancedMessage _$AdvancedMessageFromJson(Map<String, dynamic> json) => AdvancedMessage(
  messageList: (json['messageList'] as List<dynamic>?)
      ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
      .toList(),
  isEnd: json['isEnd'] as bool?,
  errCode: (json['errCode'] as num?)?.toInt(),
  errMsg: json['errMsg'] as String?,
  lastMinSeq: (json['lastMinSeq'] as num?)?.toInt(),
);

Map<String, dynamic> _$AdvancedMessageToJson(AdvancedMessage instance) => <String, dynamic>{
  'messageList': instance.messageList,
  'isEnd': instance.isEnd,
  'errCode': instance.errCode,
  'errMsg': instance.errMsg,
  'lastMinSeq': instance.lastMinSeq,
};

RichMessageInfo _$RichMessageInfoFromJson(Map<String, dynamic> json) => RichMessageInfo(
  type: json['type'] as String?,
  offset: (json['offset'] as num?)?.toInt(),
  length: (json['length'] as num?)?.toInt(),
  url: json['url'] as String?,
  info: json['info'] as String?,
);

Map<String, dynamic> _$RichMessageInfoToJson(RichMessageInfo instance) => <String, dynamic>{
  'type': instance.type,
  'offset': instance.offset,
  'length': instance.length,
  'url': instance.url,
  'info': instance.info,
};

UserExInfo _$UserExInfoFromJson(Map<String, dynamic> json) =>
    UserExInfo(userID: json['userID'] as String?, ex: json['ex'] as String?);

Map<String, dynamic> _$UserExInfoToJson(UserExInfo instance) => <String, dynamic>{
  'userID': instance.userID,
  'ex': instance.ex,
};
