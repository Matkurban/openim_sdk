import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/cache_key.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
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
import 'package:tostore/tostore.dart';

class IMManager {
  static final Logger _log = Logger('IMManager');

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

  /// 朋友圈管理
  late MomentsManager momentsManager;

  /// 收藏夹管理
  late FavoriteManager favoriteManager;

  /// 服务监听（可选）
  OnListenerForService? _listenerForService;

  /// 文件上传监听（可选）
  OnUploadFileListener? _uploadFileListener;

  /// 通知分发器（登录时创建，登出时清理）
  NotificationDispatcher? _notificationDispatcher;

  /// 当前登录用户 ID
  String? _userID;

  String get userID => _userID!;

  /// 当前登录用户信息
  UserInfo? _userInfo;

  UserInfo get userInfo => _userInfo!;

  AuthCacheData? _authData;

  AuthCacheData get authData => _authData!;

  /// 当前登录状态
  LoginStatus _loginStatus = LoginStatus.logout;

  IMManager() {
    conversationManager = ConversationManager();
    friendshipManager = FriendshipManager();
    messageManager = MessageManager();
    groupManager = GroupManager();
    userManager = UserManager();
    momentsManager = MomentsManager();
    favoriteManager = FavoriteManager();
  }

  final GetIt _getIt = GetIt.instance;

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
    required String chatAddr,
    String? dataDir,
    required OnConnectListener listener,
    Level logLevel = .ALL,
    List<TableSchema> schemas = const [],
  }) async {
    _log.info(
      'initSDK: platformID=$platformID, apiAddr=$apiAddr, wsAddr=$wsAddr, chatAddr=$chatAddr, dataDir=$dataDir, logLevel=$logLevel',
    );
    final InitConfig config = InitConfig(
      platformID: platformID,
      apiAddr: apiAddr,
      chatAddr: chatAddr,
      wsAddr: wsAddr,
      dbPath: dataDir,
      logLevel: logLevel,
      schemas: schemas,
    );
    try {
      hierarchicalLoggingEnabled = true;
      Logger.root.level = config.logLevel;
      Logger.root.onRecord.listen((record) {
        log(
          '[${record.level.name}] ${record.time}: ${record.loggerName}: ${record.message}',
          stackTrace: record.stackTrace,
        );
      });

      // 注册配置
      _getIt.registerSingleton<InitConfig>(config, instanceName: InstanceName.initConfig);

      // 初始化 HTTP 层
      HttpClient().init(baseUrl: config.apiAddr);

      // 初始化 Chat 服务端 HTTP 客户端
      if (config.chatAddr != null && config.chatAddr!.isNotEmpty) {
        HttpClient().initChat(baseUrl: config.chatAddr!);
      }

      // 设置 API 错误回调（对应 Go SDK 的 apiErrCallback）
      // 拦截 token 过期/无效等全局错误，触发 OnConnectListener 回调
      HttpClient().onApiError = _createApiErrorHandler(listener);

      ToStore toStore = await _initDatabase(
        dbPath: config.dbPath ?? await OpenImUtils.defaultDbPath(),
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

      _log.info('OpenIM SDK initialized successfully');
      return true;
    } catch (e, s) {
      _log.severe(e.toString(), e, s);
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
    return await ToStore.open(
      dbPath: dbPath,
      dbName: dbName ?? 'kurban_openim_sdk',
      schemas: [...DbSchema.allSchemas, ...schemas],
    );
  }

  ///加载登录配置（自动登录）
  ///从本地缓存读取登录用户数据，验证 token 是否有效，若有效则自动登录
  ///适用于 App 启动时自动登录场景
  ///调用完此方法后可以使用[getLoginStatus] 判断是否自动登录成功
  ///此方法建议在启动页（splash）页中调用，因为涉及网络请求，可能会有一定延迟
  Future<LoginStatus> loadLoginConfig() async {
    String? value = await getDatabaseInstance().getValue(CacheKey.loginUserData, isGlobal: true);
    if (value != null) {
      try {
        AuthCacheData authCacheData = AuthCacheData.fromJson(jsonDecode(value));
        bool result = await checkToken(token: authCacheData.imToken);
        if (result) {
          _authData = authCacheData;
          HttpClient().setChatToken(authCacheData.chatToken);
          await login(userID: authCacheData.userID, token: authCacheData.imToken);
        }
      } catch (e, s) {
        _log.severe(e.toString(), e, s);
      }
    }
    return _loginStatus;
  }

  ///检验登录的 token 是否有效
  Future<bool> checkToken({required String token}) async {
    final ImApiService imApiService = _getIt.get<ImApiService>(
      instanceName: InstanceName.imApiService,
    );
    try {
      ApiResponse result = await imApiService.parseToken(token: token);
      return result.isSuccess;
    } catch (e) {
      _log.warning('检查 Token 失败: $e');
      return false;
    }
  }

  /// 获取数据库实例
  ToStore getDatabaseInstance() {
    return _getIt.get<ToStore>(instanceName: InstanceName.toStore);
  }

  /// 反初始化 SDK
  Future<void> unInitSDK() async {
    _log.info('unInitSDK');
    _userID = null;
    _userInfo = null;
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
  }

  /// Chat 服务端登录（内部方法）
  /// 向 chatAddr + /account/login 发起请求，返回 {userID, imToken, chatToken}
  Future<AuthCacheData> _chatLogin(Map<String, dynamic> body) async {
    final InitConfig config = _getIt.get<InitConfig>(instanceName: InstanceName.initConfig);
    final String? chatAddr = config.chatAddr;
    if (chatAddr == null || chatAddr.isEmpty) {
      throw Exception('chatAddr 未配置，请在 InitConfig 中设置 chatAddr');
    }

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: chatAddr,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {'operationID': OpenImUtils.generateOperationID(operationName: 'chatLogin')},
      ),
    );

    try {
      final Response response = await dio.post('/account/login', data: body);
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      _log.info('Chat 登录响应: $data');
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
          throw Exception('Chat 登录失败: ${apiResponse.errMsg}');
        }
      }
    } catch (e, s) {
      _log.severe(e.toString(), e, s);
      throw OpenIMException(
        code: SDKErrorCode.networkRequestError.code,
        message: SDKErrorCode.networkRequestError.message,
      );
    } finally {
      dio.close();
    }
  }

  /// 登录
  /// [userID] 用户ID
  /// [token] 用户 token
  @internal
  Future<UserInfo> login({required String userID, required String token}) async {
    _log.info('login: userID=$userID');
    _loginStatus = LoginStatus.logging;

    // 设置 HTTP token
    HttpClient().setToken(token);

    final DatabaseService databaseService = _getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );

    final ImApiService imApiService = _getIt.get<ImApiService>(
      instanceName: InstanceName.imApiService,
    );

    // 从服务端获取当前用户信息并存入本地
    final ApiResponse response = await imApiService.getUsersInfo(userIDs: [userID]);
    if (response.isSuccess) {
      final dataMap = response.data as Map<String, dynamic>;
      final users = dataMap['usersInfo'] as List?;
      if (users != null && users.isNotEmpty) {
        final userData = Map<String, dynamic>.from(users.first as Map);
        await databaseService.upsertUser(userData);
        _userInfo = UserInfo.fromJson(userData);
      }
    }
    if (_userInfo == null) {
      _loginStatus = LoginStatus.logout;
      throw OpenIMException(
        code: response.errCode,
        message: '${response.errMsg} : ${response.errDlt}',
      );
    }
    _userID = userID;
    conversationManager.setCurrentUserID(userID);
    groupManager.setCurrentUserID(userID);
    messageManager.setCurrentUserID(userID);
    messageManager.setConversationManager(conversationManager);
    friendshipManager.setCurrentUserID(userID);
    userManager.setCurrentUserID(userID);
    momentsManager.setCurrentUserID(userID);
    favoriteManager.setCurrentUserID(userID);
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

    final WebSocketService webSocketService = _getIt.get<WebSocketService>(
      instanceName: InstanceName.webSocketService,
    );
    webSocketService.connect(userID: userID, token: token);

    webSocketService.onPushMsg = msgSyncer.handlePushMsg;

    msgSyncer.doConnectedSync();

    _log.info('用户已登录: $userID');
    return _userInfo!;
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
    _log.info('loginByEmail: email=$email');
    final body = <String, dynamic>{'email': email, 'platform': PlatformUtils.platformID};
    if (verificationCode != null) {
      body['verifyCode'] = verificationCode;
    } else {
      body['password'] = OpenImUtils.generateMD5(password!);
    }
    AuthCacheData loginData = await _chatLogin(body);
    _authData = loginData;
    HttpClient().setChatToken(loginData.chatToken);
    _log.info('邮箱 Chat 登录成功: $email, userID=${loginData.userID}');
    final userInfo = await OpenIM.iMManager.login(
      userID: loginData.userID,
      token: loginData.imToken,
    );
    // 保存登录数据到缓存（用于自动登录）
    final DatabaseService db = _getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );
    await db.toStore.setValue(CacheKey.loginUserData, loginData.toString(), isGlobal: true);
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
    _log.info('loginByPhone: areaCode=$areaCode, phoneNumber=$phoneNumber');
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
    _log.info('手机号 Chat 登录成功: $areaCode$phoneNumber, userID=${loginData.userID}');
    final userInfo = await OpenIM.iMManager.login(
      userID: loginData.userID,
      token: loginData.imToken,
    );
    // 保存登录数据到缓存（用于自动登录）
    final DatabaseService db = _getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );
    await db.toStore.setValue(CacheKey.loginUserData, loginData.toString(), isGlobal: true);
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
    await db.toStore.setValue(CacheKey.loginUserData, loginData.toString(), isGlobal: true);
    return userInfo;
  }

  /// 登出
  Future<void> logout() async {
    _log.info('logout');
    _loginStatus = LoginStatus.logout;
    final WebSocketService webSocketService = _getIt.get<WebSocketService>(
      instanceName: InstanceName.webSocketService,
    );
    // 断开 WebSocket
    await webSocketService.disconnect();

    // 取消防抖 Timer
    _notificationDispatcher?.dispose();
    _notificationDispatcher = null;

    // 清除 HTTP token
    HttpClient().setToken(null);
    HttpClient().setChatToken(null);
    _authData = null;
    final DatabaseService databaseService = _getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );
    // 清除登录缓存，但不关闭数据库（避免 Web 上重新登录时操作已关闭的 IndexedDB 挂起）
    await databaseService.toStore.setValue(CacheKey.loginUserData, null, isGlobal: true);

    _log.info('用户已登出');
  }

  /// 设置服务监听（用于后台推送等场景）
  void setListenerForService(OnListenerForService listener) {
    _listenerForService = listener;
  }

  /// 设置文件上传进度监听
  void setUploadFileListener(OnUploadFileListener listener) {
    _uploadFileListener = listener;
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

  /// 上传文件
  /// [id] 文件标识，用于回调区分
  /// [filePath] 本地文件路径
  /// [fileName] 上传后的文件名
  /// [contentType] MIME 类型（可选，自动检测）
  /// [cause] 上传原因/用途
  Future<String> uploadFile({
    required String id,
    required String filePath,
    required String fileName,
    String? contentType,
    String? cause,
  }) async {
    _log.info(
      'uploadFile: id=$id, filePath=$filePath, fileName=$fileName, contentType=$contentType, cause=$cause',
    );
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception(SDKErrorCode.uploadFileNotExist.message);
    }

    final fileSize = await file.length();
    _uploadFileListener?.open(id, fileSize);

    // 计算文件 MD5
    final fileBytes = await file.readAsBytes();
    final hash = md5.convert(fileBytes).toString();

    // 分片大小: 2MB
    const partSize = 2 * 1024 * 1024;
    final partNum = (fileSize / partSize).ceil().clamp(1, 10000);
    _uploadFileListener?.partSize(id, partSize, partNum);

    final ImApiService imApiService = _getIt.get<ImApiService>(
      instanceName: InstanceName.imApiService,
    );

    // 1. 发起分片上传
    final initResp = await imApiService.initiateMultipartUpload(
      hash: hash,
      size: fileSize,
      partSize: partSize,
      maxParts: partNum.clamp(1, 20),
      cause: cause ?? '',
      name: '$_userID/$fileName',
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
    _uploadFileListener?.uploadID(id, uploadID);

    final sign = upload['sign'] as Map<String, dynamic>? ?? {};
    final parts = sign['parts'] as List? ?? [];

    // 2. 逐片上传
    final partMd5s = <String>[];
    for (int i = 0; i < partNum; i++) {
      final start = i * partSize;
      final end = (start + partSize).clamp(0, fileSize);
      final partBytes = fileBytes.sublist(start, end);
      final partHash = md5.convert(partBytes).toString();

      _uploadFileListener?.hashPartProgress(id, i, partBytes.length, partHash);

      if (i < parts.length) {
        final partInfo = parts[i] as Map<String, dynamic>;
        final putUrl = partInfo['url'] as String? ?? '';
        final headers = (partInfo['header'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, v?.toString() ?? ''),
        );

        if (putUrl.isNotEmpty) {
          await HttpClient().put(
            putUrl,
            data: Stream.fromIterable([partBytes]),
            options: Options(
              headers: {...?headers, Headers.contentLengthHeader: partBytes.length},
              contentType: contentType ?? 'application/octet-stream',
            ),
            onSendProgress: (sent, total) {
              _uploadFileListener?.uploadProgress(id, fileSize, start + sent, start);
            },
          );
        }
      }

      partMd5s.add(partHash);
      _uploadFileListener?.uploadPartComplete(id, i, partBytes.length, partHash);
    }

    _uploadFileListener?.hashPartComplete(id, partMd5s.join(','), hash);

    // 3. 完成分片上传
    final completeResp = await imApiService.completeMultipartUpload(
      uploadID: uploadID,
      parts: partMd5s,
      name: '$_userID/$fileName',
      contentType: contentType ?? 'application/octet-stream',
      cause: cause ?? '',
    );
    if (completeResp.errCode != 0) {
      throw Exception('Complete upload failed: ${completeResp.errMsg}');
    }

    final resultUrl = (completeResp.data?['url'] as String?) ?? '';
    _uploadFileListener?.complete(id, fileSize, resultUrl, 1);
    return resultUrl;
  }

  /// 获取当前登录用户ID
  String getLoginUserID() {
    return _userID!;
  }

  /// 获取当前登录用户信息
  UserInfo getLoginUserInfo() {
    return _userInfo!;
  }

  /// 获取 SDK 版本号
  /// 对应 Go SDK GetSdkVersion
  String getSdkVersion() {
    return '1.0.0';
  }

  /// 设置 App 前后台状态
  /// 对应 Go SDK SetAppBackgroundStatus
  /// [isBackground] true=后台, false=前台
  Future<void> setAppBackgroundStatus({required bool isBackground}) async {
    _log.info('setAppBackgroundStatus: isBackground=$isBackground');
    final WebSocketService webSocketService = _getIt.get<WebSocketService>(
      instanceName: InstanceName.webSocketService,
    );
    webSocketService.setBackground(isBackground);
    try {
      await webSocketService.sendRequestWaitResponse(
        reqIdentifier: WebSocketIdentifier.setBackgroundStatus,
        data: _encodeBackgroundStatusReq(isBackground),
      );
    } catch (e) {
      _log.warning('setAppBackgroundStatus 请求失败: $e');
    }
  }

  Uint8List _encodeBackgroundStatusReq(bool isBackground) {
    final req = sdkws.SetAppBackgroundStatusReq()
      ..userID = _userID!
      ..isBackground = isBackground;
    return req.writeToBuffer();
  }

  /// 网络状态变更通知
  /// 对应 Go SDK NetworkStatusChanged —— 关闭长连接触发自动重连
  Future<void> networkStatusChanged() async {
    _log.info('networkStatusChanged');
    final WebSocketService webSocketService = _getIt.get<WebSocketService>(
      instanceName: InstanceName.webSocketService,
    );
    await webSocketService.reconnect();
  }

  /// 更新 FCM 推送 Token
  /// 对应 Go SDK UpdateFcmToken
  /// [fcmToken] FCM 设备令牌
  /// [expireTime] 过期时间（秒级时间戳）
  Future<void> updateFcmToken({required String fcmToken, int expireTime = 0}) async {
    _log.info('updateFcmToken: fcmToken=${fcmToken.substring(0, fcmToken.length.clamp(0, 8))}...');
    final ImApiService imApiService = _getIt.get<ImApiService>(
      instanceName: InstanceName.imApiService,
    );
    final resp = await imApiService.fcmUpdateToken(
      platformID: PlatformUtils.platformID.toString(),
      fcmToken: fcmToken,
      account: _userID!,
      expireTime: expireTime,
    );
    if (resp.errCode != 0) {
      _log.warning('更新 FCM Token 失败: ${resp.errMsg}');
    }
  }

  /// 设置 App 角标未读数
  /// 对应 Go SDK SetAppBadge
  /// [appUnreadCount] 角标显示的未读数量
  Future<void> setAppBadge({required int appUnreadCount}) async {
    _log.info('setAppBadge: appUnreadCount=$appUnreadCount');
    final ImApiService imApiService = _getIt.get<ImApiService>(
      instanceName: InstanceName.imApiService,
    );
    final resp = await imApiService.setAppBadge(userID: _userID!, appUnreadCount: appUnreadCount);
    if (resp.errCode != 0) {
      _log.warning('设置 App 角标失败: ${resp.errMsg}');
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
            logout();
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
            logout();
          }
        case 1506: // TokenKickedError
          if (!kickedOfflineFired) {
            kickedOfflineFired = true;
            _log.warning('被踢下线 (Token Kicked)');
            listener.kickedOffline();
            logout();
          }
      }
    };
  }
}
