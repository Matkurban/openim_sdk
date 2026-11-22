import 'dart:convert';

import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../listener/favorite_listener.dart';
import '../models/api_response.dart';
import '../models/favorite_item.dart';
import '../models/favorite_list_response.dart';
import '../models/favorite_type.dart';
import '../models/link_info.dart';
import '../models/message.dart';
import '../models/moment_comment.dart';
import '../models/moment_info.dart';
import '../models/note_info.dart';

/// 收藏夹管理器（继承 [BaseManager]）。
final class FavoriteManager extends BaseManager<OnFavoriteListener> {
  final SdkContext _context;

  FavoriteManager({required this._context}) : super('FavoriteManager');

  void setFavoriteListener(OnFavoriteListener listener) {
    setPrimaryListener(listener);
  }

  Future<FavoriteItem?> addFavorite({
    required FavoriteType type,
    required String targetID,
    String? data,
  }) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/favorite/add',
      data: <String, dynamic>{'targetType': type.value, 'targetID': targetID, 'data': data},
    );
    if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
      logger.warning('addFavorite failed: ${resp.errMsg}');
      return null;
    }
    final Map<String, dynamic> map = resp.data as Map<String, dynamic>;
    final Map<String, dynamic> rawItem = (map['favorite'] as Map<String, dynamic>?) ?? map;
    final FavoriteItem item = FavoriteItem.fromJson(rawItem);
    await _context.db.social.upsertFavorite(item);
    listener?.favoriteAdded(item);
    return item;
  }

  Future<bool> removeFavorite({required FavoriteType type, required String targetID}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/favorite/remove',
      data: <String, dynamic>{'targetType': type.value, 'targetID': targetID},
    );
    if (!resp.isSuccess) {
      return false;
    }
    await _context.db.social.deleteFavoriteByTarget(type.value, targetID);
    listener?.favoriteRemoved(type.value, targetID);
    return true;
  }

  Future<FavoriteListResponse> getFavoriteList({int pageNumber = 1, int showNumber = 20}) async {
    final int offset = (pageNumber - 1) * showNumber;
    final List<FavoriteItem> local = await _context.db.social.getFavorites(
      offset: offset,
      count: showNumber,
    );
    if (local.isNotEmpty) {
      return FavoriteListResponse(total: local.length, favorites: local);
    }
    return fetchFavoriteListFromServer(pageNumber: pageNumber, showNumber: showNumber);
  }

  Future<FavoriteListResponse> fetchFavoriteListFromServer({
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/favorite/list',
      data: <String, dynamic>{'pageNumber': pageNumber, 'showNumber': showNumber},
    );
    if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
      return const FavoriteListResponse(total: 0, favorites: <FavoriteItem>[]);
    }
    final FavoriteListResponse result = FavoriteListResponse.fromJson(
      resp.data as Map<String, dynamic>,
    );
    if (result.favorites.isNotEmpty) {
      await _context.db.social.batchUpsertFavorites(result.favorites);
    }
    return result;
  }

  Future<bool> isFavorited({required FavoriteType type, required String targetID}) async {
    final FavoriteItem? item = await _context.db.social.getFavoriteByTarget(type.value, targetID);
    return item != null;
  }

  Future<bool> isMessageFavorited(String clientMsgID) =>
      isFavorited(type: FavoriteType.message, targetID: clientMsgID);

  Future<bool> isMomentFavorited(String momentID) =>
      isFavorited(type: FavoriteType.momentContent, targetID: momentID);

  Future<FavoriteItem?> addMessage({required Message message}) => addFavorite(
    type: FavoriteType.message,
    targetID: message.clientMsgID ?? '',
    data: jsonEncode(message.toJson()),
  );

  Future<bool> removeMessage({required String clientMsgID}) =>
      removeFavorite(type: FavoriteType.message, targetID: clientMsgID);

  Future<FavoriteItem?> addMoment({required MomentInfo moment}) => addFavorite(
    type: FavoriteType.momentContent,
    targetID: moment.momentID,
    data: jsonEncode(moment.toJson()),
  );

  Future<bool> removeMoment({required String momentID}) =>
      removeFavorite(type: FavoriteType.momentContent, targetID: momentID);

  Future<FavoriteItem?> addMomentComment({required MomentCommentWithUser comment}) => addFavorite(
    type: FavoriteType.momentComment,
    targetID: comment.commentID,
    data: jsonEncode(comment.toJson()),
  );

  Future<bool> removeMomentComment({required String commentID}) =>
      removeFavorite(type: FavoriteType.momentComment, targetID: commentID);

  Future<FavoriteItem?> addNote({required String title, required String content}) {
    final String noteID = 'note_${DateTime.now().millisecondsSinceEpoch}';
    final NoteInfo note = NoteInfo(
      noteID: noteID,
      summary: title,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
    );
    return addFavorite(type: FavoriteType.note, targetID: noteID, data: jsonEncode(note.toJson()));
  }

  Future<FavoriteItem?> updateFavorite({
    required FavoriteType type,
    required String targetID,
    required String data,
  }) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      '/favorite/update',
      data: <String, dynamic>{'targetType': type.value, 'targetID': targetID, 'data': data},
    );
    if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
      return null;
    }
    final Map<String, dynamic> map = resp.data as Map<String, dynamic>;
    final Map<String, dynamic> rawItem = (map['favorite'] as Map<String, dynamic>?) ?? map;
    final FavoriteItem item = FavoriteItem.fromJson(rawItem);
    await _context.db.social.upsertFavorite(item);
    return item;
  }

  Future<FavoriteItem?> updateNote({
    required String targetID,
    required String title,
    required String content,
  }) {
    final NoteInfo note = NoteInfo(
      noteID: targetID,
      summary: title,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
    );
    return updateFavorite(
      type: FavoriteType.note,
      targetID: targetID,
      data: jsonEncode(note.toJson()),
    );
  }

  Future<FavoriteItem?> addLink({required LinkInfo link}) =>
      addFavorite(type: FavoriteType.link, targetID: link.url, data: jsonEncode(link.toJson()));

  Future<bool> removeFavoriteItem(FavoriteItem item) =>
      removeFavorite(type: FavoriteType.fromValue(item.targetType), targetID: item.targetID);

  Future<void> handleNotification(String key, Map<String, dynamic> data) async {
    try {
      if (key == 'favorite_added') {
        final FavoriteItem item = FavoriteItem.fromJson(data);
        await _context.db.social.upsertFavorite(item);
        listener?.favoriteAdded(item);
      } else if (key == 'favorite_removed') {
        final String targetType = data['targetType']?.toString() ?? '';
        final String targetID = data['targetID']?.toString() ?? '';
        if (targetType.isNotEmpty && targetID.isNotEmpty) {
          await _context.db.social.deleteFavoriteByTarget(targetType, targetID);
          listener?.favoriteRemoved(targetType, targetID);
        }
      }
    } on Object catch (error, stackTrace) {
      logger.warning('handleNotification($key) failed', error, stackTrace);
    }
  }

  Future<void> syncFromServer() async {
    await fetchFavoriteListFromServer(pageNumber: 1, showNumber: 20);
  }
}
