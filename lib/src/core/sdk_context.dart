import '../api/sdk_apis.dart';
import '../db/db_engine.dart';
import '../enums/sdk_error_code.dart';
import '../models/init_config.dart';
import '../models/openim_exception.dart';
import '../models/user_info.dart';
import '../network/http_client.dart';
import '../services/web_socket_service.dart';

/// SDK 运行时依赖容器，集中管理核心基础设施实例的生命周期。
///
/// Runtime dependency container managing the lifecycle of core SDK services.
///
/// 显式持有配置、HTTP 客户端、API 集合、ToStore 引擎、WebSocket 与当前登录用户，
/// 保证 `unInitSDK()` 时可一次性干净释放，杜绝重复初始化冲突。
/// Explicitly holds configuration, HTTP client, API collection, ToStore engine,
/// WebSocket service, and logged-in user so `unInitSDK()` can dispose cleanly.
class SdkContext {
  InitConfig? _config;
  HttpClient? _httpClient;
  SdkApis? _apis;
  DbEngine? _db;
  WebSocketService? _ws;
  UserInfo? _loginUser;

  /// SDK 核心依赖是否均已初始化绑定。
  ///
  /// Whether all core SDK dependencies are initialized and attached.
  ///
  /// - Returns: 已初始化返回 `true`，否则返回 `false` / `true` if initialized, otherwise `false`.
  bool get isInitialized => _config != null && _db != null && _apis != null && _ws != null;

  /// 当前 SDK 初始化配置（未初始化时抛出 [OpenIMException]）。
  ///
  /// Current SDK [InitConfig]; throws [OpenIMException] if uninitialized.
  InitConfig get config => _require(_config, SDKErrorCode.initializedError);

  /// 统一 HTTP 客户端实例（未初始化时抛出 [OpenIMException]）。
  ///
  /// Shared [HttpClient] instance; throws [OpenIMException] if uninitialized.
  HttpClient get httpClient => _require(_httpClient, SDKErrorCode.initializedError);

  /// 领域 REST API 聚合入口（未初始化时抛出 [OpenIMException]）。
  ///
  /// Aggregated domain [SdkApis] collection; throws [OpenIMException] if uninitialized.
  SdkApis get apis => _require(_apis, SDKErrorCode.initializedError);

  /// ToStore 数据库引擎门面（未初始化时抛出 [OpenIMException]）。
  ///
  /// ToStore [DbEngine] facade; throws [OpenIMException] if uninitialized.
  DbEngine get db => _require(_db, SDKErrorCode.initializedDatabaseError);

  /// WebSocket 长连接服务实例（未初始化时抛出 [OpenIMException]）。
  ///
  /// [WebSocketService] instance; throws [OpenIMException] if uninitialized.
  WebSocketService get ws => _require(_ws, SDKErrorCode.websocketNotConnected);

  /// 当前登录用户信息（可为 `null`）。
  ///
  /// Currently logged-in [UserInfo], or `null` when logged out.
  UserInfo? get loginUserOrNull => _loginUser;

  /// 当前登录用户信息（未登录时抛出 [OpenIMException]）。
  ///
  /// Currently logged-in [UserInfo]; throws [OpenIMException] when logged out.
  UserInfo get loginUser => _require(_loginUser, SDKErrorCode.userHasLoggedOut);

  /// 绑定初始化完成的全部核心运行时依赖。
  ///
  /// Attaches all initialized core runtime services to this context.
  ///
  /// - [config] SDK 初始化配置 / SDK initialization config.
  /// - [httpClient] 统一 HTTP 客户端 / Shared HTTP client.
  /// - [apis] 领域 API 聚合容器 / Domain API collection.
  /// - [db] ToStore 数据库引擎 / ToStore database engine.
  /// - [ws] WebSocket 长连接服务 / WebSocket transport service.
  void attach({
    required InitConfig config,
    required HttpClient httpClient,
    required SdkApis apis,
    required DbEngine db,
    required WebSocketService ws,
  }) {
    _config = config;
    _httpClient = httpClient;
    _apis = apis;
    _db = db;
    _ws = ws;
  }

  /// 更新或清空当前登录用户信息。
  ///
  /// Updates or clears the currently logged-in [UserInfo].
  ///
  /// - [user] 登录用户对象，登出时传 `null` / Logged-in user info, or `null` on logout.
  void setLoginUser(UserInfo? user) {
    _loginUser = user;
  }

  /// 断开长连接、关闭数据库并清空全部运行时引用。
  ///
  /// Disconnects WebSocket, closes the database, and clears all runtime references.
  Future<void> clear() async {
    final WebSocketService? ws = _ws;
    final DbEngine? db = _db;
    _loginUser = null;
    _ws = null;
    _apis = null;
    _db = null;
    _config = null;
    _httpClient = null;
    if (ws != null) {
      await ws.disconnect();
    }
    if (db != null) {
      await db.close(keepActiveSpace: false);
    }
  }

  T _require<T>(T? value, SDKErrorCode errorCode) {
    if (value == null) {
      throw OpenIMException(code: errorCode.code, message: errorCode.message);
    }
    return value;
  }
}
