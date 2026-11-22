import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'auth_cache_data.g.dart';

///鉴权信息数据对象
///
/// Authentication cache data.
@JsonSerializable()
class AuthCacheData extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// IM令牌。
  ///
  /// IM token.
  final String imToken;

  /// chat令牌。
  ///
  /// Chat token.
  final String? chatToken;

  /// 创建 `AuthCacheData` 实例。
  ///
  /// Creates a `AuthCacheData` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [imToken] IM令牌 / IM token.
  /// - [chatToken] chat令牌 / Chat token.
  const AuthCacheData({required this.userID, required this.imToken, this.chatToken});

  /// 从 JSON 字典反序列化实例（`AuthCacheData.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`AuthCacheData.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `AuthCacheData` 结果 / Resulting `AuthCacheData`.
  factory AuthCacheData.fromJson(Map<String, dynamic> json) => _$AuthCacheDataFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$AuthCacheDataToJson(this);

  /// 返回对象的可读字符串表示。
  ///
  /// Returns a human-readable string representation.
  ///
  /// - Returns: 字符串结果 / String result.
  @override
  String toString() {
    return jsonEncode(toJson());
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[userID, imToken, chatToken];
}
