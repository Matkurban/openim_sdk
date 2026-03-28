// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually maintained until build_runner is run.
// ignore_for_file: type=lint

part of 'red_packet.dart';

// ─── RedPacketGrabInfo ────────────────────────────────────────────────────────

RedPacketGrabInfo _$RedPacketGrabInfoFromJson(Map<String, dynamic> json) => RedPacketGrabInfo(
  grabberID: json['grabberID'] as String,
  nickname: json['nickname'] as String? ?? '',
  faceURL: json['faceURL'] as String? ?? '',
  amount: (json['amount'] as num).toDouble(),
  createTime: RedPacketGrabInfo._dateFromJson(json['createTime']),
);

Map<String, dynamic> _$RedPacketGrabInfoToJson(RedPacketGrabInfo instance) => <String, dynamic>{
  'grabberID': instance.grabberID,
  'nickname': instance.nickname,
  'faceURL': instance.faceURL,
  'amount': instance.amount,
  'createTime': instance.createTime.toIso8601String(),
};

// ─── RedPacketDetail ─────────────────────────────────────────────────────────

RedPacketDetail _$RedPacketDetailFromJson(Map<String, dynamic> json) => RedPacketDetail(
  packetID: json['packetID'] as String,
  senderID: json['senderID'] as String,
  senderNickname: json['senderNickname'] as String? ?? '',
  senderFaceURL: json['senderFaceURL'] as String? ?? '',
  packetType: (json['packetType'] as num).toInt(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  totalCount: (json['totalCount'] as num).toInt(),
  grabbedAmount: (json['grabbedAmount'] as num).toDouble(),
  grabbedCount: (json['grabbedCount'] as num).toInt(),
  status: (json['status'] as num).toInt(),
  greeting: json['greeting'] as String? ?? '恭喜发财，大吉大利',
  expireAt: RedPacketDetail._dateFromJson(json['expireAt']),
  grabs:
      (json['grabs'] as List<dynamic>?)
          ?.map((e) => RedPacketGrabInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  myGrabAmount: (json['myGrabAmount'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$RedPacketDetailToJson(RedPacketDetail instance) => <String, dynamic>{
  'packetID': instance.packetID,
  'senderID': instance.senderID,
  'senderNickname': instance.senderNickname,
  'senderFaceURL': instance.senderFaceURL,
  'packetType': instance.packetType,
  'totalAmount': instance.totalAmount,
  'totalCount': instance.totalCount,
  'grabbedAmount': instance.grabbedAmount,
  'grabbedCount': instance.grabbedCount,
  'status': instance.status,
  'greeting': instance.greeting,
  'expireAt': instance.expireAt.toIso8601String(),
  'grabs': instance.grabs.map((e) => e.toJson()).toList(),
  'myGrabAmount': instance.myGrabAmount,
};

// ─── PointsTransaction ───────────────────────────────────────────────────────

PointsTransaction _$PointsTransactionFromJson(Map<String, dynamic> json) => PointsTransaction(
  txID: json['txID'] as String,
  userID: json['userID'] as String,
  amount: (json['amount'] as num).toDouble(),
  txType: (json['txType'] as num).toInt(),
  relatedID: json['relatedID'] as String? ?? '',
  remark: json['remark'] as String? ?? '',
  createTime: PointsTransaction._dateFromJson(json['createTime']),
);

Map<String, dynamic> _$PointsTransactionToJson(PointsTransaction instance) => <String, dynamic>{
  'txID': instance.txID,
  'userID': instance.userID,
  'amount': instance.amount,
  'txType': instance.txType,
  'relatedID': instance.relatedID,
  'remark': instance.remark,
  'createTime': instance.createTime.toIso8601String(),
};
