import 'dart:async';

/// 按字符串 Key 隔离的轻量异步互斥锁。
///
/// 同一 [key] 的操作严格串行，不同 [key] 的操作可并发执行。
class KeyedAsyncLock {
  final Map<String, Future<void>> _chains = <String, Future<void>>{};

  /// 在指定 [key] 的临界区内执行 [action]。
  Future<T> synchronized<T>(String key, Future<T> Function() action) {
    final Future<void> previous = _chains[key] ?? Future<void>.value();
    final Completer<T> completer = Completer<T>();
    late final Future<void> next;
    next = previous.then((_) async {
      try {
        final T result = await action();
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      } on Object catch (error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      } finally {
        if (identical(_chains[key], next)) {
          _chains.remove(key);
        }
      }
    });
    _chains[key] = next;
    return completer.future;
  }

  /// 当前指定 [key] 是否处于锁定状态。
  bool isLocked(String key) => _chains.containsKey(key);
}
