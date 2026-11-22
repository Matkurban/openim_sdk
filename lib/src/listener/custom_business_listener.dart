/// 自定义业务通知事件监听器（对应 `contentType = 2001`）。
///
/// Custom business notification event listener (`contentType = 2001`).
class OnCustomBusinessListener {
  /// 收到自定义业务消息回调 / Callback invoked when a custom business message arrives.
  void Function(String s)? onRecvCustomBusinessMessage;

  /// 创建自定义业务通知监听器。
  ///
  /// Creates an [OnCustomBusinessListener].
  ///
  /// - [onRecvCustomBusinessMessage] 自定义业务消息 JSON 字符串回调 / Callback receiving JSON payload string.
  OnCustomBusinessListener({this.onRecvCustomBusinessMessage});

  /// 触发自定义业务消息回调 / Dispatches [onRecvCustomBusinessMessage].
  ///
  /// - [s] 自定义业务消息内容字符串 / Custom business message payload string.
  void recvCustomBusinessMessage(String s) {
    onRecvCustomBusinessMessage?.call(s);
  }
}
