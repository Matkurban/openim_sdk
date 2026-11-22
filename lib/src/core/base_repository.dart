import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tostore/tostore.dart';

/// 所有 ToStore 领域仓储（Repository）的抽象基类。
///
/// Abstract base class for all ToStore domain repositories.
///
/// 统一封装热点内存探针 `peekFirst`、批量写入 `batchUpsert`/`batchUpdate`、
/// `DbResult.hasErrors` 诊断日志记录及主键操作辅助方法。
/// Provides memory-cache probing via `peekFirst`, high-throughput `batchUpsert`/`batchUpdate`,
/// standardized `DbResult.hasErrors` diagnostics, and primary-key CRUD helpers.
abstract base class BaseRepository<T> {
  final ToStore _store;
  final String _tableName;
  final String _primaryKeyName;
  final Logger _logger;

  /// 创建领域仓储基类实例。
  ///
  /// Creates a [BaseRepository] instance.
  ///
  /// - [_store] ToStore 数据库实例 / Underlying [ToStore] database instance.
  /// - [_tableName] 目标数据表名 / Target table name.
  /// - [_primaryKeyName] 主键列名 / Primary key column name.
  /// - [name] 仓储模块名称，用于日志标识 / Repository module name for logging.
  BaseRepository({
    required this._store,
    required this._tableName,
    required this._primaryKeyName,
    required String name,
  }) : _logger = Logger('openim_sdk.$name');

  /// 底层 ToStore 实例。
  ///
  /// Underlying [ToStore] database instance.
  @protected
  ToStore get store => _store;

  /// 当前仓储绑定的数据表名。
  ///
  /// Table name bound to this repository.
  @protected
  String get tableName => _tableName;

  /// 当前数据表主键列名。
  ///
  /// Primary key column name of the bound table.
  @protected
  String get primaryKeyName => _primaryKeyName;

  /// 当前仓储日志器。
  ///
  /// Logger instance for this repository.
  @protected
  Logger get logger => _logger;

  /// 将数据库原始行数据映射为领域模型 [T]。
  ///
  /// Maps a raw database row map to the domain model [T].
  ///
  /// - [row] 数据库行数据字典 / Raw database row map.
  /// - Returns: 映射后的领域模型实例 / Mapped domain model instance.
  @protected
  T fromRow(Map<String, dynamic> row);

  /// 按主键进行 O(1) 热点内存探针优先查询（未命中再走标准异步查询）。
  ///
  /// Queries a single record by primary key using memory-cache probing (`peekFirst`) first,
  /// falling back to an async query on cache miss.
  ///
  /// - [key] 主键值 / Primary key value.
  /// - Returns: 命中的领域模型，不存在时返回 `null` / Matched domain model, or `null` if absent.
  Future<T?> findByPrimaryKey(String key) async {
    final QueryBuilder query = _store.query(_tableName).whereEqual(_primaryKeyName, key);
    final Map<String, dynamic>? cached = query.peekFirst();
    if (cached != null) {
      return fromRow(cached);
    }
    final Map<String, dynamic>? row = await query.first();
    return row != null ? fromRow(row) : null;
  }

  /// 按主键集合批量查询记录。
  ///
  /// Batch-queries records by a list of primary keys.
  ///
  /// - [keys] 主键值列表 / List of primary key values.
  /// - Returns: 匹配到的领域模型列表 / List of matched domain models.
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
  ///
  /// Checks record existence by primary key using a short-circuit probe without fetching row payloads.
  ///
  /// - [key] 主键值 / Primary key value.
  /// - Returns: 记录存在返回 `true`，否则返回 `false` / `true` if the record exists, otherwise `false`.
  Future<bool> existsByPrimaryKey(String key) async {
    final QueryBuilder query = _store.query(_tableName).whereEqual(_primaryKeyName, key);
    if (query.peekExists()) {
      return true;
    }
    return query.exists();
  }

  /// 单条写入或更新记录并统一记录诊断错误日志。
  ///
  /// Upserts a single row and logs any database errors.
  ///
  /// - [data] 待写入的行数据字典 / Row map to insert or update.
  /// - [durability] 可选持久化级别覆盖 / Optional [RecoveryDurability] override.
  /// - Returns: 数据库执行结果 [DbResult] / Execution result [DbResult].
  Future<DbResult> upsertRow(Map<String, dynamic> data, {RecoveryDurability? durability}) async {
    final DbResult result = await _store.upsert(_tableName, data, durability: durability);
    logIfErrors('upsert', result);
    return result;
  }

  /// 批量写入或更新记录（ToStore 3.6.3 高吞吐批量通道）。
  ///
  /// Batch-upserts multiple rows via ToStore's high-throughput batch pipeline.
  ///
  /// - [rows] 待写入的行数据列表 / List of row maps to upsert.
  /// - [allowPartialErrors] 是否允许部分记录失败而不中止整批 / Whether partial row errors are allowed.
  /// - [durability] 可选持久化级别覆盖 / Optional [RecoveryDurability] override.
  /// - Returns: 数据库执行结果 [DbResult] / Execution result [DbResult].
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

  /// 批量局部更新记录（每条记录只需包含主键/唯一键及待修改字段）。
  ///
  /// Batch-updates partial fields for multiple rows (each map needs only key and changed fields).
  ///
  /// - [rows] 局部更新行列表 / List of partial update maps.
  /// - [allowPartialErrors] 是否允许部分记录失败而不中止整批 / Whether partial row errors are allowed.
  /// - [durability] 可选持久化级别覆盖 / Optional [RecoveryDurability] override.
  /// - Returns: 数据库执行结果 [DbResult] / Execution result [DbResult].
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
  ///
  /// Updates specific columns for the row matching [key].
  ///
  /// - [key] 主键值 / Primary key value.
  /// - [fields] 待更新的字段键值对 / Map of column names to new values.
  /// - [durability] 可选持久化级别覆盖 / Optional [RecoveryDurability] override.
  /// - Returns: 数据库执行结果 [DbResult] / Execution result [DbResult].
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
  ///
  /// Deletes a single row matching [key].
  ///
  /// - [key] 主键值 / Primary key value.
  /// - [durability] 可选持久化级别覆盖 / Optional [RecoveryDurability] override.
  /// - Returns: 数据库执行结果 [DbResult] / Execution result [DbResult].
  Future<DbResult> deleteByPrimaryKey(String key, {RecoveryDurability? durability}) async {
    DeleteBuilder builder = _store.delete(_tableName).whereEqual(_primaryKeyName, key);
    if (durability != null) {
      builder = builder.durability(durability);
    }
    final DbResult result = await builder;
    logIfErrors('delete($key)', result);
    return result;
  }

  /// 统一检查 ToStore 3.6.3 `DbResult.hasErrors` 并输出详细诊断警告日志。
  ///
  /// Checks `DbResult.hasErrors` and logs structured warning diagnostics on failure.
  ///
  /// - [operation] 操作名称标识 / Name of the database operation.
  /// - [result] 数据库操作结果 / Database operation result to inspect.
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
