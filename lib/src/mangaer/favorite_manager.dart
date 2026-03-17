import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:openim_sdk/src/logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/network/http_client.dart';
import 'package:openim_sdk/src/services/database_service.dart';

/// 收藏夹管理器
///
/// 支持收藏消息、朋友圈内容/评论、图片、视频、笔记等。
/// 采用 local-first + network-sync 混合架构：
/// - 读取：优先返回本地数据，后台异步拉取最新
/// - 写入：先发网络请求，成功后写入本地 + 触发 listener
class FavoriteManager {
  static final Logger _log = Logger('FavoriteManager');

  final GetIt _getIt = GetIt.instance;

  OnFavoriteListener? listener;

  late String _currentUserID;

  /// 当前登录用户 ID
  String get currentUserID => _currentUserID;

  void setFavoriteListener(OnFavoriteListener listener) {
    this.listener = listener;
  }

  @internal
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  DatabaseService get _database {
    return _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  // ---------------------------------------------------------------------------
  // 内部 HTTP
  // ---------------------------------------------------------------------------

  String get _chatAddr {
    final config = _getIt.get<InitConfig>(instanceName: InstanceName.initConfig);
    final addr = config.authAddr;
    if (addr == null || addr.isEmpty) {
      throw Exception('chatAddr 未配置');
    }
    return addr;
  }

  Future<ApiResponse> _post(String path, Map<String, dynamic> data) async {
    _log.info('path=$path', methodName: '_post');
    final dio = Dio(
      BaseOptions(
        baseUrl: _chatAddr,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          if (HttpClient().token != null) 'token': HttpClient().token,
          'operationID': OpenImUtils.generateOperationID(operationName: 'favorite'),
        },
      ),
    );
    try {
      final response = await dio.post(path, data: data);
      return ApiResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_post');
      if (e is DioException) {
        return ApiResponse(
          errCode: -1,
          errMsg: e.message ?? 'network error',
          errDlt: '',
          data: null,
        );
      }
      return ApiResponse(errCode: -1, errMsg: e.toString(), errDlt: '', data: null);
    } finally {
      dio.close();
    }
  }

  // ---------------------------------------------------------------------------
  // 通用收藏
  // ---------------------------------------------------------------------------

  /// 添加收藏
  Future<FavoriteItem?> addFavorite({
    required FavoriteType type,
    required String targetID,
    String? data,
  }) async {
    _log.info('type=${type.value}, id=$targetID', methodName: 'addFavorite');
    try {
      final resp = await _post('/favorite/add', {
        'targetType': type.value,
        'targetID': targetID,
        'data': data,
      });
      if (!resp.isSuccess) {
        _log.warning('addFavorite failed: ${resp.errMsg}');
        return null;
      }
      if (resp.data is Map<String, dynamic>) {
        final dataMap = resp.data as Map<String, dynamic>;
        if (dataMap['favorite'] is Map<String, dynamic>) {
          final item = FavoriteItem.fromJson(dataMap['favorite'] as Map<String, dynamic>);
          await _database.upsertFavorite(item);
          listener?.favoriteAdded(item);
          return item;
        }
      }
      return null;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addFavorite');
      rethrow;
    }
  }

  /// 移除收藏
  Future<bool> removeFavorite({required FavoriteType type, required String targetID}) async {
    _log.info('type=${type.value}, id=$targetID', methodName: 'removeFavorite');
    try {
      final resp = await _post('/favorite/remove', {
        'targetType': type.value,
        'targetID': targetID,
      });
      if (resp.isSuccess) {
        await _database.deleteFavoriteByTarget(type.value, targetID);
        listener?.favoriteRemoved(type.value, targetID);
        return true;
      }
      _log.warning('removeFavorite failed: ${resp.errMsg}');
      return false;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'removeFavorite');
      rethrow;
    }
  }

  /// 获取收藏列表（local-first）
  ///
  /// 优先返回本地数据；同时后台拉取网络最新并更新本地。
  Future<FavoriteListResponse> getFavoriteList({int pageNumber = 1, int showNumber = 20}) async {
    _log.info('page=$pageNumber, size=$showNumber', methodName: 'getFavoriteList');
    try {
      final offset = (pageNumber - 1) * showNumber;
      final localItems = await _database.getFavorites(offset: offset, count: showNumber);

      // 后台异步刷新
      _fetchAndCacheFavorites(pageNumber: pageNumber, showNumber: showNumber);

      return FavoriteListResponse(total: localItems.length, favorites: localItems);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getFavoriteList');
      rethrow;
    }
  }

  /// 仅从网络获取（强制刷新）
  Future<FavoriteListResponse> fetchFavoriteListFromServer({
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    _log.info('page=$pageNumber, size=$showNumber', methodName: 'fetchFavoriteListFromServer');
    try {
      final resp = await _post('/favorite/list', {
        'pageNumber': pageNumber,
        'showNumber': showNumber,
      });
      if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
        return FavoriteListResponse.empty();
      }
      final response = FavoriteListResponse.fromJson(resp.data as Map<String, dynamic>);
      if (response.favorites.isNotEmpty) {
        await _database.batchUpsertFavorites(response.favorites);
      }
      return response;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'fetchFavoriteListFromServer');
      rethrow;
    }
  }

  Future<void> _fetchAndCacheFavorites({int pageNumber = 1, int showNumber = 20}) async {
    _log.info('page=$pageNumber, size=$showNumber', methodName: '_fetchAndCacheFavorites');
    try {
      final resp = await _post('/favorite/list', {
        'pageNumber': pageNumber,
        'showNumber': showNumber,
      });
      if (!resp.isSuccess || resp.data is! Map<String, dynamic>) return;
      final response = FavoriteListResponse.fromJson(resp.data as Map<String, dynamic>);
      if (response.favorites.isNotEmpty) {
        await _database.batchUpsertFavorites(response.favorites);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_fetchAndCacheFavorites');
    }
  }

  /// 检查是否已收藏
  Future<bool> isFavorited({required FavoriteType type, required String targetID}) async {
    _log.info('type=${type.value}, id=$targetID', methodName: 'isFavorited');
    try {
      final item = await _database.getFavoriteByTarget(type.value, targetID);
      return item != null;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'isFavorited');
      rethrow;
    }
  }

  /// 检查消息是否已收藏
  Future<bool> isMessageFavorited(String clientMsgID) async {
    _log.info('clientMsgID=$clientMsgID', methodName: 'isMessageFavorited');
    try {
      return isFavorited(type: FavoriteType.message, targetID: clientMsgID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'isMessageFavorited');
      rethrow;
    }
  }

  /// 检查朋友圈动态是否已收藏
  Future<bool> isMomentFavorited(String momentID) async {
    _log.info('momentID=$momentID', methodName: 'isMomentFavorited');
    try {
      return isFavorited(type: FavoriteType.momentContent, targetID: momentID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'isMomentFavorited');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 便捷方法 —— 收藏消息
  // ---------------------------------------------------------------------------

  /// 收藏一条聊天消息
  Future<FavoriteItem?> addMessage({required Message message}) async {
    _log.info('called', methodName: 'addMessage');
    try {
      final clientMsgID = message.clientMsgID;
      if (clientMsgID == null || clientMsgID.isEmpty) return null;
      final data = jsonEncode(message.toJson());
      return addFavorite(type: FavoriteType.message, targetID: clientMsgID, data: data);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addMessage');
      rethrow;
    }
  }

  /// 取消收藏消息
  Future<bool> removeMessage({required String clientMsgID}) async {
    _log.info('clientMsgID=$clientMsgID', methodName: 'removeMessage');
    try {
      return removeFavorite(type: FavoriteType.message, targetID: clientMsgID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'removeMessage');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 便捷方法 —— 收藏朋友圈
  // ---------------------------------------------------------------------------

  /// 收藏朋友圈动态
  Future<FavoriteItem?> addMoment({required MomentInfo moment}) async {
    _log.info('called', methodName: 'addMoment');
    try {
      final data = jsonEncode(moment.toJson());
      return addFavorite(type: FavoriteType.momentContent, targetID: moment.momentID, data: data);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addMoment');
      rethrow;
    }
  }

  /// 取消收藏朋友圈动态
  Future<bool> removeMoment({required String momentID}) async {
    _log.info('momentID=$momentID', methodName: 'removeMoment');
    try {
      return removeFavorite(type: FavoriteType.momentContent, targetID: momentID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'removeMoment');
      rethrow;
    }
  }

  /// 收藏朋友圈评论
  Future<FavoriteItem?> addMomentComment({required MomentCommentWithUser comment}) async {
    _log.info('called', methodName: 'addMomentComment');
    try {
      final data = jsonEncode(comment.toJson());
      return addFavorite(type: FavoriteType.momentComment, targetID: comment.commentID, data: data);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addMomentComment');
      rethrow;
    }
  }

  /// 取消收藏朋友圈评论
  Future<bool> removeMomentComment({required String commentID}) async {
    _log.info('commentID=$commentID', methodName: 'removeMomentComment');
    try {
      return removeFavorite(type: FavoriteType.momentComment, targetID: commentID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'removeMomentComment');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 便捷方法 —— 收藏笔记
  // ---------------------------------------------------------------------------

  /// 添加笔记到收藏
  Future<FavoriteItem?> addNote({required String title, required String content}) async {
    _log.info('called', methodName: 'addNote');
    try {
      final noteID = 'note_${DateTime.now().millisecondsSinceEpoch}';
      final data = jsonEncode({
        'noteID': noteID,
        'summary': title,
        'content': content,
        'createdAt': DateTime.now().toIso8601String(),
      });
      return addFavorite(type: FavoriteType.note, targetID: noteID, data: data);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addNote');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 便捷方法 —— 收藏链接
  // ---------------------------------------------------------------------------

  /// 收藏链接
  Future<FavoriteItem?> addLink({required LinkInfo link}) async {
    _log.info('called', methodName: 'addLink');
    try {
      final data = jsonEncode(link.toJson());
      return addFavorite(type: FavoriteType.link, targetID: link.url, data: data);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addLink');
      rethrow;
    }
  }

  /// 移除收藏项
  Future<bool> removeFavoriteItem(FavoriteItem item) async {
    _log.info('called', methodName: 'removeFavoriteItem');
    try {
      return removeFavorite(type: item.favoriteType, targetID: item.targetID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'removeFavoriteItem');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // WS 通知处理（由 NotificationDispatcher 调用）
  // ---------------------------------------------------------------------------

  /// 处理来自 WS 的收藏夹业务通知
  Future<void> handleNotification(String key, Map<String, dynamic> data) async {
    _log.info('key=$key', methodName: 'handleNotification');
    try {
      switch (key) {
        case 'favorite_added':
          if (data['favorite'] is Map<String, dynamic>) {
            final item = FavoriteItem.fromJson(data['favorite'] as Map<String, dynamic>);
            await _database.upsertFavorite(item);
            listener?.favoriteAdded(item);
          }
        case 'favorite_removed':
          final targetType = data['targetType'] as String? ?? '';
          final targetID = data['targetID'] as String? ?? '';
          if (targetType.isNotEmpty && targetID.isNotEmpty) {
            await _database.deleteFavoriteByTarget(targetType, targetID);
            listener?.favoriteRemoved(targetType, targetID);
          }
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'handleNotification');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 全量同步（登录 / 重连时调用）
  // ---------------------------------------------------------------------------

  /// 全量同步到本地（由 MsgSyncer 在 doConnectedSync 中调用）
  Future<void> syncFromServer() async {
    _log.info('开始同步收藏夹', methodName: 'syncFromServer');
    try {
      int page = 1;
      const pageSize = 100;
      while (true) {
        final resp = await fetchFavoriteListFromServer(pageNumber: page, showNumber: pageSize);
        if (resp.favorites.length < pageSize) break;
        page++;
      }
      _log.info('收藏夹同步完成', methodName: 'syncFromServer');
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'syncFromServer');
    }
  }
}
