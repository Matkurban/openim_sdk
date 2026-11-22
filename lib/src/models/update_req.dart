import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_req.g.dart';

/// 更新好友列表请求参数。
///
/// Update friends request.
@JsonSerializable()
class UpdateFriendsReq extends Equatable {
  /// 群主/拥有者用户ID。
  ///
  /// Owner user ID.
  final String? ownerUserID;

  /// 好友用户ID 列表。
  ///
  /// Friend user i ds.
  final List<String>? friendUserIDs;

  /// 是否已置顶。
  ///
  /// Whether pinned.
  final bool? isPinned;

  /// 备注。
  ///
  /// Remark.
  final String? remark;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 创建 `UpdateFriendsReq` 实例。
  ///
  /// Creates a `UpdateFriendsReq` instance.
  ///
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [friendUserIDs] 好友用户ID 列表 / Friend user i ds.
  /// - [isPinned] 是否已置顶 / Whether pinned.
  /// - [remark] 备注 / Remark.
  /// - [ex] 扩展字段 / Extension.
  const UpdateFriendsReq({
    this.ownerUserID,
    this.friendUserIDs,
    this.isPinned,
    this.remark,
    this.ex,
  });

  /// 从 JSON 字典反序列化实例（`UpdateFriendsReq.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`UpdateFriendsReq.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `UpdateFriendsReq` 结果 / Resulting `UpdateFriendsReq`.
  factory UpdateFriendsReq.fromJson(Map<String, dynamic> json) => _$UpdateFriendsReqFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$UpdateFriendsReqToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [friendUserIDs] 好友用户ID 列表 / Friend user i ds.
  /// - [isPinned] 是否已置顶 / Whether pinned.
  /// - [remark] 备注 / Remark.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `UpdateFriendsReq` 结果 / Resulting `UpdateFriendsReq`.
  UpdateFriendsReq copyWith({
    String? ownerUserID,
    List<String>? friendUserIDs,
    bool? isPinned,
    String? remark,
    String? ex,
  }) {
    return UpdateFriendsReq(
      ownerUserID: ownerUserID ?? this.ownerUserID,
      friendUserIDs: friendUserIDs ?? this.friendUserIDs,
      isPinned: isPinned ?? this.isPinned,
      remark: remark ?? this.remark,
      ex: ex ?? this.ex,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[ownerUserID, friendUserIDs, isPinned, remark, ex];
}

/// 会话请求参数。
///
/// Conversation request.
@JsonSerializable()
class ConversationReq extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 群组ID。
  ///
  /// Group ID.
  final String? groupID;

  /// 接收消息选项。
  ///
  /// Receive message option.
  final int? recvMsgOpt;

  /// 是否已置顶。
  ///
  /// Whether pinned.
  final bool? isPinned;

  /// 是否阅后即焚聊天。
  ///
  /// Whether private chat.
  final bool? isPrivateChat;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

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

  /// 群组@提及类型。
  ///
  /// Group @-mention type.
  final int? groupAtType;

  /// 创建 `ConversationReq` 实例。
  ///
  /// Creates a `ConversationReq` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - [recvMsgOpt] 接收消息选项 / Receive message option.
  /// - [isPinned] 是否已置顶 / Whether pinned.
  /// - [isPrivateChat] 是否阅后即焚Chat / Whether private chat.
  /// - [ex] 扩展字段 / Extension.
  /// - [burnDuration] 阅后即焚时长 / Burn-after-read duration.
  /// - [isMsgDestruct] 是否消息定时销毁 / Whether message destruct.
  /// - [msgDestructTime] 消息定时销毁时间戳 / Message destruct timestamp.
  /// - [groupAtType] 群组@提及类型 / Group @-mention type.
  const ConversationReq({
    this.userID,
    this.groupID,
    this.recvMsgOpt,
    this.isPinned,
    this.isPrivateChat,
    this.ex,
    this.burnDuration,
    this.isMsgDestruct,
    this.msgDestructTime,
    this.groupAtType,
  });

  /// 从 JSON 字典反序列化实例（`ConversationReq.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`ConversationReq.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `ConversationReq` 结果 / Resulting `ConversationReq`.
  factory ConversationReq.fromJson(Map<String, dynamic> json) => _$ConversationReqFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$ConversationReqToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - [recvMsgOpt] 接收消息选项 / Receive message option.
  /// - [isPinned] 是否已置顶 / Whether pinned.
  /// - [isPrivateChat] 是否阅后即焚Chat / Whether private chat.
  /// - [ex] 扩展字段 / Extension.
  /// - [burnDuration] 阅后即焚时长 / Burn-after-read duration.
  /// - [isMsgDestruct] 是否消息定时销毁 / Whether message destruct.
  /// - [msgDestructTime] 消息定时销毁时间戳 / Message destruct timestamp.
  /// - [groupAtType] 群组@提及类型 / Group @-mention type.
  /// - Returns: `ConversationReq` 结果 / Resulting `ConversationReq`.
  ConversationReq copyWith({
    String? userID,
    String? groupID,
    int? recvMsgOpt,
    bool? isPinned,
    bool? isPrivateChat,
    String? ex,
    int? burnDuration,
    bool? isMsgDestruct,
    int? msgDestructTime,
    int? groupAtType,
  }) {
    return ConversationReq(
      userID: userID ?? this.userID,
      groupID: groupID ?? this.groupID,
      recvMsgOpt: recvMsgOpt ?? this.recvMsgOpt,
      isPinned: isPinned ?? this.isPinned,
      isPrivateChat: isPrivateChat ?? this.isPrivateChat,
      ex: ex ?? this.ex,
      burnDuration: burnDuration ?? this.burnDuration,
      isMsgDestruct: isMsgDestruct ?? this.isMsgDestruct,
      msgDestructTime: msgDestructTime ?? this.msgDestructTime,
      groupAtType: groupAtType ?? this.groupAtType,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    userID,
    groupID,
    recvMsgOpt,
    isPinned,
    isPrivateChat,
    ex,
    burnDuration,
    isMsgDestruct,
    msgDestructTime,
    groupAtType,
  ];
}
