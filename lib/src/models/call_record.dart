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
  final CallRecordConversation conversation;

  /// 房间 ID
  final String roomId;

  /// 通话类型（语音/视频）
  final CallType callType;

  /// 房间类型（单聊/群聊）
  final CallRoomType callRoomType;

  /// 信令类型（邀请/接受/拒绝/取消/挂断/无响应）
  final CallSignalType callSignalType;

  /// 发起者
  final CallRecordUser senderUser;

  /// 接收者列表
  final List<CallRecordUser> recvUser;

  /// 通话时长（秒），仅挂断时有值
  final int? duration;

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
  String get formattedDuration {
    final d = duration ?? 0;
    final m = (d ~/ 60).toString().padLeft(2, '0');
    final s = (d % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// 获取展示文案
  ///
  /// [selfUserId] 当前用户 ID，用于判断发起方/接收方
  /// [labels] 各信令状态的本地化文案
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

  factory CallRecord.fromJson(Map<String, dynamic> json) {
    return CallRecord(
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
          [],
      duration: json['duration'] as int?,
    );
  }
}

/// 通话记录中的本地化文案接口
///
/// App 层实现此接口以接入 l10n。
class CallRecordLabels {
  final String calling;
  final String incomingCall;
  final String answered;
  final String otherRejected;
  final String rejected;
  final String cancelled;
  final String otherCancelled;
  final String callEnded;
  final String otherNoAnswer;
  final String missedCall;
  final String Function(String duration) callDuration;

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
class CallRecordUser {
  final String userID;
  final String? nickname;
  final String? faceURL;

  const CallRecordUser({required this.userID, this.nickname, this.faceURL});

  /// 从 SDK UserInfo 转换
  factory CallRecordUser.fromUserInfo(UserInfo info) {
    return CallRecordUser(userID: info.userID, nickname: info.nickname, faceURL: info.faceURL);
  }

  Map<String, dynamic> toJson() => {'userID': userID, 'nickname': nickname, 'faceURL': faceURL};

  factory CallRecordUser.fromJson(Map<String, dynamic> json) {
    return CallRecordUser(
      userID: json['userID'] as String? ?? '',
      nickname: json['nickname'] as String?,
      faceURL: json['faceURL'] as String?,
    );
  }
}

/// 通话记录中的轻量会话信息
class CallRecordConversation {
  final String? conversationID;
  final String? userID;
  final String? groupID;
  final String? showName;
  final String? faceURL;

  const CallRecordConversation({
    this.conversationID,
    this.userID,
    this.groupID,
    this.showName,
    this.faceURL,
  });

  /// 从 SDK ConversationInfo 转换
  factory CallRecordConversation.fromConversation(ConversationInfo conv) {
    return CallRecordConversation(
      conversationID: conv.conversationID,
      userID: conv.userID,
      groupID: conv.groupID,
      showName: conv.showName,
      faceURL: conv.faceURL,
    );
  }

  Map<String, dynamic> toJson() => {
    'conversationID': conversationID,
    'userID': userID,
    'groupID': groupID,
    'showName': showName,
    'faceURL': faceURL,
  };

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
