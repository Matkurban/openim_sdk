import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../listener/moments_listener.dart';
import '../models/api_response.dart';
import '../models/moment_comment.dart';
import '../models/moment_create_req.dart';
import '../models/moment_info.dart';
import '../models/moment_like.dart';
import '../models/moment_list_response.dart';

/// 朋友圈动态管理器（继承 [BaseManager]）。
final class MomentsManager extends BaseManager<OnMomentsListener> {
  final SdkContext _context;

  MomentsManager({required this._context}) : super('MomentsManager');

  void setMomentsListener(OnMomentsListener listener) {
    setPrimaryListener(listener);
  }

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
    listener?.momentPublished(moment);
    return moment;
  }

  Future<bool> deleteMoment({required String momentID}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/delete',
      data: <String, dynamic>{'momentID': momentID},
    );
    if (!resp.isSuccess) {
      return false;
    }
    await _context.db.social.deleteMoment(momentID);
    listener?.momentDeleted(momentID);
    return true;
  }

  Future<MomentListResponse> getMomentList({
    String? ownerUserID,
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    final int offset = (pageNumber - 1) * showNumber;
    final List<MomentInfo> local = (ownerUserID != null && ownerUserID.isNotEmpty)
        ? await _context.db.social.getMomentsByUserID(
            ownerUserID,
            offset: offset,
            count: showNumber,
          )
        : await _context.db.social.getMoments(offset: offset, count: showNumber);
    if (local.isNotEmpty) {
      return MomentListResponse(total: local.length, moments: local);
    }
    return fetchMomentListFromServer(
      ownerUserID: ownerUserID,
      pageNumber: pageNumber,
      showNumber: showNumber,
    );
  }

  Future<MomentListResponse> fetchMomentListFromServer({
    String? ownerUserID,
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/list',
      data: <String, dynamic>{
        if (ownerUserID != null && ownerUserID.isNotEmpty) 'ownerUserID': ownerUserID,
        'pagination': <String, int>{'pageNumber': pageNumber, 'showNumber': showNumber},
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

  Future<bool> likeMoment({required String momentID, String? ownerUserID}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/like',
      data: <String, dynamic>{'momentID': momentID, 'ownerUserID': ?ownerUserID},
    );
    return resp.isSuccess;
  }

  Future<bool> unlikeMoment({required String momentID, String? ownerUserID}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/unlike',
      data: <String, dynamic>{'momentID': momentID, 'ownerUserID': ?ownerUserID},
    );
    return resp.isSuccess;
  }

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
    listener?.momentCommented(comment);
    return comment;
  }

  Future<bool> deleteComment({required String commentID, String? momentID}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/moment/delete_comment',
      data: <String, dynamic>{'commentID': commentID},
    );
    if (!resp.isSuccess) {
      return false;
    }
    listener?.momentCommentDeleted(commentID);
    return true;
  }

  Future<void> handleNotification(String key, Map<String, dynamic> data) async {
    try {
      switch (key) {
        case 'moment_published':
          final MomentInfo moment = MomentInfo.fromJson(data);
          await _context.db.social.upsertMoment(moment);
          listener?.momentPublished(moment);
        case 'moment_deleted':
          final String id = data['momentID']?.toString() ?? '';
          if (id.isNotEmpty) {
            await _context.db.social.deleteMoment(id);
            listener?.momentDeleted(id);
          }
        case 'moment_liked':
          final MomentLikeWithUser like = MomentLikeWithUser.fromJson(data);
          listener?.momentLiked(like);
        case 'moment_unliked':
          final String momentID = data['momentID']?.toString() ?? '';
          final String userID = data['userID']?.toString() ?? '';
          if (momentID.isNotEmpty) {
            listener?.momentUnliked(momentID, userID);
          }
        case 'moment_commented':
          final MomentCommentWithUser comment = MomentCommentWithUser.fromJson(data);
          listener?.momentCommented(comment);
        case 'moment_comment_deleted':
          final String commentID = data['commentID']?.toString() ?? '';
          if (commentID.isNotEmpty) {
            listener?.momentCommentDeleted(commentID);
          }
      }
    } on Object catch (error, stackTrace) {
      logger.warning('handleNotification($key) failed', error, stackTrace);
    }
  }

  Future<void> syncFromServer() async {
    await fetchMomentListFromServer(pageNumber: 1, showNumber: 20);
  }
}
