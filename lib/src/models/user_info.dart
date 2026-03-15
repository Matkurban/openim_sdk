import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo extends Equatable {
  final String? userID;
  final String? nickname;
  final String? faceURL;
  final String? ex;
  final int? createTime;
  final String? remark;

  /// Global do not disturb setting
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ReceiveMessageOpt? globalRecvMsgOpt;

  final int? appMangerLevel;

  const UserInfo({
    this.userID,
    this.nickname,
    this.faceURL,
    this.ex,
    this.createTime,
    this.remark,
    this.globalRecvMsgOpt,
    this.appMangerLevel,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  String getShowName() => _isNull(remark) ?? _isNull(nickname) ?? userID!;

  static String? _isNull(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  UserInfo copyWith({
    String? userID,
    String? nickname,
    String? faceURL,
    String? ex,
    int? createTime,
    String? remark,
    ReceiveMessageOpt? globalRecvMsgOpt,
    int? appMangerLevel,
  }) {
    return UserInfo(
      userID: userID ?? this.userID,
      nickname: nickname ?? this.nickname,
      faceURL: faceURL ?? this.faceURL,
      ex: ex ?? this.ex,
      createTime: createTime ?? this.createTime,
      remark: remark ?? this.remark,
      globalRecvMsgOpt: globalRecvMsgOpt ?? this.globalRecvMsgOpt,
      appMangerLevel: appMangerLevel ?? this.appMangerLevel,
    );
  }

  @override
  List<Object?> get props => [
    userID,
    nickname,
    faceURL,
    ex,
    createTime,
    remark,
    globalRecvMsgOpt,
    appMangerLevel,
  ];
}

@JsonSerializable()
class PublicUserInfo extends Equatable {
  final String? userID;
  final String? nickname;
  final String? faceURL;
  final int? appManagerLevel;
  final String? ex;

  const PublicUserInfo({this.userID, this.nickname, this.faceURL, this.appManagerLevel, this.ex});

  factory PublicUserInfo.fromJson(Map<String, dynamic> json) => _$PublicUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PublicUserInfoToJson(this);

  PublicUserInfo copyWith({
    String? userID,
    String? nickname,
    String? faceURL,
    int? appManagerLevel,
    String? ex,
  }) {
    return PublicUserInfo(
      userID: userID ?? this.userID,
      nickname: nickname ?? this.nickname,
      faceURL: faceURL ?? this.faceURL,
      appManagerLevel: appManagerLevel ?? this.appManagerLevel,
      ex: ex ?? this.ex,
    );
  }

  @override
  List<Object?> get props => [userID, nickname, faceURL, appManagerLevel, ex];
}

@JsonSerializable()
class FriendInfo extends Equatable {
  final String? ownerUserID;
  final String? userID;
  final String? nickname;
  final String? faceURL;
  final String? friendUserID;
  final String? remark;
  final String? ex;
  final int? createTime;
  final int? addSource;
  final String? operatorUserID;

  const FriendInfo({
    this.ownerUserID,
    this.userID,
    this.nickname,
    this.faceURL,
    this.friendUserID,
    this.remark,
    this.ex,
    this.createTime,
    this.addSource,
    this.operatorUserID,
  });

  factory FriendInfo.fromJson(Map<String, dynamic> json) => _$FriendInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FriendInfoToJson(this);

  String getShowName() => _isNull(remark) ?? _isNull(nickname) ?? userID!;

  static String? _isNull(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  FriendInfo copyWith({
    String? ownerUserID,
    String? userID,
    String? nickname,
    String? faceURL,
    String? friendUserID,
    String? remark,
    String? ex,
    int? createTime,
    int? addSource,
    String? operatorUserID,
  }) {
    return FriendInfo(
      ownerUserID: ownerUserID ?? this.ownerUserID,
      userID: userID ?? this.userID,
      nickname: nickname ?? this.nickname,
      faceURL: faceURL ?? this.faceURL,
      friendUserID: friendUserID ?? this.friendUserID,
      remark: remark ?? this.remark,
      ex: ex ?? this.ex,
      createTime: createTime ?? this.createTime,
      addSource: addSource ?? this.addSource,
      operatorUserID: operatorUserID ?? this.operatorUserID,
    );
  }

  @override
  List<Object?> get props => [
    ownerUserID,
    userID,
    nickname,
    faceURL,
    friendUserID,
    remark,
    ex,
    createTime,
    addSource,
    operatorUserID,
  ];
}

@JsonSerializable()
class BlacklistInfo extends Equatable {
  final String? userID;
  final String? nickname;
  final String? ownerUserID;
  final String? blockUserID;
  final String? faceURL;
  final int? gender;
  final int? createTime;
  final int? addSource;
  final String? operatorUserID;
  final String? ex;

  const BlacklistInfo({
    this.userID,
    this.nickname,
    this.ownerUserID,
    this.blockUserID,
    this.faceURL,
    this.gender,
    this.createTime,
    this.addSource,
    this.operatorUserID,
    this.ex,
  });

  factory BlacklistInfo.fromJson(Map<String, dynamic> json) => _$BlacklistInfoFromJson(json);

  Map<String, dynamic> toJson() => _$BlacklistInfoToJson(this);

  BlacklistInfo copyWith({
    String? userID,
    String? nickname,
    String? ownerUserID,
    String? blockUserID,
    String? faceURL,
    int? gender,
    int? createTime,
    int? addSource,
    String? operatorUserID,
    String? ex,
  }) {
    return BlacklistInfo(
      userID: userID ?? this.userID,
      nickname: nickname ?? this.nickname,
      ownerUserID: ownerUserID ?? this.ownerUserID,
      blockUserID: blockUserID ?? this.blockUserID,
      faceURL: faceURL ?? this.faceURL,
      gender: gender ?? this.gender,
      createTime: createTime ?? this.createTime,
      addSource: addSource ?? this.addSource,
      operatorUserID: operatorUserID ?? this.operatorUserID,
      ex: ex ?? this.ex,
    );
  }

  @override
  List<Object?> get props => [
    userID,
    nickname,
    ownerUserID,
    blockUserID,
    faceURL,
    gender,
    createTime,
    addSource,
    operatorUserID,
    ex,
  ];
}

@JsonSerializable()
class FriendshipInfo extends Equatable {
  final String? userID;
  final int? result;

  const FriendshipInfo({this.userID, this.result});

  factory FriendshipInfo.fromJson(Map<String, dynamic> json) => _$FriendshipInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FriendshipInfoToJson(this);

  FriendshipInfo copyWith({String? userID, int? result}) {
    return FriendshipInfo(userID: userID ?? this.userID, result: result ?? this.result);
  }

  @override
  List<Object?> get props => [userID, result];
}

@JsonSerializable()
class FriendApplicationInfo extends Equatable {
  final String? fromUserID;
  final String? fromNickname;
  final String? fromFaceURL;
  final String? toUserID;
  final String? toNickname;
  final String? toFaceURL;
  final int? handleResult;
  final String? reqMsg;
  final int? createTime;
  final String? handlerUserID;
  final String? handleMsg;
  final int? handleTime;
  final String? ex;

  const FriendApplicationInfo({
    this.fromUserID,
    this.fromNickname,
    this.fromFaceURL,
    this.toUserID,
    this.toNickname,
    this.toFaceURL,
    this.handleResult,
    this.reqMsg,
    this.createTime,
    this.handlerUserID,
    this.handleMsg,
    this.handleTime,
    this.ex,
  });

  factory FriendApplicationInfo.fromJson(Map<String, dynamic> json) =>
      _$FriendApplicationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FriendApplicationInfoToJson(this);

  /// Waiting to be processed
  bool get isWaitingHandle => handleResult == 0;

  /// Already agreed
  bool get isAgreed => handleResult == 1;

  /// Already rejected
  bool get isRejected => handleResult == -1;

  FriendApplicationInfo copyWith({
    String? fromUserID,
    String? fromNickname,
    String? fromFaceURL,
    String? toUserID,
    String? toNickname,
    String? toFaceURL,
    int? handleResult,
    String? reqMsg,
    int? createTime,
    String? handlerUserID,
    String? handleMsg,
    int? handleTime,
    String? ex,
  }) {
    return FriendApplicationInfo(
      fromUserID: fromUserID ?? this.fromUserID,
      fromNickname: fromNickname ?? this.fromNickname,
      fromFaceURL: fromFaceURL ?? this.fromFaceURL,
      toUserID: toUserID ?? this.toUserID,
      toNickname: toNickname ?? this.toNickname,
      toFaceURL: toFaceURL ?? this.toFaceURL,
      handleResult: handleResult ?? this.handleResult,
      reqMsg: reqMsg ?? this.reqMsg,
      createTime: createTime ?? this.createTime,
      handlerUserID: handlerUserID ?? this.handlerUserID,
      handleMsg: handleMsg ?? this.handleMsg,
      handleTime: handleTime ?? this.handleTime,
      ex: ex ?? this.ex,
    );
  }

  @override
  List<Object?> get props => [
    fromUserID,
    fromNickname,
    fromFaceURL,
    toUserID,
    toNickname,
    toFaceURL,
    handleResult,
    reqMsg,
    createTime,
    handlerUserID,
    handleMsg,
    handleTime,
    ex,
  ];
}

@JsonSerializable()
class UserStatusInfo extends Equatable {
  final String? userID;
  final int? status;
  final List<int>? platformIDs;

  const UserStatusInfo({this.userID, this.status, this.platformIDs});

  factory UserStatusInfo.fromJson(Map<String, dynamic> json) => _$UserStatusInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatusInfoToJson(this);

  UserStatusInfo copyWith({String? userID, int? status, List<int>? platformIDs}) {
    return UserStatusInfo(
      userID: userID ?? this.userID,
      status: status ?? this.status,
      platformIDs: platformIDs ?? this.platformIDs,
    );
  }

  @override
  List<Object?> get props => [userID, status, platformIDs];
}

@JsonSerializable()
class GetFriendApplicationListAsRecipientReq extends Equatable {
  final List<int> handleResults;
  final int offset;
  final int count;

  const GetFriendApplicationListAsRecipientReq({
    this.handleResults = const [],
    required this.offset,
    required this.count,
  });

  factory GetFriendApplicationListAsRecipientReq.fromJson(Map<String, dynamic> json) =>
      _$GetFriendApplicationListAsRecipientReqFromJson(json);

  Map<String, dynamic> toJson() => _$GetFriendApplicationListAsRecipientReqToJson(this);

  GetFriendApplicationListAsRecipientReq copyWith({
    List<int>? handleResults,
    int? offset,
    int? count,
  }) {
    return GetFriendApplicationListAsRecipientReq(
      handleResults: handleResults ?? this.handleResults,
      offset: offset ?? this.offset,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [handleResults, offset, count];
}

@JsonSerializable()
class GetFriendApplicationListAsApplicantReq extends Equatable {
  final int offset;
  final int count;

  const GetFriendApplicationListAsApplicantReq({required this.offset, required this.count});

  factory GetFriendApplicationListAsApplicantReq.fromJson(Map<String, dynamic> json) =>
      _$GetFriendApplicationListAsApplicantReqFromJson(json);

  Map<String, dynamic> toJson() => _$GetFriendApplicationListAsApplicantReqToJson(this);

  GetFriendApplicationListAsApplicantReq copyWith({int? offset, int? count}) {
    return GetFriendApplicationListAsApplicantReq(
      offset: offset ?? this.offset,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [offset, count];
}
