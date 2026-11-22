import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../listener/user_listener.dart';
import '../models/api_response.dart';
import '../models/auth_cache_data.dart';
import '../models/openim_exception.dart';
import '../models/user_full_info.dart';
import '../models/user_info.dart';

/// 用户信息、在线状态与账号安全管理器（继承 [BaseManager]）。
final class UserManager extends BaseManager<OnUserListener> {
  final SdkContext _context;

  /// 记录已订阅在线状态的用户 ID 集合，供 WS 重连后自动续订（修复 B-14）。
  final Set<String> _subscribedStatusUserIDs = <String>{};

  /// 创建 `UserManager` 实例。
  ///
  /// Creates a `UserManager` instance.
  ///
  /// - [_context] context / Context.
  UserManager({required this._context}) : super('UserManager');

  /// 设置用户监听器。
  ///
  /// Set user listener.
  ///
  /// - [listener] 监听器 / Listener.
  void setUserListener(OnUserListener listener) {
    setPrimaryListener(listener);
  }

  /// subscribed状态用户ID 列表。
  ///
  /// Subscribed status user i ds.
  Set<String> get subscribedStatusUserIDs => Set<String>.unmodifiable(_subscribedStatusUserIDs);

  /// on登出。
  ///
  /// On logout.
  @override
  void onLogout() {
    _subscribedStatusUserIDs.clear();
    super.onLogout();
  }

  /// 获取用户列表信息。
  ///
  /// Get users info.
  ///
  /// - [userIDList] 用户ID列表 / User ID list.
  /// - Returns: `Future<List<UserInfo>>` 列表结果 / Resulting `Future<List<UserInfo>>` list.
  Future<List<UserInfo>> getUsersInfo({required List<String> userIDList}) =>
      getUsersInfoWithCache(userIDList: userIDList);

  /// 获取用户列表信息并更新指定字段缓存。
  ///
  /// Get users info with updated fields cache.
  ///
  /// - [userIDList] 用户ID列表 / User ID list.
  /// - Returns: `Future<List<UserInfo>>` 列表结果 / Resulting `Future<List<UserInfo>>` list.
  Future<List<UserInfo>> getUsersInfoWithCache({required List<String> userIDList}) async {
    if (userIDList.isEmpty) {
      return <UserInfo>[];
    }
    final List<UserInfo> cached = await _context.db.users.getUsersByIDs(userIDList);
    final Set<String> foundIDs = cached.map<String>((UserInfo u) => u.userID).toSet();
    final List<String> missingFromUsers = userIDList
        .where((String id) => !foundIDs.contains(id))
        .toList();
    if (missingFromUsers.isEmpty) {
      return cached;
    }

    // 好友信息在登录同步时已落库到 local_friends，优先命中本地好友缓存避免无谓网络请求。
    final List<FriendInfo> cachedFriends = await _context.db.friends.getFriendsByUserIDs(
      missingFromUsers,
    );
    for (final FriendInfo friend in cachedFriends) {
      final String? fid = friend.friendUserID;
      if (fid != null && fid.isNotEmpty && foundIDs.add(fid)) {
        cached.add(
          UserInfo(
            userID: fid,
            nickname: friend.nickname,
            faceURL: friend.faceURL,
            ex: friend.ex,
            createTime: friend.createTime,
          ),
        );
      }
    }

    final List<String> missing = userIDList.where((String id) => !foundIDs.contains(id)).toList();
    if (missing.isEmpty) {
      return cached;
    }
    final List<UserInfo> fetched = await getUsersInfoFromSrv(userIDList: missing);
    return <UserInfo>[...cached, ...fetched];
  }

  /// 获取用户列表信息从Srv。
  ///
  /// Get users info from srv.
  ///
  /// - [userIDList] 用户ID列表 / User ID list.
  /// - Returns: `Future<List<UserInfo>>` 列表结果 / Resulting `Future<List<UserInfo>>` list.
  Future<List<UserInfo>> getUsersInfoFromSrv({required List<String> userIDList}) async {
    if (userIDList.isEmpty) {
      return <UserInfo>[];
    }
    final ApiResponse resp = await _context.apis.user.getUsersInfo(userIDs: userIDList);
    if (resp.errCode != 0) {
      return <UserInfo>[];
    }
    final List<dynamic> list = resp.data?['usersInfo'] as List<dynamic>? ?? const <dynamic>[];
    final List<Map<String, dynamic>> maps = list.whereType<Map<String, dynamic>>().toList();
    if (maps.isNotEmpty) {
      await _context.db.users.upsertUsers(maps);
    }
    return maps.map<UserInfo>(UserInfo.fromJson).toList();
  }

  /// 获取当前用户用户信息。
  ///
  /// Get self user user info.
  ///
  /// - Returns: `Future<UserInfo?>` 结果 / Resulting `Future<UserInfo?>`.
  Future<UserInfo?> getSelfUserInfo() async {
    final UserInfo? local = await _context.db.users.getLoginUser();
    if (local != null) {
      return local;
    }
    if (currentUserID.isEmpty) {
      return null;
    }
    final List<UserInfo> list = await getUsersInfoFromSrv(userIDList: <String>[currentUserID]);
    return list.isNotEmpty ? list.first : null;
  }

  /// 设置当前用户信息。
  ///
  /// Set self user info.
  ///
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [globalRecvMsgOpt] 全局接收消息选项 / Global receive message option.
  /// - [ex] 扩展字段 / Extension.
  Future<void> setSelfInfo({
    String? nickname,
    String? faceURL,
    int? globalRecvMsgOpt,
    String? ex,
  }) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'userID': currentUserID,
      'nickname': ?nickname,
      'faceURL': ?faceURL,
      'globalRecvMsgOpt': ?globalRecvMsgOpt,
      'ex': ?ex,
    };
    final ApiResponse resp = await _context.apis.user.updateUserInfoEx(
      userInfo: <String, dynamic>{'userInfo': payload},
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    await _context.db.users.upsertUser(payload);
    final UserInfo? updated = await _context.db.users.getLoginUser();
    if (updated != null) {
      _context.setLoginUser(updated);
      listener?.selfInfoUpdated(updated);
      if (nickname != null && nickname.isNotEmpty) {
        await _context.db.messages.updateAllMessageSenderInfo(
          currentUserID,
          senderNickname: nickname,
          senderFaceUrl: faceURL,
        );
      }
    }
  }

  /// 订阅用户列表状态。
  ///
  /// Subscribe users status.
  ///
  /// - [userIDs] 用户ID 列表 / User i ds.
  /// - Returns: `Future<List<UserStatusInfo>>` 列表结果 / Resulting `Future<List<UserStatusInfo>>` list.
  Future<List<UserStatusInfo>> subscribeUsersStatus(List<String> userIDs) async {
    if (userIDs.isEmpty) {
      return <UserStatusInfo>[];
    }
    _subscribedStatusUserIDs.addAll(userIDs);
    final ApiResponse resp = await _context.apis.user.subscribeUsersStatus(
      userID: currentUserID,
      userIDs: userIDs,
      genre: 1,
    );
    if (resp.errCode != 0) {
      return <UserStatusInfo>[];
    }
    final List<dynamic> list = resp.data?['statusList'] as List<dynamic>? ?? const <dynamic>[];
    return list
        .whereType<Map<String, dynamic>>()
        .map<UserStatusInfo>(UserStatusInfo.fromJson)
        .toList();
  }

  /// 取消订阅用户列表状态。
  ///
  /// Unsubscribe users status.
  ///
  /// - [userIDs] 用户ID 列表 / User i ds.
  Future<void> unsubscribeUsersStatus(List<String> userIDs) async {
    if (userIDs.isEmpty) {
      return;
    }
    _subscribedStatusUserIDs.removeAll(userIDs);
    final ApiResponse resp = await _context.apis.user.subscribeUsersStatus(
      userID: currentUserID,
      userIDs: userIDs,
      genre: 2,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 获取订阅用户列表状态。
  ///
  /// Get subscribe users status.
  ///
  /// - Returns: `Future<List<UserStatusInfo>>` 列表结果 / Resulting `Future<List<UserStatusInfo>>` list.
  Future<List<UserStatusInfo>> getSubscribeUsersStatus() async {
    final ApiResponse resp = await _context.apis.user.getSubscribeUsersStatus(
      userID: currentUserID,
    );
    if (resp.errCode != 0) {
      return <UserStatusInfo>[];
    }
    final List<dynamic> list = resp.data?['statusList'] as List<dynamic>? ?? const <dynamic>[];
    return list
        .whereType<Map<String, dynamic>>()
        .map<UserStatusInfo>(UserStatusInfo.fromJson)
        .toList();
  }

  /// 获取用户状态。
  ///
  /// Get user status.
  ///
  /// - [userIDs] 用户ID 列表 / User i ds.
  /// - Returns: `Future<List<UserStatusInfo>>` 列表结果 / Resulting `Future<List<UserStatusInfo>>` list.
  Future<List<UserStatusInfo>> getUserStatus(List<String> userIDs) async {
    if (userIDs.isEmpty) {
      return <UserStatusInfo>[];
    }
    final ApiResponse resp = await _context.apis.user.getUserStatus(
      userID: currentUserID,
      userIDs: userIDs,
    );
    if (resp.errCode != 0) {
      return <UserStatusInfo>[];
    }
    final List<dynamic> list = resp.data?['statusList'] as List<dynamic>? ?? const <dynamic>[];
    return list
        .whereType<Map<String, dynamic>>()
        .map<UserStatusInfo>(UserStatusInfo.fromJson)
        .toList();
  }

  /// 获取用户客户端配置。
  ///
  /// Get user client configuration.
  ///
  /// - Returns: `Future<Map<String, String>>` 映射结果 / Resulting `Future<Map<String, String>>` map.
  Future<Map<String, String>> getUserClientConfig() async {
    final ApiResponse resp = await _context.apis.user.getUserClientConfig(userID: currentUserID);
    if (resp.errCode != 0) {
      return <String, String>{};
    }
    final Map<String, dynamic> configs =
        resp.data?['configs'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    return configs.map<String, String>((String k, dynamic v) => MapEntry<String, String>(k, '$v'));
  }

  /// 搜索好友信息。
  ///
  /// Search friend info.
  ///
  /// - [keyword] 关键词 / Keyword.
  /// - [pageNumber] 分页号码 / Paged number.
  /// - [showNumber] 展示号码 / Display number.
  /// - Returns: `Future<List<FriendInfo>>` 列表结果 / Resulting `Future<List<FriendInfo>>` list.
  Future<List<FriendInfo>> searchFriendInfo(
    String keyword, {
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    final ApiResponse resp = await _context.apis.user.searchFriend(
      keyword: keyword,
      pageNumber: pageNumber,
      showNumber: showNumber,
    );
    if (resp.errCode != 0) {
      return <FriendInfo>[];
    }
    final List<dynamic> list = resp.data?['users'] as List<dynamic>? ?? const <dynamic>[];
    return list.whereType<Map<String, dynamic>>().map<FriendInfo>(FriendInfo.fromJson).toList();
  }

  /// 搜索用户全量信息。
  ///
  /// Search user full info.
  ///
  /// - [keyword] 关键词 / Keyword.
  /// - [pageNumber] 分页号码 / Paged number.
  /// - [showNumber] 展示号码 / Display number.
  /// - Returns: `Future<List<UserFullInfo>>` 列表结果 / Resulting `Future<List<UserFullInfo>>` list.
  Future<List<UserFullInfo>> searchUserFullInfo(
    String keyword, {
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    final ApiResponse resp = await _context.apis.user.searchUserFullInfo(
      keyword: keyword,
      pageNumber: pageNumber,
      showNumber: showNumber,
    );
    if (resp.errCode != 0) {
      return <UserFullInfo>[];
    }
    final List<dynamic> list = resp.data?['users'] as List<dynamic>? ?? const <dynamic>[];
    return list.whereType<Map<String, dynamic>>().map<UserFullInfo>(UserFullInfo.fromJson).toList();
  }

  /// 获取用户全量信息。
  ///
  /// Get user full info.
  ///
  /// - [userID] 用户ID / User ID.
  /// - Returns: `Future<UserFullInfo?>` 结果 / Resulting `Future<UserFullInfo?>`.
  Future<UserFullInfo?> getUserFullInfo({required String userID}) async {
    final ApiResponse resp = await _context.apis.user.getUserFullInfo(userIDs: <String>[userID]);
    if (resp.errCode != 0) {
      return null;
    }
    final List<dynamic> list = resp.data?['users'] as List<dynamic>? ?? const <dynamic>[];
    if (list.isEmpty || list.first is! Map<String, dynamic>) {
      return null;
    }
    return UserFullInfo.fromJson(list.first as Map<String, dynamic>);
  }

  /// 更新聊天用户信息。
  ///
  /// Update chat user info.
  ///
  /// - [account] 账号 / Account.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [areaCode] 区号代码 / Area code.
  /// - [email] 邮箱 / Email.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [gender] 性别 / Gender.
  /// - [birth] 生日 / Birth date.
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
    final ApiResponse resp = await _context.apis.user.updateChatUserInfo(
      userID: currentUserID,
      account: account,
      phoneNumber: phoneNumber,
      areaCode: areaCode,
      email: email,
      nickname: nickname,
      faceURL: faceURL,
      gender: gender,
      birth: birth,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 注册。
  ///
  /// Register.
  ///
  /// - [nickname] 昵称 / Nickname.
  /// - [password] 密码 / Password.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [areaCode] 区号代码 / Area code.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [email] 邮箱 / Email.
  /// - [account] 账号 / Account.
  /// - [birth] 生日 / Birth date.
  /// - [gender] 性别 / Gender.
  /// - [verificationCode] 验证代码 / Verification code.
  /// - [invitationCode] invitation代码 / Invitation code.
  /// - [autoLogin] auto登录 / Auto login.
  /// - [deviceID] deviceID / Device ID.
  /// - Returns: `Future<AuthCacheData?>` 结果 / Resulting `Future<AuthCacheData?>`.
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
    final ApiResponse resp = await _context.apis.auth.register(
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
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    if (resp.data is Map<String, dynamic>) {
      return AuthCacheData.fromJson(resp.data as Map<String, dynamic>);
    }
    return null;
  }

  /// 发送验证代码。
  ///
  /// Send verification code.
  ///
  /// - [areaCode] 区号代码 / Area code.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [email] 邮箱 / Email.
  /// - [usedFor] usedFor / Used for.
  /// - [invitationCode] invitation代码 / Invitation code.
  Future<void> sendVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required int usedFor,
    String? invitationCode,
  }) async {
    final ApiResponse resp = await _context.apis.auth.sendVerificationCode(
      areaCode: areaCode,
      phoneNumber: phoneNumber,
      email: email,
      usedFor: usedFor,
      invitationCode: invitationCode,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 变更密码。
  ///
  /// Change password.
  ///
  /// - [currentPassword] current密码 / Current password.
  /// - [newPassword] new密码 / New password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final ApiResponse resp = await _context.apis.auth.changePassword(
      userID: currentUserID,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 重置密码。
  ///
  /// Reset password.
  ///
  /// - [areaCode] 区号代码 / Area code.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [email] 邮箱 / Email.
  /// - [verifyCode] 校验代码 / Verify code.
  /// - [newPassword] new密码 / New password.
  Future<void> resetPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verifyCode,
    required String newPassword,
  }) async {
    final ApiResponse resp = await _context.apis.auth.resetPassword(
      areaCode: areaCode,
      phoneNumber: phoneNumber,
      email: email,
      verifyCode: verifyCode,
      newPassword: newPassword,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 删除账号。
  ///
  /// Delete account.
  ///
  /// - [currentPassword] current密码 / Current password.
  Future<void> deleteAccount({required String currentPassword}) async {
    final ApiResponse resp = await _context.apis.auth.deleteAccount(
      currentPassword: currentPassword,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 设置支付密码。
  ///
  /// Set payment password.
  ///
  /// - [paymentPassword] 支付密码 / Payment password.
  /// - [loginPassword] 登录密码 / Login password.
  Future<void> setPaymentPassword({
    required String paymentPassword,
    required String loginPassword,
  }) async {
    final ApiResponse resp = await _context.apis.auth.setPaymentPassword(
      paymentPassword: paymentPassword,
      loginPassword: loginPassword,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 变更支付密码。
  ///
  /// Change payment password.
  ///
  /// - [currentPaymentPassword] current支付密码 / Current payment password.
  /// - [newPaymentPassword] new支付密码 / New payment password.
  Future<void> changePaymentPassword({
    required String currentPaymentPassword,
    required String newPaymentPassword,
  }) async {
    final ApiResponse resp = await _context.apis.auth.changePaymentPassword(
      currentPaymentPassword: currentPaymentPassword,
      newPaymentPassword: newPaymentPassword,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 校验支付密码。
  ///
  /// Verify payment password.
  ///
  /// - [paymentPassword] 支付密码 / Payment password.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> verifyPaymentPassword({required String paymentPassword}) async {
    final ApiResponse resp = await _context.apis.auth.verifyPaymentPassword(
      paymentPassword: paymentPassword,
    );
    return resp.errCode == 0;
  }

  /// 检查支付密码设置。
  ///
  /// Check payment password set.
  ///
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> checkPaymentPasswordSet() async {
    final ApiResponse resp = await _context.apis.auth.checkPaymentPasswordSet();
    if (resp.errCode != 0) {
      return false;
    }
    return resp.data?['isSet'] as bool? ?? false;
  }

  /// 重置支付密码。
  ///
  /// Reset payment password.
  ///
  /// - [areaCode] 区号代码 / Area code.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [email] 邮箱 / Email.
  /// - [verifyCode] 校验代码 / Verify code.
  /// - [newPaymentPassword] new支付密码 / New payment password.
  Future<void> resetPaymentPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verifyCode,
    required String newPaymentPassword,
  }) async {
    final ApiResponse resp = await _context.apis.auth.resetPaymentPassword(
      areaCode: areaCode,
      phoneNumber: phoneNumber,
      email: email,
      verifyCode: verifyCode,
      newPaymentPassword: newPaymentPassword,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }
}
