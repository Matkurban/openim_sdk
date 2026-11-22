import 'package:openim_sdk/openim_sdk.dart';

/// 群组与群成员事件监听器。
///
/// Group and group-member event listener.
class OnGroupListener {
  /// 入群申请被通过回调 / Callback invoked when a group join application is accepted.
  void Function(GroupApplicationInfo info)? onGroupApplicationAccepted;

  /// 收到新的入群申请回调 / Callback invoked when a new group join application arrives.
  void Function(GroupApplicationInfo info)? onGroupApplicationAdded;

  /// 入群申请被删除回调 / Callback invoked when a group join application is deleted.
  void Function(GroupApplicationInfo info)? onGroupApplicationDeleted;

  /// 入群申请被拒绝回调 / Callback invoked when a group join application is rejected.
  void Function(GroupApplicationInfo info)? onGroupApplicationRejected;

  /// 群组已解散回调 / Callback invoked when a group is dismissed.
  void Function(GroupInfo info)? onGroupDismissed;

  /// 群资料更新回调 / Callback invoked when group profile info changes.
  void Function(GroupInfo info)? onGroupInfoChanged;

  /// 新成员加入群组回调 / Callback invoked when a member joins a group.
  void Function(GroupMembersInfo info)? onGroupMemberAdded;

  /// 群成员离开或被踢出回调 / Callback invoked when a member leaves or is kicked from a group.
  void Function(GroupMembersInfo info)? onGroupMemberDeleted;

  /// 群成员资料变更回调 / Callback invoked when a group member's info changes.
  void Function(GroupMembersInfo info)? onGroupMemberInfoChanged;

  /// 当前用户新加入群组回调 / Callback invoked when the current user joins a new group.
  void Function(GroupInfo info)? onJoinedGroupAdded;

  /// 当前用户退出或被移出群组回调 / Callback invoked when the current user leaves or is removed from a group.
  void Function(GroupInfo info)? onJoinedGroupDeleted;

  /// 创建群组事件监听器。
  ///
  /// Creates an [OnGroupListener] with optional group and membership callbacks.
  ///
  /// - [onGroupApplicationAccepted] 入群申请通过回调 / Group application accepted callback.
  /// - [onGroupApplicationAdded] 新增入群申请回调 / Group application added callback.
  /// - [onGroupApplicationDeleted] 删除入群申请回调 / Group application deleted callback.
  /// - [onGroupApplicationRejected] 拒绝入群申请回调 / Group application rejected callback.
  /// - [onGroupDismissed] 群解散回调 / Group dismissed callback.
  /// - [onGroupInfoChanged] 群信息变更回调 / Group info changed callback.
  /// - [onGroupMemberAdded] 群成员新增回调 / Group member added callback.
  /// - [onGroupMemberDeleted] 群成员移除回调 / Group member deleted callback.
  /// - [onGroupMemberInfoChanged] 群成员资料变更回调 / Group member info changed callback.
  /// - [onJoinedGroupAdded] 加入新群回调 / Joined group added callback.
  /// - [onJoinedGroupDeleted] 退群/移出群回调 / Joined group deleted callback.
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

  /// 触发入群申请通过回调 / Dispatches [onGroupApplicationAccepted].
  ///
  /// - [info] 入群申请信息 / Group application info.
  void groupApplicationAccepted(GroupApplicationInfo info) {
    onGroupApplicationAccepted?.call(info);
  }

  /// 触发新增入群申请回调 / Dispatches [onGroupApplicationAdded].
  ///
  /// - [info] 入群申请信息 / Group application info.
  void groupApplicationAdded(GroupApplicationInfo info) {
    onGroupApplicationAdded?.call(info);
  }

  /// 触发入群申请删除回调 / Dispatches [onGroupApplicationDeleted].
  ///
  /// - [info] 入群申请信息 / Group application info.
  void groupApplicationDeleted(GroupApplicationInfo info) {
    onGroupApplicationDeleted?.call(info);
  }

  /// 触发入群申请拒绝回调 / Dispatches [onGroupApplicationRejected].
  ///
  /// - [info] 入群申请信息 / Group application info.
  void groupApplicationRejected(GroupApplicationInfo info) {
    onGroupApplicationRejected?.call(info);
  }

  /// 触发群解散回调 / Dispatches [onGroupDismissed].
  ///
  /// - [info] 已解散的群信息 / Dismissed group info.
  void groupDismissed(GroupInfo info) {
    onGroupDismissed?.call(info);
  }

  /// 触发群信息变更回调 / Dispatches [onGroupInfoChanged].
  ///
  /// - [info] 更新后的群信息 / Updated group info.
  void groupInfoChanged(GroupInfo info) {
    onGroupInfoChanged?.call(info);
  }

  /// 触发群成员新增回调 / Dispatches [onGroupMemberAdded].
  ///
  /// - [info] 新加入的群成员信息 / Added group member info.
  void groupMemberAdded(GroupMembersInfo info) {
    onGroupMemberAdded?.call(info);
  }

  /// 触发群成员移除回调 / Dispatches [onGroupMemberDeleted].
  ///
  /// - [info] 被移除的群成员信息 / Removed group member info.
  void groupMemberDeleted(GroupMembersInfo info) {
    onGroupMemberDeleted?.call(info);
  }

  /// 触发群成员资料变更回调 / Dispatches [onGroupMemberInfoChanged].
  ///
  /// - [info] 变更后的群成员信息 / Updated group member info.
  void groupMemberInfoChanged(GroupMembersInfo info) {
    onGroupMemberInfoChanged?.call(info);
  }

  /// 触发加入新群回调 / Dispatches [onJoinedGroupAdded].
  ///
  /// - [info] 新加入的群组信息 / Newly joined group info.
  void joinedGroupAdded(GroupInfo info) {
    onJoinedGroupAdded?.call(info);
  }

  /// 触发退群或被移出群回调 / Dispatches [onJoinedGroupDeleted].
  ///
  /// - [info] 已离开的群组信息 / Left or removed group info.
  void joinedGroupDeleted(GroupInfo info) {
    onJoinedGroupDeleted?.call(info);
  }
}
