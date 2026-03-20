// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFriendsReq _$UpdateFriendsReqFromJson(Map<String, dynamic> json) =>
    UpdateFriendsReq(
      ownerUserID: json['ownerUserID'] as String?,
      friendUserIDs: (json['friendUserIDs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isPinned: json['isPinned'] as bool?,
      remark: json['remark'] as String?,
      ex: json['ex'] as String?,
    );

Map<String, dynamic> _$UpdateFriendsReqToJson(UpdateFriendsReq instance) =>
    <String, dynamic>{
      'ownerUserID': instance.ownerUserID,
      'friendUserIDs': instance.friendUserIDs,
      'isPinned': instance.isPinned,
      'remark': instance.remark,
      'ex': instance.ex,
    };

ConversationReq _$ConversationReqFromJson(Map<String, dynamic> json) =>
    ConversationReq(
      userID: json['userID'] as String?,
      groupID: json['groupID'] as String?,
      recvMsgOpt: (json['recvMsgOpt'] as num?)?.toInt(),
      isPinned: json['isPinned'] as bool?,
      isPrivateChat: json['isPrivateChat'] as bool?,
      ex: json['ex'] as String?,
      burnDuration: (json['burnDuration'] as num?)?.toInt(),
      isMsgDestruct: json['isMsgDestruct'] as bool?,
      msgDestructTime: (json['msgDestructTime'] as num?)?.toInt(),
      groupAtType: (json['groupAtType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConversationReqToJson(ConversationReq instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'groupID': instance.groupID,
      'recvMsgOpt': instance.recvMsgOpt,
      'isPinned': instance.isPinned,
      'isPrivateChat': instance.isPrivateChat,
      'ex': instance.ex,
      'burnDuration': instance.burnDuration,
      'isMsgDestruct': instance.isMsgDestruct,
      'msgDestructTime': instance.msgDestructTime,
      'groupAtType': instance.groupAtType,
    };
