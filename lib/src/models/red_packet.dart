import 'package:json_annotation/json_annotation.dart';

part 'red_packet.g.dart';

// ─── 红包类型 ─────────────────────────────────────────────────────────────────

/// 红包类型
enum RedPacketType {
  single(0), // 单人专属红包
  luck(1), // 拼手气红包
  equal(2); // 均等红包

  const RedPacketType(this.value);
  final int value;

  static RedPacketType fromValue(int v) =>
      RedPacketType.values.firstWhere((e) => e.value == v, orElse: () => RedPacketType.luck);
}

/// 红包状态
enum RedPacketStatus {
  active(0),
  exhausted(1),
  expired(2);

  const RedPacketStatus(this.value);
  final int value;

  static RedPacketStatus fromValue(int v) =>
      RedPacketStatus.values.firstWhere((e) => e.value == v, orElse: () => RedPacketStatus.active);
}

// ─── 请求类 ───────────────────────────────────────────────────────────────────

class SendRedPacketRequest {
  final int packetType;
  final double totalAmount;
  final int totalCount;
  final String greeting;
  final String? targetUserID;
  final String convID;

  const SendRedPacketRequest({
    required this.packetType,
    required this.totalAmount,
    required this.totalCount,
    required this.greeting,
    required this.convID,
    this.targetUserID,
  });

  Map<String, dynamic> toJson() => {
    'packetType': packetType,
    'totalAmount': totalAmount,
    'totalCount': totalCount,
    'greeting': greeting,
    'convID': convID,
    if (targetUserID != null) 'targetUserID': targetUserID,
  };
}

// ─── 响应 / 展示模型 ──────────────────────────────────────────────────────────

@JsonSerializable()
class RedPacketGrabInfo {
  final String grabberID;
  final String nickname;
  final String faceURL;
  final double amount;
  @JsonKey(fromJson: _dateFromJson)
  final DateTime createTime;

  const RedPacketGrabInfo({
    required this.grabberID,
    this.nickname = '',
    this.faceURL = '',
    required this.amount,
    required this.createTime,
  });

  factory RedPacketGrabInfo.fromJson(Map<String, dynamic> json) =>
      _$RedPacketGrabInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RedPacketGrabInfoToJson(this);

  static DateTime _dateFromJson(dynamic v) {
    if (v is String) return DateTime.parse(v);
    return DateTime.fromMillisecondsSinceEpoch((v as num).toInt());
  }
}

@JsonSerializable()
class RedPacketDetail {
  final String packetID;
  final String senderID;
  final String senderNickname;
  final String senderFaceURL;
  final int packetType;
  final double totalAmount;
  final int totalCount;
  final double grabbedAmount;
  final int grabbedCount;
  final int status;
  final String greeting;
  @JsonKey(fromJson: _dateFromJson)
  final DateTime expireAt;
  final List<RedPacketGrabInfo> grabs;

  /// 当前用户领取金额（0=未领取）
  final double myGrabAmount;

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

  factory RedPacketDetail.fromJson(Map<String, dynamic> json) => _$RedPacketDetailFromJson(json);
  Map<String, dynamic> toJson() => _$RedPacketDetailToJson(this);

  static DateTime _dateFromJson(dynamic v) {
    if (v is String) return DateTime.parse(v);
    return DateTime.fromMillisecondsSinceEpoch((v as num).toInt());
  }

  RedPacketStatus get statusEnum => RedPacketStatus.fromValue(status);
  RedPacketType get typeEnum => RedPacketType.fromValue(packetType);

  bool get isExpired => statusEnum == RedPacketStatus.expired || DateTime.now().isAfter(expireAt);
  bool get isExhausted => statusEnum == RedPacketStatus.exhausted;
  bool get isGrabbed => myGrabAmount > 0;
  bool get canGrab => !isExpired && !isExhausted && !isGrabbed;
}

// ─── 积分流水 ─────────────────────────────────────────────────────────────────

@JsonSerializable()
class PointsTransaction {
  final String txID;
  final String userID;
  final double amount;
  final int txType;
  final String relatedID;
  final String remark;
  @JsonKey(fromJson: _dateFromJson)
  final DateTime createTime;

  const PointsTransaction({
    required this.txID,
    required this.userID,
    required this.amount,
    required this.txType,
    required this.relatedID,
    required this.remark,
    required this.createTime,
  });

  factory PointsTransaction.fromJson(Map<String, dynamic> json) =>
      _$PointsTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$PointsTransactionToJson(this);

  static DateTime _dateFromJson(dynamic v) {
    if (v is String) return DateTime.parse(v);
    return DateTime.fromMillisecondsSinceEpoch((v as num).toInt());
  }
}

// ─── 自定义消息 payload ───────────────────────────────────────────────────────

/// 红包气泡嵌入到 OpenIM 自定义消息的 data 字段
class RedPacketMessageData {
  final String packetID;
  final int packetType;
  final double totalAmount;
  final int totalCount;
  final String greeting;
  final String? targetUserID;

  const RedPacketMessageData({
    required this.packetID,
    required this.packetType,
    required this.totalAmount,
    required this.totalCount,
    required this.greeting,
    this.targetUserID,
  });

  factory RedPacketMessageData.fromJson(Map<String, dynamic> json) => RedPacketMessageData(
    packetID: json['packetID'] as String,
    packetType: (json['packetType'] as num).toInt(),
    totalAmount: (json['totalAmount'] as num).toDouble(),
    totalCount: (json['totalCount'] as num).toInt(),
    greeting: json['greeting'] as String? ?? '恭喜发财，大吉大利',
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

/// 红包被领取通知（business notification）的 data 字段。
/// 用于实时刷新红包气泡状态（已领取/已领完）。
class RedPacketGrabbedNotify {
  final String packetID;
  final String grabberID;
  final String grabberName;
  final String grabberFaceURL;
  final double amount;
  final String convID;

  const RedPacketGrabbedNotify({
    required this.packetID,
    required this.grabberID,
    this.grabberName = '',
    this.grabberFaceURL = '',
    required this.amount,
    required this.convID,
  });

  factory RedPacketGrabbedNotify.fromJson(Map<String, dynamic> json) => RedPacketGrabbedNotify(
    packetID: json['packetID'] as String,
    grabberID: json['grabberID'] as String,
    grabberName: json['grabberName'] as String? ?? json['grabberID'] as String? ?? '',
    grabberFaceURL: json['grabberFaceURL'] as String? ?? '',
    amount: (json['amount'] as num).toDouble(),
    convID: json['convID'] as String,
  );
}

/// 红包领取提示（真实 IM 自定义消息）的 data 字段。
/// 由服务端在抢红包成功后发送到会话中，作为聊天记录中可见的领取提示条。
/// description = "redPacketGrabNotify"
class RedPacketGrabNotifyMessageData {
  final String packetID;
  final String grabberID;
  final String grabberName;
  final String grabberFaceURL;
  final String senderID;
  final String senderName;
  final double amount;

  const RedPacketGrabNotifyMessageData({
    required this.packetID,
    required this.grabberID,
    this.grabberName = '',
    this.grabberFaceURL = '',
    required this.senderID,
    this.senderName = '',
    required this.amount,
  });

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
  final String packetID;
  const RedPacketExpiredNotify({required this.packetID});
  factory RedPacketExpiredNotify.fromJson(Map<String, dynamic> json) =>
      RedPacketExpiredNotify(packetID: json['packetID'] as String? ?? json as String);
}
