// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationInfo _$ConversationInfoFromJson(Map<String, dynamic> json) => ConversationInfo(
  conversationID: json['conversationID'] as String,
  conversationType: $enumDecodeNullable(
    _$ConversationTypeEnumMap,
    json['conversationType'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  userID: json['userID'] as String?,
  groupID: json['groupID'] as String?,
  showName: json['showName'] as String?,
  faceURL: json['faceURL'] as String?,
  recvMsgOpt: $enumDecodeNullable(
    _$ReceiveMessageOptEnumMap,
    json['recvMsgOpt'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
  latestMsg: json['latestMsg'] == null
      ? null
      : Message.fromJson(json['latestMsg'] as Map<String, dynamic>),
  latestMsgSendTime: (json['latestMsgSendTime'] as num?)?.toInt(),
  draftText: json['draftText'] as String?,
  draftTextTime: (json['draftTextTime'] as num?)?.toInt(),
  isPinned: json['isPinned'] as bool?,
  isPrivateChat: json['isPrivateChat'] as bool?,
  burnDuration: (json['burnDuration'] as num?)?.toInt(),
  isMsgDestruct: json['isMsgDestruct'] as bool?,
  msgDestructTime: (json['msgDestructTime'] as num?)?.toInt(),
  ex: json['ex'] as String?,
  isNotInGroup: json['isNotInGroup'] as bool?,
  groupAtType: $enumDecodeNullable(
    _$GroupAtTypeEnumMap,
    json['groupAtType'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
);

Map<String, dynamic> _$ConversationInfoToJson(ConversationInfo instance) => <String, dynamic>{
  'conversationID': instance.conversationID,
  'conversationType': _$ConversationTypeEnumMap[instance.conversationType],
  'userID': instance.userID,
  'groupID': instance.groupID,
  'showName': instance.showName,
  'faceURL': instance.faceURL,
  'recvMsgOpt': _$ReceiveMessageOptEnumMap[instance.recvMsgOpt],
  'unreadCount': instance.unreadCount,
  'latestMsg': instance.latestMsg,
  'latestMsgSendTime': instance.latestMsgSendTime,
  'draftText': instance.draftText,
  'draftTextTime': instance.draftTextTime,
  'isPinned': instance.isPinned,
  'isPrivateChat': instance.isPrivateChat,
  'burnDuration': instance.burnDuration,
  'isMsgDestruct': instance.isMsgDestruct,
  'msgDestructTime': instance.msgDestructTime,
  'ex': instance.ex,
  'isNotInGroup': instance.isNotInGroup,
  'groupAtType': _$GroupAtTypeEnumMap[instance.groupAtType],
};

const _$ConversationTypeEnumMap = {
  ConversationType.single: 1,
  ConversationType.group: 2,
  ConversationType.superGroup: 3,
  ConversationType.notification: 4,
};

const _$ReceiveMessageOptEnumMap = {
  ReceiveMessageOpt.receive: 0,
  ReceiveMessageOpt.notReceive: 1,
  ReceiveMessageOpt.notNotify: 2,
};

const _$GroupAtTypeEnumMap = {
  GroupAtType.atNormal: 0,
  GroupAtType.atMe: 1,
  GroupAtType.atAll: 2,
  GroupAtType.atAllAtMe: 3,
  GroupAtType.groupNotification: 4,
};
