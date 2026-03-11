// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupInfo _$GroupInfoFromJson(Map<String, dynamic> json) => GroupInfo(
  groupID: json['groupID'] as String,
  groupName: json['groupName'] as String?,
  notification: json['notification'] as String?,
  introduction: json['introduction'] as String?,
  faceURL: json['faceURL'] as String?,
  ownerUserID: json['ownerUserID'] as String?,
  createTime: (json['createTime'] as num?)?.toInt(),
  memberCount: (json['memberCount'] as num?)?.toInt(),
  status: $enumDecodeNullable(
    _$GroupStatusEnumMap,
    json['status'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  creatorUserID: json['creatorUserID'] as String?,
  groupType: $enumDecodeNullable(
    _$GroupTypeEnumMap,
    json['groupType'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  ex: json['ex'] as String?,
  needVerification: $enumDecodeNullable(
    _$GroupVerificationEnumMap,
    json['needVerification'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  lookMemberInfo: (json['lookMemberInfo'] as num?)?.toInt(),
  applyMemberFriend: (json['applyMemberFriend'] as num?)?.toInt(),
  notificationUpdateTime: (json['notificationUpdateTime'] as num?)?.toInt(),
  notificationUserID: json['notificationUserID'] as String?,
);

Map<String, dynamic> _$GroupInfoToJson(GroupInfo instance) => <String, dynamic>{
  'groupID': instance.groupID,
  'groupName': instance.groupName,
  'notification': instance.notification,
  'introduction': instance.introduction,
  'faceURL': instance.faceURL,
  'ownerUserID': instance.ownerUserID,
  'createTime': instance.createTime,
  'memberCount': instance.memberCount,
  'status': _$GroupStatusEnumMap[instance.status],
  'creatorUserID': instance.creatorUserID,
  'groupType': _$GroupTypeEnumMap[instance.groupType],
  'ex': instance.ex,
  'needVerification': _$GroupVerificationEnumMap[instance.needVerification],
  'lookMemberInfo': instance.lookMemberInfo,
  'applyMemberFriend': instance.applyMemberFriend,
  'notificationUpdateTime': instance.notificationUpdateTime,
  'notificationUserID': instance.notificationUserID,
};

const _$GroupStatusEnumMap = {
  GroupStatus.normal: 0,
  GroupStatus.banned: 1,
  GroupStatus.dismissed: 2,
  GroupStatus.muted: 3,
};

const _$GroupTypeEnumMap = {GroupType.general: 0, GroupType.work: 2};

const _$GroupVerificationEnumMap = {
  GroupVerification.applyNeedVerificationInviteDirectly: 0,
  GroupVerification.allNeedVerification: 1,
  GroupVerification.directly: 2,
};

GroupMembersInfo _$GroupMembersInfoFromJson(Map<String, dynamic> json) =>
    GroupMembersInfo(
      groupID: json['groupID'] as String?,
      userID: json['userID'] as String?,
      nickname: json['nickname'] as String?,
      faceURL: json['faceURL'] as String?,
      roleLevel: $enumDecodeNullable(
        _$GroupRoleLevelEnumMap,
        json['roleLevel'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      joinTime: (json['joinTime'] as num?)?.toInt(),
      joinSource: $enumDecodeNullable(
        _$JoinSourceEnumMap,
        json['joinSource'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      operatorUserID: json['operatorUserID'] as String?,
      ex: json['ex'] as String?,
      muteEndTime: (json['muteEndTime'] as num?)?.toInt(),
      appManagerLevel: (json['appManagerLevel'] as num?)?.toInt(),
      inviterUserID: json['inviterUserID'] as String?,
    );

Map<String, dynamic> _$GroupMembersInfoToJson(GroupMembersInfo instance) =>
    <String, dynamic>{
      'groupID': instance.groupID,
      'userID': instance.userID,
      'nickname': instance.nickname,
      'faceURL': instance.faceURL,
      'roleLevel': _$GroupRoleLevelEnumMap[instance.roleLevel],
      'joinTime': instance.joinTime,
      'joinSource': _$JoinSourceEnumMap[instance.joinSource],
      'operatorUserID': instance.operatorUserID,
      'ex': instance.ex,
      'muteEndTime': instance.muteEndTime,
      'appManagerLevel': instance.appManagerLevel,
      'inviterUserID': instance.inviterUserID,
    };

const _$GroupRoleLevelEnumMap = {
  GroupRoleLevel.member: 20,
  GroupRoleLevel.admin: 60,
  GroupRoleLevel.owner: 100,
};

const _$JoinSourceEnumMap = {
  JoinSource.invited: 2,
  JoinSource.search: 3,
  JoinSource.qrCode: 4,
};

GroupMemberRole _$GroupMemberRoleFromJson(Map<String, dynamic> json) =>
    GroupMemberRole(
      userID: json['userID'] as String?,
      roleLevel: $enumDecodeNullable(
        _$GroupRoleLevelEnumMap,
        json['roleLevel'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
    );

Map<String, dynamic> _$GroupMemberRoleToJson(GroupMemberRole instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'roleLevel': _$GroupRoleLevelEnumMap[instance.roleLevel],
    };

GroupApplicationInfo _$GroupApplicationInfoFromJson(
  Map<String, dynamic> json,
) => GroupApplicationInfo(
  groupID: json['groupID'] as String?,
  groupName: json['groupName'] as String?,
  notification: json['notification'] as String?,
  introduction: json['introduction'] as String?,
  groupFaceURL: json['groupFaceURL'] as String?,
  createTime: (json['createTime'] as num?)?.toInt(),
  status: $enumDecodeNullable(
    _$GroupStatusEnumMap,
    json['status'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  creatorUserID: json['creatorUserID'] as String?,
  groupType: $enumDecodeNullable(
    _$GroupTypeEnumMap,
    json['groupType'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  ownerUserID: json['ownerUserID'] as String?,
  memberCount: (json['memberCount'] as num?)?.toInt(),
  userID: json['userID'] as String?,
  nickname: json['nickname'] as String?,
  userFaceURL: json['userFaceURL'] as String?,
  gender: (json['gender'] as num?)?.toInt(),
  handleResult: (json['handleResult'] as num?)?.toInt(),
  reqMsg: json['reqMsg'] as String?,
  handledMsg: json['handledMsg'] as String?,
  reqTime: (json['reqTime'] as num?)?.toInt(),
  handleUserID: json['handleUserID'] as String?,
  handledTime: (json['handledTime'] as num?)?.toInt(),
  ex: json['ex'] as String?,
  joinSource: $enumDecodeNullable(
    _$JoinSourceEnumMap,
    json['joinSource'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  inviterUserID: json['inviterUserID'] as String?,
);

Map<String, dynamic> _$GroupApplicationInfoToJson(
  GroupApplicationInfo instance,
) => <String, dynamic>{
  'groupID': instance.groupID,
  'groupName': instance.groupName,
  'notification': instance.notification,
  'introduction': instance.introduction,
  'groupFaceURL': instance.groupFaceURL,
  'createTime': instance.createTime,
  'status': _$GroupStatusEnumMap[instance.status],
  'creatorUserID': instance.creatorUserID,
  'groupType': _$GroupTypeEnumMap[instance.groupType],
  'ownerUserID': instance.ownerUserID,
  'memberCount': instance.memberCount,
  'userID': instance.userID,
  'nickname': instance.nickname,
  'userFaceURL': instance.userFaceURL,
  'gender': instance.gender,
  'handleResult': instance.handleResult,
  'reqMsg': instance.reqMsg,
  'handledMsg': instance.handledMsg,
  'reqTime': instance.reqTime,
  'handleUserID': instance.handleUserID,
  'handledTime': instance.handledTime,
  'ex': instance.ex,
  'joinSource': _$JoinSourceEnumMap[instance.joinSource],
  'inviterUserID': instance.inviterUserID,
};

GroupInviteResult _$GroupInviteResultFromJson(Map<String, dynamic> json) =>
    GroupInviteResult(
      userID: json['userID'] as String?,
      result: (json['result'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GroupInviteResultToJson(GroupInviteResult instance) =>
    <String, dynamic>{'userID': instance.userID, 'result': instance.result};

GetGroupApplicationListAsRecipientReq
_$GetGroupApplicationListAsRecipientReqFromJson(Map<String, dynamic> json) =>
    GetGroupApplicationListAsRecipientReq(
      groupIDs:
          (json['groupIDs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      handleResults:
          (json['handleResults'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      offset: (json['offset'] as num).toInt(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$GetGroupApplicationListAsRecipientReqToJson(
  GetGroupApplicationListAsRecipientReq instance,
) => <String, dynamic>{
  'groupIDs': instance.groupIDs,
  'handleResults': instance.handleResults,
  'offset': instance.offset,
  'count': instance.count,
};

GetGroupApplicationListAsApplicantReq
_$GetGroupApplicationListAsApplicantReqFromJson(Map<String, dynamic> json) =>
    GetGroupApplicationListAsApplicantReq(
      groupIDs:
          (json['groupIDs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      handleResults:
          (json['handleResults'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 40,
    );

Map<String, dynamic> _$GetGroupApplicationListAsApplicantReqToJson(
  GetGroupApplicationListAsApplicantReq instance,
) => <String, dynamic>{
  'groupIDs': instance.groupIDs,
  'handleResults': instance.handleResults,
  'offset': instance.offset,
  'count': instance.count,
};

GetGroupApplicationUnhandledCountReq
_$GetGroupApplicationUnhandledCountReqFromJson(Map<String, dynamic> json) =>
    GetGroupApplicationUnhandledCountReq(
      time: (json['time'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GetGroupApplicationUnhandledCountReqToJson(
  GetGroupApplicationUnhandledCountReq instance,
) => <String, dynamic>{'time': instance.time};
