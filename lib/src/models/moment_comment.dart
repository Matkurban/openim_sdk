import 'package:equatable/equatable.dart';

import 'moment_user_info.dart';

/// 朋友圈评论记录
///
/// Moment comment with updated fields user.
class MomentCommentWithUser extends Equatable {
  /// 创建 `MomentCommentWithUser` 实例。
  ///
  /// Creates a `MomentCommentWithUser` instance.
  ///
  /// - [commentID] 评论ID / Comment ID.
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - [userID] 用户ID / User ID.
  /// - [replyToUserID] 回复转为用户ID / Reply to user ID.
  /// - [content] 内容 / Content.
  /// - [status] 状态 / Status.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [updateTime] 更新时间戳 / Update timestamp.
  /// - [userInfo] 用户信息 / User info.
  /// - [replyToUser] 回复转为用户 / Reply to user.
  const MomentCommentWithUser({
    required this.commentID,
    required this.momentID,
    required this.userID,
    required this.replyToUserID,
    required this.content,
    required this.status,
    required this.createTime,
    required this.updateTime,
    this.userInfo,
    this.replyToUser,
  });

  /// 评论ID。
  ///
  /// Comment ID.
  final String commentID;

  /// 朋友圈动态ID。
  ///
  /// Moment ID.
  final String momentID;

  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 回复转为用户ID。
  ///
  /// Reply to user ID.
  final String replyToUserID;

  /// 内容。
  ///
  /// Content.
  final String content;

  /// 状态。
  ///
  /// Status.
  final int status;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  final String createTime;

  /// 更新时间戳。
  ///
  /// Update timestamp.
  final String updateTime;

  /// 用户信息。
  ///
  /// User info.
  final MomentUserInfo? userInfo;

  /// 回复转为用户。
  ///
  /// Reply to user.
  final MomentUserInfo? replyToUser;

  /// 从 JSON 字典反序列化实例（`MomentCommentWithUser.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MomentCommentWithUser.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MomentCommentWithUser` 结果 / Resulting `MomentCommentWithUser`.
  factory MomentCommentWithUser.fromJson(Map<String, dynamic> json) {
    return MomentCommentWithUser(
      commentID: json['commentID']?.toString() ?? '',
      momentID: json['momentID']?.toString() ?? '',
      userID: json['userID']?.toString() ?? '',
      replyToUserID: json['replyToUserID']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      status: _toInt(json['status']) ?? 0,
      createTime: json['createTime']?.toString() ?? '',
      updateTime: json['updateTime']?.toString() ?? '',
      userInfo: json['userInfo'] is Map<String, dynamic>
          ? MomentUserInfo.fromJson(json['userInfo'] as Map<String, dynamic>)
          : null,
      replyToUser: json['replyToUser'] is Map<String, dynamic>
          ? MomentUserInfo.fromJson(json['replyToUser'] as Map<String, dynamic>)
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
      'commentID': commentID,
      'momentID': momentID,
      'userID': userID,
      'replyToUserID': replyToUserID,
      'content': content,
      'status': status,
      'createTime': createTime,
      'updateTime': updateTime,
      if (userInfo != null) 'userInfo': userInfo!.toJson(),
      if (replyToUser != null) 'replyToUser': replyToUser!.toJson(),
    };
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    commentID,
    momentID,
    userID,
    replyToUserID,
    content,
    status,
    createTime,
    updateTime,
    userInfo,
    replyToUser,
  ];
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
