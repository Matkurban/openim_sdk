/// 红包消息体（contentType=125）
///
/// 由发送端通过 [MessageManager.createRedPacketMessage] 构造，
/// 字段对齐后端红包业务接口的请求结构。
class RedPacketElem {
  final String packetID;
  final int packetType;
  final double totalAmount;
  final int totalCount;
  final String greeting;
  final String? targetUserID;

  const RedPacketElem({
    required this.packetID,
    required this.packetType,
    required this.totalAmount,
    required this.totalCount,
    required this.greeting,
    this.targetUserID,
  });

  factory RedPacketElem.fromJson(Map<String, dynamic> json) => RedPacketElem(
    packetID: json['packetID'] as String? ?? '',
    packetType: (json['packetType'] as num?)?.toInt() ?? 0,
    totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
    totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
    greeting: json['greeting'] as String? ?? '',
    targetUserID: json['targetUserID'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'packetID': packetID,
    'packetType': packetType,
    'totalAmount': totalAmount,
    'totalCount': totalCount,
    'greeting': greeting,
    if (targetUserID != null) 'targetUserID': targetUserID,
  };
}
