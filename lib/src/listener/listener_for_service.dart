import 'package:openim_sdk/openim_sdk.dart';

/// Friend Relationship Listener
class OnListenerForService {
  void Function(FriendApplicationInfo i)? onFriendApplicationAdded;
  void Function(FriendApplicationInfo i)? onFriendApplicationAccepted;
  void Function(GroupApplicationInfo info)? onGroupApplicationAccepted;
  void Function(GroupApplicationInfo info)? onGroupApplicationAdded;
  void Function(Message msg)? onRecvNewMessage;
  void Function(Message msg)? onRecvOnlineOnlyMessage;

  OnListenerForService({
    this.onFriendApplicationAdded,
    this.onFriendApplicationAccepted,
    this.onGroupApplicationAccepted,
    this.onGroupApplicationAdded,
    this.onRecvNewMessage,
    this.onRecvOnlineOnlyMessage,
  });

  void friendApplicationAccepted(FriendApplicationInfo u) {
    onFriendApplicationAccepted?.call(u);
  }

  void friendApplicationAdded(FriendApplicationInfo u) {
    onFriendApplicationAdded?.call(u);
  }

  void groupApplicationAccepted(GroupApplicationInfo info) {
    onGroupApplicationAccepted?.call(info);
  }

  void groupApplicationAdded(GroupApplicationInfo info) {
    onGroupApplicationAdded?.call(info);
  }

  void recvNewMessage(Message msg) {
    onRecvNewMessage?.call(msg);
  }

  void recvOnlineOnlyMessage(Message msg) {
    onRecvOnlineOnlyMessage?.call(msg);
  }
}
