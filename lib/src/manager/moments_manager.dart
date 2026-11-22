import 'dart:async';

import '../config/api_url.dart';
import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../listener/moments_listener.dart';
import '../models/api_response.dart';
import '../models/moment_comment.dart';
import '../models/moment_create_req.dart';
import '../models/moment_info.dart';
import '../models/moment_like.dart';
import '../models/moment_list_response.dart';
import '../models/moment_user_info.dart';

/// 朋友圈动态管理器（支持本地优先秒开缓存、严格时序游标分页与增量同步）。
///
/// Moments manager with local-first timeline caching, monotonic cursor paging,
/// and incremental sync.
final class MomentsManager extends BaseManager<OnMomentsListener> {
  static const int _maxSyncRounds = 10;

  final SdkContext _context;
  Future<MomentSyncResponse>? _syncInFlight;

  /// 创建 `MomentsManager` 实例。
  ///
  /// Creates a `MomentsManager` instance.
  ///
  /// - [_context] SDK 上下文 / SDK context.
  MomentsManager({required this._context}) : super('MomentsManager');

  /// 设置朋友圈动态事件监听器。
  ///
  /// Sets the moments event listener.
  ///
  /// - [listener] 监听器 / Listener.
  void setMomentsListener(OnMomentsListener listener) {
    setPrimaryListener(listener);
  }

  /// 登出时清理内存态同步引用。
  @override
  void onLogout() {
    _syncInFlight = null;
    super.onLogout();
  }

  // ---- 本地优先缓存与时序同步 ----

  /// 直接读取本地缓存的朋友圈时间线（零网络延迟，按 `timelineSeq` 严格降序）。
  ///
  /// Reads cached moments directly from local storage ordered by `timelineSeq` descending.
  ///
  /// - [ownerUserID] 可选发布者用户ID，不传则读取全局可见时间线 / Optional author user ID.
  /// - [beforeSeq] 游标序号，`> 0` 时仅返回早于该序号的动态 / Exclusive upper-bound cursor.
  /// - [limit] 返回条数上限 / Maximum number of moments to return.
  /// - Returns: 本地缓存的严格时序动态列表 / Strictly ordered cached moments.
  Future<List<MomentInfo>> getCachedTimeline({
    String? ownerUserID,
    int beforeSeq = 0,
    int limit = 20,
  }) {
    return _context.db.social.getMomentsTimeline(
      ownerUserID: ownerUserID,
      beforeSeq: beforeSeq,
      limit: limit,
    );
  }

  /// 执行朋友圈增量同步（基于持久化 `syncSeq` 水位，自动合并并发请求）。
  ///
  /// Performs incremental moments sync using the persisted `syncSeq` watermark.
  /// Concurrent calls coalesce into the same in-flight request.
  ///
  /// - [limit] 单批拉取上限 / Page size per sync batch.
  /// - Returns: 聚合后的同步响应 / Aggregated sync response.
  Future<MomentSyncResponse> syncMoments({int limit = 50}) {
    final Future<MomentSyncResponse>? existing = _syncInFlight;
    if (existing != null) {
      return existing;
    }
    final Future<MomentSyncResponse> task = _runSyncMoments(limit: limit);
    _syncInFlight = task;
    return task.whenComplete(() {
      if (identical(_syncInFlight, task)) {
        _syncInFlight = null;
      }
    });
  }

  Future<MomentSyncResponse> _runSyncMoments({required int limit}) async {
    int currentSeq = await _context.db.social.getMomentsSyncSeq();
    final List<MomentInfo> totalUpserts = <MomentInfo>[];
    final List<String> totalDeleted = <String>[];
    bool didFullRefresh = false;
    bool hasMore = false;

    for (int round = 0; round < _maxSyncRounds; round++) {
      final ApiResponse resp = await _context.httpClient.chatPost(
        ChatApiUrl.momentSync,
        data: <String, dynamic>{'lastSyncSeq': currentSeq, 'limit': limit},
      );
      if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
        logger.warning('syncMoments failed: ${resp.errMsg}');
        break;
      }

      final MomentSyncResponse batch = MomentSyncResponse.fromJson(
        resp.data as Map<String, dynamic>,
      );

      if (batch.needFullRefresh) {
        didFullRefresh = true;
        await _context.db.social.clearMoments();
        if (batch.upserts.isNotEmpty) {
          await _context.db.social.batchUpsertMoments(batch.upserts);
          final int oldest = _minTimelineSeq(batch.upserts);
          if (oldest > 0) {
            await _context.db.social.setMomentsOldestSeq(oldest);
          }
          await _context.db.social.setMomentsHasMoreHistory(batch.hasMore);
        } else {
          await _context.db.social.setMomentsOldestSeq(0);
          await _context.db.social.setMomentsHasMoreHistory(false);
        }
        totalUpserts.addAll(batch.upserts);
      } else {
        if (batch.upserts.isNotEmpty) {
          await _context.db.social.batchUpsertMoments(batch.upserts);
          totalUpserts.addAll(batch.upserts);
        }
        if (batch.deletedMomentIDs.isNotEmpty) {
          await _context.db.social.deleteMomentsByIDs(batch.deletedMomentIDs);
          totalDeleted.addAll(batch.deletedMomentIDs);
        }
      }

      if (batch.latestSyncSeq > currentSeq) {
        currentSeq = batch.latestSyncSeq;
        await _context.db.social.setMomentsSyncSeq(currentSeq);
      }

      hasMore = batch.hasMore;
      if (!batch.hasMore || batch.needFullRefresh) {
        break;
      }
    }

    if (didFullRefresh || totalUpserts.isNotEmpty || totalDeleted.isNotEmpty) {
      final List<MomentInfo> topPage = await getCachedTimeline(limit: 20);
      listener?.momentListUpdated(topPage);
    }

    return MomentSyncResponse(
      latestSyncSeq: currentSeq,
      needFullRefresh: didFullRefresh,
      hasMore: hasMore,
      upserts: totalUpserts,
      deletedMomentIDs: totalDeleted,
    );
  }

  /// 按 `timelineSeq` 游标向下加载更多历史动态（本地优先，不足时自动回源并写回缓存）。
  ///
  /// Loads older moments before [beforeSeq], reading local cache first and fetching
  /// from `/moment/timeline` when local history is exhausted.
  ///
  /// - [ownerUserID] 可选发布者用户ID，不传则拉取全局可见时间线 / Optional author user ID.
  /// - [beforeSeq] 当前列表末尾动态的 `timelineSeq`（`0` 表示从最新开始） / Exclusive upper-bound cursor.
  /// - [limit] 本页加载条数 / Page size.
  /// - Returns: 严格时序游标分页响应 / Cursor-based timeline response.
  Future<MomentTimelineResponse> loadMoreTimeline({
    String? ownerUserID,
    int beforeSeq = 0,
    int limit = 20,
  }) async {
    final bool isGlobalFeed = ownerUserID == null || ownerUserID.isEmpty;
    final int currentSyncSeq = await _context.db.social.getMomentsSyncSeq();

    if (isGlobalFeed) {
      final List<MomentInfo> local = await _context.db.social.getMomentsTimeline(
        beforeSeq: beforeSeq,
        limit: limit,
      );
      if (local.length >= limit) {
        final int nextCursor = local.last.timelineSeq;
        return MomentTimelineResponse(
          moments: local,
          nextBeforeSeq: nextCursor,
          hasMore: true,
          latestSyncSeq: currentSyncSeq,
        );
      }
      final bool hasMoreHistory = await _context.db.social.getMomentsHasMoreHistory();
      if (!hasMoreHistory && local.isNotEmpty) {
        return MomentTimelineResponse(
          moments: local,
          nextBeforeSeq: local.last.timelineSeq,
          hasMore: false,
          latestSyncSeq: currentSyncSeq,
        );
      }
    }

    final ApiResponse resp = await _context.httpClient.chatPost(
      ChatApiUrl.momentTimeline,
      data: <String, dynamic>{
        if (!isGlobalFeed) 'ownerUserID': ownerUserID,
        'beforeSeq': beforeSeq,
        'limit': limit,
      },
    );
    if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
      logger.warning('loadMoreTimeline failed: ${resp.errMsg}');
      final List<MomentInfo> fallback = await _context.db.social.getMomentsTimeline(
        ownerUserID: ownerUserID,
        beforeSeq: beforeSeq,
        limit: limit,
      );
      return MomentTimelineResponse(
        moments: fallback,
        nextBeforeSeq: fallback.isNotEmpty ? fallback.last.timelineSeq : 0,
        hasMore: false,
        latestSyncSeq: currentSyncSeq,
      );
    }

    final MomentTimelineResponse remote = MomentTimelineResponse.fromJson(
      resp.data as Map<String, dynamic>,
    );
    if (remote.moments.isNotEmpty) {
      await _context.db.social.batchUpsertMoments(remote.moments);
    }
    if (isGlobalFeed) {
      final int oldest = _minTimelineSeq(remote.moments);
      if (oldest > 0) {
        final int prevOldest = await _context.db.social.getMomentsOldestSeq();
        if (prevOldest == 0 || oldest < prevOldest) {
          await _context.db.social.setMomentsOldestSeq(oldest);
        }
      }
      await _context.db.social.setMomentsHasMoreHistory(remote.hasMore);
      if (remote.latestSyncSeq > currentSyncSeq) {
        await _context.db.social.setMomentsSyncSeq(remote.latestSyncSeq);
      }
    }
    return remote;
  }

  // ---- 动态 CRUD 与互动 ----

  /// 创建朋友圈动态（成功后立即写入本地缓存并推进同步水位）。
  ///
  /// Creates a moment, persists it locally, and advances the sync sequence.
  ///
  /// - [request] 创建动态请求参数 / Create moment request payload.
  /// - Returns: 新创建的动态对象，失败返回 `null` / Created [MomentInfo], or `null` on failure.
  Future<MomentInfo?> createMoment({required MomentCreateReq request}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/create',
      data: request.toJson(),
    );
    if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
      logger.warning('createMoment failed: ${resp.errMsg}');
      return null;
    }
    final Map<String, dynamic> data = resp.data as Map<String, dynamic>;
    final Map<String, dynamic> momentMap = (data['moment'] as Map<String, dynamic>?) ?? data;
    final MomentInfo moment = MomentInfo.fromJson(momentMap);
    await _context.db.social.upsertMoment(moment);
    await _advanceSyncSeqFromPayload(data);
    listener?.momentPublished(moment);
    return moment;
  }

  /// 删除朋友圈动态（成功后立即从本地缓存移除并推进同步水位）。
  ///
  /// Deletes a moment, removes it from local cache, and advances the sync sequence.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - Returns: 操作是否成功 / Whether deletion succeeded.
  Future<bool> deleteMoment({required String momentID}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/delete',
      data: <String, dynamic>{'momentID': momentID},
    );
    if (!resp.isSuccess) {
      return false;
    }
    await _context.db.social.deleteMoment(momentID);
    await _advanceSyncSeqFromPayload(resp.data);
    listener?.momentDeleted(momentID);
    return true;
  }

  /// 获取朋友圈动态列表（本地优先秒开，首页命中缓存时自动后台增量同步）。
  ///
  /// Gets moments local-first; when page 1 of the global feed hits local cache,
  /// triggers an asynchronous incremental sync in the background.
  ///
  /// - [ownerUserID] 发布者用户ID（为空时查全局时间线） / Optional author user ID.
  /// - [pageNumber] 页码（从 1 开始） / 1-based page number.
  /// - [showNumber] 每页条数 / Page size.
  /// - Returns: `Future<MomentListResponse>` 结果 / Resulting `Future<MomentListResponse>`.
  Future<MomentListResponse> getMomentList({
    String? ownerUserID,
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    final bool isGlobalFeed = ownerUserID == null || ownerUserID.isEmpty;
    final int offset = (pageNumber - 1) * showNumber;
    final List<MomentInfo> local = isGlobalFeed
        ? await _context.db.social.getMoments(offset: offset, count: showNumber)
        : await _context.db.social.getMomentsByUserID(
            ownerUserID,
            offset: offset,
            count: showNumber,
          );
    if (local.isNotEmpty) {
      if (isGlobalFeed && pageNumber == 1) {
        unawaited(syncMoments());
      }
      return MomentListResponse(total: local.length, moments: local);
    }

    if (isGlobalFeed && pageNumber == 1) {
      await syncMoments(limit: showNumber > 20 ? showNumber : 20);
      final List<MomentInfo> synced = await _context.db.social.getMoments(
        offset: 0,
        count: showNumber,
      );
      return MomentListResponse(total: synced.length, moments: synced);
    }

    return fetchMomentListFromServer(
      ownerUserID: ownerUserID,
      pageNumber: pageNumber,
      showNumber: showNumber,
    );
  }

  /// 从服务端拉取传统分页朋友圈列表并写回本地缓存。
  ///
  /// Fetches moments using page-based pagination from `/moment/list` and updates local cache.
  ///
  /// - [ownerUserID] 发布者用户ID / Optional author user ID.
  /// - [pageNumber] 页码 / Page number.
  /// - [showNumber] 每页条数 / Page size.
  /// - Returns: `Future<MomentListResponse>` 结果 / Resulting `Future<MomentListResponse>`.
  Future<MomentListResponse> fetchMomentListFromServer({
    String? ownerUserID,
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/list',
      data: <String, dynamic>{
        if (ownerUserID != null && ownerUserID.isNotEmpty) 'ownerUserID': ownerUserID,
        'pageNumber': pageNumber,
        'showNumber': showNumber,
      },
    );
    if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
      return const MomentListResponse(total: 0, moments: <MomentInfo>[]);
    }
    final MomentListResponse result = MomentListResponse.fromJson(
      resp.data as Map<String, dynamic>,
    );
    if (result.moments.isNotEmpty) {
      await _context.db.social.batchUpsertMoments(result.moments);
      listener?.momentListUpdated(result.moments);
    }
    return result;
  }

  /// 点赞朋友圈动态（成功后同步更新本地缓存）。
  ///
  /// Likes a moment and updates local cache immediately.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - [ownerUserID] 动态发布者用户ID / Moment owner user ID.
  /// - Returns: 操作是否成功 / Whether liking succeeded.
  Future<bool> likeMoment({required String momentID, String? ownerUserID}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/like',
      data: <String, dynamic>{'momentID': momentID, 'ownerUserID': ?ownerUserID},
    );
    if (!resp.isSuccess) {
      return false;
    }
    final MomentLikeWithUser localLike = MomentLikeWithUser(
      momentID: momentID,
      userID: _context.loginUser.userID,
      createTime: DateTime.now().toUtc().toIso8601String(),
      userInfo: MomentUserInfo(
        userID: _context.loginUser.userID,
        nickname: _context.loginUser.nickname ?? '',
        faceURL: _context.loginUser.faceURL ?? '',
      ),
    );
    await _applyLocalLike(momentID, localLike);
    await _advanceSyncSeqFromPayload(resp.data);
    return true;
  }

  /// 取消点赞朋友圈动态（成功后同步更新本地缓存）。
  ///
  /// Unlikes a moment and updates local cache immediately.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - [ownerUserID] 动态发布者用户ID / Moment owner user ID.
  /// - Returns: 操作是否成功 / Whether unliking succeeded.
  Future<bool> unlikeMoment({required String momentID, String? ownerUserID}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/unlike',
      data: <String, dynamic>{'momentID': momentID, 'ownerUserID': ?ownerUserID},
    );
    if (!resp.isSuccess) {
      return false;
    }
    await _applyLocalUnlike(momentID, _context.loginUser.userID);
    await _advanceSyncSeqFromPayload(resp.data);
    return true;
  }

  /// 评论朋友圈动态（成功后同步更新本地缓存）。
  ///
  /// Comments on a moment and updates local cache immediately.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - [content] 评论内容 / Comment content.
  /// - [replyToUserID] 被回复用户ID / Optional reply target user ID.
  /// - [ownerUserID] 动态发布者用户ID / Moment owner user ID.
  /// - Returns: 新建评论对象，失败返回 `null` / Created comment, or `null` on failure.
  Future<MomentCommentWithUser?> commentMoment({
    required String momentID,
    required String content,
    String? replyToUserID,
    String? ownerUserID,
  }) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/comment',
      data: <String, dynamic>{
        'momentID': momentID,
        'content': content,
        'replyToUserID': ?replyToUserID,
        'ownerUserID': ?ownerUserID,
      },
    );
    if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
      return null;
    }
    final Map<String, dynamic> data = resp.data as Map<String, dynamic>;
    final Map<String, dynamic> rawComment = (data['comment'] as Map<String, dynamic>?) ?? data;
    final MomentCommentWithUser comment = MomentCommentWithUser.fromJson(rawComment);
    await _applyLocalComment(momentID, comment);
    await _advanceSyncSeqFromPayload(data);
    listener?.momentCommented(comment);
    return comment;
  }

  /// 删除评论（成功后同步更新本地缓存）。
  ///
  /// Deletes a comment and updates local cache immediately.
  ///
  /// - [commentID] 评论ID / Comment ID.
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - Returns: 操作是否成功 / Whether deletion succeeded.
  Future<bool> deleteComment({required String commentID, String? momentID}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/delete_comment',
      data: <String, dynamic>{'commentID': commentID},
    );
    if (!resp.isSuccess) {
      return false;
    }
    if (momentID != null && momentID.isNotEmpty) {
      await _applyLocalDeleteComment(momentID, commentID);
    }
    await _advanceSyncSeqFromPayload(resp.data);
    listener?.momentCommentDeleted(commentID);
    return true;
  }

  /// 处理来自长连接的朋友圈业务通知并维护本地缓存与序号连续性。
  ///
  /// Handles real-time WebSocket moments notifications, updates local cache,
  /// and triggers incremental sync when a sequence gap is detected.
  ///
  /// - [key] 业务通知事件键名 / Business notification key.
  /// - [data] 通知数据载荷 / Notification payload map.
  Future<void> handleNotification(String key, Map<String, dynamic> data) async {
    try {
      switch (key) {
        case 'moment_created':
        case 'moment_published':
          final Map<String, dynamic> rawMoment = (data['moment'] as Map<String, dynamic>?) ?? data;
          final MomentInfo moment = MomentInfo.fromJson(rawMoment);
          if (moment.momentID.isNotEmpty) {
            await _context.db.social.upsertMoment(moment);
            listener?.momentPublished(moment);
          }
        case 'moment_deleted':
          final String id = data['momentID']?.toString() ?? '';
          if (id.isNotEmpty) {
            await _context.db.social.deleteMoment(id);
            listener?.momentDeleted(id);
          }
        case 'moment_liked':
          final Map<String, dynamic> rawLike = Map<String, dynamic>.from(
            (data['like'] as Map<dynamic, dynamic>?) ?? data,
          );
          if ((rawLike['momentID'] == null || rawLike['momentID'].toString().isEmpty) &&
              data['momentID'] != null) {
            rawLike['momentID'] = data['momentID'];
          }
          final MomentLikeWithUser like = MomentLikeWithUser.fromJson(rawLike);
          if (like.momentID.isNotEmpty) {
            await _applyLocalLike(like.momentID, like);
          }
          listener?.momentLiked(like);
        case 'moment_unliked':
          final String momentID = data['momentID']?.toString() ?? '';
          final String userID = data['userID']?.toString() ?? '';
          if (momentID.isNotEmpty) {
            await _applyLocalUnlike(momentID, userID);
            listener?.momentUnliked(momentID, userID);
          }
        case 'moment_commented':
          final Map<String, dynamic> rawComment = Map<String, dynamic>.from(
            (data['comment'] as Map<dynamic, dynamic>?) ?? data,
          );
          if ((rawComment['momentID'] == null || rawComment['momentID'].toString().isEmpty) &&
              data['momentID'] != null) {
            rawComment['momentID'] = data['momentID'];
          }
          final MomentCommentWithUser comment = MomentCommentWithUser.fromJson(rawComment);
          if (comment.momentID.isNotEmpty) {
            await _applyLocalComment(comment.momentID, comment);
          }
          listener?.momentCommented(comment);
        case 'moment_comment_deleted':
          final String commentID = data['commentID']?.toString() ?? '';
          final String momentID = data['momentID']?.toString() ?? '';
          if (momentID.isNotEmpty && commentID.isNotEmpty) {
            await _applyLocalDeleteComment(momentID, commentID);
          }
          if (commentID.isNotEmpty) {
            listener?.momentCommentDeleted(commentID);
          }
      }

      await _checkNotificationSyncSeq(data);
    } on Object catch (error, stackTrace) {
      logger.warning('handleNotification($key) failed', error, stackTrace);
    }
  }

  /// 与服务端执行增量同步（由登录建连与重连流程自动调用）。
  ///
  /// Syncs moments incrementally from the server on connection / reconnect.
  Future<void> syncFromServer() async {
    await syncMoments();
  }

  // ---- 内部辅助方法 ----

  Future<void> _applyLocalLike(String momentID, MomentLikeWithUser like) async {
    final MomentInfo? cached = await _context.db.social.getMomentByID(momentID);
    if (cached == null) {
      return;
    }
    final bool exists = cached.likes.any((MomentLikeWithUser item) => item.userID == like.userID);
    if (exists) {
      return;
    }
    final List<MomentLikeWithUser> updatedLikes = <MomentLikeWithUser>[...cached.likes, like];
    await _context.db.social.upsertMoment(
      cached.copyWith(likes: updatedLikes, likeCount: cached.likeCount + 1),
    );
  }

  Future<void> _applyLocalUnlike(String momentID, String userID) async {
    final MomentInfo? cached = await _context.db.social.getMomentByID(momentID);
    if (cached == null) {
      return;
    }
    final List<MomentLikeWithUser> updatedLikes = cached.likes
        .where((MomentLikeWithUser item) => item.userID != userID)
        .toList();
    if (updatedLikes.length == cached.likes.length) {
      return;
    }
    final int nextCount = cached.likeCount > 0 ? cached.likeCount - 1 : 0;
    await _context.db.social.upsertMoment(
      cached.copyWith(likes: updatedLikes, likeCount: nextCount),
    );
  }

  Future<void> _applyLocalComment(String momentID, MomentCommentWithUser comment) async {
    final MomentInfo? cached = await _context.db.social.getMomentByID(momentID);
    if (cached == null) {
      return;
    }
    final bool exists = cached.comments.any(
      (MomentCommentWithUser item) =>
          comment.commentID.isNotEmpty && item.commentID == comment.commentID,
    );
    if (exists) {
      return;
    }
    final List<MomentCommentWithUser> updatedComments = <MomentCommentWithUser>[
      ...cached.comments,
      comment,
    ];
    await _context.db.social.upsertMoment(
      cached.copyWith(comments: updatedComments, commentCount: cached.commentCount + 1),
    );
  }

  Future<void> _applyLocalDeleteComment(String momentID, String commentID) async {
    final MomentInfo? cached = await _context.db.social.getMomentByID(momentID);
    if (cached == null) {
      return;
    }
    final List<MomentCommentWithUser> updatedComments = cached.comments
        .where((MomentCommentWithUser item) => item.commentID != commentID)
        .toList();
    if (updatedComments.length == cached.comments.length) {
      return;
    }
    final int nextCount = cached.commentCount > 0 ? cached.commentCount - 1 : 0;
    await _context.db.social.upsertMoment(
      cached.copyWith(comments: updatedComments, commentCount: nextCount),
    );
  }

  Future<void> _advanceSyncSeqFromPayload(dynamic payload) async {
    if (payload is! Map<dynamic, dynamic>) {
      return;
    }
    final int incoming = _toInt(payload['syncSeq']) ?? 0;
    if (incoming <= 0) {
      return;
    }
    final int current = await _context.db.social.getMomentsSyncSeq();
    if (incoming == current + 1) {
      await _context.db.social.setMomentsSyncSeq(incoming);
    } else if (incoming > current + 1) {
      unawaited(syncMoments());
    }
  }

  Future<void> _checkNotificationSyncSeq(Map<String, dynamic> data) async {
    final int incoming = _toInt(data['syncSeq']) ?? 0;
    if (incoming <= 0) {
      return;
    }
    final int current = await _context.db.social.getMomentsSyncSeq();
    if (incoming == current + 1) {
      await _context.db.social.setMomentsSyncSeq(incoming);
    } else if (incoming > current + 1) {
      unawaited(syncMoments());
    }
  }

  int _minTimelineSeq(List<MomentInfo> moments) {
    int minSeq = 0;
    for (final MomentInfo m in moments) {
      if (m.timelineSeq > 0 && (minSeq == 0 || m.timelineSeq < minSeq)) {
        minSeq = m.timelineSeq;
      }
    }
    return minSeq;
  }
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
