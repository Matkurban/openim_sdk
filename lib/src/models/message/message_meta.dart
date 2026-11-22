part of '../message.dart';

/// Group message read information
@JsonSerializable()
class GroupHasReadInfo extends Equatable {
  final int? hasReadCount;
  final int? unreadCount;

  const GroupHasReadInfo({this.hasReadCount, this.unreadCount});

  factory GroupHasReadInfo.fromJson(Map<String, dynamic> json) => _$GroupHasReadInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GroupHasReadInfoToJson(this);

  GroupHasReadInfo copyWith({int? hasReadCount, int? unreadCount}) {
    return GroupHasReadInfo(
      hasReadCount: hasReadCount ?? this.hasReadCount,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => <Object?>[hasReadCount, unreadCount];
}

/// Message read receipt information
@JsonSerializable()
class ReadReceiptInfo extends Equatable {
  final String? userID;
  final String? groupID;
  final List<String>? msgIDList;
  final int? readTime;
  final int? msgFrom;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final MessageType? contentType;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? sessionType;

  const ReadReceiptInfo({
    this.userID,
    this.groupID,
    this.msgIDList,
    this.readTime,
    this.msgFrom,
    this.contentType,
    this.sessionType,
  });

  factory ReadReceiptInfo.fromJson(Map<String, dynamic> json) => _$ReadReceiptInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ReadReceiptInfoToJson(this);

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

/// Offline push information
@JsonSerializable()
class OfflinePushInfo extends Equatable {
  final String? title;
  final String? desc;
  final String? ex;
  final String? iOSPushSound;
  final bool? iOSBadgeCount;

  const OfflinePushInfo({this.title, this.desc, this.ex, this.iOSPushSound, this.iOSBadgeCount});

  factory OfflinePushInfo.fromJson(Map<String, dynamic> json) => _$OfflinePushInfoFromJson(json);

  Map<String, dynamic> toJson() => _$OfflinePushInfoToJson(this);

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

  @override
  List<Object?> get props => <Object?>[title, desc, ex, iOSPushSound, iOSBadgeCount];
}

/// @ message user ID and nickname relationship object
@JsonSerializable()
class AtUserInfo extends Equatable {
  final String? atUserID;
  final String? groupNickname;

  const AtUserInfo({this.atUserID, this.groupNickname});

  factory AtUserInfo.fromJson(Map<String, dynamic> json) => _$AtUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AtUserInfoToJson(this);

  AtUserInfo copyWith({String? atUserID, String? groupNickname}) {
    return AtUserInfo(
      atUserID: atUserID ?? this.atUserID,
      groupNickname: groupNickname ?? this.groupNickname,
    );
  }

  @override
  List<Object?> get props => <Object?>[atUserID, groupNickname];
}

/// Message revocation details
@JsonSerializable()
class RevokedInfo extends Equatable {
  final String? revokerID;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupRoleLevel? revokerRole;

  final String? revokerNickname;
  final String? clientMsgID;
  final int? revokeTime;
  final int? sourceMessageSendTime;
  final String? sourceMessageSendID;
  final String? sourceMessageSenderNickname;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? sessionType;

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

  factory RevokedInfo.fromJson(Map<String, dynamic> json) => _$RevokedInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RevokedInfoToJson(this);

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

@JsonSerializable()
class AdvancedMessage extends Equatable {
  final List<Message>? messageList;
  final bool? isEnd;
  final int? errCode;
  final String? errMsg;
  final int? lastMinSeq;

  const AdvancedMessage({this.messageList, this.isEnd, this.errCode, this.errMsg, this.lastMinSeq});

  factory AdvancedMessage.fromJson(Map<String, dynamic> json) => _$AdvancedMessageFromJson(json);

  Map<String, dynamic> toJson() => _$AdvancedMessageToJson(this);

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

  @override
  List<Object?> get props => <Object?>[messageList, isEnd, errCode, errMsg, lastMinSeq];
}

@JsonSerializable()
class RichMessageInfo extends Equatable {
  final String? type;
  final int? offset;
  final int? length;
  final String? url;
  final String? info;

  const RichMessageInfo({this.type, this.offset, this.length, this.url, this.info});

  factory RichMessageInfo.fromJson(Map<String, dynamic> json) => _$RichMessageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RichMessageInfoToJson(this);

  RichMessageInfo copyWith({String? type, int? offset, int? length, String? url, String? info}) {
    return RichMessageInfo(
      type: type ?? this.type,
      offset: offset ?? this.offset,
      length: length ?? this.length,
      url: url ?? this.url,
      info: info ?? this.info,
    );
  }

  @override
  List<Object?> get props => <Object?>[type, offset, length, url, info];
}

@JsonSerializable()
class UserExInfo extends Equatable {
  final String? userID;
  final String? ex;

  const UserExInfo({this.userID, this.ex});

  factory UserExInfo.fromJson(Map<String, dynamic> json) => _$UserExInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserExInfoToJson(this);

  UserExInfo copyWith({String? userID, String? ex}) {
    return UserExInfo(userID: userID ?? this.userID, ex: ex ?? this.ex);
  }

  @override
  List<Object?> get props => <Object?>[userID, ex];
}
