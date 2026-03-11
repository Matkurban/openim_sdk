import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_group_member_info.g.dart';

@JsonSerializable()
class SetGroupMemberInfo extends Equatable {
  final String groupID;
  final String userID;
  final int? roleLevel;
  final String? nickname;
  final String? faceURL;
  final String? ex;

  const SetGroupMemberInfo({
    required this.groupID,
    required this.userID,
    this.roleLevel,
    this.nickname,
    this.faceURL,
    this.ex,
  });

  factory SetGroupMemberInfo.fromJson(Map<String, dynamic> json) =>
      _$SetGroupMemberInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SetGroupMemberInfoToJson(this);

  SetGroupMemberInfo copyWith({
    String? groupID,
    String? userID,
    int? roleLevel,
    String? nickname,
    String? faceURL,
    String? ex,
  }) {
    return SetGroupMemberInfo(
      groupID: groupID ?? this.groupID,
      userID: userID ?? this.userID,
      roleLevel: roleLevel ?? this.roleLevel,
      nickname: nickname ?? this.nickname,
      faceURL: faceURL ?? this.faceURL,
      ex: ex ?? this.ex,
    );
  }

  @override
  List<Object?> get props => [groupID, userID, roleLevel, nickname, faceURL, ex];
}
