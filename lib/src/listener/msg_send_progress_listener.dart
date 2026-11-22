/// 消息发送与媒体上传进度监听器。
///
/// Message sending and media upload progress listener.
class OnMsgSendProgressListener {
  /// 发送进度更新回调（0–100） / Callback invoked with upload/send progress (`0`–`100`).
  void Function(String clientMsgID, int progress)? onProgress;

  /// 发送失败回调 / Callback invoked when sending fails.
  void Function(String clientMsgID, String? error)? onFailure;

  /// 创建消息发送进度监听器。
  ///
  /// Creates an [OnMsgSendProgressListener].
  ///
  /// - [onProgress] 进度回调 / Progress callback.
  /// - [onFailure] 失败回调 / Failure callback.
  OnMsgSendProgressListener({this.onProgress, this.onFailure});

  /// 触发发送进度回调 / Dispatches [onProgress].
  ///
  /// - [clientMsgID] 客户端消息 ID / Client message ID.
  /// - [progress] 进度百分比（0–100） / Progress percentage (`0`–`100`).
  void progress(String clientMsgID, int progress) {
    onProgress?.call(clientMsgID, progress);
  }

  /// 触发发送失败回调 / Dispatches [onFailure].
  ///
  /// - [clientMsgID] 客户端消息 ID / Client message ID.
  /// - [error] 错误描述信息 / Optional error message.
  void fail(String clientMsgID, String? error) {
    onFailure?.call(clientMsgID, error);
  }
}
