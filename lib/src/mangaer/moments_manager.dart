import 'package:get_it/get_it.dart';
import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/listener/moments_listener.dart';
import 'package:openim_sdk/src/models/moment_comment.dart';
import 'package:openim_sdk/src/models/moment_create_req.dart';
import 'package:openim_sdk/src/models/moment_info.dart';
import 'package:openim_sdk/src/models/moment_like.dart';
import 'package:openim_sdk/src/models/moment_list_response.dart';
import 'package:openim_sdk/src/network/http_client.dart';
import 'package:openim_sdk/src/services/database_service.dart';

/// 朋友圈管理器
///
/// 提供发布、删除、点赞、取消点赞、评论、删除评论、获取列表等能力。
/// 采用 local-first + network-sync 混合架构：
/// - 读取：优先返回本地数据，后台异步拉取最新并更新本地 + 回调通知
/// - 写入：先发网络请求，成功后写入本地 + 触发 listener
class MomentsManager {
  MomentsManager._internal();

  static final MomentsManager _instance = MomentsManager._internal();

  factory MomentsManager() => _instance;

  static final AoiweLogger _log = AoiweLogger('MomentsManager');

  final GetIt _getIt = GetIt.instance;

  OnMomentsListener? listener;

  late String _currentUserID;

  void setMomentsListener(OnMomentsListener listener) {
    this.listener = listener;
  }

  @internal
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  DatabaseService get _database {
    return _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  /// 发布朋友圈动态
  Future<MomentInfo?> createMoment({required MomentCreateReq request}) async {
    _log.info('content=${request.content}', methodName: 'createMoment');
    try {
      final resp = await HttpClient().chatPost('/moment/create', data: request.toJson());
      if (!resp.isSuccess) {
        _log.warning('createMoment failed: ${resp.errMsg}');
        return null;
      }
      if (resp.data is Map<String, dynamic>) {
        final dataMap = resp.data as Map<String, dynamic>;
        if (dataMap['moment'] is Map<String, dynamic>) {
          final moment = MomentInfo.fromJson(dataMap['moment'] as Map<String, dynamic>);
          await _database.upsertMoment(moment);
          return moment;
        }
      }
      return null;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createMoment');
      rethrow;
    }
  }

  /// 删除朋友圈动态
  Future<bool> deleteMoment({required String momentID}) async {
    _log.info('momentID: $momentID', methodName: 'deleteMoment');
    try {
      final resp = await HttpClient().chatPost('/moment/delete', data: {'momentID': momentID});
      if (resp.isSuccess) {
        await _database.deleteMoment(momentID);
        return true;
      }
      _log.warning('deleteMoment failed: ${resp.errMsg}');
      return false;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'deleteMoment');
      rethrow;
    }
  }

  /// 获取朋友圈列表
  ///
  /// 优先返回本地数据；同时后台拉取网络最新，更新本地后通过 listener 回调。
  /// [ownerUserID] 为空则获取好友动态流；指定则获取某人的动态。
  Future<MomentListResponse> getMomentList({
    String? ownerUserID,
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    _log.info(
      'ownerUserID=$ownerUserID, page=$pageNumber, size=$showNumber',
      methodName: 'getMomentList',
    );
    try {
      // 先查本地
      final offset = (pageNumber - 1) * showNumber;
      final localMoments = ownerUserID != null && ownerUserID.isNotEmpty
          ? await _database.getMomentsByUserID(ownerUserID, offset: offset, count: showNumber)
          : await _database.getMoments(offset: offset, count: showNumber);

      // 本地有数据时直接返回，后台异步刷新
      if (localMoments.isNotEmpty) {
        _fetchAndCacheMoments(
          ownerUserID: ownerUserID,
          pageNumber: pageNumber,
          showNumber: showNumber,
        );
        return MomentListResponse(total: localMoments.length, moments: localMoments);
      }

      // 本地无数据时直接走网络
      return await fetchMomentListFromServer(
        ownerUserID: ownerUserID,
        pageNumber: pageNumber,
        showNumber: showNumber,
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getMomentList');
      rethrow;
    }
  }

  /// 仅从网络获取（强制刷新）
  Future<MomentListResponse> fetchMomentListFromServer({
    String? ownerUserID,
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    _log.info(
      'ownerUserID=$ownerUserID, page=$pageNumber, size=$showNumber',
      methodName: 'fetchMomentListFromServer',
    );
    try {
      final resp = await HttpClient().chatPost(
        '/moment/list',
        data: {
          'ownerUserID': ownerUserID ?? '',
          'pageNumber': pageNumber,
          'showNumber': showNumber,
        },
      );
      if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
        return MomentListResponse.empty();
      }
      final response = MomentListResponse.fromJson(resp.data as Map<String, dynamic>);
      // 写入本地
      if (response.moments.isNotEmpty) {
        await _database.batchUpsertMoments(response.moments);
      }
      return response;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'fetchMomentListFromServer');
      rethrow;
    }
  }

  /// 后台拉取网络数据并缓存
  Future<void> _fetchAndCacheMoments({
    String? ownerUserID,
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    _log.info(
      'ownerUserID=$ownerUserID, page=$pageNumber, size=$showNumber',
      methodName: '_fetchAndCacheMoments',
    );
    try {
      final resp = await HttpClient().chatPost(
        '/moment/list',
        data: {
          'ownerUserID': ownerUserID ?? '',
          'pageNumber': pageNumber,
          'showNumber': showNumber,
        },
      );
      if (!resp.isSuccess || resp.data is! Map<String, dynamic>) return;
      final response = MomentListResponse.fromJson(resp.data as Map<String, dynamic>);
      if (response.moments.isNotEmpty) {
        await _database.batchUpsertMoments(response.moments);
        listener?.momentListUpdated(response.moments);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_fetchAndCacheMoments');
    }
  }

  /// 点赞动态
  Future<bool> likeMoment({required String momentID, String? ownerUserID}) async {
    _log.info('momentID: $momentID', methodName: 'likeMoment');
    try {
      final resp = await HttpClient().chatPost(
        '/moment/like',
        data: {'momentID': momentID, 'ownerUserID': ownerUserID},
      );
      if (resp.isSuccess) {
        final like = MomentLikeWithUser(
          momentID: momentID,
          userID: _currentUserID,
          createTime: DateTime.now().toIso8601String(),
        );
        // 更新本地动态的点赞信息
        await _updateLocalMomentLike(momentID, like, add: true);
        return true;
      }
      _log.warning('likeMoment failed: ${resp.errMsg}');
      return false;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'likeMoment');
      rethrow;
    }
  }

  /// 取消点赞
  Future<bool> unlikeMoment({required String momentID, String? ownerUserID}) async {
    _log.info('momentID: $momentID', methodName: 'unlikeMoment');
    try {
      final resp = await HttpClient().chatPost(
        '/moment/unlike',
        data: {'momentID': momentID, 'ownerUserID': ?ownerUserID},
      );
      if (resp.isSuccess) {
        await _updateLocalMomentLike(
          momentID,
          MomentLikeWithUser(momentID: momentID, userID: _currentUserID, createTime: ''),
          add: false,
        );
        return true;
      }
      _log.warning('unlikeMoment failed: ${resp.errMsg}');
      return false;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'unlikeMoment');
      rethrow;
    }
  }

  Future<void> _updateLocalMomentLike(
    String momentID,
    MomentLikeWithUser like, {
    required bool add,
  }) async {
    _log.info('momentID: $momentID, add: $add', methodName: '_updateLocalMomentLike');
    try {
      final moment = await _database.getMomentByID(momentID);
      if (moment == null) return;
      final likes = List<MomentLikeWithUser>.from(moment.likes);
      if (add) {
        likes.removeWhere((l) => l.userID == like.userID);
        likes.add(like);
      } else {
        likes.removeWhere((l) => l.userID == like.userID);
      }
      final updated = moment.copyWith(likes: likes, likeCount: likes.length);
      await _database.upsertMoment(updated);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_updateLocalMomentLike');
      rethrow;
    }
  }

  /// 评论动态
  Future<MomentCommentWithUser?> commentMoment({
    required String momentID,
    required String content,
    String? replyToUserID,
    String? ownerUserID,
  }) async {
    _log.info('momentID=$momentID, content=$content', methodName: 'commentMoment');
    try {
      final resp = await HttpClient().chatPost(
        '/moment/comment',
        data: {
          'momentID': momentID,
          'content': content,
          if (replyToUserID != null && replyToUserID.isNotEmpty) 'replyToUserID': replyToUserID,
          'ownerUserID': ?ownerUserID,
        },
      );
      if (!resp.isSuccess) {
        _log.warning('commentMoment failed: ${resp.errMsg}');
        return null;
      }
      if (resp.data is Map<String, dynamic>) {
        final data = resp.data as Map<String, dynamic>;
        if (data['comment'] is Map<String, dynamic>) {
          final comment = MomentCommentWithUser.fromJson(data['comment'] as Map<String, dynamic>);
          await _updateLocalMomentComment(momentID, comment, add: true);
          return comment;
        }
      }
      return null;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'commentMoment');
      rethrow;
    }
  }

  /// 删除评论
  Future<bool> deleteComment({required String commentID, String? momentID}) async {
    _log.info('commentID: $commentID', methodName: 'deleteComment');
    try {
      final resp = await HttpClient().chatPost(
        '/moment/delete_comment',
        data: {'commentID': commentID},
      );
      if (resp.isSuccess) {
        if (momentID != null) {
          await _updateLocalMomentComment(momentID, null, add: false, removeCommentID: commentID);
        }
        return true;
      }
      _log.warning('deleteComment failed: ${resp.errMsg}');
      return false;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'deleteComment');
      rethrow;
    }
  }

  Future<void> _updateLocalMomentComment(
    String momentID,
    MomentCommentWithUser? comment, {
    required bool add,
    String? removeCommentID,
  }) async {
    _log.info('momentID: $momentID, add: $add', methodName: '_updateLocalMomentComment');
    try {
      final moment = await _database.getMomentByID(momentID);
      if (moment == null) return;
      final comments = List<MomentCommentWithUser>.from(moment.comments);
      if (add && comment != null) {
        comments.add(comment);
      } else if (removeCommentID != null) {
        comments.removeWhere((c) => c.commentID == removeCommentID);
      }
      final updated = moment.copyWith(comments: comments, commentCount: comments.length);
      await _database.upsertMoment(updated);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_updateLocalMomentComment');
      rethrow;
    }
  }

  /// 处理来自 WS 的朋友圈业务通知
  Future<void> handleNotification(String key, Map<String, dynamic> data) async {
    _log.info('key=$key', methodName: 'handleNotification');
    try {
      switch (key) {
        case 'moment_created':
          if (data['moment'] is Map<String, dynamic>) {
            final moment = MomentInfo.fromJson(data['moment'] as Map<String, dynamic>);
            // Skip if this is our own moment (already handled in createMoment())
            if (moment.userID == _currentUserID) break;
            await _database.upsertMoment(moment);
            listener?.momentPublished(moment);
          }
        case 'moment_deleted':
          final momentID = data['momentID'] as String? ?? '';
          if (momentID.isNotEmpty) {
            await _database.deleteMoment(momentID);
            listener?.momentDeleted(momentID);
          }
        case 'moment_liked':
          if (data['like'] is Map<String, dynamic>) {
            final like = MomentLikeWithUser.fromJson(data['like'] as Map<String, dynamic>);
            final momentID = data['momentID'] as String? ?? like.momentID;
            await _updateLocalMomentLike(momentID, like, add: true);
            listener?.momentLiked(like);
          }
        case 'moment_unliked':
          final momentID = data['momentID'] as String? ?? '';
          final userID = data['userID'] as String? ?? '';
          if (momentID.isNotEmpty) {
            await _updateLocalMomentLike(
              momentID,
              MomentLikeWithUser(momentID: momentID, userID: userID, createTime: ''),
              add: false,
            );
            listener?.momentUnliked(momentID, userID);
          }
        case 'moment_commented':
          if (data['comment'] is Map<String, dynamic>) {
            final comment = MomentCommentWithUser.fromJson(data['comment'] as Map<String, dynamic>);
            final momentID = data['momentID'] as String? ?? '';
            if (momentID.isNotEmpty) {
              await _updateLocalMomentComment(momentID, comment, add: true);
            }
            listener?.momentCommented(comment);
          }
        case 'moment_comment_deleted':
          final commentID = data['commentID'] as String? ?? '';
          final momentID = data['momentID'] as String? ?? '';
          if (commentID.isNotEmpty && momentID.isNotEmpty) {
            await _updateLocalMomentComment(momentID, null, add: false, removeCommentID: commentID);
          }
          if (commentID.isNotEmpty) {
            listener?.momentCommentDeleted(commentID);
          }
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'handleNotification');
      rethrow;
    }
  }

  /// 全量同步第一页数据到本地（由 MsgSyncer 在 doConnectedSync 中调用）
  Future<void> syncFromServer() async {
    _log.info('开始同步朋友圈', methodName: 'syncFromServer');
    try {
      await fetchMomentListFromServer(pageNumber: 1, showNumber: 50);
      _log.info('朋友圈同步完成', methodName: 'syncFromServer');
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'syncFromServer');
    }
  }
}
