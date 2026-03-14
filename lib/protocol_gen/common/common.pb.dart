// This is a generated file - do not edit.
//
// Generated from common/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class UserFullInfo extends $pb.GeneratedMessage {
  factory UserFullInfo({
    $core.String? userID,
    $core.String? password,
    $core.String? account,
    $core.String? phoneNumber,
    $core.String? areaCode,
    $core.String? email,
    $core.String? nickname,
    $core.String? faceURL,
    $core.int? gender,
    $core.int? level,
    $fixnum.Int64? birth,
    $core.int? allowAddFriend,
    $core.int? allowBeep,
    $core.int? allowVibration,
    $core.int? globalRecvMsgOpt,
    $core.int? registerType,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (password != null) result.password = password;
    if (account != null) result.account = account;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (areaCode != null) result.areaCode = areaCode;
    if (email != null) result.email = email;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    if (gender != null) result.gender = gender;
    if (level != null) result.level = level;
    if (birth != null) result.birth = birth;
    if (allowAddFriend != null) result.allowAddFriend = allowAddFriend;
    if (allowBeep != null) result.allowBeep = allowBeep;
    if (allowVibration != null) result.allowVibration = allowVibration;
    if (globalRecvMsgOpt != null) result.globalRecvMsgOpt = globalRecvMsgOpt;
    if (registerType != null) result.registerType = registerType;
    return result;
  }

  UserFullInfo._();

  factory UserFullInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserFullInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserFullInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'account')
    ..aOS(4, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(5, _omitFieldNames ? '' : 'areaCode', protoName: 'areaCode')
    ..aOS(6, _omitFieldNames ? '' : 'email')
    ..aOS(7, _omitFieldNames ? '' : 'nickname')
    ..aOS(8, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aI(9, _omitFieldNames ? '' : 'gender')
    ..aI(10, _omitFieldNames ? '' : 'level')
    ..aInt64(11, _omitFieldNames ? '' : 'birth')
    ..aI(12, _omitFieldNames ? '' : 'allowAddFriend', protoName: 'allowAddFriend')
    ..aI(13, _omitFieldNames ? '' : 'allowBeep', protoName: 'allowBeep')
    ..aI(14, _omitFieldNames ? '' : 'allowVibration', protoName: 'allowVibration')
    ..aI(15, _omitFieldNames ? '' : 'globalRecvMsgOpt', protoName: 'globalRecvMsgOpt')
    ..aI(16, _omitFieldNames ? '' : 'registerType', protoName: 'registerType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserFullInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserFullInfo copyWith(void Function(UserFullInfo) updates) =>
      super.copyWith((message) => updates(message as UserFullInfo)) as UserFullInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserFullInfo create() => UserFullInfo._();
  @$core.override
  UserFullInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserFullInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserFullInfo>(create);
  static UserFullInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get account => $_getSZ(2);
  @$pb.TagNumber(3)
  set account($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAccount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get phoneNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set phoneNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPhoneNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearPhoneNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get areaCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set areaCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAreaCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearAreaCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get email => $_getSZ(5);
  @$pb.TagNumber(6)
  set email($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEmail() => $_has(5);
  @$pb.TagNumber(6)
  void clearEmail() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get nickname => $_getSZ(6);
  @$pb.TagNumber(7)
  set nickname($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNickname() => $_has(6);
  @$pb.TagNumber(7)
  void clearNickname() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get faceURL => $_getSZ(7);
  @$pb.TagNumber(8)
  set faceURL($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFaceURL() => $_has(7);
  @$pb.TagNumber(8)
  void clearFaceURL() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get gender => $_getIZ(8);
  @$pb.TagNumber(9)
  set gender($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasGender() => $_has(8);
  @$pb.TagNumber(9)
  void clearGender() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get level => $_getIZ(9);
  @$pb.TagNumber(10)
  set level($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLevel() => $_has(9);
  @$pb.TagNumber(10)
  void clearLevel() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get birth => $_getI64(10);
  @$pb.TagNumber(11)
  set birth($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBirth() => $_has(10);
  @$pb.TagNumber(11)
  void clearBirth() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get allowAddFriend => $_getIZ(11);
  @$pb.TagNumber(12)
  set allowAddFriend($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAllowAddFriend() => $_has(11);
  @$pb.TagNumber(12)
  void clearAllowAddFriend() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get allowBeep => $_getIZ(12);
  @$pb.TagNumber(13)
  set allowBeep($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAllowBeep() => $_has(12);
  @$pb.TagNumber(13)
  void clearAllowBeep() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get allowVibration => $_getIZ(13);
  @$pb.TagNumber(14)
  set allowVibration($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasAllowVibration() => $_has(13);
  @$pb.TagNumber(14)
  void clearAllowVibration() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get globalRecvMsgOpt => $_getIZ(14);
  @$pb.TagNumber(15)
  set globalRecvMsgOpt($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasGlobalRecvMsgOpt() => $_has(14);
  @$pb.TagNumber(15)
  void clearGlobalRecvMsgOpt() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get registerType => $_getIZ(15);
  @$pb.TagNumber(16)
  set registerType($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRegisterType() => $_has(15);
  @$pb.TagNumber(16)
  void clearRegisterType() => $_clearField(16);
}

class UserPublicInfo extends $pb.GeneratedMessage {
  factory UserPublicInfo({
    $core.String? userID,
    $core.String? account,
    $core.String? email,
    $core.String? nickname,
    $core.String? faceURL,
    $core.int? gender,
    $core.int? level,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (account != null) result.account = account;
    if (email != null) result.email = email;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    if (gender != null) result.gender = gender;
    if (level != null) result.level = level;
    return result;
  }

  UserPublicInfo._();

  factory UserPublicInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserPublicInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserPublicInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'account')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aOS(4, _omitFieldNames ? '' : 'nickname')
    ..aOS(5, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aI(6, _omitFieldNames ? '' : 'gender')
    ..aI(7, _omitFieldNames ? '' : 'level')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPublicInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPublicInfo copyWith(void Function(UserPublicInfo) updates) =>
      super.copyWith((message) => updates(message as UserPublicInfo)) as UserPublicInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserPublicInfo create() => UserPublicInfo._();
  @$core.override
  UserPublicInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserPublicInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserPublicInfo>(create);
  static UserPublicInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get account => $_getSZ(1);
  @$pb.TagNumber(2)
  set account($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nickname => $_getSZ(3);
  @$pb.TagNumber(4)
  set nickname($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNickname() => $_has(3);
  @$pb.TagNumber(4)
  void clearNickname() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get faceURL => $_getSZ(4);
  @$pb.TagNumber(5)
  set faceURL($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFaceURL() => $_has(4);
  @$pb.TagNumber(5)
  void clearFaceURL() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get gender => $_getIZ(5);
  @$pb.TagNumber(6)
  set gender($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGender() => $_has(5);
  @$pb.TagNumber(6)
  void clearGender() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get level => $_getIZ(6);
  @$pb.TagNumber(7)
  set level($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLevel() => $_has(6);
  @$pb.TagNumber(7)
  void clearLevel() => $_clearField(7);
}

class UserIdentity extends $pb.GeneratedMessage {
  factory UserIdentity({
    $core.String? email,
    $core.String? areaCode,
    $core.String? phoneNumber,
    $core.String? deviceID,
    $core.int? platform,
    $core.String? account,
  }) {
    final result = create();
    if (email != null) result.email = email;
    if (areaCode != null) result.areaCode = areaCode;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (deviceID != null) result.deviceID = deviceID;
    if (platform != null) result.platform = platform;
    if (account != null) result.account = account;
    return result;
  }

  UserIdentity._();

  factory UserIdentity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserIdentity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserIdentity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'areaCode', protoName: 'areaCode')
    ..aOS(3, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(4, _omitFieldNames ? '' : 'deviceID', protoName: 'deviceID')
    ..aI(5, _omitFieldNames ? '' : 'platform')
    ..aOS(6, _omitFieldNames ? '' : 'account')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserIdentity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserIdentity copyWith(void Function(UserIdentity) updates) =>
      super.copyWith((message) => updates(message as UserIdentity)) as UserIdentity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserIdentity create() => UserIdentity._();
  @$core.override
  UserIdentity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserIdentity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserIdentity>(create);
  static UserIdentity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get areaCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set areaCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAreaCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearAreaCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get phoneNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set phoneNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhoneNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhoneNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get deviceID => $_getSZ(3);
  @$pb.TagNumber(4)
  set deviceID($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeviceID() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeviceID() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get platform => $_getIZ(4);
  @$pb.TagNumber(5)
  set platform($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPlatform() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlatform() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get account => $_getSZ(5);
  @$pb.TagNumber(6)
  set account($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAccount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAccount() => $_clearField(6);
}

class AppletInfo extends $pb.GeneratedMessage {
  factory AppletInfo({
    $core.String? id,
    $core.String? name,
    $core.String? appID,
    $core.String? icon,
    $core.String? url,
    $core.String? md5,
    $fixnum.Int64? size,
    $core.String? version,
    $core.int? priority,
    $core.int? status,
    $fixnum.Int64? createTime,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (appID != null) result.appID = appID;
    if (icon != null) result.icon = icon;
    if (url != null) result.url = url;
    if (md5 != null) result.md5 = md5;
    if (size != null) result.size = size;
    if (version != null) result.version = version;
    if (priority != null) result.priority = priority;
    if (status != null) result.status = status;
    if (createTime != null) result.createTime = createTime;
    return result;
  }

  AppletInfo._();

  factory AppletInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppletInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AppletInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'appID', protoName: 'appID')
    ..aOS(4, _omitFieldNames ? '' : 'icon')
    ..aOS(5, _omitFieldNames ? '' : 'url')
    ..aOS(6, _omitFieldNames ? '' : 'md5')
    ..aInt64(7, _omitFieldNames ? '' : 'size')
    ..aOS(8, _omitFieldNames ? '' : 'version')
    ..aI(9, _omitFieldNames ? '' : 'priority', fieldType: $pb.PbFieldType.OU3)
    ..aI(10, _omitFieldNames ? '' : 'status', fieldType: $pb.PbFieldType.OU3)
    ..aInt64(11, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppletInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppletInfo copyWith(void Function(AppletInfo) updates) =>
      super.copyWith((message) => updates(message as AppletInfo)) as AppletInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppletInfo create() => AppletInfo._();
  @$core.override
  AppletInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppletInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppletInfo>(create);
  static AppletInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get appID => $_getSZ(2);
  @$pb.TagNumber(3)
  set appID($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppID() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppID() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get icon => $_getSZ(3);
  @$pb.TagNumber(4)
  set icon($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearIcon() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get url => $_getSZ(4);
  @$pb.TagNumber(5)
  set url($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get md5 => $_getSZ(5);
  @$pb.TagNumber(6)
  set md5($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMd5() => $_has(5);
  @$pb.TagNumber(6)
  void clearMd5() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get size => $_getI64(6);
  @$pb.TagNumber(7)
  set size($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearSize() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get version => $_getSZ(7);
  @$pb.TagNumber(8)
  set version($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVersion() => $_has(7);
  @$pb.TagNumber(8)
  void clearVersion() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get priority => $_getIZ(8);
  @$pb.TagNumber(9)
  set priority($core.int value) => $_setUnsignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPriority() => $_has(8);
  @$pb.TagNumber(9)
  void clearPriority() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get status => $_getIZ(9);
  @$pb.TagNumber(10)
  set status($core.int value) => $_setUnsignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get createTime => $_getI64(10);
  @$pb.TagNumber(11)
  set createTime($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCreateTime() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreateTime() => $_clearField(11);
}

class LogInfo extends $pb.GeneratedMessage {
  factory LogInfo({
    $core.String? userID,
    $core.int? platform,
    $core.String? url,
    $fixnum.Int64? createTime,
    $core.String? nickname,
    $core.String? logID,
    $core.String? filename,
    $core.String? systemType,
    $core.String? ex,
    $core.String? version,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (platform != null) result.platform = platform;
    if (url != null) result.url = url;
    if (createTime != null) result.createTime = createTime;
    if (nickname != null) result.nickname = nickname;
    if (logID != null) result.logID = logID;
    if (filename != null) result.filename = filename;
    if (systemType != null) result.systemType = systemType;
    if (ex != null) result.ex = ex;
    if (version != null) result.version = version;
    return result;
  }

  LogInfo._();

  factory LogInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LogInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LogInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat.common'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aI(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..aInt64(4, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aOS(5, _omitFieldNames ? '' : 'nickname')
    ..aOS(6, _omitFieldNames ? '' : 'logID', protoName: 'logID')
    ..aOS(7, _omitFieldNames ? '' : 'filename')
    ..aOS(8, _omitFieldNames ? '' : 'systemType', protoName: 'systemType')
    ..aOS(9, _omitFieldNames ? '' : 'ex')
    ..aOS(10, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LogInfo copyWith(void Function(LogInfo) updates) =>
      super.copyWith((message) => updates(message as LogInfo)) as LogInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LogInfo create() => LogInfo._();
  @$core.override
  LogInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LogInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LogInfo>(create);
  static LogInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get platform => $_getIZ(1);
  @$pb.TagNumber(2)
  set platform($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get createTime => $_getI64(3);
  @$pb.TagNumber(4)
  set createTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreateTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreateTime() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get nickname => $_getSZ(4);
  @$pb.TagNumber(5)
  set nickname($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNickname() => $_has(4);
  @$pb.TagNumber(5)
  void clearNickname() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get logID => $_getSZ(5);
  @$pb.TagNumber(6)
  set logID($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLogID() => $_has(5);
  @$pb.TagNumber(6)
  void clearLogID() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get filename => $_getSZ(6);
  @$pb.TagNumber(7)
  set filename($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFilename() => $_has(6);
  @$pb.TagNumber(7)
  void clearFilename() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get systemType => $_getSZ(7);
  @$pb.TagNumber(8)
  set systemType($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSystemType() => $_has(7);
  @$pb.TagNumber(8)
  void clearSystemType() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get ex => $_getSZ(8);
  @$pb.TagNumber(9)
  set ex($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEx() => $_has(8);
  @$pb.TagNumber(9)
  void clearEx() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get version => $_getSZ(9);
  @$pb.TagNumber(10)
  set version($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
