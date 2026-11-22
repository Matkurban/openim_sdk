import 'dart:async';
import 'dart:convert';

import '../config/api_url.dart';
import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../enums/call_state.dart';
import '../enums/call_type.dart';
import '../listener/call_listener.dart';
import '../models/api_response.dart';
import '../models/call_session.dart';
import '../models/openim_exception.dart';

/// 音视频通话管理器（继承 [BaseManager]）。
///
/// 修复 B-11：移除 L1 后台 Isolate 后，`_currentSession` / `isBusy` / `callState`
/// 成为唯一真实数据源，全 6 端同步读取始终准确。
final class CallManager extends BaseManager<OnCallListener> {
  final SdkContext _context;

  CallSession? _currentSession;
  Timer? _inviteTimer;
  Timer? _incomingTimer;
  Future<void>? _pendingCleanup;

  void Function(String toUserID, String data, {bool isInvite})? _sendSignalingFn;

  CallManager({required this._context}) : super('CallManager');

  CallSession? get currentSession => _currentSession;

  bool get isBusy => _currentSession != null;

  CallState get callState => _currentSession?.state ?? CallState.idle;

  void setCallListener(OnCallListener listener) {
    setPrimaryListener(listener);
  }

  void setSendSignalingFn(void Function(String toUserID, String data, {bool isInvite}) fn) {
    _sendSignalingFn = fn;
  }

  Future<CallSession> invite({
    required List<String> inviteeUserIDs,
    required CallType callType,
    int timeout = 60,
  }) async {
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

    final CreateMeetingResult result = await _createMeeting(
      creatorUserID: currentUserID,
      callType: callType.value,
      inviteeUserIDs: inviteeUserIDs,
    );
    final CallSession session = CallSession(
      roomID: result.roomID,
      callType: callType,
      inviterUserID: currentUserID,
      inviteeUserIDs: inviteeUserIDs,
      liveURL: result.liveURL,
      token: result.token,
      state: CallState.calling,
    );
    _currentSession = session;

    final CallSignaling signaling = CallSignaling(
      action: SignalAction.invite,
      roomID: result.roomID,
      callType: callType,
      inviterUserID: currentUserID,
      inviteeUserIDs: inviteeUserIDs,
      liveURL: result.liveURL,
      timeout: timeout,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    for (final String userID in inviteeUserIDs) {
      _sendSignaling(signaling, userID);
    }
    _startInviteTimer(timeout);
    for (final String busyUserID in result.busyUsers) {
      listener?.onCallBusy?.call(session, busyUserID);
    }
    return session;
  }

  Future<CallSession> accept({required String roomID}) async {
    final CallSession? session = _currentSession;
    if (session == null || session.roomID != roomID) {
      throw StateError('没有对应的来电会话');
    }
    if (session.state != CallState.incoming) {
      throw StateError('当前状态不允许接受通话: ${session.state}');
    }
    _cancelIncomingTimer();

    final JoinMeetingResult result = await _joinMeeting(roomID: roomID, userID: currentUserID);
    session.token = result.token;
    session.state = CallState.connected;
    session.connectTime = DateTime.now().millisecondsSinceEpoch;

    final CallSignaling signaling = CallSignaling(
      action: SignalAction.accept,
      roomID: roomID,
      callType: session.callType,
      inviterUserID: session.inviterUserID,
      inviteeUserIDs: session.inviteeUserIDs,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _sendSignaling(signaling, session.inviterUserID);
    listener?.onCallConnected?.call(session);
    return session;
  }

  Future<void> reject({required String roomID}) async {
    final CallSession? session = _currentSession;
    if (session == null || session.roomID != roomID) {
      throw StateError('没有对应的来电会话');
    }
    _cancelIncomingTimer();
    final CallSignaling signaling = CallSignaling(
      action: SignalAction.reject,
      roomID: roomID,
      callType: session.callType,
      inviterUserID: session.inviterUserID,
      inviteeUserIDs: session.inviteeUserIDs,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _sendSignaling(signaling, session.inviterUserID);
    _cleanupSession();
  }

  Future<void> cancel() async {
    final CallSession? session = _currentSession;
    if (session == null) {
      return;
    }
    if (session.state != CallState.calling) {
      throw StateError('当前状态不允许取消: ${session.state}');
    }
    _cancelInviteTimer();
    final CallSignaling signaling = CallSignaling(
      action: SignalAction.cancel,
      roomID: session.roomID,
      callType: session.callType,
      inviterUserID: session.inviterUserID,
      inviteeUserIDs: session.inviteeUserIDs,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    for (final String userID in session.inviteeUserIDs) {
      _sendSignaling(signaling, userID);
    }
    await _endMeeting(roomID: session.roomID, userID: currentUserID);
    _cleanupSession();
  }

  Future<void> hangup() async {
    final CallSession? session = _currentSession;
    if (session == null) {
      return;
    }
    _cancelInviteTimer();
    _cancelIncomingTimer();

    final CallSignaling signaling = CallSignaling(
      action: SignalAction.hangup,
      roomID: session.roomID,
      callType: session.callType,
      inviterUserID: session.inviterUserID,
      inviteeUserIDs: session.inviteeUserIDs,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    final Set<String> notifyUserIDs = <String>{};
    if (session.inviterUserID == currentUserID) {
      notifyUserIDs.addAll(session.inviteeUserIDs);
    } else {
      notifyUserIDs.add(session.inviterUserID);
      if (session.isGroupCall) {
        notifyUserIDs.addAll(session.inviteeUserIDs);
        notifyUserIDs.remove(currentUserID);
      }
    }
    for (final String userID in notifyUserIDs) {
      _sendSignaling(signaling, userID);
    }

    if (session.state == CallState.connected && session.inviterUserID == currentUserID) {
      await _endMeeting(roomID: session.roomID, userID: currentUserID);
    } else {
      await _leaveMeeting(roomID: session.roomID, userID: currentUserID);
    }

    _cleanupSession();
    listener?.onCallEnded?.call(session);
  }

  bool handleSignalingMessage(String senderUserID, String data) {
    try {
      final Map<String, dynamic> map = jsonDecode(data) as Map<String, dynamic>;
      if (map['businessID'] != CallSignaling.businessID) {
        return false;
      }
      final Map<String, dynamic>? signalingData = map['data'] as Map<String, dynamic>?;
      if (signalingData == null) {
        return false;
      }
      final CallSignaling signaling = CallSignaling.fromJson(signalingData);
      switch (signaling.action) {
        case SignalAction.invite:
          _handleInvite(senderUserID, signaling);
        case SignalAction.accept:
          _handleAccept(senderUserID, signaling);
        case SignalAction.reject:
          _handleReject(senderUserID, signaling);
        case SignalAction.cancel:
          _handleCancel(signaling);
        case SignalAction.hangup:
          _handleHangup(senderUserID, signaling);
        case SignalAction.busy:
          _handleBusy(senderUserID, signaling);
        case SignalAction.timeout:
          _handleTimeout(signaling);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  void _handleInvite(String senderUserID, CallSignaling signaling) {
    final int elapsed = DateTime.now().millisecondsSinceEpoch - signaling.timestamp;
    if (elapsed > signaling.timeout * 1000) {
      return;
    }
    if (_currentSession != null) {
      _sendSignaling(
        signaling.copyWith(
          action: SignalAction.busy,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        senderUserID,
      );
      return;
    }
    final CallSession session = CallSession(
      roomID: signaling.roomID,
      callType: signaling.callType,
      inviterUserID: signaling.inviterUserID,
      inviteeUserIDs: signaling.inviteeUserIDs,
      liveURL: signaling.liveURL,
      state: CallState.incoming,
    );
    _currentSession = session;
    _startIncomingTimer(signaling.timeout);
    listener?.onIncomingCall?.call(session);
  }

  void _handleAccept(String senderUserID, CallSignaling signaling) {
    final CallSession? session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) {
      return;
    }
    session.acceptedUserIDs.add(senderUserID);
    if (session.state == CallState.calling) {
      session.state = CallState.connected;
      session.connectTime = DateTime.now().millisecondsSinceEpoch;
      _cancelInviteTimer();
    }
    listener?.onCallAccepted?.call(session, senderUserID);
    if (!session.isGroupCall) {
      listener?.onCallConnected?.call(session);
    }
  }

  void _handleReject(String senderUserID, CallSignaling signaling) {
    final CallSession? session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) {
      return;
    }
    session.rejectedUserIDs.add(senderUserID);
    listener?.onCallRejected?.call(session, senderUserID);
    final bool shouldEnd =
        !session.isGroupCall ||
        (session.rejectedUserIDs.length >= session.inviteeUserIDs.length &&
            session.acceptedUserIDs.isEmpty);
    if (shouldEnd) {
      _cancelInviteTimer();
      _pendingCleanup = _endMeeting(roomID: session.roomID, userID: currentUserID);
      _cleanupSession();
      listener?.onCallEnded?.call(session);
    }
  }

  void _handleCancel(CallSignaling signaling) {
    final CallSession? session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) {
      return;
    }
    _cancelIncomingTimer();
    _cleanupSession();
    listener?.onCallCancelled?.call(session);
  }

  void _handleHangup(String senderUserID, CallSignaling signaling) {
    final CallSession? session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) {
      return;
    }
    if (session.isGroupCall && senderUserID != session.inviterUserID) {
      return;
    }
    _cancelInviteTimer();
    _cancelIncomingTimer();
    _pendingCleanup = (!session.isGroupCall && session.inviterUserID == currentUserID)
        ? _endMeeting(roomID: session.roomID, userID: currentUserID)
        : _leaveMeeting(roomID: session.roomID, userID: currentUserID);
    _cleanupSession();
    listener?.onCallEnded?.call(session);
  }

  void _handleBusy(String senderUserID, CallSignaling signaling) {
    final CallSession? session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) {
      return;
    }
    listener?.onCallBusy?.call(session, senderUserID);
    if (!session.isGroupCall) {
      _cancelInviteTimer();
      _pendingCleanup = _endMeeting(roomID: session.roomID, userID: currentUserID);
      _cleanupSession();
    }
  }

  void _handleTimeout(CallSignaling signaling) {
    final CallSession? session = _currentSession;
    if (session == null || session.roomID != signaling.roomID) {
      return;
    }
    _cancelIncomingTimer();
    _cleanupSession();
    listener?.onCallTimeout?.call(session);
  }

  void _startInviteTimer(int timeoutSeconds) {
    _cancelInviteTimer();
    _inviteTimer = Timer(Duration(seconds: timeoutSeconds), () {
      final CallSession? session = _currentSession;
      if (session == null || session.state != CallState.calling) {
        return;
      }
      final CallSignaling signaling = CallSignaling(
        action: SignalAction.timeout,
        roomID: session.roomID,
        callType: session.callType,
        inviterUserID: session.inviterUserID,
        inviteeUserIDs: session.inviteeUserIDs,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      for (final String userID in session.inviteeUserIDs) {
        _sendSignaling(signaling, userID);
      }
      _pendingCleanup = _endMeeting(roomID: session.roomID, userID: currentUserID);
      _cleanupSession();
      listener?.onCallTimeout?.call(session);
    });
  }

  void _cancelInviteTimer() {
    _inviteTimer?.cancel();
    _inviteTimer = null;
  }

  void _startIncomingTimer(int timeoutSeconds) {
    _cancelIncomingTimer();
    _incomingTimer = Timer(Duration(seconds: timeoutSeconds), () {
      final CallSession? session = _currentSession;
      if (session == null || session.state != CallState.incoming) {
        return;
      }
      _cleanupSession();
      listener?.onCallTimeout?.call(session);
    });
  }

  void _cancelIncomingTimer() {
    _incomingTimer?.cancel();
    _incomingTimer = null;
  }

  void _cleanupSession() {
    _currentSession = null;
    _cancelInviteTimer();
    _cancelIncomingTimer();
  }

  void _sendSignaling(CallSignaling signaling, String toUserID) {
    final String payload = jsonEncode(<String, dynamic>{
      'businessID': CallSignaling.businessID,
      'data': signaling.toJson(),
    });
    _sendSignalingFn?.call(toUserID, payload, isInvite: signaling.action == SignalAction.invite);
  }

  Future<CreateMeetingResult> _createMeeting({
    required String creatorUserID,
    required String callType,
    required List<String> inviteeUserIDs,
  }) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      ChatApiUrl.createMeeting,
      data: <String, dynamic>{
        'creatorUserID': creatorUserID,
        'callType': callType,
        'inviteeUserIDs': inviteeUserIDs,
      },
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    return CreateMeetingResult.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<JoinMeetingResult> _joinMeeting({required String roomID, required String userID}) async {
    final ApiResponse resp = await _context.httpClient.chatPost(
      ChatApiUrl.joinMeeting,
      data: <String, dynamic>{'roomID': roomID, 'userID': userID},
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    return JoinMeetingResult.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> _leaveMeeting({required String roomID, required String userID}) async {
    try {
      await _context.httpClient.chatPost(
        ChatApiUrl.leaveMeeting,
        data: <String, dynamic>{'roomID': roomID, 'userID': userID},
      );
    } on Object catch (error, stackTrace) {
      logger.warning('leaveMeeting failed', error, stackTrace);
    }
  }

  Future<void> _endMeeting({required String roomID, required String userID}) async {
    try {
      await _context.httpClient.chatPost(
        ChatApiUrl.endMeeting,
        data: <String, dynamic>{'roomID': roomID, 'userID': userID},
      );
    } on Object catch (error, stackTrace) {
      logger.warning('endMeeting failed', error, stackTrace);
    }
  }

  @override
  void onLogout() {
    _cleanupSession();
    _pendingCleanup = null;
    super.onLogout();
  }

  @override
  void dispose() {
    _cleanupSession();
    _pendingCleanup = null;
    _sendSignalingFn = null;
    super.dispose();
  }
}
