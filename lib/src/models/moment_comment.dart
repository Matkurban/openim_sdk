import 'moment_user_info.dart';

/// 朋友圈评论记录
class MomentCommentWithUser {
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

  final String commentID;
  final String momentID;
  final String userID;
  final String replyToUserID;
  final String content;
  final int status;
  final String createTime;
  final String updateTime;
  final MomentUserInfo? userInfo;
  final MomentUserInfo? replyToUser;

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

  Map<String, dynamic> toJson() {
    return {
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
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
