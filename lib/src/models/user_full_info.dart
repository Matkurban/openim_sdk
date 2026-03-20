import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_full_info.g.dart';

/// Chat 服务端的完整用户信息（对应 chat server 的 /user/find/full 接口返回）
///
/// 相比 [UserInfo]，包含手机号、邮箱、账号等注册信息字段。
@JsonSerializable()
class UserFullInfo extends Equatable {
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

  const UserFullInfo({
    this.userID = '',
    this.password = '',
    this.account = '',
    this.phoneNumber = '',
    this.areaCode = '',
    this.nickname = '',
    this.faceURL = '',
    this.gender = 0,
    this.level = 0,
    this.birth = 0,
    this.email = '',
    this.allowAddFriend = 0,
    this.allowBeep = 0,
    this.allowVibration = 0,
    this.globalRecvMsgOpt = 0,
    this.registerType = 0,
  });

  factory UserFullInfo.empty() {
    return const UserFullInfo(
      userID: '',
      password: '',
      account: '',
      phoneNumber: '',
      areaCode: '',
      nickname: '',
      faceURL: '',
      gender: 0,
      level: 0,
      birth: 0,
      email: '',
      allowAddFriend: 0,
      allowBeep: 0,
      allowVibration: 0,
      globalRecvMsgOpt: 0,
      registerType: 0,
    );
  }

  UserFullInfo copyWith({
    String? userID,
    String? password,
    String? account,
    String? phoneNumber,
    String? areaCode,
    String? nickname,
    String? faceURL,
    int? gender,
    int? level,
    int? birth,
    String? email,
    int? allowAddFriend,
    int? allowBeep,
    int? allowVibration,
    int? globalRecvMsgOpt,
    int? registerType,
  }) {
    return UserFullInfo(
      userID: userID ?? this.userID,
      password: password ?? this.password,
      account: account ?? this.account,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      areaCode: areaCode ?? this.areaCode,
      nickname: nickname ?? this.nickname,
      faceURL: faceURL ?? this.faceURL,
      gender: gender ?? this.gender,
      level: level ?? this.level,
      birth: birth ?? this.birth,
      email: email ?? this.email,
      allowAddFriend: allowAddFriend ?? this.allowAddFriend,
      allowBeep: allowBeep ?? this.allowBeep,
      allowVibration: allowVibration ?? this.allowVibration,
      globalRecvMsgOpt: globalRecvMsgOpt ?? this.globalRecvMsgOpt,
      registerType: registerType ?? this.registerType,
    );
  }

  factory UserFullInfo.fromJson(Map<String, dynamic> json) => _$UserFullInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserFullInfoToJson(this);

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
