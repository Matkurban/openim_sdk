import 'package:openim_sdk/src/enums/call_type.dart';
import 'package:openim_sdk/src/enums/call_signal_type.dart';
import 'package:openim_sdk/src/enums/call_room_type.dart';
import 'package:openim_sdk/src/models/conversation_info.dart';
import 'package:openim_sdk/src/models/user_info.dart';

/// 通话记录消息模型
///
/// 用于序列化到聊天消息的 customElem.data 中，记录一次通话的完整信息。
class CallRecord {
  /// 所属会话信息
  ///
  /// Conversation.
  final CallRecordConversation conversation;

  /// 房间 ID
  ///
  /// Room ID.
  final String roomId;

  /// 通话类型（语音/视频）
  ///
  /// Call type.
  final CallType callType;

  /// 房间类型（单聊/群聊）
  ///
  /// Call room type.
  final CallRoomType callRoomType;

  /// 信令类型（邀请/接受/拒绝/取消/挂断/无响应）
  ///
  /// Call signaling type.
  final CallSignalType callSignalType;

  /// 发起者
  ///
  /// Sender user.
  final CallRecordUser senderUser;

  /// 接收者列表
  ///
  /// Receive user.
  final List<CallRecordUser> recvUser;

  /// 通话时长（秒），仅挂断时有值
  ///
  /// Duration.
  final int? duration;

  /// 创建 `CallRecord` 实例。
  ///
  /// Creates a `CallRecord` instance.
  ///
  /// - [conversation] 会话 / Conversation.
  /// - [roomId] 房间ID / Room ID.
  /// - [callType] 通话类型 / Call type.
  /// - [callRoomType] 通话房间类型 / Call room type.
  /// - [callSignalType] 通话信令类型 / Call signaling type.
  /// - [senderUser] 发送器用户 / Sender user.
  /// - [recvUser] 接收用户 / Receive user.
  /// - [duration] 时长 / Duration.
  const CallRecord({
    required this.conversation,
    required this.roomId,
    required this.callType,
    required this.callRoomType,
    required this.callSignalType,
    required this.senderUser,
    required this.recvUser,
    this.duration,
  });

  /// 格式化通话时长 mm:ss
  ///
  /// Formatted duration.
  String get formattedDuration {
    final int d = duration ?? 0;
    final String m = (d ~/ 60).toString().padLeft(2, '0');
    final String s = (d % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// 获取展示文案
  ///
  /// [selfUserId] 当前用户 ID，用于判断发起方/接收方
  /// [labels] 各信令状态的本地化文案
  ///
  /// - Returns: 字符串结果 / String result.
  String getDisplayText({required String selfUserId, required CallRecordLabels labels}) {
    final bool isSender = senderUser.userID == selfUserId;

    if (callSignalType == CallSignalType.hungup && duration != null && duration! > 0) {
      return labels.callDuration(formattedDuration);
    }

    return switch (callSignalType) {
      CallSignalType.invite => isSender ? labels.calling : labels.incomingCall,
      CallSignalType.accept => labels.answered,
      CallSignalType.reject => isSender ? labels.otherRejected : labels.rejected,
      CallSignalType.cancel => isSender ? labels.cancelled : labels.otherCancelled,
      CallSignalType.hungup => labels.callEnded,
      CallSignalType.noResponse => isSender ? labels.otherNoAnswer : labels.missedCall,
    };
  }

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

  /// 从 JSON 字典反序列化实例（`CallRecord.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CallRecord.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CallRecord` 结果 / Resulting `CallRecord`.
  factory CallRecord.fromJson(Map<String, dynamic> json) {
    return CallRecord(
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
              ?.map<CallRecordUser>(
                (dynamic e) => CallRecordUser.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <CallRecordUser>[],
      duration: json['duration'] as int?,
    );
  }
}

/// 通话记录中的本地化文案接口
///
/// App 层实现此接口以接入 l10n。
class CallRecordLabels {
  /// calling。
  ///
  /// Calling.
  final String calling;

  /// incoming通话。
  ///
  /// Incoming call.
  final String incomingCall;

  /// answered。
  ///
  /// Answered.
  final String answered;

  /// other已拒绝。
  ///
  /// Other rejected.
  final String otherRejected;

  /// 已拒绝。
  ///
  /// Rejected.
  final String rejected;

  /// cancelled。
  ///
  /// Cancelled.
  final String cancelled;

  /// otherCancelled。
  ///
  /// Other cancelled.
  final String otherCancelled;

  /// 通话Ended。
  ///
  /// Call ended.
  final String callEnded;

  /// otherNoAnswer。
  ///
  /// Other no answer.
  final String otherNoAnswer;

  /// missed通话。
  ///
  /// Missed call.
  final String missedCall;

  /// 通话时长。
  ///
  /// Call duration.
  final String Function(String duration) callDuration;

  /// 创建 `CallRecordLabels` 实例。
  ///
  /// Creates a `CallRecordLabels` instance.
  ///
  /// - [calling] calling / Calling.
  /// - [incomingCall] incoming通话 / Incoming call.
  /// - [answered] answered / Answered.
  /// - [otherRejected] other已拒绝 / Other rejected.
  /// - [rejected] 已拒绝 / Rejected.
  /// - [cancelled] cancelled / Cancelled.
  /// - [otherCancelled] otherCancelled / Other cancelled.
  /// - [callEnded] 通话Ended / Call ended.
  /// - [otherNoAnswer] otherNoAnswer / Other no answer.
  /// - [missedCall] missed通话 / Missed call.
  /// - [callDuration] 通话时长 / Call duration.
  const CallRecordLabels({
    required this.calling,
    required this.incomingCall,
    required this.answered,
    required this.otherRejected,
    required this.rejected,
    required this.cancelled,
    required this.otherCancelled,
    required this.callEnded,
    required this.otherNoAnswer,
    required this.missedCall,
    required this.callDuration,
  });
}

/// 通话记录中的轻量用户信息
///
/// Call record user.
class CallRecordUser {
  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 昵称。
  ///
  /// Nickname.
  final String? nickname;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String? faceURL;

  /// 创建 `CallRecordUser` 实例。
  ///
  /// Creates a `CallRecordUser` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  const CallRecordUser({required this.userID, this.nickname, this.faceURL});

  /// 从 SDK UserInfo 转换
  ///
  /// - [info] 信息 / Info.
  /// - Returns: `CallRecordUser` 结果 / Resulting `CallRecordUser`.
  factory CallRecordUser.fromUserInfo(UserInfo info) {
    return CallRecordUser(userID: info.userID, nickname: info.nickname, faceURL: info.faceURL);
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'userID': userID,
    'nickname': nickname,
    'faceURL': faceURL,
  };

  /// 从 JSON 字典反序列化实例（`CallRecordUser.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CallRecordUser.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CallRecordUser` 结果 / Resulting `CallRecordUser`.
  factory CallRecordUser.fromJson(Map<String, dynamic> json) {
    return CallRecordUser(
      userID: json['userID'] as String? ?? '',
      nickname: json['nickname'] as String?,
      faceURL: json['faceURL'] as String?,
    );
  }
}

/// 通话记录中的轻量会话信息
///
/// Call record conversation.
class CallRecordConversation {
  /// 会话ID。
  ///
  /// Conversation ID.
  final String? conversationID;

  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 群组ID。
  ///
  /// Group ID.
  final String? groupID;

  /// 展示名称。
  ///
  /// Display name.
  final String? showName;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String? faceURL;

  /// 创建 `CallRecordConversation` 实例。
  ///
  /// Creates a `CallRecordConversation` instance.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - [showName] 展示名称 / Display name.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  const CallRecordConversation({
    this.conversationID,
    this.userID,
    this.groupID,
    this.showName,
    this.faceURL,
  });

  /// 从 SDK ConversationInfo 转换
  ///
  /// - [conv] 会话 / Conversation.
  /// - Returns: `CallRecordConversation` 结果 / Resulting `CallRecordConversation`.
  factory CallRecordConversation.fromConversation(ConversationInfo conv) {
    return CallRecordConversation(
      conversationID: conv.conversationID,
      userID: conv.userID,
      groupID: conv.groupID,
      showName: conv.showName,
      faceURL: conv.faceURL,
    );
  }

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'conversationID': conversationID,
    'userID': userID,
    'groupID': groupID,
    'showName': showName,
    'faceURL': faceURL,
  };

  /// 从 JSON 字典反序列化实例（`CallRecordConversation.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CallRecordConversation.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CallRecordConversation` 结果 / Resulting `CallRecordConversation`.
  factory CallRecordConversation.fromJson(Map<String, dynamic> json) {
    return CallRecordConversation(
      conversationID: json['conversationID'] as String?,
      userID: json['userID'] as String?,
      groupID: json['groupID'] as String?,
      showName: json['showName'] as String?,
      faceURL: json['faceURL'] as String?,
    );
  }
}
