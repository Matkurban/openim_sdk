import 'package:openim_sdk/src/models/moment_comment.dart';
import 'package:openim_sdk/src/models/moment_info.dart';
import 'package:openim_sdk/src/models/moment_like.dart';

/// 朋友圈动态事件监听器。
///
/// Moments social feed event listener.
class OnMomentsListener {
  /// 新动态发布回调 / Callback invoked when a new moment is published.
  void Function(MomentInfo moment)? onMomentPublished;

  /// 动态被删除回调 / Callback invoked when a moment is deleted.
  void Function(String momentID)? onMomentDeleted;

  /// 收到新点赞回调 / Callback invoked when a moment receives a like.
  void Function(MomentLikeWithUser like)? onMomentLiked;

  /// 点赞被取消回调 / Callback invoked when a like is removed from a moment.
  void Function(String momentID, String userID)? onMomentUnliked;

  /// 收到新评论回调 / Callback invoked when a moment receives a new comment.
  void Function(MomentCommentWithUser comment)? onMomentCommented;

  /// 评论被删除回调 / Callback invoked when a comment is deleted.
  void Function(String commentID)? onMomentCommentDeleted;

  /// 后台刷新完成返回最新动态列表回调 / Callback invoked when background refresh updates the feed.
  void Function(List<MomentInfo> moments)? onMomentListUpdated;

  /// 创建朋友圈监听器。
  ///
  /// Creates an [OnMomentsListener] with optional Moments event callbacks.
  ///
  /// - [onMomentPublished] 动态发布回调 / Moment published callback.
  /// - [onMomentDeleted] 动态删除回调 / Moment deleted callback.
  /// - [onMomentLiked] 动态点赞回调 / Moment liked callback.
  /// - [onMomentUnliked] 取消点赞回调 / Moment unliked callback.
  /// - [onMomentCommented] 动态评论回调 / Moment commented callback.
  /// - [onMomentCommentDeleted] 评论删除回调 / Comment deleted callback.
  /// - [onMomentListUpdated] 动态列表刷新回调 / Feed refreshed callback.
  OnMomentsListener({
    this.onMomentPublished,
    this.onMomentDeleted,
    this.onMomentLiked,
    this.onMomentUnliked,
    this.onMomentCommented,
    this.onMomentCommentDeleted,
    this.onMomentListUpdated,
  });

  /// 触发动态发布回调 / Dispatches [onMomentPublished].
  ///
  /// - [moment] 新发布的动态对象 / Published moment.
  void momentPublished(MomentInfo moment) {
    onMomentPublished?.call(moment);
  }

  /// 触发动态删除回调 / Dispatches [onMomentDeleted].
  ///
  /// - [momentID] 被删除动态 ID / Deleted moment ID.
  void momentDeleted(String momentID) {
    onMomentDeleted?.call(momentID);
  }

  /// 触发动态点赞回调 / Dispatches [onMomentLiked].
  ///
  /// - [like] 点赞记录对象 / Like record with user info.
  void momentLiked(MomentLikeWithUser like) {
    onMomentLiked?.call(like);
  }

  /// 触发取消点赞回调 / Dispatches [onMomentUnliked].
  ///
  /// - [momentID] 动态 ID / Moment ID.
  /// - [userID] 取消点赞的用户 ID / User ID who unliked.
  void momentUnliked(String momentID, String userID) {
    onMomentUnliked?.call(momentID, userID);
  }

  /// 触发动态评论回调 / Dispatches [onMomentCommented].
  ///
  /// - [comment] 评论对象 / Comment record with user info.
  void momentCommented(MomentCommentWithUser comment) {
    onMomentCommented?.call(comment);
  }

  /// 触发评论删除回调 / Dispatches [onMomentCommentDeleted].
  ///
  /// - [commentID] 被删除评论 ID / Deleted comment ID.
  void momentCommentDeleted(String commentID) {
    onMomentCommentDeleted?.call(commentID);
  }

  /// 触发动态列表更新回调 / Dispatches [onMomentListUpdated].
  ///
  /// - [moments] 最新动态列表 / Refreshed list of moments.
  void momentListUpdated(List<MomentInfo> moments) {
    onMomentListUpdated?.call(moments);
  }
}
