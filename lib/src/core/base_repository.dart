import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tostore/tostore.dart';

/// 所有 ToStore 领域仓储（Repository）的抽象基类。
///
/// 统一封装热点内存探针 `peekFirst`、批量写入 `batchUpsert`/`batchUpdate`、
/// `DbResult.hasErrors` 诊断日志记录及事务辅助方法。
abstract base class BaseRepository<T> {
  final ToStore _store;
  final String _tableName;
  final String _primaryKeyName;
  final Logger _logger;

  BaseRepository({
    required this._store,
    required this._tableName,
    required this._primaryKeyName,
    required String name,
  }) : _logger = Logger('openim_sdk.$name');

  @protected
  ToStore get store => _store;

  @protected
  String get tableName => _tableName;

  @protected
  String get primaryKeyName => _primaryKeyName;

  @protected
  Logger get logger => _logger;

  /// 将数据库原始 Map 映射为领域模型。
  @protected
  T fromRow(Map<String, dynamic> row);

  /// 按主键进行 O(1) 热点内存探针优先查询（未命中再走标准异步查询）。
  Future<T?> findByPrimaryKey(String key) async {
    final QueryBuilder query = _store.query(_tableName).whereEqual(_primaryKeyName, key);
    final Map<String, dynamic>? cached = query.peekFirst();
    if (cached != null) {
      return fromRow(cached);
    }
    final Map<String, dynamic>? row = await query.first();
    return row != null ? fromRow(row) : null;
  }

  /// 按主键批量查询。
  Future<List<T>> findByPrimaryKeys(List<String> keys) async {
    if (keys.isEmpty) {
      return <T>[];
    }
    final QueryResult<Map<String, dynamic>> result = await _store
        .query(_tableName)
        .whereIn(_primaryKeyName, keys);
    return result.data.map<T>(fromRow).toList();
  }

  /// 按主键短路判断记录是否存在（避免拉取整行数据）。
  Future<bool> existsByPrimaryKey(String key) async {
    final QueryBuilder query = _store.query(_tableName).whereEqual(_primaryKeyName, key);
    if (query.peekExists()) {
      return true;
    }
    return query.exists();
  }

  /// 单条写入或更新并统一诊断错误日志。
  Future<DbResult> upsertRow(Map<String, dynamic> data, {RecoveryDurability? durability}) async {
    final DbResult result = await _store.upsert(_tableName, data, durability: durability);
    logIfErrors('upsert', result);
    return result;
  }

  /// 批量写入或更新（ToStore 3.6.3 高吞吐批量通道）。
  Future<DbResult> batchUpsertRows(
    List<Map<String, dynamic>> rows, {
    bool allowPartialErrors = true,
    RecoveryDurability? durability,
  }) async {
    if (rows.isEmpty) {
      return DbResult.success(message: 'Empty batch');
    }
    final DbResult result = await _store.batchUpsert(
      _tableName,
      rows,
      allowPartialErrors: allowPartialErrors,
      durability: durability,
    );
    logIfErrors('batchUpsert', result);
    return result;
  }

  /// 批量局部更新（每条记录只需包含主键/唯一键及待修改字段）。
  Future<DbResult> batchUpdateRows(
    List<Map<String, dynamic>> rows, {
    bool allowPartialErrors = true,
    RecoveryDurability? durability,
  }) async {
    if (rows.isEmpty) {
      return DbResult.success(message: 'Empty batch');
    }
    final DbResult result = await _store.batchUpdate(
      _tableName,
      rows,
      allowPartialErrors: allowPartialErrors,
      durability: durability,
    );
    logIfErrors('batchUpdate', result);
    return result;
  }

  /// 按主键更新指定字段。
  Future<DbResult> updateByPrimaryKey(
    String key,
    Map<String, dynamic> fields, {
    RecoveryDurability? durability,
  }) async {
    UpdateBuilder builder = _store.update(_tableName, fields).whereEqual(_primaryKeyName, key);
    if (durability != null) {
      builder = builder.durability(durability);
    }
    final DbResult result = await builder;
    logIfErrors('update($key)', result);
    return result;
  }

  /// 按主键删除单条记录。
  Future<DbResult> deleteByPrimaryKey(String key, {RecoveryDurability? durability}) async {
    DeleteBuilder builder = _store.delete(_tableName).whereEqual(_primaryKeyName, key);
    if (durability != null) {
      builder = builder.durability(durability);
    }
    final DbResult result = await builder;
    logIfErrors('delete($key)', result);
    return result;
  }

  /// 统一检查 ToStore 3.6.3 `DbResult.hasErrors` 并输出详细诊断信息。
  @protected
  void logIfErrors(String operation, DbResult result) {
    if (!result.hasErrors) {
      return;
    }
    _logger.warning(
      'DB $_tableName.$operation failed: [${result.firstType.codeKey}] ${result.message}',
    );
  }
}
