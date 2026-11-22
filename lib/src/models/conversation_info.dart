import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'conversation_info.g.dart';

/// 会话信息。
///
/// Conversation info.
@JsonSerializable()
class ConversationInfo extends Equatable {
  /// 会话ID。
  ///
  /// Conversation ID.
  final String conversationID;

  /// 会话类型。
  ///
  /// Conversation type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? conversationType;

  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 群组ID。
  ///
  /// Group ID.
  final String? groupID;

  /// 展示名称。
  ///
  /// Display name.
  final String? showName;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String? faceURL;

  /// 接收消息选项。
  ///
  /// Receive message option.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ReceiveMessageOpt? recvMsgOpt;

  /// 未读数量。
  ///
  /// Unread count.
  final int unreadCount;

  /// 最新消息。
  ///
  /// Latest message.
  final Message? latestMsg;

  /// 最新消息发送时间戳。
  ///
  /// Latest message send timestamp.
  final int? latestMsgSendTime;

  /// 草稿文本。
  ///
  /// Draft text.
  final String? draftText;

  /// 草稿文本时间戳。
  ///
  /// Draft text timestamp.
  final int? draftTextTime;

  /// 是否已置顶。
  ///
  /// Whether pinned.
  final bool? isPinned;

  /// 是否阅后即焚聊天。
  ///
  /// Whether private chat.
  final bool? isPrivateChat;

  /// 阅后即焚时长。
  ///
  /// Burn-after-read duration.
  final int? burnDuration;

  /// 是否消息定时销毁。
  ///
  /// Whether message destruct.
  final bool? isMsgDestruct;

  /// 消息定时销毁时间戳。
  ///
  /// Message destruct timestamp.
  final int? msgDestructTime;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 是否不在群组。
  ///
  /// Whether not in group.
  final bool? isNotInGroup;

  /// 群组@提及类型。
  ///
  /// Group @-mention type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GroupAtType? groupAtType;

  /// 创建 `ConversationInfo` 实例。
  ///
  /// Creates a `ConversationInfo` instance.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [conversationType] 会话类型 / Conversation type.
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - [showName] 展示名称 / Display name.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [recvMsgOpt] 接收消息选项 / Receive message option.
  /// - [unreadCount] 未读数量 / Unread count.
  /// - [latestMsg] 最新消息 / Latest message.
  /// - [latestMsgSendTime] 最新消息发送时间戳 / Latest message send timestamp.
  /// - [draftText] 草稿文本 / Draft text.
  /// - [draftTextTime] 草稿文本时间戳 / Draft text timestamp.
  /// - [isPinned] 是否已置顶 / Whether pinned.
  /// - [isPrivateChat] 是否阅后即焚Chat / Whether private chat.
  /// - [burnDuration] 阅后即焚时长 / Burn-after-read duration.
  /// - [isMsgDestruct] 是否消息定时销毁 / Whether message destruct.
  /// - [msgDestructTime] 消息定时销毁时间戳 / Message destruct timestamp.
  /// - [ex] 扩展字段 / Extension.
  /// - [isNotInGroup] 是否不在群组 / Whether not in group.
  /// - [groupAtType] 群组@提及类型 / Group @-mention type.
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

  /// 从 JSON 字典反序列化实例（`ConversationInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`ConversationInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `ConversationInfo` 结果 / Resulting `ConversationInfo`.
  factory ConversationInfo.fromJson(Map<String, dynamic> json) => _$ConversationInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$ConversationInfoToJson(this);

  /// 是否为单聊。
  ///
  /// Whether single chat.
  bool get isSingleChat => conversationType == ConversationType.single;

  /// 是否为群聊。
  ///
  /// Whether group chat.
  bool get isGroupChat => conversationType == ConversationType.superGroup;

  /// 是否为通知会话。
  ///
  /// Whether notification chat.
  bool get isNotificationChat => conversationType == ConversationType.notification;

  /// 当前用户是否在该群中（仅群聊有意义）
  ///
  /// Whether in group.
  bool get isInGroup => isNotInGroup != true;

  /// 是否Valid。
  ///
  /// Whether valid.
  bool get isValid => isSingleChat || (isGroupChat && isInGroup);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [conversationType] 会话类型 / Conversation type.
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - [showName] 展示名称 / Display name.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [recvMsgOpt] 接收消息选项 / Receive message option.
  /// - [unreadCount] 未读数量 / Unread count.
  /// - [latestMsg] 最新消息 / Latest message.
  /// - [latestMsgSendTime] 最新消息发送时间戳 / Latest message send timestamp.
  /// - [draftText] 草稿文本 / Draft text.
  /// - [draftTextTime] 草稿文本时间戳 / Draft text timestamp.
  /// - [isPinned] 是否已置顶 / Whether pinned.
  /// - [isPrivateChat] 是否阅后即焚Chat / Whether private chat.
  /// - [burnDuration] 阅后即焚时长 / Burn-after-read duration.
  /// - [isMsgDestruct] 是否消息定时销毁 / Whether message destruct.
  /// - [msgDestructTime] 消息定时销毁时间戳 / Message destruct timestamp.
  /// - [ex] 扩展字段 / Extension.
  /// - [isNotInGroup] 是否不在群组 / Whether not in group.
  /// - [groupAtType] 群组@提及类型 / Group @-mention type.
  /// - Returns: `ConversationInfo` 结果 / Resulting `ConversationInfo`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
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
