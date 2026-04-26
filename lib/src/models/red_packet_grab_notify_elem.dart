/// 红包领取提示消息体（contentType=126）
///
/// 由 openim-chat 服务端在抢红包成功后通过 admin /msg/send_msg 注入到会话中，
/// 客户端不主动发送，仅消费展示。
class RedPacketGrabNotifyElem {
  final String packetID;
  final String grabberID;
  final String grabberName;
  final String grabberFaceURL;
  final String senderID;
  final String senderName;
  final double amount;

  const RedPacketGrabNotifyElem({
    required this.packetID,
    required this.grabberID,
    this.grabberName = '',
    this.grabberFaceURL = '',
    required this.senderID,
    this.senderName = '',
    required this.amount,
  });

  factory RedPacketGrabNotifyElem.fromJson(Map<String, dynamic> json) => RedPacketGrabNotifyElem(
    packetID: json['packetID'] as String? ?? '',
    grabberID: json['grabberID'] as String? ?? '',
    grabberName: json['grabberName'] as String? ?? '',
    grabberFaceURL: json['grabberFaceURL'] as String? ?? '',
    senderID: json['senderID'] as String? ?? '',
    senderName: json['senderName'] as String? ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'packetID': packetID,
    'grabberID': grabberID,
    'grabberName': grabberName,
    'grabberFaceURL': grabberFaceURL,
    'senderID': senderID,
    'senderName': senderName,
    'amount': amount,
  };
}
