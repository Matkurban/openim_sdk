import 'package:logging/logging.dart';

/// 幂等多播监听器容器，兼容单监听器覆盖设置与多监听器订阅。
class ListenerRegistry<L> {
  final Logger _logger;
  L? _primaryListener;
  final List<L> _extraListeners = <L>[];

  ListenerRegistry(String name) : _logger = Logger('openim_sdk.ListenerRegistry.$name');

  /// 主监听器（兼容传统 `setXxxListener` 单一覆盖语义）。
  L? get primary => _primaryListener;

  /// 设置主监听器（传 `null` 清除）。
  void setPrimary(L? listener) {
    _primaryListener = listener;
  }

  /// 幂等添加附加监听器。
  void add(L listener) {
    if (!_extraListeners.contains(listener)) {
      _extraListeners.add(listener);
    }
  }

  /// 幂等移除监听器（同时检查主监听器与附加监听器）。
  void remove(L listener) {
    if (identical(_primaryListener, listener)) {
      _primaryListener = null;
    }
    _extraListeners.remove(listener);
  }

  /// 向所有已注册监听器安全派发事件（单个回调异常不影响其他监听器）。
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

  /// 清空所有监听器。
  void clear() {
    _primaryListener = null;
    _extraListeners.clear();
  }
}
