/// 红包监听器
class OnRedPacketListener {
  /// 红包过期时的回调（仅发包人会收到）
  void Function(String packetID)? onRedPacketExpired;

  /// 积分余额变化时的回调
  void Function(double newBalance)? onPointsBalanceChanged;

  OnRedPacketListener({this.onRedPacketExpired, this.onPointsBalanceChanged});

  void redPacketExpired(String packetID) {
    onRedPacketExpired?.call(packetID);
  }

  void pointsBalanceChanged(double newBalance) {
    onPointsBalanceChanged?.call(newBalance);
  }
}
