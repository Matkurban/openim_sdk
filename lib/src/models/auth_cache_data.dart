import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'auth_cache_data.g.dart';

///鉴权信息数据对象
@JsonSerializable()
class AuthCacheData {
  final String userID;

  final String imToken;

  final String? chatToken;

  AuthCacheData({required this.userID, required this.imToken, this.chatToken});

  factory AuthCacheData.fromJson(Map<String, dynamic> json) => _$AuthCacheDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthCacheDataToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
