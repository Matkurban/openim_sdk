import 'package:openim_sdk/openim_sdk.dart';

/// Friendship Listener
/// 好友及黑名单关系链监听器，当好友及黑名单信息改变时回调。
class OnFriendshipListener {
  ///好友申请被接受
  void Function(FriendApplicationInfo info)? onFriendApplicationAccepted;

  ///好友申请新增通知
  void Function(FriendApplicationInfo info)? onFriendApplicationAdded;

  ///好友申请被删除
  void Function(FriendApplicationInfo info)? onFriendApplicationDeleted;

  ///好友申请被拒绝
  void Function(FriendApplicationInfo info)? onFriendApplicationRejected;

  ///好友新增通知
  void Function(FriendInfo info)? onFriendAdded;

  ///好友删除通知
  void Function(FriendInfo info)? onFriendDeleted;

  ///好友资料变更通知
  void Function(FriendInfo info)? onFriendInfoChanged;

  ///黑名单新增通知
  void Function(BlacklistInfo info)? onBlackAdded;

  ///黑名单删除通知
  void Function(BlacklistInfo info)? onBlackDeleted;

  OnFriendshipListener({
    this.onFriendApplicationAccepted,
    this.onFriendApplicationAdded,
    this.onFriendApplicationDeleted,
    this.onFriendApplicationRejected,
    this.onFriendAdded,
    this.onFriendDeleted,
    this.onFriendInfoChanged,
    this.onBlackAdded,
    this.onBlackDeleted,
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
