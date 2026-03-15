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
  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  /// 解析 Token 有效性
  Future<ApiResponse> parseToken() async {
    return HttpClient().post(ImApiUrl.parseToken, data: {});
  }

  /// 获取用户 Token（管理端使用）
  Future<ApiResponse> getUserToken({required String userID, int? platformID}) async {
    return HttpClient().post(
      ImApiUrl.getUserToken,
      data: {'userID': userID, 'platformID': platformID ?? PlatformUtils.platformID},
    );
  }

  /// 登录接口，支持邮箱或手机号登录
  Future<ApiResponse> login({
    String? email,
    String? phoneNumber,
    String? password,
    String? areaCode,
  }) async {
    return await HttpClient().post(
      ChatApiUrl.login,
      data: {
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'areaCode': areaCode,
        'platform': PlatformUtils.platformID,
      },
    );
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
    return await HttpClient().post(
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
  }

  // ---------------------------------------------------------------------------
  // User
  // ---------------------------------------------------------------------------

  /// 获取指定用户信息
  Future<ApiResponse> getUsersInfo({required List<String> userIDs}) async {
    return HttpClient().post(ImApiUrl.getUsersInfo, data: {'userIDs': userIDs});
  }

  /// 更新用户信息
  Future<ApiResponse> updateUserInfo({required Map<String, dynamic> userInfo}) async {
    return HttpClient().post(ImApiUrl.updateUserInfo, data: userInfo);
  }

  /// 订阅用户状态
  Future<ApiResponse> subscribeUsersStatus({
    required String userID,
    required List<String> userIDs,
    required int genre,
  }) async {
    return HttpClient().post(
      ImApiUrl.subscribeUsersStatus,
      data: {'userID': userID, 'userIDs': userIDs, 'genre': genre},
    );
  }

  /// 获取已订阅用户状态
  Future<ApiResponse> getSubscribeUsersStatus({required String userID}) async {
    return HttpClient().post(ImApiUrl.getSubscribeUsersStatus, data: {'userID': userID});
  }

  /// 获取用户在线状态
  Future<ApiResponse> getUserStatus({required String userID, required List<String> userIDs}) async {
    return HttpClient().post(ImApiUrl.getUserStatus, data: {'userID': userID, 'userIDs': userIDs});
  }

  /// 更新用户扩展信息
  Future<ApiResponse> updateUserInfoEx({required Map<String, dynamic> userInfo}) async {
    return HttpClient().post(ImApiUrl.updateUserInfoEx, data: userInfo);
  }

  /// 获取用户客户端配置
  Future<ApiResponse> getUserClientConfig({required String userID}) async {
    return HttpClient().post(ImApiUrl.getUserClientConfig, data: {'userID': userID});
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
    return HttpClient().post(
      ImApiUrl.addFriend,
      data: {
        'fromUserID': fromUserID,
        'toUserID': toUserID,
        'reqMsg': reqMsg ?? '',
        'ex': ex ?? '',
      },
    );
  }

  /// 删除好友
  Future<ApiResponse> deleteFriend({
    required String ownerUserID,
    required String friendUserID,
  }) async {
    return HttpClient().post(
      ImApiUrl.deleteFriend,
      data: {'ownerUserID': ownerUserID, 'friendUserID': friendUserID},
    );
  }

  /// 获取收到的好友申请列表
  Future<ApiResponse> getRecvFriendApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    return HttpClient().post(
      ImApiUrl.getRecvFriendApplicationList,
      data: {
        'userID': userID,
        'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
      },
    );
  }

  /// 获取发出的好友申请列表
  Future<ApiResponse> getSelfFriendApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    return HttpClient().post(
      ImApiUrl.getSelfFriendApplicationList,
      data: {
        'userID': userID,
        'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
      },
    );
  }

  /// 回复好友申请
  Future<ApiResponse> addFriendResponse({
    required String fromUserID,
    required String toUserID,
    required int handleResult,
    String? handleMsg,
  }) async {
    return HttpClient().post(
      ImApiUrl.addFriendResponse,
      data: {
        'fromUserID': fromUserID,
        'toUserID': toUserID,
        'handleResult': handleResult,
        'handleMsg': handleMsg ?? '',
      },
    );
  }

  /// 更新好友信息（备注、置顶等）
  Future<ApiResponse> updateFriends({required Map<String, dynamic> req}) async {
    return HttpClient().post(ImApiUrl.updateFriends, data: req);
  }

  /// 拉取好友列表（分页）
  Future<ApiResponse> getFriendList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    return HttpClient().post(
      ImApiUrl.getFriendList,
      data: {
        'userID': userID,
        'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
      },
    );
  }

  /// 获取指定好友信息
  Future<ApiResponse> getDesignatedFriends({
    required String ownerUserID,
    required List<String> friendUserIDs,
  }) async {
    return HttpClient().post(
      ImApiUrl.getDesignatedFriends,
      data: {'ownerUserID': ownerUserID, 'friendUserIDs': friendUserIDs},
    );
  }

  /// 增量同步好友
  Future<ApiResponse> getIncrementalFriends({required Map<String, dynamic> req}) async {
    return HttpClient().post(ImApiUrl.getIncrementalFriends, data: req);
  }

  /// 获取完整好友 ID 列表
  Future<ApiResponse> getFullFriendUserIDs({required String userID}) async {
    return HttpClient().post(ImApiUrl.getFullFriendUserIDs, data: {'userID': userID});
  }

  /// 添加黑名单
  Future<ApiResponse> addBlack({
    required String ownerUserID,
    required String blackUserID,
    String? ex,
  }) async {
    return HttpClient().post(
      ImApiUrl.addBlack,
      data: {'ownerUserID': ownerUserID, 'blackUserID': blackUserID, 'ex': ex ?? ''},
    );
  }

  /// 移除黑名单
  Future<ApiResponse> removeBlack({
    required String ownerUserID,
    required String blackUserID,
  }) async {
    return HttpClient().post(
      ImApiUrl.removeBlack,
      data: {'ownerUserID': ownerUserID, 'blackUserID': blackUserID},
    );
  }

  /// 获取黑名单列表
  Future<ApiResponse> getBlackList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    return HttpClient().post(
      ImApiUrl.getBlackList,
      data: {
        'userID': userID,
        'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Group
  // ---------------------------------------------------------------------------

  /// 创建群组
  Future<ApiResponse> createGroup({required Map<String, dynamic> req}) async {
    return HttpClient().post(ImApiUrl.createGroup, data: req);
  }

  /// 设置群信息
  Future<ApiResponse> setGroupInfoEx({required Map<String, dynamic> req}) async {
    return HttpClient().post(ImApiUrl.setGroupInfoEx, data: req);
  }

  /// 加入群组
  Future<ApiResponse> joinGroup({
    required String groupID,
    String? reqMessage,
    int joinSource = 3,
    String? inviterUserID,
    String? ex,
  }) async {
    return HttpClient().post(
      ImApiUrl.joinGroup,
      data: {
        'groupID': groupID,
        'reqMessage': reqMessage ?? '',
        'joinSource': joinSource,
        'inviterUserID': inviterUserID ?? '',
        'ex': ex ?? '',
      },
    );
  }

  /// 退出群组
  Future<ApiResponse> quitGroup({required String userID, required String groupID}) async {
    return HttpClient().post(ImApiUrl.quitGroup, data: {'userID': userID, 'groupID': groupID});
  }

  /// 获取群信息
  Future<ApiResponse> getGroupsInfo({required List<String> groupIDs}) async {
    return HttpClient().post(ImApiUrl.getGroupsInfo, data: {'groupIDs': groupIDs});
  }

  /// 获取群成员列表（分页）
  Future<ApiResponse> getGroupMemberList({
    required String groupID,
    int offset = 0,
    int count = 100,
    int filter = 0,
  }) async {
    return HttpClient().post(
      ImApiUrl.getGroupMemberList,
      data: {
        'groupID': groupID,
        'filter': filter,
        'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
      },
    );
  }

  /// 获取指定群成员信息
  Future<ApiResponse> getGroupMembersInfo({
    required String groupID,
    required List<String> userIDs,
  }) async {
    return HttpClient().post(
      ImApiUrl.getGroupMembersInfo,
      data: {'groupID': groupID, 'userIDs': userIDs},
    );
  }

  /// 邀请用户入群
  Future<ApiResponse> inviteUserToGroup({
    required String groupID,
    required List<String> invitedUserIDs,
    String? reason,
  }) async {
    return HttpClient().post(
      ImApiUrl.inviteUserToGroup,
      data: {'groupID': groupID, 'invitedUserIDs': invitedUserIDs, 'reason': reason ?? ''},
    );
  }

  /// 获取已加入群列表
  Future<ApiResponse> getJoinedGroupList({
    required String fromUserID,
    int offset = 0,
    int count = 100,
  }) async {
    return HttpClient().post(
      ImApiUrl.getJoinedGroupList,
      data: {
        'fromUserID': fromUserID,
        'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
      },
    );
  }

  /// 踢出群成员
  Future<ApiResponse> kickGroupMember({
    required String groupID,
    required List<String> kickedUserIDs,
    String? reason,
  }) async {
    return HttpClient().post(
      ImApiUrl.kickGroup,
      data: {'groupID': groupID, 'kickedUserIDs': kickedUserIDs, 'reason': reason ?? ''},
    );
  }

  /// 转让群主
  Future<ApiResponse> transferGroup({
    required String groupID,
    required String oldOwnerUserID,
    required String newOwnerUserID,
  }) async {
    return HttpClient().post(
      ImApiUrl.transferGroup,
      data: {
        'groupID': groupID,
        'oldOwnerUserID': oldOwnerUserID,
        'newOwnerUserID': newOwnerUserID,
      },
    );
  }

  /// 获取收到的入群申请
  Future<ApiResponse> getRecvGroupApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    return HttpClient().post(
      ImApiUrl.getRecvGroupApplicationList,
      data: {
        'fromUserID': userID,
        'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
      },
    );
  }

  /// 获取发出的入群申请
  Future<ApiResponse> getSendGroupApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) async {
    return HttpClient().post(
      ImApiUrl.getSendGroupApplicationList,
      data: {
        'fromUserID': userID,
        'pagination': {'pageNumber': offset ~/ count + 1, 'showNumber': count},
      },
    );
  }

  /// 处理入群申请
  Future<ApiResponse> groupApplicationResponse({
    required String groupID,
    required String fromUserID,
    required String handledMsg,
    required int handleResult,
  }) async {
    return HttpClient().post(
      ImApiUrl.groupApplicationResponse,
      data: {
        'groupID': groupID,
        'fromUserID': fromUserID,
        'handledMsg': handledMsg,
        'handleResult': handleResult,
      },
    );
  }

  /// 解散群
  Future<ApiResponse> dismissGroup({required String groupID}) async {
    return HttpClient().post(ImApiUrl.dismissGroup, data: {'groupID': groupID});
  }

  /// 禁言群成员
  Future<ApiResponse> muteGroupMember({
    required String groupID,
    required String userID,
    required int mutedSeconds,
  }) async {
    return HttpClient().post(
      ImApiUrl.muteGroupMember,
      data: {'groupID': groupID, 'userID': userID, 'mutedSeconds': mutedSeconds},
    );
  }

  /// 取消禁言群成员
  Future<ApiResponse> cancelMuteGroupMember({
    required String groupID,
    required String userID,
  }) async {
    return HttpClient().post(
      ImApiUrl.cancelMuteGroupMember,
      data: {'groupID': groupID, 'userID': userID},
    );
  }

  /// 全员禁言
  Future<ApiResponse> muteGroup({required String groupID}) async {
    return HttpClient().post(ImApiUrl.muteGroup, data: {'groupID': groupID});
  }

  /// 取消全员禁言
  Future<ApiResponse> cancelMuteGroup({required String groupID}) async {
    return HttpClient().post(ImApiUrl.cancelMuteGroup, data: {'groupID': groupID});
  }

  /// 设置群成员信息
  Future<ApiResponse> setGroupMemberInfo({required Map<String, dynamic> req}) async {
    return HttpClient().post(ImApiUrl.setGroupMemberInfo, data: req);
  }

  // ---------------------------------------------------------------------------
  // Message
  // ---------------------------------------------------------------------------

  /// 发送消息
  Future<ApiResponse> sendMsg({required Map<String, dynamic> msgData}) async {
    return HttpClient().post(ImApiUrl.sendMsg, data: msgData);
  }

  /// 撤回消息
  Future<ApiResponse> revokeMsg({
    required String userID,
    required String conversationID,
    required int seq,
  }) async {
    return HttpClient().post(
      ImApiUrl.revokeMsg,
      data: {'userID': userID, 'conversationID': conversationID, 'seq': seq},
    );
  }

  /// 标记消息为已读
  Future<ApiResponse> markMsgsAsRead({
    required String userID,
    required String conversationID,
    required List<int> seqs,
  }) async {
    return HttpClient().post(
      ImApiUrl.markMsgsAsRead,
      data: {'userID': userID, 'conversationID': conversationID, 'seqs': seqs},
    );
  }

  /// 标记会话为已读
  Future<ApiResponse> markConversationAsRead({
    required String userID,
    required String conversationID,
    required int hasReadSeq,
  }) async {
    return HttpClient().post(
      ImApiUrl.markConversationAsRead,
      data: {'userID': userID, 'conversationID': conversationID, 'hasReadSeq': hasReadSeq},
    );
  }

  /// 删除消息
  Future<ApiResponse> deleteMsgs({
    required String userID,
    required String conversationID,
    required List<int> seqs,
  }) async {
    return HttpClient().post(
      ImApiUrl.deleteMsgs,
      data: {'userID': userID, 'conversationID': conversationID, 'seqs': seqs},
    );
  }

  /// 清空会话消息
  Future<ApiResponse> clearConversationMsg({
    required String userID,
    required List<String> conversationIDs,
  }) async {
    return HttpClient().post(
      ImApiUrl.clearConversationMsg,
      data: {'userID': userID, 'conversationIDs': conversationIDs},
    );
  }

  /// 清空全部消息
  Future<ApiResponse> clearAllMsg({required String userID}) async {
    return HttpClient().post(ImApiUrl.clearAllMsg, data: {'userID': userID});
  }

  /// 获取会话已读和最大 seq
  Future<ApiResponse> getConversationsHasReadAndMaxSeq({
    required String userID,
    required List<String> conversationIDs,
  }) async {
    return HttpClient().post(
      ImApiUrl.getConversationsHasReadAndMaxSeq,
      data: {'userID': userID, 'conversationIDs': conversationIDs},
    );
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
    return HttpClient().post(
      ImApiUrl.pullMsgBySeqs,
      data: {'userID': userID, 'seqRanges': seqRanges, 'order': order},
    );
  }

  /// 获取服务器时间
  Future<ApiResponse> getServerTime() async {
    return HttpClient().post(ImApiUrl.getServerTime, data: {});
  }

  // ---------------------------------------------------------------------------
  // Conversation
  // ---------------------------------------------------------------------------

  /// 获取指定会话
  Future<ApiResponse> getConversations({
    required String ownerUserID,
    required List<String> conversationIDs,
  }) async {
    return HttpClient().post(
      ImApiUrl.getConversations,
      data: {'ownerUserID': ownerUserID, 'conversationIDs': conversationIDs},
    );
  }

  /// 获取全部会话
  Future<ApiResponse> getAllConversations({required String ownerUserID}) async {
    return HttpClient().post(ImApiUrl.getAllConversations, data: {'ownerUserID': ownerUserID});
  }

  /// 设置会话属性
  Future<ApiResponse> setConversations({required Map<String, dynamic> req}) async {
    return HttpClient().post(ImApiUrl.setConversations, data: req);
  }

  /// 增量同步会话
  Future<ApiResponse> getIncrementalConversation({required Map<String, dynamic> req}) async {
    return HttpClient().post(ImApiUrl.getIncrementalConversation, data: req);
  }

  /// 获取完整会话 ID 列表
  Future<ApiResponse> getFullConversationIDs({required String userID}) async {
    return HttpClient().post(ImApiUrl.getFullConversationIDs, data: {'userID': userID});
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
    return HttpClient().post(
      ImApiUrl.fcmUpdateToken,
      data: {
        'platformID': platformID,
        'fcmToken': fcmToken,
        'account': account,
        'expireTime': expireTime,
      },
    );
  }

  /// 设置 App 角标
  Future<ApiResponse> setAppBadge({required String userID, required int appUnreadCount}) async {
    return HttpClient().post(
      ImApiUrl.setAppBadge,
      data: {'userID': userID, 'appUnreadCount': appUnreadCount},
    );
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
    return HttpClient().post(
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
  }

  /// 完成分片上传
  Future<ApiResponse> completeMultipartUpload({
    required String uploadID,
    required List<String> parts,
    required String name,
    required String contentType,
    required String cause,
  }) async {
    return HttpClient().post(
      ImApiUrl.objectCompleteUpload,
      data: {
        'uploadID': uploadID,
        'parts': parts,
        'name': name,
        'contentType': contentType,
        'cause': cause,
      },
    );
  }
}
