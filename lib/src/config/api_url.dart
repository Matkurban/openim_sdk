/// Chat 业务服务端 API 路由（注册/登录/验证码/用户搜索等）
sealed class ChatApiUrl {
  /// 登录。
  ///
  /// Login.
  static const String login = '/account/login';

  /// 注册。
  ///
  /// Register.
  static const String register = '/account/register';

  /// 验证码。
  ///
  /// Verification code.
  static const String captcha = '/account/code/send';

  // ---- User ----
  /// 搜索用户全量。
  ///
  /// Search user full.
  static const String searchUserFull = '/user/search/full';

  /// 获取用户全量。
  ///
  /// Get user full.
  static const String getUserFull = '/user/find/full';

  /// 更新用户。
  ///
  /// Update user.
  static const String updateUser = '/user/update';

  // ---- Friend ----
  /// 搜索好友。
  ///
  /// Search friend.
  static const String searchFriend = '/friend/search';

  // ---- Meeting / Call ----
  /// 创建会议。
  ///
  /// Create meeting.
  static const String createMeeting = '/meeting/create';

  /// 加入会议。
  ///
  /// Join meeting.
  static const String joinMeeting = '/meeting/join';

  /// 离开会议。
  ///
  /// Leave meeting.
  static const String leaveMeeting = '/meeting/leave';

  /// 结束会议。
  ///
  /// End meeting.
  static const String endMeeting = '/meeting/end';

  /// 获取会议。
  ///
  /// Get meeting.
  static const String getMeeting = '/meeting/get';

  /// 获取活跃会议。
  ///
  /// Get active meeting.
  static const String getActiveMeeting = '/meeting/get_active';

  // ---- Login Password ----
  /// 变更密码。
  ///
  /// Change password.
  static const String changePassword = '/account/password/change';

  /// 重置密码。
  ///
  /// Reset password.
  static const String resetPassword = '/account/password/reset';

  // ---- Account ----
  /// 注销当前登录账号（删除 chat 端账号凭证 + 强制下线）
  static const String deleteAccount = '/account/delete';

  // ---- Payment Password ----
  /// 设置支付密码。
  ///
  /// Set payment password.
  static const String setPaymentPassword = '/user/payment_password/set';

  /// 变更支付密码。
  ///
  /// Change payment password.
  static const String changePaymentPassword = '/user/payment_password/change';

  /// 校验支付密码。
  ///
  /// Verify payment password.
  static const String verifyPaymentPassword = '/user/payment_password/verify';

  /// 检查支付密码设置。
  ///
  /// Check payment password set.
  static const String checkPaymentPasswordSet = '/user/payment_password/check';

  /// 重置支付密码。
  ///
  /// Reset payment password.
  static const String resetPaymentPassword = '/user/payment_password/reset';

  // ---- Report (登录用户侧) ----
  /// 创建举报。
  ///
  /// Create report.
  static const String createReport = '/report/create';

  // ---- Appeal (公开端，登录前可用) ----
  /// 申诉验证码。
  ///
  /// Appeal verification code.
  static const String appealCaptcha = '/public/appeal/captcha';

  /// 申诉创建。
  ///
  /// Appeal create.
  static const String appealCreate = '/public/appeal/create';

  /// 申诉上传。
  ///
  /// Appeal upload.
  static const String appealUpload = '/public/appeal/upload';

  // ---- Moments ----
  /// 朋友圈时间线游标分页。
  ///
  /// Moments cursor-based timeline.
  static const String momentTimeline = '/moment/timeline';

  /// 朋友圈增量同步。
  ///
  /// Moments incremental sync.
  static const String momentSync = '/moment/sync';

  // ---- Application Version ----
  /// 最新申请版本。
  ///
  /// Latest application version.
  static const String latestApplicationVersion = '/application/latest_version';
}

/// OpenIM 核心服务端 API 路由（对应 openim-server）
sealed class ImApiUrl {
  // ---- Auth ----
  /// 解析令牌。
  ///
  /// Parse token.
  static const String parseToken = '/auth/parse_token';

  /// 获取用户令牌。
  ///
  /// Get user token.
  static const String getUserToken = '/auth/get_user_token';

  // ---- User ----
  /// 获取用户列表信息。
  ///
  /// Get users info.
  static const String getUsersInfo = '/user/get_users_info';

  /// 更新用户信息。
  ///
  /// Update user info.
  static const String updateUserInfo = '/user/update_user_info';

  /// 更新用户信息扩展字段。
  ///
  /// Update user info extension.
  static const String updateUserInfoEx = '/user/update_user_info_ex';

  /// 获取用户客户端配置。
  ///
  /// Get user client configuration.
  static const String getUserClientConfig = '/user/get_user_client_config';

  /// 订阅用户列表状态。
  ///
  /// Subscribe users status.
  static const String subscribeUsersStatus = '/user/subscribe_users_status';

  /// 获取订阅用户列表状态。
  ///
  /// Get subscribe users status.
  static const String getSubscribeUsersStatus = '/user/get_subscribe_users_status';

  /// 获取用户状态。
  ///
  /// Get user status.
  static const String getUserStatus = '/user/get_users_status';

  // ---- Friend ----
  /// 添加好友。
  ///
  /// Add friend.
  static const String addFriend = '/friend/add_friend';

  /// 删除好友。
  ///
  /// Delete friend.
  static const String deleteFriend = '/friend/delete_friend';

  /// 获取接收好友申请列表。
  ///
  /// Get receive friend application list.
  static const String getRecvFriendApplicationList = '/friend/get_friend_apply_list';

  /// 获取当前用户好友申请列表。
  ///
  /// Get self user friend application list.
  static const String getSelfFriendApplicationList = '/friend/get_self_friend_apply_list';

  /// 获取当前用户未处理Apply数量。
  ///
  /// Get self user unhandled apply count.
  static const String getSelfUnhandledApplyCount = '/friend/get_self_unhandled_apply_count';

  /// 获取Designated好友列表Apply。
  ///
  /// Get designated friends apply.
  static const String getDesignatedFriendsApply = '/friend/get_designated_friend_apply';

  /// 获取好友列表。
  ///
  /// Get friend list.
  static const String getFriendList = '/friend/get_friend_list';

  /// 获取Designated好友列表。
  ///
  /// Get designated friends.
  static const String getDesignatedFriends = '/friend/get_designated_friends';

  /// 添加好友响应。
  ///
  /// Add friend response.
  static const String addFriendResponse = '/friend/add_friend_response';

  /// 更新好友列表。
  ///
  /// Update friends.
  static const String updateFriends = '/friend/update_friends';

  /// 获取增量好友列表。
  ///
  /// Get incremental friends.
  static const String getIncrementalFriends = '/friend/get_incremental_friends';

  /// 获取全量好友用户ID 列表。
  ///
  /// Get full friend user i ds.
  static const String getFullFriendUserIDs = '/friend/get_full_friend_user_ids';

  /// 添加黑名单。
  ///
  /// Add blacklist.
  static const String addBlack = '/friend/add_black';

  /// 移除黑名单。
  ///
  /// Remove blacklist.
  static const String removeBlack = '/friend/remove_black';

  /// 获取黑名单列表。
  ///
  /// Get blacklist list.
  static const String getBlackList = '/friend/get_black_list';

  // ---- Group ----
  /// 创建群组。
  ///
  /// Create group.
  static const String createGroup = '/group/create_group';

  /// 设置群组信息扩展字段。
  ///
  /// Set group info extension.
  static const String setGroupInfoEx = '/group/set_group_info_ex';

  /// 加入群组。
  ///
  /// Join group.
  static const String joinGroup = '/group/join_group';

  /// 退出群组。
  ///
  /// Quit group.
  static const String quitGroup = '/group/quit_group';

  /// 获取群组列表信息。
  ///
  /// Get groups info.
  static const String getGroupsInfo = '/group/get_groups_info';

  /// 获取群组成员列表。
  ///
  /// Get group member list.
  static const String getGroupMemberList = '/group/get_group_member_list';

  /// 获取群组成员列表信息。
  ///
  /// Get group members info.
  static const String getGroupMembersInfo = '/group/get_group_members_info';

  /// 邀请用户转为群组。
  ///
  /// Invite user to group.
  static const String inviteUserToGroup = '/group/invite_user_to_group';

  /// 获取Joined群组列表。
  ///
  /// Get joined group list.
  static const String getJoinedGroupList = '/group/get_joined_group_list';

  /// 踢出群组。
  ///
  /// Kick group.
  static const String kickGroup = '/group/kick_group';

  /// 转让群组。
  ///
  /// Transfer group.
  static const String transferGroup = '/group/transfer_group';

  /// 获取接收群组申请列表。
  ///
  /// Get receive group application list.
  static const String getRecvGroupApplicationList = '/group/get_recv_group_applicationList';

  /// 获取发送群组申请列表。
  ///
  /// Get send group application list.
  static const String getSendGroupApplicationList = '/group/get_user_req_group_applicationList';

  /// 获取群组申请未处理数量。
  ///
  /// Get group application unhandled count.
  static const String getGroupApplicationUnhandledCount =
      '/group/get_group_application_unhandled_count';

  /// 群组申请响应。
  ///
  /// Group application response.
  static const String groupApplicationResponse = '/group/group_application_response';

  /// 解散群组。
  ///
  /// Dismiss group.
  static const String dismissGroup = '/group/dismiss_group';

  /// 禁言群组成员。
  ///
  /// Mute group member.
  static const String muteGroupMember = '/group/mute_group_member';

  /// 取消禁言群组成员。
  ///
  /// Cancel mute group member.
  static const String cancelMuteGroupMember = '/group/cancel_mute_group_member';

  /// 禁言群组。
  ///
  /// Mute group.
  static const String muteGroup = '/group/mute_group';

  /// 取消禁言群组。
  ///
  /// Cancel mute group.
  static const String cancelMuteGroup = '/group/cancel_mute_group';

  /// 设置群组成员信息。
  ///
  /// Set group member info.
  static const String setGroupMemberInfo = '/group/set_group_member_info';

  /// 获取增量加入群组。
  ///
  /// Get incremental join group.
  static const String getIncrementalJoinGroup = '/group/get_incremental_join_groups';

  /// 获取全量加入群组ID 列表。
  ///
  /// Get full join group i ds.
  static const String getFullJoinGroupIDs = '/group/get_full_join_group_ids';

  // ---- Message ----
  /// 发送消息。
  ///
  /// Send message.
  static const String sendMsg = '/msg/send_msg';

  /// 撤回消息。
  ///
  /// Revoke message.
  static const String revokeMsg = '/msg/revoke_msg';

  /// 标记消息列表为已读。
  ///
  /// Mark messages as read.
  static const String markMsgsAsRead = '/msg/mark_msgs_as_read';

  /// 标记会话为已读。
  ///
  /// Mark conversation as read.
  static const String markConversationAsRead = '/msg/mark_conversation_as_read';

  /// 删除消息列表。
  ///
  /// Delete messages.
  static const String deleteMsgs = '/msg/delete_msgs';

  /// 清空会话消息。
  ///
  /// Clear conversation message.
  static const String clearConversationMsg = '/msg/clear_conversation_msg';

  /// 清空全部消息。
  ///
  /// Clear all message.
  static const String clearAllMsg = '/msg/user_clear_all_msg';

  /// 获取会话列表是否包含已读与最大序列号。
  ///
  /// Get conversations whether has read and maximum sequence number.
  static const String getConversationsHasReadAndMaxSeq =
      '/msg/get_conversations_has_read_and_max_seq';

  /// 拉取消息按序列号列表。
  ///
  /// Pull message by sequence numbers.
  static const String pullMsgBySeqs = '/msg/pull_msg_by_seq';

  /// 设置会话是否包含读取序列号。
  ///
  /// Set conversation whether has read sequence number.
  static const String setConversationHasReadSeq = '/msg/set_conversation_has_read_seq';

  /// 获取服务端时间戳。
  ///
  /// Get server timestamp.
  static const String getServerTime = '/msg/get_server_time';

  // ---- Conversation ----
  /// 获取会话列表。
  ///
  /// Get conversations.
  static const String getConversations = '/conversation/get_conversations';

  /// 获取全部会话列表。
  ///
  /// Get all conversations.
  static const String getAllConversations = '/conversation/get_all_conversations';

  /// 设置会话列表。
  ///
  /// Set conversations.
  static const String setConversations = '/conversation/set_conversations';

  /// 获取增量会话。
  ///
  /// Get incremental conversation.
  static const String getIncrementalConversation = '/conversation/get_incremental_conversations';

  /// 获取全量会话ID 列表。
  ///
  /// Get full conversation i ds.
  static const String getFullConversationIDs = '/conversation/get_full_conversation_ids';

  /// 获取群主/拥有者会话。
  ///
  /// Get owner conversation.
  static const String getOwnerConversation = '/conversation/get_owner_conversation';

  // ---- Third ----
  /// FCM 推送更新令牌。
  ///
  /// FCM push update token.
  static const String fcmUpdateToken = '/third/fcm_update_token';

  /// 设置App角标。
  ///
  /// Set app badge.
  static const String setAppBadge = '/third/set_app_badge';

  /// 上传Logs。
  ///
  /// Upload logs.
  static const String uploadLogs = '/third/logs/upload';

  // ---- Object Storage ----
  /// 对象分片条数上限。
  ///
  /// Object part limit.
  static const String objectPartLimit = '/object/part_limit';

  /// 初始化对象上传。
  ///
  /// Object initiate upload.
  static const String objectInitiateUpload = '/object/initiate_multipart_upload';

  /// 对象认证Sign。
  ///
  /// Object authentication sign.
  static const String objectAuthSign = '/object/auth_sign';

  /// 对象Complete上传。
  ///
  /// Object complete upload.
  static const String objectCompleteUpload = '/object/complete_multipart_upload';

  /// 对象AccessURL 地址。
  ///
  /// Object access URL.
  static const String objectAccessURL = '/object/access_url';
}
