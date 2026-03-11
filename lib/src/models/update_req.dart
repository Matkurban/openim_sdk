import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_req.g.dart';

@JsonSerializable()
class UpdateFriendsReq extends Equatable {
  final String? ownerUserID;
  final List<String>? friendUserIDs;
  final bool? isPinned;
  final String? remark;
  final String? ex;

  const UpdateFriendsReq({
    this.ownerUserID,
    this.friendUserIDs,
    this.isPinned,
    this.remark,
    this.ex,
  });

  factory UpdateFriendsReq.fromJson(Map<String, dynamic> json) => _$UpdateFriendsReqFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFriendsReqToJson(this);

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

  @override
  List<Object?> get props => [ownerUserID, friendUserIDs, isPinned, remark, ex];
}

@JsonSerializable()
class ConversationReq extends Equatable {
  final String? userID;
  final String? groupID;
  final int? recvMsgOpt;
  final bool? isPinned;
  final bool? isPrivateChat;
  final String? ex;
  final int? burnDuration;
  final bool? isMsgDestruct;
  final int? msgDestructTime;
  final int? groupAtType;

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

  factory ConversationReq.fromJson(Map<String, dynamic> json) => _$ConversationReqFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationReqToJson(this);

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

  @override
  List<Object?> get props => [
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
