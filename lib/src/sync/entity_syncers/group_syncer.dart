import '../../api/group_api.dart';
import '../../core/base_syncer.dart';
import '../../db/db_engine.dart';
import '../../models/api_response.dart';

/// 群组与群成员增量/全量同步器（继承 [BaseSyncer]）。
///
/// 使用事务级 `replaceGroupMembers` 保证全量替换原子性，
/// 并移除原 `msg_syncer.dart:1110` 生产环境的调试验证查询（修复 B-27）。
final class GroupSyncer extends BaseSyncer {
  /// 数据库。
  ///
  /// Database.
  final DbEngine db;

  /// 群组API。
  ///
  /// Group API.
  final GroupApi groupApi;

  /// 创建 `GroupSyncer` 实例。
  ///
  /// Creates a `GroupSyncer` instance.
  ///
  /// - [db] 数据库 / Database.
  /// - [groupApi] 群组API / Group API.
  GroupSyncer({required this.db, required this.groupApi}) : super('GroupSyncer');

  /// 同步数据表名称。
  ///
  /// Sync table name.
  @override
  String get syncTableName => 'groups';

  /// 读取本地版本。
  ///
  /// Read local version.
  ///
  /// - [entityID] 实体ID / Entity ID.
  /// - Returns: `Future<({int version, String versionID})>` 结果 / Resulting `Future<({int version, String versionID})>`.
  @override
  Future<({int version, String versionID})> readLocalVersion(String entityID) async {
    final Map<String, dynamic>? row = await db.syncMeta.getVersionSync(syncTableName, entityID);
    return (
      version: (row?['version'] as num?)?.toInt() ?? 0,
      versionID: row?['versionID']?.toString() ?? '',
    );
  }

  /// 保存本地版本。
  ///
  /// Save local version.
  ///
  /// - [entityID] 实体ID / Entity ID.
  /// - [version] 版本 / Version.
  /// - [versionID] 版本ID / Version ID.
  @override
  Future<void> saveLocalVersion(
    String entityID, {
    required int version,
    required String versionID,
  }) async {
    await db.syncMeta.setVersionSync(
      tableName: syncTableName,
      entityID: entityID,
      versionID: versionID,
      version: version,
      uidList: const <String>[],
    );
  }

  /// 拉取增量。
  ///
  /// Fetch incremental.
  ///
  /// - [entityID] 实体ID / Entity ID.
  /// - [version] 版本 / Version.
  /// - [versionID] 版本ID / Version ID.
  /// - Returns: `Future<IncrementalSyncResponse?>` 结果 / Resulting `Future<IncrementalSyncResponse?>`.
  @override
  Future<IncrementalSyncResponse?> fetchIncremental({
    required String entityID,
    required int version,
    required String versionID,
  }) async {
    final ApiResponse resp = await groupApi.getIncrementalJoinGroup(
      req: <String, dynamic>{'userID': entityID, 'version': version, 'versionID': versionID},
    );
    if (resp.errCode != 0) {
      logger.warning('getIncrementalJoinGroup failed: ${resp.errMsg}');
      return null;
    }
    final Map<String, dynamic> data = resp.data as Map<String, dynamic>? ?? <String, dynamic>{};
    return IncrementalSyncResponse(
      isFull: data['full'] as bool? ?? false,
      versionID: data['versionID']?.toString() ?? versionID,
      version: (data['version'] as num?)?.toInt() ?? version,
      deleteIDs: (data['delete'] as List<dynamic>?)?.cast<String>() ?? const <String>[],
      insertItems: ((data['insert'] as List<dynamic>?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .toList(),
      updateItems: ((data['update'] as List<dynamic>?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .toList(),
    );
  }

  /// apply增量。
  ///
  /// Apply incremental.
  ///
  /// - [entityID] 实体ID / Entity ID.
  /// - [deleteIDs] 删除ID 列表 / Delete i ds.
  /// - [insertItems] 插入Items / Insert items.
  /// - [updateItems] 更新Items / Update items.
  @override
  Future<void> applyIncremental({
    required String entityID,
    required List<String> deleteIDs,
    required List<Map<String, dynamic>> insertItems,
    required List<Map<String, dynamic>> updateItems,
  }) async {
    for (final String groupID in deleteIDs) {
      await db.groups.deleteGroup(groupID);
      await db.groups.deleteGroupAllMembers(groupID);
    }

    if (insertItems.isNotEmpty) {
      await db.groups.batchUpsertGroups(insertItems);
      await Future.wait<void>(
        insertItems
            .map<String?>((Map<String, dynamic> g) => g['groupID']?.toString())
            .whereType<String>()
            .where((String gid) => gid.isNotEmpty)
            .map<Future<void>>(syncGroupMembers),
      );
    }

    if (updateItems.isNotEmpty) {
      await db.groups.batchUpsertGroups(updateItems);
    }
  }

  /// 同步全量。
  ///
  /// Sync full.
  ///
  /// - [entityID] 实体ID / Entity ID.
  @override
  Future<void> syncFull(String entityID) async {
    int pageNumber = 1;
    const int pageSize = 100;
    final List<Map<String, dynamic>> allGroups = <Map<String, dynamic>>[];
    while (true) {
      final ApiResponse resp = await groupApi.getJoinedGroupList(
        fromUserID: entityID,
        offset: (pageNumber - 1) * pageSize,
        count: pageSize,
      );
      if (resp.errCode != 0) {
        break;
      }
      final List<dynamic> groups = resp.data?['groups'] as List<dynamic>? ?? const <dynamic>[];
      if (groups.isEmpty) {
        break;
      }
      for (final dynamic g in groups) {
        if (g is Map<String, dynamic>) {
          allGroups.add(g);
        }
      }
      if (groups.length < pageSize) {
        break;
      }
      pageNumber++;
    }
    if (allGroups.isNotEmpty) {
      await db.groups.batchUpsertGroups(allGroups);
    }
    for (final Map<String, dynamic> group in allGroups) {
      final String? groupID = group['groupID'] as String?;
      if (groupID != null && groupID.isNotEmpty) {
        await syncGroupMembers(groupID);
      }
    }
    await db.syncMeta.deleteVersionSync(syncTableName, entityID);
    logger.info('syncFull completed: ${allGroups.length} groups');
  }

  /// 全量拉取指定群成员并在原子事务内替换本地缓存。
  ///
  /// Sync group members.
  ///
  /// - [groupID] 群组ID / Group ID.
  Future<void> syncGroupMembers(String groupID) async {
    try {
      int offset = 0;
      const int pageSize = 100;
      final List<Map<String, dynamic>> allMembers = <Map<String, dynamic>>[];
      while (true) {
        final ApiResponse resp = await groupApi.getGroupMemberList(
          groupID: groupID,
          offset: offset,
          count: pageSize,
        );
        if (resp.errCode != 0) {
          logger.warning('getGroupMemberList($groupID) error: ${resp.errCode} ${resp.errMsg}');
          break;
        }
        final List<dynamic> members = resp.data?['members'] as List<dynamic>? ?? const <dynamic>[];
        if (members.isEmpty) {
          break;
        }
        for (final dynamic m in members) {
          if (m is Map<String, dynamic>) {
            allMembers.add(m);
          }
        }
        if (members.length < pageSize) {
          break;
        }
        offset += pageSize;
      }
      if (allMembers.isNotEmpty) {
        await db.groups.replaceGroupMembers(groupID, allMembers);
      }
    } on Object catch (error, stackTrace) {
      logger.severe('syncGroupMembers($groupID) failed', error, stackTrace);
    }
  }

  /// 同步单个群组信息及其成员。
  ///
  /// Sync group info and members.
  ///
  /// - [groupID] 群组ID / Group ID.
  Future<void> syncGroupInfoAndMembers(String groupID) async {
    final ApiResponse resp = await groupApi.getGroupsInfo(groupIDs: <String>[groupID]);
    if (resp.errCode == 0) {
      final List<dynamic> groupInfos =
          resp.data?['groupInfos'] as List<dynamic>? ?? const <dynamic>[];
      final List<Map<String, dynamic>> maps = groupInfos.whereType<Map<String, dynamic>>().toList();
      if (maps.isNotEmpty) {
        await db.groups.batchUpsertGroups(maps);
      }
    }
    await syncGroupMembers(groupID);
  }
}
