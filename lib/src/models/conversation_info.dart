import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'conversation_info.g.dart';

@JsonSerializable()
class ConversationInfo extends Equatable {
  final String conversationID;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? conversationType;

  final String? userID;
  final String? groupID;
  final String? showName;
  final String? faceURL;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ReceiveMessageOpt? recvMsgOpt;

  final int unreadCount;
  final Message? latestMsg;
  final int? latestMsgSendTime;
  final String? draftText;
  final int? draftTextTime;
  final bool? isPinned;
  final bool? isPrivateChat;
  final int? burnDuration;
  final bool? isMsgDestruct;
  final int? msgDestructTime;
  final String? ex;
  final bool? isNotInGroup;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupAtType? groupAtType;

  const ConversationInfo({
    required this.conversationID,
    this.conversationType,
    this.userID,
    this.groupID,
    this.showName,
    this.faceURL,
    this.recvMsgOpt,
    this.unreadCount = 0,
    this.latestMsg,
    this.latestMsgSendTime,
    this.draftText,
    this.draftTextTime,
    this.isPinned,
    this.isPrivateChat,
    this.burnDuration,
    this.isMsgDestruct,
    this.msgDestructTime,
    this.ex,
    this.isNotInGroup,
    this.groupAtType,
  });

  factory ConversationInfo.fromJson(Map<String, dynamic> json) => _$ConversationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationInfoToJson(this);

  bool get isSingleChat => conversationType == ConversationType.single;

  bool get isGroupChat =>
      conversationType == ConversationType.group || conversationType == ConversationType.superGroup;

  bool get isValid => isSingleChat || (isGroupChat && isNotInGroup != true);

  ConversationInfo copyWith({
    String? conversationID,
    ConversationType? conversationType,
    String? userID,
    String? groupID,
    String? showName,
    String? faceURL,
    ReceiveMessageOpt? recvMsgOpt,
    int? unreadCount,
    Message? latestMsg,
    int? latestMsgSendTime,
    String? draftText,
    int? draftTextTime,
    bool? isPinned,
    bool? isPrivateChat,
    int? burnDuration,
    bool? isMsgDestruct,
    int? msgDestructTime,
    String? ex,
    bool? isNotInGroup,
    GroupAtType? groupAtType,
  }) {
    return ConversationInfo(
      conversationID: conversationID ?? this.conversationID,
      conversationType: conversationType ?? this.conversationType,
      userID: userID ?? this.userID,
      groupID: groupID ?? this.groupID,
      showName: showName ?? this.showName,
      faceURL: faceURL ?? this.faceURL,
      recvMsgOpt: recvMsgOpt ?? this.recvMsgOpt,
      unreadCount: unreadCount ?? this.unreadCount,
      latestMsg: latestMsg ?? this.latestMsg,
      latestMsgSendTime: latestMsgSendTime ?? this.latestMsgSendTime,
      draftText: draftText ?? this.draftText,
      draftTextTime: draftTextTime ?? this.draftTextTime,
      isPinned: isPinned ?? this.isPinned,
      isPrivateChat: isPrivateChat ?? this.isPrivateChat,
      burnDuration: burnDuration ?? this.burnDuration,
      isMsgDestruct: isMsgDestruct ?? this.isMsgDestruct,
      msgDestructTime: msgDestructTime ?? this.msgDestructTime,
      ex: ex ?? this.ex,
      isNotInGroup: isNotInGroup ?? this.isNotInGroup,
      groupAtType: groupAtType ?? this.groupAtType,
    );
  }

  @override
  List<Object?> get props => [
    conversationID,
    conversationType,
    userID,
    groupID,
    showName,
    faceURL,
    recvMsgOpt,
    unreadCount,
    latestMsg,
    latestMsgSendTime,
    draftText,
    draftTextTime,
    isPinned,
    isPrivateChat,
    burnDuration,
    isMsgDestruct,
    msgDestructTime,
    ex,
    isNotInGroup,
    groupAtType,
  ];
}
