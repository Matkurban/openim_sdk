import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'notification_info.g.dart';

/// OA通知。
///
/// OA Notification
@JsonSerializable()
class OANotification extends Equatable {
  /// 通知名称。
  ///
  /// Notification name.
  final String? notificationName;

  /// 通知头像URL 地址。
  ///
  /// Notification avatar URL.
  final String? notificationFaceURL;

  /// 通知类型。
  ///
  /// Notification type.
  final int? notificationType;

  /// 文本。
  ///
  /// Text.
  final String? text;

  /// externalURL 地址。
  ///
  /// External URL.
  final String? externalUrl;

  /// mix类型。
  ///
  /// 0: Text-only, 1: Text + Image, 2: Text + Video, 3: Text + File
  final int? mixType;

  /// 图片元素。
  ///
  /// Picture element.
  final PictureElem? pictureElem;

  /// 语音元素。
  ///
  /// Voice audio element.
  final SoundElem? soundElem;

  /// 视频元素。
  ///
  /// Video element.
  final VideoElem? videoElem;

  /// 文件元素。
  ///
  /// File element.
  final FileElem? fileElem;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 创建 `OANotification` 实例。
  ///
  /// Creates a `OANotification` instance.
  ///
  /// - [notificationName] 通知名称 / Notification name.
  /// - [notificationFaceURL] 通知头像URL 地址 / Notification avatar URL.
  /// - [notificationType] 通知类型 / Notification type.
  /// - [text] 文本 / Text.
  /// - [externalUrl] externalURL 地址 / External URL.
  /// - [mixType] mix类型 / Mix type.
  /// - [pictureElem] 图片元素 / Picture element.
  /// - [soundElem] 语音元素 / Voice audio element.
  /// - [videoElem] 视频元素 / Video element.
  /// - [fileElem] 文件元素 / File element.
  /// - [ex] 扩展字段 / Extension.
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

  /// 从 JSON 字典反序列化实例（`OANotification.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`OANotification.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `OANotification` 结果 / Resulting `OANotification`.
  factory OANotification.fromJson(Map<String, dynamic> json) => _$OANotificationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$OANotificationToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [notificationName] 通知名称 / Notification name.
  /// - [notificationFaceURL] 通知头像URL 地址 / Notification avatar URL.
  /// - [notificationType] 通知类型 / Notification type.
  /// - [text] 文本 / Text.
  /// - [externalUrl] externalURL 地址 / External URL.
  /// - [mixType] mix类型 / Mix type.
  /// - [pictureElem] 图片元素 / Picture element.
  /// - [soundElem] 语音元素 / Voice audio element.
  /// - [videoElem] 视频元素 / Video element.
  /// - [fileElem] 文件元素 / File element.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `OANotification` 结果 / Resulting `OANotification`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
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

/// Base群组通知。
///
/// Base class for group notifications with common group and opUser fields
@JsonSerializable()
class BaseGroupNotification extends Equatable {
  /// 群组。
  ///
  /// Group.
  final GroupInfo? group;

  /// op用户。
  ///
  /// Op user.
  final GroupMembersInfo? opUser;

  /// 创建 `BaseGroupNotification` 实例。
  ///
  /// Creates a `BaseGroupNotification` instance.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  const BaseGroupNotification({this.group, this.opUser});

  /// 从 JSON 字典反序列化实例（`BaseGroupNotification.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`BaseGroupNotification.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `BaseGroupNotification` 结果 / Resulting `BaseGroupNotification`.
  factory BaseGroupNotification.fromJson(Map<String, dynamic> json) =>
      _$BaseGroupNotificationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$BaseGroupNotificationToJson(this);

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[group, opUser];
}

/// 群组通知。
///
/// Group Event Notification
@JsonSerializable()
class GroupNotification extends BaseGroupNotification {
  /// 群组群主/拥有者用户。
  ///
  /// Group owner user.
  final GroupMembersInfo? groupOwnerUser;

  /// 成员列表。
  ///
  /// Member list.
  final List<GroupMembersInfo>? memberList;

  /// 创建 `GroupNotification` 实例。
  ///
  /// Creates a `GroupNotification` instance.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [groupOwnerUser] 群组群主/拥有者用户 / Group owner user.
  /// - [memberList] 成员列表 / Member list.
  const GroupNotification({super.group, super.opUser, this.groupOwnerUser, this.memberList});

  /// 从 JSON 字典反序列化实例（`GroupNotification.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GroupNotification.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GroupNotification` 结果 / Resulting `GroupNotification`.
  factory GroupNotification.fromJson(Map<String, dynamic> json) =>
      _$GroupNotificationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  @override
  Map<String, dynamic> toJson() => _$GroupNotificationToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [groupOwnerUser] 群组群主/拥有者用户 / Group owner user.
  /// - [memberList] 成员列表 / Member list.
  /// - Returns: `GroupNotification` 结果 / Resulting `GroupNotification`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[group, opUser, groupOwnerUser, memberList];
}

/// 被邀请加入群组通知。
///
/// User Invited to Join Group Notification
@JsonSerializable()
class InvitedJoinGroupNotification extends BaseGroupNotification {
  /// 邀请者用户。
  ///
  /// Inviter user.
  final GroupMembersInfo? inviterUser;

  /// 被邀请用户列表。
  ///
  /// Invited user list.
  final List<GroupMembersInfo>? invitedUserList;

  /// 创建 `InvitedJoinGroupNotification` 实例。
  ///
  /// Creates a `InvitedJoinGroupNotification` instance.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [inviterUser] 邀请者用户 / Inviter user.
  /// - [invitedUserList] 被邀请用户列表 / Invited user list.
  const InvitedJoinGroupNotification({
    super.group,
    super.opUser,
    this.inviterUser,
    this.invitedUserList,
  });

  /// 从 JSON 字典反序列化实例（`InvitedJoinGroupNotification.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`InvitedJoinGroupNotification.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `InvitedJoinGroupNotification` 结果 / Resulting `InvitedJoinGroupNotification`.
  factory InvitedJoinGroupNotification.fromJson(Map<String, dynamic> json) =>
      _$InvitedJoinGroupNotificationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  @override
  Map<String, dynamic> toJson() => _$InvitedJoinGroupNotificationToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [inviterUser] 邀请者用户 / Inviter user.
  /// - [invitedUserList] 被邀请用户列表 / Invited user list.
  /// - Returns: `InvitedJoinGroupNotification` 结果 / Resulting `InvitedJoinGroupNotification`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[group, opUser, inviterUser, invitedUserList];
}

/// 被踢群组Memeber通知。
///
/// Group Member Kicked Notification
@JsonSerializable()
class KickedGroupMemeberNotification extends BaseGroupNotification {
  /// 被踢用户列表。
  ///
  /// Kicked user list.
  final List<GroupMembersInfo>? kickedUserList;

  /// 创建 `KickedGroupMemeberNotification` 实例。
  ///
  /// Creates a `KickedGroupMemeberNotification` instance.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [kickedUserList] 被踢用户列表 / Kicked user list.
  const KickedGroupMemeberNotification({super.group, super.opUser, this.kickedUserList});

  /// 从 JSON 字典反序列化实例（`KickedGroupMemeberNotification.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`KickedGroupMemeberNotification.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `KickedGroupMemeberNotification` 结果 / Resulting `KickedGroupMemeberNotification`.
  factory KickedGroupMemeberNotification.fromJson(Map<String, dynamic> json) =>
      _$KickedGroupMemeberNotificationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  @override
  Map<String, dynamic> toJson() => _$KickedGroupMemeberNotificationToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [kickedUserList] 被踢用户列表 / Kicked user list.
  /// - Returns: `KickedGroupMemeberNotification` 结果 / Resulting `KickedGroupMemeberNotification`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[group, opUser, kickedUserList];
}

/// 退出群组通知。
///
/// Quit Group Notification
@JsonSerializable()
class QuitGroupNotification extends Equatable {
  /// 群组。
  ///
  /// Group.
  final GroupInfo? group;

  /// 退出用户。
  ///
  /// Quit user.
  final GroupMembersInfo? quitUser;

  /// 创建 `QuitGroupNotification` 实例。
  ///
  /// Creates a `QuitGroupNotification` instance.
  ///
  /// - [group] 群组 / Group.
  /// - [quitUser] 退出用户 / Quit user.
  const QuitGroupNotification({this.group, this.quitUser});

  /// 从 JSON 字典反序列化实例（`QuitGroupNotification.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`QuitGroupNotification.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `QuitGroupNotification` 结果 / Resulting `QuitGroupNotification`.
  factory QuitGroupNotification.fromJson(Map<String, dynamic> json) =>
      _$QuitGroupNotificationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$QuitGroupNotificationToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [group] 群组 / Group.
  /// - [quitUser] 退出用户 / Quit user.
  /// - Returns: `QuitGroupNotification` 结果 / Resulting `QuitGroupNotification`.
  QuitGroupNotification copyWith({GroupInfo? group, GroupMembersInfo? quitUser}) {
    return QuitGroupNotification(group: group ?? this.group, quitUser: quitUser ?? this.quitUser);
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[group, quitUser];
}

/// Enter群组通知。
///
/// Enter Group Notification
@JsonSerializable()
class EnterGroupNotification extends Equatable {
  /// 群组。
  ///
  /// Group.
  final GroupInfo? group;

  /// entrant用户。
  ///
  /// Entrant user.
  final GroupMembersInfo? entrantUser;

  /// 创建 `EnterGroupNotification` 实例。
  ///
  /// Creates a `EnterGroupNotification` instance.
  ///
  /// - [group] 群组 / Group.
  /// - [entrantUser] entrant用户 / Entrant user.
  const EnterGroupNotification({this.group, this.entrantUser});

  /// 从 JSON 字典反序列化实例（`EnterGroupNotification.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`EnterGroupNotification.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `EnterGroupNotification` 结果 / Resulting `EnterGroupNotification`.
  factory EnterGroupNotification.fromJson(Map<String, dynamic> json) =>
      _$EnterGroupNotificationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$EnterGroupNotificationToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [group] 群组 / Group.
  /// - [entrantUser] entrant用户 / Entrant user.
  /// - Returns: `EnterGroupNotification` 结果 / Resulting `EnterGroupNotification`.
  EnterGroupNotification copyWith({GroupInfo? group, GroupMembersInfo? entrantUser}) {
    return EnterGroupNotification(
      group: group ?? this.group,
      entrantUser: entrantUser ?? this.entrantUser,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[group, entrantUser];
}

/// 群组Rights转让Noticication。
///
/// Group Rights Transfer Notification
@JsonSerializable()
class GroupRightsTransferNoticication extends BaseGroupNotification {
  /// new群组群主/拥有者。
  ///
  /// New group owner.
  final GroupMembersInfo? newGroupOwner;

  /// 创建 `GroupRightsTransferNoticication` 实例。
  ///
  /// Creates a `GroupRightsTransferNoticication` instance.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [newGroupOwner] new群组群主/拥有者 / New group owner.
  const GroupRightsTransferNoticication({super.group, super.opUser, this.newGroupOwner});

  /// 从 JSON 字典反序列化实例（`GroupRightsTransferNoticication.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GroupRightsTransferNoticication.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GroupRightsTransferNoticication` 结果 / Resulting `GroupRightsTransferNoticication`.
  factory GroupRightsTransferNoticication.fromJson(Map<String, dynamic> json) =>
      _$GroupRightsTransferNoticicationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  @override
  Map<String, dynamic> toJson() => _$GroupRightsTransferNoticicationToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [newGroupOwner] new群组群主/拥有者 / New group owner.
  /// - Returns: `GroupRightsTransferNoticication` 结果 / Resulting `GroupRightsTransferNoticication`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[group, opUser, newGroupOwner];
}

/// 禁言成员通知。
///
/// Mute Member Notification
@JsonSerializable()
class MuteMemberNotification extends BaseGroupNotification {
  /// 被禁言用户。
  ///
  /// Muted user.
  final GroupMembersInfo? mutedUser;

  /// 被禁言秒数。
  ///
  /// Muted seconds.
  final int? mutedSeconds;

  /// 创建 `MuteMemberNotification` 实例。
  ///
  /// Creates a `MuteMemberNotification` instance.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [mutedUser] 被禁言用户 / Muted user.
  /// - [mutedSeconds] 被禁言秒数 / Muted seconds.
  const MuteMemberNotification({super.group, super.opUser, this.mutedUser, this.mutedSeconds});

  /// 从 JSON 字典反序列化实例（`MuteMemberNotification.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MuteMemberNotification.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MuteMemberNotification` 结果 / Resulting `MuteMemberNotification`.
  factory MuteMemberNotification.fromJson(Map<String, dynamic> json) =>
      _$MuteMemberNotificationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  @override
  Map<String, dynamic> toJson() => _$MuteMemberNotificationToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [mutedUser] 被禁言用户 / Muted user.
  /// - [mutedSeconds] 被禁言秒数 / Muted seconds.
  /// - Returns: `MuteMemberNotification` 结果 / Resulting `MuteMemberNotification`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[group, opUser, mutedUser, mutedSeconds];
}

/// 阅后即焚AfterReading通知。
///
/// Burn After Reading Notification
@JsonSerializable()
class BurnAfterReadingNotification extends Equatable {
  /// 接收ID。
  ///
  /// Receive ID.
  final String? recvID;

  /// 发送ID。
  ///
  /// Send ID.
  final String? sendID;

  /// 是否阅后即焚。
  ///
  /// Whether private.
  final bool? isPrivate;

  /// 创建 `BurnAfterReadingNotification` 实例。
  ///
  /// Creates a `BurnAfterReadingNotification` instance.
  ///
  /// - [recvID] 接收ID / Receive ID.
  /// - [sendID] 发送ID / Send ID.
  /// - [isPrivate] 是否阅后即焚 / Whether private.
  const BurnAfterReadingNotification({this.recvID, this.sendID, this.isPrivate});

  /// 从 JSON 字典反序列化实例（`BurnAfterReadingNotification.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`BurnAfterReadingNotification.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `BurnAfterReadingNotification` 结果 / Resulting `BurnAfterReadingNotification`.
  factory BurnAfterReadingNotification.fromJson(Map<String, dynamic> json) =>
      _$BurnAfterReadingNotificationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$BurnAfterReadingNotificationToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [recvID] 接收ID / Receive ID.
  /// - [sendID] 发送ID / Send ID.
  /// - [isPrivate] 是否阅后即焚 / Whether private.
  /// - Returns: `BurnAfterReadingNotification` 结果 / Resulting `BurnAfterReadingNotification`.
  BurnAfterReadingNotification copyWith({String? recvID, String? sendID, bool? isPrivate}) {
    return BurnAfterReadingNotification(
      recvID: recvID ?? this.recvID,
      sendID: sendID ?? this.sendID,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[recvID, sendID, isPrivate];
}

/// 群组成员信息Changed通知。
///
/// Group Member Information Changed Notification
@JsonSerializable()
class GroupMemberInfoChangedNotification extends BaseGroupNotification {
  /// changed用户。
  ///
  /// Changed user.
  final GroupMembersInfo? changedUser;

  /// 创建 `GroupMemberInfoChangedNotification` 实例。
  ///
  /// Creates a `GroupMemberInfoChangedNotification` instance.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [changedUser] changed用户 / Changed user.
  const GroupMemberInfoChangedNotification({super.group, super.opUser, this.changedUser});

  /// 从 JSON 字典反序列化实例（`GroupMemberInfoChangedNotification.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GroupMemberInfoChangedNotification.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GroupMemberInfoChangedNotification` 结果 / Resulting `GroupMemberInfoChangedNotification`.
  factory GroupMemberInfoChangedNotification.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberInfoChangedNotificationFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  @override
  Map<String, dynamic> toJson() => _$GroupMemberInfoChangedNotificationToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [group] 群组 / Group.
  /// - [opUser] op用户 / Op user.
  /// - [changedUser] changed用户 / Changed user.
  /// - Returns: `GroupMemberInfoChangedNotification` 结果 / Resulting `GroupMemberInfoChangedNotification`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[group, opUser, changedUser];
}
