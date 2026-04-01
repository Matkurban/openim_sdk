import 'package:meta/meta.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';
import 'package:get_it/get_it.dart';
import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/services/database_service.dart';

class GroupManager {
  GroupManager._internal();

  static final GroupManager _instance = GroupManager._internal();

  factory GroupManager() => _instance;

  static final AoiweLogger _log = AoiweLogger('GroupManager');

  final GetIt _getIt = GetIt.instance;

  DatabaseService get _database {
    return _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  ImApiService get _api {
    return _getIt.get<ImApiService>(instanceName: InstanceName.imApiService);
  }

  OnGroupListener? listener;

  late String _currentUserID;

  /// 已确认本地存在成员数据的群组（会话级缓存，避免重复检查）
  /// 对齐 Go SDK GetGroupMemberList 中的 sync-before-read 模式。
  final Set<String> _memberSyncedGroups = {};

  void setGroupListener(OnGroupListener listener) {
    this.listener = listener;
  }

  @internal
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
    _memberSyncedGroups.clear();
  }

  // ---------------------------------------------------------------------------
  // Sync-before-read (mirrors Go SDK's GetGroupMemberList pattern)
  // ---------------------------------------------------------------------------

  /// 对齐 Go SDK GetGroupMemberList：读取前确保群成员已同步到本地。
  /// Go SDK 检查 groupAndMemberVersionTableName 的版本记录，若不存在则
  /// 调用 IncrSyncGroupAndMember 先同步。此处简化为：检查本地是否有任何
  /// 该群成员，没有则从服务器拉取全量成员。
  Future<void> _ensureGroupMembersSynced(String groupID) async {
    if (groupID.isEmpty || _memberSyncedGroups.contains(groupID)) return;
    try {
      final existing = await _database.getGroupMembersPage(groupID, filter: 0, offset: 0, count: 1);
      if (existing.isNotEmpty) {
        _memberSyncedGroups.add(groupID);
        return;
      }
      _log.info(
        'No local members for $groupID, syncing from server',
        methodName: '_ensureGroupMembersSynced',
      );
      final apiMembers = await _syncGroupMembersFromServer(groupID);
      if (apiMembers.isNotEmpty) {
        _memberApiCache[groupID] = apiMembers;
      }
      _memberSyncedGroups.add(groupID);
    } catch (e, s) {
      _log.error(
        'Failed to ensure members synced: $e',
        error: e,
        stackTrace: s,
        methodName: '_ensureGroupMembersSynced',
      );
    }
  }

  /// 从服务器分页拉取指定群的全部成员。
  /// 返回原始 API 数据列表同时尝试存入本地数据库。
  Future<List<Map<String, dynamic>>> _syncGroupMembersFromServer(String groupID) async {
    int offset = 0;
    const pageSize = 100;
    final allMembers = <Map<String, dynamic>>[];
    while (true) {
      final resp = await _api.getGroupMemberList(groupID: groupID, offset: offset, count: pageSize);
      _log.info(
        'API resp for $groupID: errCode=${resp.errCode}, dataType=${resp.data?.runtimeType}, '
        'dataKeys=${resp.data is Map ? (resp.data as Map).keys.toList() : "N/A"}',
        methodName: '_syncGroupMembersFromServer',
      );
      if (resp.errCode != 0) {
        _log.warning(
          'API error for $groupID: ${resp.errCode} ${resp.errMsg}',
          methodName: '_syncGroupMembersFromServer',
        );
        break;
      }
      final members = resp.data?['members'] as List? ?? [];
      _log.info(
        'Fetched ${members.length} members for $groupID (offset=$offset)',
        methodName: '_syncGroupMembersFromServer',
      );
      if (members.isEmpty) break;
      for (final m in members) {
        if (m is Map<String, dynamic>) allMembers.add(m);
      }
      if (members.length < pageSize) break;
      offset += pageSize;
    }
    if (allMembers.isNotEmpty) {
      _log.info(
        'Storing ${allMembers.length} members for $groupID to DB',
        methodName: '_syncGroupMembersFromServer',
      );
      try {
        await _database.batchUpsertGroupMembers(allMembers);
        // 验证写入是否成功
        final verify = await _database.getGroupMembersPage(groupID, filter: 0, offset: 0, count: 1);
        _log.info(
          'DB verify after write for $groupID: ${verify.length} rows found',
          methodName: '_syncGroupMembersFromServer',
        );
      } catch (e, s) {
        _log.error(
          'DB write failed for $groupID: $e',
          error: e,
          stackTrace: s,
          methodName: '_syncGroupMembersFromServer',
        );
      }
    } else {
      _log.warning(
        'No members fetched from API for $groupID',
        methodName: '_syncGroupMembersFromServer',
      );
    }
    return allMembers;
  }

  /// 从 API 原始数据转换为 GroupMembersInfo 列表
  List<GroupMembersInfo> _apiMembersToGroupMembersInfo(List<Map<String, dynamic>> apiMembers) {
    return apiMembers.map((m) => GroupMembersInfo.fromJson(m)).toList();
  }

  /// 缓存最近一次从 API 拉取的群成员原始数据，用于 DB 写入失败时的回退
  final Map<String, List<Map<String, dynamic>>> _memberApiCache = {};

  // ---------------------------------------------------------------------------
  // Incremental sync helpers (mirrors Go SDK's IncrSyncJoinGroup / IncrSyncGroupAndMember)
  // ---------------------------------------------------------------------------

  /// Incremental sync of joined groups list from server.
  Future<void> _incrSyncJoinGroup() async {
    final versionInfo = await _database.getVersionSync('group', _currentUserID);
    final versionID = versionInfo?['versionID'] as String? ?? '';
    final version = (versionInfo?['version'] as num?)?.toInt() ?? 0;

    final resp = await _api.getIncrementalJoinGroup(
      req: {'userID': _currentUserID, 'versionID': versionID, 'version': version},
    );
    if (resp.errCode != 0) return;

    final data = resp.data as Map<String, dynamic>? ?? {};
    final bool full = data['full'] as bool? ?? false;

    final deleteIDs =
        (data['delete'] as List?)?.map((e) => e.toString()).whereType<String>().toList() ??
        const <String>[];
    final insertList = (data['insert'] as List?) ?? const <dynamic>[];
    final updateList = (data['update'] as List?) ?? const <dynamic>[];

    if (full) {
      final serverGroupIDs = <String>{};
      for (final g in [...insertList, ...updateList]) {
        if (g is Map<String, dynamic>) {
          final id = g['groupID']?.toString();
          if (id != null && id.isNotEmpty) serverGroupIDs.add(id);
        }
      }
      if (serverGroupIDs.isNotEmpty) {
        final localGroupIDs = (await _database.getJoinedGroupList()).map((e) => e.groupID).toSet();
        final toDelete = localGroupIDs.difference(serverGroupIDs);
        for (final groupID in toDelete) {
          await _database.deleteGroupAllMembers(groupID);
          await _database.deleteGroup(groupID);
          final convID = OpenImUtils.genGroupConversationID(groupID);
          await _database.updateConversation(convID, {'isNotInGroup': true});
        }
      }
    }

    for (final groupID in deleteIDs) {
      await _database.deleteGroupAllMembers(groupID);
      await _database.deleteGroup(groupID);
      final convID = OpenImUtils.genGroupConversationID(groupID);
      await _database.updateConversation(convID, {'isNotInGroup': true});
    }

    final allGroups = <Map<String, dynamic>>[];
    for (final g in [...insertList, ...updateList]) {
      if (g is Map<String, dynamic>) allGroups.add(g);
    }
    if (allGroups.isNotEmpty) {
      await _database.batchUpsertGroups(allGroups);
    }

    final newVersion = (data['version'] as num?)?.toInt() ?? version;
    final newVersionID = data['versionID'] as String? ?? versionID;
    await _database.setVersionSync(
      tableName: 'group',
      entityID: _currentUserID,
      versionID: newVersionID,
      version: newVersion,
      uidList: const [],
    );
  }

  /// Sync group info AND all members for a specific group from server.
  /// Mirrors Go SDK's IncrSyncGroupAndMember which syncs both.
  Future<void> _incrSyncGroupAndMember(String groupID) async {
    final groupResp = await _api.getGroupsInfo(groupIDs: [groupID]);
    if (groupResp.errCode == 0) {
      final groups = groupResp.data?['groupInfos'] as List? ?? [];
      final groupMaps = <Map<String, dynamic>>[];
      for (final g in groups) {
        if (g is Map<String, dynamic>) groupMaps.add(g);
      }
      if (groupMaps.isNotEmpty) {
        await _database.batchUpsertGroups(groupMaps);
      }
    }

    int offset = 0;
    const pageSize = 100;
    final allMembers = <Map<String, dynamic>>[];
    while (true) {
      final resp = await _api.getGroupMemberList(groupID: groupID, offset: offset, count: pageSize);
      if (resp.errCode != 0) break;
      final members = resp.data?['members'] as List? ?? [];
      if (members.isEmpty) break;
      for (final m in members) {
        if (m is Map<String, dynamic>) allMembers.add(m);
      }
      if (members.length < pageSize) break;
      offset += pageSize;
    }
    if (allMembers.isNotEmpty) {
      await _database.batchUpsertGroupMembers(allMembers);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// 将服务器返回的嵌套 GroupRequest 转换为扁平化的 GroupApplicationInfo
  /// 对齐 Go SDK ServerGroupRequestToLocalGroupRequest
  GroupApplicationInfo _serverGroupRequestToLocal(Map<String, dynamic> req) {
    final userInfo = req['userInfo'] as Map<String, dynamic>? ?? {};
    final groupInfo = req['groupInfo'] as Map<String, dynamic>? ?? {};
    return GroupApplicationInfo.fromJson({
      'groupID': groupInfo['groupID'],
      'groupName': groupInfo['groupName'],
      'notification': groupInfo['notification'],
      'introduction': groupInfo['introduction'],
      'groupFaceURL': groupInfo['faceURL'],
      'createTime': groupInfo['createTime'],
      'status': groupInfo['status'],
      'creatorUserID': groupInfo['creatorUserID'],
      'groupType': groupInfo['groupType'],
      'ownerUserID': groupInfo['ownerUserID'],
      'memberCount': groupInfo['memberCount'],
      'userID': userInfo['userID'],
      'nickname': userInfo['nickname'],
      'userFaceURL': userInfo['faceURL'],
      'handleResult': req['handleResult'],
      'reqMsg': req['reqMsg'],
      'handledMsg': req['handleMsg'],
      'reqTime': req['reqTime'],
      'handleUserID': req['handleUserID'],
      'handledTime': req['handleTime'],
      'ex': req['ex'],
      'joinSource': req['joinSource'],
      'inviterUserID': req['inviterUserID'],
    });
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// 查询群组信息
  /// [groupIDList] 群组ID列表
  /// 对齐 Go SDK GetSpecifiedGroupsInfoSafe：先查本地，缺失的从服务器拉取但不写入本地
  /// （local_groups 表仅存储已加入的群，由 sync 维护）
  Future<List<GroupInfo>> getGroupsInfo({required List<String> groupIDList}) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.getGroupsInfo', {
        'groupIDList': groupIDList,
      });
      return (result as List)
          .map((e) => GroupInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info('groupIDList=$groupIDList', methodName: 'getGroupsInfo');
    try {
      if (groupIDList.isEmpty) return [];

      // 1. 从本地数据库查询
      final localGroups = await _database.getGroupsByIDs(groupIDList);
      final localIDSet = <String>{for (final g in localGroups) g.groupID};

      // 2. 找出本地缺失的 groupID
      final missingIDs = groupIDList.where((id) => !localIDSet.contains(id)).toList();
      if (missingIDs.isEmpty) return localGroups;

      // 3. 从服务器拉取缺失的群信息（不写入本地 DB，避免污染 local_groups 表）
      _log.info('本地缺失 ${missingIDs.length} 个群，从服务器拉取: $missingIDs', methodName: 'getGroupsInfo');
      final resp = await _api.getGroupsInfo(groupIDs: missingIDs);
      if (resp.errCode != 0) {
        _log.warning('从服务器获取群信息失败: ${resp.errMsg}', methodName: 'getGroupsInfo');
        return localGroups;
      }

      final serverGroups = resp.data?['groupInfos'] as List? ?? [];
      final serverGroupInfos = <GroupInfo>[];
      for (final g in serverGroups) {
        if (g is Map<String, dynamic>) {
          serverGroupInfos.add(GroupInfo.fromJson(g));
        }
      }

      // 4. 合并返回（不缓存到本地，local_groups 仅由 sync 维护）
      return [...localGroups, ...serverGroupInfos];
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getGroupsInfo');
      rethrow;
    }
  }

  /// 获取已加入的群组列表
  Future<List<GroupInfo>> getJoinedGroupList() async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.getJoinedGroupList', {});
      return (result as List)
          .map((e) => GroupInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info('called', methodName: 'getJoinedGroupList');
    try {
      return await _database.getJoinedGroupList();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getJoinedGroupList');
      rethrow;
    }
  }

  /// 分页获取已加入的群组列表
  /// [offset] 起始索引
  /// [count] 每页数量
  Future<List<GroupInfo>> getJoinedGroupListPage({int offset = 0, int count = 40}) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.getJoinedGroupListPage', {
        'offset': offset,
        'count': count,
      });
      return (result as List)
          .map((e) => GroupInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info('offset=$offset, count=$count', methodName: 'getJoinedGroupListPage');
    try {
      return await _database.getJoinedGroupListPage(offset, count);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getJoinedGroupListPage');
      rethrow;
    }
  }

  /// 检查是否已加入群组
  /// [groupID] 群组ID
  /// 通过服务器查询当前用户是否为群成员，避免本地 local_groups 表数据不准确
  Future<bool> isJoinedGroup({required String groupID}) async {
    if (SdkIsolateManager.isActive) {
      return await SdkIsolateManager.instance.invoke('group.isJoinedGroup', {'groupID': groupID})
          as bool;
    }
    _log.info('groupID=$groupID', methodName: 'isJoinedGroup');
    try {
      final resp = await _api.getGroupMembersInfo(groupID: groupID, userIDs: [_currentUserID]);
      if (resp.errCode != 0) return false;
      final members = resp.data?['members'] as List?;
      return members != null && members.isNotEmpty;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'isJoinedGroup');
      rethrow;
    }
  }

  /// 创建群组（对齐 Go SDK: API → IncrSyncJoinGroup → IncrSyncGroupAndMember → return）
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
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.createGroup', {
        'groupInfo': groupInfo.toJson(),
        'memberUserIDs': memberUserIDs,
        'adminUserIDs': adminUserIDs,
        'ownerUserID': ownerUserID,
      });
      return GroupInfo.fromJson(Map<String, dynamic>.from(result as Map));
    }
    _log.info(
      'groupName=${groupInfo.groupName}, memberCount=${memberUserIDs.length}, adminCount=${adminUserIDs.length}, ownerUserID=$ownerUserID',
      methodName: 'createGroup',
    );
    try {
      final String finalOwnerUserID = ownerUserID ?? _currentUserID;

      if (groupInfo.groupType != null && groupInfo.groupType != GroupType.work) {
        throw OpenIMException(code: 10007, message: 'GroupType must be WorkingGroup');
      }

      final groupInfoMap = Map<String, dynamic>.from(groupInfo.toJson())
        ..remove('groupID')
        ..removeWhere((_, v) => v == null);
      groupInfoMap['creatorUserID'] = _currentUserID;

      final req = <String, dynamic>{
        'memberUserIDs': memberUserIDs,
        'adminUserIDs': adminUserIDs,
        'ownerUserID': finalOwnerUserID,
        'groupInfo': groupInfoMap,
      };

      final resp = await _api.createGroup(req: req);
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      final serverGroupInfo =
          (resp.data as Map<String, dynamic>?)?['groupInfo'] as Map<String, dynamic>? ?? {};
      final gid = serverGroupInfo['groupID']?.toString() ?? '';

      if (gid.isEmpty) {
        throw OpenIMException(code: 0, message: 'createGroup: missing groupID in response');
      }

      // 立即写入群信息，避免竞态：WebSocket 推送可能在增量同步的 HTTP 等待期间到达，
      // MsgSyncer._enrichNewConversation 需要从本地 DB 查群名来填充会话 showName。
      await _database.upsertGroup(serverGroupInfo);

      await _incrSyncJoinGroup();
      await _incrSyncGroupAndMember(gid);

      final result = await _database.getGroupByID(gid);
      final groupResult = result ?? GroupInfo.fromJson(serverGroupInfo);

      listener?.joinedGroupAdded(groupResult);
      return groupResult;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'createGroup');
      rethrow;
    }
  }

  /// 修改群组信息（对齐 Go SDK: API → IncrSyncJoinGroup）
  /// [groupInfo] 群组信息（只更新非null字段）
  Future<void> setGroupInfo({required GroupInfo groupInfo}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.setGroupInfo', {
        'groupInfo': groupInfo.toJson(),
      });
      return;
    }
    _log.info(
      'groupID=${groupInfo.groupID}, groupName=${groupInfo.groupName}',
      methodName: 'setGroupInfo',
    );
    try {
      final resp = await _api.setGroupInfoEx(req: groupInfo.toJson());
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      await _incrSyncJoinGroup();

      final updated = await _database.getGroupByID(groupInfo.groupID);
      if (updated != null) {
        listener?.groupInfoChanged(updated);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setGroupInfo');
      rethrow;
    }
  }

  /// 邀请用户入群（对齐 Go SDK: API → IncrSyncGroupAndMember）
  /// [groupID] 群组ID
  /// [userIDList] 用户ID列表
  /// [reason] 邀请原因
  Future<void> inviteUserToGroup({
    required String groupID,
    required List<String> userIDList,
    String? reason,
  }) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.inviteUserToGroup', {
        'groupID': groupID,
        'userIDList': userIDList,
        'reason': reason,
      });
      return;
    }
    _log.info(
      'groupID=$groupID, userIDList=$userIDList, reason=$reason',
      methodName: 'inviteUserToGroup',
    );
    try {
      final resp = await _api.inviteUserToGroup(
        groupID: groupID,
        invitedUserIDs: userIDList,
        reason: reason,
      );
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      await _incrSyncGroupAndMember(groupID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'inviteUserToGroup');
      rethrow;
    }
  }

  /// 踢出群成员（对齐 Go SDK: API → IncrSyncGroupAndMember）
  /// [groupID] 群组ID
  /// [userIDList] 用户ID列表
  /// [reason] 踢出原因
  Future<void> kickGroupMember({
    required String groupID,
    required List<String> userIDList,
    String? reason,
  }) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.kickGroupMember', {
        'groupID': groupID,
        'userIDList': userIDList,
        'reason': reason,
      });
      return;
    }
    _log.info(
      'groupID=$groupID, userIDList=$userIDList, reason=$reason',
      methodName: 'kickGroupMember',
    );
    try {
      final resp = await _api.kickGroupMember(
        groupID: groupID,
        kickedUserIDs: userIDList,
        reason: reason,
      );
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      await _incrSyncGroupAndMember(groupID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'kickGroupMember');
      rethrow;
    }
  }

  /// 查询群成员信息
  /// [groupID] 群组ID
  /// [userIDList] 用户ID列表
  Future<List<GroupMembersInfo>> getGroupMembersInfo({
    required String groupID,
    required List<String> userIDList,
  }) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.getGroupMembersInfo', {
        'groupID': groupID,
        'userIDList': userIDList,
      });
      return (result as List)
          .map((e) => GroupMembersInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info('groupID=$groupID, userIDList=$userIDList', methodName: 'getGroupMembersInfo');
    try {
      if (userIDList.isEmpty) return [];
      await _ensureGroupMembersSynced(groupID);
      final dbResult = await _database.getGroupMembersByUserIDs(groupID, userIDList);
      if (dbResult.isNotEmpty) return dbResult;

      // DB 回退：从缓存或 API 获取
      final userIDSet = userIDList.toSet();
      final cached = _memberApiCache[groupID];
      if (cached != null && cached.isNotEmpty) {
        return _apiMembersToGroupMembersInfo(
          cached,
        ).where((m) => userIDSet.contains(m.userID)).toList();
      }
      // 直接调用 getGroupMembersInfo API
      final resp = await _api.getGroupMembersInfo(groupID: groupID, userIDs: userIDList);
      if (resp.errCode != 0) return [];
      final members = resp.data?['members'] as List? ?? [];
      return members
          .whereType<Map<String, dynamic>>()
          .map((m) => GroupMembersInfo.fromJson(m))
          .toList();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getGroupMembersInfo');
      rethrow;
    }
  }

  /// 分页获取群成员列表
  /// [groupID] 群组ID
  /// [filter] 成员过滤（0:全部，1:群主，2:管理员，3:普通成员，4:管理员+普通成员，5:群主+管理员）
  /// [offset] 起始索引
  /// [count] 数量
  ///
  /// 对齐 Go SDK GetGroupMemberList：先检查本地是否已同步成员，
  /// 若无则从服务器拉取后再返回本地结果。
  Future<List<GroupMembersInfo>> getGroupMemberList({
    required String groupID,
    int filter = 0,
    int offset = 0,
    int count = 40,
  }) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.getGroupMemberList', {
        'groupID': groupID,
        'filter': filter,
        'offset': offset,
        'count': count,
      });
      return (result as List)
          .map((e) => GroupMembersInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info(
      'groupID=$groupID, filter=$filter, offset=$offset, count=$count',
      methodName: 'getGroupMemberList',
    );
    try {
      await _ensureGroupMembersSynced(groupID);
      final dbResult = await _database.getGroupMembersPage(
        groupID,
        filter: filter,
        offset: offset,
        count: count,
      );
      if (dbResult.isNotEmpty) return dbResult;

      // DB 为空（写入可能失败），直接从 API 获取作为回退
      _log.warning(
        'DB empty after sync for $groupID, falling back to API',
        methodName: 'getGroupMemberList',
      );
      final cached = _memberApiCache[groupID];
      if (cached != null && cached.isNotEmpty) {
        var members = _apiMembersToGroupMembersInfo(cached);
        if (filter > 0) {
          members = members.where((m) => m.roleLevel?.value == filter).toList();
        }
        if (offset > 0 || count < members.length) {
          final end = (offset + count).clamp(0, members.length);
          members = members.sublist(offset.clamp(0, members.length), end);
        }
        return members;
      }

      // 缓存也没有，直接调 API
      final apiMembers = await _fetchMembersFromApi(
        groupID,
        filter: filter,
        offset: offset,
        count: count,
      );
      return apiMembers;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getGroupMemberList');
      rethrow;
    }
  }

  /// 直接从 API 获取群成员（DataFetcher 回退模式）
  Future<List<GroupMembersInfo>> _fetchMembersFromApi(
    String groupID, {
    int filter = 0,
    int offset = 0,
    int count = 40,
  }) async {
    final resp = await _api.getGroupMemberList(
      groupID: groupID,
      offset: offset,
      count: count,
      filter: filter,
    );
    if (resp.errCode != 0) return [];
    final members = resp.data?['members'] as List? ?? [];
    return members
        .whereType<Map<String, dynamic>>()
        .map((m) => GroupMembersInfo.fromJson(m))
        .toList();
  }

  /// 获取群主和管理员列表
  /// [groupID] 群组ID
  Future<List<GroupMembersInfo>> getGroupOwnerAndAdmin({required String groupID}) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.getGroupOwnerAndAdmin', {
        'groupID': groupID,
      });
      return (result as List)
          .map((e) => GroupMembersInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info('groupID=$groupID', methodName: 'getGroupOwnerAndAdmin');
    try {
      await _ensureGroupMembersSynced(groupID);
      final dbResult = await _database.getGroupOwnerAndAdmin(groupID);
      if (dbResult.isNotEmpty) return dbResult;

      // DB 回退：从缓存或 API 获取
      final cached = _memberApiCache[groupID];
      if (cached != null && cached.isNotEmpty) {
        return _apiMembersToGroupMembersInfo(cached)
            .where(
              (m) => m.roleLevel == GroupRoleLevel.admin || m.roleLevel == GroupRoleLevel.owner,
            )
            .toList();
      }
      return await _fetchMembersFromApi(groupID, filter: 0, offset: 0, count: 100).then(
        (all) => all
            .where(
              (m) => m.roleLevel == GroupRoleLevel.admin || m.roleLevel == GroupRoleLevel.owner,
            )
            .toList(),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getGroupOwnerAndAdmin');
      rethrow;
    }
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
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.searchGroupMembers', {
        'groupID': groupID,
        'keywordList': keywordList,
        'isSearchUserID': isSearchUserID,
        'isSearchMemberNickname': isSearchMemberNickname,
        'offset': offset,
        'count': count,
      });
      return (result as List)
          .map((e) => GroupMembersInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info(
      'groupID=$groupID, keywordList=$keywordList, isSearchUserID=$isSearchUserID, isSearchMemberNickname=$isSearchMemberNickname, offset=$offset, count=$count',
      methodName: 'searchGroupMembers',
    );
    try {
      final keyword = keywordList.isNotEmpty ? keywordList.first : '';
      if (keyword.isEmpty) return [];

      await _ensureGroupMembersSynced(groupID);
      return await _database.searchGroupMembers(
        groupID,
        keyword,
        searchUserID: isSearchUserID,
        searchNickname: isSearchMemberNickname,
        offset: offset,
        count: count,
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'searchGroupMembers');
      rethrow;
    }
  }

  /// 修改群成员信息（对齐 Go SDK: API → IncrSyncGroupAndMember）
  /// [groupMembersInfo] 群成员信息
  Future<void> setGroupMemberInfo({required SetGroupMemberInfo groupMembersInfo}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.setGroupMemberInfo', {
        'groupMembersInfo': groupMembersInfo.toJson(),
      });
      return;
    }
    _log.info(
      'groupID=${groupMembersInfo.groupID}, userID=${groupMembersInfo.userID}, nickname=${groupMembersInfo.nickname}, roleLevel=${groupMembersInfo.roleLevel}',
      methodName: 'setGroupMemberInfo',
    );
    try {
      final gid = groupMembersInfo.groupID;
      if (gid.isEmpty || groupMembersInfo.userID.isEmpty) return;

      final resp = await _api.setGroupMemberInfo(req: groupMembersInfo.toJson());
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      await _incrSyncGroupAndMember(gid);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setGroupMemberInfo');
      rethrow;
    }
  }

  /// 转让群主（对齐 Go SDK: API → IncrSyncGroupAndMember）
  /// [groupID] 群组ID
  /// [userID] 新群主用户ID
  Future<void> transferGroupOwner({required String groupID, required String userID}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.transferGroupOwner', {
        'groupID': groupID,
        'userID': userID,
      });
      return;
    }
    _log.info('groupID=$groupID, userID=$userID', methodName: 'transferGroupOwner');
    try {
      final resp = await _api.transferGroup(
        groupID: groupID,
        oldOwnerUserID: _currentUserID,
        newOwnerUserID: userID,
      );
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      await _incrSyncGroupAndMember(groupID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'transferGroupOwner');
      rethrow;
    }
  }

  /// 申请加入群组（对齐 Go SDK: API only, sync via notification）
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
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.joinGroup', {
        'groupID': groupID,
        'reason': reason,
        'joinSource': joinSource,
        'ex': ex,
      });
      return;
    }
    _log.info('groupID=$groupID, reason=$reason, joinSource=$joinSource', methodName: 'joinGroup');
    try {
      final resp = await _api.joinGroup(
        groupID: groupID,
        reqMessage: reason,
        joinSource: joinSource,
        inviterUserID: _currentUserID,
        ex: ex,
      );
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'joinGroup');
      rethrow;
    }
  }

  /// 退出群组（对齐 Go SDK: API → IncrSyncJoinGroup）
  /// [groupID] 群组ID
  Future<void> quitGroup({required String groupID}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.quitGroup', {'groupID': groupID});
      return;
    }
    _log.info('groupID=$groupID', methodName: 'quitGroup');
    try {
      final resp = await _api.quitGroup(userID: _currentUserID, groupID: groupID);
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      await _incrSyncJoinGroup();

      final convID = OpenImUtils.genGroupConversationID(groupID);
      await _database.updateConversation(convID, {'isNotInGroup': true});

      listener?.joinedGroupDeleted(GroupInfo(groupID: groupID));
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'quitGroup');
      rethrow;
    }
  }

  /// 解散群组（对齐 Go SDK: API → IncrSyncJoinGroup）
  /// [groupID] 群组ID
  Future<void> dismissGroup({required String groupID}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.dismissGroup', {'groupID': groupID});
      return;
    }
    _log.info('groupID=$groupID', methodName: 'dismissGroup');
    try {
      final resp = await _api.dismissGroup(groupID: groupID);
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      await _incrSyncJoinGroup();

      final convID = OpenImUtils.genGroupConversationID(groupID);
      await _database.updateConversation(convID, {'isNotInGroup': true});

      listener?.groupDismissed(GroupInfo(groupID: groupID));
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'dismissGroup');
      rethrow;
    }
  }

  /// 群组全员禁言/解除禁言（对齐 Go SDK: API → IncrSyncGroupAndMember）
  /// [groupID] 群组ID
  /// [mute] true:禁言, false:解除禁言
  Future<void> changeGroupMute({required String groupID, required bool mute}) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.changeGroupMute', {
        'groupID': groupID,
        'mute': mute,
      });
      return;
    }
    _log.info('groupID=$groupID, mute=$mute', methodName: 'changeGroupMute');
    try {
      final resp = mute
          ? await _api.muteGroup(groupID: groupID)
          : await _api.cancelMuteGroup(groupID: groupID);
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      await _incrSyncGroupAndMember(groupID);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'changeGroupMute');
      rethrow;
    }
  }

  /// 群成员禁言（对齐 Go SDK: API only）
  /// [groupID] 群组ID
  /// [userID] 被禁言的成员ID
  /// [seconds] 禁言秒数（0为解除禁言）
  Future<void> changeGroupMemberMute({
    required String groupID,
    required String userID,
    int seconds = 0,
  }) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.changeGroupMemberMute', {
        'groupID': groupID,
        'userID': userID,
        'seconds': seconds,
      });
      return;
    }
    _log.info(
      'groupID=$groupID, userID=$userID, seconds=$seconds',
      methodName: 'changeGroupMemberMute',
    );
    try {
      final resp = seconds > 0
          ? await _api.muteGroupMember(groupID: groupID, userID: userID, mutedSeconds: seconds)
          : await _api.cancelMuteGroupMember(groupID: groupID, userID: userID);
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'changeGroupMemberMute');
      rethrow;
    }
  }

  /// 获取收到的入群申请列表（对齐 Go SDK: 从服务器按需获取）
  /// [req] 查询参数
  Future<List<GroupApplicationInfo>> getGroupApplicationListAsRecipient({
    GetGroupApplicationListAsRecipientReq? req,
  }) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke(
        'group.getGroupApplicationListAsRecipient',
        {'req': req?.toJson()},
      );
      return (result as List)
          .map((e) => GroupApplicationInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info(
      'offset=${req?.offset}, count=${req?.count}',
      methodName: 'getGroupApplicationListAsRecipient',
    );
    try {
      final offset = req?.offset ?? 0;
      final count = req?.count ?? 40;
      final resp = await _api.getRecvGroupApplicationList(
        userID: _currentUserID,
        offset: offset,
        count: count,
      );
      if (resp.errCode != 0) return [];
      final list = resp.data?['groupRequests'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => _serverGroupRequestToLocal(e))
          .toList();
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'getGroupApplicationListAsRecipient',
      );
      rethrow;
    }
  }

  /// 获取已发送的入群申请列表（对齐 Go SDK: 从服务器按需获取）
  /// [req] 查询参数
  Future<List<GroupApplicationInfo>> getGroupApplicationListAsApplicant({
    GetGroupApplicationListAsApplicantReq? req,
  }) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke(
        'group.getGroupApplicationListAsApplicant',
        {'req': req?.toJson()},
      );
      return (result as List)
          .map((e) => GroupApplicationInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info(
      'offset=${req?.offset}, count=${req?.count}',
      methodName: 'getGroupApplicationListAsApplicant',
    );
    try {
      final offset = req?.offset ?? 0;
      final count = req?.count ?? 40;
      final resp = await _api.getSendGroupApplicationList(
        userID: _currentUserID,
        offset: offset,
        count: count,
      );
      if (resp.errCode != 0) return [];
      final list = resp.data?['groupRequests'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => _serverGroupRequestToLocal(e))
          .toList();
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'getGroupApplicationListAsApplicant',
      );
      rethrow;
    }
  }

  /// 接受入群申请（对齐 Go SDK: API only）
  /// [groupID] 群组ID
  /// [userID] 申请者用户ID
  /// [handleMsg] 处理消息
  Future<void> acceptGroupApplication({
    required String groupID,
    required String userID,
    String? handleMsg,
  }) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.acceptGroupApplication', {
        'groupID': groupID,
        'userID': userID,
        'handleMsg': handleMsg,
      });
      return;
    }
    _log.info(
      'groupID=$groupID, userID=$userID, handleMsg=$handleMsg',
      methodName: 'acceptGroupApplication',
    );
    try {
      final resp = await _api.groupApplicationResponse(
        groupID: groupID,
        fromUserID: userID,
        handledMsg: handleMsg ?? '',
        handleResult: 1,
      );
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'acceptGroupApplication');
      rethrow;
    }
  }

  /// 拒绝入群申请（对齐 Go SDK: API only）
  /// [groupID] 群组ID
  /// [userID] 申请者用户ID
  /// [handleMsg] 拒绝原因
  Future<void> refuseGroupApplication({
    required String groupID,
    required String userID,
    String? handleMsg,
  }) async {
    if (SdkIsolateManager.isActive) {
      await SdkIsolateManager.instance.invoke('group.refuseGroupApplication', {
        'groupID': groupID,
        'userID': userID,
        'handleMsg': handleMsg,
      });
      return;
    }
    _log.info(
      'groupID=$groupID, userID=$userID, handleMsg=$handleMsg',
      methodName: 'refuseGroupApplication',
    );
    try {
      final resp = await _api.groupApplicationResponse(
        groupID: groupID,
        fromUserID: userID,
        handledMsg: handleMsg ?? '',
        handleResult: -1,
      );
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'refuseGroupApplication');
      rethrow;
    }
  }

  /// 获取未处理的入群申请数量（对齐 Go SDK: 从服务器获取）
  /// [req] 查询参数
  Future<int> getGroupApplicationUnhandledCount(GetGroupApplicationUnhandledCountReq req) async {
    if (SdkIsolateManager.isActive) {
      return await SdkIsolateManager.instance.invoke('group.getGroupApplicationUnhandledCount', {
            'req': req.toJson(),
          })
          as int;
    }
    _log.info('called', methodName: 'getGroupApplicationUnhandledCount');
    try {
      final resp = await _api.getGroupApplicationUnhandledCount(
        userID: _currentUserID,
        time: req.time,
      );
      if (resp.errCode != 0) return 0;
      return (resp.data?['count'] as num?)?.toInt() ?? 0;
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

  /// 搜索群组
  /// [keywordList] 搜索关键字
  /// [isSearchGroupID] 是否搜索群组ID
  /// [isSearchGroupName] 是否搜索群名
  Future<List<GroupInfo>> searchGroups({
    List<String> keywordList = const [],
    bool isSearchGroupID = false,
    bool isSearchGroupName = false,
  }) async {
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.searchGroups', {
        'keywordList': keywordList,
        'isSearchGroupID': isSearchGroupID,
        'isSearchGroupName': isSearchGroupName,
      });
      return (result as List)
          .map((e) => GroupInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info(
      'keywordList=$keywordList, isSearchGroupID=$isSearchGroupID, isSearchGroupName=$isSearchGroupName',
      methodName: 'searchGroups',
    );
    try {
      final keyword = keywordList.isNotEmpty ? keywordList.first : '';
      if (keyword.isEmpty) return [];

      return await _database.searchGroups(
        keyword,
        searchGroupID: isSearchGroupID,
        searchGroupName: isSearchGroupName,
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'searchGroups');
      rethrow;
    }
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
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.getGroupMemberListByJoinTime', {
        'groupID': groupID,
        'offset': offset,
        'count': count,
        'joinTimeBegin': joinTimeBegin,
        'joinTimeEnd': joinTimeEnd,
        'filterUserIDList': filterUserIDList,
      });
      return (result as List)
          .map((e) => GroupMembersInfo.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
    _log.info(
      'groupID=$groupID, offset=$offset, count=$count, joinTimeBegin=$joinTimeBegin, joinTimeEnd=$joinTimeEnd, filterUserIDList=$filterUserIDList',
      methodName: 'getGroupMemberListByJoinTime',
    );
    try {
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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getGroupMemberListByJoinTime');
      rethrow;
    }
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
    if (SdkIsolateManager.isActive) {
      final result = await SdkIsolateManager.instance.invoke('group.getUsersInGroup', {
        'groupID': groupID,
        'userIDList': userIDList,
      });
      return (result as List).cast<String>();
    }
    _log.info('groupID=$groupID, userIDList=$userIDList', methodName: 'getUsersInGroup');
    try {
      if (userIDList.isEmpty) return [];

      final members = await _database.getGroupMembersByUserIDs(groupID, userIDList);
      return members.map((m) => m.userID ?? '').where((id) => id.isNotEmpty).toList();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getUsersInGroup');
      rethrow;
    }
  }
}
