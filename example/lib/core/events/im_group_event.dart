import 'package:openim_sdk/openim_sdk.dart';

/// IM 群组、群成员与入群申请事件。
///
/// IM group, group member, and group application event.
class ImGroupEvent {
  /// 事件类型：`joinedAdded`、`joinedDeleted`、`infoChanged`、`dismissed`、`memberAdded`、`memberDeleted`、`memberInfoChanged`、`applicationAdded`、`applicationAccepted`、`applicationRejected`、`applicationDeleted`。
  final String kind;

  /// 群组信息（群事件有效）。
  final GroupInfo? group;

  /// 群成员信息（成员事件有效）。
  final GroupMembersInfo? member;

  /// 入群申请信息（申请事件有效）。
  final GroupApplicationInfo? application;

  /// 创建群组事件。
  const ImGroupEvent({
    required this.kind,
    this.group,
    this.member,
    this.application,
  });
}
