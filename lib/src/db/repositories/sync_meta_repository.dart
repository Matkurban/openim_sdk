import 'package:tostore/tostore.dart';

import '../../core/base_repository.dart';
import '../db_schema.dart';

/// 同步元数据与辅助表仓储：
/// - `local_version_sync`（O(1) 复合主键 `id = '${tableName}_$entityID'`）
/// - `local_notification_seqs`
/// - `local_uploads`（高频断点续传进度，使用 `RecoveryDurability.async` 提升吞吐）
/// - `local_sending_messages`
final class SyncMetaRepository extends BaseRepository<Map<String, dynamic>> {
  /// 创建 `SyncMetaRepository` 实例。
  ///
  /// Creates a `SyncMetaRepository` instance.
  ///
  /// - [store] 存储 / Store.
  SyncMetaRepository({required super.store})
    : super(
        tableName: DbTableName.localVersionSync,
        primaryKeyName: 'id',
        name: 'SyncMetaRepository',
      );

  /// 从行数据。
  ///
  /// From row.
  ///
  /// - [row] 行数据 / Row.
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  @override
  Map<String, dynamic> fromRow(Map<String, dynamic> row) => row;

  // ---- VersionSync (O(1) 复合主键，彻底移除 3.0.8 绕过代码) ----

  /// 获取版本同步。
  ///
  /// Get version sync.
  ///
  /// - [tableName] 数据表名称 / Table name.
  /// - [entityID] 实体ID / Entity ID.
  /// - Returns: `Future<Map<String, dynamic>?>` 映射结果 / Resulting `Future<Map<String, dynamic>?>` map.
  Future<Map<String, dynamic>?> getVersionSync(String tableName, String entityID) {
    return findByPrimaryKey(DbSchema.compositeKey(tableName, entityID));
  }

  /// 设置版本同步。
  ///
  /// Set version sync.
  ///
  /// - [tableName] 数据表名称 / Table name.
  /// - [entityID] 实体ID / Entity ID.
  /// - [versionID] 版本ID / Version ID.
  /// - [version] 版本 / Version.
  /// - [uidList] 用户 ID列表 / User ID list.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
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

  /// 删除版本同步。
  ///
  /// Delete version sync.
  ///
  /// - [tableName] 数据表名称 / Table name.
  /// - [entityID] 实体ID / Entity ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteVersionSync(String tableName, String entityID) {
    return deleteByPrimaryKey(DbSchema.compositeKey(tableName, entityID));
  }

  // ---- NotificationSeq ----

  /// 写入或更新通知序列号。
  ///
  /// Upsert notification sequence number.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [seq] 序列号 / Sequence number.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> upsertNotificationSeq(String conversationID, int seq) async {
    final DbResult result = await store.upsert(DbTableName.localNotificationSeq, <String, dynamic>{
      'conversationID': conversationID,
      'seq': seq,
      'updateTime': DateTime.now().millisecondsSinceEpoch,
    });
    logIfErrors('upsertNotificationSeq($conversationID)', result);
    return result;
  }

  /// 获取全部通知序列号列表。
  ///
  /// Get all notification sequence numbers.
  ///
  /// - Returns: `Future<Map<String, int>>` 映射结果 / Resulting `Future<Map<String, int>>` map.
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

  /// 写入或更新上传Task。
  ///
  /// Upsert upload task.
  ///
  /// - [data] 数据 / Data.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> upsertUploadTask(Map<String, dynamic> data) async {
    final DbResult result = await store.upsert(
      DbTableName.localUpload,
      data,
      durability: RecoveryDurability.async,
    );
    logIfErrors('upsertUploadTask', result);
    return result;
  }

  /// 获取上传Task。
  ///
  /// Get upload task.
  ///
  /// - [uploadID] 上传ID / Upload ID.
  /// - Returns: `Future<Map<String, dynamic>?>` 映射结果 / Resulting `Future<Map<String, dynamic>?>` map.
  Future<Map<String, dynamic>?> getUploadTask(String uploadID) {
    return store.query(DbTableName.localUpload).whereEqual('uploadID', uploadID).first();
  }

  /// 获取上传TaskBy哈希值并名称。
  ///
  /// Get upload task by hash and name.
  ///
  /// - [hash] 哈希值 / Hash.
  /// - [name] 名称 / Name.
  /// - Returns: `Future<Map<String, dynamic>?>` 映射结果 / Resulting `Future<Map<String, dynamic>?>` map.
  Future<Map<String, dynamic>?> getUploadTaskByHashAndName(String hash, String name) {
    return store
        .query(DbTableName.localUpload)
        .whereEqual('hash', hash)
        .whereEqual('name', name)
        .first();
  }

  /// 删除上传Task。
  ///
  /// Delete upload task.
  ///
  /// - [uploadID] 上传ID / Upload ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteUploadTask(String uploadID) async {
    final DbResult result = await store
        .delete(DbTableName.localUpload)
        .whereEqual('uploadID', uploadID)
        .durability(RecoveryDurability.async);
    logIfErrors('deleteUploadTask($uploadID)', result);
    return result;
  }

  // ---- Sending Messages ----

  /// 插入Sending消息。
  ///
  /// Insert sending message.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - [conversationID] 会话ID / Conversation ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> insertSendingMessage(String clientMsgID, String conversationID) async {
    final DbResult result = await store.upsert(DbTableName.localSendingMessage, <String, dynamic>{
      'clientMsgID': clientMsgID,
      'conversationID': conversationID,
    });
    logIfErrors('insertSendingMessage($clientMsgID)', result);
    return result;
  }

  /// 删除Sending消息。
  ///
  /// Delete sending message.
  ///
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - Returns: `Future<DbResult>` 结果 / Resulting `Future<DbResult>`.
  Future<DbResult> deleteSendingMessage(String clientMsgID) async {
    final DbResult result = await store
        .delete(DbTableName.localSendingMessage)
        .whereEqual('clientMsgID', clientMsgID);
    logIfErrors('deleteSendingMessage($clientMsgID)', result);
    return result;
  }

  /// 获取全部Sending消息列表。
  ///
  /// Get all sending messages.
  ///
  /// - Returns: `Future<List<Map<String, dynamic>>>` 列表结果 / Resulting `Future<List<Map<String, dynamic>>>` list.
  Future<List<Map<String, dynamic>>> getAllSendingMessages() async {
    final QueryResult<Map<String, dynamic>> result = await store
        .query(DbTableName.localSendingMessage)
        .limit(1000);
    return result.data;
  }
}
