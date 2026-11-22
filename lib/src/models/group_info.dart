import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'group_info.g.dart';

/// 群组信息。
///
/// Group Information
@JsonSerializable()
class GroupInfo extends Equatable {
  /// 群组ID。
  ///
  /// Group ID.
  final String groupID;

  /// 群组名称。
  ///
  /// Group name.
  final String? groupName;

  /// 通知。
  ///
  /// Notification.
  final String? notification;

  /// 简介。
  ///
  /// Introduction.
  final String? introduction;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String? faceURL;

  /// 群主/拥有者用户ID。
  ///
  /// Owner user ID.
  final String? ownerUserID;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  final int? createTime;

  /// 成员数量。
  ///
  /// Member count.
  final int? memberCount;

  /// 状态。
  ///
  /// Status.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupStatus? status;

  /// 创建者用户ID。
  ///
  /// Creator user ID.
  final String? creatorUserID;

  /// 群组类型。
  ///
  /// Group type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupType? groupType;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// need验证。
  ///
  /// Need verification.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupVerification? needVerification;

  /// look成员信息。
  ///
  /// Look member info.
  final int? lookMemberInfo;

  /// apply成员好友。
  ///
  /// Apply member friend.
  final int? applyMemberFriend;

  /// 通知更新时间戳。
  ///
  /// Notification update timestamp.
  final int? notificationUpdateTime;

  /// 通知用户ID。
  ///
  /// Notification user ID.
  final String? notificationUserID;

  /// 创建 `GroupInfo` 实例。
  ///
  /// Creates a `GroupInfo` instance.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [groupName] 群组名称 / Group name.
  /// - [notification] 通知 / Notification.
  /// - [introduction] 简介 / Introduction.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [memberCount] 成员数量 / Member count.
  /// - [status] 状态 / Status.
  /// - [creatorUserID] 创建者用户ID / Creator user ID.
  /// - [groupType] 群组类型 / Group type.
  /// - [ex] 扩展字段 / Extension.
  /// - [needVerification] need验证 / Need verification.
  /// - [lookMemberInfo] look成员信息 / Look member info.
  /// - [applyMemberFriend] apply成员好友 / Apply member friend.
  /// - [notificationUpdateTime] 通知更新时间戳 / Notification update timestamp.
  /// - [notificationUserID] 通知用户ID / Notification user ID.
  const GroupInfo({
    required this.groupID,
    this.groupName,
    this.notification,
    this.introduction,
    this.faceURL,
    this.ownerUserID,
    this.createTime,
    this.memberCount,
    this.status,
    this.creatorUserID,
    this.groupType,
    this.ex,
    this.needVerification,
    this.lookMemberInfo,
    this.applyMemberFriend,
    this.notificationUpdateTime,
    this.notificationUserID,
  });

  /// 从 JSON 字典反序列化实例（`GroupInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GroupInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GroupInfo` 结果 / Resulting `GroupInfo`.
  factory GroupInfo.fromJson(Map<String, dynamic> json) => _$GroupInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GroupInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [groupName] 群组名称 / Group name.
  /// - [notification] 通知 / Notification.
  /// - [introduction] 简介 / Introduction.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [memberCount] 成员数量 / Member count.
  /// - [status] 状态 / Status.
  /// - [creatorUserID] 创建者用户ID / Creator user ID.
  /// - [groupType] 群组类型 / Group type.
  /// - [ex] 扩展字段 / Extension.
  /// - [needVerification] need验证 / Need verification.
  /// - [lookMemberInfo] look成员信息 / Look member info.
  /// - [applyMemberFriend] apply成员好友 / Apply member friend.
  /// - [notificationUpdateTime] 通知更新时间戳 / Notification update timestamp.
  /// - [notificationUserID] 通知用户ID / Notification user ID.
  /// - Returns: `GroupInfo` 结果 / Resulting `GroupInfo`.
  GroupInfo copyWith({
    String? groupID,
    String? groupName,
    String? notification,
    String? introduction,
    String? faceURL,
    String? ownerUserID,
    int? createTime,
    int? memberCount,
    GroupStatus? status,
    String? creatorUserID,
    GroupType? groupType,
    String? ex,
    GroupVerification? needVerification,
    int? lookMemberInfo,
    int? applyMemberFriend,
    int? notificationUpdateTime,
    String? notificationUserID,
  }) {
    return GroupInfo(
      groupID: groupID ?? this.groupID,
      groupName: groupName ?? this.groupName,
      notification: notification ?? this.notification,
      introduction: introduction ?? this.introduction,
      faceURL: faceURL ?? this.faceURL,
      ownerUserID: ownerUserID ?? this.ownerUserID,
      createTime: createTime ?? this.createTime,
      memberCount: memberCount ?? this.memberCount,
      status: status ?? this.status,
      creatorUserID: creatorUserID ?? this.creatorUserID,
      groupType: groupType ?? this.groupType,
      ex: ex ?? this.ex,
      needVerification: needVerification ?? this.needVerification,
      lookMemberInfo: lookMemberInfo ?? this.lookMemberInfo,
      applyMemberFriend: applyMemberFriend ?? this.applyMemberFriend,
      notificationUpdateTime: notificationUpdateTime ?? this.notificationUpdateTime,
      notificationUserID: notificationUserID ?? this.notificationUserID,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    groupID,
    groupName,
    notification,
    introduction,
    faceURL,
    ownerUserID,
    createTime,
    memberCount,
    status,
    creatorUserID,
    groupType,
    ex,
    needVerification,
    lookMemberInfo,
    applyMemberFriend,
    notificationUpdateTime,
    notificationUserID,
  ];
}

/// 群组成员列表信息。
///
/// Group Member Information
@JsonSerializable()
class GroupMembersInfo extends Equatable {
  /// 群组ID。
  ///
  /// Group ID.
  final String? groupID;

  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 昵称。
  ///
  /// Nickname.
  final String? nickname;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String? faceURL;

  /// 角色等级。
  ///
  /// Role level.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupRoleLevel? roleLevel;

  /// 加入时间戳。
  ///
  /// Join timestamp.
  final int? joinTime;

  /// 加入来源。
  ///
  /// Join source.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final JoinSource? joinSource;

  /// 操作者用户ID。
  ///
  /// Operator user ID.
  final String? operatorUserID;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 禁言结束时间戳。
  ///
  /// Mute end timestamp.
  final int? muteEndTime;

  /// appManger等级。
  ///
  /// App manger level.
  @JsonKey(name: 'appMangerLevel')
  final int? appMangerLevel;

  /// 邀请者用户ID。
  ///
  /// Inviter user ID.
  final String? inviterUserID;

  /// 创建 `GroupMembersInfo` 实例。
  ///
  /// Creates a `GroupMembersInfo` instance.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [roleLevel] 角色等级 / Role level.
  /// - [joinTime] 加入时间戳 / Join timestamp.
  /// - [joinSource] 加入来源 / Join source.
  /// - [operatorUserID] 操作者用户ID / Operator user ID.
  /// - [ex] 扩展字段 / Extension.
  /// - [muteEndTime] 禁言结束时间戳 / Mute end timestamp.
  /// - [appMangerLevel] appManger等级 / App manger level.
  /// - [inviterUserID] 邀请者用户ID / Inviter user ID.
  const GroupMembersInfo({
    this.groupID,
    this.userID,
    this.nickname,
    this.faceURL,
    this.roleLevel,
    this.joinTime,
    this.joinSource,
    this.operatorUserID,
    this.ex,
    this.muteEndTime,
    this.appMangerLevel,
    this.inviterUserID,
  });

  /// 从 JSON 字典反序列化实例（`GroupMembersInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GroupMembersInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GroupMembersInfo` 结果 / Resulting `GroupMembersInfo`.
  factory GroupMembersInfo.fromJson(Map<String, dynamic> json) => _$GroupMembersInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GroupMembersInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [roleLevel] 角色等级 / Role level.
  /// - [joinTime] 加入时间戳 / Join timestamp.
  /// - [joinSource] 加入来源 / Join source.
  /// - [operatorUserID] 操作者用户ID / Operator user ID.
  /// - [ex] 扩展字段 / Extension.
  /// - [muteEndTime] 禁言结束时间戳 / Mute end timestamp.
  /// - [appMangerLevel] appManger等级 / App manger level.
  /// - [inviterUserID] 邀请者用户ID / Inviter user ID.
  /// - Returns: `GroupMembersInfo` 结果 / Resulting `GroupMembersInfo`.
  GroupMembersInfo copyWith({
    String? groupID,
    String? userID,
    String? nickname,
    String? faceURL,
    GroupRoleLevel? roleLevel,
    int? joinTime,
    JoinSource? joinSource,
    String? operatorUserID,
    String? ex,
    int? muteEndTime,
    int? appMangerLevel,
    String? inviterUserID,
  }) {
    return GroupMembersInfo(
      groupID: groupID ?? this.groupID,
      userID: userID ?? this.userID,
      nickname: nickname ?? this.nickname,
      faceURL: faceURL ?? this.faceURL,
      roleLevel: roleLevel ?? this.roleLevel,
      joinTime: joinTime ?? this.joinTime,
      joinSource: joinSource ?? this.joinSource,
      operatorUserID: operatorUserID ?? this.operatorUserID,
      ex: ex ?? this.ex,
      muteEndTime: muteEndTime ?? this.muteEndTime,
      appMangerLevel: appMangerLevel ?? this.appMangerLevel,
      inviterUserID: inviterUserID ?? this.inviterUserID,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    groupID,
    userID,
    nickname,
    faceURL,
    roleLevel,
    joinTime,
    joinSource,
    operatorUserID,
    ex,
    muteEndTime,
    appMangerLevel,
    inviterUserID,
  ];
}

/// 群组成员角色。
///
/// Group Member Role
@JsonSerializable()
class GroupMemberRole extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 角色等级。
  ///
  /// Role level.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupRoleLevel? roleLevel;

  /// 创建 `GroupMemberRole` 实例。
  ///
  /// Creates a `GroupMemberRole` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [roleLevel] 角色等级 / Role level.
  const GroupMemberRole({this.userID, this.roleLevel});

  /// 从 JSON 字典反序列化实例（`GroupMemberRole.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GroupMemberRole.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GroupMemberRole` 结果 / Resulting `GroupMemberRole`.
  factory GroupMemberRole.fromJson(Map<String, dynamic> json) => _$GroupMemberRoleFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GroupMemberRoleToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [roleLevel] 角色等级 / Role level.
  /// - Returns: `GroupMemberRole` 结果 / Resulting `GroupMemberRole`.
  GroupMemberRole copyWith({String? userID, GroupRoleLevel? roleLevel}) {
    return GroupMemberRole(userID: userID ?? this.userID, roleLevel: roleLevel ?? this.roleLevel);
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[userID, roleLevel];
}

/// 群组申请信息。
///
/// Group Application Information
@JsonSerializable()
class GroupApplicationInfo extends Equatable {
  /// 群组ID。
  ///
  /// Group ID.
  final String? groupID;

  /// 群组名称。
  ///
  /// Group name.
  final String? groupName;

  /// 通知。
  ///
  /// Notification.
  final String? notification;

  /// 简介。
  ///
  /// Introduction.
  final String? introduction;

  /// 群组头像URL 地址。
  ///
  /// Group avatar URL.
  final String? groupFaceURL;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  final int? createTime;

  /// 状态。
  ///
  /// Status.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupStatus? status;

  /// 创建者用户ID。
  ///
  /// Creator user ID.
  final String? creatorUserID;

  /// 群组类型。
  ///
  /// Group type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupType? groupType;

  /// 群主/拥有者用户ID。
  ///
  /// Owner user ID.
  final String? ownerUserID;

  /// 成员数量。
  ///
  /// Member count.
  final int? memberCount;

  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 昵称。
  ///
  /// Nickname.
  final String? nickname;

  /// 用户头像URL 地址。
  ///
  /// User avatar URL.
  final String? userFaceURL;

  /// 性别。
  ///
  /// Gender.
  final int? gender;

  /// 处理结果。
  ///
  /// Handle result.
  final int? handleResult;

  /// 请求参数消息。
  ///
  /// Request message.
  final String? reqMsg;

  /// handled消息。
  ///
  /// Handled message.
  final String? handledMsg;

  /// 请求参数时间戳。
  ///
  /// Request timestamp.
  final int? reqTime;

  /// 处理用户ID。
  ///
  /// Handle user ID.
  final String? handleUserID;

  /// handled时间戳。
  ///
  /// Handled timestamp.
  final int? handledTime;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 加入来源。
  ///
  /// Join source.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final JoinSource? joinSource;

  /// 邀请者用户ID。
  ///
  /// Inviter user ID.
  final String? inviterUserID;

  /// 创建 `GroupApplicationInfo` 实例。
  ///
  /// Creates a `GroupApplicationInfo` instance.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [groupName] 群组名称 / Group name.
  /// - [notification] 通知 / Notification.
  /// - [introduction] 简介 / Introduction.
  /// - [groupFaceURL] 群组头像URL 地址 / Group avatar URL.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [status] 状态 / Status.
  /// - [creatorUserID] 创建者用户ID / Creator user ID.
  /// - [groupType] 群组类型 / Group type.
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [memberCount] 成员数量 / Member count.
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [userFaceURL] 用户头像URL 地址 / User avatar URL.
  /// - [gender] 性别 / Gender.
  /// - [handleResult] 处理结果 / Handle result.
  /// - [reqMsg] 请求参数消息 / Request message.
  /// - [handledMsg] handled消息 / Handled message.
  /// - [reqTime] 请求参数时间戳 / Request timestamp.
  /// - [handleUserID] 处理用户ID / Handle user ID.
  /// - [handledTime] handled时间戳 / Handled timestamp.
  /// - [ex] 扩展字段 / Extension.
  /// - [joinSource] 加入来源 / Join source.
  /// - [inviterUserID] 邀请者用户ID / Inviter user ID.
  const GroupApplicationInfo({
    this.groupID,
    this.groupName,
    this.notification,
    this.introduction,
    this.groupFaceURL,
    this.createTime,
    this.status,
    this.creatorUserID,
    this.groupType,
    this.ownerUserID,
    this.memberCount,
    this.userID,
    this.nickname,
    this.userFaceURL,
    this.gender,
    this.handleResult,
    this.reqMsg,
    this.handledMsg,
    this.reqTime,
    this.handleUserID,
    this.handledTime,
    this.ex,
    this.joinSource,
    this.inviterUserID,
  });

  /// 从 JSON 字典反序列化实例（`GroupApplicationInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GroupApplicationInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GroupApplicationInfo` 结果 / Resulting `GroupApplicationInfo`.
  factory GroupApplicationInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupApplicationInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GroupApplicationInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [groupName] 群组名称 / Group name.
  /// - [notification] 通知 / Notification.
  /// - [introduction] 简介 / Introduction.
  /// - [groupFaceURL] 群组头像URL 地址 / Group avatar URL.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [status] 状态 / Status.
  /// - [creatorUserID] 创建者用户ID / Creator user ID.
  /// - [groupType] 群组类型 / Group type.
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [memberCount] 成员数量 / Member count.
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [userFaceURL] 用户头像URL 地址 / User avatar URL.
  /// - [gender] 性别 / Gender.
  /// - [handleResult] 处理结果 / Handle result.
  /// - [reqMsg] 请求参数消息 / Request message.
  /// - [handledMsg] handled消息 / Handled message.
  /// - [reqTime] 请求参数时间戳 / Request timestamp.
  /// - [handleUserID] 处理用户ID / Handle user ID.
  /// - [handledTime] handled时间戳 / Handled timestamp.
  /// - [ex] 扩展字段 / Extension.
  /// - [joinSource] 加入来源 / Join source.
  /// - [inviterUserID] 邀请者用户ID / Inviter user ID.
  /// - Returns: `GroupApplicationInfo` 结果 / Resulting `GroupApplicationInfo`.
  GroupApplicationInfo copyWith({
    String? groupID,
    String? groupName,
    String? notification,
    String? introduction,
    String? groupFaceURL,
    int? createTime,
    GroupStatus? status,
    String? creatorUserID,
    GroupType? groupType,
    String? ownerUserID,
    int? memberCount,
    String? userID,
    String? nickname,
    String? userFaceURL,
    int? gender,
    int? handleResult,
    String? reqMsg,
    String? handledMsg,
    int? reqTime,
    String? handleUserID,
    int? handledTime,
    String? ex,
    JoinSource? joinSource,
    String? inviterUserID,
  }) {
    return GroupApplicationInfo(
      groupID: groupID ?? this.groupID,
      groupName: groupName ?? this.groupName,
      notification: notification ?? this.notification,
      introduction: introduction ?? this.introduction,
      groupFaceURL: groupFaceURL ?? this.groupFaceURL,
      createTime: createTime ?? this.createTime,
      status: status ?? this.status,
      creatorUserID: creatorUserID ?? this.creatorUserID,
      groupType: groupType ?? this.groupType,
      ownerUserID: ownerUserID ?? this.ownerUserID,
      memberCount: memberCount ?? this.memberCount,
      userID: userID ?? this.userID,
      nickname: nickname ?? this.nickname,
      userFaceURL: userFaceURL ?? this.userFaceURL,
      gender: gender ?? this.gender,
      handleResult: handleResult ?? this.handleResult,
      reqMsg: reqMsg ?? this.reqMsg,
      handledMsg: handledMsg ?? this.handledMsg,
      reqTime: reqTime ?? this.reqTime,
      handleUserID: handleUserID ?? this.handleUserID,
      handledTime: handledTime ?? this.handledTime,
      ex: ex ?? this.ex,
      joinSource: joinSource ?? this.joinSource,
      inviterUserID: inviterUserID ?? this.inviterUserID,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    groupID,
    groupName,
    notification,
    introduction,
    groupFaceURL,
    createTime,
    status,
    creatorUserID,
    groupType,
    ownerUserID,
    memberCount,
    userID,
    nickname,
    userFaceURL,
    gender,
    handleResult,
    reqMsg,
    handledMsg,
    reqTime,
    handleUserID,
    handledTime,
    ex,
    joinSource,
    inviterUserID,
  ];
}

/// 群组邀请结果。
///
/// Group Invitation Result
@JsonSerializable()
class GroupInviteResult extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 结果。
  ///
  /// Result.
  final int? result;

  /// 创建 `GroupInviteResult` 实例。
  ///
  /// Creates a `GroupInviteResult` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [result] 结果 / Result.
  const GroupInviteResult({this.userID, this.result});

  /// 从 JSON 字典反序列化实例（`GroupInviteResult.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GroupInviteResult.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GroupInviteResult` 结果 / Resulting `GroupInviteResult`.
  factory GroupInviteResult.fromJson(Map<String, dynamic> json) =>
      _$GroupInviteResultFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GroupInviteResultToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [result] 结果 / Result.
  /// - Returns: `GroupInviteResult` 结果 / Resulting `GroupInviteResult`.
  GroupInviteResult copyWith({String? userID, int? result}) {
    return GroupInviteResult(userID: userID ?? this.userID, result: result ?? this.result);
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[userID, result];
}

/// 获取群组申请列表作为接收方请求参数。
///
/// Get group application list as recipient request.
@JsonSerializable()
class GetGroupApplicationListAsRecipientReq extends Equatable {
  /// 群组ID 列表。
  ///
  /// Group i ds.
  final List<String> groupIDs;

  /// 处理Results。
  ///
  /// Handle results.
  final List<int> handleResults;

  /// 偏移量。
  ///
  /// Offset.
  final int offset;

  /// 数量。
  ///
  /// Count.
  final int count;

  /// 创建 `GetGroupApplicationListAsRecipientReq` 实例。
  ///
  /// Creates a `GetGroupApplicationListAsRecipientReq` instance.
  ///
  /// - [groupIDs] 群组ID 列表 / Group i ds.
  /// - [handleResults] 处理Results / Handle results.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  const GetGroupApplicationListAsRecipientReq({
    this.groupIDs = const <String>[],
    this.handleResults = const <int>[],
    required this.offset,
    required this.count,
  });

  /// 从 JSON 字典反序列化实例（`GetGroupApplicationListAsRecipientReq.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GetGroupApplicationListAsRecipientReq.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GetGroupApplicationListAsRecipientReq` 结果 / Resulting `GetGroupApplicationListAsRecipientReq`.
  factory GetGroupApplicationListAsRecipientReq.fromJson(Map<String, dynamic> json) =>
      _$GetGroupApplicationListAsRecipientReqFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GetGroupApplicationListAsRecipientReqToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [groupIDs] 群组ID 列表 / Group i ds.
  /// - [handleResults] 处理Results / Handle results.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `GetGroupApplicationListAsRecipientReq` 结果 / Resulting `GetGroupApplicationListAsRecipientReq`.
  GetGroupApplicationListAsRecipientReq copyWith({
    List<String>? groupIDs,
    List<int>? handleResults,
    int? offset,
    int? count,
  }) {
    return GetGroupApplicationListAsRecipientReq(
      groupIDs: groupIDs ?? this.groupIDs,
      handleResults: handleResults ?? this.handleResults,
      offset: offset ?? this.offset,
      count: count ?? this.count,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[groupIDs, handleResults, offset, count];
}

/// 获取群组申请列表作为申请方请求参数。
///
/// Get group application list as applicant request.
@JsonSerializable()
class GetGroupApplicationListAsApplicantReq extends Equatable {
  /// 群组ID 列表。
  ///
  /// Group i ds.
  final List<String> groupIDs;

  /// 处理Results。
  ///
  /// Handle results.
  final List<int> handleResults;

  /// 偏移量。
  ///
  /// Offset.
  final int offset;

  /// 数量。
  ///
  /// Count.
  final int count;

  /// 创建 `GetGroupApplicationListAsApplicantReq` 实例。
  ///
  /// Creates a `GetGroupApplicationListAsApplicantReq` instance.
  ///
  /// - [groupIDs] 群组ID 列表 / Group i ds.
  /// - [handleResults] 处理Results / Handle results.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  const GetGroupApplicationListAsApplicantReq({
    this.groupIDs = const <String>[],
    this.handleResults = const <int>[],
    this.offset = 0,
    this.count = 40,
  });

  /// 从 JSON 字典反序列化实例（`GetGroupApplicationListAsApplicantReq.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GetGroupApplicationListAsApplicantReq.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GetGroupApplicationListAsApplicantReq` 结果 / Resulting `GetGroupApplicationListAsApplicantReq`.
  factory GetGroupApplicationListAsApplicantReq.fromJson(Map<String, dynamic> json) =>
      _$GetGroupApplicationListAsApplicantReqFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GetGroupApplicationListAsApplicantReqToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [groupIDs] 群组ID 列表 / Group i ds.
  /// - [handleResults] 处理Results / Handle results.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `GetGroupApplicationListAsApplicantReq` 结果 / Resulting `GetGroupApplicationListAsApplicantReq`.
  GetGroupApplicationListAsApplicantReq copyWith({
    List<String>? groupIDs,
    List<int>? handleResults,
    int? offset,
    int? count,
  }) {
    return GetGroupApplicationListAsApplicantReq(
      groupIDs: groupIDs ?? this.groupIDs,
      handleResults: handleResults ?? this.handleResults,
      offset: offset ?? this.offset,
      count: count ?? this.count,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[groupIDs, handleResults, offset, count];
}

/// 获取群组申请未处理数量请求参数。
///
/// Get group application unhandled count request.
@JsonSerializable()
class GetGroupApplicationUnhandledCountReq extends Equatable {
  /// 时间戳。
  ///
  /// Timestamp.
  final int time;

  /// 创建 `GetGroupApplicationUnhandledCountReq` 实例。
  ///
  /// Creates a `GetGroupApplicationUnhandledCountReq` instance.
  ///
  /// - [time] 时间戳 / Timestamp.
  const GetGroupApplicationUnhandledCountReq({this.time = 0});

  /// 从 JSON 字典反序列化实例（`GetGroupApplicationUnhandledCountReq.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GetGroupApplicationUnhandledCountReq.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GetGroupApplicationUnhandledCountReq` 结果 / Resulting `GetGroupApplicationUnhandledCountReq`.
  factory GetGroupApplicationUnhandledCountReq.fromJson(Map<String, dynamic> json) =>
      _$GetGroupApplicationUnhandledCountReqFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GetGroupApplicationUnhandledCountReqToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [time] 时间戳 / Timestamp.
  /// - Returns: `GetGroupApplicationUnhandledCountReq` 结果 / Resulting `GetGroupApplicationUnhandledCountReq`.
  GetGroupApplicationUnhandledCountReq copyWith({int? time}) {
    return GetGroupApplicationUnhandledCountReq(time: time ?? this.time);
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[time];
}
