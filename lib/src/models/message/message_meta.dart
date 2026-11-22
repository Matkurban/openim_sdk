part of '../message.dart';

/// 群组是否包含读取信息。
///
/// Group message read information
@JsonSerializable()
class GroupHasReadInfo extends Equatable {
  /// 是否包含读取数量。
  ///
  /// Whether has read count.
  final int? hasReadCount;

  /// 未读数量。
  ///
  /// Unread count.
  final int? unreadCount;

  /// 创建 `GroupHasReadInfo` 实例。
  ///
  /// Creates a `GroupHasReadInfo` instance.
  ///
  /// - [hasReadCount] 是否包含读取数量 / Whether has read count.
  /// - [unreadCount] 未读数量 / Unread count.
  const GroupHasReadInfo({this.hasReadCount, this.unreadCount});

  /// 从 JSON 字典反序列化实例（`GroupHasReadInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`GroupHasReadInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `GroupHasReadInfo` 结果 / Resulting `GroupHasReadInfo`.
  factory GroupHasReadInfo.fromJson(Map<String, dynamic> json) => _$GroupHasReadInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$GroupHasReadInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [hasReadCount] 是否包含读取数量 / Whether has read count.
  /// - [unreadCount] 未读数量 / Unread count.
  /// - Returns: `GroupHasReadInfo` 结果 / Resulting `GroupHasReadInfo`.
  GroupHasReadInfo copyWith({int? hasReadCount, int? unreadCount}) {
    return GroupHasReadInfo(
      hasReadCount: hasReadCount ?? this.hasReadCount,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[hasReadCount, unreadCount];
}

/// 读取Receipt信息。
///
/// Message read receipt information
@JsonSerializable()
class ReadReceiptInfo extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 群组ID。
  ///
  /// Group ID.
  final String? groupID;

  /// 消息ID列表。
  ///
  /// Message ID list.
  final List<String>? msgIDList;

  /// 读取时间戳。
  ///
  /// Read timestamp.
  final int? readTime;

  /// 消息从。
  ///
  /// Message from.
  final int? msgFrom;

  /// 内容类型。
  ///
  /// Content type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final MessageType? contentType;

  /// 会话类型。
  ///
  /// Session type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? sessionType;

  /// 创建 `ReadReceiptInfo` 实例。
  ///
  /// Creates a `ReadReceiptInfo` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - [msgIDList] 消息ID列表 / Message ID list.
  /// - [readTime] 读取时间戳 / Read timestamp.
  /// - [msgFrom] 消息从 / Message from.
  /// - [contentType] 内容类型 / Content type.
  /// - [sessionType] 会话类型 / Session type.
  const ReadReceiptInfo({
    this.userID,
    this.groupID,
    this.msgIDList,
    this.readTime,
    this.msgFrom,
    this.contentType,
    this.sessionType,
  });

  /// 从 JSON 字典反序列化实例（`ReadReceiptInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`ReadReceiptInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `ReadReceiptInfo` 结果 / Resulting `ReadReceiptInfo`.
  factory ReadReceiptInfo.fromJson(Map<String, dynamic> json) => _$ReadReceiptInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$ReadReceiptInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - [msgIDList] 消息ID列表 / Message ID list.
  /// - [readTime] 读取时间戳 / Read timestamp.
  /// - [msgFrom] 消息从 / Message from.
  /// - [contentType] 内容类型 / Content type.
  /// - [sessionType] 会话类型 / Session type.
  /// - Returns: `ReadReceiptInfo` 结果 / Resulting `ReadReceiptInfo`.
  ReadReceiptInfo copyWith({
    String? userID,
    String? groupID,
    List<String>? msgIDList,
    int? readTime,
    int? msgFrom,
    MessageType? contentType,
    ConversationType? sessionType,
  }) {
    return ReadReceiptInfo(
      userID: userID ?? this.userID,
      groupID: groupID ?? this.groupID,
      msgIDList: msgIDList ?? this.msgIDList,
      readTime: readTime ?? this.readTime,
      msgFrom: msgFrom ?? this.msgFrom,
      contentType: contentType ?? this.contentType,
      sessionType: sessionType ?? this.sessionType,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    userID,
    groupID,
    msgIDList,
    readTime,
    msgFrom,
    contentType,
    sessionType,
  ];
}

/// 离线推送信息。
///
/// Offline push information
@JsonSerializable()
class OfflinePushInfo extends Equatable {
  /// 标题。
  ///
  /// Title.
  final String? title;

  /// 描述。
  ///
  /// Description.
  final String? desc;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// iOS推送语音。
  ///
  /// I os push voice audio.
  final String? iOSPushSound;

  /// iOS角标数量。
  ///
  /// I os badge count.
  final bool? iOSBadgeCount;

  /// 创建 `OfflinePushInfo` 实例。
  ///
  /// Creates a `OfflinePushInfo` instance.
  ///
  /// - [title] 标题 / Title.
  /// - [desc] 描述 / Description.
  /// - [ex] 扩展字段 / Extension.
  /// - [iOSPushSound] iOS推送语音 / I os push voice audio.
  /// - [iOSBadgeCount] iOS角标数量 / I os badge count.
  const OfflinePushInfo({this.title, this.desc, this.ex, this.iOSPushSound, this.iOSBadgeCount});

  /// 从 JSON 字典反序列化实例（`OfflinePushInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`OfflinePushInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `OfflinePushInfo` 结果 / Resulting `OfflinePushInfo`.
  factory OfflinePushInfo.fromJson(Map<String, dynamic> json) => _$OfflinePushInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$OfflinePushInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [title] 标题 / Title.
  /// - [desc] 描述 / Description.
  /// - [ex] 扩展字段 / Extension.
  /// - [iOSPushSound] iOS推送语音 / I os push voice audio.
  /// - [iOSBadgeCount] iOS角标数量 / I os badge count.
  /// - Returns: `OfflinePushInfo` 结果 / Resulting `OfflinePushInfo`.
  OfflinePushInfo copyWith({
    String? title,
    String? desc,
    String? ex,
    String? iOSPushSound,
    bool? iOSBadgeCount,
  }) {
    return OfflinePushInfo(
      title: title ?? this.title,
      desc: desc ?? this.desc,
      ex: ex ?? this.ex,
      iOSPushSound: iOSPushSound ?? this.iOSPushSound,
      iOSBadgeCount: iOSBadgeCount ?? this.iOSBadgeCount,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[title, desc, ex, iOSPushSound, iOSBadgeCount];
}

/// @提及用户信息。
///
/// @ message user ID and nickname relationship object
@JsonSerializable()
class AtUserInfo extends Equatable {
  /// @提及用户ID。
  ///
  /// @-mention user ID.
  final String? atUserID;

  /// 群组昵称。
  ///
  /// Group nickname.
  final String? groupNickname;

  /// 创建 `AtUserInfo` 实例。
  ///
  /// Creates a `AtUserInfo` instance.
  ///
  /// - [atUserID] @提及用户ID / @-mention user ID.
  /// - [groupNickname] 群组昵称 / Group nickname.
  const AtUserInfo({this.atUserID, this.groupNickname});

  /// 从 JSON 字典反序列化实例（`AtUserInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`AtUserInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `AtUserInfo` 结果 / Resulting `AtUserInfo`.
  factory AtUserInfo.fromJson(Map<String, dynamic> json) => _$AtUserInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$AtUserInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [atUserID] @提及用户ID / @-mention user ID.
  /// - [groupNickname] 群组昵称 / Group nickname.
  /// - Returns: `AtUserInfo` 结果 / Resulting `AtUserInfo`.
  AtUserInfo copyWith({String? atUserID, String? groupNickname}) {
    return AtUserInfo(
      atUserID: atUserID ?? this.atUserID,
      groupNickname: groupNickname ?? this.groupNickname,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[atUserID, groupNickname];
}

/// 已撤回信息。
///
/// Message revocation details
@JsonSerializable()
class RevokedInfo extends Equatable {
  /// revokerID。
  ///
  /// Revoker ID.
  final String? revokerID;

  /// revoker角色。
  ///
  /// Revoker role.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupRoleLevel? revokerRole;

  /// revoker昵称。
  ///
  /// Revoker nickname.
  final String? revokerNickname;

  /// 客户端消息ID。
  ///
  /// Client message ID.
  final String? clientMsgID;

  /// 撤回时间戳。
  ///
  /// Revoke timestamp.
  final int? revokeTime;

  /// 来源消息发送时间戳。
  ///
  /// Source message send timestamp.
  final int? sourceMessageSendTime;

  /// 来源消息发送ID。
  ///
  /// Source message send ID.
  final String? sourceMessageSendID;

  /// 来源消息发送器昵称。
  ///
  /// Source message sender nickname.
  final String? sourceMessageSenderNickname;

  /// 会话类型。
  ///
  /// Session type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? sessionType;

  /// 创建 `RevokedInfo` 实例。
  ///
  /// Creates a `RevokedInfo` instance.
  ///
  /// - [revokerID] revokerID / Revoker ID.
  /// - [revokerRole] revoker角色 / Revoker role.
  /// - [revokerNickname] revoker昵称 / Revoker nickname.
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - [revokeTime] 撤回时间戳 / Revoke timestamp.
  /// - [sourceMessageSendTime] 来源消息发送时间戳 / Source message send timestamp.
  /// - [sourceMessageSendID] 来源消息发送ID / Source message send ID.
  /// - [sourceMessageSenderNickname] 来源消息发送器昵称 / Source message sender nickname.
  /// - [sessionType] 会话类型 / Session type.
  const RevokedInfo({
    this.revokerID,
    this.revokerRole,
    this.revokerNickname,
    this.clientMsgID,
    this.revokeTime,
    this.sourceMessageSendTime,
    this.sourceMessageSendID,
    this.sourceMessageSenderNickname,
    this.sessionType,
  });

  /// 从 JSON 字典反序列化实例（`RevokedInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`RevokedInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `RevokedInfo` 结果 / Resulting `RevokedInfo`.
  factory RevokedInfo.fromJson(Map<String, dynamic> json) => _$RevokedInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$RevokedInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [revokerID] revokerID / Revoker ID.
  /// - [revokerRole] revoker角色 / Revoker role.
  /// - [revokerNickname] revoker昵称 / Revoker nickname.
  /// - [clientMsgID] 客户端消息ID / Client message ID.
  /// - [revokeTime] 撤回时间戳 / Revoke timestamp.
  /// - [sourceMessageSendTime] 来源消息发送时间戳 / Source message send timestamp.
  /// - [sourceMessageSendID] 来源消息发送ID / Source message send ID.
  /// - [sourceMessageSenderNickname] 来源消息发送器昵称 / Source message sender nickname.
  /// - [sessionType] 会话类型 / Session type.
  /// - Returns: `RevokedInfo` 结果 / Resulting `RevokedInfo`.
  RevokedInfo copyWith({
    String? revokerID,
    GroupRoleLevel? revokerRole,
    String? revokerNickname,
    String? clientMsgID,
    int? revokeTime,
    int? sourceMessageSendTime,
    String? sourceMessageSendID,
    String? sourceMessageSenderNickname,
    ConversationType? sessionType,
  }) {
    return RevokedInfo(
      revokerID: revokerID ?? this.revokerID,
      revokerRole: revokerRole ?? this.revokerRole,
      revokerNickname: revokerNickname ?? this.revokerNickname,
      clientMsgID: clientMsgID ?? this.clientMsgID,
      revokeTime: revokeTime ?? this.revokeTime,
      sourceMessageSendTime: sourceMessageSendTime ?? this.sourceMessageSendTime,
      sourceMessageSendID: sourceMessageSendID ?? this.sourceMessageSendID,
      sourceMessageSenderNickname: sourceMessageSenderNickname ?? this.sourceMessageSenderNickname,
      sessionType: sessionType ?? this.sessionType,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    revokerID,
    revokerRole,
    revokerNickname,
    clientMsgID,
    revokeTime,
    sourceMessageSendTime,
    sourceMessageSendID,
    sourceMessageSenderNickname,
    sessionType,
  ];
}

/// 高级消息。
///
/// Advanced message.
@JsonSerializable()
class AdvancedMessage extends Equatable {
  /// 消息列表。
  ///
  /// Message list.
  final List<Message>? messageList;

  /// 是否结束。
  ///
  /// Whether end.
  final bool? isEnd;

  /// 错误代码。
  ///
  /// Error code.
  final int? errCode;

  /// 错误消息。
  ///
  /// Error message.
  final String? errMsg;

  /// last最小序列号。
  ///
  /// Last minimum sequence number.
  final int? lastMinSeq;

  /// 创建 `AdvancedMessage` 实例。
  ///
  /// Creates a `AdvancedMessage` instance.
  ///
  /// - [messageList] 消息列表 / Message list.
  /// - [isEnd] 是否结束 / Whether end.
  /// - [errCode] 错误代码 / Error code.
  /// - [errMsg] 错误消息 / Error message.
  /// - [lastMinSeq] last最小序列号 / Last minimum sequence number.
  const AdvancedMessage({this.messageList, this.isEnd, this.errCode, this.errMsg, this.lastMinSeq});

  /// 从 JSON 字典反序列化实例（`AdvancedMessage.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`AdvancedMessage.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `AdvancedMessage` 结果 / Resulting `AdvancedMessage`.
  factory AdvancedMessage.fromJson(Map<String, dynamic> json) => _$AdvancedMessageFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$AdvancedMessageToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [messageList] 消息列表 / Message list.
  /// - [isEnd] 是否结束 / Whether end.
  /// - [errCode] 错误代码 / Error code.
  /// - [errMsg] 错误消息 / Error message.
  /// - [lastMinSeq] last最小序列号 / Last minimum sequence number.
  /// - Returns: `AdvancedMessage` 结果 / Resulting `AdvancedMessage`.
  AdvancedMessage copyWith({
    List<Message>? messageList,
    bool? isEnd,
    int? errCode,
    String? errMsg,
    int? lastMinSeq,
  }) {
    return AdvancedMessage(
      messageList: messageList ?? this.messageList,
      isEnd: isEnd ?? this.isEnd,
      errCode: errCode ?? this.errCode,
      errMsg: errMsg ?? this.errMsg,
      lastMinSeq: lastMinSeq ?? this.lastMinSeq,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[messageList, isEnd, errCode, errMsg, lastMinSeq];
}

/// 富文本消息信息。
///
/// Rich-text message info.
@JsonSerializable()
class RichMessageInfo extends Equatable {
  /// 类型。
  ///
  /// Type.
  final String? type;

  /// 偏移量。
  ///
  /// Offset.
  final int? offset;

  /// length。
  ///
  /// Length.
  final int? length;

  /// URL 地址。
  ///
  /// URL.
  final String? url;

  /// 信息。
  ///
  /// Info.
  final String? info;

  /// 创建 `RichMessageInfo` 实例。
  ///
  /// Creates a `RichMessageInfo` instance.
  ///
  /// - [type] 类型 / Type.
  /// - [offset] 偏移量 / Offset.
  /// - [length] length / Length.
  /// - [url] URL 地址 / URL.
  /// - [info] 信息 / Info.
  const RichMessageInfo({this.type, this.offset, this.length, this.url, this.info});

  /// 从 JSON 字典反序列化实例（`RichMessageInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`RichMessageInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `RichMessageInfo` 结果 / Resulting `RichMessageInfo`.
  factory RichMessageInfo.fromJson(Map<String, dynamic> json) => _$RichMessageInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$RichMessageInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [type] 类型 / Type.
  /// - [offset] 偏移量 / Offset.
  /// - [length] length / Length.
  /// - [url] URL 地址 / URL.
  /// - [info] 信息 / Info.
  /// - Returns: `RichMessageInfo` 结果 / Resulting `RichMessageInfo`.
  RichMessageInfo copyWith({String? type, int? offset, int? length, String? url, String? info}) {
    return RichMessageInfo(
      type: type ?? this.type,
      offset: offset ?? this.offset,
      length: length ?? this.length,
      url: url ?? this.url,
      info: info ?? this.info,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[type, offset, length, url, info];
}

/// 用户扩展字段信息。
///
/// User extension info.
@JsonSerializable()
class UserExInfo extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 创建 `UserExInfo` 实例。
  ///
  /// Creates a `UserExInfo` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [ex] 扩展字段 / Extension.
  const UserExInfo({this.userID, this.ex});

  /// 从 JSON 字典反序列化实例（`UserExInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`UserExInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `UserExInfo` 结果 / Resulting `UserExInfo`.
  factory UserExInfo.fromJson(Map<String, dynamic> json) => _$UserExInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$UserExInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `UserExInfo` 结果 / Resulting `UserExInfo`.
  UserExInfo copyWith({String? userID, String? ex}) {
    return UserExInfo(userID: userID ?? this.userID, ex: ex ?? this.ex);
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[userID, ex];
}
