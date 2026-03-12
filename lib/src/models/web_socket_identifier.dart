/// WebSocket 请求/响应标识符，对应 Go SDK 的 constant.go
sealed class WebSocketIdentifier {
  // ---- Client → Server ----
  /// 获取最新 seq
  static const int getNewestSeq = 1001;

  /// 按范围拉取消息
  static const int pullMsgByRange = 1002;

  /// 发送消息
  static const int sendMsg = 1003;

  /// 发送信令消息
  static const int sendSignalMsg = 1004;

  /// 按 seq 列表拉取消息
  static const int pullMsgBySeqList = 1005;

  /// 获取会话最大已读 seq
  static const int getConvMaxReadSeq = 1006;

  /// 拉取会话最后一条消息
  static const int pullConvLastMessage = 1007;

  // ---- Server → Client ----
  /// 推送消息
  static const int pushMsg = 2001;

  /// 被踢下线
  static const int kickOnlineMsg = 2002;

  /// 强制登出
  static const int logoutMsg = 2003;

  /// 设置后台状态
  static const int setBackgroundStatus = 2004;

  /// 用户在线状态订阅
  static const int wsSubUserOnlineStatus = 2005;
}
