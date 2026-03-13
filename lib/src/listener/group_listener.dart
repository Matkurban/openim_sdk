import 'package:openim_sdk/openim_sdk.dart';

/// Group Listener
/// 群组监听器，当群组及群成员信息改变时回调。
class OnGroupListener {
  ///群申请被接受通知
  void Function(GroupApplicationInfo info)? onGroupApplicationAccepted;

  ///新的群申请通知
  void Function(GroupApplicationInfo info)? onGroupApplicationAdded;

  ///群申请删除通知
  void Function(GroupApplicationInfo info)? onGroupApplicationDeleted;

  ///群申请被拒绝通知
  void Function(GroupApplicationInfo info)? onGroupApplicationRejected;

  ///群申请被拒绝通知
  void Function(GroupInfo info)? onGroupDismissed;
  void Function(GroupInfo info)? onGroupInfoChanged;

  ///有新成员加入群
  void Function(GroupMembersInfo info)? onGroupMemberAdded;

  ///有成员离开群
  void Function(GroupMembersInfo info)? onGroupMemberDeleted;

  ///某成员信息发生变更
  void Function(GroupMembersInfo info)? onGroupMemberInfoChanged;

  ///群成员变更
  void Function(GroupInfo info)? onJoinedGroupAdded;

  ///群成员变更
  void Function(GroupInfo info)? onJoinedGroupDeleted;

  OnGroupListener({
    this.onGroupApplicationAccepted,
    this.onGroupApplicationAdded,
    this.onGroupApplicationDeleted,
    this.onGroupApplicationRejected,
    this.onGroupDismissed,
    this.onGroupInfoChanged,
    this.onGroupMemberAdded,
    this.onGroupMemberDeleted,
    this.onGroupMemberInfoChanged,
    this.onJoinedGroupAdded,
    this.onJoinedGroupDeleted,
  });

  /// Group application accepted
  void groupApplicationAccepted(GroupApplicationInfo info) {
    onGroupApplicationAccepted?.call(info);
  }

  /// Group application added
  void groupApplicationAdded(GroupApplicationInfo info) {
    onGroupApplicationAdded?.call(info);
  }

  /// Group application deleted
  void groupApplicationDeleted(GroupApplicationInfo info) {
    onGroupApplicationDeleted?.call(info);
  }

  /// Group application rejected
  void groupApplicationRejected(GroupApplicationInfo info) {
    onGroupApplicationRejected?.call(info);
  }

  void groupDismissed(GroupInfo info) {
    onGroupDismissed?.call(info);
  }

  /// Group information changed
  void groupInfoChanged(GroupInfo info) {
    onGroupInfoChanged?.call(info);
  }

  /// Group member added
  void groupMemberAdded(GroupMembersInfo info) {
    onGroupMemberAdded?.call(info);
  }

  /// Group member deleted
  void groupMemberDeleted(GroupMembersInfo info) {
    onGroupMemberDeleted?.call(info);
  }

  /// Group member information changed
  void groupMemberInfoChanged(GroupMembersInfo info) {
    onGroupMemberInfoChanged?.call(info);
  }

  /// Joined group added
  void joinedGroupAdded(GroupInfo info) {
    onJoinedGroupAdded?.call(info);
  }

  /// Joined group deleted
  void joinedGroupDeleted(GroupInfo info) {
    onJoinedGroupDeleted?.call(info);
  }
}
