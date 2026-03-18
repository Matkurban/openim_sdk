import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'full_user_info.g.dart';

/// Chat 服务端的完整用户信息（对应 chat server 的 /user/find/full 接口返回）
///
/// 相比 [UserInfo]，包含手机号、邮箱、账号等注册信息字段。
@JsonSerializable()
class FullUserInfo extends Equatable {
  final String userID;

  @JsonKey(defaultValue: '')
  final String? password;

  final String? account;

  @JsonKey(defaultValue: '')
  final String? phoneNumber;

  @JsonKey(defaultValue: '')
  final String? areaCode;

  @JsonKey(defaultValue: '')
  final String? nickname;

  @JsonKey(defaultValue: '')
  final String? faceURL;

  @JsonKey(defaultValue: -1)
  final int? gender;

  @JsonKey(defaultValue: 0)
  final int? level;

  final int? birth;

  @JsonKey(defaultValue: '')
  final String? email;

  @JsonKey(defaultValue: 0)
  final int? allowAddFriend;

  @JsonKey(defaultValue: 0)
  final int? allowBeep;

  @JsonKey(defaultValue: 0)
  final int? allowVibration;

  @JsonKey(defaultValue: 0)
  final int? globalRecvMsgOpt;

  @JsonKey(defaultValue: 0)
  final int? registerType;

  const FullUserInfo({
    required this.userID,
    this.password,
    this.account,
    this.phoneNumber,
    this.areaCode,
    this.nickname,
    this.faceURL,
    this.gender,
    this.level,
    this.birth,
    this.email,
    this.allowAddFriend,
    this.allowBeep,
    this.allowVibration,
    this.globalRecvMsgOpt,
    this.registerType,
  });

  factory FullUserInfo.fromJson(Map<String, dynamic> json) => _$FullUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FullUserInfoToJson(this);

  @override
  List<Object?> get props => [
        userID,
        password,
        account,
        phoneNumber,
        areaCode,
        nickname,
        faceURL,
        gender,
        level,
        birth,
        email,
        allowAddFriend,
        allowBeep,
        allowVibration,
        globalRecvMsgOpt,
        registerType,
      ];
}
