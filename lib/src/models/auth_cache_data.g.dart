// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_cache_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthCacheData _$AuthCacheDataFromJson(Map<String, dynamic> json) => AuthCacheData(
  userID: json['userID'] as String,
  imToken: json['imToken'] as String,
  chatToken: json['chatToken'] as String,
);

Map<String, dynamic> _$AuthCacheDataToJson(AuthCacheData instance) => <String, dynamic>{
  'userID': instance.userID,
  'imToken': instance.imToken,
  'chatToken': instance.chatToken,
};
