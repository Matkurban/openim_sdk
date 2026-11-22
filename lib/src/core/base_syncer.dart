import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// 增量同步响应的标准化封装，供 [BaseSyncer] 模板方法复用。
class IncrementalSyncResponse {
  final bool isFull;
  final String versionID;
  final int version;
  final List<String> deleteIDs;
  final List<Map<String, dynamic>> insertItems;
  final List<Map<String, dynamic>> updateItems;

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
/// 好友、群组、会话等同步器继承本基类后，只需覆写增量拉取、全量降级与变更落地逻辑，
/// 彻底消除 `msg_syncer` 与 `notification_dispatcher` 之间超千行的重复同步代码。
abstract base class BaseSyncer {
  final Logger _logger;

  BaseSyncer(String name) : _logger = Logger('openim_sdk.$name');

  @protected
  Logger get logger => _logger;

  /// 版本同步表中的 `tableName` 标识（如 `friends`、`groups`、`conversations`）。
  @protected
  String get syncTableName;

  /// 读取本地版本记录 `(version, versionID)`。
  @protected
  Future<({int version, String versionID})> readLocalVersion(String entityID);

  /// 持久化最新版本号。
  @protected
  Future<void> saveLocalVersion(String entityID, {required int version, required String versionID});

  /// 向服务端拉取增量数据；返回 `null` 表示接口失败需降级或跳过。
  @protected
  Future<IncrementalSyncResponse?> fetchIncremental({
    required String entityID,
    required int version,
    required String versionID,
  });

  /// 执行全量同步降级路径。
  @protected
  Future<void> syncFull(String entityID);

  /// 应用增量删除、新增与更新。
  @protected
  Future<void> applyIncremental({
    required String entityID,
    required List<String> deleteIDs,
    required List<Map<String, dynamic>> insertItems,
    required List<Map<String, dynamic>> updateItems,
  });

  /// 模板方法：执行“增量优先、自动降级全量、更新版本号”的标准同步流程。
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
