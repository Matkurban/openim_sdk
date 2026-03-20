// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_group_member_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetGroupMemberInfo _$SetGroupMemberInfoFromJson(Map<String, dynamic> json) =>
    SetGroupMemberInfo(
      groupID: json['groupID'] as String,
      userID: json['userID'] as String,
      roleLevel: (json['roleLevel'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
      faceURL: json['faceURL'] as String?,
      ex: json['ex'] as String?,
    );

Map<String, dynamic> _$SetGroupMemberInfoToJson(SetGroupMemberInfo instance) =>
    <String, dynamic>{
      'groupID': instance.groupID,
      'userID': instance.userID,
      'roleLevel': instance.roleLevel,
      'nickname': instance.nickname,
      'faceURL': instance.faceURL,
      'ex': instance.ex,
    };
