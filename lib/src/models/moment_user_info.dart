import 'package:equatable/equatable.dart';

/// 朋友圈交互中的用户信息
///
/// Moment user info.
class MomentUserInfo extends Equatable {
  /// 创建 `MomentUserInfo` 实例。
  ///
  /// Creates a `MomentUserInfo` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  const MomentUserInfo({required this.userID, required this.nickname, required this.faceURL});

  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 昵称。
  ///
  /// Nickname.
  final String nickname;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String faceURL;

  /// 从 JSON 字典反序列化实例（`MomentUserInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MomentUserInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MomentUserInfo` 结果 / Resulting `MomentUserInfo`.
  factory MomentUserInfo.fromJson(Map<String, dynamic> json) {
    return MomentUserInfo(
      userID: json['userID']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      faceURL: json['faceURL']?.toString() ?? '',
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'userID': userID, 'nickname': nickname, 'faceURL': faceURL};
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[userID, nickname, faceURL];
}
