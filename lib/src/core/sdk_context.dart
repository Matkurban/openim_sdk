import '../api/sdk_apis.dart';
import '../db/db_engine.dart';
import '../models/init_config.dart';
import '../models/user_info.dart';
import '../network/http_client.dart';
import '../services/web_socket_service.dart';
import '../enums/sdk_error_code.dart';
import '../models/openim_exception.dart';

/// SDK 运行时依赖容器，替代全局散落的 `GetIt.instance`。
///
/// 显式管理 SDK 生命周期内的核心依赖（配置、HTTP、API 集合、ToStore 引擎、WebSocket、登录用户），
/// 保证 `unInitSDK()` 时可一次性干净释放，杜绝重复初始化冲突（修复 B-07）。
class SdkContext {
  InitConfig? _config;
  HttpClient? _httpClient;
  SdkApis? _apis;
  DbEngine? _db;
  WebSocketService? _ws;
  UserInfo? _loginUser;

  bool get isInitialized => _config != null && _db != null && _apis != null && _ws != null;

  InitConfig get config => _require(_config, SDKErrorCode.initializedError);
  HttpClient get httpClient => _require(_httpClient, SDKErrorCode.initializedError);
  SdkApis get apis => _require(_apis, SDKErrorCode.initializedError);
  DbEngine get db => _require(_db, SDKErrorCode.initializedDatabaseError);
  WebSocketService get ws => _require(_ws, SDKErrorCode.websocketNotConnected);
  UserInfo? get loginUserOrNull => _loginUser;

  UserInfo get loginUser => _require(_loginUser, SDKErrorCode.userHasLoggedOut);

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

  void setLoginUser(UserInfo? user) {
    _loginUser = user;
  }

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
