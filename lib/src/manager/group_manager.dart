import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../enums/group_type.dart';
import '../enums/sdk_error_code.dart';
import '../listener/group_listener.dart';
import '../models/api_response.dart';
import '../models/group_info.dart';
import '../models/openim_exception.dart';
import '../models/set_group_member_info.dart';

/// 群组与群成员管理器（继承 [BaseManager]）。
///
/// 消除原 1,309 行中的 Isolate 样板与重复同步逻辑，修复 B-24（错误码 0 替换为 `SDKErrorCode.serverInternalError`）。
final class GroupManager extends BaseManager<OnGroupListener> {
  final SdkContext _context;

  /// 创建 `GroupManager` 实例。
  ///
  /// Creates a `GroupManager` instance.
  ///
  /// - [_context] context / Context.
  GroupManager({required this._context}) : super('GroupManager');

  /// 设置群组监听器。
  ///
  /// Set group listener.
  ///
  /// - [listener] 监听器 / Listener.
  void setGroupListener(OnGroupListener listener) {
    setPrimaryListener(listener);
  }

  /// 获取群组列表信息。
  ///
  /// Get groups info.
  ///
  /// - [groupIDList] 群组ID列表 / Group ID list.
  /// - Returns: `Future<List<GroupInfo>>` 列表结果 / Resulting `Future<List<GroupInfo>>` list.
  Future<List<GroupInfo>> getGroupsInfo({required List<String> groupIDList}) async {
    if (groupIDList.isEmpty) {
      return <GroupInfo>[];
    }
    final List<GroupInfo> local = await _context.db.groups.getGroupsByIDs(groupIDList);
    if (local.length == groupIDList.length) {
      return local;
    }
    final Set<String> foundIDs = local.map<String>((GroupInfo g) => g.groupID).toSet();
    final List<String> missing = groupIDList.where((String id) => !foundIDs.contains(id)).toList();
    final ApiResponse resp = await _context.apis.group.getGroupsInfo(groupIDs: missing);
    if (resp.errCode == 0) {
      final List<dynamic> list = resp.data?['groupInfos'] as List<dynamic>? ?? const <dynamic>[];
      final List<Map<String, dynamic>> maps = list.whereType<Map<String, dynamic>>().toList();
      if (maps.isNotEmpty) {
        await _context.db.groups.batchUpsertGroups(maps);
        local.addAll(maps.map<GroupInfo>(GroupInfo.fromJson));
      }
    }
    return local;
  }

  /// 获取Joined群组列表。
  ///
  /// Get joined group list.
  ///
  /// - Returns: `Future<List<GroupInfo>>` 列表结果 / Resulting `Future<List<GroupInfo>>` list.
  Future<List<GroupInfo>> getJoinedGroupList() => _context.db.groups.getJoinedGroupList();

  /// 获取Joined群组列表分页。
  ///
  /// Get joined group list paged.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<GroupInfo>>` 列表结果 / Resulting `Future<List<GroupInfo>>` list.
  Future<List<GroupInfo>> getJoinedGroupListPage({int offset = 0, int count = 40}) =>
      _context.db.groups.getJoinedGroupListPage(offset, count);

  /// 是否Joined群组。
  ///
  /// Whether joined group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> isJoinedGroup({required String groupID}) async {
    final GroupInfo? info = await _context.db.groups.getGroupByID(groupID);
    return info != null;
  }

  /// 创建群组。
  ///
  /// Create group.
  ///
  /// - [groupInfo] 群组信息 / Group info.
  /// - [memberUserIDs] 成员用户ID 列表 / Member user i ds.
  /// - [adminUserIDs] 管理员用户ID 列表 / Administrator user i ds.
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - Returns: `Future<GroupInfo>` 结果 / Resulting `Future<GroupInfo>`.
  Future<GroupInfo> createGroup({
    required GroupInfo groupInfo,
    List<String> memberUserIDs = const <String>[],
    List<String> adminUserIDs = const <String>[],
    String? ownerUserID,
  }) async {
    if (groupInfo.groupType != null && groupInfo.groupType != GroupType.work) {
      throw OpenIMException(
        code: SDKErrorCode.wrongGroupType.code,
        message: SDKErrorCode.wrongGroupType.message,
      );
    }
    final ApiResponse resp = await _context.apis.group.createGroup(
      req: <String, dynamic>{
        'memberUserIDs': memberUserIDs,
        'adminUserIDs': adminUserIDs,
        'ownerUserID': ownerUserID ?? currentUserID,
        'groupInfo': groupInfo.toJson(),
      },
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    final Map<String, dynamic>? rawGroup =
        (resp.data?['groupInfo'] ?? resp.data) as Map<String, dynamic>?;
    final String? groupID = rawGroup?['groupID']?.toString();
    if (rawGroup == null || groupID == null || groupID.isEmpty) {
      throw OpenIMException(
        code: SDKErrorCode.serverInternalError.code,
        message: 'createGroup: missing groupID in response',
      );
    }
    await _context.db.groups.upsertGroup(rawGroup);
    return GroupInfo.fromJson(rawGroup);
  }

  /// 设置群组信息。
  ///
  /// Set group info.
  ///
  /// - [groupInfo] 群组信息 / Group info.
  Future<void> setGroupInfo({required GroupInfo groupInfo}) async {
    final ApiResponse resp = await _context.apis.group.setGroupInfoEx(req: groupInfo.toJson());
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    await _context.db.groups.upsertGroup(groupInfo.toJson());
  }

  /// 邀请用户转为群组。
  ///
  /// Invite user to group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userIDList] 用户ID列表 / User ID list.
  /// - [reason] 原因 / Reason.
  Future<void> inviteUserToGroup({
    required String groupID,
    required List<String> userIDList,
    String? reason,
  }) async {
    final ApiResponse resp = await _context.apis.group.inviteUserToGroup(
      groupID: groupID,
      invitedUserIDs: userIDList,
      reason: reason,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 踢出群组成员。
  ///
  /// Kick group member.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userIDList] 用户ID列表 / User ID list.
  /// - [reason] 原因 / Reason.
  Future<void> kickGroupMember({
    required String groupID,
    required List<String> userIDList,
    String? reason,
  }) async {
    final ApiResponse resp = await _context.apis.group.kickGroupMember(
      groupID: groupID,
      kickedUserIDs: userIDList,
      reason: reason,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    for (final String uid in userIDList) {
      await _context.db.groups.deleteGroupMember(groupID, uid);
    }
  }

  /// 获取群组成员列表信息。
  ///
  /// Get group members info.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userIDList] 用户ID列表 / User ID list.
  /// - Returns: `Future<List<GroupMembersInfo>>` 列表结果 / Resulting `Future<List<GroupMembersInfo>>` list.
  Future<List<GroupMembersInfo>> getGroupMembersInfo({
    required String groupID,
    required List<String> userIDList,
  }) async {
    if (userIDList.isEmpty) {
      return <GroupMembersInfo>[];
    }
    final List<GroupMembersInfo> local = await _context.db.groups.getGroupMembersByUserIDs(
      groupID,
      userIDList,
    );
    if (local.length == userIDList.length) {
      return local;
    }
    final ApiResponse resp = await _context.apis.group.getGroupMembersInfo(
      groupID: groupID,
      userIDs: userIDList,
    );
    if (resp.errCode != 0) {
      return local;
    }
    final List<dynamic> members = resp.data?['members'] as List<dynamic>? ?? const <dynamic>[];
    final List<Map<String, dynamic>> maps = members.whereType<Map<String, dynamic>>().toList();
    if (maps.isNotEmpty) {
      await _context.db.groups.batchUpsertGroupMembers(maps);
    }
    return maps.map<GroupMembersInfo>(GroupMembersInfo.fromJson).toList();
  }

  /// 获取群组成员列表。
  ///
  /// Get group member list.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [filter] 筛选 / Filter.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<GroupMembersInfo>>` 列表结果 / Resulting `Future<List<GroupMembersInfo>>` list.
  Future<List<GroupMembersInfo>> getGroupMemberList({
    required String groupID,
    int filter = 0,
    int offset = 0,
    int count = 40,
  }) async {
    final List<GroupMembersInfo> local = await _context.db.groups.getGroupMembersPage(
      groupID,
      offset: offset,
      count: count,
      filter: filter,
    );
    if (local.isNotEmpty || offset > 0) {
      return local;
    }
    final ApiResponse resp = await _context.apis.group.getGroupMemberList(
      groupID: groupID,
      offset: offset,
      count: count,
      filter: filter,
    );
    if (resp.errCode != 0) {
      return <GroupMembersInfo>[];
    }
    final List<dynamic> members = resp.data?['members'] as List<dynamic>? ?? const <dynamic>[];
    final List<Map<String, dynamic>> maps = members.whereType<Map<String, dynamic>>().toList();
    if (maps.isNotEmpty) {
      await _context.db.groups.batchUpsertGroupMembers(maps);
    }
    return maps.map<GroupMembersInfo>(GroupMembersInfo.fromJson).toList();
  }

  /// 获取群组群主/拥有者并管理员。
  ///
  /// Get group owner and administrator.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - Returns: `Future<List<GroupMembersInfo>>` 列表结果 / Resulting `Future<List<GroupMembersInfo>>` list.
  Future<List<GroupMembersInfo>> getGroupOwnerAndAdmin({required String groupID}) {
    return _context.db.groups.getGroupOwnerAndAdmin(groupID);
  }

  /// 搜索群组成员列表。
  ///
  /// Search group members.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [keywordList] 关键词列表 / Keyword list.
  /// - [isSearchUserID] 是否搜索用户ID / Whether search user ID.
  /// - [isSearchMemberNickname] 是否搜索成员昵称 / Whether search member nickname.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<GroupMembersInfo>>` 列表结果 / Resulting `Future<List<GroupMembersInfo>>` list.
  Future<List<GroupMembersInfo>> searchGroupMembers({
    required String groupID,
    List<String> keywordList = const <String>[],
    bool isSearchUserID = false,
    bool isSearchMemberNickname = false,
    int offset = 0,
    int count = 40,
  }) async {
    final String keyword = keywordList.isNotEmpty ? keywordList.first : '';
    if (keyword.isEmpty) {
      return <GroupMembersInfo>[];
    }
    return _context.db.groups.searchGroupMembers(
      groupID,
      keyword,
      searchUserID: isSearchUserID,
      searchNickname: isSearchMemberNickname,
      offset: offset,
      count: count,
    );
  }

  /// 设置群组成员信息。
  ///
  /// Set group member info.
  ///
  /// - [groupMembersInfo] 群组成员列表信息 / Group members info.
  Future<void> setGroupMemberInfo({required SetGroupMemberInfo groupMembersInfo}) async {
    final ApiResponse resp = await _context.apis.group.setGroupMemberInfo(
      req: groupMembersInfo.toJson(),
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    final Map<String, dynamic> updates = <String, dynamic>{
      if (groupMembersInfo.nickname != null) 'nickname': groupMembersInfo.nickname,
      if (groupMembersInfo.faceURL != null) 'faceURL': groupMembersInfo.faceURL,
      if (groupMembersInfo.roleLevel != null) 'roleLevel': groupMembersInfo.roleLevel,
      if (groupMembersInfo.ex != null) 'ex': groupMembersInfo.ex,
    };
    if (updates.isNotEmpty) {
      await _context.db.groups.updateGroupMember(
        groupMembersInfo.groupID,
        groupMembersInfo.userID,
        updates,
      );
    }
  }

  /// 转让群组群主/拥有者。
  ///
  /// Transfer group owner.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  Future<void> transferGroupOwner({required String groupID, required String userID}) async {
    final ApiResponse resp = await _context.apis.group.transferGroup(
      groupID: groupID,
      oldOwnerUserID: currentUserID,
      newOwnerUserID: userID,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 加入群组。
  ///
  /// Join group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [reason] 原因 / Reason.
  /// - [joinSource] 加入来源 / Join source.
  /// - [ex] 扩展字段 / Extension.
  Future<void> joinGroup({
    required String groupID,
    String? reason,
    int joinSource = 3,
    String? ex,
  }) async {
    final ApiResponse resp = await _context.apis.group.joinGroup(
      groupID: groupID,
      reqMessage: reason,
      joinSource: joinSource,
      ex: ex,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 退出群组。
  ///
  /// Quit group.
  ///
  /// - [groupID] 群组ID / Group ID.
  Future<void> quitGroup({required String groupID}) async {
    final ApiResponse resp = await _context.apis.group.quitGroup(
      userID: currentUserID,
      groupID: groupID,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    await _context.db.groups.deleteGroup(groupID);
    await _context.db.groups.deleteGroupAllMembers(groupID);
  }

  /// 解散群组。
  ///
  /// Dismiss group.
  ///
  /// - [groupID] 群组ID / Group ID.
  Future<void> dismissGroup({required String groupID}) async {
    final ApiResponse resp = await _context.apis.group.dismissGroup(groupID: groupID);
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    await _context.db.groups.deleteGroup(groupID);
    await _context.db.groups.deleteGroupAllMembers(groupID);
  }

  /// 变更群组禁言。
  ///
  /// Change group mute.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [mute] 禁言 / Mute.
  Future<void> changeGroupMute({required String groupID, required bool mute}) async {
    final ApiResponse resp = mute
        ? await _context.apis.group.muteGroup(groupID: groupID)
        : await _context.apis.group.cancelMuteGroup(groupID: groupID);
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 变更群组成员禁言。
  ///
  /// Change group member mute.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - [seconds] 秒数 / Seconds.
  Future<void> changeGroupMemberMute({
    required String groupID,
    required String userID,
    int seconds = 0,
  }) async {
    final ApiResponse resp = seconds > 0
        ? await _context.apis.group.muteGroupMember(
            groupID: groupID,
            userID: userID,
            mutedSeconds: seconds,
          )
        : await _context.apis.group.cancelMuteGroupMember(groupID: groupID, userID: userID);
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 获取群组申请列表作为接收方。
  ///
  /// Get group application list as recipient.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<List<GroupApplicationInfo>>` 列表结果 / Resulting `Future<List<GroupApplicationInfo>>` list.
  Future<List<GroupApplicationInfo>> getGroupApplicationListAsRecipient({
    GetGroupApplicationListAsRecipientReq? req,
  }) async {
    final ApiResponse resp = await _context.apis.group.getRecvGroupApplicationList(
      userID: currentUserID,
      offset: req?.offset ?? 0,
      count: req?.count ?? 100,
    );
    if (resp.errCode != 0) {
      return <GroupApplicationInfo>[];
    }
    final List<dynamic> list = resp.data?['groupRequests'] as List<dynamic>? ?? const <dynamic>[];
    return list
        .whereType<Map<String, dynamic>>()
        .map<GroupApplicationInfo>(GroupApplicationInfo.fromJson)
        .toList();
  }

  /// 获取群组申请列表作为申请方。
  ///
  /// Get group application list as applicant.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<List<GroupApplicationInfo>>` 列表结果 / Resulting `Future<List<GroupApplicationInfo>>` list.
  Future<List<GroupApplicationInfo>> getGroupApplicationListAsApplicant({
    GetGroupApplicationListAsApplicantReq? req,
  }) async {
    final ApiResponse resp = await _context.apis.group.getSendGroupApplicationList(
      userID: currentUserID,
      offset: req?.offset ?? 0,
      count: req?.count ?? 100,
    );
    if (resp.errCode != 0) {
      return <GroupApplicationInfo>[];
    }
    final List<dynamic> list = resp.data?['groupRequests'] as List<dynamic>? ?? const <dynamic>[];
    return list
        .whereType<Map<String, dynamic>>()
        .map<GroupApplicationInfo>(GroupApplicationInfo.fromJson)
        .toList();
  }

  /// 接受群组申请。
  ///
  /// Accept group application.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - [handleMsg] 处理消息 / Handle message.
  Future<void> acceptGroupApplication({
    required String groupID,
    required String userID,
    String? handleMsg,
  }) async {
    final ApiResponse resp = await _context.apis.group.groupApplicationResponse(
      groupID: groupID,
      fromUserID: userID,
      handledMsg: handleMsg ?? '',
      handleResult: 1,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 拒绝群组申请。
  ///
  /// Refuse group application.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - [handleMsg] 处理消息 / Handle message.
  Future<void> refuseGroupApplication({
    required String groupID,
    required String userID,
    String? handleMsg,
  }) async {
    final ApiResponse resp = await _context.apis.group.groupApplicationResponse(
      groupID: groupID,
      fromUserID: userID,
      handledMsg: handleMsg ?? '',
      handleResult: -1,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 获取群组申请未处理数量。
  ///
  /// Get group application unhandled count.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: 整数结果 / Integer result.
  Future<int> getGroupApplicationUnhandledCount(GetGroupApplicationUnhandledCountReq req) async {
    final ApiResponse resp = await _context.apis.group.getGroupApplicationUnhandledCount(
      userID: currentUserID,
      time: req.time,
    );
    if (resp.errCode == 0) {
      return (resp.data?['count'] as num?)?.toInt() ?? 0;
    }
    return _context.db.groups.getGroupRequestUnhandledCount();
  }

  /// 搜索群组列表。
  ///
  /// Search groups.
  ///
  /// - [keywordList] 关键词列表 / Keyword list.
  /// - [isSearchGroupID] 是否搜索群组ID / Whether search group ID.
  /// - [isSearchGroupName] 是否搜索群组名称 / Whether search group name.
  /// - Returns: `Future<List<GroupInfo>>` 列表结果 / Resulting `Future<List<GroupInfo>>` list.
  Future<List<GroupInfo>> searchGroups({
    List<String> keywordList = const <String>[],
    bool isSearchGroupID = false,
    bool isSearchGroupName = false,
  }) async {
    final String keyword = keywordList.isNotEmpty ? keywordList.first : '';
    if (keyword.isEmpty) {
      return <GroupInfo>[];
    }
    return _context.db.groups.searchGroups(
      keyword,
      searchGroupID: isSearchGroupID,
      searchGroupName: isSearchGroupName,
    );
  }

  /// 获取群组成员列表按加入时间戳。
  ///
  /// Get group member list by join timestamp.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - [joinTimeBegin] 加入时间戳Begin / Join timestamp begin.
  /// - [joinTimeEnd] 加入时间戳结束 / Join timestamp end.
  /// - [filterUserIDList] 筛选用户ID列表 / Filter user ID list.
  /// - Returns: `Future<List<GroupMembersInfo>>` 列表结果 / Resulting `Future<List<GroupMembersInfo>>` list.
  Future<List<GroupMembersInfo>> getGroupMemberListByJoinTime({
    required String groupID,
    int offset = 0,
    int count = 40,
    int joinTimeBegin = 0,
    int joinTimeEnd = 0,
    List<String> filterUserIDList = const <String>[],
  }) async {
    final List<GroupMembersInfo> all = await _context.db.groups.getGroupMembers(groupID);
    final Set<String> excluded = filterUserIDList.toSet();
    final List<GroupMembersInfo> filtered = all.where((GroupMembersInfo m) {
      if (m.userID != null && excluded.contains(m.userID)) {
        return false;
      }
      final int jt = m.joinTime ?? 0;
      if (joinTimeBegin > 0 && jt < joinTimeBegin) {
        return false;
      }
      if (joinTimeEnd > 0 && jt > joinTimeEnd) {
        return false;
      }
      return true;
    }).toList();
    if (offset >= filtered.length) {
      return <GroupMembersInfo>[];
    }
    final int safeCount = count <= 0 ? filtered.length : count;
    final int end = (offset + safeCount).clamp(offset, filtered.length);
    return filtered.sublist(offset, end);
  }

  /// 获取用户列表内群组。
  ///
  /// Get users in group.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userIDList] 用户ID列表 / User ID list.
  /// - Returns: `Future<List<String>>` 列表结果 / Resulting `Future<List<String>>` list.
  Future<List<String>> getUsersInGroup({
    required String groupID,
    required List<String> userIDList,
  }) async {
    if (userIDList.isEmpty) {
      return <String>[];
    }
    final List<GroupMembersInfo> members = await _context.db.groups.getGroupMembersByUserIDs(
      groupID,
      userIDList,
    );
    return members.map<String?>((GroupMembersInfo m) => m.userID).whereType<String>().toList();
  }
}
