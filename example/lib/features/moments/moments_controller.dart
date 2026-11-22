import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../core/events/im_event_bus.dart';
import '../../core/events/im_social_event.dart';

/// 朋友圈控制器（订阅 [ImEventBus] 同步动态、点赞、评论与互动提醒）。
///
/// Moments feed controller subscribing to [ImEventBus].
class MomentsController extends WireController {
  static final Logger _logger = Logger('MomentsController');

  /// 动态列表信号。
  late final Signal<List<MomentInfo>> moments = createSignal<List<MomentInfo>>(
    <MomentInfo>[],
  );

  /// 未读互动提醒事件列表信号（点赞与评论）。
  late final Signal<List<ImSocialEvent>> notifications =
      createSignal<List<ImSocialEvent>>(<ImSocialEvent>[]);

  /// 是否加载中。
  late final Signal<bool> loading = createSignal<bool>(true);

  StreamSubscription<ImSocialEvent>? _socialSub;

  @override
  void onInit() {
    super.onInit();
    final ImEventBus bus = Wire.find<ImEventBus>();
    _socialSub = bus.socialStream.listen((ImSocialEvent event) {
      if (event.kind.startsWith('moment')) {
        if (event.kind == 'momentLiked' || event.kind == 'momentCommented') {
          notifications.value = <ImSocialEvent>[event, ...notifications.value];
        }
        unawaited(loadMoments());
      }
    });
    unawaited(loadMoments(fromServer: true));
  }

  /// 加载朋友圈动态列表。
  Future<void> loadMoments({bool fromServer = false}) async {
    try {
      final MomentListResponse res = fromServer
          ? await OpenIM.iMManager.momentsManager.fetchMomentListFromServer(
              pageNumber: 1,
              showNumber: 30,
            )
          : await OpenIM.iMManager.momentsManager.getMomentList(
              pageNumber: 1,
              showNumber: 30,
            );
      moments.value = res.moments;
    } on Object catch (error, stackTrace) {
      _logger.warning('loadMoments failed', error, stackTrace);
    } finally {
      loading.value = false;
    }
  }

  /// 点赞或取消点赞。
  Future<void> toggleLike(MomentInfo moment) async {
    final String selfId = OpenIM.iMManager.userID;
    final bool liked = moment.likes.any(
      (MomentLikeWithUser l) => l.userID == selfId,
    );
    try {
      if (liked) {
        await OpenIM.iMManager.momentsManager.unlikeMoment(
          momentID: moment.momentID,
          ownerUserID: moment.userID,
        );
      } else {
        await OpenIM.iMManager.momentsManager.likeMoment(
          momentID: moment.momentID,
          ownerUserID: moment.userID,
        );
      }
      await loadMoments();
    } on Object catch (error) {
      await FlutterToastPro.error('点赞操作失败：$error');
    }
  }

  /// 发表评论或回复评论。
  Future<void> addComment({
    required MomentInfo moment,
    required String content,
    String? replyUserID,
  }) async {
    final String trimmed = content.trim();
    if (trimmed.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.momentsManager.commentMoment(
        momentID: moment.momentID,
        content: trimmed,
        replyToUserID: replyUserID,
        ownerUserID: moment.userID,
      );
      await loadMoments();
    } on Object catch (error) {
      await FlutterToastPro.error('评论失败：$error');
    }
  }

  /// 删除动态。
  Future<void> deleteMoment(String momentId) async {
    try {
      await OpenIM.iMManager.momentsManager.deleteMoment(momentID: momentId);
      await FlutterToastPro.success('已删除动态');
      await loadMoments();
    } on Object catch (error) {
      await FlutterToastPro.error('删除失败：$error');
    }
  }

  /// 删除评论。
  Future<void> deleteComment(String commentId, String momentId) async {
    try {
      await OpenIM.iMManager.momentsManager.deleteComment(
        commentID: commentId,
        momentID: momentId,
      );
      await loadMoments();
    } on Object catch (error) {
      await FlutterToastPro.error('删除评论失败：$error');
    }
  }

  /// 收藏动态。
  Future<void> favoriteMoment(MomentInfo moment) async {
    try {
      await OpenIM.iMManager.favoriteManager.addMoment(moment: moment);
      await FlutterToastPro.success('已收藏该动态');
    } on Object catch (error) {
      await FlutterToastPro.error('收藏失败：$error');
    }
  }

  /// 清空未读互动通知。
  void clearNotifications() {
    notifications.value = <ImSocialEvent>[];
  }

  @override
  void onClose() {
    _socialSub?.cancel();
    super.onClose();
  }
}
