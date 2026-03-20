// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
  userID: json['userID'] as String,
  nickname: json['nickname'] as String?,
  faceURL: json['faceURL'] as String?,
  ex: json['ex'] as String?,
  createTime: (json['createTime'] as num?)?.toInt(),
  remark: json['remark'] as String?,
  globalRecvMsgOpt: $enumDecodeNullable(
    _$ReceiveMessageOptEnumMap,
    json['globalRecvMsgOpt'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  appMangerLevel: (json['appMangerLevel'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
  'userID': instance.userID,
  'nickname': instance.nickname,
  'faceURL': instance.faceURL,
  'ex': instance.ex,
  'createTime': instance.createTime,
  'remark': instance.remark,
  'globalRecvMsgOpt': _$ReceiveMessageOptEnumMap[instance.globalRecvMsgOpt],
  'appMangerLevel': instance.appMangerLevel,
};

const _$ReceiveMessageOptEnumMap = {
  ReceiveMessageOpt.receive: 0,
  ReceiveMessageOpt.notReceive: 1,
  ReceiveMessageOpt.notNotify: 2,
};

PublicUserInfo _$PublicUserInfoFromJson(Map<String, dynamic> json) =>
    PublicUserInfo(
      userID: json['userID'] as String?,
      nickname: json['nickname'] as String?,
      faceURL: json['faceURL'] as String?,
      appManagerLevel: (json['appManagerLevel'] as num?)?.toInt(),
      ex: json['ex'] as String?,
    );

Map<String, dynamic> _$PublicUserInfoToJson(PublicUserInfo instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'nickname': instance.nickname,
      'faceURL': instance.faceURL,
      'appManagerLevel': instance.appManagerLevel,
      'ex': instance.ex,
    };

FriendInfo _$FriendInfoFromJson(Map<String, dynamic> json) => FriendInfo(
  ownerUserID: json['ownerUserID'] as String?,
  nickname: json['nickname'] as String?,
  faceURL: json['faceURL'] as String?,
  friendUserID: json['friendUserID'] as String?,
  remark: json['remark'] as String?,
  ex: json['ex'] as String?,
  createTime: (json['createTime'] as num?)?.toInt(),
  addSource: (json['addSource'] as num?)?.toInt(),
  operatorUserID: json['operatorUserID'] as String?,
);

Map<String, dynamic> _$FriendInfoToJson(FriendInfo instance) =>
    <String, dynamic>{
      'ownerUserID': instance.ownerUserID,
      'nickname': instance.nickname,
      'faceURL': instance.faceURL,
      'friendUserID': instance.friendUserID,
      'remark': instance.remark,
      'ex': instance.ex,
      'createTime': instance.createTime,
      'addSource': instance.addSource,
      'operatorUserID': instance.operatorUserID,
    };

BlacklistInfo _$BlacklistInfoFromJson(Map<String, dynamic> json) =>
    BlacklistInfo(
      nickname: json['nickname'] as String?,
      ownerUserID: json['ownerUserID'] as String?,
      blockUserID: json['blockUserID'] as String?,
      faceURL: json['faceURL'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      createTime: (json['createTime'] as num?)?.toInt(),
      addSource: (json['addSource'] as num?)?.toInt(),
      operatorUserID: json['operatorUserID'] as String?,
      ex: json['ex'] as String?,
    );

Map<String, dynamic> _$BlacklistInfoToJson(BlacklistInfo instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'ownerUserID': instance.ownerUserID,
      'blockUserID': instance.blockUserID,
      'faceURL': instance.faceURL,
      'gender': instance.gender,
      'createTime': instance.createTime,
      'addSource': instance.addSource,
      'operatorUserID': instance.operatorUserID,
      'ex': instance.ex,
    };

FriendshipInfo _$FriendshipInfoFromJson(Map<String, dynamic> json) =>
    FriendshipInfo(
      userID: json['userID'] as String?,
      result: (json['result'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FriendshipInfoToJson(FriendshipInfo instance) =>
    <String, dynamic>{'userID': instance.userID, 'result': instance.result};

FriendApplicationInfo _$FriendApplicationInfoFromJson(
  Map<String, dynamic> json,
) => FriendApplicationInfo(
  fromUserID: json['fromUserID'] as String?,
  fromNickname: json['fromNickname'] as String?,
  fromFaceURL: json['fromFaceURL'] as String?,
  toUserID: json['toUserID'] as String?,
  toNickname: json['toNickname'] as String?,
  toFaceURL: json['toFaceURL'] as String?,
  handleResult: (json['handleResult'] as num?)?.toInt(),
  reqMsg: json['reqMsg'] as String?,
  createTime: (json['createTime'] as num?)?.toInt(),
  handlerUserID: json['handlerUserID'] as String?,
  handleMsg: json['handleMsg'] as String?,
  handleTime: (json['handleTime'] as num?)?.toInt(),
  ex: json['ex'] as String?,
);

Map<String, dynamic> _$FriendApplicationInfoToJson(
  FriendApplicationInfo instance,
) => <String, dynamic>{
  'fromUserID': instance.fromUserID,
  'fromNickname': instance.fromNickname,
  'fromFaceURL': instance.fromFaceURL,
  'toUserID': instance.toUserID,
  'toNickname': instance.toNickname,
  'toFaceURL': instance.toFaceURL,
  'handleResult': instance.handleResult,
  'reqMsg': instance.reqMsg,
  'createTime': instance.createTime,
  'handlerUserID': instance.handlerUserID,
  'handleMsg': instance.handleMsg,
  'handleTime': instance.handleTime,
  'ex': instance.ex,
};

UserStatusInfo _$UserStatusInfoFromJson(Map<String, dynamic> json) =>
    UserStatusInfo(
      userID: json['userID'] as String?,
      status: (json['status'] as num?)?.toInt(),
      platformIDs: (json['platformIDs'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$UserStatusInfoToJson(UserStatusInfo instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'status': instance.status,
      'platformIDs': instance.platformIDs,
    };

GetFriendApplicationListAsRecipientReq
_$GetFriendApplicationListAsRecipientReqFromJson(Map<String, dynamic> json) =>
    GetFriendApplicationListAsRecipientReq(
      handleResults:
          (json['handleResults'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      offset: (json['offset'] as num).toInt(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$GetFriendApplicationListAsRecipientReqToJson(
  GetFriendApplicationListAsRecipientReq instance,
) => <String, dynamic>{
  'handleResults': instance.handleResults,
  'offset': instance.offset,
  'count': instance.count,
};

GetFriendApplicationListAsApplicantReq
_$GetFriendApplicationListAsApplicantReqFromJson(Map<String, dynamic> json) =>
    GetFriendApplicationListAsApplicantReq(
      offset: (json['offset'] as num).toInt(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$GetFriendApplicationListAsApplicantReqToJson(
  GetFriendApplicationListAsApplicantReq instance,
) => <String, dynamic>{'offset': instance.offset, 'count': instance.count};
