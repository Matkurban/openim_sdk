import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'notification_info.g.dart';

/// OA Notification
@JsonSerializable()
class OANotification extends Equatable {
  final String? notificationName;
  final String? notificationFaceURL;
  final int? notificationType;
  final String? text;
  final String? externalUrl;

  /// 0: Text-only, 1: Text + Image, 2: Text + Video, 3: Text + File
  final int? mixType;

  final PictureElem? pictureElem;
  final SoundElem? soundElem;
  final VideoElem? videoElem;
  final FileElem? fileElem;
  final String? ex;

  const OANotification({
    this.notificationName,
    this.notificationFaceURL,
    this.notificationType,
    this.text,
    this.externalUrl,
    this.mixType,
    this.pictureElem,
    this.soundElem,
    this.videoElem,
    this.fileElem,
    this.ex,
  });

  factory OANotification.fromJson(Map<String, dynamic> json) =>
      _$OANotificationFromJson(json);

  Map<String, dynamic> toJson() => _$OANotificationToJson(this);

  OANotification copyWith({
    String? notificationName,
    String? notificationFaceURL,
    int? notificationType,
    String? text,
    String? externalUrl,
    int? mixType,
    PictureElem? pictureElem,
    SoundElem? soundElem,
    VideoElem? videoElem,
    FileElem? fileElem,
    String? ex,
  }) {
    return OANotification(
      notificationName: notificationName ?? this.notificationName,
      notificationFaceURL: notificationFaceURL ?? this.notificationFaceURL,
      notificationType: notificationType ?? this.notificationType,
      text: text ?? this.text,
      externalUrl: externalUrl ?? this.externalUrl,
      mixType: mixType ?? this.mixType,
      pictureElem: pictureElem ?? this.pictureElem,
      soundElem: soundElem ?? this.soundElem,
      videoElem: videoElem ?? this.videoElem,
      fileElem: fileElem ?? this.fileElem,
      ex: ex ?? this.ex,
    );
  }

  @override
  List<Object?> get props => [
    notificationName,
    notificationFaceURL,
    notificationType,
    text,
    externalUrl,
    mixType,
    pictureElem,
    soundElem,
    videoElem,
    fileElem,
    ex,
  ];
}

/// Base class for group notifications with common group and opUser fields
@JsonSerializable()
class BaseGroupNotification extends Equatable {
  final GroupInfo? group;
  final GroupMembersInfo? opUser;

  const BaseGroupNotification({this.group, this.opUser});

  factory BaseGroupNotification.fromJson(Map<String, dynamic> json) =>
      _$BaseGroupNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$BaseGroupNotificationToJson(this);

  @override
  List<Object?> get props => [group, opUser];
}

/// Group Event Notification
@JsonSerializable()
class GroupNotification extends BaseGroupNotification {
  final GroupMembersInfo? groupOwnerUser;
  final List<GroupMembersInfo>? memberList;

  const GroupNotification({
    super.group,
    super.opUser,
    this.groupOwnerUser,
    this.memberList,
  });

  factory GroupNotification.fromJson(Map<String, dynamic> json) =>
      _$GroupNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$GroupNotificationToJson(this);

  GroupNotification copyWith({
    GroupInfo? group,
    GroupMembersInfo? opUser,
    GroupMembersInfo? groupOwnerUser,
    List<GroupMembersInfo>? memberList,
  }) {
    return GroupNotification(
      group: group ?? this.group,
      opUser: opUser ?? this.opUser,
      groupOwnerUser: groupOwnerUser ?? this.groupOwnerUser,
      memberList: memberList ?? this.memberList,
    );
  }

  @override
  List<Object?> get props => [group, opUser, groupOwnerUser, memberList];
}

/// User Invited to Join Group Notification
@JsonSerializable()
class InvitedJoinGroupNotification extends BaseGroupNotification {
  final GroupMembersInfo? inviterUser;
  final List<GroupMembersInfo>? invitedUserList;

  const InvitedJoinGroupNotification({
    super.group,
    super.opUser,
    this.inviterUser,
    this.invitedUserList,
  });

  factory InvitedJoinGroupNotification.fromJson(Map<String, dynamic> json) =>
      _$InvitedJoinGroupNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InvitedJoinGroupNotificationToJson(this);

  InvitedJoinGroupNotification copyWith({
    GroupInfo? group,
    GroupMembersInfo? opUser,
    GroupMembersInfo? inviterUser,
    List<GroupMembersInfo>? invitedUserList,
  }) {
    return InvitedJoinGroupNotification(
      group: group ?? this.group,
      opUser: opUser ?? this.opUser,
      inviterUser: inviterUser ?? this.inviterUser,
      invitedUserList: invitedUserList ?? this.invitedUserList,
    );
  }

  @override
  List<Object?> get props => [group, opUser, inviterUser, invitedUserList];
}

/// Group Member Kicked Notification
@JsonSerializable()
class KickedGroupMemeberNotification extends BaseGroupNotification {
  final List<GroupMembersInfo>? kickedUserList;

  const KickedGroupMemeberNotification({
    super.group,
    super.opUser,
    this.kickedUserList,
  });

  factory KickedGroupMemeberNotification.fromJson(Map<String, dynamic> json) =>
      _$KickedGroupMemeberNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$KickedGroupMemeberNotificationToJson(this);

  KickedGroupMemeberNotification copyWith({
    GroupInfo? group,
    GroupMembersInfo? opUser,
    List<GroupMembersInfo>? kickedUserList,
  }) {
    return KickedGroupMemeberNotification(
      group: group ?? this.group,
      opUser: opUser ?? this.opUser,
      kickedUserList: kickedUserList ?? this.kickedUserList,
    );
  }

  @override
  List<Object?> get props => [group, opUser, kickedUserList];
}

/// Quit Group Notification
@JsonSerializable()
class QuitGroupNotification extends Equatable {
  final GroupInfo? group;
  final GroupMembersInfo? quitUser;

  const QuitGroupNotification({this.group, this.quitUser});

  factory QuitGroupNotification.fromJson(Map<String, dynamic> json) =>
      _$QuitGroupNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$QuitGroupNotificationToJson(this);

  QuitGroupNotification copyWith({
    GroupInfo? group,
    GroupMembersInfo? quitUser,
  }) {
    return QuitGroupNotification(
      group: group ?? this.group,
      quitUser: quitUser ?? this.quitUser,
    );
  }

  @override
  List<Object?> get props => [group, quitUser];
}

/// Enter Group Notification
@JsonSerializable()
class EnterGroupNotification extends Equatable {
  final GroupInfo? group;
  final GroupMembersInfo? entrantUser;

  const EnterGroupNotification({this.group, this.entrantUser});

  factory EnterGroupNotification.fromJson(Map<String, dynamic> json) =>
      _$EnterGroupNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$EnterGroupNotificationToJson(this);

  EnterGroupNotification copyWith({
    GroupInfo? group,
    GroupMembersInfo? entrantUser,
  }) {
    return EnterGroupNotification(
      group: group ?? this.group,
      entrantUser: entrantUser ?? this.entrantUser,
    );
  }

  @override
  List<Object?> get props => [group, entrantUser];
}

/// Group Rights Transfer Notification
@JsonSerializable()
class GroupRightsTransferNoticication extends BaseGroupNotification {
  final GroupMembersInfo? newGroupOwner;

  const GroupRightsTransferNoticication({
    super.group,
    super.opUser,
    this.newGroupOwner,
  });

  factory GroupRightsTransferNoticication.fromJson(Map<String, dynamic> json) =>
      _$GroupRightsTransferNoticicationFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$GroupRightsTransferNoticicationToJson(this);

  GroupRightsTransferNoticication copyWith({
    GroupInfo? group,
    GroupMembersInfo? opUser,
    GroupMembersInfo? newGroupOwner,
  }) {
    return GroupRightsTransferNoticication(
      group: group ?? this.group,
      opUser: opUser ?? this.opUser,
      newGroupOwner: newGroupOwner ?? this.newGroupOwner,
    );
  }

  @override
  List<Object?> get props => [group, opUser, newGroupOwner];
}

/// Mute Member Notification
@JsonSerializable()
class MuteMemberNotification extends BaseGroupNotification {
  final GroupMembersInfo? mutedUser;
  final int? mutedSeconds;

  const MuteMemberNotification({
    super.group,
    super.opUser,
    this.mutedUser,
    this.mutedSeconds,
  });

  factory MuteMemberNotification.fromJson(Map<String, dynamic> json) =>
      _$MuteMemberNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MuteMemberNotificationToJson(this);

  MuteMemberNotification copyWith({
    GroupInfo? group,
    GroupMembersInfo? opUser,
    GroupMembersInfo? mutedUser,
    int? mutedSeconds,
  }) {
    return MuteMemberNotification(
      group: group ?? this.group,
      opUser: opUser ?? this.opUser,
      mutedUser: mutedUser ?? this.mutedUser,
      mutedSeconds: mutedSeconds ?? this.mutedSeconds,
    );
  }

  @override
  List<Object?> get props => [group, opUser, mutedUser, mutedSeconds];
}

/// Burn After Reading Notification
@JsonSerializable()
class BurnAfterReadingNotification extends Equatable {
  final String? recvID;
  final String? sendID;
  final bool? isPrivate;

  const BurnAfterReadingNotification({
    this.recvID,
    this.sendID,
    this.isPrivate,
  });

  factory BurnAfterReadingNotification.fromJson(Map<String, dynamic> json) =>
      _$BurnAfterReadingNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$BurnAfterReadingNotificationToJson(this);

  BurnAfterReadingNotification copyWith({
    String? recvID,
    String? sendID,
    bool? isPrivate,
  }) {
    return BurnAfterReadingNotification(
      recvID: recvID ?? this.recvID,
      sendID: sendID ?? this.sendID,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  @override
  List<Object?> get props => [recvID, sendID, isPrivate];
}

/// Group Member Information Changed Notification
@JsonSerializable()
class GroupMemberInfoChangedNotification extends BaseGroupNotification {
  final GroupMembersInfo? changedUser;

  const GroupMemberInfoChangedNotification({
    super.group,
    super.opUser,
    this.changedUser,
  });

  factory GroupMemberInfoChangedNotification.fromJson(
    Map<String, dynamic> json,
  ) => _$GroupMemberInfoChangedNotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$GroupMemberInfoChangedNotificationToJson(this);

  GroupMemberInfoChangedNotification copyWith({
    GroupInfo? group,
    GroupMembersInfo? opUser,
    GroupMembersInfo? changedUser,
  }) {
    return GroupMemberInfoChangedNotification(
      group: group ?? this.group,
      opUser: opUser ?? this.opUser,
      changedUser: changedUser ?? this.changedUser,
    );
  }

  @override
  List<Object?> get props => [group, opUser, changedUser];
}
