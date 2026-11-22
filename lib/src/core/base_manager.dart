import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'listener_registry.dart';

/// 所有业务 Manager 的统一抽象基类。
///
/// Unified abstract base class for all business managers.
///
/// 统一管理日志器 `_logger`、当前登录用户 ID、多播监听器以及登录/登出生命周期钩子，
/// 消除各 Manager 之间重复的样板代码。
/// Centralizes `_logger`, the active login user ID, multicast listeners, and
/// login/logout lifecycle hooks to eliminate boilerplate across managers.
abstract base class BaseManager<L> {
  final Logger _logger;
  final ListenerRegistry<L> _listeners;
  String _currentUserID = '';

  /// 创建业务管理器基类实例。
  ///
  /// Creates a [BaseManager] instance.
  ///
  /// - [name] 模块名称，用于构造 `openim_sdk.<name>` 日志器 / Module name used for `openim_sdk.<name>` logger.
  BaseManager(String name)
    : _logger = Logger('openim_sdk.$name'),
      _listeners = ListenerRegistry<L>(name);

  /// 子类共用的日志实例。
  ///
  /// Shared [Logger] instance for subclasses.
  @protected
  Logger get logger => _logger;

  /// 子类共用的多播监听器注册表。
  ///
  /// Shared multicast [ListenerRegistry] for subclasses.
  @protected
  ListenerRegistry<L> get listeners => _listeners;

  /// 当前主监听器（兼容旧版单监听器访问方式）。
  ///
  /// Current primary listener (compatible with legacy single-listener access).
  ///
  /// - Returns: 主监听器实例，未设置时返回 `null` / Primary listener instance, or `null` if unset.
  L? get listener => _listeners.primary;

  /// 当前登录用户 ID。
  ///
  /// Currently logged-in user ID.
  ///
  /// - Returns: 登录用户 ID，未登录时为空字符串 / Logged-in user ID, or empty string when logged out.
  @protected
  String get currentUserID => _currentUserID;

  /// 是否已绑定有效登录用户。
  ///
  /// Whether a valid logged-in user is currently bound.
  ///
  /// - Returns: 已登录返回 `true`，否则返回 `false` / `true` if logged in, otherwise `false`.
  @protected
  bool get hasLoggedInUser => _currentUserID.isNotEmpty;

  /// 注册主监听器（覆盖式）。
  ///
  /// Sets or replaces the primary listener.
  ///
  /// - [listener] 监听器实例，传 `null` 清除 / Listener instance, or `null` to clear.
  @protected
  void setPrimaryListener(L? listener) {
    _listeners.setPrimary(listener);
  }

  /// 添加附加监听器（幂等）。
  ///
  /// Adds an additional listener idempotently.
  ///
  /// - [listener] 要注册的监听器 / Listener to register.
  void addListener(L listener) {
    _listeners.add(listener);
  }

  /// 移除指定监听器（幂等）。
  ///
  /// Removes the given listener idempotently.
  ///
  /// - [listener] 要移除的监听器 / Listener to remove.
  void removeListener(L listener) {
    _listeners.remove(listener);
  }

  /// 登录成功时由 `IMManager` 统一触发的生命周期钩子。
  ///
  /// Lifecycle hook invoked by `IMManager` upon successful login.
  ///
  /// - [userID] 当前登录用户 ID / Newly logged-in user ID.
  @mustCallSuper
  @internal
  void onLogin(String userID) {
    _currentUserID = userID;
  }

  /// 登出时由 `IMManager` 统一触发的生命周期钩子。
  ///
  /// Lifecycle hook invoked by `IMManager` upon logout.
  @mustCallSuper
  @internal
  void onLogout() {
    _currentUserID = '';
  }

  /// 反初始化时释放内部状态与所有监听器。
  ///
  /// Releases internal state and clears all listeners during uninitialization.
  @mustCallSuper
  @internal
  void dispose() {
    _currentUserID = '';
    _listeners.clear();
  }
}
