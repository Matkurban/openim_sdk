import 'package:openim_sdk/openim_sdk.dart';

/// 当前用户资料与已订阅用户在线状态事件监听器。
///
/// Current user profile and subscribed users' online status listener.
class OnUserListener {
  /// 当前登录用户个人资料变更回调 / Callback invoked when the logged-in user's profile changes.
  void Function(UserInfo info)? onSelfInfoUpdated;

  /// 已订阅用户在线状态变更回调 / Callback invoked when a subscribed user's online status changes.
  void Function(UserStatusInfo info)? onUserStatusChanged;

  /// 创建用户信息事件监听器。
  ///
  /// Creates an [OnUserListener].
  ///
  /// - [onSelfInfoUpdated] 个人资料变更回调 / Self profile updated callback.
  /// - [onUserStatusChanged] 用户在线状态变更回调 / Subscribed user status changed callback.
  OnUserListener({this.onSelfInfoUpdated, this.onUserStatusChanged});

  /// 触发个人资料变更回调 / Dispatches [onSelfInfoUpdated].
  ///
  /// - [info] 更新后的当前用户信息 / Updated current user info.
  void selfInfoUpdated(UserInfo info) {
    onSelfInfoUpdated?.call(info);
  }

  /// 触发用户在线状态变更回调 / Dispatches [onUserStatusChanged].
  ///
  /// - [info] 在线状态变更信息 / Updated user online status info.
  void userStatusChanged(UserStatusInfo info) {
    onUserStatusChanged?.call(info);
  }
}
