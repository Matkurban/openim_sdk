import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/network/msg_syncer.dart';
import 'package:openim_sdk/src/network/notification_dispatcher.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/db/db_schema.dart';
import 'package:openim_sdk/src/network/http_client.dart';
import 'package:openim_sdk/src/services/web_socket_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:openim_sdk/src/utils/im_utils.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';
import 'package:tostore/tostore.dart';

class IMManager {
  static final Logger _log = Logger('openim_sdk');

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

  /// 当前登录状态
  LoginStatus _loginStatus = LoginStatus.logout;

  /// Token
  String? token;

  IMManager() {
    conversationManager = ConversationManager();
    friendshipManager = FriendshipManager();
    messageManager = MessageManager();
    groupManager = GroupManager();
    userManager = UserManager();
  }

  /// 初始化 SDK
  /// [platformID] 平台ID
  /// [apiAddr] SDK API 地址
  /// [wsAddr] SDK WebSocket 地址
  /// [dataDir] SDK 数据库存储目录
  /// [listener] 连接状态监听
  /// [logLevel] 日志级别
  /// [operationID] 操作ID
  Future<bool> initSDK({
    int? platformID,
    required String apiAddr,
    required String wsAddr,
    required String chatAddr,
    String? dataDir,
    required OnConnectListener listener,
    Level logLevel = .ALL,
    String? operationID,
  }) async {
    final InitConfig config = InitConfig(
      platformID: platformID,
      apiAddr: apiAddr,
      chatAddr: chatAddr,
      wsAddr: wsAddr,
      dbPath: dataDir,
      logLevel: logLevel,
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

      final GetIt getIt = GetIt.instance;

      // 注册配置
      getIt.registerSingleton<InitConfig>(config, instanceName: InstanceName.initConfig);

      // 初始化 HTTP 层
      HttpClient().init(baseUrl: config.apiAddr);

      ToStore toStore = await _initDatabase(
        dbPath: config.dbPath ?? await ImUtils.defaultDbPath(),
        dbName: config.dbName,
        schemas: config.schemas,
      );

      getIt.registerSingleton(toStore, instanceName: InstanceName.toStore);

      final DatabaseService databaseService = DatabaseService(toStore: toStore);
      getIt.registerSingleton<DatabaseService>(
        databaseService,
        instanceName: InstanceName.databaseService,
      );

      // 注册 IM API 服务
      final ImApiService imApiService = ImApiService();
      getIt.registerSingleton<ImApiService>(imApiService, instanceName: InstanceName.imApiService);

      // 初始化 WebSocket 连接管理器
      final WebSocketService webSocketService = WebSocketService(
        wsUrl: config.wsAddr,
        platformID: config.platformID ?? PlatformUtils.platformID,
        connectListener: listener,
      );
      getIt.registerSingleton<WebSocketService>(
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

  ///
  Future<void> unInitSDK() async {
    final GetIt getIt = GetIt.instance;
    if (getIt.isRegistered<InitConfig>(instanceName: InstanceName.initConfig)) {
      await getIt.unregister<InitConfig>(instanceName: InstanceName.initConfig);
    }
    if (getIt.isRegistered<DatabaseService>(instanceName: InstanceName.databaseService)) {
      await getIt.unregister<DatabaseService>(instanceName: InstanceName.databaseService);
    }

    if (getIt.isRegistered<ImApiService>(instanceName: InstanceName.imApiService)) {
      await getIt.unregister<ImApiService>(instanceName: InstanceName.imApiService);
    }

    if (getIt.isRegistered<WebSocketService>(instanceName: InstanceName.webSocketService)) {
      await getIt.unregister<WebSocketService>(instanceName: InstanceName.webSocketService);
    }
  }

  /// 登录
  /// [userID] 用户ID
  /// [token] 用户 token
  Future<UserInfo> login({
    required String userID,
    required String token,
    Future<UserInfo> Function()? defaultValue,
  }) async {
    this.userID = userID;
    this.token = token;
    _loginStatus = LoginStatus.logging;

    // 设置 HTTP token
    HttpClient().setToken(token);

    final GetIt getIt = GetIt.instance;

    final DatabaseService databaseService = getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );

    // 初始化数据库（以用户维度）
    await databaseService.switchSpace(userID: userID);

    final ImApiService imApiService = getIt.get<ImApiService>(
      instanceName: InstanceName.imApiService,
    );

    // 从服务端获取当前用户信息并存入本地
    final resp = await imApiService.getUsersInfo(userIDs: [userID]);
    UserInfo? loginUser;
    if (resp.errCode == 0 && resp.data != null) {
      final dataMap = resp.data as Map<String, dynamic>;
      final users = dataMap['usersInfo'] as List?;
      if (users != null && users.isNotEmpty) {
        final userData = Map<String, dynamic>.from(users.first as Map);
        await databaseService.insertOrUpdateUser(userData);
        loginUser = UserInfo.fromJson(userData);
        userInfo = loginUser;
      } else {
        loginUser = await defaultValue?.call();
      }
    }
    if (loginUser == null) {
      return Future.error('Login Field');
    }

    isLogined = true;
    _loginStatus = LoginStatus.logged;

    // 建立 WebSocket 连接
    final WebSocketService webSocketService = getIt.get<WebSocketService>(
      instanceName: InstanceName.webSocketService,
    );
    await webSocketService.connect(userID: userID, token: token);

    // 初始化通知分发器
    final dispatcher = NotificationDispatcher(database: databaseService, api: imApiService);
    dispatcher.setLoginUserID(userID);
    dispatcher.friendshipListener = friendshipManager.listener;
    dispatcher.groupListener = groupManager.listener;
    dispatcher.userListener = userManager.listener;
    dispatcher.conversationListener = conversationManager.listener;
    dispatcher.msgListener = messageManager.msgListener;
    dispatcher.customBusinessListener = messageManager.customBusinessListener;
    dispatcher.listenerForService = listenerForService;

    // 初始化消息同步器
    final msgSyncer = MsgSyncer(
      database: databaseService,
      api: imApiService,
      notificationDispatcher: dispatcher,
    );
    msgSyncer.setLoginUserID(userID);
    msgSyncer.msgListener = messageManager.msgListener;
    msgSyncer.conversationListener = conversationManager.listener;
    msgSyncer.listenerForService = listenerForService;

    // WS 推送 → MsgSyncer 处理
    webSocketService.onPushMsg = msgSyncer.handlePushMsg;

    // 启动初始同步
    msgSyncer.doConnectedSync();

    _log.info('用户已登录: $userID');
    return loginUser;
  }

  /// 登出
  Future<void> logout() async {
    isLogined = false;
    _loginStatus = LoginStatus.logout;
    token = null;
    final GetIt getIt = GetIt.instance;
    final WebSocketService webSocketService = getIt.get<WebSocketService>(
      instanceName: InstanceName.webSocketService,
    );
    // 断开 WebSocket
    await webSocketService.disconnect();

    // 清除 HTTP token
    HttpClient().setToken(null);
    final DatabaseService databaseService = getIt.get<DatabaseService>(
      instanceName: InstanceName.databaseService,
    );
    // 关闭数据库
    await databaseService.close();

    _log.info('用户已登出');
  }

  /// 设置服务监听（用于后台推送等场景）
  void setListenerForService(OnListenerForService listener) {
    listenerForService = listener;
  }

  /// 设置文件上传进度监听
  void setUploadFileListener(OnUploadFileListener listener) {
    uploadFileListener = listener;
  }

  /// 获取登录状态
  /// 1: logout  2: logging  3: logged
  int getLoginStatus() {
    return _loginStatus.value;
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
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception(SDKErrorCode.uploadFileNotExist.message);
    }

    final fileSize = await file.length();
    uploadFileListener?.open(id, fileSize);

    // 计算文件 MD5
    final fileBytes = await file.readAsBytes();
    final hash = md5.convert(fileBytes).toString();

    // 分片大小: 2MB
    const partSize = 2 * 1024 * 1024;
    final partNum = (fileSize / partSize).ceil().clamp(1, 10000);
    uploadFileListener?.partSize(id, partSize, partNum);

    final GetIt getIt = GetIt.instance;
    final ImApiService imApiService = getIt.get<ImApiService>(
      instanceName: InstanceName.imApiService,
    );

    // 1. 发起分片上传
    final initResp = await imApiService.initiateMultipartUpload(
      hash: hash,
      size: fileSize,
      partSize: partSize,
      maxParts: partNum.clamp(1, 20),
      cause: cause ?? '',
      name: '$userID/$fileName',
      contentType: contentType ?? 'application/octet-stream',
    );
    if (initResp.errCode != 0) {
      throw Exception('Initiate upload failed: ${initResp.errMsg}');
    }

    final respData = initResp.data ?? {};
    final url = respData['url'] as String?;

    // 如果服务端返回 url，说明文件已存在（秒传）
    if (url != null && url.isNotEmpty) {
      uploadFileListener?.complete(id, fileSize, url, 0);
      return url;
    }

    final upload = respData['upload'] as Map<String, dynamic>? ?? {};
    final uploadID = upload['uploadID'] as String? ?? '';
    uploadFileListener?.uploadID(id, uploadID);

    final sign = upload['sign'] as Map<String, dynamic>? ?? {};
    final parts = sign['parts'] as List? ?? [];

    // 2. 逐片上传
    final partMd5s = <String>[];
    for (int i = 0; i < partNum; i++) {
      final start = i * partSize;
      final end = (start + partSize).clamp(0, fileSize);
      final partBytes = fileBytes.sublist(start, end);
      final partHash = md5.convert(partBytes).toString();

      uploadFileListener?.hashPartProgress(id, i, partBytes.length, partHash);

      if (i < parts.length) {
        final partInfo = parts[i] as Map<String, dynamic>;
        final putUrl = partInfo['url'] as String? ?? '';
        final headers = (partInfo['header'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, v?.toString() ?? ''),
        );

        if (putUrl.isNotEmpty) {
          await HttpClient().dio.put(
            putUrl,
            data: Stream.fromIterable([partBytes]),
            options: Options(
              headers: {...?headers, Headers.contentLengthHeader: partBytes.length},
              contentType: contentType ?? 'application/octet-stream',
            ),
            onSendProgress: (sent, total) {
              uploadFileListener?.uploadProgress(id, fileSize, start + sent, start);
            },
          );
        }
      }

      partMd5s.add(partHash);
      uploadFileListener?.uploadPartComplete(id, i, partBytes.length, partHash);
    }

    uploadFileListener?.hashPartComplete(id, partMd5s.join(','), hash);

    // 3. 完成分片上传
    final completeResp = await imApiService.completeMultipartUpload(
      uploadID: uploadID,
      parts: partMd5s,
      name: '$userID/$fileName',
      contentType: contentType ?? 'application/octet-stream',
      cause: cause ?? '',
    );
    if (completeResp.errCode != 0) {
      throw Exception('Complete upload failed: ${completeResp.errMsg}');
    }

    final resultUrl = (completeResp.data?['url'] as String?) ?? '';
    uploadFileListener?.complete(id, fileSize, resultUrl, 1);
    return resultUrl;
  }

  /// 获取当前登录用户ID
  String getLoginUserID() {
    return userID;
  }

  /// 获取当前登录用户信息
  UserInfo getLoginUserInfo() {
    return userInfo;
  }
}
