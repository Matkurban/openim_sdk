import 'package:openim_sdk/src/enums/call_type.dart';
import 'package:openim_sdk/src/enums/call_signal_type.dart';
import 'package:openim_sdk/src/enums/call_room_type.dart';
import 'package:openim_sdk/src/models/call_record.dart';

/// 通话信令消息体（contentType=124）
///
/// 字段与 [CallRecord] 完全一致；保留为独立类型以让通话信令成为
/// SDK 的一等公民消息（通过 [Message.callSignalElem] 访问），
/// 而非塞进通用 [CustomElem.data]。
///
/// 与 [CallRecord] 互转通过 [toCallRecord] / [CallSignalElem.fromCallRecord]，
/// 这样上层既有依赖 [CallRecord] 的展示逻辑可以零改动复用。
class CallSignalElem {
  final CallRecordConversation conversation;
  final String roomId;
  final CallType callType;
  final CallRoomType callRoomType;
  final CallSignalType callSignalType;
  final CallRecordUser senderUser;
  final List<CallRecordUser> recvUser;
  final int? duration;

  const CallSignalElem({
    required this.conversation,
    required this.roomId,
    required this.callType,
    required this.callRoomType,
    required this.callSignalType,
    required this.senderUser,
    required this.recvUser,
    this.duration,
  });

  /// 由现有 [CallRecord] 构造（迁移期适配）
  factory CallSignalElem.fromCallRecord(CallRecord r) => CallSignalElem(
    conversation: r.conversation,
    roomId: r.roomId,
    callType: r.callType,
    callRoomType: r.callRoomType,
    callSignalType: r.callSignalType,
    senderUser: r.senderUser,
    recvUser: r.recvUser,
    duration: r.duration,
  );

  /// 转为 [CallRecord]，复用其 [CallRecord.getDisplayText] 等方法
  CallRecord toCallRecord() => CallRecord(
    conversation: conversation,
    roomId: roomId,
    callType: callType,
    callRoomType: callRoomType,
    callSignalType: callSignalType,
    senderUser: senderUser,
    recvUser: recvUser,
    duration: duration,
  );

  Map<String, dynamic> toJson() => {
    'conversation': conversation.toJson(),
    'roomId': roomId,
    'callType': callType.intValue,
    'callRoomType': callRoomType.value,
    'callSignalType': callSignalType.value,
    'senderUser': senderUser.toJson(),
    'recvUser': recvUser.map((u) => u.toJson()).toList(),
    'duration': duration,
  };

  factory CallSignalElem.fromJson(Map<String, dynamic> json) => CallSignalElem(
    conversation: CallRecordConversation.fromJson(
      json['conversation'] as Map<String, dynamic>? ?? {},
    ),
    roomId: json['roomId'] as String? ?? '',
    callType: CallType.fromIntValue(json['callType'] as int? ?? 1),
    callRoomType: CallRoomType.fromValue(json['callRoomType'] as int? ?? 1),
    callSignalType: CallSignalType.fromValue(json['callSignalType'] as int? ?? 1),
    senderUser: CallRecordUser.fromJson(json['senderUser'] as Map<String, dynamic>? ?? {}),
    recvUser:
        (json['recvUser'] as List<dynamic>?)
            ?.map((e) => CallRecordUser.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    duration: json['duration'] as int?,
  );
}
