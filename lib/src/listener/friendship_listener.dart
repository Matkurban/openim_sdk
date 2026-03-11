import 'package:openim_sdk/openim_sdk.dart';

/// Friendship Listener
class OnFriendshipListener {
  void Function(BlacklistInfo info)? onBlackAdded;
  void Function(BlacklistInfo info)? onBlackDeleted;
  void Function(FriendInfo info)? onFriendAdded;
  void Function(FriendApplicationInfo info)? onFriendApplicationAccepted;
  void Function(FriendApplicationInfo info)? onFriendApplicationAdded;
  void Function(FriendApplicationInfo info)? onFriendApplicationDeleted;
  void Function(FriendApplicationInfo info)? onFriendApplicationRejected;
  void Function(FriendInfo info)? onFriendDeleted;
  void Function(FriendInfo info)? onFriendInfoChanged;

  OnFriendshipListener({
    this.onBlackAdded,
    this.onBlackDeleted,
    this.onFriendAdded,
    this.onFriendApplicationAccepted,
    this.onFriendApplicationAdded,
    this.onFriendApplicationDeleted,
    this.onFriendApplicationRejected,
    this.onFriendDeleted,
    this.onFriendInfoChanged,
  });

  /// Added to the blacklist
  void blackAdded(BlacklistInfo info) {
    onBlackAdded?.call(info);
  }

  /// Removed from the blacklist
  void blackDeleted(BlacklistInfo info) {
    onBlackDeleted?.call(info);
  }

  /// Friend added
  void friendAdded(FriendInfo info) {
    onFriendAdded?.call(info);
  }

  /// Friend application accepted
  void friendApplicationAccepted(FriendApplicationInfo info) {
    onFriendApplicationAccepted?.call(info);
  }

  /// New friend application added
  void friendApplicationAdded(FriendApplicationInfo info) {
    onFriendApplicationAdded?.call(info);
  }

  /// Friend application deleted
  void friendApplicationDeleted(FriendApplicationInfo info) {
    onFriendApplicationDeleted?.call(info);
  }

  /// Friend application rejected
  void friendApplicationRejected(FriendApplicationInfo info) {
    onFriendApplicationRejected?.call(info);
  }

  /// Friend deleted
  void friendDeleted(FriendInfo info) {
    onFriendDeleted?.call(info);
  }

  /// Friend information changed
  void friendInfoChanged(FriendInfo info) {
    onFriendInfoChanged?.call(info);
  }
}
