import 'dart:async';

/// 按字符串 Key 隔离的轻量异步互斥锁。
///
/// Lightweight per-key asynchronous mutex lock.
///
/// 同一 [key] 的操作严格串行，不同 [key] 的操作可并发执行。
/// Operations sharing the same key execute strictly serially while distinct keys run concurrently.
class KeyedAsyncLock {
  final Map<String, Future<void>> _chains = <String, Future<void>>{};

  /// 在指定 [key] 的临界区内执行 [action]。
  ///
  /// Executes [action] inside the mutual-exclusion critical section for [key].
  ///
  /// - [key] 锁隔离键（如会话 ID 或群 ID） / Lock partition key (e.g., conversationID or groupID).
  /// - [action] 临界区内执行的异步任务 / Asynchronous action to execute exclusively.
  /// - Returns: [action] 的执行结果 / Result returned by [action].
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

  /// 查询指定 [key] 当前是否处于锁定状态。
  ///
  /// Checks whether [key] is currently locked.
  ///
  /// - [key] 锁隔离键 / Lock partition key.
  /// - Returns: 处于锁定中返回 `true`，否则返回 `false` / `true` if locked, otherwise `false`.
  bool isLocked(String key) => _chains.containsKey(key);
}
