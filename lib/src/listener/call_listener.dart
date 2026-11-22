import 'package:openim_sdk/src/models/call_session.dart';

/// 音视频通话事件监听器。
///
/// Audio/video call event listener.
class OnCallListener {
  /// 收到来电邀请回调 / Callback invoked on receiving an incoming call invitation.
  void Function(CallSession session)? onIncomingCall;

  /// 对方接受通话回调（单聊直接进入通话，多人场景表示某成员接听）。
  ///
  /// Callback invoked when a callee accepts the call.
  void Function(CallSession session, String userID)? onCallAccepted;

  /// 对方拒绝通话回调 / Callback invoked when a callee rejects the call.
  void Function(CallSession session, String userID)? onCallRejected;

  /// 呼叫被发起者取消回调 / Callback invoked when the caller cancels the call.
  void Function(CallSession session)? onCallCancelled;

  /// 通话结束回调 / Callback invoked when the call ends.
  void Function(CallSession session)? onCallEnded;

  /// 呼叫超时无响应回调 / Callback invoked when the call invitation times out.
  void Function(CallSession session)? onCallTimeout;

  /// 对方忙线回调 / Callback invoked when the target user is busy.
  void Function(CallSession session, String busyUserID)? onCallBusy;

  /// 通话已接通回调（LiveKit 连接成功） / Callback invoked when the call connects.
  void Function(CallSession session)? onCallConnected;

  /// 创建音视频通话监听器。
  ///
  /// Creates an [OnCallListener] with optional call lifecycle callbacks.
  ///
  /// - [onIncomingCall] 来电邀请回调 / Incoming call callback.
  /// - [onCallAccepted] 接听回调 / Call accepted callback.
  /// - [onCallRejected] 拒绝回调 / Call rejected callback.
  /// - [onCallCancelled] 取消回调 / Call cancelled callback.
  /// - [onCallEnded] 结束回调 / Call ended callback.
  /// - [onCallTimeout] 超时回调 / Call timeout callback.
  /// - [onCallBusy] 忙线回调 / Peer busy callback.
  /// - [onCallConnected] 接通回调 / Call connected callback.
  OnCallListener({
    this.onIncomingCall,
    this.onCallAccepted,
    this.onCallRejected,
    this.onCallCancelled,
    this.onCallEnded,
    this.onCallTimeout,
    this.onCallBusy,
    this.onCallConnected,
  });
}
