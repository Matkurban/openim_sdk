// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_full_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFullInfo _$UserFullInfoFromJson(Map<String, dynamic> json) => UserFullInfo(
  userID: json['userID'] as String? ?? '',
  password: json['password'] as String? ?? '',
  account: json['account'] as String? ?? '',
  phoneNumber: json['phoneNumber'] as String? ?? '',
  areaCode: json['areaCode'] as String? ?? '',
  nickname: json['nickname'] as String? ?? '',
  faceURL: json['faceURL'] as String? ?? '',
  gender: (json['gender'] as num?)?.toInt() ?? -1,
  level: (json['level'] as num?)?.toInt() ?? 0,
  birth: (json['birth'] as num?)?.toInt() ?? 0,
  email: json['email'] as String? ?? '',
  allowAddFriend: (json['allowAddFriend'] as num?)?.toInt() ?? 0,
  allowBeep: (json['allowBeep'] as num?)?.toInt() ?? 0,
  allowVibration: (json['allowVibration'] as num?)?.toInt() ?? 0,
  globalRecvMsgOpt: (json['globalRecvMsgOpt'] as num?)?.toInt() ?? 0,
  registerType: (json['registerType'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserFullInfoToJson(UserFullInfo instance) =>
    <String, dynamic>{
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
