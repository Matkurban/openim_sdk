import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 群组与群成员 API 客户端。
final class GroupApi extends BaseApiClient {
  /// 创建 `GroupApi` 实例。
  ///
  /// Creates a `GroupApi` instance.
  ///
  /// - [httpClient] HTTP客户端 / HTTP client.
  GroupApi({required super.httpClient}) : super(name: 'GroupApi');

  /// 创建群组。
  ///
  /// Create group.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> createGroup({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.createGroup, data: req);
  }

  /// 设置群组信息扩展字段。
  ///
  /// Set group info extension.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> setGroupInfoEx({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.setGroupInfoEx, data: req);
  }

  /// 加入群组。
  ///
  /// Join group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [reqMessage] 请求参数消息 / Request message.
  /// - [joinSource] 加入来源 / Join source.
  /// - [inviterUserID] 邀请者用户ID / Inviter user ID.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> joinGroup({
    required String groupID,
    String? reqMessage,
    int joinSource = 3,
    String? inviterUserID,
    String? ex,
  }) {
    return postIm(
      ImApiUrl.joinGroup,
      data: <String, dynamic>{
        'groupID': groupID,
        'reqMessage': reqMessage ?? '',
        'joinSource': joinSource,
        'inviterUserID': inviterUserID ?? '',
        'ex': ex ?? '',
      },
    );
  }

  /// 退出群组。
  ///
  /// Quit group.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> quitGroup({required String userID, required String groupID}) {
    return postIm(
      ImApiUrl.quitGroup,
      data: <String, dynamic>{'userID': userID, 'groupID': groupID},
    );
  }

  /// 获取群组列表信息。
  ///
  /// Get groups info.
  ///
  /// - [groupIDs] 群组ID 列表 / Group i ds.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getGroupsInfo({required List<String> groupIDs}) {
    return postIm(ImApiUrl.getGroupsInfo, data: <String, dynamic>{'groupIDs': groupIDs});
  }

  /// 获取群组成员列表。
  ///
  /// Get group member list.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - [filter] 筛选 / Filter.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getGroupMemberList({
    required String groupID,
    int offset = 0,
    int count = 100,
    int filter = 0,
  }) {
    return postIm(
      ImApiUrl.getGroupMemberList,
      data: <String, dynamic>{
        'groupID': groupID,
        'filter': filter,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  /// 获取群组成员列表信息。
  ///
  /// Get group members info.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userIDs] 用户ID 列表 / User i ds.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getGroupMembersInfo({
    required String groupID,
    required List<String> userIDs,
  }) {
    return postIm(
      ImApiUrl.getGroupMembersInfo,
      data: <String, dynamic>{'groupID': groupID, 'userIDs': userIDs},
    );
  }

  /// 邀请用户转为群组。
  ///
  /// Invite user to group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [invitedUserIDs] 被邀请用户ID 列表 / Invited user i ds.
  /// - [reason] 原因 / Reason.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> inviteUserToGroup({
    required String groupID,
    required List<String> invitedUserIDs,
    String? reason,
  }) {
    return postIm(
      ImApiUrl.inviteUserToGroup,
      data: <String, dynamic>{
        'groupID': groupID,
        'invitedUserIDs': invitedUserIDs,
        'reason': reason ?? '',
      },
    );
  }

  /// 获取Joined群组列表。
  ///
  /// Get joined group list.
  ///
  /// - [fromUserID] 从用户ID / From user ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getJoinedGroupList({
    required String fromUserID,
    int offset = 0,
    int count = 100,
  }) {
    return postIm(
      ImApiUrl.getJoinedGroupList,
      data: <String, dynamic>{
        'fromUserID': fromUserID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  /// 获取增量加入群组。
  ///
  /// Get incremental join group.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getIncrementalJoinGroup({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.getIncrementalJoinGroup, data: req);
  }

  /// 获取全量加入群组ID 列表。
  ///
  /// Get full join group i ds.
  ///
  /// - [userID] 用户ID / User ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getFullJoinGroupIDs({required String userID}) {
    return postIm(ImApiUrl.getFullJoinGroupIDs, data: <String, dynamic>{'userID': userID});
  }

  /// 踢出群组成员。
  ///
  /// Kick group member.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [kickedUserIDs] 被踢用户ID 列表 / Kicked user i ds.
  /// - [reason] 原因 / Reason.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> kickGroupMember({
    required String groupID,
    required List<String> kickedUserIDs,
    String? reason,
  }) {
    return postIm(
      ImApiUrl.kickGroup,
      data: <String, dynamic>{
        'groupID': groupID,
        'kickedUserIDs': kickedUserIDs,
        'reason': reason ?? '',
      },
    );
  }

  /// 转让群组。
  ///
  /// Transfer group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [oldOwnerUserID] old群主/拥有者用户ID / Old owner user ID.
  /// - [newOwnerUserID] new群主/拥有者用户ID / New owner user ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> transferGroup({
    required String groupID,
    required String oldOwnerUserID,
    required String newOwnerUserID,
  }) {
    return postIm(
      ImApiUrl.transferGroup,
      data: <String, dynamic>{
        'groupID': groupID,
        'oldOwnerUserID': oldOwnerUserID,
        'newOwnerUserID': newOwnerUserID,
      },
    );
  }

  /// 获取接收群组申请列表。
  ///
  /// Get receive group application list.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getRecvGroupApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) {
    return postIm(
      ImApiUrl.getRecvGroupApplicationList,
      data: <String, dynamic>{
        'fromUserID': userID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  /// 获取发送群组申请列表。
  ///
  /// Get send group application list.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getSendGroupApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) {
    return postIm(
      ImApiUrl.getSendGroupApplicationList,
      data: <String, dynamic>{
        'userID': userID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  /// 获取群组申请未处理数量。
  ///
  /// Get group application unhandled count.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [time] 时间戳 / Timestamp.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getGroupApplicationUnhandledCount({required String userID, int time = 0}) {
    return postIm(
      ImApiUrl.getGroupApplicationUnhandledCount,
      data: <String, dynamic>{'userID': userID, 'time': time},
    );
  }

  /// 群组申请响应。
  ///
  /// Group application response.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [fromUserID] 从用户ID / From user ID.
  /// - [handledMsg] handled消息 / Handled message.
  /// - [handleResult] 处理结果 / Handle result.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> groupApplicationResponse({
    required String groupID,
    required String fromUserID,
    required String handledMsg,
    required int handleResult,
  }) {
    return postIm(
      ImApiUrl.groupApplicationResponse,
      data: <String, dynamic>{
        'groupID': groupID,
        'fromUserID': fromUserID,
        'handledMsg': handledMsg,
        'handleResult': handleResult,
      },
    );
  }

  /// 解散群组。
  ///
  /// Dismiss group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> dismissGroup({required String groupID}) {
    return postIm(ImApiUrl.dismissGroup, data: <String, dynamic>{'groupID': groupID});
  }

  /// 禁言群组成员。
  ///
  /// Mute group member.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - [mutedSeconds] 被禁言秒数 / Muted seconds.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> muteGroupMember({
    required String groupID,
    required String userID,
    required int mutedSeconds,
  }) {
    return postIm(
      ImApiUrl.muteGroupMember,
      data: <String, dynamic>{'groupID': groupID, 'userID': userID, 'mutedSeconds': mutedSeconds},
    );
  }

  /// 取消禁言群组成员。
  ///
  /// Cancel mute group member.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> cancelMuteGroupMember({required String groupID, required String userID}) {
    return postIm(
      ImApiUrl.cancelMuteGroupMember,
      data: <String, dynamic>{'groupID': groupID, 'userID': userID},
    );
  }

  /// 禁言群组。
  ///
  /// Mute group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> muteGroup({required String groupID}) {
    return postIm(ImApiUrl.muteGroup, data: <String, dynamic>{'groupID': groupID});
  }

  /// 取消禁言群组。
  ///
  /// Cancel mute group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> cancelMuteGroup({required String groupID}) {
    return postIm(ImApiUrl.cancelMuteGroup, data: <String, dynamic>{'groupID': groupID});
  }

  /// 设置群组成员信息。
  ///
  /// Set group member info.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> setGroupMemberInfo({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.setGroupMemberInfo, data: req);
  }
}
