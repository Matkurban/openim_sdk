/// 红包与积分余额事件监听器。
///
/// Red packet and points balance event listener.
class OnRedPacketListener {
  /// 红包过期回调（仅发包人会收到） / Callback invoked when a red packet expires (sender only).
  void Function(String packetID)? onRedPacketExpired;

  /// 积分余额变化回调 / Callback invoked when the user's points balance changes.
  void Function(double newBalance)? onPointsBalanceChanged;

  /// 创建红包事件监听器。
  ///
  /// Creates an [OnRedPacketListener].
  ///
  /// - [onRedPacketExpired] 红包过期回调 / Red packet expired callback.
  /// - [onPointsBalanceChanged] 积分余额变化回调 / Points balance changed callback.
  OnRedPacketListener({this.onRedPacketExpired, this.onPointsBalanceChanged});

  /// 触发红包过期回调 / Dispatches [onRedPacketExpired].
  ///
  /// - [packetID] 过期红包 ID / Expired red packet ID.
  void redPacketExpired(String packetID) {
    onRedPacketExpired?.call(packetID);
  }

  /// 触发积分余额变化回调 / Dispatches [onPointsBalanceChanged].
  ///
  /// - [newBalance] 最新积分余额 / Updated points balance.
  void pointsBalanceChanged(double newBalance) {
    onPointsBalanceChanged?.call(newBalance);
  }
}
