import 'package:json_annotation/json_annotation.dart';

part 'red_packet.g.dart';

// ─── 红包类型 ─────────────────────────────────────────────────────────────────

/// 红包类型
///
/// Red packet type enum.
enum RedPacketType {
  /// 单聊。
  ///
  /// Single.
  single(0), // 单人专属红包
  /// luck。
  ///
  /// Luck.
  luck(1), // 拼手气红包
  /// equal。
  ///
  /// Equal.
  equal(2); // 均等红包

  /// 创建 `RedPacketType` 实例。
  ///
  /// Creates a `RedPacketType` instance.
  ///
  /// - [value] 值 / Value.
  const RedPacketType(this.value);

  /// 值。
  ///
  /// Value.
  final int value;

  /// 从值。
  ///
  /// From value.
  ///
  /// - [v] v / V.
  /// - Returns: `RedPacketType` 结果 / Resulting `RedPacketType`.
  static RedPacketType fromValue(int v) => RedPacketType.values.firstWhere(
    (RedPacketType e) => e.value == v,
    orElse: () => RedPacketType.luck,
  );
}

/// 红包状态
///
/// Red packet status enum.
enum RedPacketStatus {
  /// 活跃。
  ///
  /// Active.
  active(0),

  /// exhausted。
  ///
  /// Exhausted.
  exhausted(1),

  /// expired。
  ///
  /// Expired.
  expired(2);

  /// 创建 `RedPacketStatus` 实例。
  ///
  /// Creates a `RedPacketStatus` instance.
  ///
  /// - [value] 值 / Value.
  const RedPacketStatus(this.value);

  /// 值。
  ///
  /// Value.
  final int value;

  /// 从值。
  ///
  /// From value.
  ///
  /// - [v] v / V.
  /// - Returns: `RedPacketStatus` 结果 / Resulting `RedPacketStatus`.
  static RedPacketStatus fromValue(int v) => RedPacketStatus.values.firstWhere(
    (RedPacketStatus e) => e.value == v,
    orElse: () => RedPacketStatus.active,
  );
}

// ─── 请求类 ───────────────────────────────────────────────────────────────────

/// 发送红包申请/请求。
///
/// Send red packet request.
class SendRedPacketRequest {
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

  /// 会话ID。
  ///
  /// Conversation ID.
  final String convID;

  /// 创建 `SendRedPacketRequest` 实例。
  ///
  /// Creates a `SendRedPacketRequest` instance.
  ///
  /// - [packetType] 包类型 / Packet type.
  /// - [totalAmount] 总计金额 / Total amount.
  /// - [totalCount] 总计数量 / Total count.
  /// - [greeting] 祝福语 / Greeting.
  /// - [convID] 会话ID / Conversation ID.
  /// - [targetUserID] 目标用户ID / Target user ID.
  const SendRedPacketRequest({
    required this.packetType,
    required this.totalAmount,
    required this.totalCount,
    required this.greeting,
    required this.convID,
    this.targetUserID,
  });

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'packetType': packetType,
    'totalAmount': totalAmount,
    'totalCount': totalCount,
    'greeting': greeting,
    'convID': convID,
    if (targetUserID != null) 'targetUserID': targetUserID,
  };

  /// 从 JSON 字典反序列化实例（`SendRedPacketRequest.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`SendRedPacketRequest.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `SendRedPacketRequest` 结果 / Resulting `SendRedPacketRequest`.
  factory SendRedPacketRequest.fromJson(Map<String, dynamic> json) {
    return SendRedPacketRequest(
      packetType: json['packetType'] as int? ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      totalCount: json['totalCount'] as int? ?? 0,
      greeting: json['greeting'] as String? ?? '',
      convID: json['convID'] as String? ?? '',
      targetUserID: json['targetUserID'] as String?,
    );
  }
}

// ─── 响应 / 展示模型 ──────────────────────────────────────────────────────────

/// 红包领取信息。
///
/// Red packet grab info.
@JsonSerializable()
class RedPacketGrabInfo {
  /// grabberID。
  ///
  /// Grabber ID.
  final String grabberID;

  /// 昵称。
  ///
  /// Nickname.
  final String nickname;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String faceURL;

  /// 金额。
  ///
  /// Amount.
  final double amount;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  @JsonKey(fromJson: _dateFromJson)
  final DateTime createTime;

  /// 创建 `RedPacketGrabInfo` 实例。
  ///
  /// Creates a `RedPacketGrabInfo` instance.
  ///
  /// - [grabberID] grabberID / Grabber ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [amount] 金额 / Amount.
  /// - [createTime] 创建时间戳 / Create timestamp.
  const RedPacketGrabInfo({
    required this.grabberID,
    this.nickname = '',
    this.faceURL = '',
    required this.amount,
    required this.createTime,
  });

  /// 从 JSON 字典反序列化实例（`RedPacketGrabInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`RedPacketGrabInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `RedPacketGrabInfo` 结果 / Resulting `RedPacketGrabInfo`.
  factory RedPacketGrabInfo.fromJson(Map<String, dynamic> json) =>
      _$RedPacketGrabInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$RedPacketGrabInfoToJson(this);

  static DateTime _dateFromJson(dynamic v) {
    if (v is String) return DateTime.parse(v);
    return DateTime.fromMillisecondsSinceEpoch((v as num).toInt());
  }
}

/// 红包详情。
///
/// Red packet detail.
@JsonSerializable()
class RedPacketDetail {
  /// 包ID。
  ///
  /// Packet ID.
  final String packetID;

  /// 发送器ID。
  ///
  /// Sender ID.
  final String senderID;

  /// 发送器昵称。
  ///
  /// Sender nickname.
  final String senderNickname;

  /// 发送器头像URL 地址。
  ///
  /// Sender avatar URL.
  final String senderFaceURL;

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

  /// 已领取金额。
  ///
  /// Grabbed amount.
  final double grabbedAmount;

  /// 已领取数量。
  ///
  /// Grabbed count.
  final int grabbedCount;

  /// 状态。
  ///
  /// Status.
  final int status;

  /// 祝福语。
  ///
  /// Greeting.
  final String greeting;

  /// expire@提及。
  ///
  /// Expire @-mention.
  @JsonKey(fromJson: _dateFromJson)
  final DateTime expireAt;

  /// grabs。
  ///
  /// Grabs.
  final List<RedPacketGrabInfo> grabs;

  /// 当前用户领取金额（0=未领取）
  ///
  /// My grab amount.
  final double myGrabAmount;

  /// 创建 `RedPacketDetail` 实例。
  ///
  /// Creates a `RedPacketDetail` instance.
  ///
  /// - [packetID] 包ID / Packet ID.
  /// - [senderID] 发送器ID / Sender ID.
  /// - [senderNickname] 发送器昵称 / Sender nickname.
  /// - [senderFaceURL] 发送器头像URL 地址 / Sender avatar URL.
  /// - [packetType] 包类型 / Packet type.
  /// - [totalAmount] 总计金额 / Total amount.
  /// - [totalCount] 总计数量 / Total count.
  /// - [grabbedAmount] 已领取金额 / Grabbed amount.
  /// - [grabbedCount] 已领取数量 / Grabbed count.
  /// - [status] 状态 / Status.
  /// - [greeting] 祝福语 / Greeting.
  /// - [expireAt] expire@提及 / Expire @-mention.
  /// - [grabs] grabs / Grabs.
  /// - [myGrabAmount] my领取金额 / My grab amount.
  const RedPacketDetail({
    required this.packetID,
    required this.senderID,
    this.senderNickname = '',
    this.senderFaceURL = '',
    required this.packetType,
    required this.totalAmount,
    required this.totalCount,
    required this.grabbedAmount,
    required this.grabbedCount,
    required this.status,
    required this.greeting,
    required this.expireAt,
    required this.grabs,
    required this.myGrabAmount,
  });

  /// 从 JSON 字典反序列化实例（`RedPacketDetail.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`RedPacketDetail.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `RedPacketDetail` 结果 / Resulting `RedPacketDetail`.
  factory RedPacketDetail.fromJson(Map<String, dynamic> json) => _$RedPacketDetailFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$RedPacketDetailToJson(this);

  static DateTime _dateFromJson(dynamic v) {
    if (v is String) return DateTime.parse(v);
    return DateTime.fromMillisecondsSinceEpoch((v as num).toInt());
  }

  /// 状态Enum。
  ///
  /// Status enum.
  RedPacketStatus get statusEnum => RedPacketStatus.fromValue(status);

  /// 类型Enum。
  ///
  /// Type enum.
  RedPacketType get typeEnum => RedPacketType.fromValue(packetType);

  /// 是否Expired。
  ///
  /// Whether expired.
  bool get isExpired => statusEnum == RedPacketStatus.expired || DateTime.now().isAfter(expireAt);

  /// 是否Exhausted。
  ///
  /// Whether exhausted.
  bool get isExhausted => statusEnum == RedPacketStatus.exhausted;

  /// 是否已领取。
  ///
  /// Whether grabbed.
  bool get isGrabbed => myGrabAmount > 0;

  /// 是否支持领取。
  ///
  /// Whether can grab.
  bool get canGrab => !isExpired && !isExhausted && !isGrabbed;
}

// ─── 积分流水 ─────────────────────────────────────────────────────────────────

/// 积分流水交易类型
///
/// Points tx type enum.
enum PointsTxType {
  /// 发送红包。
  ///
  /// Send red packet.
  sendRedPacket(1),

  /// receive红包。
  ///
  /// Receive red packet.
  receiveRedPacket(2),

  /// refund。
  ///
  /// Refund.
  refund(3),

  /// 管理员添加。
  ///
  /// Administrator add.
  adminAdd(4),

  /// 管理员Sub。
  ///
  /// Administrator sub.
  adminSub(5);

  /// 创建 `PointsTxType` 实例。
  ///
  /// Creates a `PointsTxType` instance.
  ///
  /// - [value] 值 / Value.
  const PointsTxType(this.value);

  /// 值。
  ///
  /// Value.
  final int value;

  /// 从值。
  ///
  /// From value.
  ///
  /// - [v] v / V.
  /// - Returns: `PointsTxType?` 结果 / Resulting `PointsTxType?`.
  static PointsTxType? fromValue(int v) {
    for (final PointsTxType e in values) {
      if (e.value == v) return e;
    }
    return null;
  }

  /// 是否为收入类型（收红包、退款、管理加）
  ///
  /// Whether income.
  bool get isIncome => this == receiveRedPacket || this == refund || this == adminAdd;

  /// 是否为支出类型（发红包、管理减）
  ///
  /// Whether expense.
  bool get isExpense => this == sendRedPacket || this == adminSub;
}

/// 积分交易记录。
///
/// Points transaction.
@JsonSerializable()
class PointsTransaction {
  /// txID。
  ///
  /// Tx ID.
  final String txID;

  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 金额。
  ///
  /// Amount.
  final double amount;

  /// tx类型。
  ///
  /// Tx type.
  final int txType;

  /// relatedID。
  ///
  /// Related ID.
  final String relatedID;

  /// 备注。
  ///
  /// Remark.
  final String remark;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  @JsonKey(fromJson: _dateFromJson)
  final DateTime createTime;

  /// 创建 `PointsTransaction` 实例。
  ///
  /// Creates a `PointsTransaction` instance.
  ///
  /// - [txID] txID / Tx ID.
  /// - [userID] 用户ID / User ID.
  /// - [amount] 金额 / Amount.
  /// - [txType] tx类型 / Tx type.
  /// - [relatedID] relatedID / Related ID.
  /// - [remark] 备注 / Remark.
  /// - [createTime] 创建时间戳 / Create timestamp.
  const PointsTransaction({
    required this.txID,
    required this.userID,
    required this.amount,
    required this.txType,
    required this.relatedID,
    required this.remark,
    required this.createTime,
  });

  /// 从 JSON 字典反序列化实例（`PointsTransaction.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`PointsTransaction.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `PointsTransaction` 结果 / Resulting `PointsTransaction`.
  factory PointsTransaction.fromJson(Map<String, dynamic> json) =>
      _$PointsTransactionFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$PointsTransactionToJson(this);

  static DateTime _dateFromJson(dynamic v) {
    if (v is String) return DateTime.parse(v);
    return DateTime.fromMillisecondsSinceEpoch((v as num).toInt());
  }

  /// tx类型Enum。
  ///
  /// Tx type enum.
  PointsTxType? get txTypeEnum => PointsTxType.fromValue(txType);

  /// 是否Income。
  ///
  /// Whether income.
  bool get isIncome => txTypeEnum?.isIncome ?? false;

  /// 是否Expense。
  ///
  /// Whether expense.
  bool get isExpense => txTypeEnum?.isExpense ?? false;
}

// ─── 自定义消息 payload ───────────────────────────────────────────────────────

/// 红包气泡嵌入到 OpenIM 自定义消息的 data 字段
class RedPacketMessageData {
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

  /// 创建 `RedPacketMessageData` 实例。
  ///
  /// Creates a `RedPacketMessageData` instance.
  ///
  /// - [packetID] 包ID / Packet ID.
  /// - [packetType] 包类型 / Packet type.
  /// - [totalAmount] 总计金额 / Total amount.
  /// - [totalCount] 总计数量 / Total count.
  /// - [greeting] 祝福语 / Greeting.
  /// - [targetUserID] 目标用户ID / Target user ID.
  const RedPacketMessageData({
    required this.packetID,
    required this.packetType,
    required this.totalAmount,
    required this.totalCount,
    required this.greeting,
    this.targetUserID,
  });

  /// 从 JSON 字典反序列化实例（`RedPacketMessageData.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`RedPacketMessageData.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `RedPacketMessageData` 结果 / Resulting `RedPacketMessageData`.
  factory RedPacketMessageData.fromJson(Map<String, dynamic> json) => RedPacketMessageData(
    packetID: json['packetID'] as String,
    packetType: (json['packetType'] as num).toInt(),
    totalAmount: (json['totalAmount'] as num).toDouble(),
    totalCount: (json['totalCount'] as num).toInt(),
    greeting: json['greeting'] as String? ?? '恭喜发财，大吉大利',
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

/// 红包领取提示（真实 IM 自定义消息）的 data 字段。
/// 由服务端在抢红包成功后发送到会话中，作为聊天记录中可见的领取提示条。
/// description = "redPacketGrabNotify"
class RedPacketGrabNotifyMessageData {
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

  /// 创建 `RedPacketGrabNotifyMessageData` 实例。
  ///
  /// Creates a `RedPacketGrabNotifyMessageData` instance.
  ///
  /// - [packetID] 包ID / Packet ID.
  /// - [grabberID] grabberID / Grabber ID.
  /// - [grabberName] grabber名称 / Grabber name.
  /// - [grabberFaceURL] grabber头像URL 地址 / Grabber avatar URL.
  /// - [senderID] 发送器ID / Sender ID.
  /// - [senderName] 发送器名称 / Sender name.
  /// - [amount] 金额 / Amount.
  const RedPacketGrabNotifyMessageData({
    required this.packetID,
    required this.grabberID,
    this.grabberName = '',
    this.grabberFaceURL = '',
    required this.senderID,
    this.senderName = '',
    required this.amount,
  });

  /// 从 JSON 字典反序列化实例（`RedPacketGrabNotifyMessageData.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`RedPacketGrabNotifyMessageData.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `RedPacketGrabNotifyMessageData` 结果 / Resulting `RedPacketGrabNotifyMessageData`.
  factory RedPacketGrabNotifyMessageData.fromJson(Map<String, dynamic> json) =>
      RedPacketGrabNotifyMessageData(
        packetID: json['packetID'] as String,
        grabberID: json['grabberID'] as String,
        grabberName: json['grabberName'] as String? ?? '',
        grabberFaceURL: json['grabberFaceURL'] as String? ?? '',
        senderID: json['senderID'] as String? ?? '',
        senderName: json['senderName'] as String? ?? '',
        amount: (json['amount'] as num).toDouble(),
      );
}

/// 红包过期通知的 data 字段
class RedPacketExpiredNotify {
  /// 包ID。
  ///
  /// Packet ID.
  final String packetID;

  /// 创建 `RedPacketExpiredNotify` 实例。
  ///
  /// Creates a `RedPacketExpiredNotify` instance.
  ///
  /// - [packetID] 包ID / Packet ID.
  const RedPacketExpiredNotify({required this.packetID});

  /// 从 JSON 字典反序列化实例（`RedPacketExpiredNotify.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`RedPacketExpiredNotify.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `RedPacketExpiredNotify` 结果 / Resulting `RedPacketExpiredNotify`.
  factory RedPacketExpiredNotify.fromJson(Map<String, dynamic> json) => RedPacketExpiredNotify(
    packetID: json['packetID']?.toString() ?? json['value']?.toString() ?? '',
  );
}
