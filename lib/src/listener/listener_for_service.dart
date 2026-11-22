import 'package:openim_sdk/openim_sdk.dart';

/// 后台服务级综合事件监听器（聚合好友申请、入群申请与新消息事件）。
///
/// Background service-level aggregated listener for friend/group applications and new messages.
class OnListenerForService {
  /// 收到好友申请回调 / Callback invoked when a new friend application arrives.
  void Function(FriendApplicationInfo i)? onFriendApplicationAdded;

  /// 好友申请通过回调 / Callback invoked when a friend application is accepted.
  void Function(FriendApplicationInfo i)? onFriendApplicationAccepted;

  /// 入群申请通过回调 / Callback invoked when a group application is accepted.
  void Function(GroupApplicationInfo info)? onGroupApplicationAccepted;

  /// 收到入群申请回调 / Callback invoked when a new group application arrives.
  void Function(GroupApplicationInfo info)? onGroupApplicationAdded;

  /// 收到新消息回调 / Callback invoked when a new message arrives.
  void Function(Message msg)? onRecvNewMessage;

  /// 收到仅在线消息回调 / Callback invoked when an online-only message arrives.
  void Function(Message msg)? onRecvOnlineOnlyMessage;

  /// 创建服务级事件监听器。
  ///
  /// Creates an [OnListenerForService] instance.
  ///
  /// - [onFriendApplicationAdded] 新增好友申请回调 / Friend application added callback.
  /// - [onFriendApplicationAccepted] 好友申请通过回调 / Friend application accepted callback.
  /// - [onGroupApplicationAccepted] 入群申请通过回调 / Group application accepted callback.
  /// - [onGroupApplicationAdded] 新增入群申请回调 / Group application added callback.
  /// - [onRecvNewMessage] 收到新消息回调 / New message callback.
  /// - [onRecvOnlineOnlyMessage] 收到仅在线消息回调 / Online-only message callback.
  OnListenerForService({
    this.onFriendApplicationAdded,
    this.onFriendApplicationAccepted,
    this.onGroupApplicationAccepted,
    this.onGroupApplicationAdded,
    this.onRecvNewMessage,
    this.onRecvOnlineOnlyMessage,
  });

  /// 触发好友申请通过回调 / Dispatches [onFriendApplicationAccepted].
  ///
  /// - [u] 好友申请信息 / Friend application info.
  void friendApplicationAccepted(FriendApplicationInfo u) {
    onFriendApplicationAccepted?.call(u);
  }

  /// 触发好友申请新增回调 / Dispatches [onFriendApplicationAdded].
  ///
  /// - [u] 好友申请信息 / Friend application info.
  void friendApplicationAdded(FriendApplicationInfo u) {
    onFriendApplicationAdded?.call(u);
  }

  /// 触发入群申请通过回调 / Dispatches [onGroupApplicationAccepted].
  ///
  /// - [info] 入群申请信息 / Group application info.
  void groupApplicationAccepted(GroupApplicationInfo info) {
    onGroupApplicationAccepted?.call(info);
  }

  /// 触发入群申请新增回调 / Dispatches [onGroupApplicationAdded].
  ///
  /// - [info] 入群申请信息 / Group application info.
  void groupApplicationAdded(GroupApplicationInfo info) {
    onGroupApplicationAdded?.call(info);
  }

  /// 触发新消息回调 / Dispatches [onRecvNewMessage].
  ///
  /// - [msg] 新消息对象 / Received message.
  void recvNewMessage(Message msg) {
    onRecvNewMessage?.call(msg);
  }

  /// 触发仅在线消息回调 / Dispatches [onRecvOnlineOnlyMessage].
  ///
  /// - [msg] 仅在线消息对象 / Received online-only message.
  void recvOnlineOnlyMessage(Message msg) {
    onRecvOnlineOnlyMessage?.call(msg);
  }
}
