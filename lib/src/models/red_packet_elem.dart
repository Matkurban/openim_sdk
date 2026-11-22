/// 红包消息体（contentType=125）
///
/// 由发送端通过 [MessageManager.createRedPacketMessage] 构造，
/// 字段对齐后端红包业务接口的请求结构。
class RedPacketElem {
  /// 包ID。
  ///
  /// Packet ID.
  final String packetID;

  /// 包类型。
  ///
  /// Packet type.
  final int packetType;

  /// 总计金额。
  ///
  /// Total amount.
  final double totalAmount;

  /// 总计数量。
  ///
  /// Total count.
  final int totalCount;

  /// 祝福语。
  ///
  /// Greeting.
  final String greeting;

  /// 目标用户ID。
  ///
  /// Target user ID.
  final String? targetUserID;

  /// 创建 `RedPacketElem` 实例。
  ///
  /// Creates a `RedPacketElem` instance.
  ///
  /// - [packetID] 包ID / Packet ID.
  /// - [packetType] 包类型 / Packet type.
  /// - [totalAmount] 总计金额 / Total amount.
  /// - [totalCount] 总计数量 / Total count.
  /// - [greeting] 祝福语 / Greeting.
  /// - [targetUserID] 目标用户ID / Target user ID.
  const RedPacketElem({
    required this.packetID,
    required this.packetType,
    required this.totalAmount,
    required this.totalCount,
    required this.greeting,
    this.targetUserID,
  });

  /// 从 JSON 字典反序列化实例（`RedPacketElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`RedPacketElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `RedPacketElem` 结果 / Resulting `RedPacketElem`.
  factory RedPacketElem.fromJson(Map<String, dynamic> json) => RedPacketElem(
    packetID: json['packetID'] as String? ?? '',
    packetType: (json['packetType'] as num?)?.toInt() ?? 0,
    totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
    totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
    greeting: json['greeting'] as String? ?? '',
    targetUserID: json['targetUserID'] as String?,
  );

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'packetID': packetID,
    'packetType': packetType,
    'totalAmount': totalAmount,
    'totalCount': totalCount,
    'greeting': greeting,
    if (targetUserID != null) 'targetUserID': targetUserID,
  };
}
