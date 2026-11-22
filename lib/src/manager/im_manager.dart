import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tostore/tostore.dart';

import '../../protocol_gen/sdkws/sdkws.pb.dart' as sdkws;
import '../api/sdk_apis.dart';
import '../config/cache_key.dart';
import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../db/db_engine.dart';
import '../enums/login_status.dart';
import '../enums/sdk_error_code.dart';
import '../listener/connect_listener.dart';
import '../listener/listener_for_service.dart';
import '../listener/upload_file_listener.dart';
import '../models/api_response.dart';
import '../models/auth_cache_data.dart';
import '../models/conversation_info.dart';
import '../models/init_config.dart';
import '../models/message.dart';
import '../models/openim_exception.dart';
import '../models/user_info.dart';
import '../models/web_socket_codec.dart';
import '../network/http_client.dart';
import '../services/web_socket_service.dart';
import '../sync/entity_syncers/conversation_syncer.dart';
import '../sync/entity_syncers/friend_syncer.dart';
import '../sync/entity_syncers/group_syncer.dart';
import '../sync/entity_syncers/user_syncer.dart';
import '../sync/handlers/conversation_notification_handler.dart';
import '../sync/handlers/friend_notification_handler.dart';
import '../sync/handlers/group_notification_handler.dart';
import '../sync/handlers/message_notification_handler.dart';
import '../sync/handlers/notification_router.dart';
import '../sync/handlers/user_notification_handler.dart';
import '../sync/sync_coordinator.dart';
import '../sync/typing_state_tracker.dart';
import '../utils/open_im_utils.dart';
import '../utils/platform_utils.dart';
import 'application_manager.dart';
import 'call_manager.dart';
import 'conversation_manager.dart';
import 'favorite_manager.dart';
import 'file_uploader.dart';
import 'group_manager.dart';
import 'message/message_manager.dart';
import 'moments_manager.dart';
import 'red_packet_manager.dart';
import 'relation_manager.dart';
import 'report_appeal_manager.dart';
import 'user_manager.dart';

/// OpenIM SDK 顶层门面（精简重设计，替代原 1,718 行巨型 `IMManager`）。
///
/// 关键修复：
/// - B-05：`login()` 先执行 `db.switchSpace(userID)` 再写入用户信息；
/// - B-06：移除 L1 后台 Isolate，6 端统一单一异步模型，彻底消除跨 Isolate 事件丢失；
/// - B-07：`unInitSDK()` 通过 `SdkContext.clear()` 安全关闭数据库并释放全部资源；
/// - B-14：先绑定全部 WebSocket 回调（含 `onUserOnlineStatusChanged`）再建立连接，并自动续订在线状态；
/// - B-15：每次登录重置 Token 失效防重入标志，不再出现重登录后失效回调永久静默；
/// - 日志全面切换为官方 `package:logging`（`_logger`），零胶水代码，不打印明文 Token。
class IMManager {
  IMManager._internal() {
    _fileUploader = FileUploader(context: _context);
    conversationManager = ConversationManager(context: _context, typingTracker: _typingTracker);
    friendshipManager = FriendshipManager(
      context: _context,
      conversationListenerProvider: () => conversationManager.listener,
    );
    messageManager = MessageManager(
      context: _context,
      fileUploader: _fileUploader,
      conversationListenerProvider: () => conversationManager.listener,
    );
    groupManager = GroupManager(context: _context);
    userManager = UserManager(context: _context);
    momentsManager = MomentsManager(context: _context);
    favoriteManager = FavoriteManager(context: _context);
    callManager = CallManager(context: _context);
    redPacketManager = RedPacketManager(context: _context);
    reportAppealManager = ReportAppealManager(context: _context);
    applicationManager = ApplicationManager(context: _context);
    _allManagers = <BaseManager<dynamic>>[
      conversationManager,
      friendshipManager,
      messageManager,
      groupManager,
      userManager,
      momentsManager,
      favoriteManager,
      callManager,
      redPacketManager,
      reportAppealManager,
      applicationManager,
    ];
  }

  static final IMManager _instance = IMManager._internal();

  /// 创建 `IMManager` 实例。
  ///
  /// Creates a `IMManager` instance.
  ///
  /// - Returns: `IMManager` 结果 / Resulting `IMManager`.
  factory IMManager() => _instance;

  final Logger _logger = Logger('openim_sdk.IMManager');
  final SdkContext _context = SdkContext();
  final TypingStateTracker _typingTracker = TypingStateTracker();
  late final FileUploader _fileUploader;
  late final List<BaseManager<dynamic>> _allManagers;

  /// 会话管理器。
  ///
  /// Conversation manager.
  late final ConversationManager conversationManager;

  /// 好友关系管理器。
  ///
  /// Friendship manager.
  late final FriendshipManager friendshipManager;

  /// 消息管理器。
  ///
  /// Message manager.
  late final MessageManager messageManager;

  /// 群组管理器。
  ///
  /// Group manager.
  late final GroupManager groupManager;

  /// 用户管理器。
  ///
  /// User manager.
  late final UserManager userManager;

  /// 朋友圈动态列表管理器。
  ///
  /// Moments manager.
  late final MomentsManager momentsManager;

  /// 收藏管理器。
  ///
  /// Favorite manager.
  late final FavoriteManager favoriteManager;

  /// 通话管理器。
  ///
  /// Call manager.
  late final CallManager callManager;

  /// 红包管理器。
  ///
  /// Red packet manager.
  late final RedPacketManager redPacketManager;

  /// 举报申诉管理器。
  ///
  /// Report appeal manager.
  late final ReportAppealManager reportAppealManager;

  /// 申请管理器。
  ///
  /// Application manager.
  late final ApplicationManager applicationManager;

  OnListenerForService? _listenerForService;
  SyncCoordinator? _syncCoordinator;
  AuthCacheData? _authData;
  OnConnectListener? _connectListener;

  LoginStatus _loginStatus = LoginStatus.logout;
  bool _initialized = false;

  // 每次登录重置的 Token 错误防重入标志（修复 B-15）
  bool _tokenExpiredFired = false;
  bool _tokenInvalidFired = false;
  bool _kickedOfflineFired = false;

  /// 认证数据。
  ///
  /// Authentication data.
  AuthCacheData get authData => _authData!;

  /// 是否Initialized。
  ///
  /// Whether initialized.
  bool get isInitialized => _initialized;

  /// 获取登录状态。
  ///
  /// Get login status.
  LoginStatus get getLoginStatus => _loginStatus;

  /// 设置监听器的服务。
  ///
  /// Set listener for service.
  ///
  /// - [listener] 监听器 / Listener.
  void setListenerForService(OnListenerForService listener) {
    _listenerForService = listener;
  }

  /// 设置上传文件监听器。
  ///
  /// Set upload file listener.
  ///
  /// - [listener] 监听器 / Listener.
  void setUploadFileListener(OnUploadFileListener listener) {
    _fileUploader.uploadFileListener = listener;
  }

  /// 初始化 SDK。
  ///
  /// [logLevel] 使用官方 `package:logging` 的 [Level]（默认 [Level.INFO]），
  /// 仅作用于 `openim_sdk` 命名空间，不覆盖宿主 App 全局 `Logger.root.level`。
  ///
  /// - [platformID] 平台ID / Platform ID.
  /// - [apiAddr] APIAddr / API addr.
  /// - [wsAddr] WebSocketAddr / WebSocket addr.
  /// - [authAddr] 认证Addr / Authentication addr.
  /// - [adminAddr] 管理员Addr / Administrator addr.
  /// - [dataDir] 数据Dir / Data dir.
  /// - [listener] 监听器 / Listener.
  /// - [schemas] 表结构列表 / Schemas.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> initSDK({
    int? platformID,
    required String apiAddr,
    required String wsAddr,
    required String authAddr,
    String? adminAddr,
    String? dataDir,
    required OnConnectListener listener,
    Level logLevel = Level.INFO,
    List<TableSchema> schemas = const <TableSchema>[],
  }) async {
    hierarchicalLoggingEnabled = true;
    Logger('openim_sdk').level = logLevel;

    final InitConfig config = InitConfig(
      platformID: platformID,
      apiAddr: apiAddr,
      authAddr: authAddr,
      adminAddr: adminAddr,
      wsAddr: wsAddr,
      dbPath: dataDir,
      schemas: schemas,
    );

    try {
      if (_context.isInitialized) {
        await unInitSDK();
      }
      _connectListener = listener;
      _logger.info('initSDK apiAddr=$apiAddr wsAddr=$wsAddr');

      final HttpClient httpClient = HttpClient()..init(baseUrl: config.apiAddr);
      if (config.authAddr != null && config.authAddr!.isNotEmpty) {
        httpClient.initChat(baseUrl: config.authAddr!);
      }
      final String adminUrl = (config.adminAddr != null && config.adminAddr!.isNotEmpty)
          ? config.adminAddr!
          : (config.authAddr ?? '');
      if (adminUrl.isNotEmpty) {
        httpClient.initAdmin(baseUrl: adminUrl);
      }
      httpClient.onApiError = _handleGlobalApiError;

      final DbEngine db = await DbEngine.open(
        dbPath: config.dbPath,
        dbName: config.dbName,
        extraSchemas: config.schemas,
        logLevel: logLevel,
      );
      final SdkApis apis = SdkApis(httpClient: httpClient);
      final WebSocketService ws = WebSocketService(
        wsUrl: config.wsAddr,
        platformID: config.platformID ?? PlatformUtils.platformID,
        connectListener: listener,
      );

      _context.attach(config: config, httpClient: httpClient, apis: apis, db: db, ws: ws);
      _initialized = true;
      _logger.info('OpenIM SDK initialized successfully');
      return true;
    } on Object catch (error, stackTrace) {
      _logger.severe('initSDK failed', error, stackTrace);
      _initialized = false;
      return false;
    }
  }

  /// 自动登录（从 ToStore 全局 KV 加载并校验 Token）。
  ///
  /// - Returns: `Future<LoginStatus>` 结果 / Resulting `Future<LoginStatus>`.
  Future<LoginStatus> loadLoginConfig() async {
    try {
      final String? value = await _context.db.toStore.kv.getString(
        CacheKey.loginAuthData,
        isGlobal: true,
      );
      if (value != null && value.isNotEmpty) {
        try {
          final AuthCacheData cached = AuthCacheData.fromJson(
            jsonDecode(value) as Map<String, dynamic>,
          );
          final bool valid = await checkToken(token: cached.imToken);
          if (valid) {
            _authData = cached;
            _context.httpClient.setChatToken(cached.chatToken);
            await login(userID: cached.userID, token: cached.imToken);
          } else {
            _loginStatus = LoginStatus.logout;
          }
        } on Object catch (error, stackTrace) {
          _logger.warning('Auto login failed', error, stackTrace);
          _loginStatus = LoginStatus.logout;
        }
      }
      return _loginStatus;
    } on Object catch (error, stackTrace) {
      _logger.severe('loadLoginConfig failed', error, stackTrace);
      throw OpenIMException(
        code: SDKErrorCode.initializedError.code,
        message: SDKErrorCode.initializedError.message,
      );
    }
  }

  /// 检查令牌。
  ///
  /// Check token.
  ///
  /// - [token] 令牌 / Token.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> checkToken({required String token}) async {
    try {
      final ApiResponse result = await _context.apis.auth.parseToken(token: token);
      return result.isSuccess;
    } on Object catch (error, stackTrace) {
      _logger.warning('checkToken failed', error, stackTrace);
      return false;
    }
  }

  // ---- KV 与数据库访问 ----

  /// 获取值。
  ///
  /// Get value.
  ///
  /// - [key] 键名 / Key.
  /// - [isGlobal] 是否全局 / Whether global.
  /// - Returns: `Future<dynamic>` 结果 / Resulting `Future<dynamic>`.
  Future<dynamic> getValue(String key, {bool isGlobal = false}) {
    return _context.db.toStore.kv.get(key, isGlobal: isGlobal);
  }

  /// 设置值。
  ///
  /// Set value.
  ///
  /// - [key] 键名 / Key.
  /// - [value] 值 / Value.
  /// - [isGlobal] 是否全局 / Whether global.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> setValue(String key, dynamic value, {bool isGlobal = false}) async {
    final DbResult result = await _context.db.toStore.kv.set(key, value, isGlobal: isGlobal);
    return !result.hasErrors;
  }

  /// 移除值。
  ///
  /// Remove value.
  ///
  /// - [key] 键名 / Key.
  /// - [isGlobal] 是否全局 / Whether global.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> removeValue(String key, {bool isGlobal = false}) async {
    final DbResult result = await _context.db.toStore.kv.remove(key, isGlobal: isGlobal);
    return !result.hasErrors;
  }

  /// 获取存储空间信息。
  ///
  /// Get storage space info.
  ///
  /// - Returns: `Future<SpaceInfo>` 结果 / Resulting `Future<SpaceInfo>`.
  Future<SpaceInfo> getSpaceInfo() => _context.db.toStore.getSpaceInfo();

  /// 获取DatabaseInstance。
  ///
  /// Get database instance.
  ///
  /// - Returns: `ToStore` 结果 / Resulting `ToStore`.
  @internal
  ToStore getDatabaseInstance() => _context.db.toStore;

  /// 执行InDatabase。
  ///
  /// Run in database.
  ///
  /// - [callback] 回调 / Callback.
  /// - [arg] arg / Arg.
  /// - Returns: `Future<R>` 结果 / Resulting `Future<R>`.
  Future<R> runInDatabase<R, A>(
    FutureOr<R> Function(ToStore db, [A? arg]) callback, {
    A? arg,
  }) async {
    return callback(_context.db.toStore, arg);
  }

  // ---- 登录 / 登出 / 反初始化 ----

  /// 登录。
  ///
  /// Login.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [token] 令牌 / Token.
  /// - Returns: `Future<UserInfo>` 结果 / Resulting `Future<UserInfo>`.
  Future<UserInfo> login({required String userID, required String token}) async {
    _logger.info('login userID=$userID');
    _loginStatus = LoginStatus.logging;
    _tokenExpiredFired = false;
    _tokenInvalidFired = false;
    _kickedOfflineFired = false;

    _context.httpClient.setToken(token);

    // 修复 B-05：必须先切换到目标用户空间，再读写任何用户表数据！
    await _context.db.switchSpace(userID: userID);

    final ApiResponse response = await _context.apis.user.getUsersInfo(userIDs: <String>[userID]);
    if (!response.isSuccess) {
      _loginStatus = LoginStatus.logout;
      throw OpenIMException(code: SDKErrorCode.loginError.code, message: '获取登录用户信息失败');
    }

    final Map<String, dynamic> dataMap = response.data as Map<String, dynamic>;
    final List<dynamic>? users = dataMap['usersInfo'] as List<dynamic>?;
    if (users == null || users.isEmpty) {
      _loginStatus = LoginStatus.logout;
      throw OpenIMException(code: SDKErrorCode.loginError.code, message: '获取登录用户 $userID 信息为空');
    }

    final Map<String, dynamic> userData = Map<String, dynamic>.from(
      users.first as Map<dynamic, dynamic>,
    );
    await _context.db.users.upsertUser(userData);
    final UserInfo user = UserInfo.fromJson(userData);
    _context.setLoginUser(user);

    for (final BaseManager<dynamic> manager in _allManagers) {
      manager.onLogin(userID);
    }
    callManager.setSendSignalingFn(_sendCallSignaling);

    _syncCoordinator?.dispose();
    _syncCoordinator = _buildSyncCoordinator(userID);

    // 修复 B-14：先绑定全部回调（含 onUserOnlineStatusChanged），再发起连接！
    final WebSocketService ws = _context.ws;
    ws.onPushMsg = _syncCoordinator!.handlePushMsg;
    ws.onUserOnlineStatusChanged = _handleOnlineStatusPush;
    ws.onConnected = () {
      unawaited(_syncCoordinator?.doConnectedSync());
      final Set<String> subs = userManager.subscribedStatusUserIDs;
      if (subs.isNotEmpty) {
        unawaited(userManager.subscribeUsersStatus(subs.toList()));
      }
    };

    _loginStatus = LoginStatus.logged;
    unawaited(ws.connect(userID: userID, token: token));
    unawaited(messageManager.recoverSendingMessages());
    return user;
  }

  /// 登录按邮箱。
  ///
  /// Login by email.
  ///
  /// - [email] 邮箱 / Email.
  /// - [password] 密码 / Password.
  /// - [verificationCode] 验证代码 / Verification code.
  /// - Returns: `Future<UserInfo>` 结果 / Resulting `Future<UserInfo>`.
  Future<UserInfo> loginByEmail({
    required String email,
    String? password,
    String? verificationCode,
  }) async {
    assert(password != null || verificationCode != null, 'password 和 verificationCode 必须提供其中一个');
    final Map<String, dynamic> body = <String, dynamic>{
      'email': email,
      'platform': PlatformUtils.platformID,
      'verifyCode': ?verificationCode,
      if (verificationCode == null) 'password': OpenImUtils.generateMD5(password!),
    };
    return _loginWithChatPayload(body);
  }

  /// 登录按手机号。
  ///
  /// Login by phone number.
  ///
  /// - [areaCode] 区号代码 / Area code.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [password] 密码 / Password.
  /// - [verificationCode] 验证代码 / Verification code.
  /// - Returns: `Future<UserInfo>` 结果 / Resulting `Future<UserInfo>`.
  Future<UserInfo> loginByPhone({
    required String areaCode,
    required String phoneNumber,
    String? password,
    String? verificationCode,
  }) async {
    assert(password != null || verificationCode != null, 'password 和 verificationCode 必须提供其中一个');
    final Map<String, dynamic> body = <String, dynamic>{
      'areaCode': areaCode,
      'phoneNumber': phoneNumber,
      'platform': PlatformUtils.platformID,
      'verifyCode': ?verificationCode,
      if (verificationCode == null) 'password': OpenImUtils.generateMD5(password!),
    };
    return _loginWithChatPayload(body);
  }

  /// 登录按账号。
  ///
  /// Login by account.
  ///
  /// - [account] 账号 / Account.
  /// - [password] 密码 / Password.
  /// - Returns: `Future<UserInfo>` 结果 / Resulting `Future<UserInfo>`.
  Future<UserInfo> loginByAccount({required String account, required String password}) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'account': account,
      'password': OpenImUtils.generateMD5(password),
      'platform': PlatformUtils.platformID,
    };
    return _loginWithChatPayload(body);
  }

  Future<UserInfo> _loginWithChatPayload(Map<String, dynamic> body) async {
    final ApiResponse apiResponse = await _context.apis.auth.chatLogin(body: body);
    if (!apiResponse.isSuccess) {
      if (apiResponse.errCode == SDKErrorCode.accountNotRegistered.code) {
        throw OpenIMException(
          code: SDKErrorCode.accountNotRegistered.code,
          message: SDKErrorCode.accountNotRegistered.message,
        );
      }
      if (apiResponse.errCode == SDKErrorCode.passwordError.code) {
        throw OpenIMException(
          code: SDKErrorCode.passwordError.code,
          message: SDKErrorCode.passwordError.message,
        );
      }
      if (apiResponse.errCode == SDKErrorCode.ipBanned.code) {
        throw OpenIMException(
          code: SDKErrorCode.ipBanned.code,
          message: SDKErrorCode.ipBanned.message,
        );
      }
      throw OpenIMException(code: SDKErrorCode.loginError.code, message: apiResponse.errMsg);
    }

    final AuthCacheData loginData = AuthCacheData.fromJson(
      apiResponse.data as Map<String, dynamic>,
    );
    _authData = loginData;
    _context.httpClient.setChatToken(loginData.chatToken);
    final UserInfo userInfo = await login(userID: loginData.userID, token: loginData.imToken);
    await _context.db.toStore.kv.set(
      CacheKey.loginAuthData,
      jsonEncode(loginData.toJson()),
      isGlobal: true,
    );
    return userInfo;
  }

  /// 登出。
  ///
  /// Logout.
  Future<void> logout() async {
    _logger.info('logout called');
    try {
      _loginStatus = LoginStatus.logout;
      _syncCoordinator?.dispose();
      _syncCoordinator = null;
      _fileUploader.resetCache();

      if (_context.isInitialized) {
        final WebSocketService ws = _context.ws;
        ws.onPushMsg = null;
        ws.onConnected = null;
        ws.onUserOnlineStatusChanged = null;
        await ws.disconnect();

        _context.httpClient.setToken(null);
        _context.httpClient.setChatToken(null);
        await _context.db.toStore.kv.remove(CacheKey.loginAuthData, isGlobal: true);
      }

      _authData = null;
      _context.setLoginUser(null);
      for (final BaseManager<dynamic> manager in _allManagers) {
        manager.onLogout();
      }
    } on Object catch (error, stackTrace) {
      _logger.severe('logout failed', error, stackTrace);
      throw OpenIMException(code: SDKErrorCode.loginError.code, message: '退出登录失败');
    }
  }

  /// 反初始化 SDK（修复 B-07：释放所有资源并关闭 ToStore，支持再次 `initSDK()`）。
  Future<void> unInitSDK() async {
    _logger.info('unInitSDK called');
    _loginStatus = LoginStatus.logout;
    _initialized = false;
    _syncCoordinator?.dispose();
    _syncCoordinator = null;
    _connectListener = null;
    _authData = null;
    _fileUploader.resetCache();
    for (final BaseManager<dynamic> manager in _allManagers) {
      manager.dispose();
    }
    await _context.clear();
  }

  /// 触发唤醒同步。
  ///
  /// Trigger wakeup sync.
  Future<void> triggerWakeupSync() async {
    if (_loginStatus != LoginStatus.logged) {
      return;
    }
    await _syncCoordinator?.doWakeupSync();
  }

  /// 获取登录用户ID。
  ///
  /// Get login user ID.
  ///
  /// - Returns: 字符串结果 / String result.
  String getLoginUserID() => _context.loginUser.userID;

  /// 用户ID。
  ///
  /// User ID.
  String get userID => _context.loginUser.userID;

  /// 获取登录用户信息。
  ///
  /// Get login user info.
  ///
  /// - Returns: `UserInfo` 结果 / Resulting `UserInfo`.
  UserInfo getLoginUserInfo() => _context.loginUser;

  /// 用户信息。
  ///
  /// User info.
  UserInfo get userInfo => _context.loginUser;

  /// 上传文件。
  ///
  /// Upload file.
  ///
  /// - [id] ID / ID.
  /// - [filePath] 文件路径 / File path.
  /// - [fileBytes] 文件字节数据 / File bytes.
  /// - [fileName] 文件名称 / File name.
  /// - [contentType] 内容类型 / Content type.
  /// - [cause] cause / Cause.
  /// - [onProgress] on进度 / On progress.
  /// - Returns: 字符串结果 / String result.
  Future<String> uploadFile({
    required String id,
    String? filePath,
    Uint8List? fileBytes,
    required String fileName,
    String? contentType,
    String? cause,
    void Function(int sent, int total)? onProgress,
  }) {
    return _fileUploader.uploadFile(
      id: id,
      userID: userID,
      filePath: filePath,
      fileBytes: fileBytes,
      fileName: fileName,
      contentType: contentType,
      cause: cause,
      onProgress: onProgress,
    );
  }

  /// 网络状态Changed。
  ///
  /// Network status changed.
  Future<void> networkStatusChanged() async {
    if (!_context.isInitialized) {
      return;
    }
    await _context.ws.reconnect();
  }

  /// 设置App后台状态。
  ///
  /// Set app background status.
  ///
  /// - [isBackground] 是否后台 / Whether background.
  Future<void> setAppBackgroundStatus(bool isBackground) async {
    if (!_context.isInitialized) {
      return;
    }
    await _context.ws.setBackground(isBackground);
  }

  /// 更新FCM 推送令牌。
  ///
  /// Update FCM push token.
  ///
  /// - [fcmToken] FCM 推送令牌 / FCM push token.
  /// - [expireTime] expire时间戳 / Expire timestamp.
  Future<void> updateFcmToken({required String fcmToken, int expireTime = 0}) async {
    final ApiResponse resp = await _context.apis.objectStorage.fcmUpdateToken(
      platformID: PlatformUtils.platformID,
      fcmToken: fcmToken,
      account: userID,
      expireTime: expireTime,
    );
    if (resp.errCode != 0) {
      _logger.warning('updateFcmToken failed: ${resp.errMsg}');
    }
  }

  // ---- 内部装配 ----

  SyncCoordinator _buildSyncCoordinator(String loginUserID) {
    final FriendSyncer friendSyncer = FriendSyncer(
      db: _context.db,
      friendApi: _context.apis.friend,
      onFriendInfoChanged: (FriendInfo info) => friendshipManager.listener?.friendInfoChanged(info),
      onConversationChanged: (List<ConversationInfo> list) =>
          conversationManager.listener?.conversationChanged(list),
    );
    final GroupSyncer groupSyncer = GroupSyncer(db: _context.db, groupApi: _context.apis.group);
    final ConversationSyncer conversationSyncer = ConversationSyncer(
      db: _context.db,
      conversationApi: _context.apis.conversation,
      messageApi: _context.apis.message,
      userApi: _context.apis.user,
      groupApi: _context.apis.group,
      onConversationChanged: (List<ConversationInfo> list) =>
          conversationManager.listener?.conversationChanged(list),
      onTotalUnreadChanged: (int total) =>
          conversationManager.listener?.totalUnreadMessageCountChanged(total),
    );
    final UserSyncer userSyncer = UserSyncer(
      db: _context.db,
      userApi: _context.apis.user,
      onSelfInfoUpdated: (UserInfo info) {
        _context.setLoginUser(info);
        userManager.listener?.selfInfoUpdated(info);
      },
    );

    final NotificationRouter router = NotificationRouter(
      handlers: <dynamic>[
        FriendNotificationHandler(
          db: _context.db,
          friendSyncer: friendSyncer,
          loginUserID: loginUserID,
          listenerProvider: () => friendshipManager.listener,
        ),
        GroupNotificationHandler(
          db: _context.db,
          groupSyncer: groupSyncer,
          loginUserID: loginUserID,
          listenerProvider: () => groupManager.listener,
        ),
        ConversationNotificationHandler(
          db: _context.db,
          conversationSyncer: conversationSyncer,
          loginUserID: loginUserID,
          conversationListenerProvider: () => conversationManager.listener,
          onBusinessNotification: _routeBusinessNotification,
        ),
        MessageNotificationHandler(
          db: _context.db,
          conversationSyncer: conversationSyncer,
          loginUserID: loginUserID,
          msgListenerProvider: () => messageManager.msgListener,
          conversationListenerProvider: () => conversationManager.listener,
        ),
        UserNotificationHandler(
          userSyncer: userSyncer,
          loginUserID: loginUserID,
          userListenerProvider: () => userManager.listener,
        ),
      ].cast(),
    );

    return SyncCoordinator(
      loginUserID: loginUserID,
      db: _context.db,
      messageApi: _context.apis.message,
      friendSyncer: friendSyncer,
      groupSyncer: groupSyncer,
      conversationSyncer: conversationSyncer,
      userSyncer: userSyncer,
      notificationRouter: router,
      typingTracker: _typingTracker,
      msgListenerProvider: () => messageManager.msgListener,
      conversationListenerProvider: () => conversationManager.listener,
      serviceListenerProvider: () => _listenerForService,
      callSignalingInterceptor: callManager.handleSignalingMessage,
      onLowPrioritySync: () => Future.wait<void>(<Future<void>>[
        momentsManager.syncFromServer(),
        favoriteManager.syncFromServer(),
      ]),
    );
  }

  void _routeBusinessNotification(String key, Map<String, dynamic> data) {
    if (key.startsWith('moment_')) {
      unawaited(momentsManager.handleNotification(key, data));
    } else if (key.startsWith('favorite_')) {
      unawaited(favoriteManager.handleNotification(key, data));
    } else if (key == 'red_packet_expired' ||
        key == 'red_packet_grabbed' ||
        key == 'points_adjusted') {
      redPacketManager.dispatchBusinessNotification(key, jsonEncode(data));
    }
    messageManager.customBusinessListener?.recvCustomBusinessMessage(
      jsonEncode(<String, dynamic>{'key': key, 'data': data}),
    );
  }

  void _handleOnlineStatusPush(WebSocketResponse resp) {
    if (resp.data.isEmpty) {
      return;
    }
    try {
      final sdkws.UserStatusChangeTips tips = sdkws.UserStatusChangeTips.fromBuffer(resp.data);
      userManager.listener?.userStatusChanged(
        UserStatusInfo(
          userID: tips.fromUserID,
          status: tips.status,
          platformIDs: tips.platformID > 0 ? <int>[tips.platformID] : const <int>[],
        ),
      );
    } on Object catch (error, stackTrace) {
      _logger.fine('Failed to decode UserStatusChangeTips', error, stackTrace);
    }
  }

  void _sendCallSignaling(String toUserID, String data, {bool isInvite = false}) {
    final Message msg = messageManager.createCustomMessage(
      data: data,
      extension: '',
      description: '',
    );
    unawaited(
      messageManager.sendMessage(
        message: msg,
        offlinePushInfo: OfflinePushInfo(title: '音视频通话', desc: '您有一个新的通话邀请'),
        userID: toUserID,
        isOnlineOnly: true,
        messageOptions: isInvite
            ? const <String, bool>{'persistent': true, 'offlinePush': true}
            : null,
      ),
    );
  }

  void _handleGlobalApiError(int errCode, String errMsg) {
    final OnConnectListener? listener = _connectListener;
    if (listener == null) {
      return;
    }
    switch (errCode) {
      case 1501:
        if (!_tokenExpiredFired) {
          _tokenExpiredFired = true;
          _logger.warning('Token expired');
          listener.userTokenExpired();
          unawaited(logout());
        }
      case 1502:
      case 1503:
      case 1504:
      case 1505:
      case 1507:
        if (!_tokenInvalidFired) {
          _tokenInvalidFired = true;
          _logger.warning('Token invalid: $errMsg');
          listener.userTokenInvalid();
          unawaited(logout());
        }
      case 1506:
        if (!_kickedOfflineFired) {
          _kickedOfflineFired = true;
          _logger.warning('Kicked offline');
          listener.kickedOffline();
          unawaited(logout());
        }
    }
  }
}
