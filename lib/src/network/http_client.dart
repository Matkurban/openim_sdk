import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/src/utils/im_utils.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';

import '../models/api_response.dart';

/// 封装 Dio 的单例网络请求类
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();

  factory HttpClient() => _instance;

  late final Dio _dio;

  final Logger _log = Logger('HttpClient');

  String? _token;

  /// API 错误回调（用于拦截 token 过期等全局错误）
  /// 对应 Go SDK 的 apiErrCallback.OnError
  void Function(int errCode, String errMsg)? onApiError;

  HttpClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(TalkerDioLogger());
  }

  /// 初始化，设置 baseUrl 及可选参数
  void init({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, dynamic>? headers,
  }) {
    _dio.options.baseUrl = baseUrl;
    if (connectTimeout != null) _dio.options.connectTimeout = connectTimeout;
    if (receiveTimeout != null) _dio.options.receiveTimeout = receiveTimeout;
    if (sendTimeout != null) _dio.options.sendTimeout = sendTimeout;
    if (headers != null) _dio.options.headers.addAll(headers);
    // 每次请求动态生成 operationID，便于服务端日志追踪
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['operationID'] = ImUtils.generateOperationID(
            operationName: 'openim_sdk_network_request',
          );
          handler.next(options);
        },
      ),
    );
  }

  /// 设置 Token
  void setToken(String? token) {
    _token = token;
    if (token != null) {
      _dio.options.headers['token'] = token;
    } else {
      _dio.options.headers.remove('token');
    }
  }

  /// 获取当前 Token
  String? get token => _token;

  /// 获取底层 Dio 实例（用于高级自定义场景）
  Dio get dio => _dio;

  /// 添加自定义拦截器
  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  // ---------------------------------------------------------------------------
  // HTTP 请求方法
  // ---------------------------------------------------------------------------

  /// GET 请求
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// POST 请求
  Future<ApiResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// PUT 请求
  Future<ApiResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    return _request(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      ),
    );
  }

  /// DELETE 请求
  Future<ApiResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _request(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// 上传文件
  Future<ApiResponse> upload(
    String path, {
    required FormData formData,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    return _request(
      () => _dio.post(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      ),
    );
  }

  /// 下载文件
  Future<Response> download(
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

  // ---------------------------------------------------------------------------
  // 内部方法
  // ---------------------------------------------------------------------------

  /// 统一请求处理 & 异常捕获
  Future<ApiResponse> _request(Future<Response> Function() request) async {
    try {
      final response = await request();
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e, s) {
      _log.severe('Unknown error', e, s);
      return ApiResponse(errCode: -1, errMsg: e.toString(), errDlt: s.toString(), data: null);
    }
  }

  /// 解析响应数据为 [ApiResponse]
  ApiResponse _handleResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final resp = ApiResponse.fromJson(data);
      if (resp.errCode != 0) {
        onApiError?.call(resp.errCode, resp.errMsg);
      }
      return resp;
    }
    return ApiResponse(errCode: 0, errMsg: '', errDlt: '', data: data);
  }

  /// 处理 Dio 异常
  ApiResponse _handleDioException(DioException e) {
    final String message;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = '连接超时';
      case DioExceptionType.sendTimeout:
        message = '请求发送超时';
      case DioExceptionType.receiveTimeout:
        message = '响应接收超时';
      case DioExceptionType.badCertificate:
        message = '证书验证失败';
      case DioExceptionType.badResponse:
        message = '服务器响应异常 (${e.response?.statusCode})';
      case DioExceptionType.cancel:
        message = '请求已取消';
      case DioExceptionType.connectionError:
        message = '网络连接异常，请检查网络';
      case DioExceptionType.unknown:
        message = '未知网络错误: ${e.message}';
    }
    _log.warning('DioException [${e.type}]: $message');
    return ApiResponse(
      errCode: e.response?.statusCode ?? -1,
      errMsg: message,
      errDlt: e.message ?? '',
      data: null,
    );
  }
}
