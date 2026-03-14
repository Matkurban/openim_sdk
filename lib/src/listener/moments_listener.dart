import 'package:openim_sdk/src/models/moment_info.dart';
import 'package:openim_sdk/src/models/moment_comment.dart';
import 'package:openim_sdk/src/models/moment_like.dart';

/// 朋友圈监听器
class OnMomentsListener {
  /// 新动态发布
  void Function(MomentInfo moment)? onMomentPublished;

  /// 动态被删除
  void Function(String momentID)? onMomentDeleted;

  /// 收到新点赞
  void Function(MomentLikeWithUser like)? onMomentLiked;

  /// 点赞被取消
  void Function(String momentID, String userID)? onMomentUnliked;

  /// 收到新评论
  void Function(MomentCommentWithUser comment)? onMomentCommented;

  /// 评论被删除
  void Function(String commentID)? onMomentCommentDeleted;

  OnMomentsListener({
    this.onMomentPublished,
    this.onMomentDeleted,
    this.onMomentLiked,
    this.onMomentUnliked,
    this.onMomentCommented,
    this.onMomentCommentDeleted,
  });

  void momentPublished(MomentInfo moment) {
    onMomentPublished?.call(moment);
  }

  void momentDeleted(String momentID) {
    onMomentDeleted?.call(momentID);
  }

  void momentLiked(MomentLikeWithUser like) {
    onMomentLiked?.call(like);
  }

  void momentUnliked(String momentID, String userID) {
    onMomentUnliked?.call(momentID, userID);
  }

  void momentCommented(MomentCommentWithUser comment) {
    onMomentCommented?.call(comment);
  }

  void momentCommentDeleted(String commentID) {
    onMomentCommentDeleted?.call(commentID);
  }
}
