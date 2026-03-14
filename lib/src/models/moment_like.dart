import 'moment_user_info.dart';

/// 朋友圈点赞记录
class MomentLikeWithUser {
  const MomentLikeWithUser({
    required this.momentID,
    required this.userID,
    required this.createTime,
    this.userInfo,
  });

  final String momentID;
  final String userID;
  final String createTime;
  final MomentUserInfo? userInfo;

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

  Map<String, dynamic> toJson() {
    return {
      'momentID': momentID,
      'userID': userID,
      'createTime': createTime,
      if (userInfo != null) 'userInfo': userInfo!.toJson(),
    };
  }
}
