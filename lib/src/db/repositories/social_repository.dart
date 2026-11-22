import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../../models/favorite_item.dart';
import '../../models/moment_info.dart';
import '../db_schema.dart';

/// 社交扩展领域仓储（朋友圈 `local_moments`、收藏夹 `local_favorites`、已领取红包 `local_grabbed_red_packets`）。
final class SocialRepository extends BaseRepository<MomentInfo> {
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

  /// 设置Current用户ID。
  ///
  /// Set current user ID.
  ///
  /// - [userID] 用户ID / User ID.
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  /// 从行数据。
  ///
  /// From row.
  ///
  /// - [row] 行数据 / Row.
  /// - Returns: `MomentInfo` 结果 / Resulting `MomentInfo`.
  @override
  MomentInfo fromRow(Map<String, dynamic> row) => MomentInfo.fromJson(row);

  // ---- Moments ----

  /// 写入或更新朋友圈动态。
  ///
  /// Upsert moment.
  ///
  /// - [moment] 朋友圈动态 / Moment.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> upsertMoment(MomentInfo moment) => upsertRow(moment.toJson());

  /// 批量写入或更新朋友圈动态列表。
  ///
  /// Batch upsert moments.
  ///
  /// - [moments] 朋友圈动态列表 / Moments.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> batchUpsertMoments(List<MomentInfo> moments) =>
      batchUpsertRows(moments.map<Map<String, dynamic>>((MomentInfo m) => m.toJson()).toList());

  /// 获取朋友圈动态列表。
  ///
  /// Get moments.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<MomentInfo>>` 列表结果 / Resulting `Future<List<MomentInfo>>` list.
  Future<List<MomentInfo>> getMoments({int offset = 0, int count = 20}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localMoment)
        .orderByDesc('createTime')
        .limit(count)
        .offset(offset);
    return result.data.map<MomentInfo>(fromRow).toList();
  }

  /// 获取朋友圈动态列表按用户ID。
  ///
  /// Get moments by user ID.
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
        .orderByDesc('createTime')
        .limit(count)
        .offset(offset);
    return result.data.map<MomentInfo>(fromRow).toList();
  }

  /// 获取朋友圈动态ByID。
  ///
  /// Get moment by ID.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - Returns: `Future<MomentInfo?>` 结果 / Resulting `Future<MomentInfo?>`.
  Future<MomentInfo?> getMomentByID(String momentID) => findByPrimaryKey(momentID);

  /// 删除朋友圈动态。
  ///
  /// Delete moment.
  ///
  /// - [momentID] 朋友圈动态ID / Moment ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteMoment(String momentID) => deleteByPrimaryKey(momentID);

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
  /// Get grabbed red packet i ds.
  ///
  /// - [packetIDs] 包ID 列表 / Packet i ds.
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
