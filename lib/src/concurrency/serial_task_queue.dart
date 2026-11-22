import 'dart:async';

/// 串行异步任务队列，确保入队任务严格按 FIFO 顺序依次完成。
///
/// Serial asynchronous task queue ensuring enqueued tasks complete strictly in FIFO order.
///
/// 适用于 WS 推送落库、顺序事件派发等禁止并发交叉执行的场景。
/// Designed for WebSocket push persistence and ordered event dispatch where overlap is forbidden.
class SerialTaskQueue {
  Future<void> _tail = Future<void>.value();

  /// 将异步任务 [task] 追加到队列尾部，等待前置任务完成后执行。
  ///
  /// Appends [task] to the tail of the queue and executes it after all prior tasks complete.
  ///
  /// - [task] 待串行执行的异步任务 / Asynchronous task to execute serially.
  /// - Returns: [task] 的执行结果 / Result returned by [task].
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

  /// 等待当前队列中所有已提交任务全部完成。
  ///
  /// Waits until all currently queued tasks have completed.
  ///
  /// - Returns: 队列排空后完成的 [Future] / [Future] completing once the queue drains.
  Future<void> drain() => _tail;
}
