import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/listener/favorite_listener.dart';
import 'package:openim_sdk/src/models/api_response.dart';
import 'package:openim_sdk/src/models/favorite_item.dart';
import 'package:openim_sdk/src/models/favorite_list_response.dart';
import 'package:openim_sdk/src/models/init_config.dart';
import 'package:openim_sdk/src/network/http_client.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/utils/im_utils.dart';

/// 收藏类型常量
sealed class FavoriteType {
  static const String message = 'message';
  static const String momentContent = 'moment_content';
  static const String momentComment = 'moment_comment';
  static const String image = 'image';
  static const String video = 'video';
  static const String audio = 'audio';
  static const String file = 'file';
  static const String link = 'link';
  static const String note = 'note';
}

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

  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  DatabaseService get _db =>
      _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);

  // ---------------------------------------------------------------------------
  // 内部 HTTP
  // ---------------------------------------------------------------------------

  String get _chatAddr {
    final config = _getIt.get<InitConfig>(instanceName: InstanceName.initConfig);
    final addr = config.chatAddr;
    if (addr == null || addr.isEmpty) {
      throw Exception('chatAddr 未配置');
    }
    return addr;
  }

  Future<ApiResponse> _post(String path, Map<String, dynamic> data) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: _chatAddr,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {
          if (HttpClient().token != null) 'token': HttpClient().token,
          'operationID': ImUtils.generateOperationID(operationName: 'favorite'),
        },
      ),
    );
    try {
      final response = await dio.post(path, data: data);
      return ApiResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _log.severe('FavoriteManager POST $path failed: ${e.message}');
      return ApiResponse(errCode: -1, errMsg: e.message ?? 'network error', errDlt: '', data: null);
    } finally {
      dio.close();
    }
  }

  // ---------------------------------------------------------------------------
  // 通用收藏
  // ---------------------------------------------------------------------------

  /// 添加收藏
  Future<FavoriteItem?> addFavorite({
    required String targetType,
    required String targetID,
    String? data,
  }) async {
    _log.info('addFavorite: type=$targetType, id=$targetID');
    final resp = await _post('/favorite/add', {
      'targetType': targetType,
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
        await _db.upsertFavorite(item);
        listener?.favoriteAdded(item);
        return item;
      }
    }
    return null;
  }

  /// 移除收藏
  Future<bool> removeFavorite({required String targetType, required String targetID}) async {
    _log.info('removeFavorite: type=$targetType, id=$targetID');
    final resp = await _post('/favorite/remove', {'targetType': targetType, 'targetID': targetID});
    if (resp.isSuccess) {
      await _db.deleteFavoriteByTarget(targetType, targetID);
      listener?.favoriteRemoved(targetType, targetID);
      return true;
    }
    _log.warning('removeFavorite failed: ${resp.errMsg}');
    return false;
  }

  /// 获取收藏列表（local-first）
  ///
  /// 优先返回本地数据；同时后台拉取网络最新并更新本地。
  Future<FavoriteListResponse> getFavoriteList({int pageNumber = 1, int showNumber = 20}) async {
    _log.info('getFavoriteList: page=$pageNumber, size=$showNumber');
    final offset = (pageNumber - 1) * showNumber;
    final localItems = await _db.getFavorites(offset: offset, count: showNumber);

    // 后台异步刷新
    _fetchAndCacheFavorites(pageNumber: pageNumber, showNumber: showNumber);

    return FavoriteListResponse(total: localItems.length, favorites: localItems);
  }

  /// 仅从网络获取（强制刷新）
  Future<FavoriteListResponse> fetchFavoriteListFromServer({
    int pageNumber = 1,
    int showNumber = 20,
  }) async {
    final resp = await _post('/favorite/list', {
      'pageNumber': pageNumber,
      'showNumber': showNumber,
    });
    if (!resp.isSuccess || resp.data is! Map<String, dynamic>) {
      return FavoriteListResponse.empty();
    }
    final response = FavoriteListResponse.fromJson(resp.data as Map<String, dynamic>);
    if (response.favorites.isNotEmpty) {
      await _db.batchUpsertFavorites(response.favorites);
    }
    return response;
  }

  Future<void> _fetchAndCacheFavorites({int pageNumber = 1, int showNumber = 20}) async {
    try {
      final resp = await _post('/favorite/list', {
        'pageNumber': pageNumber,
        'showNumber': showNumber,
      });
      if (!resp.isSuccess || resp.data is! Map<String, dynamic>) return;
      final response = FavoriteListResponse.fromJson(resp.data as Map<String, dynamic>);
      if (response.favorites.isNotEmpty) {
        await _db.batchUpsertFavorites(response.favorites);
      }
    } catch (e) {
      _log.fine('后台同步收藏夹失败: $e');
    }
  }

  /// 检查是否已收藏
  Future<bool> isFavorited({required String targetType, required String targetID}) async {
    final item = await _db.getFavoriteByTarget(targetType, targetID);
    return item != null;
  }

  // ---------------------------------------------------------------------------
  // 便捷方法 —— 收藏消息
  // ---------------------------------------------------------------------------

  /// 收藏一条聊天消息
  Future<FavoriteItem?> addMessage({
    required String clientMsgID,
    required String conversationID,
    required int contentType,
    required String summary,
    required Map<String, dynamic> messageData,
  }) async {
    final data = jsonEncode({
      'clientMsgID': clientMsgID,
      'conversationID': conversationID,
      'contentType': contentType,
      'summary': summary,
      'messageData': messageData,
    });
    return addFavorite(targetType: FavoriteType.message, targetID: clientMsgID, data: data);
  }

  /// 取消收藏消息
  Future<bool> removeMessage({required String clientMsgID}) async {
    return removeFavorite(targetType: FavoriteType.message, targetID: clientMsgID);
  }

  // ---------------------------------------------------------------------------
  // 便捷方法 —— 收藏朋友圈内容
  // ---------------------------------------------------------------------------

  /// 收藏朋友圈动态内容
  Future<FavoriteItem?> addMomentContent({
    required String momentID,
    required String content,
    String? authorName,
    String? authorID,
  }) async {
    final data = jsonEncode({
      'momentID': momentID,
      'content': content,
      'authorName': authorName,
      'authorID': authorID,
    });
    return addFavorite(targetType: FavoriteType.momentContent, targetID: momentID, data: data);
  }

  /// 收藏朋友圈评论
  Future<FavoriteItem?> addMomentComment({
    required String commentID,
    required String momentID,
    required String content,
    String? authorName,
    String? authorID,
    String? createTime,
  }) async {
    final data = jsonEncode({
      'commentID': commentID,
      'momentID': momentID,
      'content': content,
      'authorName': authorName,
      'authorID': authorID,
      'createTime': createTime,
    });
    return addFavorite(targetType: FavoriteType.momentComment, targetID: commentID, data: data);
  }

  // ---------------------------------------------------------------------------
  // 便捷方法 —— 收藏笔记
  // ---------------------------------------------------------------------------

  /// 添加笔记到收藏
  Future<FavoriteItem?> addNote({required String title, required String content}) async {
    final noteID = 'note_${DateTime.now().millisecondsSinceEpoch}';
    final data = jsonEncode({
      'noteID': noteID,
      'summary': title,
      'content': content,
      'createdAt': DateTime.now().toIso8601String(),
    });
    return addFavorite(targetType: FavoriteType.note, targetID: noteID, data: data);
  }

  /// 移除收藏项
  Future<bool> removeFavoriteItem(FavoriteItem item) {
    return removeFavorite(targetType: item.targetType, targetID: item.targetID);
  }

  // ---------------------------------------------------------------------------
  // WS 通知处理（由 NotificationDispatcher 调用）
  // ---------------------------------------------------------------------------

  /// 处理来自 WS 的收藏夹业务通知
  Future<void> handleNotification(String key, Map<String, dynamic> data) async {
    _log.info('handleNotification: key=$key');
    switch (key) {
      case 'favorite_added':
        if (data['favorite'] is Map<String, dynamic>) {
          final item = FavoriteItem.fromJson(data['favorite'] as Map<String, dynamic>);
          await _db.upsertFavorite(item);
          listener?.favoriteAdded(item);
        }
      case 'favorite_removed':
        final targetType = data['targetType'] as String? ?? '';
        final targetID = data['targetID'] as String? ?? '';
        if (targetType.isNotEmpty && targetID.isNotEmpty) {
          await _db.deleteFavoriteByTarget(targetType, targetID);
          listener?.favoriteRemoved(targetType, targetID);
        }
    }
  }

  // ---------------------------------------------------------------------------
  // 全量同步（登录 / 重连时调用）
  // ---------------------------------------------------------------------------

  /// 全量同步到本地（由 MsgSyncer 在 doConnectedSync 中调用）
  Future<void> syncFromServer() async {
    try {
      _log.info('syncFromServer: 开始同步收藏夹');
      int page = 1;
      const pageSize = 100;
      while (true) {
        final resp = await fetchFavoriteListFromServer(pageNumber: page, showNumber: pageSize);
        if (resp.favorites.length < pageSize) break;
        page++;
      }
      _log.info('syncFromServer: 收藏夹同步完成');
    } catch (e) {
      _log.warning('syncFromServer: 收藏夹同步失败: $e');
    }
  }
}
