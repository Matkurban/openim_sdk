import 'package:openim_sdk/openim_sdk.dart';

/// IM 用户资料与在线状态事件。
///
/// IM user profile and online status event.
class ImUserEvent {
  /// 事件类型：`selfInfoUpdated`、`userStatusChanged`。
  final String kind;

  /// 更新后的当前用户信息。
  final UserInfo? selfInfo;

  /// 变更后的用户在线状态。
  final UserStatusInfo? statusInfo;

  /// 创建用户事件。
  const ImUserEvent({required this.kind, this.selfInfo, this.statusInfo});
}
