import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/db/database_service.dart';

/// 群组管理器
/// 对应 open-im-sdk-flutter 中 GroupManager。
/// 负责群组创建、加入/退出、成员管理、群信息修改和监听回调。
class GroupManager {
  static final Logger _log = Logger('GroupManager');

  DatabaseService get _db => GetIt.instance.get<DatabaseService>();

  /// 群组监听器
  OnGroupListener? listener;

  /// 设置群组监听器
  void setGroupListener(OnGroupListener listener) {
    this.listener = listener;
  }

  // ---------------------------------------------------------------------------
  // 群组信息查询
  // ---------------------------------------------------------------------------

  /// 查询群组信息
  /// [groupIDList] 群组ID列表
  Future<List<GroupInfo>> getGroupsInfo({required List<String> groupIDList}) async {
    final results = <GroupInfo>[];
    for (final gid in groupIDList) {
      final data = await _db.getGroupByID(gid);
      if (data != null) {
        results.add(_convertGroupInfo(data));
      }
    }
    return results;
  }

  /// 获取已加入的群组列表
  Future<List<GroupInfo>> getJoinedGroupList() async {
    final dataList = await _db.getJoinedGroupList();
    return dataList.map(_convertGroupInfo).toList();
  }

  /// 分页获取已加入的群组列表
  /// [offset] 起始索引
  /// [count] 每页数量
  Future<List<GroupInfo>> getJoinedGroupListPage({int offset = 0, int count = 40}) async {
    final dataList = await _db.getJoinedGroupListPage(offset, count);
    return dataList.map(_convertGroupInfo).toList();
  }

  /// 检查是否已加入群组
  /// [groupID] 群组ID
  Future<bool> isJoinedGroup({required String groupID}) async {
    final data = await _db.getGroupByID(groupID);
    return data != null;
  }

  // ---------------------------------------------------------------------------
  // 群组创建与修改
  // ---------------------------------------------------------------------------

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
    final now = DateTime.now().millisecondsSinceEpoch;
    final gid = groupInfo.groupID.isNotEmpty ? groupInfo.groupID : 'g_${now}_${_db.currentUserID}';

    final data = {
      'groupID': gid,
      'groupName': groupInfo.groupName,
      'notification': groupInfo.notification,
      'introduction': groupInfo.introduction,
      'faceURL': groupInfo.faceURL,
      'ownerUserID': ownerUserID ?? _db.currentUserID,
      'createTime': now,
      'memberCount': memberUserIDs.length + adminUserIDs.length + 1,
      'status': GroupStatus.normal.value,
      'creatorUserID': _db.currentUserID,
      'groupType': groupInfo.groupType?.value ?? GroupType.work.value,
      'ex': groupInfo.ex,
      'needVerification': groupInfo.needVerification,
      'lookMemberInfo': groupInfo.lookMemberInfo,
      'applyMemberFriend': groupInfo.applyMemberFriend,
      'notificationUpdateTime': now,
      'notificationUserID': _db.currentUserID,
    };
    await _db.upsertGroup(data);

    // 添加群主
    await _db.upsertGroupMember({
      'groupID': gid,
      'userID': ownerUserID ?? _db.currentUserID,
      'roleLevel': GroupRoleLevel.owner.value,
      'joinTime': now,
      'joinSource': JoinSource.invited.value,
    });

    // 添加管理员
    for (final uid in adminUserIDs) {
      await _db.upsertGroupMember({
        'groupID': gid,
        'userID': uid,
        'roleLevel': GroupRoleLevel.admin.value,
        'joinTime': now,
        'joinSource': JoinSource.invited.value,
      });
    }

    // 添加普通成员
    for (final uid in memberUserIDs) {
      await _db.upsertGroupMember({
        'groupID': gid,
        'userID': uid,
        'roleLevel': GroupRoleLevel.member.value,
        'joinTime': now,
        'joinSource': JoinSource.invited.value,
      });
    }

    _log.info('群组已创建: $gid');

    final createdData = await _db.getGroupByID(gid);
    return _convertGroupInfo(createdData ?? data);
  }

  /// 修改群组信息
  /// [groupInfo] 群组信息（只更新非null字段）
  Future<void> setGroupInfo(GroupInfo groupInfo) async {
    final updateData = groupInfo.toJson()..removeWhere((_, v) => v == null);
    final existing = await _db.getGroupByID(groupInfo.groupID);
    if (existing != null) {
      await _db.upsertGroup({...existing, ...updateData});
    }
    _log.info('群组信息已更新: ${groupInfo.groupID}');

    listener?.groupInfoChanged(groupInfo);
    // TODO: 同步到服务器
  }

  // ---------------------------------------------------------------------------
  // 群成员管理
  // ---------------------------------------------------------------------------

  /// 邀请用户入群（无需审批直接加入）
  /// [groupID] 群组ID
  /// [userIDList] 用户ID列表
  /// [reason] 邀请原因
  Future<void> inviteUserToGroup({
    required String groupID,
    required List<String> userIDList,
    String? reason,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final uid in userIDList) {
      await _db.upsertGroupMember({
        'groupID': groupID,
        'userID': uid,
        'roleLevel': GroupRoleLevel.member.value,
        'joinTime': now,
        'joinSource': JoinSource.invited.value,
      });
    }
    _log.info('已邀请 ${userIDList.length} 个用户加入群 $groupID');
    // TODO: 同步到服务器
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
    for (final uid in userIDList) {
      await _db.deleteGroupMember(groupID, uid);
    }
    _log.info('已从群 $groupID 踢出 ${userIDList.length} 个成员');
    // TODO: 同步到服务器
  }

  /// 查询群成员信息
  /// [groupID] 群组ID
  /// [userIDList] 用户ID列表
  Future<List<GroupMembersInfo>> getGroupMembersInfo({
    required String groupID,
    required List<String> userIDList,
  }) async {
    final results = <GroupMembersInfo>[];
    for (final uid in userIDList) {
      final data = await _db.getGroupMember(groupID, uid);
      if (data != null) {
        results.add(_convertGroupMembersInfo(data));
      }
    }
    return results;
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
    final dataList = await _db.getGroupMembersPage(
      groupID,
      filter: filter,
      offset: offset,
      count: count,
    );
    return dataList.map(_convertGroupMembersInfo).toList();
  }

  /// 获取群主和管理员列表
  /// [groupID] 群组ID
  Future<List<GroupMembersInfo>> getGroupOwnerAndAdmin({required String groupID}) async {
    final dataList = await _db.getGroupOwnerAndAdmin(groupID);
    return dataList.map(_convertGroupMembersInfo).toList();
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
    final keyword = keywordList.isNotEmpty ? keywordList.first : '';
    if (keyword.isEmpty) return [];

    final dataList = await _db.searchGroupMembers(
      groupID,
      keyword,
      searchUserID: isSearchUserID,
      searchNickname: isSearchMemberNickname,
      offset: offset,
      count: count,
    );

    return dataList.map(_convertGroupMembersInfo).toList();
  }

  /// 修改群成员信息
  /// [groupMembersInfo] 群成员信息
  Future<void> setGroupMemberInfo({required SetGroupMemberInfo groupMembersInfo}) async {
    final gid = groupMembersInfo.groupID;
    final uid = groupMembersInfo.userID;
    if (gid.isEmpty || uid.isEmpty) return;

    final existing = await _db.getGroupMember(gid, uid);
    if (existing == null) return;

    final updateData = <String, dynamic>{...existing};
    if (groupMembersInfo.nickname != null) updateData['nickname'] = groupMembersInfo.nickname;
    if (groupMembersInfo.faceURL != null) updateData['faceURL'] = groupMembersInfo.faceURL;
    if (groupMembersInfo.roleLevel != null) updateData['roleLevel'] = groupMembersInfo.roleLevel;
    if (groupMembersInfo.ex != null) updateData['ex'] = groupMembersInfo.ex;

    await _db.upsertGroupMember(updateData);
    _log.info('群成员信息已更新: group=$gid, user=$uid');

    // TODO: 同步到服务器
  }

  /// 转让群主
  /// [groupID] 群组ID
  /// [userID] 新群主用户ID
  Future<void> transferGroupOwner({required String groupID, required String userID}) async {
    // 获取当前群主
    final ownerList = await _db.getGroupOwnerAndAdmin(groupID);
    for (final member in ownerList) {
      if (member['roleLevel'] == GroupRoleLevel.owner.value) {
        await _db.upsertGroupMember({...member, 'roleLevel': GroupRoleLevel.member.value});
        break;
      }
    }

    // 设置新群主
    final newOwner = await _db.getGroupMember(groupID, userID);
    if (newOwner != null) {
      await _db.upsertGroupMember({...newOwner, 'roleLevel': GroupRoleLevel.owner.value});
    }

    _log.info('群主已转让: group=$groupID, newOwner=$userID');
    // TODO: 同步到服务器
  }

  // ---------------------------------------------------------------------------
  // 加群与退群
  // ---------------------------------------------------------------------------

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
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.upsertGroupRequest({
      'groupID': groupID,
      'userID': _db.currentUserID,
      'reqMsg': reason ?? '',
      'reqTime': now,
      'handleResult': 0,
      'joinSource': joinSource,
      'ex': ex,
    });
    _log.info('已申请加入群: $groupID');
    // TODO: 同步到服务器
  }

  /// 退出群组
  /// [groupID] 群组ID
  Future<void> quitGroup({required String groupID}) async {
    await _db.deleteGroupMember(groupID, _db.currentUserID);
    await _db.deleteGroup(groupID);
    _log.info('已退出群: $groupID');
    // TODO: 同步到服务器
  }

  /// 解散群组
  /// [groupID] 群组ID
  Future<void> dismissGroup({required String groupID}) async {
    await _db.deleteGroup(groupID);
    _log.info('群组已解散: $groupID');

    listener?.groupDismissed(GroupInfo(groupID: groupID));
    // TODO: 同步到服务器
  }

  // ---------------------------------------------------------------------------
  // 群组禁言
  // ---------------------------------------------------------------------------

  /// 群组全员禁言/解除禁言
  /// [groupID] 群组ID
  /// [mute] true:禁言, false:解除禁言
  Future<void> changeGroupMute({required String groupID, required bool mute}) async {
    final existing = await _db.getGroupByID(groupID);
    if (existing != null) {
      await _db.upsertGroup({
        ...existing,
        'status': mute ? GroupStatus.muted.value : GroupStatus.normal.value,
      });
    }
    _log.info('群组禁言状态变更: $groupID, mute=$mute');
    // TODO: 同步到服务器
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
    final member = await _db.getGroupMember(groupID, userID);
    if (member != null) {
      final muteEndTime = seconds > 0 ? DateTime.now().millisecondsSinceEpoch + seconds * 1000 : 0;
      await _db.upsertGroupMember({...member, 'muteEndTime': muteEndTime});
    }
    _log.info('群成员禁言: group=$groupID, user=$userID, seconds=$seconds');
    // TODO: 同步到服务器
  }

  // ---------------------------------------------------------------------------
  // 入群审批
  // ---------------------------------------------------------------------------

  /// 获取收到的入群申请列表（作为群主/管理员）
  /// [req] 查询参数
  Future<List<GroupApplicationInfo>> getGroupApplicationListAsRecipient({
    GetGroupApplicationListAsRecipientReq? req,
  }) async {
    final dataList = await _db.getGroupRequestsAsRecipient(
      offset: req?.offset ?? 0,
      count: req?.count ?? 40,
    );
    return dataList.map(_convertGroupApplicationInfo).toList();
  }

  /// 获取已发送的入群申请列表
  /// [req] 查询参数
  Future<List<GroupApplicationInfo>> getGroupApplicationListAsApplicant({
    GetGroupApplicationListAsApplicantReq? req,
  }) async {
    final dataList = await _db.getGroupRequestsAsApplicant(
      offset: req?.offset ?? 0,
      count: req?.count ?? 40,
    );
    return dataList.map(_convertGroupApplicationInfo).toList();
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
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.upsertGroupRequest({
      'groupID': groupID,
      'userID': userID,
      'handleResult': 1,
      'handleMsg': handleMsg ?? '',
      'handledTime': now,
    });

    // 将申请者添加为群成员
    await _db.upsertGroupMember({
      'groupID': groupID,
      'userID': userID,
      'roleLevel': GroupRoleLevel.member.value,
      'joinTime': now,
      'joinSource': JoinSource.search.value,
    });

    _log.info('入群申请已接受: group=$groupID, user=$userID');
    // TODO: 同步到服务器
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
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.upsertGroupRequest({
      'groupID': groupID,
      'userID': userID,
      'handleResult': -1,
      'handleMsg': handleMsg ?? '',
      'handledTime': now,
    });

    _log.info('入群申请已拒绝: group=$groupID, user=$userID');
    // TODO: 同步到服务器
  }

  /// 获取未处理的入群申请数量
  /// [req] 查询参数
  Future<int> getGroupApplicationUnhandledCount(GetGroupApplicationUnhandledCountReq req) async {
    return _db.getGroupRequestUnhandledCount();
  }

  // ---------------------------------------------------------------------------
  // 搜索
  // ---------------------------------------------------------------------------

  /// 搜索群组
  /// [keywordList] 搜索关键字
  /// [isSearchGroupID] 是否搜索群组ID
  /// [isSearchGroupName] 是否搜索群名
  Future<List<GroupInfo>> searchGroups({
    List<String> keywordList = const [],
    bool isSearchGroupID = false,
    bool isSearchGroupName = false,
  }) async {
    final keyword = keywordList.isNotEmpty ? keywordList.first : '';
    if (keyword.isEmpty) return [];

    final dataList = await _db.searchGroups(
      keyword,
      searchGroupID: isSearchGroupID,
      searchGroupName: isSearchGroupName,
    );

    return dataList.map(_convertGroupInfo).toList();
  }

  // ---------------------------------------------------------------------------
  // 内部回调方法（供服务器推送消息处理使用）
  // ---------------------------------------------------------------------------

  /// 处理服务器推送的群信息变更
  void onGroupInfoChanged(GroupInfo info) {
    listener?.groupInfoChanged(info);
  }

  /// 处理服务器推送的新群成员加入
  void onGroupMemberAdded(GroupMembersInfo info) {
    listener?.groupMemberAdded(info);
  }

  /// 处理服务器推送的群成员退出
  void onGroupMemberDeleted(GroupMembersInfo info) {
    listener?.groupMemberDeleted(info);
  }

  // ---------------------------------------------------------------------------
  // 私有辅助方法
  // ---------------------------------------------------------------------------

  /// 数据库 Map 转 GroupInfo
  GroupInfo _convertGroupInfo(Map<String, dynamic> data) {
    return GroupInfo(
      groupID: (data['groupID'] as String?) ?? '',
      groupName: data['groupName'] as String?,
      notification: data['notification'] as String?,
      introduction: data['introduction'] as String?,
      faceURL: data['faceURL'] as String?,
      ownerUserID: data['ownerUserID'] as String?,
      createTime: data['createTime'] as int?,
      memberCount: data['memberCount'] as int?,
      status: _intToGroupStatus(data['status'] as int?),
      creatorUserID: data['creatorUserID'] as String?,
      groupType: _intToGroupType(data['groupType'] as int?),
      ex: data['ex'] as String?,
      needVerification: _intToGroupVerification(data['needVerification'] as int?),
      lookMemberInfo: data['lookMemberInfo'] as int?,
      applyMemberFriend: data['applyMemberFriend'] as int?,
      notificationUpdateTime: data['notificationUpdateTime'] as int?,
      notificationUserID: data['notificationUserID'] as String?,
    );
  }

  /// 数据库 Map 转 GroupMembersInfo
  GroupMembersInfo _convertGroupMembersInfo(Map<String, dynamic> data) {
    return GroupMembersInfo(
      groupID: data['groupID'] as String?,
      userID: data['userID'] as String?,
      nickname: data['nickname'] as String?,
      faceURL: data['faceURL'] as String?,
      roleLevel: _intToGroupRoleLevel(data['roleLevel'] as int?),
      joinTime: data['joinTime'] as int?,
      joinSource: _intToJoinSource(data['joinSource'] as int?),
      muteEndTime: data['muteEndTime'] as int?,
      inviterUserID: data['inviterUserID'] as String?,
      operatorUserID: data['operatorUserID'] as String?,
      ex: data['ex'] as String?,
    );
  }

  /// 数据库 Map 转 GroupApplicationInfo
  GroupApplicationInfo _convertGroupApplicationInfo(Map<String, dynamic> data) {
    return GroupApplicationInfo(
      groupID: data['groupID'] as String?,
      groupName: data['groupName'] as String?,
      groupFaceURL: data['groupFaceURL'] as String?,
      userID: data['userID'] as String?,
      nickname: data['nickname'] as String?,
      userFaceURL: data['userFaceURL'] as String?,
      handleResult: data['handleResult'] as int?,
      reqMsg: data['reqMsg'] as String?,
      reqTime: data['reqTime'] as int?,
      handleUserID: data['handleUserID'] as String?,
      handledMsg: data['handledMsg'] as String?,
      handledTime: data['handledTime'] as int?,
      ex: data['ex'] as String?,
      joinSource: _intToJoinSource(data['joinSource'] as int?),
      inviterUserID: data['inviterUserID'] as String?,
    );
  }

  /// int 转 GroupType
  static GroupType? _intToGroupType(int? value) {
    if (value == null) return null;
    return GroupType.values.cast<GroupType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  /// int 转 GroupStatus
  static GroupStatus? _intToGroupStatus(int? value) {
    if (value == null) return null;
    return GroupStatus.values.cast<GroupStatus?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  /// int 转 GroupVerification
  static GroupVerification? _intToGroupVerification(int? value) {
    if (value == null) return null;
    return GroupVerification.values.cast<GroupVerification?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  /// int 转 GroupRoleLevel
  static GroupRoleLevel? _intToGroupRoleLevel(int? value) {
    if (value == null) return null;
    return GroupRoleLevel.values.cast<GroupRoleLevel?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }

  /// int 转 JoinSource
  static JoinSource? _intToJoinSource(int? value) {
    if (value == null) return null;
    return JoinSource.values.cast<JoinSource?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }
}
