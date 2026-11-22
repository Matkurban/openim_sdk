/// 红包领取提示消息体（contentType=126）
///
/// 由 openim-chat 服务端在抢红包成功后通过 admin /msg/send_msg 注入到会话中，
/// 客户端不主动发送，仅消费展示。
class RedPacketGrabNotifyElem {
  /// 包ID。
  ///
  /// Packet ID.
  final String packetID;

  /// grabberID。
  ///
  /// Grabber ID.
  final String grabberID;

  /// grabber名称。
  ///
  /// Grabber name.
  final String grabberName;

  /// grabber头像URL 地址。
  ///
  /// Grabber avatar URL.
  final String grabberFaceURL;

  /// 发送器ID。
  ///
  /// Sender ID.
  final String senderID;

  /// 发送器名称。
  ///
  /// Sender name.
  final String senderName;

  /// 金额。
  ///
  /// Amount.
  final double amount;

  /// 创建 `RedPacketGrabNotifyElem` 实例。
  ///
  /// Creates a `RedPacketGrabNotifyElem` instance.
  ///
  /// - [packetID] 包ID / Packet ID.
  /// - [grabberID] grabberID / Grabber ID.
  /// - [grabberName] grabber名称 / Grabber name.
  /// - [grabberFaceURL] grabber头像URL 地址 / Grabber avatar URL.
  /// - [senderID] 发送器ID / Sender ID.
  /// - [senderName] 发送器名称 / Sender name.
  /// - [amount] 金额 / Amount.
  const RedPacketGrabNotifyElem({
    required this.packetID,
    required this.grabberID,
    this.grabberName = '',
    this.grabberFaceURL = '',
    required this.senderID,
    this.senderName = '',
    required this.amount,
  });

  /// 从 JSON 字典反序列化实例（`RedPacketGrabNotifyElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`RedPacketGrabNotifyElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `RedPacketGrabNotifyElem` 结果 / Resulting `RedPacketGrabNotifyElem`.
  factory RedPacketGrabNotifyElem.fromJson(Map<String, dynamic> json) => RedPacketGrabNotifyElem(
    packetID: json['packetID'] as String? ?? '',
    grabberID: json['grabberID'] as String? ?? '',
    grabberName: json['grabberName'] as String? ?? '',
    grabberFaceURL: json['grabberFaceURL'] as String? ?? '',
    senderID: json['senderID'] as String? ?? '',
    senderName: json['senderName'] as String? ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 0,
  );

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'packetID': packetID,
    'grabberID': grabberID,
    'grabberName': grabberName,
    'grabberFaceURL': grabberFaceURL,
    'senderID': senderID,
    'senderName': senderName,
    'amount': amount,
  };
}
