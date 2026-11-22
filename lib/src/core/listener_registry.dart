import 'package:logging/logging.dart';

/// 幂等多播监听器容器，兼容单监听器覆盖设置与多监听器订阅。
///
/// Idempotent multicast listener registry supporting both legacy single-primary
/// replacement and multi-listener subscriptions.
class ListenerRegistry<L> {
  final Logger _logger;
  L? _primaryListener;
  final List<L> _extraListeners = <L>[];

  /// 创建监听器注册表实例。
  ///
  /// Creates a [ListenerRegistry] instance.
  ///
  /// - [name] 所属模块名称，用于日志标识 / Owning module name used for logging.
  ListenerRegistry(String name) : _logger = Logger('openim_sdk.ListenerRegistry.$name');

  /// 主监听器（兼容传统 `setXxxListener` 单一覆盖语义）。
  ///
  /// Primary listener (preserves legacy `setXxxListener` overwrite semantics).
  ///
  /// - Returns: 当前主监听器，未设置时返回 `null` / Current primary listener, or `null` if unset.
  L? get primary => _primaryListener;

  /// 设置主监听器（传 `null` 清除）。
  ///
  /// Sets the primary listener, or clears it when `null` is passed.
  ///
  /// - [listener] 主监听器实例 / Primary listener instance.
  void setPrimary(L? listener) {
    _primaryListener = listener;
  }

  /// 幂等添加附加监听器。
  ///
  /// Adds an extra listener idempotently.
  ///
  /// - [listener] 待添加的监听器 / Listener to add.
  void add(L listener) {
    if (!_extraListeners.contains(listener)) {
      _extraListeners.add(listener);
    }
  }

  /// 幂等移除监听器（同时检查主监听器与附加监听器）。
  ///
  /// Removes a listener idempotently from both primary and extra slots.
  ///
  /// - [listener] 待移除的监听器 / Listener to remove.
  void remove(L listener) {
    if (identical(_primaryListener, listener)) {
      _primaryListener = null;
    }
    _extraListeners.remove(listener);
  }

  /// 向所有已注册监听器安全派发事件（单个回调异常不影响其他监听器）。
  ///
  /// Safely dispatches an event to all registered listeners, isolating exceptions per listener.
  ///
  /// - [dispatch] 针对单个监听器的回调派发函数 / Callback invoker applied to each listener.
  void notify(void Function(L listener) dispatch) {
    final L? currentPrimary = _primaryListener;
    if (currentPrimary != null) {
      try {
        dispatch(currentPrimary);
      } on Object catch (error, stackTrace) {
        _logger.warning('Primary listener callback failed', error, stackTrace);
      }
    }
    if (_extraListeners.isEmpty) {
      return;
    }
    final List<L> snapshot = List<L>.of(_extraListeners);
    for (final L listener in snapshot) {
      try {
        dispatch(listener);
      } on Object catch (error, stackTrace) {
        _logger.warning('Listener callback failed', error, stackTrace);
      }
    }
  }

  /// 清空主监听器与所有附加监听器。
  ///
  /// Clears the primary listener and all extra listeners.
  void clear() {
    _primaryListener = null;
    _extraListeners.clear();
  }
}
