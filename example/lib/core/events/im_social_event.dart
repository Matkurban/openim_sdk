import 'package:openim_sdk/openim_sdk.dart';

/// IM 扩展业务事件（朋友圈、收藏、红包积分、音视频通话与自定义业务）。
///
/// IM extended social/business event (moments, favorites, red packet/points, calls, custom business).
class ImSocialEvent {
  /// 事件类型：
  /// `momentPublished`、`momentDeleted`、`momentLiked`、`momentUnliked`、`momentCommented`、`momentCommentDeleted`、`momentListUpdated`、
  /// `favoriteAdded`、`favoriteRemoved`、`favoriteUpdated`、
  /// `redPacketExpired`、`pointsBalanceChanged`、
  /// `incomingCall`、`callAccepted`、`callRejected`、`callCancelled`、`callEnded`、`callTimeout`、`callBusy`、`callConnected`、
  /// `customBusiness`。
  final String kind;

  /// 朋友圈动态对象。
  final MomentInfo? moment;

  /// 朋友圈点赞对象。
  final MomentLikeWithUser? momentLike;

  /// 朋友圈评论对象。
  final MomentCommentWithUser? momentComment;

  /// 收藏条目对象。
  final FavoriteItem? favorite;

  /// 通话会话对象。
  final CallSession? callSession;

  /// 关联标识（动态 ID / 评论 ID / 红包 ID / 收藏目标 ID / 用户 ID）。
  final String? targetID;

  /// 附加类型或用户 ID（如收藏目标类型、通话响应方 ID）。
  final String? extraID;

  /// 积分余额（`pointsBalanceChanged` 时有效）。
  final double? balance;

  /// 自定义业务负载字符串。
  final String? payload;

  /// 创建扩展业务事件。
  const ImSocialEvent({
    required this.kind,
    this.moment,
    this.momentLike,
    this.momentComment,
    this.favorite,
    this.callSession,
    this.targetID,
    this.extraID,
    this.balance,
    this.payload,
  });
}
