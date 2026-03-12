import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'group_info.g.dart';

/// Group Information
@JsonSerializable()
class GroupInfo extends Equatable {
  final String groupID;
  final String? groupName;
  final String? notification;
  final String? introduction;
  final String? faceURL;
  final String? ownerUserID;
  final int? createTime;
  final int? memberCount;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupStatus? status;

  final String? creatorUserID;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupType? groupType;

  final String? ex;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupVerification? needVerification;

  final int? lookMemberInfo;
  final int? applyMemberFriend;
  final int? notificationUpdateTime;
  final String? notificationUserID;

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

  factory GroupInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupInfoToJson(this);

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
      notificationUpdateTime:
          notificationUpdateTime ?? this.notificationUpdateTime,
      notificationUserID: notificationUserID ?? this.notificationUserID,
    );
  }

  @override
  List<Object?> get props => [
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

/// Group Member Information
@JsonSerializable()
class GroupMembersInfo extends Equatable {
  final String? groupID;
  final String? userID;
  final String? nickname;
  final String? faceURL;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupRoleLevel? roleLevel;

  final int? joinTime;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final JoinSource? joinSource;

  final String? operatorUserID;
  final String? ex;
  final int? muteEndTime;
  final int? appManagerLevel;
  final String? inviterUserID;

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
    this.appManagerLevel,
    this.inviterUserID,
  });

  factory GroupMembersInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupMembersInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMembersInfoToJson(this);

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
    int? appManagerLevel,
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
      appManagerLevel: appManagerLevel ?? this.appManagerLevel,
      inviterUserID: inviterUserID ?? this.inviterUserID,
    );
  }

  @override
  List<Object?> get props => [
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
    appManagerLevel,
    inviterUserID,
  ];
}

/// Group Member Role
@JsonSerializable()
class GroupMemberRole extends Equatable {
  final String? userID;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupRoleLevel? roleLevel;

  const GroupMemberRole({this.userID, this.roleLevel});

  factory GroupMemberRole.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberRoleFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberRoleToJson(this);

  GroupMemberRole copyWith({String? userID, GroupRoleLevel? roleLevel}) {
    return GroupMemberRole(
      userID: userID ?? this.userID,
      roleLevel: roleLevel ?? this.roleLevel,
    );
  }

  @override
  List<Object?> get props => [userID, roleLevel];
}

/// Group Application Information
@JsonSerializable()
class GroupApplicationInfo extends Equatable {
  final String? groupID;
  final String? groupName;
  final String? notification;
  final String? introduction;
  final String? groupFaceURL;
  final int? createTime;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupStatus? status;

  final String? creatorUserID;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupType? groupType;

  final String? ownerUserID;
  final int? memberCount;
  final String? userID;
  final String? nickname;
  final String? userFaceURL;
  final int? gender;
  final int? handleResult;
  final String? reqMsg;
  final String? handledMsg;
  final int? reqTime;
  final String? handleUserID;
  final int? handledTime;
  final String? ex;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final JoinSource? joinSource;

  final String? inviterUserID;

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

  factory GroupApplicationInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupApplicationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupApplicationInfoToJson(this);

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

  @override
  List<Object?> get props => [
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

/// Group Invitation Result
@JsonSerializable()
class GroupInviteResult extends Equatable {
  final String? userID;
  final int? result;

  const GroupInviteResult({this.userID, this.result});

  factory GroupInviteResult.fromJson(Map<String, dynamic> json) =>
      _$GroupInviteResultFromJson(json);

  Map<String, dynamic> toJson() => _$GroupInviteResultToJson(this);

  GroupInviteResult copyWith({String? userID, int? result}) {
    return GroupInviteResult(
      userID: userID ?? this.userID,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [userID, result];
}

@JsonSerializable()
class GetGroupApplicationListAsRecipientReq extends Equatable {
  final List<String> groupIDs;
  final List<int> handleResults;
  final int offset;
  final int count;

  const GetGroupApplicationListAsRecipientReq({
    this.groupIDs = const [],
    this.handleResults = const [],
    required this.offset,
    required this.count,
  });

  factory GetGroupApplicationListAsRecipientReq.fromJson(
    Map<String, dynamic> json,
  ) => _$GetGroupApplicationListAsRecipientReqFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetGroupApplicationListAsRecipientReqToJson(this);

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

  @override
  List<Object?> get props => [groupIDs, handleResults, offset, count];
}

@JsonSerializable()
class GetGroupApplicationListAsApplicantReq extends Equatable {
  final List<String> groupIDs;
  final List<int> handleResults;
  final int offset;
  final int count;

  const GetGroupApplicationListAsApplicantReq({
    this.groupIDs = const [],
    this.handleResults = const [],
    this.offset = 0,
    this.count = 40,
  });

  factory GetGroupApplicationListAsApplicantReq.fromJson(
    Map<String, dynamic> json,
  ) => _$GetGroupApplicationListAsApplicantReqFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetGroupApplicationListAsApplicantReqToJson(this);

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

  @override
  List<Object?> get props => [groupIDs, handleResults, offset, count];
}

@JsonSerializable()
class GetGroupApplicationUnhandledCountReq extends Equatable {
  final int time;

  const GetGroupApplicationUnhandledCountReq({this.time = 0});

  factory GetGroupApplicationUnhandledCountReq.fromJson(
    Map<String, dynamic> json,
  ) => _$GetGroupApplicationUnhandledCountReqFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetGroupApplicationUnhandledCountReqToJson(this);

  GetGroupApplicationUnhandledCountReq copyWith({int? time}) {
    return GetGroupApplicationUnhandledCountReq(time: time ?? this.time);
  }

  @override
  List<Object?> get props => [time];
}
