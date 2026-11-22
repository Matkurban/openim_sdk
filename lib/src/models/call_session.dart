import 'dart:convert';

import 'package:openim_sdk/src/enums/call_type.dart';
import 'package:openim_sdk/src/enums/call_state.dart';

/// 信令动作
///
/// Signaling action.
class SignalAction {
  /// 邀请。
  ///
  /// Invite.
  static const String invite = 'invite';

  /// 接受。
  ///
  /// Accept.
  static const String accept = 'accept';

  /// 拒绝。
  ///
  /// Reject.
  static const String reject = 'reject';

  /// 取消。
  ///
  /// Cancel.
  static const String cancel = 'cancel';

  /// hangup。
  ///
  /// Hangup.
  static const String hangup = 'hangup';

  /// 忙线。
  ///
  /// Busy.
  static const String busy = 'busy';

  /// 超时时间。
  ///
  /// Timeout.
  static const String timeout = 'timeout';
}

/// 通话信令消息
///
/// Call signaling.
class CallSignaling {
  /// 信令动作
  ///
  /// Action.
  final String action;

  /// 房间ID
  ///
  /// Room ID.
  final String roomID;

  /// 通话类型
  ///
  /// Call type.
  final CallType callType;

  /// 发起者用户ID
  ///
  /// Inviter user ID.
  final String inviterUserID;

  /// 被邀请者用户ID列表
  ///
  /// Invitee user i ds.
  final List<String> inviteeUserIDs;

  /// LiveKit 服务器地址
  final String? liveURL;

  /// 超时时间（秒）
  ///
  /// Timeout.
  final int timeout;

  /// 时间戳
  ///
  /// Timestamp.
  final int timestamp;

  /// 附加数据（如拒绝原因等）
  ///
  /// Extra data.
  final String? extra;

  /// 创建 `CallSignaling` 实例。
  ///
  /// Creates a `CallSignaling` instance.
  ///
  /// - [action] action / Action.
  /// - [roomID] 房间ID / Room ID.
  /// - [callType] 通话类型 / Call type.
  /// - [inviterUserID] 邀请者用户ID / Inviter user ID.
  /// - [inviteeUserIDs] 被邀请者用户ID 列表 / Invitee user i ds.
  /// - [liveURL] 实时URL 地址 / Live URL.
  /// - [timeout] 超时时间 / Timeout.
  /// - [timestamp] 时间戳 / Timestamp.
  /// - [extra] 扩展信息 / Extra data.
  const CallSignaling({
    required this.action,
    required this.roomID,
    required this.callType,
    required this.inviterUserID,
    this.inviteeUserIDs = const <String>[],
    this.liveURL,
    this.timeout = 60,
    int? timestamp,
    this.extra,
  }) : timestamp = timestamp ?? 0;

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [action] action / Action.
  /// - [roomID] 房间ID / Room ID.
  /// - [callType] 通话类型 / Call type.
  /// - [inviterUserID] 邀请者用户ID / Inviter user ID.
  /// - [inviteeUserIDs] 被邀请者用户ID 列表 / Invitee user i ds.
  /// - [liveURL] 实时URL 地址 / Live URL.
  /// - [timeout] 超时时间 / Timeout.
  /// - [timestamp] 时间戳 / Timestamp.
  /// - [extra] 扩展信息 / Extra data.
  /// - Returns: `CallSignaling` 结果 / Resulting `CallSignaling`.
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

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => <String, dynamic>{
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

  /// 从 JSON 字典反序列化实例（`CallSignaling.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CallSignaling.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CallSignaling` 结果 / Resulting `CallSignaling`.
  factory CallSignaling.fromJson(Map<String, dynamic> json) {
    return CallSignaling(
      action: json['action'] as String? ?? '',
      roomID: json['roomID'] as String? ?? '',
      callType: CallType.fromValue(json['callType'] as String? ?? 'audio'),
      inviterUserID: json['inviterUserID'] as String? ?? '',
      inviteeUserIDs:
          (json['inviteeUserIDs'] as List<dynamic>?)
              ?.map<String>((dynamic e) => e.toString())
              .toList() ??
          <String>[],
      liveURL: json['liveURL'] as String?,
      timeout: json['timeout'] as int? ?? 60,
      timestamp: json['timestamp'] as int? ?? 0,
      extra: json['extra'] as String?,
    );
  }

  /// 编码为传输格式。
  ///
  /// Encodes into transport format.
  ///
  /// - Returns: 字符串结果 / String result.
  String encode() => jsonEncode(toJson());

  /// 从传输格式解码。
  ///
  /// Decodes from transport format.
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CallSignaling?` 结果 / Resulting `CallSignaling?`.
  static CallSignaling? decode(String json) {
    try {
      final Map<String, dynamic> map = jsonDecode(json) as Map<String, dynamic>;
      return CallSignaling.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// 信令 custom message 的 businessID 标识
  static const String businessID = 'rtc_signaling';
}

/// 通话会话，代表一次正在进行的通话
///
/// Call session.
class CallSession {
  /// 房间ID
  ///
  /// Room ID.
  final String roomID;

  /// 通话类型
  ///
  /// Call type.
  final CallType callType;

  /// 发起者用户ID
  ///
  /// Inviter user ID.
  final String inviterUserID;

  /// 被邀请者用户ID列表
  ///
  /// Invitee user i ds.
  final List<String> inviteeUserIDs;

  /// LiveKit 服务器地址
  final String? liveURL;

  /// 令牌。
  ///
  /// LiveKit Token
  String? token;

  /// 当前通话状态
  ///
  /// State.
  CallState state;

  /// 创建时间
  ///
  /// Create timestamp.
  final int createTime;

  /// 接通时间
  ///
  /// Connect timestamp.
  int? connectTime;

  /// 是否为群组通话（多人）
  ///
  /// Whether group call.
  bool get isGroupCall => inviteeUserIDs.length > 1;

  /// 已接受的用户列表（多人通话用）
  ///
  /// Accepted user i ds.
  final Set<String> acceptedUserIDs = <String>{};

  /// 已拒绝的用户列表（多人通话用）
  ///
  /// Rejected user i ds.
  final Set<String> rejectedUserIDs = <String>{};

  /// 创建 `CallSession` 实例。
  ///
  /// Creates a `CallSession` instance.
  ///
  /// - [roomID] 房间ID / Room ID.
  /// - [callType] 通话类型 / Call type.
  /// - [inviterUserID] 邀请者用户ID / Inviter user ID.
  /// - [inviteeUserIDs] 被邀请者用户ID 列表 / Invitee user i ds.
  /// - [liveURL] 实时URL 地址 / Live URL.
  /// - [token] 令牌 / Token.
  /// - [state] 状态 / State.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [connectTime] 连接时间戳 / Connect timestamp.
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

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => <String, dynamic>{
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

  /// 从 JSON 字典反序列化实例（`CallSession.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CallSession.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CallSession` 结果 / Resulting `CallSession`.
  factory CallSession.fromJson(Map<String, dynamic> json) {
    final CallSession session = CallSession(
      roomID: json['roomID'] as String? ?? '',
      callType: CallType.fromValue(json['callType'] as String? ?? 'audio'),
      inviterUserID: json['inviterUserID'] as String? ?? '',
      inviteeUserIDs:
          (json['inviteeUserIDs'] as List<dynamic>?)
              ?.map<String>((dynamic e) => e.toString())
              .toList() ??
          <String>[],
      liveURL: json['liveURL'] as String?,
      token: json['token'] as String?,
      state: CallState.values.firstWhere(
        (CallState e) => e.name == (json['state'] as String?),
        orElse: () => CallState.idle,
      ),
      createTime: json['createTime'] as int?,
      connectTime: json['connectTime'] as int?,
    );
    final List<dynamic>? accepted = json['acceptedUserIDs'] as List<dynamic>?;
    if (accepted != null) session.acceptedUserIDs.addAll(accepted.cast<String>());
    final List<dynamic>? rejected = json['rejectedUserIDs'] as List<dynamic>?;
    if (rejected != null) session.rejectedUserIDs.addAll(rejected.cast<String>());
    return session;
  }
}

/// 后端创建会议的响应
///
/// Create meeting result.
class CreateMeetingResult {
  /// 房间ID。
  ///
  /// Room ID.
  final String roomID;

  /// 令牌。
  ///
  /// Token.
  final String token;

  /// 实时URL 地址。
  ///
  /// Live URL.
  final String liveURL;

  /// 忙线用户列表。
  ///
  /// Busy users.
  final List<String> busyUsers;

  /// 创建 `CreateMeetingResult` 实例。
  ///
  /// Creates a `CreateMeetingResult` instance.
  ///
  /// - [roomID] 房间ID / Room ID.
  /// - [token] 令牌 / Token.
  /// - [liveURL] 实时URL 地址 / Live URL.
  /// - [busyUsers] 忙线用户列表 / Busy users.
  const CreateMeetingResult({
    required this.roomID,
    required this.token,
    required this.liveURL,
    this.busyUsers = const <String>[],
  });

  /// 从 JSON 字典反序列化实例（`CreateMeetingResult.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CreateMeetingResult.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CreateMeetingResult` 结果 / Resulting `CreateMeetingResult`.
  factory CreateMeetingResult.fromJson(Map<String, dynamic> json) {
    return CreateMeetingResult(
      roomID: json['roomID'] as String? ?? '',
      token: json['token'] as String? ?? '',
      liveURL: json['liveURL'] as String? ?? '',
      busyUsers:
          (json['busyUsers'] as List<dynamic>?)
              ?.map<String>((dynamic e) => e.toString())
              .toList() ??
          <String>[],
    );
  }
}

/// 后端加入会议的响应
///
/// Join meeting result.
class JoinMeetingResult {
  /// 令牌。
  ///
  /// Token.
  final String token;

  /// 实时URL 地址。
  ///
  /// Live URL.
  final String liveURL;

  /// 房间ID。
  ///
  /// Room ID.
  final String roomID;

  /// 通话类型。
  ///
  /// Call type.
  final String callType;

  /// 参与者列表。
  ///
  /// Participants.
  final List<MeetingParticipant> participants;

  /// 创建 `JoinMeetingResult` 实例。
  ///
  /// Creates a `JoinMeetingResult` instance.
  ///
  /// - [token] 令牌 / Token.
  /// - [liveURL] 实时URL 地址 / Live URL.
  /// - [roomID] 房间ID / Room ID.
  /// - [callType] 通话类型 / Call type.
  /// - [participants] 参与者列表 / Participants.
  const JoinMeetingResult({
    required this.token,
    required this.liveURL,
    required this.roomID,
    required this.callType,
    this.participants = const <MeetingParticipant>[],
  });

  /// 从 JSON 字典反序列化实例（`JoinMeetingResult.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`JoinMeetingResult.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `JoinMeetingResult` 结果 / Resulting `JoinMeetingResult`.
  factory JoinMeetingResult.fromJson(Map<String, dynamic> json) {
    return JoinMeetingResult(
      token: json['token'] as String? ?? '',
      liveURL: json['liveURL'] as String? ?? '',
      roomID: json['roomID'] as String? ?? '',
      callType: json['callType'] as String? ?? '',
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map<MeetingParticipant>(
                (dynamic e) => MeetingParticipant.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <MeetingParticipant>[],
    );
  }
}

/// 会议参与者信息
///
/// Meeting participant.
class MeetingParticipant {
  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 加入时间戳。
  ///
  /// Join timestamp.
  final int joinTime;

  /// 创建 `MeetingParticipant` 实例。
  ///
  /// Creates a `MeetingParticipant` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [joinTime] 加入时间戳 / Join timestamp.
  const MeetingParticipant({required this.userID, required this.joinTime});

  /// 从 JSON 字典反序列化实例（`MeetingParticipant.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MeetingParticipant.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MeetingParticipant` 结果 / Resulting `MeetingParticipant`.
  factory MeetingParticipant.fromJson(Map<String, dynamic> json) {
    return MeetingParticipant(
      userID: json['userID'] as String? ?? '',
      joinTime: json['joinTime'] as int? ?? 0,
    );
  }
}
