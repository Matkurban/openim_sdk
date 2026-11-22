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
  /// 会话。
  ///
  /// Conversation.
  final CallRecordConversation conversation;

  /// 房间ID。
  ///
  /// Room ID.
  final String roomId;

  /// 通话类型。
  ///
  /// Call type.
  final CallType callType;

  /// 通话房间类型。
  ///
  /// Call room type.
  final CallRoomType callRoomType;

  /// 通话信令类型。
  ///
  /// Call signaling type.
  final CallSignalType callSignalType;

  /// 发送器用户。
  ///
  /// Sender user.
  final CallRecordUser senderUser;

  /// 接收用户。
  ///
  /// Receive user.
  final List<CallRecordUser> recvUser;

  /// 时长。
  ///
  /// Duration.
  final int? duration;

  /// 创建 `CallSignalElem` 实例。
  ///
  /// Creates a `CallSignalElem` instance.
  ///
  /// - [conversation] 会话 / Conversation.
  /// - [roomId] 房间ID / Room ID.
  /// - [callType] 通话类型 / Call type.
  /// - [callRoomType] 通话房间类型 / Call room type.
  /// - [callSignalType] 通话信令类型 / Call signaling type.
  /// - [senderUser] 发送器用户 / Sender user.
  /// - [recvUser] 接收用户 / Receive user.
  /// - [duration] 时长 / Duration.
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
  ///
  /// - [r] r / R.
  /// - Returns: `CallSignalElem` 结果 / Resulting `CallSignalElem`.
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
  ///
  /// - Returns: `CallRecord` 结果 / Resulting `CallRecord`.
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

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'conversation': conversation.toJson(),
    'roomId': roomId,
    'callType': callType.intValue,
    'callRoomType': callRoomType.value,
    'callSignalType': callSignalType.value,
    'senderUser': senderUser.toJson(),
    'recvUser': recvUser.map((CallRecordUser u) => u.toJson()).toList(),
    'duration': duration,
  };

  /// 从 JSON 字典反序列化实例（`CallSignalElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CallSignalElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CallSignalElem` 结果 / Resulting `CallSignalElem`.
  factory CallSignalElem.fromJson(Map<String, dynamic> json) => CallSignalElem(
    conversation: CallRecordConversation.fromJson(
      json['conversation'] as Map<String, dynamic>? ?? <String, dynamic>{},
    ),
    roomId: json['roomId'] as String? ?? '',
    callType: CallType.fromIntValue(json['callType'] as int? ?? 1),
    callRoomType: CallRoomType.fromValue(json['callRoomType'] as int? ?? 1),
    callSignalType: CallSignalType.fromValue(json['callSignalType'] as int? ?? 1),
    senderUser: CallRecordUser.fromJson(
      json['senderUser'] as Map<String, dynamic>? ?? <String, dynamic>{},
    ),
    recvUser:
        (json['recvUser'] as List<dynamic>?)
            ?.map<CallRecordUser>((dynamic e) => CallRecordUser.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const <CallRecordUser>[],
    duration: json['duration'] as int?,
  );
}
