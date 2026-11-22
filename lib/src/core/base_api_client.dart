import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../models/api_response.dart';
import '../network/http_client.dart';

/// 所有服务端 REST API 客户端的抽象基类。
///
/// Abstract base class for all server REST API clients.
///
/// 统一封装 IM / Chat / Admin 三条通道请求、分页参数防除零保护与异常日志记录。
/// Unifies IM, Chat, and Admin channel requests, division-by-zero safe pagination,
/// and structured error logging.
abstract base class BaseApiClient {
  final HttpClient _httpClient;
  final Logger _logger;

  /// 创建 API 客户端基类实例。
  ///
  /// Creates a [BaseApiClient] instance.
  ///
  /// - [_httpClient] 底层统一 HTTP 客户端 / Underlying shared HTTP client.
  /// - [name] 模块名称，用于日志标识 / Module name used for logging.
  BaseApiClient({required this._httpClient, required String name})
    : _logger = Logger('openim_sdk.$name');

  /// 底层 HTTP 客户端实例。
  ///
  /// Underlying [HttpClient] instance.
  @protected
  HttpClient get httpClient => _httpClient;

  /// 当前客户端日志器。
  ///
  /// Logger instance for this API client.
  @protected
  Logger get logger => _logger;

  /// 安全构建 OpenIM 分页参数，彻底防止 `count <= 0` 触发除零异常。
  ///
  /// Safely builds OpenIM pagination parameters while preventing division-by-zero when `count <= 0`.
  ///
  /// - [offset] 起始偏移量（小于 0 时按 0 处理） / Starting offset (clamped to `0` if negative).
  /// - [count] 每页条数（小于等于 0 时默认回退为 40） / Page size (defaults to `40` if `<= 0`).
  /// - Returns: 包含 `pageNumber` 与 `showNumber` 的分页字典 / Map containing `pageNumber` and `showNumber`.
  @protected
  Map<String, int> buildPagination({required int offset, required int count}) {
    final int safeCount = count <= 0 ? 40 : count;
    final int safeOffset = offset < 0 ? 0 : offset;
    final int pageNumber = (safeOffset ~/ safeCount) + 1;
    return <String, int>{'pageNumber': pageNumber, 'showNumber': safeCount};
  }

  /// 发起 IM 服务端 POST 请求。
  ///
  /// Sends a POST request to the IM server.
  ///
  /// - [path] 接口相对路径 / Endpoint relative path.
  /// - [data] 请求体 JSON 数据 / Optional JSON request body.
  /// - Returns: 统一解析后的 [ApiResponse] / Parsed [ApiResponse].
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
  ///
  /// Sends a POST request to the Chat server.
  ///
  /// - [path] 接口相对路径 / Endpoint relative path.
  /// - [data] 请求体 JSON 数据 / Optional JSON request body.
  /// - Returns: 统一解析后的 [ApiResponse] / Parsed [ApiResponse].
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
  ///
  /// Sends a POST request to the Admin server.
  ///
  /// - [path] 接口相对路径 / Endpoint relative path.
  /// - [data] 请求体 JSON 数据 / Optional JSON request body.
  /// - Returns: 统一解析后的 [ApiResponse] / Parsed [ApiResponse].
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
