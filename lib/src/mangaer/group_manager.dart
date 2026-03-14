import 'package:meta/meta.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/services/database_service.dart';

class GroupManager {
  static final Logger _log = Logger('GroupManager');

  final GetIt _getIt = GetIt.instance;

  DatabaseService get _database {
    return _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  ImApiService get _api {
    return _getIt.get<ImApiService>(instanceName: InstanceName.imApiService);
  }

  OnGroupListener? listener;

  late String _currentUserID;

  void setGroupListener(OnGroupListener listener) {
    this.listener = listener;
  }

  @internal
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  /// 查询群组信息
  /// [groupIDList] 群组ID列表
  Future<List<GroupInfo>> getGroupsInfo({required List<String> groupIDList}) async {
    _log.info('getGroupsInfo: groupIDList=$groupIDList');
    if (groupIDList.isEmpty) return [];
    return _database.getGroupsByIDs(groupIDList);
  }

  /// 获取已加入的群组列表
  Future<List<GroupInfo>> getJoinedGroupList() async {
    _log.info('getJoinedGroupList');
    return _database.getJoinedGroupList();
  }

  /// 分页获取已加入的群组列表
  /// [offset] 起始索引
  /// [count] 每页数量
  Future<List<GroupInfo>> getJoinedGroupListPage({int offset = 0, int count = 40}) async {
    _log.info('getJoinedGroupListPage: offset=$offset, count=$count');
    return _database.getJoinedGroupListPage(offset, count);
  }

  /// 检查是否已加入群组
  /// [groupID] 群组ID
  Future<bool> isJoinedGroup({required String groupID}) async {
    _log.info('isJoinedGroup: groupID=$groupID');
    final data = await _database.getGroupByID(groupID);
    return data != null;
  }

  /// 创建群组
  /// [groupInfo] 群组基本信息
  /// [memberUserIDs] 初始成员用户ID列表
  /// [adminUserIDs] 管理员用户ID列表
  /// [ownerUserID] 群主用户ID
  Future<GroupInfo> createGroup({
    required GroupInfo groupInfo,
    List<String> memberUserIDs = const [],
    List<String> adminUserIDs = const [],
    String? ownerUserID,
  }) async {
    _log.info(
      'createGroup: groupID=${groupInfo.groupID}, groupName=${groupInfo.groupName}, memberCount=${memberUserIDs.length}, adminCount=${adminUserIDs.length}, ownerUserID=$ownerUserID',
    );
    final now = DateTime.now().millisecondsSinceEpoch;
    final gid = groupInfo.groupID.isNotEmpty ? groupInfo.groupID : 'g_${now}_$_currentUserID';

    final data = {
      'groupID': gid,
      'groupName': groupInfo.groupName,
      'notification': groupInfo.notification,
      'introduction': groupInfo.introduction,
      'faceURL': groupInfo.faceURL,
      'ownerUserID': ownerUserID ?? _currentUserID,
      'createTime': now,
      'memberCount': memberUserIDs.length + adminUserIDs.length + 1,
      'status': GroupStatus.normal.value,
      'creatorUserID': _currentUserID,
      'groupType': groupInfo.groupType?.value ?? GroupType.work.value,
      'ex': groupInfo.ex,
      'needVerification': groupInfo.needVerification,
      'lookMemberInfo': groupInfo.lookMemberInfo,
      'applyMemberFriend': groupInfo.applyMemberFriend,
      'notificationUpdateTime': now,
      'notificationUserID': _currentUserID,
    };
    await _database.upsertGroup(data);

    // 批量添加群成员（群主 + 管理员 + 普通成员）
    final memberBatch = <Map<String, dynamic>>[];
    memberBatch.add({
      'groupID': gid,
      'userID': ownerUserID ?? _currentUserID,
      'roleLevel': GroupRoleLevel.owner.value,
      'joinTime': now,
      'joinSource': JoinSource.invited.value,
    });
    for (final uid in adminUserIDs) {
      memberBatch.add({
        'groupID': gid,
        'userID': uid,
        'roleLevel': GroupRoleLevel.admin.value,
        'joinTime': now,
        'joinSource': JoinSource.invited.value,
      });
    }
    for (final uid in memberUserIDs) {
      memberBatch.add({
        'groupID': gid,
        'userID': uid,
        'roleLevel': GroupRoleLevel.member.value,
        'joinTime': now,
        'joinSource': JoinSource.invited.value,
      });
    }
    await _database.batchUpsertGroupMembers(memberBatch);

    _log.info('群组已创建: $gid');

    final createdData = await _database.getGroupByID(gid);
    final result = createdData ?? GroupInfo(groupID: gid);
    listener?.joinedGroupAdded(result);
    return result;
  }

  /// 修改群组信息
  /// [groupInfo] 群组信息（只更新非null字段）
  Future<void> setGroupInfo({required GroupInfo groupInfo}) async {
    _log.info('setGroupInfo: groupID=${groupInfo.groupID}, groupName=${groupInfo.groupName}');
    final updateData = groupInfo.toJson()..removeWhere((_, v) => v == null);
    final existing = await _database.getGroupByID(groupInfo.groupID);
    if (existing != null) {
      await _database.updateGroup(groupInfo.groupID, updateData);
    }
    _log.info('群组信息已更新: ${groupInfo.groupID}');

    listener?.groupInfoChanged(groupInfo);
    // 5. 同步到服务器
    final resp = await _api.setGroupInfoEx(req: groupInfo.toJson());
    if (resp.errCode != 0) {
      _log.warning('同步群组信息失败: ${resp.errMsg}');
    }
  }

  /// 邀请用户入群（无需审批直接加入）
  /// [groupID] 群组ID
  /// [userIDList] 用户ID列表
  /// [reason] 邀请原因
  Future<void> inviteUserToGroup({
    required String groupID,
    required List<String> userIDList,
    String? reason,
  }) async {
    _log.info('inviteUserToGroup: groupID=$groupID, userIDList=$userIDList, reason=$reason');
    final now = DateTime.now().millisecondsSinceEpoch;
    final memberBatch = <Map<String, dynamic>>[];
    for (final uid in userIDList) {
      memberBatch.add({
        'groupID': groupID,
        'userID': uid,
        'roleLevel': GroupRoleLevel.member.value,
        'joinTime': now,
        'joinSource': JoinSource.invited.value,
      });
    }
    await _database.batchUpsertGroupMembers(memberBatch);
    for (final uid in userIDList) {
      listener?.groupMemberAdded(
        GroupMembersInfo(
          groupID: groupID,
          userID: uid,
          joinTime: now,
          roleLevel: GroupRoleLevel.member,
        ),
      );
    }
    _log.info('已邀请 ${userIDList.length} 个用户加入群 $groupID');

    final resp = await _api.inviteUserToGroup(
      groupID: groupID,
      invitedUserIDs: userIDList,
      reason: reason,
    );
    if (resp.errCode != 0) {
      _log.warning('邀请用户入群失败: ${resp.errMsg}');
    }
  }

  /// 踢出群成员
  /// [groupID] 群组ID
  /// [userIDList] 用户ID列表
  /// [reason] 踢出原因
  Future<void> kickGroupMember({
    required String groupID,
    required List<String> userIDList,
    String? reason,
  }) async {
    _log.info('kickGroupMember: groupID=$groupID, userIDList=$userIDList, reason=$reason');
    for (final uid in userIDList) {
      await _database.deleteGroupMember(groupID, uid);
      listener?.groupMemberDeleted(GroupMembersInfo(groupID: groupID, userID: uid));
    }
    _log.info('已从群 $groupID 踢出 ${userIDList.length} 个成员');

    final resp = await _api.kickGroupMember(
      groupID: groupID,
      kickedUserIDs: userIDList,
      reason: reason,
    );
    if (resp.errCode != 0) {
      _log.warning('踢出群成员失败: ${resp.errMsg}');
    }
  }

  /// 查询群成员信息
  /// [groupID] 群组ID
  /// [userIDList] 用户ID列表
  Future<List<GroupMembersInfo>> getGroupMembersInfo({
    required String groupID,
    required List<String> userIDList,
  }) async {
    _log.info('getGroupMembersInfo: groupID=$groupID, userIDList=$userIDList');
    if (userIDList.isEmpty) return [];
    return _database.getGroupMembersByUserIDs(groupID, userIDList);
  }

  /// 分页获取群成员列表
  /// [groupID] 群组ID
  /// [filter] 成员过滤（0:全部，1:群主，2:管理员，3:普通成员，4:管理员+普通成员，5:群主+管理员）
  /// [offset] 起始索引
  /// [count] 数量
  Future<List<GroupMembersInfo>> getGroupMemberList({
    required String groupID,
    int filter = 0,
    int offset = 0,
    int count = 40,
  }) async {
    _log.info('getGroupMemberList: groupID=$groupID, filter=$filter, offset=$offset, count=$count');
    return _database.getGroupMembersPage(groupID, filter: filter, offset: offset, count: count);
  }

  /// 获取群主和管理员列表
  /// [groupID] 群组ID
  Future<List<GroupMembersInfo>> getGroupOwnerAndAdmin({required String groupID}) async {
    _log.info('getGroupOwnerAndAdmin: groupID=$groupID');
    return _database.getGroupOwnerAndAdmin(groupID);
  }

  /// 搜索群成员
  /// [groupID] 群组ID
  /// [keywordList] 搜索关键字
  /// [isSearchUserID] 是否搜索成员ID
  /// [isSearchMemberNickname] 是否搜索成员昵称
  /// [offset] 起始索引
  /// [count] 数量
  Future<List<GroupMembersInfo>> searchGroupMembers({
    required String groupID,
    List<String> keywordList = const [],
    bool isSearchUserID = false,
    bool isSearchMemberNickname = false,
    int offset = 0,
    int count = 40,
  }) async {
    _log.info(
      'searchGroupMembers: groupID=$groupID, keywordList=$keywordList, isSearchUserID=$isSearchUserID, isSearchMemberNickname=$isSearchMemberNickname, offset=$offset, count=$count',
    );
    final keyword = keywordList.isNotEmpty ? keywordList.first : '';
    if (keyword.isEmpty) return [];

    return _database.searchGroupMembers(
      groupID,
      keyword,
      searchUserID: isSearchUserID,
      searchNickname: isSearchMemberNickname,
      offset: offset,
      count: count,
    );
  }

  /// 修改群成员信息
  /// [groupMembersInfo] 群成员信息
  Future<void> setGroupMemberInfo({required SetGroupMemberInfo groupMembersInfo}) async {
    _log.info(
      'setGroupMemberInfo: groupID=${groupMembersInfo.groupID}, userID=${groupMembersInfo.userID}, nickname=${groupMembersInfo.nickname}, roleLevel=${groupMembersInfo.roleLevel}',
    );
    final gid = groupMembersInfo.groupID;
    final uid = groupMembersInfo.userID;
    if (gid.isEmpty || uid.isEmpty) return;

    final updateData = <String, dynamic>{};
    if (groupMembersInfo.nickname != null) updateData['nickname'] = groupMembersInfo.nickname;
    if (groupMembersInfo.faceURL != null) updateData['faceURL'] = groupMembersInfo.faceURL;
    if (groupMembersInfo.roleLevel != null) updateData['roleLevel'] = groupMembersInfo.roleLevel;
    if (groupMembersInfo.ex != null) updateData['ex'] = groupMembersInfo.ex;

    if (updateData.isNotEmpty) {
      await _database.updateGroupMember(gid, uid, updateData);
    }
    _log.info('群成员信息已更新: group=$gid, user=$uid');

    final updatedMemberInfo = await _database.getGroupMember(gid, uid);
    if (updatedMemberInfo != null) {
      listener?.groupMemberInfoChanged(updatedMemberInfo);
    }

    final resp = await _api.setGroupMemberInfo(req: groupMembersInfo.toJson());
    if (resp.errCode != 0) {
      _log.warning('同步群成员信息失败: ${resp.errMsg}');
    }
  }

  /// 转让群主
  /// [groupID] 群组ID
  /// [userID] 新群主用户ID
  Future<void> transferGroupOwner({required String groupID, required String userID}) async {
    _log.info('transferGroupOwner: groupID=$groupID, userID=$userID');
    // 获取当前群主
    String? oldOwnerID;
    final ownerList = await _database.getGroupOwnerAndAdmin(groupID);
    for (final member in ownerList) {
      if (member.roleLevel == GroupRoleLevel.owner) {
        oldOwnerID = member.userID;
        break;
      }
    }

    // 批量更新角色：旧群主降级 + 新群主升级
    if (oldOwnerID != null) {
      await _database.updateGroupMember(groupID, oldOwnerID, {
        'roleLevel': GroupRoleLevel.member.value,
      });
    }
    await _database.updateGroupMember(groupID, userID, {'roleLevel': GroupRoleLevel.owner.value});

    _log.info('群主已转让: group=$groupID, newOwner=$userID, oldOwner=$oldOwnerID');

    // 批量获取更新后的信息并触发回调
    final updatedGroupInfo = await _database.getGroupByID(groupID);
    if (updatedGroupInfo != null) {
      listener?.groupInfoChanged(updatedGroupInfo);
    }
    final memberIDs = [?oldOwnerID, userID];
    final updatedMembers = await _database.getGroupMembersByUserIDs(groupID, memberIDs);
    for (final m in updatedMembers) {
      listener?.groupMemberInfoChanged(m);
    }

    if (oldOwnerID != null) {
      final resp = await _api.transferGroup(
        groupID: groupID,
        oldOwnerUserID: oldOwnerID,
        newOwnerUserID: userID,
      );
      if (resp.errCode != 0) {
        _log.warning('转让群主失败: ${resp.errMsg}');
      }
    }
  }

  /// 申请加入群组
  /// [groupID] 群组ID
  /// [reason] 加入原因
  /// [joinSource] 加入来源 2:邀请，3:搜索，4:二维码
  /// [ex] 扩展信息
  Future<void> joinGroup({
    required String groupID,
    String? reason,
    int joinSource = 3,
    String? ex,
  }) async {
    _log.info('joinGroup: groupID=$groupID, reason=$reason, joinSource=$joinSource');
    final now = DateTime.now().millisecondsSinceEpoch;
    await _database.upsertGroupRequest({
      'groupID': groupID,
      'userID': _currentUserID,
      'reqMsg': reason ?? '',
      'reqTime': now,
      'handleResult': 0,
      'joinSource': joinSource,
      'ex': ex,
    });
    _log.info('已申请加入群: $groupID');

    final resp = await _api.joinGroup(groupID: groupID, reqMessage: reason, joinSource: joinSource);
    if (resp.errCode != 0) {
      _log.warning('申请加入群失败: ${resp.errMsg}');
    }
  }

  /// 退出群组
  /// [groupID] 群组ID
  Future<void> quitGroup({required String groupID}) async {
    _log.info('quitGroup: groupID=$groupID');
    final quitGroupInfo = await _database.getGroupByID(groupID);
    await _database.deleteGroupMember(groupID, _currentUserID);
    await _database.deleteGroup(groupID);
    _log.info('已退出群: $groupID');
    listener?.joinedGroupDeleted(quitGroupInfo ?? GroupInfo(groupID: groupID));

    final resp = await _api.quitGroup(userID: _currentUserID, groupID: groupID);
    if (resp.errCode != 0) {
      _log.warning('退出群失败: ${resp.errMsg}');
    }
  }

  /// 解散群组
  /// [groupID] 群组ID
  Future<void> dismissGroup({required String groupID}) async {
    _log.info('dismissGroup: groupID=$groupID');
    await _database.deleteGroup(groupID);
    _log.info('群组已解散: $groupID');

    listener?.groupDismissed(GroupInfo(groupID: groupID));

    final resp = await _api.dismissGroup(groupID: groupID);
    if (resp.errCode != 0) {
      _log.warning('解散群组失败: ${resp.errMsg}');
    }
  }

  /// 群组全员禁言/解除禁言
  /// [groupID] 群组ID
  /// [mute] true:禁言, false:解除禁言
  Future<void> changeGroupMute({required String groupID, required bool mute}) async {
    _log.info('changeGroupMute: groupID=$groupID, mute=$mute');
    final existing = await _database.getGroupByID(groupID);
    if (existing != null) {
      await _database.updateGroup(groupID, {
        'status': mute ? GroupStatus.muted.value : GroupStatus.normal.value,
      });
    }
    _log.info('群组禁言状态变更: $groupID, mute=$mute');

    final updatedGroup = await _database.getGroupByID(groupID);
    if (updatedGroup != null) {
      listener?.groupInfoChanged(updatedGroup);
    }

    final resp = mute
        ? await _api.muteGroup(groupID: groupID)
        : await _api.cancelMuteGroup(groupID: groupID);
    if (resp.errCode != 0) {
      _log.warning('设置群组禁言状态失败: ${resp.errMsg}');
    }
  }

  /// 群成员禁言
  /// [groupID] 群组ID
  /// [userID] 被禁言的成员ID
  /// [seconds] 禁言秒数（0为解除禁言）
  Future<void> changeGroupMemberMute({
    required String groupID,
    required String userID,
    int seconds = 0,
  }) async {
    _log.info('changeGroupMemberMute: groupID=$groupID, userID=$userID, seconds=$seconds');
    final member = await _database.getGroupMember(groupID, userID);
    if (member != null) {
      final muteEndTime = seconds > 0 ? DateTime.now().millisecondsSinceEpoch + seconds * 1000 : 0;
      await _database.updateGroupMember(groupID, userID, {'muteEndTime': muteEndTime});
    }
    _log.info('群成员禁言: group=$groupID, user=$userID, seconds=$seconds');

    final updatedMember = await _database.getGroupMember(groupID, userID);
    if (updatedMember != null) {
      listener?.groupMemberInfoChanged(updatedMember);
    }

    final resp = seconds > 0
        ? await _api.muteGroupMember(groupID: groupID, userID: userID, mutedSeconds: seconds)
        : await _api.cancelMuteGroupMember(groupID: groupID, userID: userID);
    if (resp.errCode != 0) {
      _log.warning('设置群成员禁言失败: ${resp.errMsg}');
    }
  }

  /// 获取收到的入群申请列表（作为群主/管理员）
  /// [req] 查询参数
  Future<List<GroupApplicationInfo>> getGroupApplicationListAsRecipient({
    GetGroupApplicationListAsRecipientReq? req,
  }) async {
    _log.info('getGroupApplicationListAsRecipient: offset=${req?.offset}, count=${req?.count}');
    return _database.getGroupRequestsAsRecipient(offset: req?.offset ?? 0, count: req?.count ?? 40);
  }

  /// 获取已发送的入群申请列表
  /// [req] 查询参数
  Future<List<GroupApplicationInfo>> getGroupApplicationListAsApplicant({
    GetGroupApplicationListAsApplicantReq? req,
  }) async {
    _log.info('getGroupApplicationListAsApplicant: offset=${req?.offset}, count=${req?.count}');
    return _database.getGroupRequestsAsApplicant(offset: req?.offset ?? 0, count: req?.count ?? 40);
  }

  /// 接受入群申请
  /// [groupID] 群组ID
  /// [userID] 申请者用户ID
  /// [handleMsg] 处理消息
  Future<void> acceptGroupApplication({
    required String groupID,
    required String userID,
    String? handleMsg,
  }) async {
    _log.info('acceptGroupApplication: groupID=$groupID, userID=$userID, handleMsg=$handleMsg');
    final now = DateTime.now().millisecondsSinceEpoch;
    await _database.upsertGroupRequest({
      'groupID': groupID,
      'userID': userID,
      'handleResult': 1,
      'handleMsg': handleMsg ?? '',
      'handledTime': now,
    });

    // 将申请者添加为群成员
    await _database.upsertGroupMember({
      'groupID': groupID,
      'userID': userID,
      'roleLevel': GroupRoleLevel.member.value,
      'joinTime': now,
      'joinSource': JoinSource.search.value,
    });

    _log.info('入群申请已接受: group=$groupID, user=$userID');

    listener?.groupApplicationAccepted(
      GroupApplicationInfo(
        groupID: groupID,
        userID: userID,
        handleResult: 1,
        handledMsg: handleMsg,
      ),
    );
    listener?.groupMemberAdded(
      GroupMembersInfo(
        groupID: groupID,
        userID: userID,
        joinTime: now,
        roleLevel: GroupRoleLevel.member,
      ),
    );

    final resp = await _api.groupApplicationResponse(
      groupID: groupID,
      fromUserID: userID,
      handledMsg: handleMsg ?? '',
      handleResult: 1, // 1 for accept
    );
    if (resp.errCode != 0) {
      _log.warning('处理入群申请失败: ${resp.errMsg}');
    }
  }

  /// 拒绝入群申请
  /// [groupID] 群组ID
  /// [userID] 申请者用户ID
  /// [handleMsg] 拒绝原因
  Future<void> refuseGroupApplication({
    required String groupID,
    required String userID,
    String? handleMsg,
  }) async {
    _log.info('refuseGroupApplication: groupID=$groupID, userID=$userID, handleMsg=$handleMsg');
    final now = DateTime.now().millisecondsSinceEpoch;
    await _database.upsertGroupRequest({
      'groupID': groupID,
      'userID': userID,
      'handleResult': -1,
      'handleMsg': handleMsg ?? '',
      'handledTime': now,
    });

    _log.info('入群申请已拒绝: group=$groupID, user=$userID');

    listener?.groupApplicationRejected(
      GroupApplicationInfo(
        groupID: groupID,
        userID: userID,
        handleResult: -1,
        handledMsg: handleMsg,
      ),
    );

    final resp = await _api.groupApplicationResponse(
      groupID: groupID,
      fromUserID: userID,
      handledMsg: handleMsg ?? '',
      handleResult: -1, // -1 for refuse
    );
    if (resp.errCode != 0) {
      _log.warning('处理入群申请失败: ${resp.errMsg}');
    }
  }

  /// 获取未处理的入群申请数量
  /// [req] 查询参数
  Future<int> getGroupApplicationUnhandledCount(GetGroupApplicationUnhandledCountReq req) async {
    _log.info('getGroupApplicationUnhandledCount');
    return _database.getGroupRequestUnhandledCount();
  }

  /// 搜索群组
  /// [keywordList] 搜索关键字
  /// [isSearchGroupID] 是否搜索群组ID
  /// [isSearchGroupName] 是否搜索群名
  Future<List<GroupInfo>> searchGroups({
    List<String> keywordList = const [],
    bool isSearchGroupID = false,
    bool isSearchGroupName = false,
  }) async {
    _log.info(
      'searchGroups: keywordList=$keywordList, isSearchGroupID=$isSearchGroupID, isSearchGroupName=$isSearchGroupName',
    );
    final keyword = keywordList.isNotEmpty ? keywordList.first : '';
    if (keyword.isEmpty) return [];

    return _database.searchGroups(
      keyword,
      searchGroupID: isSearchGroupID,
      searchGroupName: isSearchGroupName,
    );
  }

  /// 按入群时间获取群成员列表
  /// [groupID] 群组ID
  /// [offset] 起始索引
  /// [count] 数量
  /// [joinTimeBegin] 入群开始时间
  /// [joinTimeEnd] 入群结束时间
  /// [filterUserIDList] 过滤用户ID列表
  Future<List<GroupMembersInfo>> getGroupMemberListByJoinTime({
    required String groupID,
    int offset = 0,
    int count = 0,
    int joinTimeBegin = 0,
    int joinTimeEnd = 0,
    List<String> filterUserIDList = const [],
    String? operationID,
  }) async {
    _log.info(
      'getGroupMemberListByJoinTime: groupID=$groupID, offset=$offset, count=$count, joinTimeBegin=$joinTimeBegin, joinTimeEnd=$joinTimeEnd, filterUserIDList=$filterUserIDList',
    );
    final dataList = await _database.getGroupMembersPage(
      groupID,
      offset: offset,
      count: count == 0 ? 40 : count,
    );
    var members = dataList;

    // 按入群时间过滤
    if (joinTimeBegin > 0 || joinTimeEnd > 0) {
      members = members.where((m) {
        final jt = m.joinTime ?? 0;
        if (joinTimeBegin > 0 && jt < joinTimeBegin) return false;
        if (joinTimeEnd > 0 && jt > joinTimeEnd) return false;
        return true;
      }).toList();
    }

    // 过滤指定用户
    if (filterUserIDList.isNotEmpty) {
      members.removeWhere((m) => filterUserIDList.contains(m.userID));
    }

    return members;
  }

  /// 获取指定用户中哪些在群组内
  /// 对应 Go SDK GetUsersInGroup
  /// [groupID] 群组ID
  /// [userIDList] 待检查的用户ID列表
  /// 返回存在于群组中的用户ID列表
  Future<List<String>> getUsersInGroup({
    required String groupID,
    required List<String> userIDList,
  }) async {
    _log.info('getUsersInGroup: groupID=$groupID, userIDList=$userIDList');
    if (userIDList.isEmpty) return [];

    final members = await _database.getGroupMembersByUserIDs(groupID, userIDList);
    return members.map((m) => m.userID ?? '').where((id) => id.isNotEmpty).toList();
  }
}
