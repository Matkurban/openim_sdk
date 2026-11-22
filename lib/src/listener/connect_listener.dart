/// SDK 长连接与登录凭证状态监听器。
///
/// SDK connection and authentication lifecycle listener.
class OnConnectListener {
  /// SDK 连接服务器失败回调 / Callback invoked when connecting to the server fails.
  void Function(int? code, String? errorMsg)? onConnectFailed;

  /// SDK 连接服务器成功回调 / Callback invoked when connected to the server successfully.
  void Function()? onConnectSuccess;

  /// SDK 正在连接服务器回调 / Callback invoked while connecting to the server.
  void Function()? onConnecting;

  /// 账号在其他设备登录导致当前设备被踢下线回调 / Callback invoked when kicked offline by another login.
  void Function()? onKickedOffline;

  /// 登录凭证过期回调 / Callback invoked when the login token expires.
  void Function()? onUserTokenExpired;

  /// 登录凭证无效回调 / Callback invoked when the login token is invalid.
  void Function()? onUserTokenInvalid;

  /// 创建 SDK 连接状态监听器。
  ///
  /// Creates an [OnConnectListener] with optional connection and token callbacks.
  ///
  /// - [onConnectFailed] 连接失败回调 / Connection failed callback.
  /// - [onConnectSuccess] 连接成功回调 / Connection succeeded callback.
  /// - [onConnecting] 连接中回调 / Connecting callback.
  /// - [onKickedOffline] 被踢下线回调 / Kicked offline callback.
  /// - [onUserTokenExpired] Token 过期回调 / Token expired callback.
  /// - [onUserTokenInvalid] Token 无效回调 / Token invalid callback.
  OnConnectListener({
    this.onConnectFailed,
    this.onConnectSuccess,
    this.onConnecting,
    this.onKickedOffline,
    this.onUserTokenExpired,
    this.onUserTokenInvalid,
  });

  /// 触发连接失败回调 / Dispatches [onConnectFailed].
  ///
  /// - [code] 错误码 / Error code.
  /// - [errorMsg] 错误描述 / Error message.
  void connectFailed(int? code, String? errorMsg) {
    onConnectFailed?.call(code, errorMsg);
  }

  /// 触发连接成功回调 / Dispatches [onConnectSuccess].
  void connectSuccess() {
    onConnectSuccess?.call();
  }

  /// 触发正在连接回调 / Dispatches [onConnecting].
  void connecting() {
    onConnecting?.call();
  }

  /// 触发被踢下线回调 / Dispatches [onKickedOffline].
  void kickedOffline() {
    onKickedOffline?.call();
  }

  /// 触发 Token 过期回调 / Dispatches [onUserTokenExpired].
  void userTokenExpired() {
    onUserTokenExpired?.call();
  }

  /// 触发 Token 无效回调 / Dispatches [onUserTokenInvalid].
  void userTokenInvalid() {
    onUserTokenInvalid?.call();
  }
}
