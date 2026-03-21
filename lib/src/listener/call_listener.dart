import 'package:openim_sdk/src/models/call_session.dart';

/// 音视频通话事件回调
class OnCallListener {
  /// 收到来电邀请
  void Function(CallSession session)? onIncomingCall;

  /// 对方接受通话（1对1场景下直接进入通话；多人场景下有人接受）
  void Function(CallSession session, String userID)? onCallAccepted;

  /// 对方拒绝通话
  void Function(CallSession session, String userID)? onCallRejected;

  /// 呼叫被取消（发起者取消）
  void Function(CallSession session)? onCallCancelled;

  /// 通话结束
  void Function(CallSession session)? onCallEnded;

  /// 呼叫超时（对方未接听）
  void Function(CallSession session)? onCallTimeout;

  /// 对方忙线
  void Function(CallSession session, String busyUserID)? onCallBusy;

  /// 通话已接通（LiveKit 连接成功，通话正式开始）
  void Function(CallSession session)? onCallConnected;

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
