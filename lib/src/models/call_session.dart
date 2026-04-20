import 'dart:convert';

import 'package:openim_sdk/src/enums/call_type.dart';
import 'package:openim_sdk/src/enums/call_state.dart';

/// 信令动作
class SignalAction {
  static const String invite = 'invite';
  static const String accept = 'accept';
  static const String reject = 'reject';
  static const String cancel = 'cancel';
  static const String hangup = 'hangup';
  static const String busy = 'busy';
  static const String timeout = 'timeout';
}

/// 通话信令消息
class CallSignaling {
  /// 信令动作
  final String action;

  /// 房间ID
  final String roomID;

  /// 通话类型
  final CallType callType;

  /// 发起者用户ID
  final String inviterUserID;

  /// 被邀请者用户ID列表
  final List<String> inviteeUserIDs;

  /// LiveKit 服务器地址
  final String? liveURL;

  /// 超时时间（秒）
  final int timeout;

  /// 时间戳
  final int timestamp;

  /// 附加数据（如拒绝原因等）
  final String? extra;

  const CallSignaling({
    required this.action,
    required this.roomID,
    required this.callType,
    required this.inviterUserID,
    this.inviteeUserIDs = const [],
    this.liveURL,
    this.timeout = 60,
    int? timestamp,
    this.extra,
  }) : timestamp = timestamp ?? 0;

  CallSignaling copyWith({
    String? action,
    String? roomID,
    CallType? callType,
    String? inviterUserID,
    List<String>? inviteeUserIDs,
    String? liveURL,
    int? timeout,
    int? timestamp,
    String? extra,
  }) {
    return CallSignaling(
      action: action ?? this.action,
      roomID: roomID ?? this.roomID,
      callType: callType ?? this.callType,
      inviterUserID: inviterUserID ?? this.inviterUserID,
      inviteeUserIDs: inviteeUserIDs ?? this.inviteeUserIDs,
      liveURL: liveURL ?? this.liveURL,
      timeout: timeout ?? this.timeout,
      timestamp: timestamp ?? this.timestamp,
      extra: extra ?? this.extra,
    );
  }

  Map<String, dynamic> toJson() => {
    'action': action,
    'roomID': roomID,
    'callType': callType.value,
    'inviterUserID': inviterUserID,
    'inviteeUserIDs': inviteeUserIDs,
    'liveURL': liveURL,
    'timeout': timeout,
    'timestamp': timestamp,
    'extra': extra,
  };

  factory CallSignaling.fromJson(Map<String, dynamic> json) {
    return CallSignaling(
      action: json['action'] as String? ?? '',
      roomID: json['roomID'] as String? ?? '',
      callType: CallType.fromValue(json['callType'] as String? ?? 'audio'),
      inviterUserID: json['inviterUserID'] as String? ?? '',
      inviteeUserIDs:
          (json['inviteeUserIDs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      liveURL: json['liveURL'] as String?,
      timeout: json['timeout'] as int? ?? 60,
      timestamp: json['timestamp'] as int? ?? 0,
      extra: json['extra'] as String?,
    );
  }

  String encode() => jsonEncode(toJson());

  static CallSignaling? decode(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return CallSignaling.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// 信令 custom message 的 businessID 标识
  static const String businessID = 'rtc_signaling';
}

/// 通话会话，代表一次正在进行的通话
class CallSession {
  /// 房间ID
  final String roomID;

  /// 通话类型
  final CallType callType;

  /// 发起者用户ID
  final String inviterUserID;

  /// 被邀请者用户ID列表
  final List<String> inviteeUserIDs;

  /// LiveKit 服务器地址
  final String? liveURL;

  /// LiveKit Token
  String? token;

  /// 当前通话状态
  CallState state;

  /// 创建时间
  final int createTime;

  /// 接通时间
  int? connectTime;

  /// 是否为群组通话（多人）
  bool get isGroupCall => inviteeUserIDs.length > 1;

  /// 已接受的用户列表（多人通话用）
  final Set<String> acceptedUserIDs = {};

  /// 已拒绝的用户列表（多人通话用）
  final Set<String> rejectedUserIDs = {};

  CallSession({
    required this.roomID,
    required this.callType,
    required this.inviterUserID,
    required this.inviteeUserIDs,
    this.liveURL,
    this.token,
    this.state = CallState.idle,
    int? createTime,
    this.connectTime,
  }) : createTime = createTime ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() => {
    'roomID': roomID,
    'callType': callType.value,
    'inviterUserID': inviterUserID,
    'inviteeUserIDs': inviteeUserIDs,
    'liveURL': liveURL,
    'token': token,
    'state': state.name,
    'createTime': createTime,
    'connectTime': connectTime,
    'acceptedUserIDs': acceptedUserIDs.toList(),
    'rejectedUserIDs': rejectedUserIDs.toList(),
  };

  factory CallSession.fromJson(Map<String, dynamic> json) {
    final session = CallSession(
      roomID: json['roomID'] as String? ?? '',
      callType: CallType.fromValue(json['callType'] as String? ?? 'audio'),
      inviterUserID: json['inviterUserID'] as String? ?? '',
      inviteeUserIDs:
          (json['inviteeUserIDs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      liveURL: json['liveURL'] as String?,
      token: json['token'] as String?,
      state: CallState.values.firstWhere(
        (e) => e.name == (json['state'] as String?),
        orElse: () => CallState.idle,
      ),
      createTime: json['createTime'] as int?,
      connectTime: json['connectTime'] as int?,
    );
    final accepted = json['acceptedUserIDs'] as List?;
    if (accepted != null) session.acceptedUserIDs.addAll(accepted.cast<String>());
    final rejected = json['rejectedUserIDs'] as List?;
    if (rejected != null) session.rejectedUserIDs.addAll(rejected.cast<String>());
    return session;
  }
}

/// 后端创建会议的响应
class CreateMeetingResult {
  final String roomID;
  final String token;
  final String liveURL;
  final List<String> busyUsers;

  const CreateMeetingResult({
    required this.roomID,
    required this.token,
    required this.liveURL,
    this.busyUsers = const [],
  });

  factory CreateMeetingResult.fromJson(Map<String, dynamic> json) {
    return CreateMeetingResult(
      roomID: json['roomID'] as String? ?? '',
      token: json['token'] as String? ?? '',
      liveURL: json['liveURL'] as String? ?? '',
      busyUsers: (json['busyUsers'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

/// 后端加入会议的响应
class JoinMeetingResult {
  final String token;
  final String liveURL;
  final String roomID;
  final String callType;
  final List<MeetingParticipant> participants;

  const JoinMeetingResult({
    required this.token,
    required this.liveURL,
    required this.roomID,
    required this.callType,
    this.participants = const [],
  });

  factory JoinMeetingResult.fromJson(Map<String, dynamic> json) {
    return JoinMeetingResult(
      token: json['token'] as String? ?? '',
      liveURL: json['liveURL'] as String? ?? '',
      roomID: json['roomID'] as String? ?? '',
      callType: json['callType'] as String? ?? '',
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map((e) => MeetingParticipant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// 会议参与者信息
class MeetingParticipant {
  final String userID;
  final int joinTime;

  const MeetingParticipant({required this.userID, required this.joinTime});

  factory MeetingParticipant.fromJson(Map<String, dynamic> json) {
    return MeetingParticipant(
      userID: json['userID'] as String? ?? '',
      joinTime: json['joinTime'] as int? ?? 0,
    );
  }
}
