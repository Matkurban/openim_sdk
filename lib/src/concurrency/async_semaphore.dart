import 'dart:async';
import 'dart:collection';

/// 并发度限制信号量，防止高并发 CPU/IO 任务打满宿主线程。
class AsyncSemaphore {
  final int maxPermits;
  int _availablePermits;
  final Queue<Completer<void>> _waiters = Queue<Completer<void>>();

  AsyncSemaphore(this.maxPermits)
    : assert(maxPermits > 0, 'maxPermits must be > 0'),
      _availablePermits = maxPermits;

  /// 获取许可后执行 [action]，无论成功或异常均保证释放许可。
  Future<T> run<T>(Future<T> Function() action) async {
    await _acquire();
    try {
      return await action();
    } finally {
      _release();
    }
  }

  Future<void> _acquire() {
    if (_availablePermits > 0) {
      _availablePermits--;
      return Future<void>.value();
    }
    final Completer<void> completer = Completer<void>();
    _waiters.addLast(completer);
    return completer.future;
  }

  void _release() {
    if (_waiters.isNotEmpty) {
      final Completer<void> next = _waiters.removeFirst();
      if (!next.isCompleted) {
        next.complete();
      }
      return;
    }
    _availablePermits++;
  }
}
