import 'dart:convert';

import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../../models/favorite_item.dart';
import '../../models/moment_comment.dart';
import '../../models/moment_info.dart';
import '../../models/moment_like.dart';
import '../../models/moment_media.dart';
import '../db_schema.dart';

/// 社交扩展领域仓储（朋友圈 `local_moments`、收藏夹 `local_favorites`、已领取红包 `local_grabbed_red_packets`）。
final class SocialRepository extends BaseRepository<MomentInfo> {
  static const String _momentsSyncSeqKey = 'moments_sync_seq';
  static const String _momentsOldestSeqKey = 'moments_oldest_seq';
  static const String _momentsHasMoreHistoryKey = 'moments_has_more_history';

  String _currentUserID = '';

  /// 创建 `SocialRepository` 实例。
  ///
  /// Creates a `SocialRepository` instance.
  ///
  /// - [store] 存储 / Store.
  SocialRepository({required super.store})
    : super(
        tableName: DbTableName.localMoment,
        primaryKeyName: 'momentID',
        name: 'SocialRepository',
      );

  /// 设置当前登录用户ID。
  ///
  /// Sets the current logged-in user ID.
  ///
  /// - [userID] 用户ID / User ID.
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  /// 将数据库行映射为 [MomentInfo]。
  ///
  /// Maps a database row to [MomentInfo].
  ///
  /// - [row] 行数据 / Row.
  /// - Returns: `MomentInfo` 结果 / Resulting `MomentInfo`.
  @override
  MomentInfo fromRow(Map<String, dynamic> row) => MomentInfo.fromJson(row);

  Map<String, dynamic> _toMomentDbRow(MomentInfo moment) {
    return <String, dynamic>{
      'momentID': moment.momentID,
      'userID': moment.userID,
      'content': moment.content,
      'media': jsonEncode(moment.media.map((MomentMedia item) => item.toJson()).toList()),
      'visibleType': moment.visibleType.value,
      'visibleGroupIDs': jsonEncode(moment.visibleGroupIDs),
      'status': moment.status,
      'createTime': moment.createTime,
      'createTimeMs': moment.createTimeMs,
      'updateTime': moment.updateTime,
      'likeCount': moment.likeCount,
      'commentCount': moment.commentCount,
      'extra': moment.extra,
      'likes': moment.likes.map((MomentLikeWithUser item) => item.toJson()).toList(),
      'comments': moment.comments.map((MomentCommentWithUser item) => item.toJson()).toList(),
      'timelineSeq': moment.timelineSeq,
      'updateSeq': moment.updateSeq,
      if (moment.userInfo != null) 'userInfo': jsonEncode(moment.userInfo!.toJson()),
    };
  }

  // ---- Moments ----

  /// 写入或更新朋友圈动态。
  ///
  /// Upserts a single moment record.
  ///
  /// - [moment] 朋友圈动态 / Moment.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> upsertMoment(MomentInfo moment) => upsertRow(_toMomentDbRow(moment));

  /// 批量写入或更新朋友圈动态列表。
  ///
  /// Batch-upserts multiple moment records.
  ///
  /// - [moments] 朋友圈动态列表 / Moments.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> batchUpsertMoments(List<MomentInfo> moments) =>
      batchUpsertRows(moments.map<Map<String, dynamic>>(_toMomentDbRow).toList());

  /// 按严格时间线序号（`timelineSeq DESC, createTimeMs DESC`）游标查询本地朋友圈缓存。
  ///
  /// Queries cached moments strictly ordered by `timelineSeq DESC, createTimeMs DESC`.
  ///
  /// - [ownerUserID] 可选发布者用户ID，不传则查询全局可见时间线 / Optional author user ID filter.
  /// - [beforeSeq] 游标序号，`> 0` 时仅返回 `timelineSeq < beforeSeq` 的历史动态 / Exclusive upper-bound cursor.
  /// - [limit] 返回条数上限 / Maximum number of records to return.
  /// - Returns: 按时序严格降序排列的动态列表 / Strictly ordered list of moments.
  Future<List<MomentInfo>> getMomentsTimeline({
    String? ownerUserID,
    int beforeSeq = 0,
    int limit = 20,
  }) async {
    QueryBuilder query = store.query(DbTableName.localMoment);
    if (ownerUserID != null && ownerUserID.isNotEmpty) {
      query = query.whereEqual('userID', ownerUserID);
    }
    if (beforeSeq > 0) {
      query = query.whereLessThanOrEqualTo('timelineSeq', beforeSeq - 1);
    }
    final QueryResult<Map<String, dynamic>> result = await query
        .orderByDesc('timelineSeq')
        .orderByDesc('createTimeMs')
        .limit(limit);
    return result.data.map<MomentInfo>(fromRow).toList();
  }

  /// 获取本地朋友圈动态列表（按时间线序号严格降序）。
  ///
  /// Gets local moments ordered by `timelineSeq DESC, createTimeMs DESC`.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<MomentInfo>>` 列表结果 / Resulting `Future<List<MomentInfo>>` list.
  Future<List<MomentInfo>> getMoments({int offset = 0, int count = 20}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localMoment)
        .orderByDesc('timelineSeq')
        .orderByDesc('createTimeMs')
        .limit(count)
        .offset(offset);
    return result.data.map<MomentInfo>(fromRow).toList();
  }

  /// 按发布者用户ID获取本地朋友圈动态列表（按时间线序号严格降序）。
  ///
  /// Gets local moments authored by [userID] ordered by `timelineSeq DESC, createTimeMs DESC`.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<MomentInfo>>` 列表结果 / Resulting `Future<List<MomentInfo>>` list.
  Future<List<MomentInfo>> getMomentsByUserID(
    String userID, {
    int offset = 0,
    int count = 20,
  }) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localMoment)
        .whereEqual('userID', userID)
        .orderByDesc('timelineSeq')
        .orderByDesc('createTimeMs')
        .limit(count)
        .offset(offset);
    return result.data.map<MomentInfo>(fromRow).toList();
  }

  /// 按ID获取单条本地朋友圈动态。
  ///
  /// Gets a single cached moment by its ID.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - Returns: `Future<MomentInfo?>` 结果 / Resulting `Future<MomentInfo?>`.
  Future<MomentInfo?> getMomentByID(String momentID) => findByPrimaryKey(momentID);

  /// 删除单条本地朋友圈动态。
  ///
  /// Deletes a single cached moment by its ID.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteMoment(String momentID) => deleteByPrimaryKey(momentID);

  /// 批量删除本地朋友圈动态。
  ///
  /// Batch-deletes cached moments matching [momentIDs].
  ///
  /// - [momentIDs] 待删除动态ID列表 / List of moment IDs to delete.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteMomentsByIDs(List<String> momentIDs) async {
    if (momentIDs.isEmpty) {
      return DbResult.success(message: 'Empty');
    }
    final DbResult result = await store
        .delete(DbTableName.localMoment)
        .whereIn('momentID', momentIDs);
    logIfErrors('deleteMomentsByIDs', result);
    return result;
  }

  /// 清空当前用户空间的本地朋友圈动态缓存。
  ///
  /// Clears all cached moments in the current user space.
  ///
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> clearMoments() async {
    final QueryResult<Map<String, dynamic>> rows = await store
        .query(DbTableName.localMoment)
        .select(<String>['momentID']);
    final List<String> ids = rows.data
        .map<String?>((Map<String, dynamic> row) => row['momentID']?.toString())
        .whereType<String>()
        .where((String id) => id.isNotEmpty)
        .toList();
    return deleteMomentsByIDs(ids);
  }

  /// 读取当前用户空间的朋友圈增量同步游标（`syncSeq`）。
  ///
  /// Reads the persisted moments incremental sync cursor (`syncSeq`).
  Future<int> getMomentsSyncSeq() async {
    final dynamic raw = await store.kv.get(_momentsSyncSeqKey, isGlobal: false);
    return _toInt(raw) ?? 0;
  }

  /// 持久化当前用户空间的朋友圈增量同步游标（`syncSeq`）。
  ///
  /// Persists the moments incremental sync cursor (`syncSeq`).
  Future<void> setMomentsSyncSeq(int seq) async {
    await store.kv.set(_momentsSyncSeqKey, seq, isGlobal: false);
  }

  /// 读取本地缓存中最旧动态的 `timelineSeq`。
  ///
  /// Reads the oldest cached `timelineSeq` in the local timeline window.
  Future<int> getMomentsOldestSeq() async {
    final dynamic raw = await store.kv.get(_momentsOldestSeqKey, isGlobal: false);
    return _toInt(raw) ?? 0;
  }

  /// 持久化本地缓存中最旧动态的 `timelineSeq`。
  ///
  /// Persists the oldest cached `timelineSeq`.
  Future<void> setMomentsOldestSeq(int seq) async {
    await store.kv.set(_momentsOldestSeqKey, seq, isGlobal: false);
  }

  /// 读取服务端是否仍有更早的历史朋友圈动态。
  ///
  /// Reads whether older moments remain available on the server.
  Future<bool> getMomentsHasMoreHistory() async {
    final dynamic raw = await store.kv.get(_momentsHasMoreHistoryKey, isGlobal: false);
    if (raw is bool) {
      return raw;
    }
    if (raw is String) {
      return raw == 'true';
    }
    return true;
  }

  /// 持久化服务端是否仍有更早的历史朋友圈动态标记。
  ///
  /// Persists whether older moments remain available on the server.
  Future<void> setMomentsHasMoreHistory(bool hasMore) async {
    await store.kv.set(_momentsHasMoreHistoryKey, hasMore, isGlobal: false);
  }

  /// 重置当前用户空间的朋友圈同步水位元数据。
  ///
  /// Resets moments sync cursor metadata for the current user space.
  Future<void> resetMomentsSyncState() async {
    await store.kv.remove(_momentsSyncSeqKey, isGlobal: false);
    await store.kv.remove(_momentsOldestSeqKey, isGlobal: false);
    await store.kv.remove(_momentsHasMoreHistoryKey, isGlobal: false);
  }

  // ---- Favorites ----

  /// 写入或更新收藏。
  ///
  /// Upsert favorite.
  ///
  /// - [item] item / Item.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> upsertFavorite(FavoriteItem item) async {
    final DbResult result = await store.upsert(DbTableName.localFavorite, item.toJson());
    logIfErrors('upsertFavorite', result);
    return result;
  }

  /// 批量写入或更新收藏列表。
  ///
  /// Batch upsert favorites.
  ///
  /// - [items] items / Items.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> batchUpsertFavorites(List<FavoriteItem> items) async {
    if (items.isEmpty) {
      return DbResult.success(message: 'Empty');
    }
    final DbResult result = await store.batchUpsert(
      DbTableName.localFavorite,
      items.map<Map<String, dynamic>>((FavoriteItem f) => f.toJson()).toList(),
      allowPartialErrors: true,
    );
    logIfErrors('batchUpsertFavorites', result);
    return result;
  }

  /// 获取收藏列表。
  ///
  /// Get favorites.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<FavoriteItem>>` 列表结果 / Resulting `Future<List<FavoriteItem>>` list.
  Future<List<FavoriteItem>> getFavorites({int offset = 0, int count = 20}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localFavorite)
        .whereEqual('userID', _currentUserID)
        .orderByDesc('createTime')
        .limit(count)
        .offset(offset);
    return result.data.map<FavoriteItem>(FavoriteItem.fromJson).toList();
  }

  /// 获取收藏按目标。
  ///
  /// Get favorite by target.
  ///
  /// - [targetType] 目标类型 / Target type.
  /// - [targetID] 目标ID / Target ID.
  /// - Returns: `Future<FavoriteItem?>` 结果 / Resulting `Future<FavoriteItem?>`.
  Future<FavoriteItem?> getFavoriteByTarget(String targetType, String targetID) async {
    final Map<String, dynamic>? row = await store
        .query(DbTableName.localFavorite)
        .whereEqual('userID', _currentUserID)
        .whereEqual('targetType', targetType)
        .whereEqual('targetID', targetID)
        .first();
    return row != null ? FavoriteItem.fromJson(row) : null;
  }

  /// 删除收藏按目标。
  ///
  /// Delete favorite by target.
  ///
  /// - [targetType] 目标类型 / Target type.
  /// - [targetID] 目标ID / Target ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteFavoriteByTarget(String targetType, String targetID) async {
    final DbResult result = await store
        .delete(DbTableName.localFavorite)
        .whereEqual('userID', _currentUserID)
        .whereEqual('targetType', targetType)
        .whereEqual('targetID', targetID);
    logIfErrors('deleteFavoriteByTarget($targetType,$targetID)', result);
    return result;
  }

  // ---- Grabbed RedPacket (使用 .exists() 短路判断与列裁剪) ----

  /// 标记红包已领取。
  ///
  /// Mark red packet grabbed.
  ///
  /// - [packetID] 包ID / Packet ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> markRedPacketGrabbed(String packetID) async {
    final DbResult result = await store.upsert(DbTableName.localGrabbedRedPacket, <String, dynamic>{
      'packetID': packetID,
      'grabTime': DateTime.now().millisecondsSinceEpoch,
    });
    logIfErrors('markRedPacketGrabbed($packetID)', result);
    return result;
  }

  /// 是否红包已领取。
  ///
  /// Whether red packet grabbed.
  ///
  /// - [packetID] 包ID / Packet ID.
  /// - Returns: 操作结果布尔值 / Boolean result.
  Future<bool> isRedPacketGrabbed(String packetID) {
    final QueryBuilder query = store
        .query(DbTableName.localGrabbedRedPacket)
        .whereEqual('packetID', packetID);
    if (query.peekExists()) {
      return Future<bool>.value(true);
    }
    return query.exists();
  }

  /// 获取已领取红包ID 列表。
  ///
  /// Get grabbed red packet IDs.
  ///
  /// - [packetIDs] 包ID 列表 / Packet IDs.
  /// - Returns: `Future<Set<String>>` 结果 / Resulting `Future<Set<String>>`.
  Future<Set<String>> getGrabbedRedPacketIDs(List<String> packetIDs) async {
    if (packetIDs.isEmpty) {
      return <String>{};
    }
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localGrabbedRedPacket)
        .whereIn('packetID', packetIDs)
        .select(<String>['packetID']);
    return result.data
        .map<String?>((Map<String, dynamic> r) => r['packetID'] as String?)
        .whereType<String>()
        .toSet();
  }
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
