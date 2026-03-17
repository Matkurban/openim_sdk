/// Message Sending Progress Listener
class OnMsgSendProgressListener {
  void Function(String clientMsgID, int progress)? onProgress;
  void Function(String clientMsgID, String? error)? onFailure;

  OnMsgSendProgressListener({this.onProgress, this.onFailure});

  /// Message sending progress (0-100)
  void progress(String clientMsgID, int progress) {
    onProgress?.call(clientMsgID, progress);
  }

  /// Message sending failed
  void fail(String clientMsgID, String? error) {
    onFailure?.call(clientMsgID, error);
  }
}
