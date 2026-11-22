import 'dart:async';

/// 串行异步任务队列，确保入队任务严格按 FIFO 顺序依次完成。
///
/// 适用于 WS 推送落库、顺序事件派发等禁止并发交叉执行的场景。
class SerialTaskQueue {
  Future<void> _tail = Future<void>.value();

  /// 将异步任务 [task] 追加到队列尾部，等待前置任务完成后执行。
  Future<T> enqueue<T>(Future<T> Function() task) {
    final Completer<T> completer = Completer<T>();
    _tail = _tail.then((_) async {
      try {
        final T result = await task();
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      } on Object catch (error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      }
    });
    return completer.future;
  }

  /// 等待当前队列中所有已提交任务完成。
  Future<void> drain() => _tail;
}
