import 'package:openim_sdk/openim_sdk.dart';

/// 好友与黑名单关系链监听器，当好友或黑名单状态变更时回调。
///
/// Friendship and blacklist relationship listener.
class OnFriendshipListener {
  /// 好友申请被接受回调 / Callback invoked when a friend application is accepted.
  void Function(FriendApplicationInfo info)? onFriendApplicationAccepted;

  /// 收到新的好友申请回调 / Callback invoked when a new friend application arrives.
  void Function(FriendApplicationInfo info)? onFriendApplicationAdded;

  /// 好友申请被删除回调 / Callback invoked when a friend application is deleted.
  void Function(FriendApplicationInfo info)? onFriendApplicationDeleted;

  /// 好友申请被拒绝回调 / Callback invoked when a friend application is rejected.
  void Function(FriendApplicationInfo info)? onFriendApplicationRejected;

  /// 好友新增回调 / Callback invoked when a friend is added.
  void Function(FriendInfo info)? onFriendAdded;

  /// 好友删除回调 / Callback invoked when a friend is deleted.
  void Function(FriendInfo info)? onFriendDeleted;

  /// 好友资料或备注变更回调 / Callback invoked when a friend's info or remark changes.
  void Function(FriendInfo info)? onFriendInfoChanged;

  /// 黑名单新增回调 / Callback invoked when a user is added to the blacklist.
  void Function(BlacklistInfo info)? onBlackAdded;

  /// 黑名单移除回调 / Callback invoked when a user is removed from the blacklist.
  void Function(BlacklistInfo info)? onBlackDeleted;

  /// 创建好友关系监听器。
  ///
  /// Creates an [OnFriendshipListener] with optional friendship and blacklist callbacks.
  ///
  /// - [onFriendApplicationAccepted] 好友申请通过回调 / Friend application accepted callback.
  /// - [onFriendApplicationAdded] 好友申请新增回调 / Friend application added callback.
  /// - [onFriendApplicationDeleted] 好友申请删除回调 / Friend application deleted callback.
  /// - [onFriendApplicationRejected] 好友申请拒绝回调 / Friend application rejected callback.
  /// - [onFriendAdded] 好友新增回调 / Friend added callback.
  /// - [onFriendDeleted] 好友删除回调 / Friend deleted callback.
  /// - [onFriendInfoChanged] 好友资料变更回调 / Friend info changed callback.
  /// - [onBlackAdded] 黑名单新增回调 / Blacklist added callback.
  /// - [onBlackDeleted] 黑名单移除回调 / Blacklist removed callback.
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

  /// 触发黑名单新增回调 / Dispatches [onBlackAdded].
  ///
  /// - [info] 黑名单用户信息 / Blacklisted user info.
  void blackAdded(BlacklistInfo info) {
    onBlackAdded?.call(info);
  }

  /// 触发黑名单移除回调 / Dispatches [onBlackDeleted].
  ///
  /// - [info] 被移出黑名单的用户信息 / Unblocked user info.
  void blackDeleted(BlacklistInfo info) {
    onBlackDeleted?.call(info);
  }

  /// 触发好友新增回调 / Dispatches [onFriendAdded].
  ///
  /// - [info] 新增好友信息 / Added friend info.
  void friendAdded(FriendInfo info) {
    onFriendAdded?.call(info);
  }

  /// 触发好友申请通过回调 / Dispatches [onFriendApplicationAccepted].
  ///
  /// - [info] 好友申请信息 / Accepted friend application info.
  void friendApplicationAccepted(FriendApplicationInfo info) {
    onFriendApplicationAccepted?.call(info);
  }

  /// 触发好友申请新增回调 / Dispatches [onFriendApplicationAdded].
  ///
  /// - [info] 好友申请信息 / New friend application info.
  void friendApplicationAdded(FriendApplicationInfo info) {
    onFriendApplicationAdded?.call(info);
  }

  /// 触发好友申请删除回调 / Dispatches [onFriendApplicationDeleted].
  ///
  /// - [info] 好友申请信息 / Deleted friend application info.
  void friendApplicationDeleted(FriendApplicationInfo info) {
    onFriendApplicationDeleted?.call(info);
  }

  /// 触发好友申请拒绝回调 / Dispatches [onFriendApplicationRejected].
  ///
  /// - [info] 好友申请信息 / Rejected friend application info.
  void friendApplicationRejected(FriendApplicationInfo info) {
    onFriendApplicationRejected?.call(info);
  }

  /// 触发好友删除回调 / Dispatches [onFriendDeleted].
  ///
  /// - [info] 被删除好友信息 / Deleted friend info.
  void friendDeleted(FriendInfo info) {
    onFriendDeleted?.call(info);
  }

  /// 触发好友资料变更回调 / Dispatches [onFriendInfoChanged].
  ///
  /// - [info] 变更后的好友信息 / Updated friend info.
  void friendInfoChanged(FriendInfo info) {
    onFriendInfoChanged?.call(info);
  }
}
