import 'dart:async';
import 'dart:convert';

import 'package:openim_sdk/src/config/api_url.dart';
import 'package:openim_sdk/src/enums/call_state.dart';
import 'package:openim_sdk/src/enums/call_type.dart';
import 'package:openim_sdk/src/listener/call_listener.dart';
import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:openim_sdk/src/models/call_session.dart';
import 'package:openim_sdk/src/network/http_client.dart';

/// 音视频通话管理器
///
/// 负责管理通话的完整生命周期：
/// - 发起/接受/拒绝/取消/挂断通话
/// - 通过 OpenIM 自定义消息发送信令
/// - 通过 openim-chat 后端管理 LiveKit 房间
///
/// 使用方式：
/// ```dart
/// final callManager = OpenIM.iMManager.callManager;
/// callManager.setCallListener(OnCallListener(
///   onIncomingCall: (session) { /* 显示来电界面 */ },
///   onCallAccepted: (session, userID) { /* 连接 LiveKit */ },
///   onCallEnded: (session) { /* 清理 */ },
/// ));
///
/// // 发起通话
/// final session = await callManager.invite(
///   inviteeUserIDs: ['user2'],
///   callType: CallType.video,
/// );
///
/// // 接受通话
/// await callManager.accept(roomID: session.roomID);
///
/// // 挂断
/// await callManager.hangup();
/// ```
class CallManager {
  CallManager._internal();

  static final CallManager _instance = CallManager._internal();

  factory CallManager() => _instance;

  static final AoiweLogger _log = AoiweLogger('CallManager');

  /// 通话事件回调
  OnCallListener? _callListener;

  /// 当前通话会话
  CallSession? _currentSession;

  /// 呼叫超时定时器
  Timer? _inviteTimer;

  /// 被呼叫超时定时器（收到来电后的超时）
  Timer? _incomingTimer;

  /// 正在进行中的后端清理 Future，invite() 会先等待它完成，
  /// 防止上次通话的 _endMeeting/_leaveMeeting 尚未执行完毕
  /// 导致 CreateMeeting 返回 "user already in room" 错误。
  Future<void>? _pendingCleanup;

  late String _currentUserID;

  /// 获取当前通话会话（只读）
  CallSession? get currentSession => _currentSession;

  /// 是否正在通话中
  bool get isBusy => _currentSession != null;

  /// 当前通话状态
  CallState get callState => _currentSession?.state ?? CallState.idle;

  /// 设置通话事件回调
  void setCallListener(OnCallListener listener) {
    _callListener = listener;
  }

  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  // ---------------------------------------------------------------------------
  // 通话操作
  // ---------------------------------------------------------------------------

  /// 发起通话
  ///
  /// [inviteeUserIDs] 被邀请者用户ID列表，1对1通话传1个，多人通话最多8个
  /// [callType] 通话类型（音频/视频）
  /// [timeout] 超时时间（秒），默认60秒
  ///
  /// 返回 [CallSession]，包含 roomID、token、liveURL 等信息
  /// 调用方拿到 session 后应使用 livekit_client 连接到 LiveKit 房间
  Future<CallSession> invite({
    required List<String> inviteeUserIDs,
    required CallType callType,
    int timeout = 60,
  }) async {
    _log.info(
      'inviteeUserIDs=$inviteeUserIDs, callType=${callType.value}, timeout=$timeout',
      methodName: 'invite',
    );

    // 等待上一次通话的后端清理完成
    if (_pendingCleanup != null) {
      await _pendingCleanup;
      _pendingCleanup = null;
    }

    if (_currentSession != null) {
      throw StateError('已在通话中，请先结束当前通话');
    }
    if (inviteeUserIDs.isEmpty) {
      throw ArgumentError('inviteeUserIDs 不能为空');
    }
    if (inviteeUserIDs.length > 8) {
      throw ArgumentError('最多邀请 8 人（总共 9 人）');
    }

    // 1. 调用后端创建会议房间
    final result = await _createMeeting(
      creatorUserID: _currentUserID,
      callType: callType.value,
      inviteeUserIDs: inviteeUserIDs,
    );

    // 2. 创建通话会话
    final session = CallSession(
      roomID: result.roomID,
      callType: callType,
      inviterUserID: _currentUserID,
      inviteeUserIDs: inviteeUserIDs,
      liveURL: result.liveURL,
      token: result.token,
      state: CallState.calling,
    );
    _currentSession = session;

    // 3. 发送邀请信令给所有被邀请者
    final signaling = CallSignaling(
      action: SignalAction.invite,
      roomID: result.roomID,
      callType: callType,
      inviterUserID: _currentUserID,
      inviteeUserIDs: inviteeUserIDs,
      liveURL: result.liveURL,
      timeout: timeout,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    for (final userID in inviteeUserIDs) {
      _sendSignaling(signaling, userID);
    }

    // 4. 设置超时定时器
    _startInviteTimer(timeout);

    // 5. 通知忙线用户
    for (final busyUserID in result.busyUsers) {
      _callListener?.onCallBusy?.call(session, busyUserID);
    }

    _log.info('通话邀请已发送, roomID=${result.roomID}', methodName: 'invite');
    return session;
  }

  /// 接受通话
  ///
  /// [roomID] 要接受的通话房间ID（来自 onIncomingCall 回调的 session.roomID）
  ///
  /// 返回 [CallSession]，包含 token 和 liveURL，调用方应连接到 LiveKit
  Future<CallSession> accept({required String roomID}) async {
    _log.info('roomID=$roomID', methodName: 'accept');

    final session = _currentSession;
    if (session == null || session.roomID != roomID) {
      throw StateError('没有对应的来电会话');
    }
    if (session.state != CallState.incoming) {
      throw StateError('当前状态不允许接受通话: ${session.state}');
    }

    _cancelIncomingTimer();

    // 1. 调用后端加入会议
    final result = await _joinMeeting(roomID: roomID, userID: _currentUserID);

    // 2. 更新会话状态
    session.token = result.token;
    session.state = CallState.connected;
    session.connectTime = DateTime.now().millisecondsSinceEpoch;

    // 3. 发送接受信令给发起者
    final signaling = CallSignaling(
      action: SignalAction.accept,
      roomID: roomID,
      callType: session.callType,
      inviterUserID: session.inviterUserID,
      inviteeUserIDs: session.inviteeUserIDs,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _sendSignaling(signaling, session.inviterUserID);

    _callListener?.onCallConnected?.call(session);

    _log.info('通话已接受, roomID=$roomID', methodName: 'accept');
    return session;
  }

  /// 拒绝通话
  ///
  /// [roomID] 要拒绝的通话房间ID
  Future<void> reject({required String roomID}) async {
    _log.info('roomID=$roomID', methodName: 'reject');

    final session = _currentSession;
    if (session == null || session.roomID != roomID) {
      throw StateError('没有对应的来电会话');
    }

    _cancelIncomingTimer();

    // 发送拒绝信令
    final signaling = CallSignaling(
      action: SignalAction.reject,
      roomID: roomID,
      callType: session.callType,
      inviterUserID: session.inviterUserID,
      inviteeUserIDs: session.inviteeUserIDs,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _sendSignaling(signaling, session.inviterUserID);

    _cleanupSession();
    _log.info('通话已拒绝, roomID=$roomID', methodName: 'reject');
  }

  /// 取消通话（发起者在对方接听前取消）
  Future<void> cancel() async {
    _log.info('', methodName: 'cancel');

    final session = _currentSession;
    if (session == null) {
      return;
    }
    if (session.state != CallState.calling) {
      throw StateError('当前状态不允许取消: ${session.state}');
    }

    _cancelInviteTimer();

    // 发送取消信令给所有被邀请者
    final signaling = CallSignaling(
      action: SignalAction.cancel,
      roomID: session.roomID,
      callType: session.callType,
      inviterUserID: session.inviterUserID,
      inviteeUserIDs: session.inviteeUserIDs,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    for (final userID in session.inviteeUserIDs) {
      _sendSignaling(signaling, userID);
    }

    // 通知后端结束会议
    await _endMeeting(roomID: session.roomID, userID: _currentUserID);

    _cleanupSession();
    _log.info('通话已取消', methodName: 'cancel');
  }

  /// 挂断通话
  Future<void> hangup() async {
    _log.info('', methodName: 'hangup');

    final session = _currentSession;
    if (session == null) {
      return;
    }

    _cancelInviteTimer();
    _cancelIncomingTimer();

    // 通知所有相关用户
    final signaling = CallSignaling(
      action: SignalAction.hangup,
      roomID: session.roomID,
      callType: session.callType,
      inviterUserID: session.inviterUserID,
      inviteeUserIDs: session.inviteeUserIDs,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    // 确定通知谁
    final notifyUserIDs = <String>{};
    if (session.inviterUserID == _currentUserID) {
      // 我是发起者，通知所有被邀请者
      notifyUserIDs.addAll(session.inviteeUserIDs);
    } else {
      // 我是被邀请者，通知发起者
      notifyUserIDs.add(session.inviterUserID);
      // 多人通话时也通知其他人
      if (session.isGroupCall) {
        notifyUserIDs.addAll(session.inviteeUserIDs);
        notifyUserIDs.remove(_currentUserID);
      }
    }

    for (final userID in notifyUserIDs) {
      _sendSignaling(signaling, userID);
    }

    // 通知后端
    if (session.state == CallState.connected) {
      if (session.inviterUserID == _currentUserID) {
        await _endMeeting(roomID: session.roomID, userID: _currentUserID);
      } else {
        await _leaveMeeting(roomID: session.roomID, userID: _currentUserID);
      }
    } else {
      await _leaveMeeting(roomID: session.roomID, userID: _currentUserID);
    }

    final endedSession = session;
    _cleanupSession();
    _callListener?.onCallEnded?.call(endedSession);
    _log.info('通话已挂断', methodName: 'hangup');
  }

  // ---------------------------------------------------------------------------
  // 信令接收处理
  // ---------------------------------------------------------------------------

  /// 处理收到的信令消息
  /// 由 MessageManager 在收到自定义消息时调用
  ///
  /// [senderUserID] 发送者用户ID
  /// [data] 信令数据（JSON字符串）
  ///
  /// 返回 true 表示是信令消息已被处理，false 表示不是信令消息
  bool handleSignalingMessage(String senderUserID, String data) {
    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      if (map['businessID'] != CallSignaling.businessID) {
        return false;
      }
      final signalingData = map['data'] as Map<String, dynamic>?;
      if (signalingData == null) return false;

      final signaling = CallSignaling.fromJson(signalingData);
      _log.info(
        'action=${signaling.action}, roomID=${signaling.roomID}, from=$senderUserID',
        methodName: 'handleSignalingMessage',
      );

      switch (signaling.action) {
        case SignalAction.invite:
          _handleInvite(senderUserID, signaling);
        case SignalAction.accept:
          _handleAccept(senderUserID, signaling);
        case SignalAction.reject:
          _handleReject(senderUserID, signaling);
        case SignalAction.cancel:
          _handleCancel(senderUserID, signaling);
        case SignalAction.hangup:
          _handleHangup(senderUserID, signaling);
        case SignalAction.busy:
          _handleBusy(senderUserID, signaling);
        case SignalAction.timeout:
          _handleTimeout(senderUserID, signaling);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void _handleInvite(String senderUserID, CallSignaling signaling) {
    // 检查邀请是否已过期（离线用户上线后收到的持久化消息可能已超时）
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsed = now - signaling.timestamp;
    if (elapsed > signaling.timeout * 1000) {
      _log.info(
        '邀请已过期 (elapsed=${elapsed}ms, timeout=${signaling.timeout}s), 忽略',
        methodName: '_handleInvite',
      );
      return;
    }

    // 如果已经在通话中，回复忙线
    if (_currentSession != null) {
      final busySignaling = signaling.copyWith(
        action: SignalAction.busy,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      _sendSignaling(busySignaling, senderUserID);
      return;
    }

    // 创建来电会话
    final session = CallSession(
      roomID: signaling.roomID,
      callType: signaling.callType,
      inviterUserID: signaling.inviterUserID,
      inviteeUserIDs: signaling.inviteeUserIDs,
      liveURL: signaling.liveURL,
      state: CallState.incoming,
    );
    _currentSession = session;

    // 设置来电超时
    _startIncomingTimer(signaling.timeout);

    _callListener?.onIncomingCall?.call(session);
  }

  void _handleAccept(String senderUserID, CallSignaling signaling) {
    final session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) return;

    session.acceptedUserIDs.add(senderUserID);

    if (session.state == CallState.calling) {
      // 第一个人接收 → 切换到连接状态
      session.state = CallState.connected;
      session.connectTime = DateTime.now().millisecondsSinceEpoch;
      _cancelInviteTimer();
    }

    _callListener?.onCallAccepted?.call(session, senderUserID);

    // 对于1对1通话，接受后即通话开始
    if (!session.isGroupCall) {
      _callListener?.onCallConnected?.call(session);
    }
  }

  void _handleReject(String senderUserID, CallSignaling signaling) {
    final session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) return;

    session.rejectedUserIDs.add(senderUserID);
    _callListener?.onCallRejected?.call(session, senderUserID);

    // 对于1对1通话，拒绝就结束
    if (!session.isGroupCall) {
      _cancelInviteTimer();
      _pendingCleanup = _endMeeting(roomID: session.roomID, userID: _currentUserID);
      _cleanupSession();
      _callListener?.onCallEnded?.call(session);
    } else {
      // 多人通话：所有人都拒绝了才结束
      if (session.rejectedUserIDs.length >= session.inviteeUserIDs.length &&
          session.acceptedUserIDs.isEmpty) {
        _cancelInviteTimer();
        _pendingCleanup = _endMeeting(roomID: session.roomID, userID: _currentUserID);
        _cleanupSession();
        _callListener?.onCallEnded?.call(session);
      }
    }
  }

  void _handleCancel(String senderUserID, CallSignaling signaling) {
    final session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) return;

    _cancelIncomingTimer();
    // 被叫收到取消信令；如果被叫此前已加入会议（不应该但防御性处理），也清理
    final cancelledSession = session;
    _cleanupSession();
    _callListener?.onCallCancelled?.call(cancelledSession);
  }

  void _handleHangup(String senderUserID, CallSignaling signaling) {
    final session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) return;

    if (session.isGroupCall) {
      // 多人通话中，某人挂断不影响整个通话
      // 除非是发起者挂断（结束整个通话）
      if (senderUserID == session.inviterUserID) {
        _cancelInviteTimer();
        _cancelIncomingTimer();
        _pendingCleanup = _leaveMeeting(roomID: session.roomID, userID: _currentUserID);
        _cleanupSession();
        _callListener?.onCallEnded?.call(session);
      }
      // 其他人挂断只是离开，不结束通话
    } else {
      // 1对1通话，任何一方挂断都结束
      _cancelInviteTimer();
      _cancelIncomingTimer();
      if (session.inviterUserID == _currentUserID) {
        _pendingCleanup = _endMeeting(roomID: session.roomID, userID: _currentUserID);
      } else {
        _pendingCleanup = _leaveMeeting(roomID: session.roomID, userID: _currentUserID);
      }
      _cleanupSession();
      _callListener?.onCallEnded?.call(session);
    }
  }

  void _handleBusy(String senderUserID, CallSignaling signaling) {
    final session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) return;

    _callListener?.onCallBusy?.call(session, senderUserID);

    // 1对1通话中，对方忙线则结束
    if (!session.isGroupCall) {
      _cancelInviteTimer();
      _pendingCleanup = _endMeeting(roomID: session.roomID, userID: _currentUserID);
      _cleanupSession();
    }
  }

  void _handleTimeout(String senderUserID, CallSignaling signaling) {
    final session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) return;

    _cancelIncomingTimer();
    _cleanupSession();
    _callListener?.onCallTimeout?.call(session);
  }

  // ---------------------------------------------------------------------------
  // 定时器管理
  // ---------------------------------------------------------------------------

  void _startInviteTimer(int timeoutSeconds) {
    _cancelInviteTimer();
    _inviteTimer = Timer(Duration(seconds: timeoutSeconds), () {
      final session = _currentSession;
      if (session == null || session.state != CallState.calling) return;

      _log.info('邀请超时', methodName: '_inviteTimeout');

      // 发送超时信令给所有被邀请者
      final signaling = CallSignaling(
        action: SignalAction.timeout,
        roomID: session.roomID,
        callType: session.callType,
        inviterUserID: session.inviterUserID,
        inviteeUserIDs: session.inviteeUserIDs,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      for (final userID in session.inviteeUserIDs) {
        _sendSignaling(signaling, userID);
      }

      // 通知后端结束
      _pendingCleanup = _endMeeting(roomID: session.roomID, userID: _currentUserID);

      _cleanupSession();
      _callListener?.onCallTimeout?.call(session);
    });
  }

  void _cancelInviteTimer() {
    _inviteTimer?.cancel();
    _inviteTimer = null;
  }

  void _startIncomingTimer(int timeoutSeconds) {
    _cancelIncomingTimer();
    _incomingTimer = Timer(Duration(seconds: timeoutSeconds), () {
      final session = _currentSession;
      if (session == null || session.state != CallState.incoming) return;

      _log.info('来电超时', methodName: '_incomingTimeout');
      _cleanupSession();
      _callListener?.onCallTimeout?.call(session);
    });
  }

  void _cancelIncomingTimer() {
    _incomingTimer?.cancel();
    _incomingTimer = null;
  }

  // ---------------------------------------------------------------------------
  // 内部方法
  // ---------------------------------------------------------------------------

  void _cleanupSession() {
    _currentSession = null;
    _cancelInviteTimer();
    _cancelIncomingTimer();
  }

  /// 发送信令消息（通过 OpenIM 自定义在线消息）
  void _sendSignaling(CallSignaling signaling, String toUserID) {
    final payload = jsonEncode({
      'businessID': CallSignaling.businessID,
      'data': signaling.toJson(),
    });

    // 使用 MessageManager 发送自定义在线消息
    // 由 IMManager 注入的发送方法
    _sendSignalingFn?.call(toUserID, payload, isInvite: signaling.action == SignalAction.invite);
  }

  /// 发送信令消息的回调，由 IMManager 注入
  void Function(String toUserID, String data, {bool isInvite})? _sendSignalingFn;

  /// 设置信令发送回调（内部使用）
  void setSendSignalingFn(void Function(String toUserID, String data, {bool isInvite}) fn) {
    _sendSignalingFn = fn;
  }

  // ---------------------------------------------------------------------------
  // 后端 API 调用
  // ---------------------------------------------------------------------------

  Future<CreateMeetingResult> _createMeeting({
    required String creatorUserID,
    required String callType,
    required List<String> inviteeUserIDs,
  }) async {
    final resp = await HttpClient().chatPost(
      ChatApiUrl.createMeeting,
      data: {
        'creatorUserID': creatorUserID,
        'callType': callType,
        'inviteeUserIDs': inviteeUserIDs,
      },
    );
    if (resp.errCode != 0) {
      throw Exception('创建会议失败: ${resp.errMsg}${resp.errDlt.isNotEmpty ? ' (${resp.errDlt})' : ''}');
    }
    return CreateMeetingResult.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<JoinMeetingResult> _joinMeeting({required String roomID, required String userID}) async {
    final resp = await HttpClient().chatPost(
      ChatApiUrl.joinMeeting,
      data: {'roomID': roomID, 'userID': userID},
    );
    if (resp.errCode != 0) {
      throw Exception('加入会议失败: ${resp.errMsg}');
    }
    return JoinMeetingResult.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> _leaveMeeting({required String roomID, required String userID}) async {
    try {
      await HttpClient().chatPost(
        ChatApiUrl.leaveMeeting,
        data: {'roomID': roomID, 'userID': userID},
      );
    } catch (e) {
      _log.warning('离开会议失败: $e', methodName: '_leaveMeeting');
    }
  }

  Future<void> _endMeeting({required String roomID, required String userID}) async {
    try {
      await HttpClient().chatPost(
        ChatApiUrl.endMeeting,
        data: {'roomID': roomID, 'userID': userID},
      );
    } catch (e) {
      _log.warning('结束会议失败: $e', methodName: '_endMeeting');
    }
  }

  /// 释放资源
  void dispose() {
    _cancelInviteTimer();
    _cancelIncomingTimer();
    _pendingCleanup = null;
    _currentSession = null;
    _callListener = null;
    _sendSignalingFn = null;
  }
}
