import 'package:equatable/equatable.dart';

import 'moment_user_info.dart';

/// 朋友圈点赞记录
///
/// Moment like with updated fields user.
class MomentLikeWithUser extends Equatable {
  /// 创建 `MomentLikeWithUser` 实例。
  ///
  /// Creates a `MomentLikeWithUser` instance.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - [userID] 用户ID / User ID.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [userInfo] 用户信息 / User info.
  const MomentLikeWithUser({
    required this.momentID,
    required this.userID,
    required this.createTime,
    this.userInfo,
  });

  /// 朋友圈动态ID。
  ///
  /// Moment ID.
  final String momentID;

  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  final String createTime;

  /// 用户信息。
  ///
  /// User info.
  final MomentUserInfo? userInfo;

  /// 从 JSON 字典反序列化实例（`MomentLikeWithUser.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MomentLikeWithUser.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MomentLikeWithUser` 结果 / Resulting `MomentLikeWithUser`.
  factory MomentLikeWithUser.fromJson(Map<String, dynamic> json) {
    return MomentLikeWithUser(
      momentID: json['momentID']?.toString() ?? '',
      userID: json['userID']?.toString() ?? '',
      createTime: json['createTime']?.toString() ?? '',
      userInfo: json['userInfo'] is Map<String, dynamic>
          ? MomentUserInfo.fromJson(json['userInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'momentID': momentID,
      'userID': userID,
      'createTime': createTime,
      if (userInfo != null) 'userInfo': userInfo!.toJson(),
    };
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[momentID, userID, createTime, userInfo];
}
