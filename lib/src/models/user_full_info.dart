import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_full_info.g.dart';

/// Chat 服务端的完整用户信息（对应 chat server 的 /user/find/full 接口返回）
///
/// 相比 [UserInfo]，包含手机号、邮箱、账号等注册信息字段。
@JsonSerializable()
class UserFullInfo extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String userID;

  /// 密码。
  ///
  /// Password.
  @JsonKey(defaultValue: '')
  final String? password;

  /// 账号。
  ///
  /// Account.
  final String? account;

  /// 手机号号码。
  ///
  /// Phone number number.
  @JsonKey(defaultValue: '')
  final String? phoneNumber;

  /// 区号代码。
  ///
  /// Area code.
  @JsonKey(defaultValue: '')
  final String? areaCode;

  /// 昵称。
  ///
  /// Nickname.
  @JsonKey(defaultValue: '')
  final String? nickname;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  @JsonKey(defaultValue: '')
  final String? faceURL;

  /// 性别。
  ///
  /// Gender.
  final int? gender;

  /// 等级。
  ///
  /// Level.
  @JsonKey(defaultValue: 0)
  final int? level;

  /// 生日。
  ///
  /// Birth date.
  final int? birth;

  /// 邮箱。
  ///
  /// Email.
  @JsonKey(defaultValue: '')
  final String? email;

  /// 是否允许添加好友。
  ///
  /// Whether allowed add friend.
  @JsonKey(defaultValue: 0)
  final int? allowAddFriend;

  /// 是否允许Beep。
  ///
  /// Whether allowed beep.
  @JsonKey(defaultValue: 0)
  final int? allowBeep;

  /// 是否允许Vibration。
  ///
  /// Whether allowed vibration.
  @JsonKey(defaultValue: 0)
  final int? allowVibration;

  /// 全局接收消息选项。
  ///
  /// Global receive message option.
  @JsonKey(defaultValue: 0)
  final int? globalRecvMsgOpt;

  /// 注册类型。
  ///
  /// Register type.
  @JsonKey(defaultValue: 0)
  final int? registerType;

  /// 创建 `UserFullInfo` 实例。
  ///
  /// Creates a `UserFullInfo` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [password] 密码 / Password.
  /// - [account] 账号 / Account.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [areaCode] 区号代码 / Area code.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [gender] 性别 / Gender.
  /// - [level] 等级 / Level.
  /// - [birth] 生日 / Birth date.
  /// - [email] 邮箱 / Email.
  /// - [allowAddFriend] 是否允许添加好友 / Whether allowed add friend.
  /// - [allowBeep] 是否允许Beep / Whether allowed beep.
  /// - [allowVibration] 是否允许Vibration / Whether allowed vibration.
  /// - [globalRecvMsgOpt] 全局接收消息选项 / Global receive message option.
  /// - [registerType] 注册类型 / Register type.
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

  /// empty（`UserFullInfo.empty`）。
  ///
  /// Empty (`UserFullInfo.empty`).
  ///
  /// - Returns: `UserFullInfo` 结果 / Resulting `UserFullInfo`.
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

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [password] 密码 / Password.
  /// - [account] 账号 / Account.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [areaCode] 区号代码 / Area code.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [gender] 性别 / Gender.
  /// - [level] 等级 / Level.
  /// - [birth] 生日 / Birth date.
  /// - [email] 邮箱 / Email.
  /// - [allowAddFriend] 是否允许添加好友 / Whether allowed add friend.
  /// - [allowBeep] 是否允许Beep / Whether allowed beep.
  /// - [allowVibration] 是否允许Vibration / Whether allowed vibration.
  /// - [globalRecvMsgOpt] 全局接收消息选项 / Global receive message option.
  /// - [registerType] 注册类型 / Register type.
  /// - Returns: `UserFullInfo` 结果 / Resulting `UserFullInfo`.
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

  /// 从 JSON 字典反序列化实例（`UserFullInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`UserFullInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `UserFullInfo` 结果 / Resulting `UserFullInfo`.
  factory UserFullInfo.fromJson(Map<String, dynamic> json) => _$UserFullInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$UserFullInfoToJson(this);

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
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
