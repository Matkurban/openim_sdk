import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../../models/favorite_item.dart';
import '../../models/moment_info.dart';
import '../db_schema.dart';

/// 社交扩展领域仓储（朋友圈 `local_moments`、收藏夹 `local_favorites`、已领取红包 `local_grabbed_red_packets`）。
final class SocialRepository extends BaseRepository<MomentInfo> {
  String _currentUserID = '';

  SocialRepository({required super.store})
    : super(
        tableName: DbTableName.localMoment,
        primaryKeyName: 'momentID',
        name: 'SocialRepository',
      );

  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  @override
  MomentInfo fromRow(Map<String, dynamic> row) => MomentInfo.fromJson(row);

  // ---- Moments ----

  Future<DbResult> upsertMoment(MomentInfo moment) => upsertRow(moment.toJson());

  Future<DbResult> batchUpsertMoments(List<MomentInfo> moments) =>
      batchUpsertRows(moments.map<Map<String, dynamic>>((MomentInfo m) => m.toJson()).toList());

  Future<List<MomentInfo>> getMoments({int offset = 0, int count = 20}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localMoment)
        .orderByDesc('createTime')
        .limit(count)
        .offset(offset);
    return result.data.map<MomentInfo>(fromRow).toList();
  }

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

  Future<MomentInfo?> getMomentByID(String momentID) => findByPrimaryKey(momentID);

  Future<DbResult> deleteMoment(String momentID) => deleteByPrimaryKey(momentID);

  // ---- Favorites ----

  Future<DbResult> upsertFavorite(FavoriteItem item) async {
    final DbResult result = await store.upsert(DbTableName.localFavorite, item.toJson());
    logIfErrors('upsertFavorite', result);
    return result;
  }

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

  Future<List<FavoriteItem>> getFavorites({int offset = 0, int count = 20}) async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localFavorite)
        .whereEqual('userID', _currentUserID)
        .orderByDesc('createTime')
        .limit(count)
        .offset(offset);
    return result.data.map<FavoriteItem>(FavoriteItem.fromJson).toList();
  }

  Future<FavoriteItem?> getFavoriteByTarget(String targetType, String targetID) async {
    final Map<String, dynamic>? row = await store
        .query(DbTableName.localFavorite)
        .whereEqual('userID', _currentUserID)
        .whereEqual('targetType', targetType)
        .whereEqual('targetID', targetID)
        .first();
    return row != null ? FavoriteItem.fromJson(row) : null;
  }

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

  Future<DbResult> markRedPacketGrabbed(String packetID) async {
    final DbResult result = await store.upsert(DbTableName.localGrabbedRedPacket, <String, dynamic>{
      'packetID': packetID,
      'grabTime': DateTime.now().millisecondsSinceEpoch,
    });
    logIfErrors('markRedPacketGrabbed($packetID)', result);
    return result;
  }

  Future<bool> isRedPacketGrabbed(String packetID) {
    final QueryBuilder query = store
        .query(DbTableName.localGrabbedRedPacket)
        .whereEqual('packetID', packetID);
    if (query.peekExists()) {
      return Future<bool>.value(true);
    }
    return query.exists();
  }

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
