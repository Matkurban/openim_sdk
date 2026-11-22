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

  GroupManager({required this._context}) : super('GroupManager');

  void setGroupListener(OnGroupListener listener) {
    setPrimaryListener(listener);
  }

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

  Future<List<GroupInfo>> getJoinedGroupList() => _context.db.groups.getJoinedGroupList();

  Future<List<GroupInfo>> getJoinedGroupListPage({int offset = 0, int count = 40}) =>
      _context.db.groups.getJoinedGroupListPage(offset, count);

  Future<bool> isJoinedGroup({required String groupID}) async {
    final GroupInfo? info = await _context.db.groups.getGroupByID(groupID);
    return info != null;
  }

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

  Future<void> setGroupInfo({required GroupInfo groupInfo}) async {
    final ApiResponse resp = await _context.apis.group.setGroupInfoEx(req: groupInfo.toJson());
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    await _context.db.groups.upsertGroup(groupInfo.toJson());
  }

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

  Future<List<GroupMembersInfo>> getGroupOwnerAndAdmin({required String groupID}) {
    return _context.db.groups.getGroupOwnerAndAdmin(groupID);
  }

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

  Future<void> dismissGroup({required String groupID}) async {
    final ApiResponse resp = await _context.apis.group.dismissGroup(groupID: groupID);
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    await _context.db.groups.deleteGroup(groupID);
    await _context.db.groups.deleteGroupAllMembers(groupID);
  }

  Future<void> changeGroupMute({required String groupID, required bool mute}) async {
    final ApiResponse resp = mute
        ? await _context.apis.group.muteGroup(groupID: groupID)
        : await _context.apis.group.cancelMuteGroup(groupID: groupID);
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

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
