/// Chat 业务服务端 API 路由（注册/登录/验证码/用户搜索等）
sealed class ChatApiUrl {
  static const String login = '/account/login';
  static const String register = '/account/register';
  static const String captcha = '/account/code/send';

  // ---- User ----
  static const String searchUserFull = '/user/search/full';
  static const String getUserFull = '/user/find/full';
  static const String updateUser = '/user/update';
  static const String getRtcToken = '/user/rtc/get_rtc_token';

  // ---- Friend ----
  static const String searchFriend = '/friend/search';

  // ---- Meeting / Call ----
  static const String createMeeting = '/meeting/create';
  static const String joinMeeting = '/meeting/join';
  static const String leaveMeeting = '/meeting/leave';
  static const String endMeeting = '/meeting/end';
  static const String getMeeting = '/meeting/get';
  static const String getActiveMeeting = '/meeting/get_active';

  // ---- Login Password ----
  static const String changePassword = '/account/password/change';
  static const String resetPassword = '/account/password/reset';

  // ---- Payment Password ----
  static const String setPaymentPassword = '/user/payment_password/set';
  static const String changePaymentPassword = '/user/payment_password/change';
  static const String verifyPaymentPassword = '/user/payment_password/verify';
  static const String checkPaymentPasswordSet = '/user/payment_password/check';
  static const String resetPaymentPassword = '/user/payment_password/reset';
}

/// OpenIM 核心服务端 API 路由（对应 openim-server）
sealed class ImApiUrl {
  // ---- Auth ----
  static const String parseToken = '/auth/parse_token';
  static const String getUserToken = '/auth/get_user_token';

  // ---- User ----
  static const String getUsersInfo = '/user/get_users_info';
  static const String updateUserInfo = '/user/update_user_info';
  static const String updateUserInfoEx = '/user/update_user_info_ex';
  static const String getUserClientConfig = '/user/get_user_client_config';
  static const String subscribeUsersStatus = '/user/subscribe_users_status';
  static const String getSubscribeUsersStatus = '/user/get_subscribe_users_status';
  static const String getUserStatus = '/user/get_users_status';

  // ---- Friend ----
  static const String addFriend = '/friend/add_friend';
  static const String deleteFriend = '/friend/delete_friend';
  static const String getRecvFriendApplicationList = '/friend/get_friend_apply_list';
  static const String getSelfFriendApplicationList = '/friend/get_self_friend_apply_list';
  static const String getSelfUnhandledApplyCount = '/friend/get_self_unhandled_apply_count';
  static const String getDesignatedFriendsApply = '/friend/get_designated_friend_apply';
  static const String getFriendList = '/friend/get_friend_list';
  static const String getDesignatedFriends = '/friend/get_designated_friends';
  static const String addFriendResponse = '/friend/add_friend_response';
  static const String updateFriends = '/friend/update_friends';
  static const String getIncrementalFriends = '/friend/get_incremental_friends';
  static const String getFullFriendUserIDs = '/friend/get_full_friend_user_ids';
  static const String addBlack = '/friend/add_black';
  static const String removeBlack = '/friend/remove_black';
  static const String getBlackList = '/friend/get_black_list';

  // ---- Group ----
  static const String createGroup = '/group/create_group';
  static const String setGroupInfoEx = '/group/set_group_info_ex';
  static const String joinGroup = '/group/join_group';
  static const String quitGroup = '/group/quit_group';
  static const String getGroupsInfo = '/group/get_groups_info';
  static const String getGroupMemberList = '/group/get_group_member_list';
  static const String getGroupMembersInfo = '/group/get_group_members_info';
  static const String inviteUserToGroup = '/group/invite_user_to_group';
  static const String getJoinedGroupList = '/group/get_joined_group_list';
  static const String kickGroup = '/group/kick_group';
  static const String transferGroup = '/group/transfer_group';
  static const String getRecvGroupApplicationList = '/group/get_recv_group_applicationList';
  static const String getSendGroupApplicationList = '/group/get_user_req_group_applicationList';
  static const String getGroupApplicationUnhandledCount =
      '/group/get_group_application_unhandled_count';
  static const String groupApplicationResponse = '/group/group_application_response';
  static const String dismissGroup = '/group/dismiss_group';
  static const String muteGroupMember = '/group/mute_group_member';
  static const String cancelMuteGroupMember = '/group/cancel_mute_group_member';
  static const String muteGroup = '/group/mute_group';
  static const String cancelMuteGroup = '/group/cancel_mute_group';
  static const String setGroupMemberInfo = '/group/set_group_member_info';
  static const String getIncrementalJoinGroup = '/group/get_incremental_join_groups';
  static const String getFullJoinGroupIDs = '/group/get_full_join_group_ids';

  // ---- Message ----
  static const String sendMsg = '/msg/send_msg';
  static const String revokeMsg = '/msg/revoke_msg';
  static const String markMsgsAsRead = '/msg/mark_msgs_as_read';
  static const String markConversationAsRead = '/msg/mark_conversation_as_read';
  static const String deleteMsgs = '/msg/delete_msgs';
  static const String clearConversationMsg = '/msg/clear_conversation_msg';
  static const String clearAllMsg = '/msg/user_clear_all_msg';
  static const String getConversationsHasReadAndMaxSeq =
      '/msg/get_conversations_has_read_and_max_seq';
  static const String pullMsgBySeqs = '/msg/pull_msg_by_seq';
  static const String setConversationHasReadSeq = '/msg/set_conversation_has_read_seq';
  static const String getServerTime = '/msg/get_server_time';

  // ---- Conversation ----
  static const String getConversations = '/conversation/get_conversations';
  static const String getAllConversations = '/conversation/get_all_conversations';
  static const String setConversations = '/conversation/set_conversations';
  static const String getIncrementalConversation = '/conversation/get_incremental_conversations';
  static const String getFullConversationIDs = '/conversation/get_full_conversation_ids';
  static const String getOwnerConversation = '/conversation/get_owner_conversation';

  // ---- Third ----
  static const String fcmUpdateToken = '/third/fcm_update_token';
  static const String setAppBadge = '/third/set_app_badge';
  static const String uploadLogs = '/third/logs/upload';

  // ---- Object Storage ----
  static const String objectPartLimit = '/object/part_limit';
  static const String objectInitiateUpload = '/object/initiate_multipart_upload';
  static const String objectAuthSign = '/object/auth_sign';
  static const String objectCompleteUpload = '/object/complete_multipart_upload';
  static const String objectAccessURL = '/object/access_url';
}
