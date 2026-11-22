import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'user_info.g.dart';

/// 用户信息。
///
/// User info.
@JsonSerializable()
class UserInfo extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 昵称。
  ///
  /// Nickname.
  final String? nickname;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String? faceURL;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  final int? createTime;

  /// 备注。
  ///
  /// Remark.
  final String? remark;

  /// 全局接收消息选项。
  ///
  /// Global do not disturb setting
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ReceiveMessageOpt? globalRecvMsgOpt;

  /// appManger等级。
  ///
  /// App manger level.
  final int? appMangerLevel;

  /// 创建 `UserInfo` 实例。
  ///
  /// Creates a `UserInfo` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [ex] 扩展字段 / Extension.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [remark] 备注 / Remark.
  /// - [globalRecvMsgOpt] 全局接收消息选项 / Global receive message option.
  /// - [appMangerLevel] appManger等级 / App manger level.
  const UserInfo({
    required this.userID,
    this.nickname,
    this.faceURL,
    this.ex,
    this.createTime,
    this.remark,
    this.globalRecvMsgOpt,
    this.appMangerLevel,
  });

  /// 从 JSON 字典反序列化实例（`UserInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`UserInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `UserInfo` 结果 / Resulting `UserInfo`.
  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  /// 获取展示名称。
  ///
  /// Get display name.
  ///
  /// - Returns: 字符串结果 / String result.
  String getShowName() => _nonBlank(remark) ?? _nonBlank(nickname) ?? userID;

  static String? _nonBlank(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [ex] 扩展字段 / Extension.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [remark] 备注 / Remark.
  /// - [globalRecvMsgOpt] 全局接收消息选项 / Global receive message option.
  /// - [appMangerLevel] appManger等级 / App manger level.
  /// - Returns: `UserInfo` 结果 / Resulting `UserInfo`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
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

/// Public用户信息。
///
/// Public user info.
@JsonSerializable()
class PublicUserInfo extends Equatable {
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

  /// app管理器等级。
  ///
  /// App manager level.
  final int? appManagerLevel;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 创建 `PublicUserInfo` 实例。
  ///
  /// Creates a `PublicUserInfo` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [appManagerLevel] app管理器等级 / App manager level.
  /// - [ex] 扩展字段 / Extension.
  const PublicUserInfo({this.userID, this.nickname, this.faceURL, this.appManagerLevel, this.ex});

  /// 从 JSON 字典反序列化实例（`PublicUserInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`PublicUserInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `PublicUserInfo` 结果 / Resulting `PublicUserInfo`.
  factory PublicUserInfo.fromJson(Map<String, dynamic> json) => _$PublicUserInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$PublicUserInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [appManagerLevel] app管理器等级 / App manager level.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `PublicUserInfo` 结果 / Resulting `PublicUserInfo`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[userID, nickname, faceURL, appManagerLevel, ex];
}

/// 好友信息。
///
/// Friend info.
@JsonSerializable()
class FriendInfo extends Equatable {
  /// 群主/拥有者用户ID。
  ///
  /// Owner user ID.
  final String? ownerUserID;

  /// 昵称。
  ///
  /// Nickname.
  final String? nickname;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String? faceURL;

  /// 好友用户ID。
  ///
  /// Friend user ID.
  final String? friendUserID;

  /// 备注。
  ///
  /// Remark.
  final String? remark;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  final int? createTime;

  /// 添加来源。
  ///
  /// Add source.
  final int? addSource;

  /// 操作者用户ID。
  ///
  /// Operator user ID.
  final String? operatorUserID;

  /// 创建 `FriendInfo` 实例。
  ///
  /// Creates a `FriendInfo` instance.
  ///
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [friendUserID] 好友用户ID / Friend user ID.
  /// - [remark] 备注 / Remark.
  /// - [ex] 扩展字段 / Extension.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [addSource] 添加来源 / Add source.
  /// - [operatorUserID] 操作者用户ID / Operator user ID.
  const FriendInfo({
    this.ownerUserID,
    this.nickname,
    this.faceURL,
    this.friendUserID,
    this.remark,
    this.ex,
    this.createTime,
    this.addSource,
    this.operatorUserID,
  });

  /// 从 JSON 字典反序列化实例（`FriendInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`FriendInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `FriendInfo` 结果 / Resulting `FriendInfo`.
  factory FriendInfo.fromJson(Map<String, dynamic> json) => _$FriendInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$FriendInfoToJson(this);

  /// 获取展示名称。
  ///
  /// Get display name.
  ///
  /// - Returns: 字符串结果 / String result.
  String getShowName() => _nonBlank(remark) ?? _nonBlank(nickname) ?? (friendUserID ?? '');

  static String? _nonBlank(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [friendUserID] 好友用户ID / Friend user ID.
  /// - [remark] 备注 / Remark.
  /// - [ex] 扩展字段 / Extension.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [addSource] 添加来源 / Add source.
  /// - [operatorUserID] 操作者用户ID / Operator user ID.
  /// - Returns: `FriendInfo` 结果 / Resulting `FriendInfo`.
  FriendInfo copyWith({
    String? ownerUserID,
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    ownerUserID,
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

/// 黑名单信息。
///
/// Blacklist info.
@JsonSerializable()
class BlacklistInfo extends Equatable {
  /// 昵称。
  ///
  /// Nickname.
  final String? nickname;

  /// 群主/拥有者用户ID。
  ///
  /// Owner user ID.
  final String? ownerUserID;

  /// block用户ID。
  ///
  /// Block user ID.
  final String? blockUserID;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String? faceURL;

  /// 性别。
  ///
  /// Gender.
  final int? gender;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  final int? createTime;

  /// 添加来源。
  ///
  /// Add source.
  final int? addSource;

  /// 操作者用户ID。
  ///
  /// Operator user ID.
  final String? operatorUserID;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 创建 `BlacklistInfo` 实例。
  ///
  /// Creates a `BlacklistInfo` instance.
  ///
  /// - [nickname] 昵称 / Nickname.
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [blockUserID] block用户ID / Block user ID.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [gender] 性别 / Gender.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [addSource] 添加来源 / Add source.
  /// - [operatorUserID] 操作者用户ID / Operator user ID.
  /// - [ex] 扩展字段 / Extension.
  const BlacklistInfo({
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

  /// 从 JSON 字典反序列化实例（`BlacklistInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`BlacklistInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `BlacklistInfo` 结果 / Resulting `BlacklistInfo`.
  factory BlacklistInfo.fromJson(Map<String, dynamic> json) => _$BlacklistInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$BlacklistInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [blockUserID] block用户ID / Block user ID.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [gender] 性别 / Gender.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [addSource] 添加来源 / Add source.
  /// - [operatorUserID] 操作者用户ID / Operator user ID.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `BlacklistInfo` 结果 / Resulting `BlacklistInfo`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
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

/// 好友关系信息。
///
/// Friendship info.
@JsonSerializable()
class FriendshipInfo extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 结果。
  ///
  /// Result.
  final int? result;

  /// 创建 `FriendshipInfo` 实例。
  ///
  /// Creates a `FriendshipInfo` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [result] 结果 / Result.
  const FriendshipInfo({this.userID, this.result});

  /// 从 JSON 字典反序列化实例（`FriendshipInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`FriendshipInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `FriendshipInfo` 结果 / Resulting `FriendshipInfo`.
  factory FriendshipInfo.fromJson(Map<String, dynamic> json) => _$FriendshipInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$FriendshipInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [result] 结果 / Result.
  /// - Returns: `FriendshipInfo` 结果 / Resulting `FriendshipInfo`.
  FriendshipInfo copyWith({String? userID, int? result}) {
    return FriendshipInfo(userID: userID ?? this.userID, result: result ?? this.result);
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[userID, result];
}

/// 好友申请信息。
///
/// Friend application info.
@JsonSerializable()
class FriendApplicationInfo extends Equatable {
  /// 从用户ID。
  ///
  /// From user ID.
  final String? fromUserID;

  /// 从昵称。
  ///
  /// From nickname.
  final String? fromNickname;

  /// 从头像URL 地址。
  ///
  /// From avatar URL.
  final String? fromFaceURL;

  /// 转为用户ID。
  ///
  /// To user ID.
  final String? toUserID;

  /// 转为昵称。
  ///
  /// To nickname.
  final String? toNickname;

  /// 转为头像URL 地址。
  ///
  /// To avatar URL.
  final String? toFaceURL;

  /// 处理结果。
  ///
  /// Handle result.
  final int? handleResult;

  /// 请求参数消息。
  ///
  /// Request message.
  final String? reqMsg;

  /// 创建时间戳。
  ///
  /// Create timestamp.
  final int? createTime;

  /// 处理器用户ID。
  ///
  /// Handler user ID.
  final String? handlerUserID;

  /// 处理消息。
  ///
  /// Handle message.
  final String? handleMsg;

  /// 处理时间戳。
  ///
  /// Handle timestamp.
  final int? handleTime;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 创建 `FriendApplicationInfo` 实例。
  ///
  /// Creates a `FriendApplicationInfo` instance.
  ///
  /// - [fromUserID] 从用户ID / From user ID.
  /// - [fromNickname] 从昵称 / From nickname.
  /// - [fromFaceURL] 从头像URL 地址 / From avatar URL.
  /// - [toUserID] 转为用户ID / To user ID.
  /// - [toNickname] 转为昵称 / To nickname.
  /// - [toFaceURL] 转为头像URL 地址 / To avatar URL.
  /// - [handleResult] 处理结果 / Handle result.
  /// - [reqMsg] 请求参数消息 / Request message.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [handlerUserID] 处理器用户ID / Handler user ID.
  /// - [handleMsg] 处理消息 / Handle message.
  /// - [handleTime] 处理时间戳 / Handle timestamp.
  /// - [ex] 扩展字段 / Extension.
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

  /// 从 JSON 字典反序列化实例（`FriendApplicationInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`FriendApplicationInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `FriendApplicationInfo` 结果 / Resulting `FriendApplicationInfo`.
  factory FriendApplicationInfo.fromJson(Map<String, dynamic> json) =>
      _$FriendApplicationInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$FriendApplicationInfoToJson(this);

  /// 是否Waiting处理。
  ///
  /// Waiting to be processed
  bool get isWaitingHandle => handleResult == 0;

  /// 是否Agreed。
  ///
  /// Already agreed
  bool get isAgreed => handleResult == 1;

  /// 是否已拒绝。
  ///
  /// Already rejected
  bool get isRejected => handleResult == -1;

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [fromUserID] 从用户ID / From user ID.
  /// - [fromNickname] 从昵称 / From nickname.
  /// - [fromFaceURL] 从头像URL 地址 / From avatar URL.
  /// - [toUserID] 转为用户ID / To user ID.
  /// - [toNickname] 转为昵称 / To nickname.
  /// - [toFaceURL] 转为头像URL 地址 / To avatar URL.
  /// - [handleResult] 处理结果 / Handle result.
  /// - [reqMsg] 请求参数消息 / Request message.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [handlerUserID] 处理器用户ID / Handler user ID.
  /// - [handleMsg] 处理消息 / Handle message.
  /// - [handleTime] 处理时间戳 / Handle timestamp.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `FriendApplicationInfo` 结果 / Resulting `FriendApplicationInfo`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
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

/// 用户状态信息。
///
/// User status info.
@JsonSerializable()
class UserStatusInfo extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 状态。
  ///
  /// Status.
  final int? status;

  /// 平台ID 列表。
  ///
  /// Platform i ds.
  final List<int>? platformIDs;

  /// 创建 `UserStatusInfo` 实例。
  ///
  /// Creates a `UserStatusInfo` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [status] 状态 / Status.
  /// - [platformIDs] 平台ID 列表 / Platform i ds.
  const UserStatusInfo({this.userID, this.status, this.platformIDs});

  /// 从 JSON 字典反序列化实例（`UserStatusInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`UserStatusInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `UserStatusInfo` 结果 / Resulting `UserStatusInfo`.
  factory UserStatusInfo.fromJson(Map<String, dynamic> json) => _$UserStatusInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$UserStatusInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [status] 状态 / Status.
  /// - [platformIDs] 平台ID 列表 / Platform i ds.
  /// - Returns: `UserStatusInfo` 结果 / Resulting `UserStatusInfo`.
  UserStatusInfo copyWith({String? userID, int? status, List<int>? platformIDs}) {
    return UserStatusInfo(
      userID: userID ?? this.userID,
      status: status ?? this.status,
      platformIDs: platformIDs ?? this.platformIDs,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[userID, status, platformIDs];
}

/// 获取好友申请列表作为接收方请求参数。
///
/// Get friend application list as recipient request.
@JsonSerializable()
class GetFriendApplicationListAsRecipientReq extends Equatable {
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

  /// 创建 `GetFriendApplicationListAsRecipientReq` 实例。
  ///
  /// Creates a `GetFriendApplicationListAsRecipientReq` instance.
  ///
  /// - [handleResults] 处理Results / Handle results.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  const GetFriendApplicationListAsRecipientReq({
    this.handleResults = const <int>[],
    required this.offset,
    required this.count,
  });

  /// 从 JSON 字典反序列化实例（`GetFriendApplicationListAsRecipientReq.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GetFriendApplicationListAsRecipientReq.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GetFriendApplicationListAsRecipientReq` 结果 / Resulting `GetFriendApplicationListAsRecipientReq`.
  factory GetFriendApplicationListAsRecipientReq.fromJson(Map<String, dynamic> json) =>
      _$GetFriendApplicationListAsRecipientReqFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GetFriendApplicationListAsRecipientReqToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [handleResults] 处理Results / Handle results.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `GetFriendApplicationListAsRecipientReq` 结果 / Resulting `GetFriendApplicationListAsRecipientReq`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[handleResults, offset, count];
}

/// 获取好友申请列表作为申请方请求参数。
///
/// Get friend application list as applicant request.
@JsonSerializable()
class GetFriendApplicationListAsApplicantReq extends Equatable {
  /// 偏移量。
  ///
  /// Offset.
  final int offset;

  /// 数量。
  ///
  /// Count.
  final int count;

  /// 创建 `GetFriendApplicationListAsApplicantReq` 实例。
  ///
  /// Creates a `GetFriendApplicationListAsApplicantReq` instance.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  const GetFriendApplicationListAsApplicantReq({required this.offset, required this.count});

  /// 从 JSON 字典反序列化实例（`GetFriendApplicationListAsApplicantReq.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GetFriendApplicationListAsApplicantReq.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GetFriendApplicationListAsApplicantReq` 结果 / Resulting `GetFriendApplicationListAsApplicantReq`.
  factory GetFriendApplicationListAsApplicantReq.fromJson(Map<String, dynamic> json) =>
      _$GetFriendApplicationListAsApplicantReqFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GetFriendApplicationListAsApplicantReqToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `GetFriendApplicationListAsApplicantReq` 结果 / Resulting `GetFriendApplicationListAsApplicantReq`.
  GetFriendApplicationListAsApplicantReq copyWith({int? offset, int? count}) {
    return GetFriendApplicationListAsApplicantReq(
      offset: offset ?? this.offset,
      count: count ?? this.count,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[offset, count];
}
