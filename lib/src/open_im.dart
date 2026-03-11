import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/db/database_service.dart';
import 'package:openim_sdk/src/network/http_client.dart';
import 'package:openim_sdk/src/network/msg_syncer.dart';
import 'package:openim_sdk/src/network/notification_dispatcher.dart';
import 'package:openim_sdk/src/network/ws_connection_manager.dart';
import 'package:openim_sdk/src/services/api_services.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';

/// OpenIM SDK 入口。
/// 对应 open-im-sdk-flutter 中 [OpenIM] → [IMManager]。
class OpenIM {
  OpenIM._();

  static final Logger _log = Logger('OpenIM');

  /// 单例
  static final iMManager = IMManager();
}

/// IM 管理器，对应 Flutter SDK 中 IMManager。
/// 管理所有子模块与监听回调。
class IMManager {
  /// 会话管理
  late ConversationManager conversationManager;

  /// 好友管理
  late FriendshipManager friendshipManager;

  /// 消息管理
  late MessageManager messageManager;

  /// 群组管理
  late GroupManager groupManager;

  /// 用户管理
  late UserManager userManager;

  /// 连接监听
  late OnConnectListener _connectListener;

  /// 服务监听（可选）
  OnListenerForService? listenerForService;

  /// 文件上传监听（可选）
  OnUploadFileListener? uploadFileListener;

  /// 当前登录用户 ID
  late String userID;

  /// 当前登录用户信息
  late UserInfo userInfo;

  /// 是否已登录
  bool isLogined = false;

  /// Token
  String? token;

  /// WebSocket 连接管理器
  late WsConnectionManager _wsManager;

  /// 消息同步器
  late MsgSyncer _msgSyncer;

  /// 通知分发器
  late NotificationDispatcher _notificationDispatcher;

  /// IM API 服务
  late ImApiService _imApiService;

  /// 数据库服务
  late DatabaseService _db;

  /// 初始化配置
  late InitConfig _config;

  IMManager() {
    conversationManager = ConversationManager();
    friendshipManager = FriendshipManager();
    messageManager = MessageManager();
    groupManager = GroupManager();
    userManager = UserManager();
  }

  /// 初始化 SDK
  /// [config] 初始化配置（包含 apiAddr、wsAddr、dataDir 等）
  /// [listener] 连接状态监听
  Future<bool> init(InitConfig config, OnConnectListener listener) async {
    try {
      _connectListener = listener;
      _config = config;
      Logger.root.level = config.logLevel;

      final getIt = GetIt.instance;

      // 注册配置
      if (!getIt.isRegistered<InitConfig>()) {
        getIt.registerSingleton<InitConfig>(config);
      }

      // 初始化 HTTP 层
      HttpClient().init(baseUrl: config.apiAddr);

      // 注册 Chat 业务 API
      if (!getIt.isRegistered<ApiServices>()) {
        getIt.registerLazySingleton<ApiServices>(() => ApiServices());
      }

      // 注册数据库服务
      _db = DatabaseService();
      if (!getIt.isRegistered<DatabaseService>()) {
        getIt.registerSingleton<DatabaseService>(_db);
      }

      // 注册 IM API 服务
      _imApiService = ImApiService();
      if (!getIt.isRegistered<ImApiService>()) {
        getIt.registerSingleton<ImApiService>(_imApiService);
      }

      // 初始化 WebSocket 连接管理器
      _wsManager = WsConnectionManager();
      if (!getIt.isRegistered<WsConnectionManager>()) {
        getIt.registerSingleton<WsConnectionManager>(_wsManager);
      }

      // 初始化通知分发器
      _notificationDispatcher = NotificationDispatcher();
      _notificationDispatcher.bindManagers(
        friendshipManager: friendshipManager,
        groupManager: groupManager,
        conversationManager: conversationManager,
        messageManager: messageManager,
        userManager: userManager,
      );

      // 初始化消息同步器
      _msgSyncer = MsgSyncer(ws: _wsManager, db: _db, api: _imApiService);

      // 绑定 WebSocket 回调
      _setupWsCallbacks();

      // 绑定同步回调
      _setupSyncCallbacks();

      OpenIM._log.info('OpenIM SDK initialized successfully');
      return true;
    } catch (e, s) {
      OpenIM._log.severe(e.toString(), e, s);
      return false;
    }
  }

  /// 登录
  /// [userID] 用户ID
  /// [token] 用户 token
  Future<UserInfo?> login({required String userID, required String token}) async {
    this.userID = userID;
    this.token = token;

    // 设置 HTTP token
    HttpClient().setToken(token);

    // 初始化数据库（以用户维度）
    await _db.init(userID: userID);

    // 设置同步器用户 ID
    _msgSyncer.setLoginUserID(userID);

    isLogined = true;

    // 建立 WebSocket 连接
    final platformID = _config.platformID ?? PlatformUtils.platformID;
    await _wsManager.connect(
      wsUrl: _config.wsAddr,
      userID: userID,
      token: token,
      platformID: platformID,
    );

    OpenIM._log.info('用户已登录: $userID');
    return null;
  }

  /// 登出
  Future<void> logout() async {
    isLogined = false;
    token = null;

    // 断开 WebSocket
    await _wsManager.disconnect();

    // 清除 HTTP token
    HttpClient().setToken(null);

    // 关闭数据库
    await _db.close();

    OpenIM._log.info('用户已登出');
  }

  /// 设置连接监听
  void setConnectListener(OnConnectListener listener) {
    _connectListener = listener;
    _setupWsCallbacks();
  }

  /// 设置服务监听（用于后台推送等场景）
  void setListenerForService(OnListenerForService listener) {
    listenerForService = listener;
    _notificationDispatcher.listenerForService = listener;
  }

  /// 设置文件上传进度监听
  void setUploadFileListener(OnUploadFileListener listener) {
    uploadFileListener = listener;
  }

  // ---------------------------------------------------------------------------
  // WebSocket 回调绑定
  // ---------------------------------------------------------------------------

  /// 将 WsConnectionManager 的回调桥接到 OnConnectListener
  void _setupWsCallbacks() {
    _wsManager.onConnecting = () {
      _connectListener.connecting();
    };

    _wsManager.onConnectSuccess = () {
      _connectListener.connectSuccess();
      // 连接成功后自动触发数据同步
      _msgSyncer.doConnectedSync();
    };

    _wsManager.onConnectFailed = (int code, String msg) {
      _connectListener.connectFailed(code, msg);
    };

    _wsManager.onKickedOffline = () {
      isLogined = false;
      _connectListener.kickedOffline();
    };

    _wsManager.onUserTokenExpired = () {
      _connectListener.userTokenExpired();
    };

    _wsManager.onUserTokenInvalid = () {
      _connectListener.userTokenInvalid();
    };

    // 推送消息 → MsgSyncer 处理 → NotificationDispatcher 分发
    _wsManager.onPushMsg = (resp) {
      _msgSyncer.handlePushMsg(resp);
    };

    // 新消息回调：由 MsgSyncer 解析后交给 NotificationDispatcher 路由
    _msgSyncer.onNewMsg = (msg) {
      _notificationDispatcher.dispatch(msg);
    };
  }

  // ---------------------------------------------------------------------------
  // 同步回调绑定
  // ---------------------------------------------------------------------------

  /// 将 MsgSyncer 的同步进度桥接到 OnConversationListener
  void _setupSyncCallbacks() {
    _msgSyncer.onSyncStart = (reinstalled) {
      conversationManager.listener?.syncServerStart(reinstalled);
    };

    _msgSyncer.onSyncProgress = (progress) {
      conversationManager.listener?.syncServerProgress(progress);
    };

    _msgSyncer.onSyncFinish = (reinstalled) {
      conversationManager.listener?.syncServerFinish(reinstalled);
    };

    _msgSyncer.onSyncFailed = (reinstalled) {
      conversationManager.listener?.syncServerFailed(reinstalled);
    };
  }

  // ---------------------------------------------------------------------------
  // 监听器绑定
  // ---------------------------------------------------------------------------
}
