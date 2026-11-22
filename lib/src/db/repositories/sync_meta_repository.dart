import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../db_schema.dart';

/// 同步元数据与辅助表仓储：
/// - `local_version_sync`（O(1) 复合主键 `id = '${tableName}_$entityID'`）
/// - `local_notification_seqs`
/// - `local_uploads`（高频断点续传进度，使用 `RecoveryDurability.async` 提升吞吐）
/// - `local_sending_messages`
final class SyncMetaRepository extends BaseRepository<Map<String, dynamic>> {
  SyncMetaRepository({required super.store})
    : super(
        tableName: DbTableName.localVersionSync,
        primaryKeyName: 'id',
        name: 'SyncMetaRepository',
      );

  @override
  Map<String, dynamic> fromRow(Map<String, dynamic> row) => row;

  // ---- VersionSync (O(1) 复合主键，彻底移除 3.0.8 绕过代码) ----

  Future<Map<String, dynamic>?> getVersionSync(String tableName, String entityID) {
    return findByPrimaryKey(DbSchema.compositeKey(tableName, entityID));
  }

  Future<DbResult> setVersionSync({
    required String tableName,
    required String entityID,
    String? versionID,
    int? version,
    List<String>? uidList,
  }) {
    return upsertRow(<String, dynamic>{
      'id': DbSchema.compositeKey(tableName, entityID),
      'tableName': tableName,
      'entityID': entityID,
      'versionID': versionID,
      'version': version,
      'uidList': uidList,
      'updateTime': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<DbResult> deleteVersionSync(String tableName, String entityID) {
    return deleteByPrimaryKey(DbSchema.compositeKey(tableName, entityID));
  }

  // ---- NotificationSeq ----

  Future<DbResult> upsertNotificationSeq(String conversationID, int seq) async {
    final DbResult result = await store.upsert(DbTableName.localNotificationSeq, <String, dynamic>{
      'conversationID': conversationID,
      'seq': seq,
      'updateTime': DateTime.now().millisecondsSinceEpoch,
    });
    logIfErrors('upsertNotificationSeq($conversationID)', result);
    return result;
  }

  Future<Map<String, int>> getAllNotificationSeqs() async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localNotificationSeq)
        .select(<String>['conversationID', 'seq'])
        .limit(5000);
    final Map<String, int> map = <String, int>{};
    for (final Map<String, dynamic> row in result.data) {
      final String? conversationID = row['conversationID'] as String?;
      if (conversationID != null) {
        map[conversationID] = (row['seq'] as num?)?.toInt() ?? 0;
      }
    }
    return map;
  }

  // ---- Upload Tasks (高频续传状态使用 async durability 提速) ----

  Future<DbResult> upsertUploadTask(Map<String, dynamic> data) async {
    final DbResult result = await store.upsert(
      DbTableName.localUpload,
      data,
      durability: RecoveryDurability.async,
    );
    logIfErrors('upsertUploadTask', result);
    return result;
  }

  Future<Map<String, dynamic>?> getUploadTask(String uploadID) {
    return store.query(DbTableName.localUpload).whereEqual('uploadID', uploadID).first();
  }

  Future<Map<String, dynamic>?> getUploadTaskByHashAndName(String hash, String name) {
    return store
        .query(DbTableName.localUpload)
        .whereEqual('hash', hash)
        .whereEqual('name', name)
        .first();
  }

  Future<DbResult> deleteUploadTask(String uploadID) async {
    final DbResult result = await store
        .delete(DbTableName.localUpload)
        .whereEqual('uploadID', uploadID)
        .durability(RecoveryDurability.async);
    logIfErrors('deleteUploadTask($uploadID)', result);
    return result;
  }

  // ---- Sending Messages ----

  Future<DbResult> insertSendingMessage(String clientMsgID, String conversationID) async {
    final DbResult result = await store.upsert(DbTableName.localSendingMessage, <String, dynamic>{
      'clientMsgID': clientMsgID,
      'conversationID': conversationID,
    });
    logIfErrors('insertSendingMessage($clientMsgID)', result);
    return result;
  }

  Future<DbResult> deleteSendingMessage(String clientMsgID) async {
    final DbResult result = await store
        .delete(DbTableName.localSendingMessage)
        .whereEqual('clientMsgID', clientMsgID);
    logIfErrors('deleteSendingMessage($clientMsgID)', result);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllSendingMessages() async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localSendingMessage)
        .limit(1000);
    return result.data;
  }
}
