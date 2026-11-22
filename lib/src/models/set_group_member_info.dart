import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'set_group_member_info.g.dart';

/// 设置群组成员信息。
///
/// Set group member info.
@JsonSerializable()
class SetGroupMemberInfo extends Equatable {
  /// 群组ID。
  ///
  /// Group ID.
  final String groupID;

  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 角色等级。
  ///
  /// Role level.
  final int? roleLevel;

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

  /// 创建 `SetGroupMemberInfo` 实例。
  ///
  /// Creates a `SetGroupMemberInfo` instance.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - [roleLevel] 角色等级 / Role level.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [ex] 扩展字段 / Extension.
  const SetGroupMemberInfo({
    required this.groupID,
    required this.userID,
    this.roleLevel,
    this.nickname,
    this.faceURL,
    this.ex,
  });

  /// 从 JSON 字典反序列化实例（`SetGroupMemberInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`SetGroupMemberInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `SetGroupMemberInfo` 结果 / Resulting `SetGroupMemberInfo`.
  factory SetGroupMemberInfo.fromJson(Map<String, dynamic> json) =>
      _$SetGroupMemberInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$SetGroupMemberInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [groupID] 群组ID / Group ID.
  /// - [userID] 用户ID / User ID.
  /// - [roleLevel] 角色等级 / Role level.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `SetGroupMemberInfo` 结果 / Resulting `SetGroupMemberInfo`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[groupID, userID, roleLevel, nickname, faceURL, ex];
}
