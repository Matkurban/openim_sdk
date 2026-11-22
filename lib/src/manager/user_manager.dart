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

  UserManager({required this._context}) : super('UserManager');

  void setUserListener(OnUserListener listener) {
    setPrimaryListener(listener);
  }

  Set<String> get subscribedStatusUserIDs => Set<String>.unmodifiable(_subscribedStatusUserIDs);

  @override
  void onLogout() {
    _subscribedStatusUserIDs.clear();
    super.onLogout();
  }

  Future<List<UserInfo>> getUsersInfo({required List<String> userIDList}) =>
      getUsersInfoWithCache(userIDList: userIDList);

  Future<List<UserInfo>> getUsersInfoWithCache({required List<String> userIDList}) async {
    if (userIDList.isEmpty) {
      return <UserInfo>[];
    }
    final List<UserInfo> cached = await _context.db.users.getUsersByIDs(userIDList);
    final Set<String> cachedIDs = cached.map<String>((UserInfo u) => u.userID).toSet();
    final List<String> missing = userIDList.where((String id) => !cachedIDs.contains(id)).toList();
    if (missing.isEmpty) {
      return cached;
    }
    final List<UserInfo> fetched = await getUsersInfoFromSrv(userIDList: missing);
    return <UserInfo>[...cached, ...fetched];
  }

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

  Future<Map<String, String>> getUserClientConfig() async {
    final ApiResponse resp = await _context.apis.user.getUserClientConfig(userID: currentUserID);
    if (resp.errCode != 0) {
      return <String, String>{};
    }
    final Map<String, dynamic> configs =
        resp.data?['configs'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    return configs.map<String, String>((String k, dynamic v) => MapEntry<String, String>(k, '$v'));
  }

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

  Future<String> getRtcToken({required String roomId, required String userId}) async {
    final ApiResponse resp = await _context.apis.user.getRtcToken(roomId: roomId, userId: userId);
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    return resp.data?['token']?.toString() ?? '';
  }

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

  Future<void> deleteAccount({required String currentPassword}) async {
    final ApiResponse resp = await _context.apis.auth.deleteAccount(
      currentPassword: currentPassword,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

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

  Future<bool> verifyPaymentPassword({required String paymentPassword}) async {
    final ApiResponse resp = await _context.apis.auth.verifyPaymentPassword(
      paymentPassword: paymentPassword,
    );
    return resp.errCode == 0;
  }

  Future<bool> checkPaymentPasswordSet() async {
    final ApiResponse resp = await _context.apis.auth.checkPaymentPasswordSet();
    if (resp.errCode != 0) {
      return false;
    }
    return resp.data?['isSet'] as bool? ?? false;
  }

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
