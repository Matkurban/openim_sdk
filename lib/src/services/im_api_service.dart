import 'dart:convert';

import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:dio/dio.dart';
import 'package:openim_sdk/src/config/api_url.dart';
import 'package:openim_sdk/src/models/api_response.dart';
import 'package:openim_sdk/src/network/http_client.dart';
import 'package:openim_sdk/src/utils/open_im_utils.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';

/// OpenIM 核心服务端 API（对应 openim-server 的 REST 接口）
///
/// 所有方法返回 [ApiResponse]，调用方根据 errCode 判断成功与否。
/// token 由 [HttpClient] 统一在请求头中携带。
class ImApiService {
  ImApiService._internal();

  static final ImApiService _instance = ImApiService._internal();

  factory ImApiService() => _instance;

  final AoiweLogger _log = AoiweLogger('ImApiService');
  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  /// 解析 Token 有效性
  Future<ApiResponse> parseToken({required String token}) async {
    _log.info('token=${token.isNotEmpty ? "***" : ""}', methodName: 'parseToken');
    try {
      return await HttpClient().post(ImApiUrl.parseToken, data: {'token': token});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'parseToken');
      rethrow;
    }
  }

  /// 获取用户 Token（管理端使用）
  Future<ApiResponse> getUserToken({required String userID, int? platformID}) async {
    _log.info('userID=$userID, platformID=$platformID', methodName: 'getUserToken');
    try {
      return await HttpClient().post(
        ImApiUrl.getUserToken,
        data: {'userID': userID, 'platformID': platformID ?? PlatformUtils.platformID},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUserToken');
      rethrow;
    }
  }

  /// 注册接口，支持邮箱或手机号注册
  Future<ApiResponse> register({
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
    _log.info(
      'nickname=$nickname, areaCode=$areaCode, phoneNumber=$phoneNumber, email=$email, account=$account, birth=$birth, gender=$gender, verificationCode=$verificationCode, invitationCode=$invitationCode, autoLogin=$autoLogin, deviceID=$deviceID',
      methodName: 'register',
    );
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.register,
        data: {
          "deviceID": deviceID,
          "verifyCode": verificationCode,
          "platform": PlatformUtils.platformID,
          "invitationCode": invitationCode,
          "autoLogin": autoLogin,
          "user": {
            "nickname": nickname,
            "faceURL": faceURL,
            "birth": birth,
            "gender": gender,
            "email": email,
            "areaCode": areaCode,
            "phoneNumber": phoneNumber,
            "account": account,
            "password": OpenImUtils.generateMD5(password),
          },
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'register');
      rethrow;
    }
  }

  /// 发送验证码
  Future<ApiResponse> sendVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required int usedFor,
    String? invitationCode,
  }) async {
    _log.info(
      'areaCode=$areaCode, phoneNumber=$phoneNumber, email=$email, usedFor=$usedFor, invitationCode=$invitationCode',
      methodName: 'sendVerificationCode',
    );
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.captcha,
        data: {
          "areaCode": ?areaCode,
          "phoneNumber": ?phoneNumber,
          "email": ?email,
          "usedFor": usedFor,
          "invitationCode": ?invitationCode,
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'sendVerificationCode');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // User
  // ---------------------------------------------------------------------------

  /// 获取指定用户信息
  Future<ApiResponse> getUsersInfo({required List<String> userIDs}) async {
    _log.info('userIDs=$userIDs', methodName: 'getUsersInfo');
    try {
      return await HttpClient().post(ImApiUrl.getUsersInfo, data: {'userIDs': userIDs});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUsersInfo');
      rethrow;
    }
  }

  /// 更新用户信息
  Future<ApiResponse> updateUserInfo({required Map<String, dynamic> userInfo}) async {
    _log.info('userInfo=$userInfo', methodName: 'updateUserInfo');
    try {
      return await HttpClient().post(ImApiUrl.updateUserInfo, data: userInfo);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'updateUserInfo');
      rethrow;
    }
  }

  /// 订阅用户状态
  Future<ApiResponse> subscribeUsersStatus({
    required String userID,
    required List<String> userIDs,
    required int genre,
  }) async {
    _log.info('userID=$userID, userIDs=$userIDs, genre=$genre', methodName: 'subscribeUsersStatus');
    try {
      return await HttpClient().post(
        ImApiUrl.subscribeUsersStatus,
        data: {'userID': userID, 'userIDs': userIDs, 'genre': genre},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'subscribeUsersStatus');
      rethrow;
    }
  }

  /// 获取已订阅用户状态
  Future<ApiResponse> getSubscribeUsersStatus({required String userID}) async {
    _log.info('userID=$userID', methodName: 'getSubscribeUsersStatus');
    try {
      return await HttpClient().post(ImApiUrl.getSubscribeUsersStatus, data: {'userID': userID});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getSubscribeUsersStatus');
      rethrow;
    }
  }

  /// 获取用户在线状态
  Future<ApiResponse> getUserStatus({required String userID, required List<String> userIDs}) async {
    _log.info('userID=$userID, userIDs=$userIDs', methodName: 'getUserStatus');
    try {
      return await HttpClient().post(
        ImApiUrl.getUserStatus,
        data: {'userID': userID, 'userIDs': userIDs},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUserStatus');
      rethrow;
    }
  }

  /// 更新用户扩展信息
  Future<ApiResponse> updateUserInfoEx({required Map<String, dynamic> userInfo}) async {
    _log.info('userInfo=$userInfo', methodName: 'updateUserInfoEx');
    try {
      return await HttpClient().post(ImApiUrl.updateUserInfoEx, data: userInfo);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'updateUserInfoEx');
      rethrow;
    }
  }

  /// 获取用户客户端配置
  Future<ApiResponse> getUserClientConfig({required String userID}) async {
    _log.info('userID=$userID', methodName: 'getUserClientConfig');
    try {
      return await HttpClient().post(ImApiUrl.getUserClientConfig, data: {'userID': userID});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUserClientConfig');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Chat Server API（使用 chatToken 访问 chatAddr）
  // ---------------------------------------------------------------------------

  /// 搜索好友（chat 服务端）
  Future<ApiResponse> searchFriend({
    required String keyword,
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    _log.info(
      'keyword=$keyword, pageNumber=$pageNumber, showNumber=$showNumber',
      methodName: 'searchFriend',
    );
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.searchFriend,
        data: {
          'keyword': keyword,
          'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'searchFriend');
      rethrow;
    }
  }

  /// 搜索用户完整信息（chat 服务端）
  Future<ApiResponse> searchUserFullInfo({
    required String keyword,
    int pageNumber = 1,
    int showNumber = 10,
  }) async {
    _log.info(
      'keyword=$keyword, pageNumber=$pageNumber, showNumber=$showNumber',
      methodName: 'searchUserFullInfo',
    );
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.searchUserFull,
        data: {
          'keyword': keyword,
          'pagination': {'pageNumber': pageNumber, 'showNumber': showNumber},
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'searchUserFullInfo');
      rethrow;
    }
  }

  /// 获取用户完整信息（chat 服务端）
  Future<ApiResponse> getUserFullInfo({required List<String> userIDs}) async {
    _log.info('userIDs=$userIDs', methodName: 'getUserFullInfo');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.getUserFull,
        data: {
          'pagination': {'pageNumber': 1, 'showNumber': userIDs.length},
          'userIDs': userIDs,
          'platform': PlatformUtils.platformID,
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUserFullInfo');
      rethrow;
    }
  }

  /// 更新用户信息（chat 服务端）
  Future<ApiResponse> updateChatUserInfo({
    required String userID,
    String? account,
    String? phoneNumber,
    String? areaCode,
    String? email,
    String? nickname,
    String? faceURL,
    int? gender,
    int? birth,
  }) async {
    _log.info(
      'userID=$userID, account=$account, phoneNumber=$phoneNumber, areaCode=$areaCode, email=$email, nickname=$nickname, gender=$gender, birth=$birth',
      methodName: 'updateChatUserInfo',
    );
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.updateUser,
        data: {
          'userID': userID,
          'platform': PlatformUtils.platformID,
          'account': ?account,
          'phoneNumber': ?phoneNumber,
          'areaCode': ?areaCode,
          'email': ?email,
          'nickname': ?nickname,
          'faceURL': ?faceURL,
          'gender': ?gender,
          'birth': ?birth,
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'updateChatUserInfo');
      rethrow;
    }
  }

  /// 获取 RTC Token（chat 服务端）
  Future<ApiResponse> getRtcToken({required String roomId, required String userId}) async {
    _log.info('roomId=$roomId, userId=$userId', methodName: 'getRtcToken');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.getRtcToken,
        data: {'roomId': roomId, 'userId': userId},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getRtcToken');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Friend / Relation
  // ---------------------------------------------------------------------------

  /// 发起好友申请
  Future<ApiResponse> addFriend({
    required String fromUserID,
    required String toUserID,
    String? reqMsg,
    String? ex,
  }) async {
    _log.info(
      'fromUserID=$fromUserID, toUserID=$toUserID, reqMsg=$reqMsg',
      methodName: 'addFriend',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.addFriend,
        data: {
          'fromUserID': fromUserID,
          'toUserID': toUserID,
          'reqMsg': reqMsg ?? '',
          'ex': ex ?? '',
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addFriend');
      rethrow;
    }
  }

  /// 删除好友
  Future<ApiResponse> deleteFriend({
    required String ownerUserID,
    required String friendUserID,
  }) async {
    _log.info('ownerUserID=$ownerUserID, friendUserID=$friendUserID', methodName: 'deleteFriend');
    try {
      return await HttpClient().post(
        ImApiUrl.deleteFriend,
        data: {'ownerUserID': ownerUserID, 'friendUserID': friendUserID},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'deleteFriend');
      rethrow;
    }
  }

  /// 获取收到的好友申请列表
  Future<ApiResponse> getRecvFriendApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    _log.info(
      'userID=$userID, offset=$offset, count=$count',
      methodName: 'getRecvFriendApplicationList',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.getRecvFriendApplicationList,
        data: {
          'userID': userID,
          'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getRecvFriendApplicationList');
      rethrow;
    }
  }

  /// 获取发出的好友申请列表
  Future<ApiResponse> getSelfFriendApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    _log.info(
      'userID=$userID, offset=$offset, count=$count',
      methodName: 'getSelfFriendApplicationList',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.getSelfFriendApplicationList,
        data: {
          'userID': userID,
          'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getSelfFriendApplicationList');
      rethrow;
    }
  }

  /// 回复好友申请
  Future<ApiResponse> addFriendResponse({
    required String fromUserID,
    required String toUserID,
    required int handleResult,
    String? handleMsg,
  }) async {
    _log.info(
      'fromUserID=$fromUserID, toUserID=$toUserID, handleResult=$handleResult, handleMsg=$handleMsg',
      methodName: 'addFriendResponse',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.addFriendResponse,
        data: {
          'fromUserID': fromUserID,
          'toUserID': toUserID,
          'handleResult': handleResult,
          'handleMsg': handleMsg ?? '',
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addFriendResponse');
      rethrow;
    }
  }

  /// 更新好友信息（备注、置顶等）
  Future<ApiResponse> updateFriends({required Map<String, dynamic> req}) async {
    _log.info('req=$req', methodName: 'updateFriends');
    try {
      return await HttpClient().post(ImApiUrl.updateFriends, data: req);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'updateFriends');
      rethrow;
    }
  }

  /// 拉取好友列表（分页）
  Future<ApiResponse> getFriendList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    _log.info('userID=$userID, offset=$offset, count=$count', methodName: 'getFriendList');
    try {
      return await HttpClient().post(
        ImApiUrl.getFriendList,
        data: {
          'userID': userID,
          'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getFriendList');
      rethrow;
    }
  }

  /// 获取指定好友信息
  Future<ApiResponse> getDesignatedFriends({
    required String ownerUserID,
    required List<String> friendUserIDs,
  }) async {
    _log.info(
      'ownerUserID=$ownerUserID, friendUserIDs=$friendUserIDs',
      methodName: 'getDesignatedFriends',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.getDesignatedFriends,
        data: {'ownerUserID': ownerUserID, 'friendUserIDs': friendUserIDs},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getDesignatedFriends');
      rethrow;
    }
  }

  /// 增量同步好友
  Future<ApiResponse> getIncrementalFriends({required Map<String, dynamic> req}) async {
    _log.info('req=$req', methodName: 'getIncrementalFriends');
    try {
      return await HttpClient().post(ImApiUrl.getIncrementalFriends, data: req);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getIncrementalFriends');
      rethrow;
    }
  }

  /// 获取完整好友 ID 列表
  Future<ApiResponse> getFullFriendUserIDs({required String userID}) async {
    _log.info('userID=$userID', methodName: 'getFullFriendUserIDs');
    try {
      return await HttpClient().post(ImApiUrl.getFullFriendUserIDs, data: {'userID': userID});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getFullFriendUserIDs');
      rethrow;
    }
  }

  /// 添加黑名单
  Future<ApiResponse> addBlack({
    required String ownerUserID,
    required String blackUserID,
    String? ex,
  }) async {
    _log.info('ownerUserID=$ownerUserID, blackUserID=$blackUserID', methodName: 'addBlack');
    try {
      return await HttpClient().post(
        ImApiUrl.addBlack,
        data: {'ownerUserID': ownerUserID, 'blackUserID': blackUserID, 'ex': ex ?? ''},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addBlack');
      rethrow;
    }
  }

  /// 移除黑名单
  Future<ApiResponse> removeBlack({
    required String ownerUserID,
    required String blackUserID,
  }) async {
    _log.info('ownerUserID=$ownerUserID, blackUserID=$blackUserID', methodName: 'removeBlack');
    try {
      return await HttpClient().post(
        ImApiUrl.removeBlack,
        data: {'ownerUserID': ownerUserID, 'blackUserID': blackUserID},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'removeBlack');
      rethrow;
    }
  }

  /// 获取黑名单列表
  Future<ApiResponse> getBlackList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    _log.info('userID=$userID, offset=$offset, count=$count', methodName: 'getBlackList');
    try {
      return await HttpClient().post(
        ImApiUrl.getBlackList,
        data: {
          'userID': userID,
          'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getBlackList');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Group
  // ---------------------------------------------------------------------------

  /// 创建群组
  Future<ApiResponse> createGroup({required Map<String, dynamic> req}) async {
    _log.info('req=$req', methodName: 'createGroup');
    try {
      return await HttpClient().post(ImApiUrl.createGroup, data: req);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createGroup');
      rethrow;
    }
  }

  /// 设置群信息
  Future<ApiResponse> setGroupInfoEx({required Map<String, dynamic> req}) async {
    _log.info('req=$req', methodName: 'setGroupInfoEx');
    try {
      return await HttpClient().post(ImApiUrl.setGroupInfoEx, data: req);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setGroupInfoEx');
      rethrow;
    }
  }

  /// 加入群组
  Future<ApiResponse> joinGroup({
    required String groupID,
    String? reqMessage,
    int joinSource = 3,
    String? inviterUserID,
    String? ex,
  }) async {
    _log.info(
      'groupID=$groupID, reqMessage=$reqMessage, joinSource=$joinSource, inviterUserID=$inviterUserID',
      methodName: 'joinGroup',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.joinGroup,
        data: {
          'groupID': groupID,
          'reqMessage': reqMessage ?? '',
          'joinSource': joinSource,
          'inviterUserID': inviterUserID ?? '',
          'ex': ex ?? '',
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'joinGroup');
      rethrow;
    }
  }

  /// 退出群组
  Future<ApiResponse> quitGroup({required String userID, required String groupID}) async {
    _log.info('userID=$userID, groupID=$groupID', methodName: 'quitGroup');
    try {
      return await HttpClient().post(
        ImApiUrl.quitGroup,
        data: {'userID': userID, 'groupID': groupID},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'quitGroup');
      rethrow;
    }
  }

  /// 获取群信息
  Future<ApiResponse> getGroupsInfo({required List<String> groupIDs}) async {
    _log.info('groupIDs=$groupIDs', methodName: 'getGroupsInfo');
    try {
      return await HttpClient().post(ImApiUrl.getGroupsInfo, data: {'groupIDs': groupIDs});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getGroupsInfo');
      rethrow;
    }
  }

  /// 获取群成员列表（分页）
  Future<ApiResponse> getGroupMemberList({
    required String groupID,
    int offset = 0,
    int count = 100,
    int filter = 0,
  }) async {
    _log.info(
      'groupID=$groupID, offset=$offset, count=$count, filter=$filter',
      methodName: 'getGroupMemberList',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.getGroupMemberList,
        data: {
          'groupID': groupID,
          'filter': filter,
          'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getGroupMemberList');
      rethrow;
    }
  }

  /// 获取指定群成员信息
  Future<ApiResponse> getGroupMembersInfo({
    required String groupID,
    required List<String> userIDs,
  }) async {
    _log.info('groupID=$groupID, userIDs=$userIDs', methodName: 'getGroupMembersInfo');
    try {
      return await HttpClient().post(
        ImApiUrl.getGroupMembersInfo,
        data: {'groupID': groupID, 'userIDs': userIDs},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getGroupMembersInfo');
      rethrow;
    }
  }

  /// 邀请用户入群
  Future<ApiResponse> inviteUserToGroup({
    required String groupID,
    required List<String> invitedUserIDs,
    String? reason,
  }) async {
    _log.info(
      'groupID=$groupID, invitedUserIDs=$invitedUserIDs, reason=$reason',
      methodName: 'inviteUserToGroup',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.inviteUserToGroup,
        data: {'groupID': groupID, 'invitedUserIDs': invitedUserIDs, 'reason': reason ?? ''},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'inviteUserToGroup');
      rethrow;
    }
  }

  /// 获取已加入群列表
  Future<ApiResponse> getJoinedGroupList({
    required String fromUserID,
    int offset = 0,
    int count = 100,
  }) async {
    _log.info(
      'fromUserID=$fromUserID, offset=$offset, count=$count',
      methodName: 'getJoinedGroupList',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.getJoinedGroupList,
        data: {
          'fromUserID': fromUserID,
          'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getJoinedGroupList');
      rethrow;
    }
  }

  /// 增量同步已加入群组
  Future<ApiResponse> getIncrementalJoinGroup({required Map<String, dynamic> req}) async {
    _log.info('req=$req', methodName: 'getIncrementalJoinGroup');
    try {
      return await HttpClient().post(ImApiUrl.getIncrementalJoinGroup, data: req);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getIncrementalJoinGroup');
      rethrow;
    }
  }

  /// 获取完整已加入群组 ID 列表
  Future<ApiResponse> getFullJoinGroupIDs({required String userID}) async {
    _log.info('userID=$userID', methodName: 'getFullJoinGroupIDs');
    try {
      return await HttpClient().post(ImApiUrl.getFullJoinGroupIDs, data: {'userID': userID});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getFullJoinGroupIDs');
      rethrow;
    }
  }

  /// 踢出群成员
  Future<ApiResponse> kickGroupMember({
    required String groupID,
    required List<String> kickedUserIDs,
    String? reason,
  }) async {
    _log.info(
      'groupID=$groupID, kickedUserIDs=$kickedUserIDs, reason=$reason',
      methodName: 'kickGroupMember',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.kickGroup,
        data: {'groupID': groupID, 'kickedUserIDs': kickedUserIDs, 'reason': reason ?? ''},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'kickGroupMember');
      rethrow;
    }
  }

  /// 转让群主
  Future<ApiResponse> transferGroup({
    required String groupID,
    required String oldOwnerUserID,
    required String newOwnerUserID,
  }) async {
    _log.info(
      'groupID=$groupID, oldOwnerUserID=$oldOwnerUserID, newOwnerUserID=$newOwnerUserID',
      methodName: 'transferGroup',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.transferGroup,
        data: {
          'groupID': groupID,
          'oldOwnerUserID': oldOwnerUserID,
          'newOwnerUserID': newOwnerUserID,
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'transferGroup');
      rethrow;
    }
  }

  /// 获取收到的入群申请
  Future<ApiResponse> getRecvGroupApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    _log.info(
      'userID=$userID, offset=$offset, count=$count',
      methodName: 'getRecvGroupApplicationList',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.getRecvGroupApplicationList,
        data: {
          'fromUserID': userID,
          'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getRecvGroupApplicationList');
      rethrow;
    }
  }

  /// 获取发出的入群申请
  Future<ApiResponse> getSendGroupApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    _log.info(
      'userID=$userID, offset=$offset, count=$count',
      methodName: 'getSendGroupApplicationList',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.getSendGroupApplicationList,
        data: {
          'userID': userID,
          'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getSendGroupApplicationList');
      rethrow;
    }
  }

  /// 处理入群申请
  Future<ApiResponse> groupApplicationResponse({
    required String groupID,
    required String fromUserID,
    required String handledMsg,
    required int handleResult,
  }) async {
    _log.info(
      'groupID=$groupID, fromUserID=$fromUserID, handledMsg=$handledMsg, handleResult=$handleResult',
      methodName: 'groupApplicationResponse',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.groupApplicationResponse,
        data: {
          'groupID': groupID,
          'fromUserID': fromUserID,
          'handledMsg': handledMsg,
          'handleResult': handleResult,
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'groupApplicationResponse');
      rethrow;
    }
  }

  /// 解散群
  Future<ApiResponse> dismissGroup({required String groupID}) async {
    _log.info('groupID=$groupID', methodName: 'dismissGroup');
    try {
      return await HttpClient().post(ImApiUrl.dismissGroup, data: {'groupID': groupID});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'dismissGroup');
      rethrow;
    }
  }

  /// 禁言群成员
  Future<ApiResponse> muteGroupMember({
    required String groupID,
    required String userID,
    required int mutedSeconds,
  }) async {
    _log.info(
      'groupID=$groupID, userID=$userID, mutedSeconds=$mutedSeconds',
      methodName: 'muteGroupMember',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.muteGroupMember,
        data: {'groupID': groupID, 'userID': userID, 'mutedSeconds': mutedSeconds},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'muteGroupMember');
      rethrow;
    }
  }

  /// 取消禁言群成员
  Future<ApiResponse> cancelMuteGroupMember({
    required String groupID,
    required String userID,
  }) async {
    _log.info('groupID=$groupID, userID=$userID', methodName: 'cancelMuteGroupMember');
    try {
      return await HttpClient().post(
        ImApiUrl.cancelMuteGroupMember,
        data: {'groupID': groupID, 'userID': userID},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'cancelMuteGroupMember');
      rethrow;
    }
  }

  /// 全员禁言
  Future<ApiResponse> muteGroup({required String groupID}) async {
    _log.info('groupID=$groupID', methodName: 'muteGroup');
    try {
      return await HttpClient().post(ImApiUrl.muteGroup, data: {'groupID': groupID});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'muteGroup');
      rethrow;
    }
  }

  /// 取消全员禁言
  Future<ApiResponse> cancelMuteGroup({required String groupID}) async {
    _log.info('groupID=$groupID', methodName: 'cancelMuteGroup');
    try {
      return await HttpClient().post(ImApiUrl.cancelMuteGroup, data: {'groupID': groupID});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'cancelMuteGroup');
      rethrow;
    }
  }

  /// 设置群成员信息
  Future<ApiResponse> setGroupMemberInfo({required Map<String, dynamic> req}) async {
    _log.info('req=$req', methodName: 'setGroupMemberInfo');
    try {
      return await HttpClient().post(ImApiUrl.setGroupMemberInfo, data: req);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setGroupMemberInfo');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Message
  // ---------------------------------------------------------------------------

  /// 发送消息
  Future<ApiResponse> sendMsg({required Map<String, dynamic> msgData}) async {
    _log.info('msgData=$msgData', methodName: 'sendMsg');
    try {
      return await HttpClient().post(ImApiUrl.sendMsg, data: msgData);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'sendMsg');
      rethrow;
    }
  }

  /// 撤回消息
  Future<ApiResponse> revokeMsg({
    required String userID,
    required String conversationID,
    required int seq,
  }) async {
    _log.info('userID=$userID, conversationID=$conversationID, seq=$seq', methodName: 'revokeMsg');
    try {
      return await HttpClient().post(
        ImApiUrl.revokeMsg,
        data: {'userID': userID, 'conversationID': conversationID, 'seq': seq},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'revokeMsg');
      rethrow;
    }
  }

  /// 标记消息为已读
  Future<ApiResponse> markMsgsAsRead({
    required String userID,
    required String conversationID,
    required List<int> seqs,
  }) async {
    _log.info(
      'userID=$userID, conversationID=$conversationID, seqs=$seqs',
      methodName: 'markMsgsAsRead',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.markMsgsAsRead,
        data: {'userID': userID, 'conversationID': conversationID, 'seqs': seqs},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'markMsgsAsRead');
      rethrow;
    }
  }

  /// 标记会话为已读
  Future<ApiResponse> markConversationAsRead({
    required String userID,
    required String conversationID,
    required int hasReadSeq,
  }) async {
    _log.info(
      'userID=$userID, conversationID=$conversationID, hasReadSeq=$hasReadSeq',
      methodName: 'markConversationAsRead',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.markConversationAsRead,
        data: {'userID': userID, 'conversationID': conversationID, 'hasReadSeq': hasReadSeq},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'markConversationAsRead');
      rethrow;
    }
  }

  /// 删除消息
  Future<ApiResponse> deleteMsgs({
    required String userID,
    required String conversationID,
    required List<int> seqs,
  }) async {
    _log.info(
      'userID=$userID, conversationID=$conversationID, seqs=$seqs',
      methodName: 'deleteMsgs',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.deleteMsgs,
        data: {'userID': userID, 'conversationID': conversationID, 'seqs': seqs},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'deleteMsgs');
      rethrow;
    }
  }

  /// 清空会话消息
  Future<ApiResponse> clearConversationMsg({
    required String userID,
    required List<String> conversationIDs,
  }) async {
    _log.info(
      'userID=$userID, conversationIDs=$conversationIDs',
      methodName: 'clearConversationMsg',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.clearConversationMsg,
        data: {'userID': userID, 'conversationIDs': conversationIDs},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'clearConversationMsg');
      rethrow;
    }
  }

  /// 清空全部消息
  Future<ApiResponse> clearAllMsg({required String userID}) async {
    _log.info('userID=$userID', methodName: 'clearAllMsg');
    try {
      return await HttpClient().post(ImApiUrl.clearAllMsg, data: {'userID': userID});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'clearAllMsg');
      rethrow;
    }
  }

  /// 获取会话已读和最大 seq
  Future<ApiResponse> getConversationsHasReadAndMaxSeq({
    required String userID,
    required List<String> conversationIDs,
  }) async {
    _log.info(
      'userID=$userID, conversationIDs=$conversationIDs',
      methodName: 'getConversationsHasReadAndMaxSeq',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.getConversationsHasReadAndMaxSeq,
        data: {'userID': userID, 'conversationIDs': conversationIDs},
      );
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'getConversationsHasReadAndMaxSeq',
      );
      rethrow;
    }
  }

  /// 按 seq 范围拉取云端消息（HTTP REST 接口）
  ///
  /// [seqRanges] 每项为 {conversationID, begin, end, num}
  /// [order] 0=升序 1=降序
  Future<ApiResponse> pullMsgBySeqs({
    required String userID,
    required List<Map<String, dynamic>> seqRanges,
    int order = 0,
  }) async {
    _log.info(
      'userID=$userID, order=$order, seqRanges=${seqRanges.length} items',
      methodName: 'pullMsgBySeqs',
    );
    try {
      final resp = await HttpClient().post(
        ImApiUrl.pullMsgBySeqs,
        data: {'userID': userID, 'seqRanges': seqRanges, 'order': order},
      );
      if (resp.errCode == 0) {
        _decodePullMsgsContent(resp.data as Map<String, dynamic>?);
      }
      return resp;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'pullMsgBySeqs');
      rethrow;
    }
  }

  /// 将 pullMsgBySeqs 响应中 protojson 自动 base64 编码的 content 字段解码为原始 JSON 字符串。
  ///
  /// proto3 JSON 规范要求把 `bytes` 字段编码为 base64；服务端在 HTTP 回包时统一走 protojson，
  /// 因此 msg.content 会以 base64 出现。WebSocket 路径直接用 protobuf 二进制，不需要此处理。
  /// 此方法原地修改 resp.data，使下游统一面对明文 JSON。
  void _decodePullMsgsContent(Map<String, dynamic>? data) {
    if (data == null) return;
    for (final key in const ['msgs', 'notificationMsgs']) {
      final group = data[key];
      if (group is! Map) continue;
      for (final entry in group.entries) {
        final pullMsgs = entry.value;
        if (pullMsgs is! Map) continue;
        final msgList = (pullMsgs['Msgs'] ?? pullMsgs['msgs']);
        if (msgList is! List) continue;
        for (final msg in msgList) {
          if (msg is! Map) continue;
          final content = msg['content'];
          if (content is! String || content.isEmpty) continue;
          // 已经是 JSON 文本则跳过（防御服务端日后改成直发明文）
          final first = content.codeUnitAt(0);
          if (first == 0x7B /* { */ || first == 0x5B /* [ */ ) continue;
          try {
            msg['content'] = utf8.decode(base64Decode(content));
          } catch (_) {
            // 既非 base64 也非 JSON，保留原值
          }
        }
      }
    }
  }

  /// 获取服务器时间
  Future<ApiResponse> getServerTime() async {
    _log.info('called', methodName: 'getServerTime');
    try {
      return await HttpClient().post(ImApiUrl.getServerTime, data: {});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getServerTime');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Conversation
  // ---------------------------------------------------------------------------

  /// 获取指定会话
  Future<ApiResponse> getConversations({
    required String ownerUserID,
    required List<String> conversationIDs,
  }) async {
    _log.info(
      'ownerUserID=$ownerUserID, conversationIDs=$conversationIDs',
      methodName: 'getConversations',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.getConversations,
        data: {'ownerUserID': ownerUserID, 'conversationIDs': conversationIDs},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getConversations');
      rethrow;
    }
  }

  /// 获取全部会话
  Future<ApiResponse> getAllConversations({required String ownerUserID}) async {
    _log.info('ownerUserID=$ownerUserID', methodName: 'getAllConversations');
    try {
      return await HttpClient().post(
        ImApiUrl.getAllConversations,
        data: {'ownerUserID': ownerUserID},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getAllConversations');
      rethrow;
    }
  }

  /// 设置会话属性
  Future<ApiResponse> setConversations({required Map<String, dynamic> req}) async {
    _log.info('req=$req', methodName: 'setConversations');
    try {
      return await HttpClient().post(ImApiUrl.setConversations, data: req);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setConversations');
      rethrow;
    }
  }

  /// 增量同步会话
  Future<ApiResponse> getIncrementalConversation({required Map<String, dynamic> req}) async {
    _log.info('req=$req', methodName: 'getIncrementalConversation');
    try {
      return await HttpClient().post(ImApiUrl.getIncrementalConversation, data: req);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getIncrementalConversation');
      rethrow;
    }
  }

  /// 获取完整会话 ID 列表
  Future<ApiResponse> getFullConversationIDs({required String userID}) async {
    _log.info('userID=$userID', methodName: 'getFullConversationIDs');
    try {
      return await HttpClient().post(ImApiUrl.getFullConversationIDs, data: {'userID': userID});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getFullConversationIDs');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Third / Object Storage
  // ---------------------------------------------------------------------------

  /// 设置 FCM Token
  Future<ApiResponse> fcmUpdateToken({
    required String platformID,
    required String fcmToken,
    required String account,
    int expireTime = 0,
  }) async {
    _log.info(
      'platformID=$platformID, fcmToken=$fcmToken, account=$account, expireTime=$expireTime',
      methodName: 'fcmUpdateToken',
    );
    try {
      return await HttpClient().post(
        ImApiUrl.fcmUpdateToken,
        data: {
          'platformID': platformID,
          'fcmToken': fcmToken,
          'account': account,
          'expireTime': expireTime,
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'fcmUpdateToken');
      rethrow;
    }
  }

  /// 获取分片上传限制参数
  /// 对应 Go SDK /object/part_limit
  Future<ApiResponse> getPartLimit() async {
    try {
      return await HttpClient().post(ImApiUrl.objectPartLimit, data: {});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getPartLimit');
      rethrow;
    }
  }

  /// 发起分片上传
  Future<ApiResponse> initiateMultipartUpload({
    required String hash,
    required int size,
    required int partSize,
    required int maxParts,
    required String cause,
    required String name,
    required String contentType,
  }) async {
    try {
      return await HttpClient().post(
        ImApiUrl.objectInitiateUpload,
        data: {
          'hash': hash,
          'size': size,
          'partSize': partSize,
          'maxParts': maxParts,
          'cause': cause,
          'name': name,
          'contentType': contentType,
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'initiateMultipartUpload');
      rethrow;
    }
  }

  /// 获取额外的分片上传签名
  Future<ApiResponse> authSign({required String uploadID, required List<int> partNumbers}) async {
    try {
      return await HttpClient().post(
        ImApiUrl.objectAuthSign,
        data: {'uploadID': uploadID, 'partNumbers': partNumbers},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'authSign');
      rethrow;
    }
  }

  /// 完成分片上传
  Future<ApiResponse> completeMultipartUpload({
    required String uploadID,
    required List<String> parts,
    required String name,
    required String contentType,
    required String cause,
  }) async {
    try {
      final result = await HttpClient().post(
        ImApiUrl.objectCompleteUpload,
        data: {
          'uploadID': uploadID,
          'parts': parts,
          'name': name,
          'contentType': contentType,
          'cause': cause,
        },
      );
      return result;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'completeMultipartUpload');
      rethrow;
    }
  }

  /// 获取未处理好友申请数量（对齐 Go SDK: 从服务器获取）
  Future<ApiResponse> getSelfUnhandledApplyCount({required String userID, int time = 0}) async {
    _log.info('userID=$userID, time=$time', methodName: 'getSelfUnhandledApplyCount');
    try {
      return await HttpClient().post(
        ImApiUrl.getSelfUnhandledApplyCount,
        data: {'userID': userID, 'time': time},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getSelfUnhandledApplyCount');
      rethrow;
    }
  }

  /// 获取未处理入群申请数量（对齐 Go SDK: 从服务器获取）
  Future<ApiResponse> getGroupApplicationUnhandledCount({
    required String userID,
    int time = 0,
  }) async {
    _log.info('userID=$userID, time=$time', methodName: 'getGroupApplicationUnhandledCount');
    try {
      return await HttpClient().post(
        ImApiUrl.getGroupApplicationUnhandledCount,
        data: {'userID': userID, 'time': time},
      );
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'getGroupApplicationUnhandledCount',
      );
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Login Password
  // ---------------------------------------------------------------------------

  /// 修改登录密码（通过原密码验证）
  Future<ApiResponse> changePassword({
    required String userID,
    required String currentPassword,
    required String newPassword,
  }) async {
    _log.info('changePassword called', methodName: 'changePassword');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.changePassword,
        data: {
          'userID': userID,
          'currentPassword': OpenImUtils.generateMD5(currentPassword),
          'newPassword': OpenImUtils.generateMD5(newPassword),
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'changePassword');
      rethrow;
    }
  }

  /// 重置登录密码（通过验证码）
  Future<ApiResponse> resetPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verifyCode,
    required String newPassword,
  }) async {
    _log.info('resetPassword called', methodName: 'resetPassword');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.resetPassword,
        data: {
          'areaCode': areaCode,
          'phoneNumber': phoneNumber,
          'email': email,
          'verifyCode': verifyCode,
          'password': OpenImUtils.generateMD5(newPassword),
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'resetPassword');
      rethrow;
    }
  }

  /// 注销当前登录账号（需要再次输入登录密码进行确认）
  Future<ApiResponse> deleteAccount({required String currentPassword}) async {
    _log.info('deleteAccount called', methodName: 'deleteAccount');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.deleteAccount,
        data: {'currentPassword': OpenImUtils.generateMD5(currentPassword)},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'deleteAccount');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Payment Password
  // ---------------------------------------------------------------------------

  /// 设置支付密码（首次设置，需验证登录密码）
  Future<ApiResponse> setPaymentPassword({
    required String paymentPassword,
    required String loginPassword,
  }) async {
    _log.info('setPaymentPassword called', methodName: 'setPaymentPassword');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.setPaymentPassword,
        data: {
          'paymentPassword': paymentPassword,
          'loginPassword': OpenImUtils.generateMD5(loginPassword),
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setPaymentPassword');
      rethrow;
    }
  }

  /// 修改支付密码（已设置，验证当前支付密码后更改）
  Future<ApiResponse> changePaymentPassword({
    required String currentPaymentPassword,
    required String newPaymentPassword,
  }) async {
    _log.info('changePaymentPassword called', methodName: 'changePaymentPassword');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.changePaymentPassword,
        data: {
          'currentPaymentPassword': currentPaymentPassword,
          'newPaymentPassword': newPaymentPassword,
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'changePaymentPassword');
      rethrow;
    }
  }

  /// 验证支付密码
  Future<ApiResponse> verifyPaymentPassword({required String paymentPassword}) async {
    _log.info('verifyPaymentPassword called', methodName: 'verifyPaymentPassword');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.verifyPaymentPassword,
        data: {'paymentPassword': paymentPassword},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'verifyPaymentPassword');
      rethrow;
    }
  }

  /// 检查是否已设置支付密码
  Future<ApiResponse> checkPaymentPasswordSet() async {
    _log.info('checkPaymentPasswordSet called', methodName: 'checkPaymentPasswordSet');
    try {
      return await HttpClient().chatPost(ChatApiUrl.checkPaymentPasswordSet, data: {});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'checkPaymentPasswordSet');
      rethrow;
    }
  }

  /// 通过验证码重置支付密码
  Future<ApiResponse> resetPaymentPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verifyCode,
    required String newPaymentPassword,
  }) async {
    _log.info('resetPaymentPassword called', methodName: 'resetPaymentPassword');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.resetPaymentPassword,
        data: {
          'areaCode': ?areaCode,
          'phoneNumber': ?phoneNumber,
          'email': ?email,
          'verifyCode': verifyCode,
          'newPaymentPassword': newPaymentPassword,
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'resetPaymentPassword');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Report & Appeal
  // ---------------------------------------------------------------------------

  /// 提交举报（已登录用户）
  Future<ApiResponse> createReport({
    required String targetType,
    required String targetID,
    String? messageID,
    required String category,
    String? description,
    List<String>? evidenceUrls,
  }) async {
    _log.info('createReport target=$targetID type=$targetType', methodName: 'createReport');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.createReport,
        data: {
          'targetType': targetType,
          'targetID': targetID,
          'messageID': ?messageID,
          'category': category,
          'description': description ?? '',
          'evidenceUrls': evidenceUrls ?? <String>[],
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createReport');
      rethrow;
    }
  }

  /// 申请申诉验证码（无需登录）
  Future<ApiResponse> requestAppealCaptcha() async {
    _log.info('requestAppealCaptcha', methodName: 'requestAppealCaptcha');
    try {
      return await HttpClient().adminPost(ChatApiUrl.appealCaptcha, data: {});
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'requestAppealCaptcha');
      rethrow;
    }
  }

  /// 提交申诉（无需登录）
  Future<ApiResponse> createAppeal({
    required String account,
    required String reason,
    String? description,
    String? contact,
    required String captchaID,
    required String captchaAnswer,
  }) async {
    _log.info('createAppeal account=$account', methodName: 'createAppeal');
    try {
      return await HttpClient().adminPost(
        ChatApiUrl.appealCreate,
        data: {
          'account': account,
          'reason': reason,
          'description': description ?? '',
          'contact': contact ?? '',
          'captchaID': captchaID,
          'captchaAnswer': captchaAnswer,
        },
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createAppeal');
      rethrow;
    }
  }

  /// 上传申诉证据（需要 appealToken）
  Future<ApiResponse> uploadAppealEvidence({
    required String appealToken,
    required String filePath,
    String? fileName,
  }) async {
    _log.info('uploadAppealEvidence file=$filePath', methodName: 'uploadAppealEvidence');
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      return await HttpClient().adminMultipartPost(
        ChatApiUrl.appealUpload,
        formData: formData,
        headers: {'Authorization': 'appeal $appealToken'},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'uploadAppealEvidence');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Application Version
  // ---------------------------------------------------------------------------

  /// 获取指定平台的最新应用版本（公开接口）
  ///
  /// [platform] 取值：android / ios / windows / macos / linux
  /// [version]  当前客户端版本号（可选，仅用于服务端日志/统计）
  Future<ApiResponse> getLatestApplicationVersion({
    required String platform,
    String? version,
  }) async {
    _log.info('platform=$platform, version=$version', methodName: 'getLatestApplicationVersion');
    try {
      return await HttpClient().chatPost(
        ChatApiUrl.latestApplicationVersion,
        data: {'platform': platform, 'version': ?version},
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getLatestApplicationVersion');
      rethrow;
    }
  }
}
