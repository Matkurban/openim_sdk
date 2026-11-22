import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'listener_registry.dart';

/// 所有业务 Manager 的统一抽象基类。
///
/// 统一管理日志器 `_logger`、当前登录用户 ID、多播监听器以及登录/登出生命周期钩子，
/// 消除各 Manager 之间重复的样板代码。
abstract base class BaseManager<L> {
  final Logger _logger;
  final ListenerRegistry<L> _listeners;
  String _currentUserID = '';

  BaseManager(String name)
    : _logger = Logger('openim_sdk.$name'),
      _listeners = ListenerRegistry<L>(name);

  /// 子类共用的日志实例（遵循统一命名规范）。
  @protected
  Logger get logger => _logger;

  /// 子类共用的监听器注册表。
  @protected
  ListenerRegistry<L> get listeners => _listeners;

  /// 兼容旧版直接访问单个主监听器的场景。
  L? get listener => _listeners.primary;

  /// 当前登录用户 ID。
  @protected
  String get currentUserID => _currentUserID;

  /// 是否已绑定有效登录用户。
  @protected
  bool get hasLoggedInUser => _currentUserID.isNotEmpty;

  /// 注册主监听器（覆盖式）。
  @protected
  void setPrimaryListener(L? listener) {
    _listeners.setPrimary(listener);
  }

  /// 添加监听器（幂等）。
  void addListener(L listener) {
    _listeners.add(listener);
  }

  /// 移除监听器（幂等）。
  void removeListener(L listener) {
    _listeners.remove(listener);
  }

  /// 登录成功时由 `IMManager` 统一触发的生命周期钩子。
  @mustCallSuper
  @internal
  void onLogin(String userID) {
    _currentUserID = userID;
  }

  /// 登出时由 `IMManager` 统一触发的生命周期钩子。
  @mustCallSuper
  @internal
  void onLogout() {
    _currentUserID = '';
  }

  /// 反初始化时释放资源。
  @mustCallSuper
  @internal
  void dispose() {
    _currentUserID = '';
    _listeners.clear();
  }
}
