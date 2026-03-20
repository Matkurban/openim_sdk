// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_full_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFullInfo _$FullUserInfoFromJson(Map<String, dynamic> json) => UserFullInfo(
  userID: json['userID'] as String,
  password: json['password'] as String? ?? '',
  account: json['account'] as String?,
  phoneNumber: json['phoneNumber'] as String? ?? '',
  areaCode: json['areaCode'] as String? ?? '',
  nickname: json['nickname'] as String? ?? '',
  faceURL: json['faceURL'] as String? ?? '',
  gender: json['gender'] as int? ?? -1,
  level: json['level'] as int? ?? 0,
  birth: json['birth'] as int?,
  email: json['email'] as String? ?? '',
  allowAddFriend: json['allowAddFriend'] as int? ?? 0,
  allowBeep: json['allowBeep'] as int? ?? 0,
  allowVibration: json['allowVibration'] as int? ?? 0,
  globalRecvMsgOpt: json['globalRecvMsgOpt'] as int? ?? 0,
  registerType: json['registerType'] as int? ?? 0,
);

Map<String, dynamic> _$FullUserInfoToJson(UserFullInfo instance) => <String, dynamic>{
  'userID': instance.userID,
  'password': instance.password,
  'account': instance.account,
  'phoneNumber': instance.phoneNumber,
  'areaCode': instance.areaCode,
  'nickname': instance.nickname,
  'faceURL': instance.faceURL,
  'gender': instance.gender,
  'level': instance.level,
  'birth': instance.birth,
  'email': instance.email,
  'allowAddFriend': instance.allowAddFriend,
  'allowBeep': instance.allowBeep,
  'allowVibration': instance.allowVibration,
  'globalRecvMsgOpt': instance.globalRecvMsgOpt,
  'registerType': instance.registerType,
};
