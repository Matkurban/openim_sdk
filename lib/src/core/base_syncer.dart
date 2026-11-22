import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// 增量同步响应的标准化封装，供 [BaseSyncer] 模板方法复用。
///
/// Standardized incremental sync payload consumed by the [BaseSyncer] template method.
class IncrementalSyncResponse {
  /// 服务端是否要求降级为全量同步。
  ///
  /// Whether the server requires falling back to a full sync.
  final bool isFull;

  /// 服务端返回的新版本标识 ID。
  ///
  /// New version identifier returned by the server.
  final String versionID;

  /// 服务端返回的新版本号。
  ///
  /// New numeric version returned by the server.
  final int version;

  /// 本次增量需删除的实体 ID 列表。
  ///
  /// List of entity IDs to delete in this incremental batch.
  final List<String> deleteIDs;

  /// 本次增量需新增的实体数据列表。
  ///
  /// List of entity maps to insert in this incremental batch.
  final List<Map<String, dynamic>> insertItems;

  /// 本次增量需更新的实体数据列表。
  ///
  /// List of entity maps to update in this incremental batch.
  final List<Map<String, dynamic>> updateItems;

  /// 创建增量同步响应对象。
  ///
  /// Creates an [IncrementalSyncResponse] instance.
  ///
  /// - [isFull] 是否触发全量同步 / Whether full sync is required.
  /// - [versionID] 最新版本 ID / Latest version ID.
  /// - [version] 最新版本号 / Latest numeric version.
  /// - [deleteIDs] 待删除 ID 列表 / Entity IDs to delete.
  /// - [insertItems] 待新增实体列表 / Entity maps to insert.
  /// - [updateItems] 待更新实体列表 / Entity maps to update.
  const IncrementalSyncResponse({
    required this.isFull,
    required this.versionID,
    required this.version,
    this.deleteIDs = const <String>[],
    this.insertItems = const <Map<String, dynamic>>[],
    this.updateItems = const <Map<String, dynamic>>[],
  });
}

/// OpenIM 版本增量同步器抽象基类（模板方法模式）。
///
/// Abstract base class for OpenIM versioned incremental syncers (Template Method pattern).
///
/// 好友、群组、会话等同步器继承本基类后，只需覆写增量拉取、全量降级与变更落地逻辑，
/// 彻底消除同步引擎与通知处理之间的重复同步代码。
/// Subclasses for friends, groups, and conversations override incremental fetching,
/// full-sync fallback, and delta persistence to eliminate duplicate sync logic.
abstract base class BaseSyncer {
  final Logger _logger;

  /// 创建同步器基类实例。
  ///
  /// Creates a [BaseSyncer] instance.
  ///
  /// - [name] 同步器模块名称 / Syncer module name used for logging.
  BaseSyncer(String name) : _logger = Logger('openim_sdk.$name');

  /// 当前同步器日志器。
  ///
  /// Logger instance for this syncer.
  @protected
  Logger get logger => _logger;

  /// 版本同步表中的 `tableName` 标识（如 `friends`、`groups`、`conversations`）。
  ///
  /// Logical table identifier stored in `local_version_sync` (e.g. `friends`, `groups`, `conversations`).
  @protected
  String get syncTableName;

  /// 读取本地版本记录 `(version, versionID)`。
  ///
  /// Reads the local version record `(version, versionID)` for [entityID].
  ///
  /// - [entityID] 实体作用域 ID（通常为当前用户 ID） / Entity scope ID (typically current user ID).
  /// - Returns: 包含 `version` 与 `versionID` 的记录元组 / Record containing `version` and `versionID`.
  @protected
  Future<({int version, String versionID})> readLocalVersion(String entityID);

  /// 持久化最新版本号到本地版本表。
  ///
  /// Persists the latest version metadata into the local version table.
  ///
  /// - [entityID] 实体作用域 ID / Entity scope ID.
  /// - [version] 最新版本号 / Latest numeric version.
  /// - [versionID] 最新版本 ID / Latest version identifier.
  @protected
  Future<void> saveLocalVersion(String entityID, {required int version, required String versionID});

  /// 向服务端拉取增量数据；返回 `null` 表示接口失败需降级或跳过。
  ///
  /// Fetches incremental changes from the server; returns `null` if the request fails.
  ///
  /// - [entityID] 实体作用域 ID / Entity scope ID.
  /// - [version] 当前本地版本号 / Current local numeric version.
  /// - [versionID] 当前本地版本 ID / Current local version identifier.
  /// - Returns: 增量响应对象，失败时返回 `null` / [IncrementalSyncResponse] or `null` on failure.
  @protected
  Future<IncrementalSyncResponse?> fetchIncremental({
    required String entityID,
    required int version,
    required String versionID,
  });

  /// 执行全量同步降级路径。
  ///
  /// Executes the full-sync fallback path for [entityID].
  ///
  /// - [entityID] 实体作用域 ID / Entity scope ID.
  @protected
  Future<void> syncFull(String entityID);

  /// 将增量删除、新增与更新落地到本地数据库。
  ///
  /// Applies incremental deletions, insertions, and updates to local storage.
  ///
  /// - [entityID] 实体作用域 ID / Entity scope ID.
  /// - [deleteIDs] 待删除实体 ID 列表 / Entity IDs to delete.
  /// - [insertItems] 待新增实体数据列表 / Entity maps to insert.
  /// - [updateItems] 待更新实体数据列表 / Entity maps to update.
  @protected
  Future<void> applyIncremental({
    required String entityID,
    required List<String> deleteIDs,
    required List<Map<String, dynamic>> insertItems,
    required List<Map<String, dynamic>> updateItems,
  });

  /// 模板方法：执行“增量优先、自动降级全量、更新版本号”的标准同步流程。
  ///
  /// Template method executing incremental-first sync with automatic full-sync fallback
  /// and version checkpoint persistence.
  ///
  /// - [entityID] 实体作用域 ID / Entity scope ID.
  /// - [forceFull] 是否强制执行全量同步 / Whether to force a full sync.
  Future<void> sync(String entityID, {bool forceFull = false}) async {
    final ({int version, String versionID}) local = await readLocalVersion(entityID);
    _logger.fine(
      'sync[$syncTableName] entity=$entityID version=${local.version} '
      'versionID=${local.versionID} forceFull=$forceFull',
    );
    final IncrementalSyncResponse? response = await fetchIncremental(
      entityID: entityID,
      version: local.version,
      versionID: local.versionID,
    );
    if (response == null) {
      if (forceFull) {
        await syncFull(entityID);
      }
      return;
    }

    if (forceFull || response.isFull || local.version == 0) {
      await syncFull(entityID);
    } else {
      await applyIncremental(
        entityID: entityID,
        deleteIDs: response.deleteIDs,
        insertItems: response.insertItems,
        updateItems: response.updateItems,
      );
      _logger.fine(
        'sync[$syncTableName] incremental done: del=${response.deleteIDs.length}, '
        'ins=${response.insertItems.length}, upd=${response.updateItems.length}',
      );
    }

    if (response.version > 0 || response.versionID.isNotEmpty) {
      await saveLocalVersion(entityID, version: response.version, versionID: response.versionID);
    }
  }
}
