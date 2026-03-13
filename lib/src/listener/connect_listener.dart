/// SDK Connection State Listener
/// SDK 连接状态监听器，当连接状态变化时回调。
class OnConnectListener {
  ///SDK 连接服务器失败
  void Function(int? code, String? errorMsg)? onConnectFailed;

  ///SDK 连接服务器成功
  void Function()? onConnectSuccess;

  ///SDK 正在连接服务器
  void Function()? onConnecting;

  ///账号已在其他地方登录，当前设备被踢下线
  void Function()? onKickedOffline;

  ///登录凭证过期，需要重新登录
  void Function()? onUserTokenExpired;
  void Function()? onUserTokenInvalid;

  OnConnectListener({
    this.onConnectFailed,
    this.onConnectSuccess,
    this.onConnecting,
    this.onKickedOffline,
    this.onUserTokenExpired,
    this.onUserTokenInvalid,
  });

  /// SDK failed to connect to the server
  void connectFailed(int? code, String? errorMsg) {
    onConnectFailed?.call(code, errorMsg);
  }

  /// SDK successfully connected to the server
  void connectSuccess() {
    onConnectSuccess?.call();
  }

  /// SDK is currently connecting to the server
  void connecting() {
    onConnecting?.call();
  }

  /// The account has been logged in from another location, and the current device has been kicked offline
  void kickedOffline() {
    onKickedOffline?.call();
  }

  /// Login credentials have expired and require reauthentication
  void userTokenExpired() {
    onUserTokenExpired?.call();
  }

  void userTokenInvalid() {
    onUserTokenInvalid?.call();
  }
}
