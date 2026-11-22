/// 红包与积分余额事件监听器。
///
/// Red packet and points balance event listener.
class OnRedPacketListener {
  /// 红包过期回调（仅发包人会收到） / Callback invoked when a red packet expires (sender only).
  void Function(String packetID)? onRedPacketExpired;

  /// 红包被领取回调 / Callback invoked when a red packet is grabbed.
  void Function(Map<String, dynamic> info)? onRedPacketGrabbed;

  /// 积分余额变化回调 / Callback invoked when the user's points balance changes.
  void Function(double newBalance)? onPointsBalanceChanged;

  /// 创建红包事件监听器。
  ///
  /// Creates an [OnRedPacketListener].
  ///
  /// - [onRedPacketExpired] 红包过期回调 / Red packet expired callback.
  /// - [onRedPacketGrabbed] 红包领取回调 / Red packet grabbed callback.
  /// - [onPointsBalanceChanged] 积分余额变化回调 / Points balance changed callback.
  OnRedPacketListener({
    this.onRedPacketExpired,
    this.onRedPacketGrabbed,
    this.onPointsBalanceChanged,
  });

  /// 触发红包过期回调 / Dispatches [onRedPacketExpired].
  ///
  /// - [packetID] 过期红包 ID / Expired red packet ID.
  void redPacketExpired(String packetID) {
    onRedPacketExpired?.call(packetID);
  }

  /// 触发红包被领取回调 / Dispatches [onRedPacketGrabbed].
  ///
  /// - [info] 领取事件详情 / Grab event details.
  void redPacketGrabbed(Map<String, dynamic> info) {
    onRedPacketGrabbed?.call(info);
  }

  /// 触发积分余额变化回调 / Dispatches [onPointsBalanceChanged].
  ///
  /// - [newBalance] 最新积分余额 / Updated points balance.
  void pointsBalanceChanged(double newBalance) {
    onPointsBalanceChanged?.call(newBalance);
  }
}
