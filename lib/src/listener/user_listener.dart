import 'package:openim_sdk/openim_sdk.dart';

/// Current User Profile Listener
/// 用户信息监听器，当用户信息变化时回调。
class OnUserListener {
  /// The information of the logged-in user has been updated
  /// 个人信息变更通知
  void Function(UserInfo info)? onSelfInfoUpdated;

  ///已订阅用户在线状态变更通知
  void Function(UserStatusInfo info)? onUserStatusChanged;

  OnUserListener({this.onSelfInfoUpdated, this.onUserStatusChanged});

  /// Callback for changes in user's own information
  void selfInfoUpdated(UserInfo info) {
    onSelfInfoUpdated?.call(info);
  }

  /// Callback for changes in user status
  void userStatusChanged(UserStatusInfo info) {
    onUserStatusChanged?.call(info);
  }
}
