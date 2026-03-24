import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:openim_sdk/src/utils/sdk_isolate.dart' as isolate_util;
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/cache_key.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/logger/im_log_config.dart';
import 'package:openim_sdk/src/logger/logger.dart';
import 'package:openim_sdk/src/models/web_socket_identifier.dart';
import 'package:openim_sdk/src/network/msg_syncer.dart';
import 'package:openim_sdk/src/network/notification_dispatcher.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/db/db_schema.dart';
import 'package:openim_sdk/src/network/http_client.dart';
import 'package:openim_sdk/src/services/web_socket_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';
import 'package:openim_sdk/protocol_gen/sdkws/sdkws.pb.dart' as sdkws;

class IMManager {
  IMManager._internal();
  static final IMManager _instance = IMManager._internal();
  factory IMManager() => _instance;
  static final Logger _log = Logger('IMManager');

  /// 会话管理
  final ConversationManager conversationManager = ConversationManager();

  /// 好友管理
  final FriendshipManager friendshipManager = FriendshipManager();

  /// 消息管理
  final MessageManager messageManager = MessageManager();

  /// 群组管理
  final GroupManager groupManager = GroupManager();

  /// 用户管理
  final UserManager userManager = UserManager();

  /// 朋友圈管理
  final MomentsManager momentsManager = MomentsManager();

  /// 收藏夹管理
  final FavoriteManager favoriteManager = FavoriteManager();

  /// 通话管理
  final CallManager callManager = CallManager();

  /// 服务监听（可选）
  OnListenerForService? _listenerForService;

  /// 文件上传监听（可选）
  OnUploadFileListener? _uploadFileListener;

  /// 通知分发器（登录时创建，登出时清理）
  NotificationDispatcher? _notificationDispatcher;
  MsgSyncer? _msgSyncer;

  AuthCacheData? _authData;

  AuthCacheData get authData => _authData!;

  /// 当前登录状态
  LoginStatus _loginStatus = LoginStatus.logout;

  final GetIt _getIt = GetIt.instance;

  /// 设置服务监听（用于后台推送等场景）
  void setListenerForService(OnListenerForService listener) {
    _listenerForService = listener;
  }

  /// 设置文件上传进度监听
  void setUploadFileListener(OnUploadFileListener listener) {
    _uploadFileListener = listener;
  }

  /// 初始化 SDK
  /// [platformID] 平台ID
  /// [apiAddr] SDK API 地址
  /// [wsAddr] SDK WebSocket 地址
  /// [dataDir] SDK 数据库存储目录
  /// [listener] 连接状态监听
  /// [logLevel] 日志级别
  /// 此方法适用于在 app 启动时调用一次，完成 SDK 的整体初始化配置。
  Future<bool> initSDK({
    int? platformID,
    required String apiAddr,
    required String wsAddr,
    required String authAddr,
    String? dataDir,
    required OnConnectListener listener,
    ImLogLevel logLevel = ImLogLevel.all,
    List<TableSchema> schemas = const [],
  }) async {
    final InitConfig config = InitConfig(
      platformID: platformID,
      apiAddr: apiAddr,
      authAddr: authAddr,
      wsAddr: wsAddr,
      dbPath: dataDir,
      schemas: schemas,
    );
    try {
      ImLogConfig logConfig = ImLogConfig();
      logConfig.setLevel(logLevel);
      _log.info(config.toString(), methodName: 'initSDK');
      // 注册配置
      _getIt.registerSingleton<InitConfig>(config, instanceName: InstanceName.initConfig);

      // 初始化 HTTP 层
      HttpClient().init(baseUrl: config.apiAddr);

      // 初始化 Chat 服务端 HTTP 客户端
      if (config.authAddr != null && config.authAddr!.isNotEmpty) {
        HttpClient().initChat(baseUrl: config.authAddr!);
      }

      // 设置 API 错误回调（对应 Go SDK 的 apiErrCallback）
      // 拦截 token 过期/无效等全局错误，触发 OnConnectListener 回调
      HttpClient().onApiError = _createApiErrorHandler(listener);

      ToStore toStore = await _initDatabase(
        dbPath: config.dbPath,
        dbName: config.dbName,
        schemas: config.schemas,
      );

      _getIt.registerSingleton(toStore, instanceName: InstanceName.toStore);

      final DatabaseService databaseService = DatabaseService(toStore: toStore);
      _getIt.registerSingleton<DatabaseService>(
        databaseService,
        instanceName: InstanceName.databaseService,
      );

      // 注册 IM API 服务
      final ImApiService imApiService = ImApiService();
      _getIt.registerSingleton<ImApiService>(imApiService, instanceName: InstanceName.imApiService);

      // 初始化 WebSocket 连接管理器
      final WebSocketService webSocketService = WebSocketService(
        wsUrl: config.wsAddr,
        platformID: config.platformID ?? PlatformUtils.platformID,
        connectListener: listener,
      );
      _getIt.registerSingleton<WebSocketService>(
        webSocketService,
        instanceName: InstanceName.webSocketService,
      );

      _log.info('OpenIM SDK initialized successfully', methodName: 'initSDK');
      return true;
    } catch (e, s) {
      _log.error('初始化失败：${e.toString()}', methodName: 'initSDK', error: e, stackTrace: s);
      return false;
    }
  }

  /// 初始化数据库
  /// [dbPath] 数据存储目录
  Future<ToStore> _initDatabase({
    String? dbPath,
    String? dbName,
    List<TableSchema> schemas = const [],
  }) async {
    try {
      return await ToStore.open(
        dbPath: dbPath,
        dbName: dbName ?? 'kurban_openim_sdk',
        schemas: [...DbSchema.allSchemas, ...schemas],
      );
    } catch (e, s) {
      _log.error('初始化数据库失败：${e.toString()}', error: e, stackTrace: s);
      throw OpenIMException(
        code: SDKErrorCode.initializedDatabaseError.code,
        message: SDKErrorCode.initializedDatabaseError.message,
      );
    }
  }

  ///加载登录配置（自动登录）
  ///从本地缓存读取登录用户数据，验证 token 是否有效，若有效则自动登录
  ///适用于 App 启动时自动登录场景
  ///调用完此方法后可以使用[getLoginStatus] 判断是否自动登录成功
  ///此方法建议在启动页（splash）页中调用，因为涉及网络请求，可能会有一定延迟
  Future<LoginStatus> loadLoginConfig() async {
    try {
      String? value = await getDatabaseInstance().getValue(CacheKey.loginAuthData, isGlobal: true);
      if (value != null) {
        try {
          AuthCacheData authCacheData = AuthCacheData.fromJson(jsonDecode(value));
          bool result = await checkToken(token: authCacheData.imToken);
          if (result) {
            _authData = authCacheData;
            HttpClient().setChatToken(authCacheData.chatToken);
            await login(userID: authCacheData.userID, token: authCacheData.imToken);
          } else {
            _loginStatus = LoginStatus.logout;
          }
        } catch (e, s) {
          _log.error(e.toString(), methodName: 'loadLoginConfig', error: e, stackTrace: s);
        }
      }
      return _loginStatus;
    } catch (e, s) {
      _log.error(e.toString(), methodName: 'loadLoginConfig', error: e, stackTrace: s);
      throw OpenIMException(
        code: SDKErrorCode.initializedError.code,
        message: SDKErrorCode.initializedError.message,
      );
    }
  }

  ///检验登录的 token 是否有效
  Future<bool> checkToken({required String token}) async {
    _log.info('检查 Token', methodName: 'checkToken');
    final ImApiService imApiService = _getIt.get<ImApiService>(
      instanceName: InstanceName.imApiService,
    );
    try {
      ApiResponse result = await imApiService.parseToken(token: token);
      _log.info('检查 Token 结果：${result.toJson()}', methodName: 'checkToken');
      return result.isSuccess;
    } catch (e) {
      _log.warning('检查 Token 失败: $e');
      return false;
    }
  }

  /// 获取数据库实例
  /// 为了保证项目中只有一个实例提供的便捷方法，初始化之后可用
  ToStore getDatabaseInstance() {
    _log.info('获取数据库实例', methodName: 'getDatabaseInstance');
    if (!_getIt.isRegistered<ToStore>(instanceName: InstanceName.toStore)) {
      throw OpenIMException(
        code: SDKErrorCode.initializedDatabaseError.code,
        message: SDKErrorCode.initializedDatabaseError.message,
      );
    }
    return _getIt.get<ToStore>(instanceName: InstanceName.toStore);
  }

  /// 反初始化 SDK
  Future<void> unInitSDK() async {
    _log.info('unInitSDK');
    _loginStatus = .logout;
    if (_getIt.isRegistered<InitConfig>(instanceName: InstanceName.initConfig)) {
      await _getIt.unregister<InitConfig>(instanceName: InstanceName.initConfig);
    }
    if (_getIt.isRegistered<DatabaseService>(instanceName: InstanceName.databaseService)) {
      await _getIt.unregister<DatabaseService>(instanceName: InstanceName.databaseService);
    }

    if (_getIt.isRegistered<ImApiService>(instanceName: InstanceName.imApiService)) {
      await _getIt.unregister<ImApiService>(instanceName: InstanceName.imApiService);
    }

    if (_getIt.isRegistered<WebSocketService>(instanceName: InstanceName.webSocketService)) {
      await _getIt.unregister<WebSocketService>(instanceName: InstanceName.webSocketService);
    }
    if (_getIt.isRegistered<UserInfo>(instanceName: InstanceName.loginUser)) {
      await _getIt.unregister<UserInfo>(instanceName: InstanceName.loginUser);
    }
  }

  /// Chat 服务端登录（内部方法）
  /// 向 chatAddr + /account/login 发起请求，返回 {userID, imToken, chatToken}
  Future<AuthCacheData> _chatLogin(Map<String, dynamic> body) async {
    final InitConfig config = _getIt.get<InitConfig>(instanceName: InstanceName.initConfig);
    final String? authAddr = config.authAddr;
    if (authAddr == null || authAddr.isEmpty) {
      throw OpenIMException(
        code: SDKErrorCode.configError.code,
        message: 'authAddr 未配置，请在 initSDK 方法中中设置 authAddr',
      );
    }

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: authAddr,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {'operationID': OpenImUtils.generateOperationID(operationName: 'chatLogin')},
      ),
    );

    final Response response = await dio.post('/account/login', data: body);
    dio.close();
    final Map<String, dynamic> data = response.data as Map<String, dynamic>;
    _log.info('登录接口响应: $data');
    ApiResponse apiResponse = ApiResponse.fromJson(data);
    if (apiResponse.isSuccess) {
      return AuthCacheData.fromJson(apiResponse.data);
    } else {
      if (apiResponse.errCode == SDKErrorCode.accountNotRegistered.code) {
        throw OpenIMException(
          code: SDKErrorCode.accountNotRegistered.code,
          message: SDKErrorCode.accountNotRegistered.message,
        );
      } else if (apiResponse.errCode == SDKErrorCode.passwordError.code) {
        throw OpenIMException(
          code: SDKErrorCode.passwordError.code,
          message: SDKErrorCode.passwordError.message,
        );
      } else if (apiResponse.errCode == SDKErrorCode.ipBanned.code) {
        throw OpenIMException(
          code: SDKErrorCode.ipBanned.code,
          message: SDKErrorCode.ipBanned.message,
        );
      } else {
        throw OpenIMException(
          code: SDKErrorCode.loginError.code,
          message: '获取登录Token失败: ${data.toString()}',
        );
      }
    }
  }

  /// 登录
  /// [userID] 用户ID
  /// [token] 用户 token
  Future<UserInfo> login({required String userID, required String token}) async {
    _log.info('userID=$userID ,token=$token', methodName: 'login');
    _loginStatus = LoginStatus.logging;
    HttpClient().setToken(token);
    final DatabaseService databaseService = _getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );
    final ImApiService imApiService = _getIt.get<ImApiService>(
      instanceName: InstanceName.imApiService,
    );
    final ApiResponse response = await imApiService.getUsersInfo(userIDs: [userID]);
    if (response.isSuccess) {
      final dataMap = response.data as Map<String, dynamic>;
      final users = dataMap['usersInfo'] as List?;
      if (users != null && users.isNotEmpty) {
        final userData = Map<String, dynamic>.from(users.first as Map);
        await databaseService.upsertUser(userData);
        UserInfo user = UserInfo.fromJson(userData);
        if (_getIt.isRegistered<UserInfo>(instanceName: InstanceName.loginUser)) {
          await _getIt.unregister<UserInfo>(instanceName: InstanceName.loginUser);
        }
        _getIt.registerSingleton<UserInfo>(user, instanceName: InstanceName.loginUser);
      } else {
        _loginStatus = LoginStatus.logout;
        throw OpenIMException(
          code: SDKErrorCode.loginError.code,
          message: '登录失败，获取登录用户 $userID 信息失败。',
        );
      }
    } else {
      _loginStatus = LoginStatus.logout;
      throw OpenIMException(code: SDKErrorCode.loginError.code, message: '登录失败，获取登录用户信息失败。');
    }
    conversationManager.setCurrentUserID(userID);
    groupManager.setCurrentUserID(userID);
    messageManager.setCurrentUserID(userID);
    messageManager.setConversationManager(conversationManager);
    friendshipManager.setCurrentUserID(userID);
    friendshipManager.setConversationManager(conversationManager);
    userManager.setCurrentUserID(userID);
    momentsManager.setCurrentUserID(userID);
    favoriteManager.setCurrentUserID(userID);
    callManager.setCurrentUserID(userID);
    callManager.setSendSignalingFn((toUserID, data, {bool isInvite = false}) {
      _sendCallSignaling(toUserID, data, isInvite: isInvite);
    });
    // 初始化数据库（以用户维度）
    await databaseService.switchSpace(userID: userID);
    _loginStatus = LoginStatus.logged;
    final dispatcher = NotificationDispatcher(
      database: databaseService,
      api: imApiService,
      friendshipManager: friendshipManager,
      groupManager: groupManager,
      userManager: userManager,
      conversationManager: conversationManager,
      messageManager: messageManager,
      momentsManager: momentsManager,
      favoriteManager: favoriteManager,
    );
    dispatcher.setLoginUserID(userID);
    dispatcher.listenerForService = _listenerForService;
    _notificationDispatcher = dispatcher;
    final msgSyncer = MsgSyncer(
      database: databaseService,
      api: imApiService,
      notificationDispatcher: dispatcher,
      messageManager: messageManager,
      conversationManager: conversationManager,
      momentsManager: momentsManager,
      favoriteManager: favoriteManager,
    );
    msgSyncer.setLoginUserID(userID);
    msgSyncer.listenerForService = _listenerForService;
    msgSyncer.callManager = callManager;
    _msgSyncer = msgSyncer;
    final WebSocketService webSocketService = _getIt.get<WebSocketService>(
      instanceName: InstanceName.webSocketService,
    );
    webSocketService.onConnected = () {
      _msgSyncer?.doConnectedSync();
    };
    webSocketService.connect(userID: userID, token: token);
    webSocketService.onPushMsg = msgSyncer.handlePushMsg;
    // 恢复发送中的消息（App 重启后重新登录时调用）
    messageManager.recoverSendingMessages();
    _log.info('用户已登录: $userID');
    return _getIt.get<UserInfo>(instanceName: InstanceName.loginUser);
  }

  /// 使用邮箱登录（包含 SDK login）
  /// 调用 chat 服务端登录后，自动使用返回的 userID 和 imToken 完成 SDK 登录。
  /// [password] 和 [verificationCode] 二选一，必须提供其中一个。
  Future<UserInfo> loginByEmail({
    required String email,
    String? password,
    String? verificationCode,
  }) async {
    assert(password != null || verificationCode != null, 'password 和 verificationCode 必须提供其中一个');
    _log.info('email=$email', methodName: 'loginByEmail');
    final body = <String, dynamic>{'email': email, 'platform': PlatformUtils.platformID};
    if (verificationCode != null) {
      body['verifyCode'] = verificationCode;
    } else {
      body['password'] = OpenImUtils.generateMD5(password!);
    }
    AuthCacheData loginData = await _chatLogin(body);
    _authData = loginData;
    HttpClient().setChatToken(loginData.chatToken);
    final userInfo = await login(userID: loginData.userID, token: loginData.imToken);
    // 保存登录数据到缓存（用于自动登录）
    final DatabaseService db = _getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );
    await db.toStore.setValue(CacheKey.loginAuthData, loginData.toString(), isGlobal: true);
    return userInfo;
  }

  /// 使用手机号登录（包含 SDK login）
  /// 调用 chat 服务端登录后，自动使用返回的 userID 和 imToken 完成 SDK 登录。
  /// [password] 和 [verificationCode] 二选一，必须提供其中一个。
  Future<UserInfo> loginByPhone({
    required String areaCode,
    required String phoneNumber,
    String? password,
    String? verificationCode,
  }) async {
    assert(password != null || verificationCode != null, 'password 和 verificationCode 必须提供其中一个');
    _log.info('areaCode=$areaCode, phoneNumber=$phoneNumber', methodName: 'loginByPhone');
    final body = <String, dynamic>{
      'areaCode': areaCode,
      'phoneNumber': phoneNumber,
      'platform': PlatformUtils.platformID,
    };
    if (verificationCode != null) {
      body['verifyCode'] = verificationCode;
    } else {
      body['password'] = OpenImUtils.generateMD5(password!);
    }
    AuthCacheData loginData = await _chatLogin(body);
    _authData = loginData;
    HttpClient().setChatToken(loginData.chatToken);
    final userInfo = login(userID: loginData.userID, token: loginData.imToken);
    // 保存登录数据到缓存（用于自动登录）
    final DatabaseService db = _getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );
    await db.toStore.setValue(CacheKey.loginAuthData, loginData.toString(), isGlobal: true);
    return userInfo;
  }

  /// 使用账号登录（包含 SDK login）
  /// 账号登录仅支持密码方式，不支持验证码。
  Future<UserInfo> loginByAccount({required String account, required String password}) async {
    _log.info('loginByAccount: account=$account');
    AuthCacheData loginData = await _chatLogin({
      'account': account,
      'password': OpenImUtils.generateMD5(password),
      'platform': PlatformUtils.platformID,
    });
    _authData = loginData;
    HttpClient().setChatToken(loginData.chatToken);
    _log.info('账号 Chat 登录成功: $account, userID=${loginData.userID}');
    final userInfo = await OpenIM.iMManager.login(
      userID: loginData.userID,
      token: loginData.imToken,
    );
    // 保存登录数据到缓存（用于自动登录）
    final DatabaseService db = _getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );
    await db.toStore.setValue(CacheKey.loginAuthData, loginData.toString(), isGlobal: true);
    return userInfo;
  }

  /// 登出
  Future<void> logout() async {
    _log.info('退出登录方法', methodName: 'logout');
    try {
      _loginStatus = LoginStatus.logout;
      final WebSocketService webSocketService = _getIt.get<WebSocketService>(
        instanceName: InstanceName.webSocketService,
      );
      // 断开 WebSocket
      await webSocketService.disconnect();

      // 取消防抖 Timer
      _notificationDispatcher?.dispose();
      _notificationDispatcher = null;
      _msgSyncer = null;

      // 清理通话管理器
      callManager.dispose();

      // 清除 HTTP token
      HttpClient().setToken(null);
      HttpClient().setChatToken(null);
      _authData = null;
      final DatabaseService databaseService = _getIt.get<DatabaseService>(
        instanceName: InstanceName.databaseService,
      );
      // 清除登录缓存，但不关闭数据库（避免 Web 上重新登录时操作已关闭的 IndexedDB 挂起）
      await databaseService.toStore.setValue(CacheKey.loginAuthData, null, isGlobal: true);
      if (_getIt.isRegistered<UserInfo>(instanceName: InstanceName.loginUser)) {
        await _getIt.unregister<UserInfo>(instanceName: InstanceName.loginUser);
      }

      _log.info('用户已登出');
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'logout');
      throw OpenIMException(code: SDKErrorCode.loginError.code, message: '退出登录失败');
    }
  }

  /// 是否已初始化
  bool get isInitialized {
    return _getIt.isRegistered<InitConfig>(instanceName: InstanceName.initConfig);
  }

  /// 获取登录状态
  /// 1: logout  2: logging  3: logged
  LoginStatus get getLoginStatus {
    return _loginStatus;
  }

  /// 获取当前登录用户ID
  String getLoginUserID() {
    return _getIt.get<UserInfo>(instanceName: InstanceName.loginUser).userID;
  }

  String get userID {
    return _getIt.get<UserInfo>(instanceName: InstanceName.loginUser).userID;
  }

  /// 获取当前登录用户信息
  UserInfo getLoginUserInfo() {
    return _getIt.get<UserInfo>(instanceName: InstanceName.loginUser);
  }

  UserInfo get userInfo {
    return _getIt.get<UserInfo>(instanceName: InstanceName.loginUser);
  }

  /// 分片上传限制参数缓存（对应 Go SDK File.partLimit）
  Map<String, dynamic>? _partLimitCache;

  /// 上传文件
  /// [id] 文件标识，用于回调区分
  /// [filePath] 本地文件路径（native 平台）
  /// [fileBytes] 文件字节数据（web 平台，与 filePath 二选一）
  /// [fileName] 上传后的文件名
  /// [contentType] MIME 类型（可选，自动检测）
  /// [cause] 上传原因/用途
  /// [onProgress] 上传进度回调 (sent, total)
  Future<String> uploadFile({
    required String id,
    String? filePath,
    Uint8List? fileBytes,
    required String fileName,
    String? contentType,
    String? cause,
    void Function(int sent, int total)? onProgress,
  }) async {
    assert(filePath != null || fileBytes != null, 'filePath 和 fileBytes 必须提供其中一个');
    _log.info(
      'id=$id, filePath=$filePath, fileName=$fileName, contentType=$contentType, cause=$cause, hasBytes=${fileBytes != null}',
      methodName: 'uploadFile',
    );

    final ImApiService imApiService = _getIt.get<ImApiService>(
      instanceName: InstanceName.imApiService,
    );
    final DatabaseService databaseService = _getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );

    // 获取文件大小
    final int fileSize;
    if (fileBytes != null) {
      fileSize = fileBytes.length;
    } else {
      final file = File(filePath!);
      if (!await file.exists()) {
        throw OpenIMException(
          code: SDKErrorCode.uploadFileNotExist.code,
          message: SDKErrorCode.uploadFileNotExist.message,
        );
      }
      fileSize = await file.length();
    }

    _uploadFileListener?.open(id, fileSize);

    // 从服务端获取分片大小限制（对应 Go SDK partSize 函数）
    final int partSize = await _getPartSize(imApiService, fileSize);
    final int partNum = (fileSize / partSize).ceil().clamp(1, 10000);
    _uploadFileListener?.partSize(id, partSize, partNum);

    // 计算每个分片的实际大小
    final partSizes = List<int>.generate(partNum, (i) {
      if (i < partNum - 1) return partSize;
      return fileSize - partSize * (partNum - 1);
    });

    // 在后台 Isolate 中批量计算所有分片的 MD5（避免阻塞主线程）
    final partMd5s = await isolate_util.computePartMd5s(
      isolate_util.ComputePartMd5sParam(
        filePath: filePath,
        fileBytes: fileBytes,
        partSize: partSize,
        partNum: partNum,
        fileSize: fileSize,
      ),
    );
    final partEtags = List<String?>.filled(partNum, null);

    for (int i = 0; i < partNum; i++) {
      _uploadFileListener?.hashPartProgress(id, i, partSizes[i], partMd5s[i]);
    }

    // 在后台 Isolate 中计算组合 MD5
    final String combinedHashStr = partMd5s.join(',');
    final String hash = await isolate_util.computeCombinedMd5(partMd5s);
    _uploadFileListener?.hashPartComplete(id, combinedHashStr, hash);

    // 对应 Go SDK: name 前缀为 loginUserID + "/"
    String objectName = fileName;
    final prefix = '$userID/';
    if (!objectName.startsWith(prefix)) {
      objectName = '$prefix$objectName';
    }
    if (objectName.startsWith('/')) {
      objectName = objectName.substring(1);
    }

    // 获取本地缓存的续传任务（对应 Go SDK getLocalUploadInfo）
    final cachedTask = await databaseService.getUploadTaskByHashAndName(hash, objectName);
    final cachedUploadID = cachedTask?['uploadID'] as String?;
    final cachedUploadedParts = ((cachedTask?['uploadedParts'] as List?) ?? const [])
        .map((e) => (e as num?)?.toInt() ?? 0)
        .where((e) => e > 0)
        .toSet();

    // 1. 发起分片上传
    final int maxParts = partNum.clamp(1, 20);
    final initResp = await imApiService.initiateMultipartUpload(
      hash: hash,
      size: fileSize,
      partSize: partSize,
      maxParts: maxParts,
      cause: cause ?? '',
      name: objectName,
      contentType: contentType ?? 'application/octet-stream',
    );
    if (initResp.errCode != 0) {
      throw Exception('Initiate upload failed: ${initResp.errMsg}');
    }

    final respData = initResp.data ?? {};
    final url = respData['url'] as String?;

    // 如果服务端返回 url，说明文件已存在（秒传）
    if (url != null && url.isNotEmpty) {
      _uploadFileListener?.complete(id, fileSize, url, 0);
      return url;
    }

    final upload = respData['upload'] as Map<String, dynamic>? ?? {};
    final uploadID = upload['uploadID'] as String? ?? '';

    // 对应 Go SDK: 验证服务端返回的 partSize 是否一致
    final serverPartSize = upload['partSize'] as int?;
    if (serverPartSize != null && serverPartSize != partSize) {
      _partLimitCache = null; // 清除缓存，下次重新获取
      throw Exception('part size not match, expect $partSize, got $serverPartSize');
    }

    _uploadFileListener?.uploadID(id, uploadID);

    // 判断是否可续传（对应 Go SDK bitmap 机制）
    final canResume = cachedUploadID != null && cachedUploadID == uploadID;
    if (uploadID.isNotEmpty) {
      await databaseService.upsertUploadTask({
        'uploadID': uploadID,
        'hash': hash,
        'name': objectName,
        'fileSize': fileSize,
        'partSize': partSize,
        'partNum': partNum,
        'uploadedParts': canResume ? cachedUploadedParts.toList() : <int>[],
        'updateTime': DateTime.now().millisecondsSinceEpoch,
      });
    }

    // 恢复已上传分片（对应 Go SDK bitmap.Get(i)）
    int uploadedSize = 0;
    if (canResume) {
      for (final part in cachedUploadedParts) {
        final idx = part - 1;
        if (idx >= 0 && idx < partEtags.length) {
          partEtags[idx] = partMd5s[idx];
          uploadedSize += partSizes[idx];
        }
      }
    }
    final bool continueUpload = uploadedSize > 0;

    final sign = upload['sign'] as Map<String, dynamic>? ?? {};
    // AWS S3 签名：sign 包含 url 和 parts
    final signUrl = sign['url'] as String? ?? '';
    // 从 sign.query 中获取 uploadId
    String? uploadIdParam;
    final signQuery = sign['query'] as List?;
    if (signQuery != null && signQuery.isNotEmpty) {
      for (final q in signQuery) {
        if (q is Map && q['key'] == 'uploadId') {
          final values = q['values'] as List?;
          if (values != null && values.isNotEmpty) {
            uploadIdParam = values.first.toString();
          }
          break;
        }
      }
    }
    // 全局 header（sign.header）
    final signHeader = sign['header'] as List?;
    var currentSignParts = (sign['parts'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    // 2. 逐片上传
    for (int i = 0; i < partNum; i++) {
      final currentPartSize = partSizes[i];
      final partNumber = i + 1;

      if (partEtags[i] != null) {
        // 已上传分片（恢复场景）直接跳过，但仍需验证 MD5
        _uploadFileListener?.uploadPartComplete(id, i, currentPartSize, partMd5s[i]);
        continue;
      }

      final start = i * partSize;
      final end = (start + currentPartSize).clamp(0, fileSize);
      // 在后台 Isolate 中读取分片数据，避免阻塞主线程
      final Uint8List partBytes;
      if (fileBytes != null) {
        partBytes = fileBytes.sublist(start, end);
      } else {
        partBytes = await isolate_util.readFilePart(
          isolate_util.ReadFilePartParam(filePath: filePath!, start: start, length: end - start),
        );
      }

      // 从当前缓存中寻找对应 partNumber 的签名
      var partInfo = currentSignParts.firstWhere(
        (p) => p['partNumber'] == partNumber,
        orElse: () => <String, dynamic>{},
      );

      // 如果未找到（例如超过了 maxParts），请求新的一批签名
      // 对应 Go SDK GetPartSign → authSign
      if (partInfo.isEmpty) {
        final nextBatch = <int>[];
        for (int j = 0; j < 20 && (partNumber + j) <= partNum; j++) {
          nextBatch.add(partNumber + j);
        }
        final authResp = await imApiService.authSign(uploadID: uploadID, partNumbers: nextBatch);
        if (authResp.errCode != 0) {
          throw Exception('authSign failed: ${authResp.errMsg}');
        }
        final newSign = authResp.data as Map<String, dynamic>? ?? {};
        currentSignParts = (newSign['parts'] as List?)?.cast<Map<String, dynamic>>() ?? [];

        partInfo = currentSignParts.firstWhere(
          (p) => p['partNumber'] == partNumber,
          orElse: () => <String, dynamic>{},
        );
      }

      // 构建上传 URL 和 Header（对应 Go SDK UploadInfo.buildRequest）
      final putUrl = _buildPartPutUrl(signUrl, uploadIdParam, signHeader, partInfo);
      final headers = _buildPartHeaders(signHeader, partInfo);

      if (putUrl.isNotEmpty) {
        final putResp = await HttpClient().dio.put(
          putUrl,
          data: partBytes,
          options: Options(
            headers: {...headers, Headers.contentLengthHeader: partBytes.length},
            contentType: contentType ?? 'application/octet-stream',
          ),
          onSendProgress: (sent, total) {
            // 对应 Go SDK UploadComplete(fileSize, uploadedSize+current, uploadedSize)
            _uploadFileListener?.uploadProgress(id, fileSize, uploadedSize + sent, uploadedSize);
            onProgress?.call(uploadedSize + sent, fileSize);
          },
        );

        if (putResp.statusCode != null &&
            (putResp.statusCode! < 200 || putResp.statusCode! >= 300)) {
          throw Exception(
            'Part upload HTTP failed (status: ${putResp.statusCode}): ${putResp.data}',
          );
        }
      }

      // 验证 MD5（对应 Go SDK md5Reader.Md5() 校验）
      final localMd5 = await isolate_util.computeMd5(partBytes);
      if (localMd5 != partMd5s[i]) {
        throw Exception(
          'upload part $i failed, md5 not match, expect ${partMd5s[i]}, got $localMd5',
        );
      }

      partEtags[i] = partMd5s[i];
      uploadedSize += currentPartSize;
      _uploadFileListener?.uploadPartComplete(id, i, currentPartSize, partMd5s[i]);

      // 更新续传记录（对应 Go SDK bitmap.Set + UpdateUpload）
      if (uploadID.isNotEmpty) {
        await databaseService.upsertUploadTask({
          'uploadID': uploadID,
          'uploadedParts': [
            for (int idx = 0; idx < partEtags.length; idx++)
              if (partEtags[idx] != null) idx + 1,
          ],
          'updateTime': DateTime.now().millisecondsSinceEpoch,
        });
      }
    }

    // 3. 完成分片上传（对应 Go SDK completeMultipartUpload）
    final completeResp = await imApiService.completeMultipartUpload(
      uploadID: uploadID,
      parts: partMd5s,
      name: objectName,
      contentType: contentType ?? 'application/octet-stream',
      cause: cause ?? '',
    );
    if (completeResp.errCode != 0) {
      throw Exception('Complete upload failed: ${completeResp.errMsg}');
    }

    final resultUrl = (completeResp.data?['url'] as String?) ?? '';

    // 清理续传记录（对应 Go SDK DeleteUpload）
    if (uploadID.isNotEmpty) {
      await databaseService.deleteUploadTask(uploadID);
    }

    // typ: 1=正常上传完成, 2=续传完成（对应 Go SDK）
    final typ = continueUpload ? 2 : 1;
    _uploadFileListener?.complete(id, fileSize, resultUrl, typ);
    return resultUrl;
  }

  /// 从服务端获取分片大小（对应 Go SDK File.partSize）
  Future<int> _getPartSize(ImApiService api, int fileSize) async {
    if (_partLimitCache == null) {
      final resp = await api.getPartLimit();
      if (resp.errCode == 0 && resp.data != null) {
        _partLimitCache = resp.data as Map<String, dynamic>;
      }
    }

    if (_partLimitCache != null) {
      final minPartSize = (_partLimitCache!['minPartSize'] as num?)?.toInt() ?? (5 * 1024 * 1024);
      final maxPartSize =
          (_partLimitCache!['maxPartSize'] as num?)?.toInt() ?? (5 * 1024 * 1024 * 1024);
      final maxNumSize = (_partLimitCache!['maxNumSize'] as num?)?.toInt() ?? 10000;

      if (fileSize > maxPartSize * maxNumSize) {
        throw Exception('file size $fileSize exceeds maximum ${maxPartSize * maxNumSize}');
      }
      if (fileSize <= minPartSize * maxNumSize) {
        return minPartSize;
      }
      var ps = fileSize ~/ maxNumSize;
      if (fileSize % maxNumSize != 0) {
        ps++;
      }
      return ps;
    }

    // fallback：5MB
    return 5 * 1024 * 1024;
  }

  /// 构建分片上传的完整 URL（对应 Go SDK UploadInfo.buildRequest）
  String _buildPartPutUrl(
    String signUrl,
    String? uploadIdParam,
    List? signHeader,
    Map<String, dynamic> partInfo,
  ) {
    // 优先使用 part 自己的 url
    String putUrl = partInfo['url'] as String? ?? '';
    if (putUrl.isNotEmpty) return putUrl;
    if (signUrl.isEmpty) return '';

    // 合并 sign.query 和 part.query（对应 Go SDK buildRequest 的 query 合并逻辑）
    final uri = Uri.parse(signUrl);
    final queryParams = Map<String, String>.from(uri.queryParameters);

    // 添加 sign 级别的 query（如 uploadId）
    if (uploadIdParam != null) {
      queryParams['uploadId'] = uploadIdParam;
    }

    // 添加 part 级别的 query
    final rawQuery = partInfo['query'] as List?;
    if (rawQuery != null) {
      for (final q in rawQuery) {
        if (q is Map) {
          final key = q['key']?.toString() ?? '';
          final values = q['values'] as List?;
          if (values != null && values.isNotEmpty && key.isNotEmpty) {
            queryParams[key] = values.first.toString();
          }
        }
      }
    }

    return uri.replace(queryParameters: queryParams).toString();
  }

  /// 构建分片上传的 Header（对应 Go SDK buildRequest 的 header 合并逻辑）
  Map<String, String> _buildPartHeaders(List? signHeader, Map<String, dynamic> partInfo) {
    final headers = <String, String>{};

    // sign 级别的 header
    if (signHeader != null) {
      for (final h in signHeader) {
        if (h is Map) {
          final key = h['key']?.toString();
          final values = h['values'] as List?;
          if (key != null && values != null && values.isNotEmpty) {
            headers[key] = values.first.toString();
          }
        }
      }
    }

    // part 级别的 header（覆盖 sign 级别）
    final rawHeaders = partInfo['header'];
    if (rawHeaders is List) {
      for (final h in rawHeaders) {
        if (h is Map) {
          final key = h['key']?.toString();
          final values = h['values'] as List?;
          if (key != null && values != null && values.isNotEmpty) {
            headers[key] = values.first.toString();
          }
        }
      }
    } else if (rawHeaders is Map) {
      for (final entry in rawHeaders.entries) {
        final val = entry.value;
        if (val is List && val.isNotEmpty) {
          headers[entry.key.toString()] = val.first.toString();
        } else if (val != null) {
          headers[entry.key.toString()] = val.toString();
        }
      }
    }

    return headers;
  }

  /// 设置 App 前后台状态
  /// 对应 Go SDK SetAppBackgroundStatus
  /// [isBackground] true=后台, false=前台
  Future<void> setAppBackgroundStatus({required bool isBackground}) async {
    _log.info('isBackground=$isBackground', methodName: 'setAppBackgroundStatus');
    final WebSocketService webSocketService = _getIt.get<WebSocketService>(
      instanceName: InstanceName.webSocketService,
    );
    webSocketService.setBackground(isBackground);
    try {
      await webSocketService.sendRequestWaitResponse(
        reqIdentifier: WebSocketIdentifier.setBackgroundStatus,
        data: _encodeBackgroundStatusReq(isBackground),
      );
      if (!isBackground) {
        unawaited(_msgSyncer?.doWakeupSync());
      }
    } catch (e, s) {
      _log.error('设置失败', error: e, stackTrace: s, methodName: 'setAppBackgroundStatus');
    }
  }

  Uint8List _encodeBackgroundStatusReq(bool isBackground) {
    final req = sdkws.SetAppBackgroundStatusReq()
      ..userID = userID
      ..isBackground = isBackground;
    return req.writeToBuffer();
  }

  /// 网络状态变更通知
  /// 对应 Go SDK NetworkStatusChanged —— 关闭长连接触发自动重连
  Future<void> networkStatusChanged() async {
    _log.info('', methodName: 'networkStatusChanged');
    try {
      final WebSocketService webSocketService = _getIt.get<WebSocketService>(
        instanceName: InstanceName.webSocketService,
      );
      await webSocketService.reconnect();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'networkStatusChanged');
    }
  }

  /// 更新 FCM 推送 Token
  /// 对应 Go SDK UpdateFcmToken
  /// [fcmToken] FCM 设备令牌
  /// [expireTime] 过期时间（秒级时间戳）
  Future<void> updateFcmToken({required String fcmToken, int expireTime = 0}) async {
    _log.info('fcmToken=$fcmToken', methodName: 'updateFcmToken');
    try {
      final ImApiService imApiService = _getIt.get<ImApiService>(
        instanceName: InstanceName.imApiService,
      );
      final resp = await imApiService.fcmUpdateToken(
        platformID: PlatformUtils.platformID.toString(),
        fcmToken: fcmToken,
        account: userID,
        expireTime: expireTime,
      );
      if (resp.errCode != 0) {
        _log.warning('更新 FCM Token 失败: ${resp.errMsg}', methodName: 'updateFcmToken');
      }
    } catch (e, s) {
      _log.error('设置 fcm Token 失败', error: e, stackTrace: s, methodName: 'updateFcmToken');
    }
  }

  /// 设置 App 角标未读数
  /// 对应 Go SDK SetAppBadge
  /// [appUnreadCount] 角标显示的未读数量
  Future<void> setAppBadge({required int appUnreadCount}) async {
    _log.info('appUnreadCount=$appUnreadCount', methodName: 'setAppBadge');
    try {
      final ImApiService imApiService = _getIt.get<ImApiService>(
        instanceName: InstanceName.imApiService,
      );
      final resp = await imApiService.setAppBadge(userID: userID, appUnreadCount: appUnreadCount);
      if (resp.errCode != 0) {
        _log.warning('设置 App 角标失败: ${resp.errMsg}');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setAppBadge');
    }
  }

  /// 发送通话信令消息（通过 OpenIM 自定义消息）
  ///
  /// [isInvite] 为 true 时，启用服务端持久化 + 离线推送，
  /// 确保被叫方即使不在线也能收到来电通知。
  void _sendCallSignaling(String toUserID, String data, {bool isInvite = false}) {
    try {
      final message = messageManager.createCustomMessage(
        data: data,
        extension: '',
        description: '',
      );
      messageManager.sendMessage(
        message: message,
        offlinePushInfo: OfflinePushInfo(title: '音视频通话', desc: '您有一个新的通话邀请'),
        userID: toUserID,
        isOnlineOnly: true,
        // 邀请信令需要服务端持久化 + 离线推送，
        // 确保离线用户上线后能收到来电。
        // 同时不更新会话列表、不计未读、不存历史。
        messageOptions: isInvite ? const {'persistent': true, 'offlinePush': true} : null,
      );
    } catch (e, s) {
      _log.error('发送信令失败', error: e, stackTrace: s, methodName: '_sendCallSignaling');
    }
  }

  /// 创建 API 错误处理器
  ///
  /// 对应 Go SDK 的 apiErrCallback.OnError：
  /// - TokenExpiredError (1501) → OnUserTokenExpired
  /// - TokenInvalidError/TokenMalformedError/TokenNotValidYetError/
  ///   TokenUnknownError/TokenNotExistError (1502-1505,1507) → OnUserTokenInvalid
  /// - TokenKickedError (1506) → OnKickedOffline
  ///
  /// 使用原子状态防止重复触发（每类只触发一次）
  void Function(int, String) _createApiErrorHandler(OnConnectListener listener) {
    bool tokenExpiredFired = false;
    bool tokenInvalidFired = false;
    bool kickedOfflineFired = false;

    return (int errCode, String errMsg) {
      switch (errCode) {
        case 1501: // TokenExpiredError
          if (!tokenExpiredFired) {
            tokenExpiredFired = true;
            _log.warning('Token 已过期');
            listener.userTokenExpired();
            unawaited(logout());
          }
        case 1502: // TokenInvalidError
        case 1503: // TokenMalformedError
        case 1504: // TokenNotValidYetError
        case 1505: // TokenUnknownError
        case 1507: // TokenNotExistError
          if (!tokenInvalidFired) {
            tokenInvalidFired = true;
            _log.warning('Token 无效: $errMsg');
            listener.userTokenInvalid();
            unawaited(logout());
          }
        case 1506: // TokenKickedError
          if (!kickedOfflineFired) {
            kickedOfflineFired = true;
            _log.warning('被踢下线 (Token Kicked)');
            listener.kickedOffline();
            unawaited(logout());
          }
      }
    };
  }
}
