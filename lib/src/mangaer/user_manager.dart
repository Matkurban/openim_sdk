import 'package:get_it/get_it.dart';
import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';

class UserManager {
  UserManager._internal();

  static final UserManager _instance = UserManager._internal();

  factory UserManager() => _instance;

  static final AoiweLogger _log = AoiweLogger('UserManager');

  final GetIt _getIt = GetIt.instance;

  ImApiService get _api {
    return _getIt.get<ImApiService>(instanceName: InstanceName.imApiService);
  }

  DatabaseService get _database {
    return _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  OnUserListener? listener;

  late String _currentUserID;

  void setUserListener(OnUserListener listener) {
    this.listener = listener;
  }

  @internal
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  /// 获取用户信息（走缓存机制）
  /// [userIDList] 用户ID列表
  Future<List<UserInfo>> getUsersInfo({required List<String> userIDList}) async {
    _log.info('userIDList=$userIDList', methodName: 'getUsersInfo');
    try {
      return await getUsersInfoWithCache(userIDList: userIDList);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUsersInfo');
      rethrow;
    }
  }

  /// 从缓存获取用户信息，缺失部分从服务器获取并回写本地
  Future<List<UserInfo>> getUsersInfoWithCache({required List<String> userIDList}) async {
    _log.info('userIDList=$userIDList', methodName: 'getUsersInfoWithCache');
    try {
      if (userIDList.isEmpty) return [];

      // 1. 查询本地数据库
      final dbUsers = await _database.getUsersByIDs(userIDList);
      final result = dbUsers.toList();

      // 2. 对比找出未缓存的用户 ID（Set O(1) 查找）
      final cachedIDs = result.map((u) => u.userID).toSet();
      final missingIDs = userIDList.where((id) => !cachedIDs.contains(id)).toList();

      // 3. 远程拉取缺失数据
      if (missingIDs.isNotEmpty) {
        final srvUsers = await getUsersInfoFromSrv(userIDList: missingIDs);
        result.addAll(srvUsers);
        // 4. 更新到本地缓存
        await _database.upsertUsers(srvUsers.map((u) => u.toJson()).toList());
      }

      return result;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUsersInfoWithCache');
      rethrow;
    }
  }

  /// 强制从服务器获取用户信息
  Future<List<UserInfo>> getUsersInfoFromSrv({required List<String> userIDList}) async {
    _log.info('userIDList=$userIDList', methodName: 'getUsersInfoFromSrv');
    try {
      if (userIDList.isEmpty) return [];
      final resp = await _api.getUsersInfo(userIDs: userIDList);
      if (resp.errCode != 0) {
        throw Exception(
          '从服务器获取用户信息失败: errCode=${resp.errCode}, errMsg=${resp.errMsg}, errDlt=${resp.errDlt}',
        );
      }
      final users = resp.data?['usersInfo'] as List? ?? [];
      return users.map((v) => UserInfo.fromJson(v as Map<String, dynamic>)).toList();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUsersInfoFromSrv');
      rethrow;
    }
  }

  /// 获取当前登录用户信息
  Future<UserInfo?> getSelfUserInfo() async {
    _log.info('called', methodName: 'getSelfUserInfo');
    try {
      return await _database.getLoginUser();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getSelfUserInfo');
      rethrow;
    }
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
    _log.info(
      'nickname=$nickname, faceURL=$faceURL, globalRecvMsgOpt=$globalRecvMsgOpt',
      methodName: 'setSelfInfo',
    );
    try {
      final updateData = <String, dynamic>{};
      if (nickname != null) updateData['nickname'] = nickname;
      if (faceURL != null) updateData['faceURL'] = faceURL;
      if (globalRecvMsgOpt != null) updateData['globalRecvMsgOpt'] = globalRecvMsgOpt;
      if (ex != null) updateData['ex'] = ex;

      if (updateData.isEmpty) return;

      // 获取当前用户信息并合并更新
      final current = await _database.getLoginUser();
      if (current != null) {
        await _database.upsertUser({...current.toJson(), ...updateData});
      }

      // 对齐 Go SDK：若昵称或头像发生变更，回溯更新本地所有消息中的发送者信息
      final newNickname = (nickname ?? current?.nickname) ?? '';
      final newFaceUrl = (faceURL ?? current?.faceURL) ?? '';
      final oldNickname = current?.nickname ?? '';
      final oldFaceUrl = current?.faceURL ?? '';
      if ((newNickname != oldNickname || newFaceUrl != oldFaceUrl) && newNickname.isNotEmpty) {
        await _database.updateAllMessageSenderInfo(
          _currentUserID,
          senderNickname: newNickname,
          senderFaceUrl: newFaceUrl.isNotEmpty ? newFaceUrl : null,
        );
      }

      _log.info('用户信息已更新', methodName: 'setSelfInfo');

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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setSelfInfo');
      rethrow;
    }
  }

  /// 订阅用户在线状态
  /// [userIDs] 用户ID列表
  Future<List<UserStatusInfo>> subscribeUsersStatus(List<String> userIDs) async {
    _log.info('userIDs=$userIDs', methodName: 'subscribeUsersStatus');
    try {
      final resp = await _api.subscribeUsersStatus(
        userID: _currentUserID,
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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'subscribeUsersStatus');
      rethrow;
    }
  }

  /// 取消订阅用户在线状态
  /// [userIDs] 用户ID列表
  Future<void> unsubscribeUsersStatus(List<String> userIDs) async {
    _log.info('userIDs=$userIDs', methodName: 'unsubscribeUsersStatus');
    try {
      final resp = await _api.subscribeUsersStatus(
        userID: _currentUserID,
        userIDs: userIDs,
        genre: 2, // 2 for unsubscribe
      );
      if (resp.errCode != 0) {
        throw Exception('取消订阅用户状态失败: ${resp.errMsg}');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'unsubscribeUsersStatus');
      rethrow;
    }
  }

  /// 获取已订阅用户的在线状态
  Future<List<UserStatusInfo>> getSubscribeUsersStatus() async {
    _log.info('called', methodName: 'getSubscribeUsersStatus');
    try {
      final resp = await _api.getSubscribeUsersStatus(userID: _currentUserID);
      if (resp.errCode != 0) {
        throw Exception('获取已订阅用户状态失败: ${resp.errMsg}');
      }
      final data = resp.data;
      if (data is Map && data['statusList'] is List) {
        return (data['statusList'] as List).map((e) => UserStatusInfo.fromJson(e)).toList();
      }
      return [];
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getSubscribeUsersStatus');
      rethrow;
    }
  }

  /// 获取用户在线状态
  /// [userIDs] 用户ID列表
  Future<List<UserStatusInfo>> getUserStatus(List<String> userIDs) async {
    _log.info('userIDs=$userIDs', methodName: 'getUserStatus');
    try {
      final resp = await _api.getUserStatus(userID: _currentUserID, userIDs: userIDs);
      if (resp.errCode != 0) {
        throw Exception('获取用户状态失败: ${resp.errMsg}');
      }
      final data = resp.data;
      if (data is Map && data['statusList'] is List) {
        return (data['statusList'] as List).map((e) => UserStatusInfo.fromJson(e)).toList();
      }
      return [];
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUserStatus');
      rethrow;
    }
  }

  /// 获取用户客户端配置
  /// 对应 Go SDK GetUserClientConfig
  /// 返回服务端下发的配置 KV 对
  Future<Map<String, String>> getUserClientConfig() async {
    _log.info('called', methodName: 'getUserClientConfig');
    try {
      final resp = await _api.getUserClientConfig(userID: _currentUserID);
      if (resp.errCode != 0) {
        throw Exception('获取用户客户端配置失败: ${resp.errMsg}');
      }
      final data = resp.data;
      if (data is Map && data['configs'] is Map) {
        return (data['configs'] as Map).map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));
      }
      return {};
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUserClientConfig');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Chat Server API（使用 chatToken 访问 chatAddr）
  // ---------------------------------------------------------------------------

  /// 搜索好友（chat 服务端）
  /// [keyword] 搜索关键字
  /// [pageNumber] 页码，从 1 开始
  /// [showNumber] 每页条数
  Future<List<FriendInfo>> searchFriendInfo(
    String keyword, {
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    _log.info('keyword=$keyword', methodName: 'searchFriendInfo');
    try {
      final resp = await _api.searchFriend(
        keyword: keyword,
        pageNumber: pageNumber,
        showNumber: showNumber,
      );
      if (resp.isSuccess && resp.data is Map) {
        final users = (resp.data as Map)['users'];
        if (users is List) {
          return users.map((e) => FriendInfo.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'searchFriendInfo');
      rethrow;
    }
  }

  /// 搜索用户完整信息（chat 服务端）
  /// [keyword] 搜索关键字
  /// [pageNumber] 页码，从 1 开始
  /// [showNumber] 每页条数
  Future<List<UserFullInfo>> searchUserFullInfo(
    String keyword, {
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    _log.info('keyword=$keyword', methodName: 'searchUserFullInfo');
    try {
      final resp = await _api.searchUserFullInfo(
        keyword: keyword,
        pageNumber: pageNumber,
        showNumber: showNumber,
      );
      if (resp.isSuccess && resp.data is Map) {
        final users = (resp.data as Map)['users'];
        if (users is List) {
          return users.map((e) => UserFullInfo.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'searchUserFullInfo');
      rethrow;
    }
  }

  /// 获取用户完整信息（chat 服务端）
  /// [userID] 用户ID
  Future<UserFullInfo?> getUserFullInfo({required String userID}) async {
    _log.info('userID=$userID', methodName: 'getUserFullInfo');
    try {
      final resp = await _api.getUserFullInfo(userIDs: [userID]);
      if (resp.isSuccess && resp.data is Map) {
        final dataMap = resp.data as Map;
        final users = dataMap['users'];
        if (users is List && users.isNotEmpty) {
          final first = users.first;
          if (first is Map<String, dynamic>) {
            return UserFullInfo.fromJson(first);
          }
        }
      }
      return null;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUserFullInfo');
      rethrow;
    }
  }

  /// 更新用户信息（chat 服务端）
  /// 注意：此方法更新的是 chat 服务端的用户扩展信息（手机号、邮箱等），
  /// 与 [setSelfInfo] 更新的 IM 核心用户信息不同。
  Future<void> updateChatUserInfo({
    String? account,
    String? phoneNumber,
    String? areaCode,
    String? email,
    String? nickname,
    String? faceURL,
    int? gender,
    int? birth,
  }) async {
    _log.info('nickname=$nickname, faceURL=$faceURL', methodName: 'updateChatUserInfo');
    try {
      final resp = await _api.updateChatUserInfo(
        userID: _currentUserID,
        account: account,
        phoneNumber: phoneNumber,
        areaCode: areaCode,
        email: email,
        nickname: nickname,
        faceURL: faceURL,
        gender: gender,
        birth: birth,
      );
      if (!resp.isSuccess) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'updateChatUserInfo');
      rethrow;
    }
  }

  /// 获取 RTC Token（chat 服务端）
  /// [roomId] 房间ID
  /// [userId] 用户ID
  Future<String?> getRtcToken({required String roomId, required String userId}) async {
    _log.info('roomId=$roomId, userId=$userId', methodName: 'getRtcToken');
    try {
      final resp = await _api.getRtcToken(roomId: roomId, userId: userId);
      if (resp.isSuccess && resp.data is Map) {
        return (resp.data as Map)['token'] as String?;
      }
      return null;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getRtcToken');
      rethrow;
    }
  }

  /// 注册账号（chat 服务端）
  /// 注册成功后如果 autoLogin 为 true，服务端会返回 chatToken 和 imToken，
  /// 但此方法不会自动执行 SDK login，调用方需要后续调用 loginByEmail / loginByPhone。
  Future<AuthCacheData?> register({
    required String nickname,
    required String password,
    String? faceURL,
    String? areaCode,
    String? phoneNumber,
    String? email,
    String? account,
    int birth = 0,
    int gender = 1,
    required String verificationCode,
    String? invitationCode,
    bool autoLogin = true,
    required String deviceID,
  }) async {
    _log.info('nickname=$nickname, email=$email, phone=$phoneNumber', methodName: 'register');
    try {
      final resp = await _api.register(
        nickname: nickname,
        password: password,
        faceURL: faceURL,
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        account: account,
        birth: birth,
        gender: gender,
        verificationCode: verificationCode,
        invitationCode: invitationCode,
        autoLogin: autoLogin,
        deviceID: deviceID,
      );
      if (!resp.isSuccess) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
      if (resp.data is Map<String, dynamic>) {
        return AuthCacheData.fromJson(resp.data);
      }
      return null;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'register');
      rethrow;
    }
  }

  /// 发送验证码（chat 服务端）
  /// [usedFor] 用途：1-注册 2-重置密码 3-登录
  Future<void> sendVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required int usedFor,
    String? invitationCode,
  }) async {
    _log.info(
      'email=$email, phone=$phoneNumber, usedFor=$usedFor',
      methodName: 'sendVerificationCode',
    );
    try {
      final resp = await _api.sendVerificationCode(
        areaCode: areaCode,
        phoneNumber: phoneNumber,
        email: email,
        usedFor: usedFor,
        invitationCode: invitationCode,
      );
      if (!resp.isSuccess) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'sendVerificationCode');
      rethrow;
    }
  }
}
