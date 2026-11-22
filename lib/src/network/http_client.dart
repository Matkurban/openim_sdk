import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../models/api_response.dart';
import '../utils/open_im_utils.dart';

/// 封装 Dio 的统一 HTTP 客户端，管理 IM / Chat / Admin 三条通道。
///
/// 修复 B-22：
/// - 重复调用 `init()` 不再叠加 `operationID` 拦截器；
/// - HTTP 非 2xx 响应体若包含 OpenIM 业务 `errCode`（如 1501），正确解析并触发 `onApiError`。
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();

  factory HttpClient() => _instance;

  final Logger _logger = Logger('openim_sdk.HttpClient');
  late final Dio _dio;
  Dio? _chatDio;
  Dio? _adminDio;
  bool _imInterceptorInstalled = false;

  String? _token;
  String? _chatToken;

  /// 全局业务错误回调（拦截 1501–1507 Token 失效与被踢下线）。
  void Function(int errCode, String errMsg)? onApiError;

  HttpClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
  }

  /// 初始化 IM API 基础配置（幂等安装拦截器）。
  void init({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? headers,
  }) {
    _logger.info('init baseUrl=$baseUrl');
    _dio.options.baseUrl = baseUrl;
    if (connectTimeout != null) {
      _dio.options.connectTimeout = connectTimeout;
    }
    if (receiveTimeout != null) {
      _dio.options.receiveTimeout = receiveTimeout;
    }
    if (headers != null) {
      _dio.options.headers.addAll(headers);
    }
    if (!_imInterceptorInstalled) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
            options.headers['operationID'] = OpenImUtils.generateOperationID(
              operationName: 'openim_sdk_network_request',
            );
            handler.next(options);
          },
        ),
      );
      _imInterceptorInstalled = true;
    }
  }

  /// 设置 IM Token。
  void setToken(String? token) {
    _logger.fine('setToken(${token != null && token.isNotEmpty ? "***" : "null"})');
    _token = token;
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['token'] = token;
    } else {
      _dio.options.headers.remove('token');
    }
  }

  String? get token => _token;

  /// 初始化 Chat 服务端客户端。
  void initChat({required String baseUrl}) {
    _logger.info('initChat baseUrl=$baseUrl');
    _chatDio?.close();
    final Dio chatDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    chatDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          options.headers['operationID'] = OpenImUtils.generateOperationID(
            operationName: 'openim_sdk_chat_request',
          );
          handler.next(options);
        },
      ),
    );
    if (_chatToken != null && _chatToken!.isNotEmpty) {
      chatDio.options.headers['token'] = _chatToken;
    }
    _chatDio = chatDio;
  }

  /// 设置 Chat Token。
  void setChatToken(String? token) {
    _logger.fine('setChatToken(${token != null && token.isNotEmpty ? "***" : "null"})');
    _chatToken = token;
    final Dio? chatDio = _chatDio;
    if (chatDio != null) {
      if (token != null && token.isNotEmpty) {
        chatDio.options.headers['token'] = token;
      } else {
        chatDio.options.headers.remove('token');
      }
    }
  }

  String? get chatToken => _chatToken;

  Dio get dio => _dio;

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<ApiResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<ApiResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) {
    return _request(
      () => _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<ApiResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<ApiResponse> upload(
    String path, {
    required FormData formData,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) {
    return _request(
      () => _dio.post<dynamic>(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      ),
    );
  }

  Future<Response<dynamic>> download(
    String urlPath,
    dynamic savePath, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.download(
      urlPath,
      savePath,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<ApiResponse> chatPost(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    final Dio? chatDio = _chatDio;
    if (chatDio == null) {
      return Future<ApiResponse>.value(
        ApiResponse(errCode: -1, errMsg: 'chat dio not initialized', errDlt: '', data: null),
      );
    }
    return _request(
      () => chatDio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// 初始化 Admin 服务端客户端（governance 公开端点）。
  void initAdmin({required String baseUrl}) {
    _logger.info('initAdmin baseUrl=$baseUrl');
    _adminDio?.close();
    final Dio adminDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 60),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    adminDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          options.headers['operationID'] = OpenImUtils.generateOperationID(
            operationName: 'openim_sdk_admin_request',
          );
          handler.next(options);
        },
      ),
    );
    _adminDio = adminDio;
  }

  Future<ApiResponse> adminPost(
    String path, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) {
    final Dio? adminDio = _adminDio;
    if (adminDio == null) {
      return Future<ApiResponse>.value(
        ApiResponse(errCode: -1, errMsg: 'admin dio not initialized', errDlt: '', data: null),
      );
    }
    return _request(
      () => adminDio.post<dynamic>(path, data: data, options: options, cancelToken: cancelToken),
    );
  }

  Future<ApiResponse> adminMultipartPost(
    String path, {
    required FormData formData,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) {
    final Dio? adminDio = _adminDio;
    if (adminDio == null) {
      return Future<ApiResponse>.value(
        ApiResponse(errCode: -1, errMsg: 'admin dio not initialized', errDlt: '', data: null),
      );
    }
    return _request(
      () => adminDio.post<dynamic>(
        path,
        data: formData,
        options: Options(headers: headers, contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      ),
    );
  }

  Future<ApiResponse> _request(Future<Response<dynamic>> Function() request) async {
    try {
      final Response<dynamic> response = await request();
      return _handleResponse(response);
    } on DioException catch (error) {
      return _handleDioException(error);
    } on Object catch (error, stackTrace) {
      _logger.severe('HTTP request failed', error, stackTrace);
      return ApiResponse(
        errCode: -1,
        errMsg: error.toString(),
        errDlt: stackTrace.toString(),
        data: null,
      );
    }
  }

  ApiResponse _handleResponse(Response<dynamic> response) {
    final dynamic data = response.data;
    if (data is Map<String, dynamic>) {
      final ApiResponse resp = ApiResponse.fromJson(data);
      if (resp.errCode != 0) {
        onApiError?.call(resp.errCode, resp.errMsg);
      }
      return resp;
    }
    return ApiResponse(errCode: 0, errMsg: '', errDlt: '', data: data);
  }

  ApiResponse _handleDioException(DioException error) {
    final dynamic responseData = error.response?.data;
    if (responseData is Map<String, dynamic> && responseData.containsKey('errCode')) {
      final ApiResponse parsed = ApiResponse.fromJson(responseData);
      if (parsed.errCode != 0) {
        onApiError?.call(parsed.errCode, parsed.errMsg);
      }
      return parsed;
    }

    final String message = switch (error.type) {
      DioExceptionType.connectionTimeout => '连接超时',
      DioExceptionType.sendTimeout => '请求发送超时',
      DioExceptionType.receiveTimeout => '响应接收超时',
      DioExceptionType.badCertificate => '证书验证失败',
      DioExceptionType.badResponse => '服务器响应异常 (${error.response?.statusCode})',
      DioExceptionType.cancel => '请求已取消',
      DioExceptionType.connectionError => '网络连接异常，请检查网络',
      DioExceptionType.unknown => '未知网络错误: ${error.message}',
      DioExceptionType.transformTimeout => '响应转换超时: ${error.message}',
    };
    return ApiResponse(
      errCode: error.response?.statusCode ?? -1,
      errMsg: message,
      errDlt: error.message ?? '',
      data: null,
    );
  }
}
