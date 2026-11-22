import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../models/api_response.dart';
import '../network/http_client.dart';

/// 所有服务端 REST API 客户端的抽象基类。
///
/// 统一封装 IM / Chat / Admin 三条通道请求、分页参数防除零保护与异常日志记录。
abstract base class BaseApiClient {
  final HttpClient _httpClient;
  final Logger _logger;

  BaseApiClient({required this._httpClient, required String name})
    : _logger = Logger('openim_sdk.$name');

  @protected
  HttpClient get httpClient => _httpClient;

  @protected
  Logger get logger => _logger;

  /// 安全构建 OpenIM 分页参数，彻底防止 `count <= 0` 触发除零异常。
  @protected
  Map<String, int> buildPagination({required int offset, required int count}) {
    final int safeCount = count <= 0 ? 40 : count;
    final int safeOffset = offset < 0 ? 0 : offset;
    final int pageNumber = (safeOffset ~/ safeCount) + 1;
    return <String, int>{'pageNumber': pageNumber, 'showNumber': safeCount};
  }

  /// 发起 IM 服务端 POST 请求。
  @protected
  Future<ApiResponse> postIm(String path, {Map<String, dynamic>? data}) async {
    _logger.fine('POST IM $path');
    try {
      return await _httpClient.post(path, data: data ?? const <String, dynamic>{});
    } on Object catch (error, stackTrace) {
      _logger.severe('POST IM $path failed', error, stackTrace);
      rethrow;
    }
  }

  /// 发起 Chat 服务端 POST 请求。
  @protected
  Future<ApiResponse> postChat(String path, {Map<String, dynamic>? data}) async {
    _logger.fine('POST Chat $path');
    try {
      return await _httpClient.chatPost(path, data: data ?? const <String, dynamic>{});
    } on Object catch (error, stackTrace) {
      _logger.severe('POST Chat $path failed', error, stackTrace);
      rethrow;
    }
  }

  /// 发起 Admin 服务端 POST 请求。
  @protected
  Future<ApiResponse> postAdmin(String path, {Map<String, dynamic>? data}) async {
    _logger.fine('POST Admin $path');
    try {
      return await _httpClient.adminPost(path, data: data ?? const <String, dynamic>{});
    } on Object catch (error, stackTrace) {
      _logger.severe('POST Admin $path failed', error, stackTrace);
      rethrow;
    }
  }
}
