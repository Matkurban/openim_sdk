import 'package:logging/logging.dart' hide LogRecord;
import 'package:tostore/tostore.dart';

import '../utils/open_im_utils.dart';
import 'db_schema.dart';
import 'repositories/conversation_repository.dart';
import 'repositories/friend_repository.dart';
import 'repositories/group_repository.dart';
import 'repositories/message_repository.dart';
import 'repositories/social_repository.dart';
import 'repositories/sync_meta_repository.dart';
import 'repositories/user_repository.dart';

/// ToStore 3.6.3 数据库引擎与领域仓储统一门面。
///
/// 负责：
/// 1. 初始化 ToStore（`yieldDurationMs: 8` 保证 UI 帧率，`enableJournal: true`，日志桥接 `logging`）；
/// 2. 管理多用户空间切换（`switchSpace(..., keepActive: true)`）与安全关闭；
/// 3. 统一装配并对外提供所有领域 Repository 与事务执行入口。
class DbEngine {
  static final Logger _logger = Logger('openim_sdk.DbEngine');
  static final Logger _toStoreLogger = Logger('openim_sdk.ToStore');

  final ToStore toStore;
  final UserRepository users;
  final FriendRepository friends;
  final GroupRepository groups;
  final ConversationRepository conversations;
  final MessageRepository messages;
  final SocialRepository social;
  final SyncMetaRepository syncMeta;

  String _currentUserID = '';

  DbEngine._({
    required this.toStore,
    required this.users,
    required this.friends,
    required this.groups,
    required this.conversations,
    required this.messages,
    required this.social,
    required this.syncMeta,
  });

  /// 当前绑定的登录用户 ID。
  String get currentUserID => _currentUserID;

  /// 按 ToStore 3.6.3 最佳实践打开数据库并构建所有领域仓储。
  static Future<DbEngine> open({
    String? dbPath,
    String? dbName,
    List<TableSchema> extraSchemas = const <TableSchema>[],
    Level logLevel = Level.INFO,
  }) async {
    _configureToStoreLogging(logLevel);
    final String? resolvedPath = dbPath ?? await OpenImUtils.defaultDbPath();
    final ToStore store = await ToStore.open(
      dbPath: resolvedPath,
      dbName: dbName ?? 'kurban_openim_sdk',
      schemas: <TableSchema>[...DbSchema.allSchemas, ...extraSchemas],
      config: DataStoreConfig(
        yieldDurationMs: 8,
        defaultQueryLimit: 500,
        enableJournal: true,
        defaultRecoveryDurability: RecoveryDurability.standard,
      ),
    );
    return DbEngine.fromStore(store);
  }

  /// 基于已打开的 [ToStore] 实例创建（适用于内存库单元测试）。
  factory DbEngine.fromStore(ToStore store) {
    final DbEngine engine = DbEngine._(
      toStore: store,
      users: UserRepository(store: store),
      friends: FriendRepository(store: store),
      groups: GroupRepository(store: store),
      conversations: ConversationRepository(store: store),
      messages: MessageRepository(store: store),
      social: SocialRepository(store: store),
      syncMeta: SyncMetaRepository(store: store),
    );
    return engine;
  }

  /// 切换到目标用户的数据空间并标记为活跃空间，提升下次冷启动速度。
  Future<bool> switchSpace({required String userID}) async {
    _currentUserID = userID;
    users.setCurrentUserID(userID);
    friends.setCurrentUserID(userID);
    groups.setCurrentUserID(userID);
    conversations.setCurrentUserID(userID);
    messages.setCurrentUserID(userID);
    social.setCurrentUserID(userID);

    final String targetSpace = OpenImUtils.generateSpaceName(userID);
    if (toStore.currentSpaceName == targetSpace) {
      return true;
    }
    final bool switched = await toStore.switchSpace(spaceName: targetSpace, keepActive: true);
    _logger.fine('switchSpace($targetSpace) -> $switched');
    return switched;
  }

  /// 在原子事务中执行多表操作；任意异常自动回滚。
  Future<TransactionResult> transaction(Future<void> Function() action) async {
    final TransactionResult result = await toStore.transaction(action, rollbackOnError: true);
    if (result.hasErrors) {
      _logger.warning('Transaction rolled back: ${result.statuses.length} status entries');
    }
    return result;
  }

  /// 安全关闭数据库。登出/反初始化时 `keepActiveSpace: false` 防止下次误入旧用户空间。
  Future<void> close({bool keepActiveSpace = false}) async {
    _currentUserID = '';
    await toStore.close(keepActiveSpace: keepActiveSpace);
  }

  static void _configureToStoreLogging(Level level) {
    final LogLevel toStoreLevel;
    if (level <= Level.FINE) {
      toStoreLevel = LogLevel.debug;
    } else if (level <= Level.INFO) {
      toStoreLevel = LogLevel.info;
    } else if (level <= Level.WARNING) {
      toStoreLevel = LogLevel.warn;
    } else {
      toStoreLevel = LogLevel.error;
    }
    ToStore.setLogConfig(
      enableLog: level < Level.OFF,
      logLevel: toStoreLevel,
      logLabel: 'openim_sdk_db',
      onLog: (LogRecord record) {
        if (record.level == LogLevel.critical || record.level == LogLevel.error) {
          _toStoreLogger.severe(record.message);
        } else if (record.level == LogLevel.warn) {
          _toStoreLogger.warning(record.message);
        } else if (record.level == LogLevel.info) {
          _toStoreLogger.info(record.message);
        } else {
          _toStoreLogger.fine(record.message);
        }
      },
    );
  }
}
