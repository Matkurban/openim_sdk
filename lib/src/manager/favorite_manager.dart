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

  /// 创建 `FavoriteManager` 实例。
  ///
  /// Creates a `FavoriteManager` instance.
  ///
  /// - [_context] context / Context.
  FavoriteManager({required this._context}) : super('FavoriteManager');

  /// 设置收藏监听器。
  ///
  /// Set favorite listener.
  ///
  /// - [listener] 监听器 / Listener.
  void setFavoriteListener(OnFavoriteListener listener) {
    setPrimaryListener(listener);
  }

  /// 添加收藏。
  ///
  /// Add favorite.
  ///
  /// - [type] 类型 / Type.
  /// - [targetID] 目标ID / Target ID.
  /// - [data] 数据 / Data.
  /// - Returns: `Future<FavoriteItem?>` 结果 / Resulting `Future<FavoriteItem?>`.
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

  /// 移除收藏。
  ///
  /// Remove favorite.
  ///
  /// - [type] 类型 / Type.
  /// - [targetID] 目标ID / Target ID.
  /// - Returns: 操作结果布尔值 / Boolean result.
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

  /// 获取收藏列表。
  ///
  /// Get favorite list.
  ///
  /// - [pageNumber] 分页号码 / Paged number.
  /// - [showNumber] 展示号码 / Display number.
  /// - Returns: `Future<FavoriteListResponse>` 结果 / Resulting `Future<FavoriteListResponse>`.
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

  /// 拉取收藏列表从服务端。
  ///
  /// Fetch favorite list from server.
  ///
  /// - [pageNumber] 分页号码 / Paged number.
  /// - [showNumber] 展示号码 / Display number.
  /// - Returns: `Future<FavoriteListResponse>` 结果 / Resulting `Future<FavoriteListResponse>`.
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

  /// 是否已收藏。
  ///
  /// Whether favorited.
  ///
  /// - [type] 类型 / Type.
  /// - [targetID] 目标ID / Target ID.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> isFavorited({required FavoriteType type, required String targetID}) async {
    final FavoriteItem? item = await _context.db.social.getFavoriteByTarget(type.value, targetID);
    return item != null;
  }

  /// 是否消息已收藏。
  ///
  /// Whether message favorited.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> isMessageFavorited(String clientMsgID) =>
      isFavorited(type: FavoriteType.message, targetID: clientMsgID);

  /// 是否朋友圈动态已收藏。
  ///
  /// Whether moment favorited.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> isMomentFavorited(String momentID) =>
      isFavorited(type: FavoriteType.momentContent, targetID: momentID);

  /// 添加消息。
  ///
  /// Add message.
  ///
  /// - [message] 消息 / Message.
  /// - Returns: `Future<FavoriteItem?>` 结果 / Resulting `Future<FavoriteItem?>`.
  Future<FavoriteItem?> addMessage({required Message message}) => addFavorite(
    type: FavoriteType.message,
    targetID: message.clientMsgID ?? '',
    data: jsonEncode(message.toJson()),
  );

  /// 移除消息。
  ///
  /// Remove message.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> removeMessage({required String clientMsgID}) =>
      removeFavorite(type: FavoriteType.message, targetID: clientMsgID);

  /// 添加朋友圈动态。
  ///
  /// Add moment.
  ///
  /// - [moment] 朋友圈动态 / Moment.
  /// - Returns: `Future<FavoriteItem?>` 结果 / Resulting `Future<FavoriteItem?>`.
  Future<FavoriteItem?> addMoment({required MomentInfo moment}) => addFavorite(
    type: FavoriteType.momentContent,
    targetID: moment.momentID,
    data: jsonEncode(moment.toJson()),
  );

  /// 移除朋友圈动态。
  ///
  /// Remove moment.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> removeMoment({required String momentID}) =>
      removeFavorite(type: FavoriteType.momentContent, targetID: momentID);

  /// 添加朋友圈动态评论。
  ///
  /// Add moment comment.
  ///
  /// - [comment] 评论 / Comment.
  /// - Returns: `Future<FavoriteItem?>` 结果 / Resulting `Future<FavoriteItem?>`.
  Future<FavoriteItem?> addMomentComment({required MomentCommentWithUser comment}) => addFavorite(
    type: FavoriteType.momentComment,
    targetID: comment.commentID,
    data: jsonEncode(comment.toJson()),
  );

  /// 移除朋友圈动态评论。
  ///
  /// Remove moment comment.
  ///
  /// - [commentID] 评论ID / Comment ID.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> removeMomentComment({required String commentID}) =>
      removeFavorite(type: FavoriteType.momentComment, targetID: commentID);

  /// 添加笔记。
  ///
  /// Add note.
  ///
  /// - [title] 标题 / Title.
  /// - [content] 内容 / Content.
  /// - Returns: `Future<FavoriteItem?>` 结果 / Resulting `Future<FavoriteItem?>`.
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

  /// 更新收藏。
  ///
  /// Update favorite.
  ///
  /// - [type] 类型 / Type.
  /// - [targetID] 目标ID / Target ID.
  /// - [data] 数据 / Data.
  /// - Returns: `Future<FavoriteItem?>` 结果 / Resulting `Future<FavoriteItem?>`.
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

  /// 更新笔记。
  ///
  /// Update note.
  ///
  /// - [targetID] 目标ID / Target ID.
  /// - [title] 标题 / Title.
  /// - [content] 内容 / Content.
  /// - Returns: `Future<FavoriteItem?>` 结果 / Resulting `Future<FavoriteItem?>`.
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

  /// 添加链接。
  ///
  /// Add link.
  ///
  /// - [link] 链接 / Link.
  /// - Returns: `Future<FavoriteItem?>` 结果 / Resulting `Future<FavoriteItem?>`.
  Future<FavoriteItem?> addLink({required LinkInfo link}) =>
      addFavorite(type: FavoriteType.link, targetID: link.url, data: jsonEncode(link.toJson()));

  /// 移除收藏Item。
  ///
  /// Remove favorite item.
  ///
  /// - [item] item / Item.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> removeFavoriteItem(FavoriteItem item) =>
      removeFavorite(type: FavoriteType.fromValue(item.targetType), targetID: item.targetID);

  /// 处理通知。
  ///
  /// Handle notification.
  ///
  /// - [key] 键名 / Key.
  /// - [data] 数据 / Data.
  Future<void> handleNotification(String key, Map<String, dynamic> data) async {
    try {
      if (key == 'favorite_added') {
        final Map<String, dynamic> rawItem = (data['favorite'] as Map<String, dynamic>?) ?? data;
        final FavoriteItem item = FavoriteItem.fromJson(rawItem);
        await _context.db.social.upsertFavorite(item);
        listener?.favoriteAdded(item);
      } else if (key == 'favorite_updated') {
        final Map<String, dynamic> rawItem = (data['favorite'] as Map<String, dynamic>?) ?? data;
        final FavoriteItem item = FavoriteItem.fromJson(rawItem);
        await _context.db.social.upsertFavorite(item);
        listener?.favoriteUpdated(item);
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

  /// 同步从服务端。
  ///
  /// Sync from server.
  Future<void> syncFromServer() async {
    await fetchFavoriteListFromServer(pageNumber: 1, showNumber: 20);
  }
}
