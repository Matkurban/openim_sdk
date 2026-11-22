import 'package:openim_sdk/openim_sdk.dart';

/// IM 好友、申请与黑名单事件。
///
/// IM friendship, application, and blacklist event.
class ImRelationEvent {
  /// 事件类型：`friendAdded`、`friendDeleted`、`friendInfoChanged`、`blackAdded`、`blackDeleted`、`applicationAdded`、`applicationAccepted`、`applicationRejected`、`applicationDeleted`。
  final String kind;

  /// 好友信息（好友事件时有效）。
  final FriendInfo? friend;

  /// 黑名单信息（黑名单事件时有效）。
  final BlacklistInfo? blacklist;

  /// 好友申请信息（申请事件时有效）。
  final FriendApplicationInfo? application;

  /// 创建好友关系事件。
  const ImRelationEvent({
    required this.kind,
    this.friend,
    this.blacklist,
    this.application,
  });
}
