import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:openim_sdk/src/utils/im_utils.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';

class UserManager {
  static final Logger _log = Logger('UserManager');

  ImApiService get _api {
    return GetIt.instance.get<ImApiService>(instanceName: InstanceName.imApiService);
  }

  DatabaseService get _database {
    return GetIt.instance.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  /// 用户信息变更监听器
  OnUserListener? listener;

  /// 设置用户监听器
  void setUserListener(OnUserListener listener) {
    this.listener = listener;
  }

  /// Chat 服务端登录（内部方法）
  /// 向 chatAddr + /account/login 发起请求，返回 {userID, imToken, chatToken}
  Future<Map<String, dynamic>> _chatLogin(Map<String, dynamic> body) async {
    final GetIt getIt = GetIt.instance;
    final InitConfig config = getIt.get<InitConfig>(instanceName: InstanceName.initConfig);
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
        headers: {'operationID': 'op_${DateTime.now().millisecondsSinceEpoch}'},
      ),
    );

    try {
      final Response response = await dio.post('/account/login', data: body);
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      final int errCode = (data['errCode'] as int?) ?? -1;
      if (errCode != 0) {
        final String errMsg = data['errMsg'] ?? '未知错误';
        final String errDlt = data['errDlt'] ?? '';
        _log.severe('[_chatLogin] 登录失败: errCode=$errCode, errMsg=$errMsg, errDlt=$errDlt');
        throw Exception('登录失败($errCode): $errMsg $errDlt');
      }
      final loginData = Map<String, dynamic>.from(data['data'] as Map);
      _log.info('[_chatLogin] loginData keys=${loginData.keys.toList()}');
      return loginData;
    } on DioException catch (e) {
      _log.severe('[_chatLogin] DioException: type=${e.type}, message=${e.message}');
      _log.severe('[_chatLogin] response statusCode=${e.response?.statusCode}');
      _log.severe('[_chatLogin] response data=${e.response?.data}');
      rethrow;
    }
  }

  /// 使用邮箱登录（包含 SDK login）
  /// 调用 chat 服务端登录后，自动使用返回的 userID 和 imToken 完成 SDK 登录。
  Future<UserInfo> loginByEmail({required String email, required String password}) async {
    final loginData = await _chatLogin({
      'email': email,
      'password': ImUtils.generateMD5(password),
      'platform': PlatformUtils.platformID,
    });
    final userID = loginData['userID'] as String;
    final imToken = loginData['imToken'] as String;
    _log.info('邮箱 Chat 登录成功: $email, userID=$userID');
    return OpenIM.iMManager.login(userID: userID, token: imToken);
  }

  /// 使用手机号登录（包含 SDK login）
  /// 调用 chat 服务端登录后，自动使用返回的 userID 和 imToken 完成 SDK 登录。
  Future<UserInfo> loginByPhone({
    required String areaCode,
    required String phoneNumber,
    required String password,
  }) async {
    final loginData = await _chatLogin({
      'areaCode': areaCode,
      'phoneNumber': phoneNumber,
      'password': ImUtils.generateMD5(password),
      'platform': PlatformUtils.platformID,
    });
    final userID = loginData['userID'] as String;
    final imToken = loginData['imToken'] as String;
    _log.info('手机号 Chat 登录成功: $areaCode$phoneNumber, userID=$userID');
    return OpenIM.iMManager.login(userID: userID, token: imToken);
  }

  /// 获取用户信息（走缓存机制）
  /// [userIDList] 用户ID列表
  Future<List<UserInfo>> getUsersInfo({required List<String> userIDList}) async {
    return getUsersInfoWithCache(userIDList: userIDList);
  }

  /// 从缓存获取用户信息，缺失部分从服务器获取并回写本地
  Future<List<UserInfo>> getUsersInfoWithCache({required List<String> userIDList}) async {
    if (userIDList.isEmpty) return [];

    List<UserInfo> result = [];
    List<String> missingIDs = [];

    // 1. 查询本地数据库
    final dbUsers = await _database.getUsersByIDs(userIDList);
    result = dbUsers.toList();

    // 2. 对比找出未缓存的用户 ID
    for (var id in userIDList) {
      if (!result.any((u) => u.userID == id)) {
        missingIDs.add(id);
      }
    }

    // 3. 远程拉取缺失数据
    if (missingIDs.isNotEmpty) {
      final srvUsers = await getUsersInfoFromSrv(userIDList: missingIDs);
      result.addAll(srvUsers);
      // 4. 更新到本地缓存
      await batchSaveUsersToLocal(srvUsers);
    }

    return result;
  }

  /// 强制从服务器获取用户信息
  Future<List<UserInfo>> getUsersInfoFromSrv({required List<String> userIDList}) async {
    if (userIDList.isEmpty) return [];
    final resp = await _api.getUsersInfo(userIDs: userIDList);
    if (resp.errCode == 0 && resp.data is List) {
      return (resp.data as List).map((v) => UserInfo.fromJson(v)).toList();
    }
    throw Exception('从服务器获取用户信息失败: ${resp.errMsg}');
  }

  /// 获取当前登录用户信息
  Future<UserInfo?> getSelfUserInfo() async {
    return _database.getLoginUser();
  }

  /// 修改当前登录用户信息
  /// [nickname] 昵称
  /// [faceURL] 头像
  /// [globalRecvMsgOpt] 全局消息接收选项
  /// [ex] 扩展字段
  Future<void> setSelfInfo({
    String? nickname,
    String? faceURL,
    int? globalRecvMsgOpt,
    String? ex,
  }) async {
    final updateData = <String, dynamic>{};
    if (nickname != null) updateData['nickname'] = nickname;
    if (faceURL != null) updateData['faceURL'] = faceURL;
    if (globalRecvMsgOpt != null) updateData['globalRecvMsgOpt'] = globalRecvMsgOpt;
    if (ex != null) updateData['ex'] = ex;

    if (updateData.isEmpty) return;

    // 获取当前用户信息并合并更新
    final current = await _database.getLoginUser();
    if (current != null) {
      await _database.insertOrUpdateUser({...current.toJson(), ...updateData});
    }

    _log.info('用户信息已更新');

    // 触发监听回调
    final updated = await getSelfUserInfo();
    if (updated != null) {
      listener?.selfInfoUpdated(updated);
    }

    // 5. 同步到服务器
    updateData['userID'] = current?.userID;
    final resp = await _api.updateUserInfo(userInfo: updateData);
    if (resp.errCode != 0) {
      _log.warning('同步用户信息到服务器失败: ${resp.errMsg}');
    }
  }

  /// 订阅用户在线状态
  /// [userIDs] 用户ID列表
  Future<List<UserStatusInfo>> subscribeUsersStatus(List<String> userIDs) async {
    _log.info('订阅用户状态: $userIDs');
    final resp = await _api.subscribeUsersStatus(
      userID: _database.currentUserID,
      userIDs: userIDs,
      genre: 1, // 1 for subscribe (assumed based on common logic)
    );
    if (resp.errCode != 0) {
      throw Exception('订阅用户状态失败: ${resp.errMsg}');
    }
    final data = resp.data;
    if (data is Map && data['statusList'] is List) {
      return (data['statusList'] as List).map((e) => UserStatusInfo.fromJson(e)).toList();
    }
    return [];
  }

  /// 取消订阅用户在线状态
  /// [userIDs] 用户ID列表
  Future<void> unsubscribeUsersStatus(List<String> userIDs) async {
    _log.info('取消订阅用户状态: $userIDs');
    final resp = await _api.subscribeUsersStatus(
      userID: _database.currentUserID,
      userIDs: userIDs,
      genre: 2, // 2 for unsubscribe
    );
    if (resp.errCode != 0) {
      throw Exception('取消订阅用户状态失败: ${resp.errMsg}');
    }
  }

  /// 获取已订阅用户的在线状态
  Future<List<UserStatusInfo>> getSubscribeUsersStatus() async {
    final resp = await _api.getSubscribeUsersStatus(userID: _database.currentUserID);
    if (resp.errCode != 0) {
      throw Exception('获取已订阅用户状态失败: ${resp.errMsg}');
    }
    final data = resp.data;
    if (data is Map && data['statusList'] is List) {
      return (data['statusList'] as List).map((e) => UserStatusInfo.fromJson(e)).toList();
    }
    return [];
  }

  /// 获取用户在线状态
  /// [userIDs] 用户ID列表
  Future<List<UserStatusInfo>> getUserStatus(List<String> userIDs) async {
    final resp = await _api.getUserStatus(userID: _database.currentUserID, userIDs: userIDs);
    if (resp.errCode != 0) {
      throw Exception('获取用户状态失败: ${resp.errMsg}');
    }
    final data = resp.data;
    if (data is Map && data['statusList'] is List) {
      return (data['statusList'] as List).map((e) => UserStatusInfo.fromJson(e)).toList();
    }
    return [];
  }

  /// 将用户信息保存到本地数据库
  Future<void> saveUserToLocal(UserInfo userInfo) async {
    final data = userInfo.toJson()..removeWhere((_, v) => v == null);
    await _database.insertOrUpdateUser(data);
  }

  /// 批量将用户信息保存到本地数据库
  Future<void> batchSaveUsersToLocal(List<UserInfo> users) async {
    for (final user in users) {
      await saveUserToLocal(user);
    }
  }

  /// 通知用户状态变更（供内部调用）
  void notifyUserStatusChanged(UserStatusInfo statusInfo) {
    listener?.userStatusChanged(statusInfo);
  }
}
