import 'package:openim_sdk/openim_sdk.dart';

/// Group Listener
class OnGroupListener {
  void Function(GroupApplicationInfo info)? onGroupApplicationAccepted;
  void Function(GroupApplicationInfo info)? onGroupApplicationAdded;
  void Function(GroupApplicationInfo info)? onGroupApplicationDeleted;
  void Function(GroupApplicationInfo info)? onGroupApplicationRejected;
  void Function(GroupInfo info)? onGroupDismissed;
  void Function(GroupInfo info)? onGroupInfoChanged;
  void Function(GroupMembersInfo info)? onGroupMemberAdded;
  void Function(GroupMembersInfo info)? onGroupMemberDeleted;
  void Function(GroupMembersInfo info)? onGroupMemberInfoChanged;
  void Function(GroupInfo info)? onJoinedGroupAdded;
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
