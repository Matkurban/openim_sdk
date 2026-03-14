// This is a generated file - do not edit.
//
// Generated from chat/chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../common/common.pb.dart' as $1;
import '../sdkws/sdkws.pb.dart' as $2;
import '../wrapperspb/wrapperspb.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

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
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
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

class UpdateUserInfoReq extends $pb.GeneratedMessage {
  factory UpdateUserInfoReq({
    $core.String? userID,
    $0.StringValue? account,
    $0.StringValue? phoneNumber,
    $0.StringValue? areaCode,
    $0.StringValue? email,
    $0.StringValue? nickname,
    $0.StringValue? faceURL,
    $0.Int32Value? gender,
    $0.Int32Value? level,
    $0.Int64Value? birth,
    $0.Int32Value? allowAddFriend,
    $0.Int32Value? allowBeep,
    $0.Int32Value? allowVibration,
    $0.Int32Value? globalRecvMsgOpt,
    $0.Int32Value? registerType,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
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

  UpdateUserInfoReq._();

  factory UpdateUserInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateUserInfoReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOM<$0.StringValue>(2, _omitFieldNames ? '' : 'account', subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(3, _omitFieldNames ? '' : 'phoneNumber',
        protoName: 'phoneNumber', subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(4, _omitFieldNames ? '' : 'areaCode',
        protoName: 'areaCode', subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(5, _omitFieldNames ? '' : 'email', subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(6, _omitFieldNames ? '' : 'nickname', subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(7, _omitFieldNames ? '' : 'faceURL',
        protoName: 'faceURL', subBuilder: $0.StringValue.create)
    ..aOM<$0.Int32Value>(8, _omitFieldNames ? '' : 'gender', subBuilder: $0.Int32Value.create)
    ..aOM<$0.Int32Value>(9, _omitFieldNames ? '' : 'level', subBuilder: $0.Int32Value.create)
    ..aOM<$0.Int64Value>(10, _omitFieldNames ? '' : 'birth', subBuilder: $0.Int64Value.create)
    ..aOM<$0.Int32Value>(11, _omitFieldNames ? '' : 'allowAddFriend',
        protoName: 'allowAddFriend', subBuilder: $0.Int32Value.create)
    ..aOM<$0.Int32Value>(12, _omitFieldNames ? '' : 'allowBeep',
        protoName: 'allowBeep', subBuilder: $0.Int32Value.create)
    ..aOM<$0.Int32Value>(13, _omitFieldNames ? '' : 'allowVibration',
        protoName: 'allowVibration', subBuilder: $0.Int32Value.create)
    ..aOM<$0.Int32Value>(14, _omitFieldNames ? '' : 'globalRecvMsgOpt',
        protoName: 'globalRecvMsgOpt', subBuilder: $0.Int32Value.create)
    ..aOM<$0.Int32Value>(15, _omitFieldNames ? '' : 'RegisterType',
        protoName: 'RegisterType', subBuilder: $0.Int32Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserInfoReq copyWith(void Function(UpdateUserInfoReq) updates) =>
      super.copyWith((message) => updates(message as UpdateUserInfoReq)) as UpdateUserInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserInfoReq create() => UpdateUserInfoReq._();
  @$core.override
  UpdateUserInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserInfoReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateUserInfoReq>(create);
  static UpdateUserInfoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.StringValue get account => $_getN(1);
  @$pb.TagNumber(2)
  set account($0.StringValue value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAccount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccount() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.StringValue ensureAccount() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.StringValue get phoneNumber => $_getN(2);
  @$pb.TagNumber(3)
  set phoneNumber($0.StringValue value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPhoneNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhoneNumber() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.StringValue ensurePhoneNumber() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.StringValue get areaCode => $_getN(3);
  @$pb.TagNumber(4)
  set areaCode($0.StringValue value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAreaCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearAreaCode() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.StringValue ensureAreaCode() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.StringValue get email => $_getN(4);
  @$pb.TagNumber(5)
  set email($0.StringValue value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearEmail() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.StringValue ensureEmail() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.StringValue get nickname => $_getN(5);
  @$pb.TagNumber(6)
  set nickname($0.StringValue value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasNickname() => $_has(5);
  @$pb.TagNumber(6)
  void clearNickname() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.StringValue ensureNickname() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.StringValue get faceURL => $_getN(6);
  @$pb.TagNumber(7)
  set faceURL($0.StringValue value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFaceURL() => $_has(6);
  @$pb.TagNumber(7)
  void clearFaceURL() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.StringValue ensureFaceURL() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Int32Value get gender => $_getN(7);
  @$pb.TagNumber(8)
  set gender($0.Int32Value value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasGender() => $_has(7);
  @$pb.TagNumber(8)
  void clearGender() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Int32Value ensureGender() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Int32Value get level => $_getN(8);
  @$pb.TagNumber(9)
  set level($0.Int32Value value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasLevel() => $_has(8);
  @$pb.TagNumber(9)
  void clearLevel() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Int32Value ensureLevel() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Int64Value get birth => $_getN(9);
  @$pb.TagNumber(10)
  set birth($0.Int64Value value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasBirth() => $_has(9);
  @$pb.TagNumber(10)
  void clearBirth() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Int64Value ensureBirth() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Int32Value get allowAddFriend => $_getN(10);
  @$pb.TagNumber(11)
  set allowAddFriend($0.Int32Value value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasAllowAddFriend() => $_has(10);
  @$pb.TagNumber(11)
  void clearAllowAddFriend() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Int32Value ensureAllowAddFriend() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Int32Value get allowBeep => $_getN(11);
  @$pb.TagNumber(12)
  set allowBeep($0.Int32Value value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAllowBeep() => $_has(11);
  @$pb.TagNumber(12)
  void clearAllowBeep() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Int32Value ensureAllowBeep() => $_ensure(11);

  @$pb.TagNumber(13)
  $0.Int32Value get allowVibration => $_getN(12);
  @$pb.TagNumber(13)
  set allowVibration($0.Int32Value value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasAllowVibration() => $_has(12);
  @$pb.TagNumber(13)
  void clearAllowVibration() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Int32Value ensureAllowVibration() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Int32Value get globalRecvMsgOpt => $_getN(13);
  @$pb.TagNumber(14)
  set globalRecvMsgOpt($0.Int32Value value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasGlobalRecvMsgOpt() => $_has(13);
  @$pb.TagNumber(14)
  void clearGlobalRecvMsgOpt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Int32Value ensureGlobalRecvMsgOpt() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Int32Value get registerType => $_getN(14);
  @$pb.TagNumber(15)
  set registerType($0.Int32Value value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasRegisterType() => $_has(14);
  @$pb.TagNumber(15)
  void clearRegisterType() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Int32Value ensureRegisterType() => $_ensure(14);
}

class UpdateUserInfoResp extends $pb.GeneratedMessage {
  factory UpdateUserInfoResp({
    $core.String? faceUrl,
    $core.String? nickName,
  }) {
    final result = create();
    if (faceUrl != null) result.faceUrl = faceUrl;
    if (nickName != null) result.nickName = nickName;
    return result;
  }

  UpdateUserInfoResp._();

  factory UpdateUserInfoResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserInfoResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateUserInfoResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'faceUrl', protoName: 'faceUrl')
    ..aOS(2, _omitFieldNames ? '' : 'nickName', protoName: 'nickName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserInfoResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserInfoResp copyWith(void Function(UpdateUserInfoResp) updates) =>
      super.copyWith((message) => updates(message as UpdateUserInfoResp)) as UpdateUserInfoResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserInfoResp create() => UpdateUserInfoResp._();
  @$core.override
  UpdateUserInfoResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserInfoResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateUserInfoResp>(create);
  static UpdateUserInfoResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get faceUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set faceUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFaceUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearFaceUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nickName => $_getSZ(1);
  @$pb.TagNumber(2)
  set nickName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNickName() => $_has(1);
  @$pb.TagNumber(2)
  void clearNickName() => $_clearField(2);
}

class FindUserPublicInfoReq extends $pb.GeneratedMessage {
  factory FindUserPublicInfoReq({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  FindUserPublicInfoReq._();

  factory FindUserPublicInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindUserPublicInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindUserPublicInfoReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserPublicInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserPublicInfoReq copyWith(void Function(FindUserPublicInfoReq) updates) =>
      super.copyWith((message) => updates(message as FindUserPublicInfoReq))
          as FindUserPublicInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindUserPublicInfoReq create() => FindUserPublicInfoReq._();
  @$core.override
  FindUserPublicInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindUserPublicInfoReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FindUserPublicInfoReq>(create);
  static FindUserPublicInfoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class FindUserPublicInfoResp extends $pb.GeneratedMessage {
  factory FindUserPublicInfoResp({
    $core.Iterable<$1.UserPublicInfo>? users,
  }) {
    final result = create();
    if (users != null) result.users.addAll(users);
    return result;
  }

  FindUserPublicInfoResp._();

  factory FindUserPublicInfoResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindUserPublicInfoResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindUserPublicInfoResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..pPM<$1.UserPublicInfo>(1, _omitFieldNames ? '' : 'users',
        subBuilder: $1.UserPublicInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserPublicInfoResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserPublicInfoResp copyWith(void Function(FindUserPublicInfoResp) updates) =>
      super.copyWith((message) => updates(message as FindUserPublicInfoResp))
          as FindUserPublicInfoResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindUserPublicInfoResp create() => FindUserPublicInfoResp._();
  @$core.override
  FindUserPublicInfoResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindUserPublicInfoResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FindUserPublicInfoResp>(create);
  static FindUserPublicInfoResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.UserPublicInfo> get users => $_getList(0);
}

class SearchUserPublicInfoReq extends $pb.GeneratedMessage {
  factory SearchUserPublicInfoReq({
    $core.String? keyword,
    $2.RequestPagination? pagination,
    $core.int? genders,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (pagination != null) result.pagination = pagination;
    if (genders != null) result.genders = genders;
    return result;
  }

  SearchUserPublicInfoReq._();

  factory SearchUserPublicInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchUserPublicInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchUserPublicInfoReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aOM<$2.RequestPagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.RequestPagination.create)
    ..aI(3, _omitFieldNames ? '' : 'genders')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserPublicInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserPublicInfoReq copyWith(void Function(SearchUserPublicInfoReq) updates) =>
      super.copyWith((message) => updates(message as SearchUserPublicInfoReq))
          as SearchUserPublicInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchUserPublicInfoReq create() => SearchUserPublicInfoReq._();
  @$core.override
  SearchUserPublicInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchUserPublicInfoReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchUserPublicInfoReq>(create);
  static SearchUserPublicInfoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.RequestPagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.RequestPagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.RequestPagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get genders => $_getIZ(2);
  @$pb.TagNumber(3)
  set genders($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGenders() => $_has(2);
  @$pb.TagNumber(3)
  void clearGenders() => $_clearField(3);
}

class SearchUserPublicInfoResp extends $pb.GeneratedMessage {
  factory SearchUserPublicInfoResp({
    $core.int? total,
    $core.Iterable<$1.UserPublicInfo>? users,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (users != null) result.users.addAll(users);
    return result;
  }

  SearchUserPublicInfoResp._();

  factory SearchUserPublicInfoResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchUserPublicInfoResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchUserPublicInfoResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPM<$1.UserPublicInfo>(2, _omitFieldNames ? '' : 'users',
        subBuilder: $1.UserPublicInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserPublicInfoResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserPublicInfoResp copyWith(void Function(SearchUserPublicInfoResp) updates) =>
      super.copyWith((message) => updates(message as SearchUserPublicInfoResp))
          as SearchUserPublicInfoResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchUserPublicInfoResp create() => SearchUserPublicInfoResp._();
  @$core.override
  SearchUserPublicInfoResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchUserPublicInfoResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchUserPublicInfoResp>(create);
  static SearchUserPublicInfoResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$1.UserPublicInfo> get users => $_getList(1);
}

class FindUserFullInfoReq extends $pb.GeneratedMessage {
  factory FindUserFullInfoReq({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  FindUserFullInfoReq._();

  factory FindUserFullInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindUserFullInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FindUserFullInfoReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserFullInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserFullInfoReq copyWith(void Function(FindUserFullInfoReq) updates) =>
      super.copyWith((message) => updates(message as FindUserFullInfoReq)) as FindUserFullInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindUserFullInfoReq create() => FindUserFullInfoReq._();
  @$core.override
  FindUserFullInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindUserFullInfoReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FindUserFullInfoReq>(create);
  static FindUserFullInfoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class FindUserFullInfoResp extends $pb.GeneratedMessage {
  factory FindUserFullInfoResp({
    $core.Iterable<$1.UserFullInfo>? users,
  }) {
    final result = create();
    if (users != null) result.users.addAll(users);
    return result;
  }

  FindUserFullInfoResp._();

  factory FindUserFullInfoResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindUserFullInfoResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FindUserFullInfoResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..pPM<$1.UserFullInfo>(1, _omitFieldNames ? '' : 'users', subBuilder: $1.UserFullInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserFullInfoResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserFullInfoResp copyWith(void Function(FindUserFullInfoResp) updates) =>
      super.copyWith((message) => updates(message as FindUserFullInfoResp)) as FindUserFullInfoResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindUserFullInfoResp create() => FindUserFullInfoResp._();
  @$core.override
  FindUserFullInfoResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindUserFullInfoResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FindUserFullInfoResp>(create);
  static FindUserFullInfoResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.UserFullInfo> get users => $_getList(0);
}

class SendVerifyCodeReq extends $pb.GeneratedMessage {
  factory SendVerifyCodeReq({
    $core.int? usedFor,
    $core.String? ip,
    $core.String? invitationCode,
    $core.String? deviceID,
    $core.int? platform,
    $core.String? areaCode,
    $core.String? phoneNumber,
    $core.String? email,
  }) {
    final result = create();
    if (usedFor != null) result.usedFor = usedFor;
    if (ip != null) result.ip = ip;
    if (invitationCode != null) result.invitationCode = invitationCode;
    if (deviceID != null) result.deviceID = deviceID;
    if (platform != null) result.platform = platform;
    if (areaCode != null) result.areaCode = areaCode;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (email != null) result.email = email;
    return result;
  }

  SendVerifyCodeReq._();

  factory SendVerifyCodeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendVerifyCodeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SendVerifyCodeReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'usedFor', protoName: 'usedFor')
    ..aOS(2, _omitFieldNames ? '' : 'ip')
    ..aOS(3, _omitFieldNames ? '' : 'invitationCode', protoName: 'invitationCode')
    ..aOS(4, _omitFieldNames ? '' : 'deviceID', protoName: 'deviceID')
    ..aI(5, _omitFieldNames ? '' : 'platform')
    ..aOS(6, _omitFieldNames ? '' : 'areaCode', protoName: 'areaCode')
    ..aOS(7, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(8, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerifyCodeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerifyCodeReq copyWith(void Function(SendVerifyCodeReq) updates) =>
      super.copyWith((message) => updates(message as SendVerifyCodeReq)) as SendVerifyCodeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendVerifyCodeReq create() => SendVerifyCodeReq._();
  @$core.override
  SendVerifyCodeReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendVerifyCodeReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendVerifyCodeReq>(create);
  static SendVerifyCodeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get usedFor => $_getIZ(0);
  @$pb.TagNumber(1)
  set usedFor($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsedFor() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsedFor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ip => $_getSZ(1);
  @$pb.TagNumber(2)
  set ip($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIp() => $_has(1);
  @$pb.TagNumber(2)
  void clearIp() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get invitationCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set invitationCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInvitationCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearInvitationCode() => $_clearField(3);

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
  $core.String get areaCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set areaCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAreaCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearAreaCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get phoneNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set phoneNumber($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPhoneNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearPhoneNumber() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get email => $_getSZ(7);
  @$pb.TagNumber(8)
  set email($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEmail() => $_has(7);
  @$pb.TagNumber(8)
  void clearEmail() => $_clearField(8);
}

class SendVerifyCodeResp extends $pb.GeneratedMessage {
  factory SendVerifyCodeResp() => create();

  SendVerifyCodeResp._();

  factory SendVerifyCodeResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendVerifyCodeResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SendVerifyCodeResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerifyCodeResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerifyCodeResp copyWith(void Function(SendVerifyCodeResp) updates) =>
      super.copyWith((message) => updates(message as SendVerifyCodeResp)) as SendVerifyCodeResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendVerifyCodeResp create() => SendVerifyCodeResp._();
  @$core.override
  SendVerifyCodeResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendVerifyCodeResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendVerifyCodeResp>(create);
  static SendVerifyCodeResp? _defaultInstance;
}

class VerifyCodeReq extends $pb.GeneratedMessage {
  factory VerifyCodeReq({
    $core.String? areaCode,
    $core.String? phoneNumber,
    $core.String? verifyCode,
    $core.String? email,
  }) {
    final result = create();
    if (areaCode != null) result.areaCode = areaCode;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (verifyCode != null) result.verifyCode = verifyCode;
    if (email != null) result.email = email;
    return result;
  }

  VerifyCodeReq._();

  factory VerifyCodeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyCodeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerifyCodeReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'areaCode', protoName: 'areaCode')
    ..aOS(2, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(3, _omitFieldNames ? '' : 'verifyCode', protoName: 'verifyCode')
    ..aOS(4, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCodeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCodeReq copyWith(void Function(VerifyCodeReq) updates) =>
      super.copyWith((message) => updates(message as VerifyCodeReq)) as VerifyCodeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyCodeReq create() => VerifyCodeReq._();
  @$core.override
  VerifyCodeReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyCodeReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerifyCodeReq>(create);
  static VerifyCodeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get areaCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set areaCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAreaCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearAreaCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phoneNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set phoneNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhoneNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhoneNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get verifyCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set verifyCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVerifyCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerifyCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get email => $_getSZ(3);
  @$pb.TagNumber(4)
  set email($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEmail() => $_has(3);
  @$pb.TagNumber(4)
  void clearEmail() => $_clearField(4);
}

class VerifyCodeResp extends $pb.GeneratedMessage {
  factory VerifyCodeResp() => create();

  VerifyCodeResp._();

  factory VerifyCodeResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyCodeResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerifyCodeResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCodeResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCodeResp copyWith(void Function(VerifyCodeResp) updates) =>
      super.copyWith((message) => updates(message as VerifyCodeResp)) as VerifyCodeResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyCodeResp create() => VerifyCodeResp._();
  @$core.override
  VerifyCodeResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyCodeResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerifyCodeResp>(create);
  static VerifyCodeResp? _defaultInstance;
}

class RegisterUserInfo extends $pb.GeneratedMessage {
  factory RegisterUserInfo({
    $core.String? userID,
    $core.String? nickname,
    $core.String? faceURL,
    $fixnum.Int64? birth,
    $core.int? gender,
    $core.String? areaCode,
    $core.String? phoneNumber,
    $core.String? email,
    $core.String? account,
    $core.String? password,
    $core.int? registerType,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    if (birth != null) result.birth = birth;
    if (gender != null) result.gender = gender;
    if (areaCode != null) result.areaCode = areaCode;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (email != null) result.email = email;
    if (account != null) result.account = account;
    if (password != null) result.password = password;
    if (registerType != null) result.registerType = registerType;
    return result;
  }

  RegisterUserInfo._();

  factory RegisterUserInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterUserInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterUserInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'nickname')
    ..aOS(3, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aInt64(4, _omitFieldNames ? '' : 'birth')
    ..aI(5, _omitFieldNames ? '' : 'gender')
    ..aOS(6, _omitFieldNames ? '' : 'areaCode', protoName: 'areaCode')
    ..aOS(7, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(8, _omitFieldNames ? '' : 'email')
    ..aOS(9, _omitFieldNames ? '' : 'account')
    ..aOS(10, _omitFieldNames ? '' : 'password')
    ..aI(11, _omitFieldNames ? '' : 'RegisterType', protoName: 'RegisterType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUserInfo copyWith(void Function(RegisterUserInfo) updates) =>
      super.copyWith((message) => updates(message as RegisterUserInfo)) as RegisterUserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterUserInfo create() => RegisterUserInfo._();
  @$core.override
  RegisterUserInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterUserInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterUserInfo>(create);
  static RegisterUserInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nickname => $_getSZ(1);
  @$pb.TagNumber(2)
  set nickname($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNickname() => $_has(1);
  @$pb.TagNumber(2)
  void clearNickname() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get faceURL => $_getSZ(2);
  @$pb.TagNumber(3)
  set faceURL($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFaceURL() => $_has(2);
  @$pb.TagNumber(3)
  void clearFaceURL() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get birth => $_getI64(3);
  @$pb.TagNumber(4)
  set birth($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBirth() => $_has(3);
  @$pb.TagNumber(4)
  void clearBirth() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get gender => $_getIZ(4);
  @$pb.TagNumber(5)
  set gender($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGender() => $_has(4);
  @$pb.TagNumber(5)
  void clearGender() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get areaCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set areaCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAreaCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearAreaCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get phoneNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set phoneNumber($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPhoneNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearPhoneNumber() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get email => $_getSZ(7);
  @$pb.TagNumber(8)
  set email($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEmail() => $_has(7);
  @$pb.TagNumber(8)
  void clearEmail() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get account => $_getSZ(8);
  @$pb.TagNumber(9)
  set account($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAccount() => $_has(8);
  @$pb.TagNumber(9)
  void clearAccount() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get password => $_getSZ(9);
  @$pb.TagNumber(10)
  set password($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPassword() => $_has(9);
  @$pb.TagNumber(10)
  void clearPassword() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get registerType => $_getIZ(10);
  @$pb.TagNumber(11)
  set registerType($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRegisterType() => $_has(10);
  @$pb.TagNumber(11)
  void clearRegisterType() => $_clearField(11);
}

class RegisterUserReq extends $pb.GeneratedMessage {
  factory RegisterUserReq({
    $core.String? invitationCode,
    $core.String? verifyCode,
    $core.String? ip,
    $core.String? deviceID,
    $core.int? platform,
    $core.bool? autoLogin,
    RegisterUserInfo? user,
  }) {
    final result = create();
    if (invitationCode != null) result.invitationCode = invitationCode;
    if (verifyCode != null) result.verifyCode = verifyCode;
    if (ip != null) result.ip = ip;
    if (deviceID != null) result.deviceID = deviceID;
    if (platform != null) result.platform = platform;
    if (autoLogin != null) result.autoLogin = autoLogin;
    if (user != null) result.user = user;
    return result;
  }

  RegisterUserReq._();

  factory RegisterUserReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterUserReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterUserReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'invitationCode', protoName: 'invitationCode')
    ..aOS(2, _omitFieldNames ? '' : 'verifyCode', protoName: 'verifyCode')
    ..aOS(3, _omitFieldNames ? '' : 'ip')
    ..aOS(4, _omitFieldNames ? '' : 'deviceID', protoName: 'deviceID')
    ..aI(5, _omitFieldNames ? '' : 'platform')
    ..aOB(6, _omitFieldNames ? '' : 'autoLogin', protoName: 'autoLogin')
    ..aOM<RegisterUserInfo>(7, _omitFieldNames ? '' : 'user', subBuilder: RegisterUserInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUserReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUserReq copyWith(void Function(RegisterUserReq) updates) =>
      super.copyWith((message) => updates(message as RegisterUserReq)) as RegisterUserReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterUserReq create() => RegisterUserReq._();
  @$core.override
  RegisterUserReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterUserReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterUserReq>(create);
  static RegisterUserReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get invitationCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set invitationCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInvitationCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvitationCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get verifyCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set verifyCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVerifyCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearVerifyCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ip => $_getSZ(2);
  @$pb.TagNumber(3)
  set ip($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIp() => $_has(2);
  @$pb.TagNumber(3)
  void clearIp() => $_clearField(3);

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
  $core.bool get autoLogin => $_getBF(5);
  @$pb.TagNumber(6)
  set autoLogin($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAutoLogin() => $_has(5);
  @$pb.TagNumber(6)
  void clearAutoLogin() => $_clearField(6);

  @$pb.TagNumber(7)
  RegisterUserInfo get user => $_getN(6);
  @$pb.TagNumber(7)
  set user(RegisterUserInfo value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUser() => $_has(6);
  @$pb.TagNumber(7)
  void clearUser() => $_clearField(7);
  @$pb.TagNumber(7)
  RegisterUserInfo ensureUser() => $_ensure(6);
}

class RegisterUserResp extends $pb.GeneratedMessage {
  factory RegisterUserResp({
    $core.String? userID,
    $core.String? chatToken,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (chatToken != null) result.chatToken = chatToken;
    return result;
  }

  RegisterUserResp._();

  factory RegisterUserResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterUserResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegisterUserResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(3, _omitFieldNames ? '' : 'chatToken', protoName: 'chatToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUserResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterUserResp copyWith(void Function(RegisterUserResp) updates) =>
      super.copyWith((message) => updates(message as RegisterUserResp)) as RegisterUserResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterUserResp create() => RegisterUserResp._();
  @$core.override
  RegisterUserResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterUserResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterUserResp>(create);
  static RegisterUserResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(3)
  $core.String get chatToken => $_getSZ(1);
  @$pb.TagNumber(3)
  set chatToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasChatToken() => $_has(1);
  @$pb.TagNumber(3)
  void clearChatToken() => $_clearField(3);
}

class AddUserAccountReq extends $pb.GeneratedMessage {
  factory AddUserAccountReq({
    $core.String? ip,
    $core.String? deviceID,
    $core.int? platform,
    RegisterUserInfo? user,
  }) {
    final result = create();
    if (ip != null) result.ip = ip;
    if (deviceID != null) result.deviceID = deviceID;
    if (platform != null) result.platform = platform;
    if (user != null) result.user = user;
    return result;
  }

  AddUserAccountReq._();

  factory AddUserAccountReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddUserAccountReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddUserAccountReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ip')
    ..aOS(2, _omitFieldNames ? '' : 'deviceID', protoName: 'deviceID')
    ..aI(3, _omitFieldNames ? '' : 'platform')
    ..aOM<RegisterUserInfo>(4, _omitFieldNames ? '' : 'user', subBuilder: RegisterUserInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserAccountReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserAccountReq copyWith(void Function(AddUserAccountReq) updates) =>
      super.copyWith((message) => updates(message as AddUserAccountReq)) as AddUserAccountReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddUserAccountReq create() => AddUserAccountReq._();
  @$core.override
  AddUserAccountReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddUserAccountReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddUserAccountReq>(create);
  static AddUserAccountReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ip => $_getSZ(0);
  @$pb.TagNumber(1)
  set ip($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIp() => $_has(0);
  @$pb.TagNumber(1)
  void clearIp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceID => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceID() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get platform => $_getIZ(2);
  @$pb.TagNumber(3)
  set platform($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  RegisterUserInfo get user => $_getN(3);
  @$pb.TagNumber(4)
  set user(RegisterUserInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUser() => $_clearField(4);
  @$pb.TagNumber(4)
  RegisterUserInfo ensureUser() => $_ensure(3);
}

class AddUserAccountResp extends $pb.GeneratedMessage {
  factory AddUserAccountResp() => create();

  AddUserAccountResp._();

  factory AddUserAccountResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddUserAccountResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddUserAccountResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserAccountResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserAccountResp copyWith(void Function(AddUserAccountResp) updates) =>
      super.copyWith((message) => updates(message as AddUserAccountResp)) as AddUserAccountResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddUserAccountResp create() => AddUserAccountResp._();
  @$core.override
  AddUserAccountResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddUserAccountResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddUserAccountResp>(create);
  static AddUserAccountResp? _defaultInstance;
}

class LoginReq extends $pb.GeneratedMessage {
  factory LoginReq({
    $core.String? areaCode,
    $core.String? phoneNumber,
    $core.String? verifyCode,
    $core.String? account,
    $core.String? password,
    $core.int? platform,
    $core.String? deviceID,
    $core.String? ip,
    $core.String? email,
  }) {
    final result = create();
    if (areaCode != null) result.areaCode = areaCode;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (verifyCode != null) result.verifyCode = verifyCode;
    if (account != null) result.account = account;
    if (password != null) result.password = password;
    if (platform != null) result.platform = platform;
    if (deviceID != null) result.deviceID = deviceID;
    if (ip != null) result.ip = ip;
    if (email != null) result.email = email;
    return result;
  }

  LoginReq._();

  factory LoginReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'areaCode', protoName: 'areaCode')
    ..aOS(2, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(3, _omitFieldNames ? '' : 'verifyCode', protoName: 'verifyCode')
    ..aOS(4, _omitFieldNames ? '' : 'account')
    ..aOS(5, _omitFieldNames ? '' : 'password')
    ..aI(6, _omitFieldNames ? '' : 'platform')
    ..aOS(7, _omitFieldNames ? '' : 'deviceID', protoName: 'deviceID')
    ..aOS(8, _omitFieldNames ? '' : 'ip')
    ..aOS(9, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginReq copyWith(void Function(LoginReq) updates) =>
      super.copyWith((message) => updates(message as LoginReq)) as LoginReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginReq create() => LoginReq._();
  @$core.override
  LoginReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginReq>(create);
  static LoginReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get areaCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set areaCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAreaCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearAreaCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phoneNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set phoneNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhoneNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhoneNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get verifyCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set verifyCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVerifyCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerifyCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get account => $_getSZ(3);
  @$pb.TagNumber(4)
  set account($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get password => $_getSZ(4);
  @$pb.TagNumber(5)
  set password($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPassword() => $_has(4);
  @$pb.TagNumber(5)
  void clearPassword() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get platform => $_getIZ(5);
  @$pb.TagNumber(6)
  set platform($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPlatform() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlatform() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get deviceID => $_getSZ(6);
  @$pb.TagNumber(7)
  set deviceID($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDeviceID() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeviceID() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get ip => $_getSZ(7);
  @$pb.TagNumber(8)
  set ip($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIp() => $_has(7);
  @$pb.TagNumber(8)
  void clearIp() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get email => $_getSZ(8);
  @$pb.TagNumber(9)
  set email($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEmail() => $_has(8);
  @$pb.TagNumber(9)
  void clearEmail() => $_clearField(9);
}

class ResetPasswordReq extends $pb.GeneratedMessage {
  factory ResetPasswordReq({
    $core.String? areaCode,
    $core.String? phoneNumber,
    $core.String? verifyCode,
    $core.String? password,
    $core.String? email,
  }) {
    final result = create();
    if (areaCode != null) result.areaCode = areaCode;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (verifyCode != null) result.verifyCode = verifyCode;
    if (password != null) result.password = password;
    if (email != null) result.email = email;
    return result;
  }

  ResetPasswordReq._();

  factory ResetPasswordReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResetPasswordReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResetPasswordReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'areaCode', protoName: 'areaCode')
    ..aOS(2, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(3, _omitFieldNames ? '' : 'verifyCode', protoName: 'verifyCode')
    ..aOS(4, _omitFieldNames ? '' : 'password')
    ..aOS(5, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetPasswordReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetPasswordReq copyWith(void Function(ResetPasswordReq) updates) =>
      super.copyWith((message) => updates(message as ResetPasswordReq)) as ResetPasswordReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetPasswordReq create() => ResetPasswordReq._();
  @$core.override
  ResetPasswordReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResetPasswordReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResetPasswordReq>(create);
  static ResetPasswordReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get areaCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set areaCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAreaCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearAreaCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get phoneNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set phoneNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPhoneNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhoneNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get verifyCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set verifyCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVerifyCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerifyCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get password => $_getSZ(3);
  @$pb.TagNumber(4)
  set password($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPassword() => $_has(3);
  @$pb.TagNumber(4)
  void clearPassword() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get email => $_getSZ(4);
  @$pb.TagNumber(5)
  set email($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearEmail() => $_clearField(5);
}

class ResetPasswordResp extends $pb.GeneratedMessage {
  factory ResetPasswordResp() => create();

  ResetPasswordResp._();

  factory ResetPasswordResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResetPasswordResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResetPasswordResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetPasswordResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResetPasswordResp copyWith(void Function(ResetPasswordResp) updates) =>
      super.copyWith((message) => updates(message as ResetPasswordResp)) as ResetPasswordResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResetPasswordResp create() => ResetPasswordResp._();
  @$core.override
  ResetPasswordResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResetPasswordResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResetPasswordResp>(create);
  static ResetPasswordResp? _defaultInstance;
}

class ChangePasswordReq extends $pb.GeneratedMessage {
  factory ChangePasswordReq({
    $core.String? userID,
    $core.String? currentPassword,
    $core.String? newPassword,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (currentPassword != null) result.currentPassword = currentPassword;
    if (newPassword != null) result.newPassword = newPassword;
    return result;
  }

  ChangePasswordReq._();

  factory ChangePasswordReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangePasswordReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChangePasswordReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'currentPassword', protoName: 'currentPassword')
    ..aOS(3, _omitFieldNames ? '' : 'newPassword', protoName: 'newPassword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordReq copyWith(void Function(ChangePasswordReq) updates) =>
      super.copyWith((message) => updates(message as ChangePasswordReq)) as ChangePasswordReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePasswordReq create() => ChangePasswordReq._();
  @$core.override
  ChangePasswordReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangePasswordReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChangePasswordReq>(create);
  static ChangePasswordReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get currentPassword => $_getSZ(1);
  @$pb.TagNumber(2)
  set currentPassword($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newPassword => $_getSZ(2);
  @$pb.TagNumber(3)
  set newPassword($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewPassword() => $_clearField(3);
}

class ChangePasswordResp extends $pb.GeneratedMessage {
  factory ChangePasswordResp() => create();

  ChangePasswordResp._();

  factory ChangePasswordResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangePasswordResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChangePasswordResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordResp copyWith(void Function(ChangePasswordResp) updates) =>
      super.copyWith((message) => updates(message as ChangePasswordResp)) as ChangePasswordResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePasswordResp create() => ChangePasswordResp._();
  @$core.override
  ChangePasswordResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangePasswordResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChangePasswordResp>(create);
  static ChangePasswordResp? _defaultInstance;
}

class FindUserAccountReq extends $pb.GeneratedMessage {
  factory FindUserAccountReq({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  FindUserAccountReq._();

  factory FindUserAccountReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindUserAccountReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FindUserAccountReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserAccountReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserAccountReq copyWith(void Function(FindUserAccountReq) updates) =>
      super.copyWith((message) => updates(message as FindUserAccountReq)) as FindUserAccountReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindUserAccountReq create() => FindUserAccountReq._();
  @$core.override
  FindUserAccountReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindUserAccountReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FindUserAccountReq>(create);
  static FindUserAccountReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class FindUserAccountResp extends $pb.GeneratedMessage {
  factory FindUserAccountResp({
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? userAccountMap,
  }) {
    final result = create();
    if (userAccountMap != null) result.userAccountMap.addEntries(userAccountMap);
    return result;
  }

  FindUserAccountResp._();

  factory FindUserAccountResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindUserAccountResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FindUserAccountResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'userAccountMap',
        protoName: 'userAccountMap',
        entryClassName: 'FindUserAccountResp.UserAccountMapEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('openim.chat'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserAccountResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserAccountResp copyWith(void Function(FindUserAccountResp) updates) =>
      super.copyWith((message) => updates(message as FindUserAccountResp)) as FindUserAccountResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindUserAccountResp create() => FindUserAccountResp._();
  @$core.override
  FindUserAccountResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindUserAccountResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FindUserAccountResp>(create);
  static FindUserAccountResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.String> get userAccountMap => $_getMap(0);
}

class FindAccountUserReq extends $pb.GeneratedMessage {
  factory FindAccountUserReq({
    $core.Iterable<$core.String>? accounts,
  }) {
    final result = create();
    if (accounts != null) result.accounts.addAll(accounts);
    return result;
  }

  FindAccountUserReq._();

  factory FindAccountUserReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindAccountUserReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FindAccountUserReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'accounts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindAccountUserReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindAccountUserReq copyWith(void Function(FindAccountUserReq) updates) =>
      super.copyWith((message) => updates(message as FindAccountUserReq)) as FindAccountUserReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindAccountUserReq create() => FindAccountUserReq._();
  @$core.override
  FindAccountUserReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindAccountUserReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FindAccountUserReq>(create);
  static FindAccountUserReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get accounts => $_getList(0);
}

class FindAccountUserResp extends $pb.GeneratedMessage {
  factory FindAccountUserResp({
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? accountUserMap,
  }) {
    final result = create();
    if (accountUserMap != null) result.accountUserMap.addEntries(accountUserMap);
    return result;
  }

  FindAccountUserResp._();

  factory FindAccountUserResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindAccountUserResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FindAccountUserResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'accountUserMap',
        protoName: 'accountUserMap',
        entryClassName: 'FindAccountUserResp.AccountUserMapEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('openim.chat'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindAccountUserResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindAccountUserResp copyWith(void Function(FindAccountUserResp) updates) =>
      super.copyWith((message) => updates(message as FindAccountUserResp)) as FindAccountUserResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindAccountUserResp create() => FindAccountUserResp._();
  @$core.override
  FindAccountUserResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindAccountUserResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FindAccountUserResp>(create);
  static FindAccountUserResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.String> get accountUserMap => $_getMap(0);
}

class SignalRecord extends $pb.GeneratedMessage {
  factory SignalRecord({
    $core.String? fileName,
    $core.String? mediaType,
    $core.String? roomType,
    $core.String? senderID,
    $core.String? senderNickname,
    $core.String? recvID,
    $core.String? recvNickname,
    $core.String? groupID,
    $core.String? groupName,
    $core.Iterable<$1.UserPublicInfo>? inviterUserList,
    $core.int? duration,
    $fixnum.Int64? createTime,
    $core.String? size,
    $core.String? downloadURL,
  }) {
    final result = create();
    if (fileName != null) result.fileName = fileName;
    if (mediaType != null) result.mediaType = mediaType;
    if (roomType != null) result.roomType = roomType;
    if (senderID != null) result.senderID = senderID;
    if (senderNickname != null) result.senderNickname = senderNickname;
    if (recvID != null) result.recvID = recvID;
    if (recvNickname != null) result.recvNickname = recvNickname;
    if (groupID != null) result.groupID = groupID;
    if (groupName != null) result.groupName = groupName;
    if (inviterUserList != null) result.inviterUserList.addAll(inviterUserList);
    if (duration != null) result.duration = duration;
    if (createTime != null) result.createTime = createTime;
    if (size != null) result.size = size;
    if (downloadURL != null) result.downloadURL = downloadURL;
    return result;
  }

  SignalRecord._();

  factory SignalRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignalRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SignalRecord',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileName', protoName: 'fileName')
    ..aOS(2, _omitFieldNames ? '' : 'mediaType', protoName: 'mediaType')
    ..aOS(3, _omitFieldNames ? '' : 'roomType', protoName: 'roomType')
    ..aOS(4, _omitFieldNames ? '' : 'senderID', protoName: 'senderID')
    ..aOS(5, _omitFieldNames ? '' : 'senderNickname', protoName: 'senderNickname')
    ..aOS(6, _omitFieldNames ? '' : 'recvID', protoName: 'recvID')
    ..aOS(7, _omitFieldNames ? '' : 'recvNickname', protoName: 'recvNickname')
    ..aOS(8, _omitFieldNames ? '' : 'groupID', protoName: 'groupID')
    ..aOS(9, _omitFieldNames ? '' : 'groupName', protoName: 'groupName')
    ..pPM<$1.UserPublicInfo>(10, _omitFieldNames ? '' : 'inviterUserList',
        protoName: 'inviterUserList', subBuilder: $1.UserPublicInfo.create)
    ..aI(11, _omitFieldNames ? '' : 'duration')
    ..aInt64(12, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aOS(13, _omitFieldNames ? '' : 'size')
    ..aOS(14, _omitFieldNames ? '' : 'downloadURL', protoName: 'downloadURL')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignalRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignalRecord copyWith(void Function(SignalRecord) updates) =>
      super.copyWith((message) => updates(message as SignalRecord)) as SignalRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignalRecord create() => SignalRecord._();
  @$core.override
  SignalRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignalRecord getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignalRecord>(create);
  static SignalRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileName => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaType => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get roomType => $_getSZ(2);
  @$pb.TagNumber(3)
  set roomType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoomType() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoomType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get senderID => $_getSZ(3);
  @$pb.TagNumber(4)
  set senderID($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSenderID() => $_has(3);
  @$pb.TagNumber(4)
  void clearSenderID() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get senderNickname => $_getSZ(4);
  @$pb.TagNumber(5)
  set senderNickname($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSenderNickname() => $_has(4);
  @$pb.TagNumber(5)
  void clearSenderNickname() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get recvID => $_getSZ(5);
  @$pb.TagNumber(6)
  set recvID($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRecvID() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecvID() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get recvNickname => $_getSZ(6);
  @$pb.TagNumber(7)
  set recvNickname($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRecvNickname() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecvNickname() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get groupID => $_getSZ(7);
  @$pb.TagNumber(8)
  set groupID($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasGroupID() => $_has(7);
  @$pb.TagNumber(8)
  void clearGroupID() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get groupName => $_getSZ(8);
  @$pb.TagNumber(9)
  set groupName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasGroupName() => $_has(8);
  @$pb.TagNumber(9)
  void clearGroupName() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$1.UserPublicInfo> get inviterUserList => $_getList(9);

  @$pb.TagNumber(11)
  $core.int get duration => $_getIZ(10);
  @$pb.TagNumber(11)
  set duration($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDuration() => $_has(10);
  @$pb.TagNumber(11)
  void clearDuration() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get createTime => $_getI64(11);
  @$pb.TagNumber(12)
  set createTime($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCreateTime() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreateTime() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get size => $_getSZ(12);
  @$pb.TagNumber(13)
  set size($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSize() => $_has(12);
  @$pb.TagNumber(13)
  void clearSize() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get downloadURL => $_getSZ(13);
  @$pb.TagNumber(14)
  set downloadURL($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDownloadURL() => $_has(13);
  @$pb.TagNumber(14)
  void clearDownloadURL() => $_clearField(14);
}

class OpenIMCallbackReq extends $pb.GeneratedMessage {
  factory OpenIMCallbackReq({
    $core.String? command,
    $core.String? body,
  }) {
    final result = create();
    if (command != null) result.command = command;
    if (body != null) result.body = body;
    return result;
  }

  OpenIMCallbackReq._();

  factory OpenIMCallbackReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenIMCallbackReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OpenIMCallbackReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'command')
    ..aOS(2, _omitFieldNames ? '' : 'body')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenIMCallbackReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenIMCallbackReq copyWith(void Function(OpenIMCallbackReq) updates) =>
      super.copyWith((message) => updates(message as OpenIMCallbackReq)) as OpenIMCallbackReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenIMCallbackReq create() => OpenIMCallbackReq._();
  @$core.override
  OpenIMCallbackReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenIMCallbackReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenIMCallbackReq>(create);
  static OpenIMCallbackReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get command => $_getSZ(0);
  @$pb.TagNumber(1)
  set command($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommand() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get body => $_getSZ(1);
  @$pb.TagNumber(2)
  set body($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBody() => $_has(1);
  @$pb.TagNumber(2)
  void clearBody() => $_clearField(2);
}

class OpenIMCallbackResp extends $pb.GeneratedMessage {
  factory OpenIMCallbackResp() => create();

  OpenIMCallbackResp._();

  factory OpenIMCallbackResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenIMCallbackResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OpenIMCallbackResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenIMCallbackResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenIMCallbackResp copyWith(void Function(OpenIMCallbackResp) updates) =>
      super.copyWith((message) => updates(message as OpenIMCallbackResp)) as OpenIMCallbackResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenIMCallbackResp create() => OpenIMCallbackResp._();
  @$core.override
  OpenIMCallbackResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenIMCallbackResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpenIMCallbackResp>(create);
  static OpenIMCallbackResp? _defaultInstance;
}

class SearchUserFullInfoReq extends $pb.GeneratedMessage {
  factory SearchUserFullInfoReq({
    $core.String? keyword,
    $2.RequestPagination? pagination,
    $core.int? genders,
    $core.int? normal,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (pagination != null) result.pagination = pagination;
    if (genders != null) result.genders = genders;
    if (normal != null) result.normal = normal;
    return result;
  }

  SearchUserFullInfoReq._();

  factory SearchUserFullInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchUserFullInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchUserFullInfoReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aOM<$2.RequestPagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.RequestPagination.create)
    ..aI(3, _omitFieldNames ? '' : 'genders')
    ..aI(4, _omitFieldNames ? '' : 'normal')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserFullInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserFullInfoReq copyWith(void Function(SearchUserFullInfoReq) updates) =>
      super.copyWith((message) => updates(message as SearchUserFullInfoReq))
          as SearchUserFullInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchUserFullInfoReq create() => SearchUserFullInfoReq._();
  @$core.override
  SearchUserFullInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchUserFullInfoReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchUserFullInfoReq>(create);
  static SearchUserFullInfoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.RequestPagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.RequestPagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.RequestPagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get genders => $_getIZ(2);
  @$pb.TagNumber(3)
  set genders($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGenders() => $_has(2);
  @$pb.TagNumber(3)
  void clearGenders() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get normal => $_getIZ(3);
  @$pb.TagNumber(4)
  set normal($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNormal() => $_has(3);
  @$pb.TagNumber(4)
  void clearNormal() => $_clearField(4);
}

class SearchUserFullInfoResp extends $pb.GeneratedMessage {
  factory SearchUserFullInfoResp({
    $core.int? total,
    $core.Iterable<$1.UserFullInfo>? users,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (users != null) result.users.addAll(users);
    return result;
  }

  SearchUserFullInfoResp._();

  factory SearchUserFullInfoResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchUserFullInfoResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchUserFullInfoResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPM<$1.UserFullInfo>(2, _omitFieldNames ? '' : 'users', subBuilder: $1.UserFullInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserFullInfoResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserFullInfoResp copyWith(void Function(SearchUserFullInfoResp) updates) =>
      super.copyWith((message) => updates(message as SearchUserFullInfoResp))
          as SearchUserFullInfoResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchUserFullInfoResp create() => SearchUserFullInfoResp._();
  @$core.override
  SearchUserFullInfoResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchUserFullInfoResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchUserFullInfoResp>(create);
  static SearchUserFullInfoResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$1.UserFullInfo> get users => $_getList(1);
}

class UserLoginCountReq extends $pb.GeneratedMessage {
  factory UserLoginCountReq({
    $fixnum.Int64? start,
    $fixnum.Int64? end,
  }) {
    final result = create();
    if (start != null) result.start = start;
    if (end != null) result.end = end;
    return result;
  }

  UserLoginCountReq._();

  factory UserLoginCountReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserLoginCountReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserLoginCountReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'start')
    ..aInt64(2, _omitFieldNames ? '' : 'end')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLoginCountReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLoginCountReq copyWith(void Function(UserLoginCountReq) updates) =>
      super.copyWith((message) => updates(message as UserLoginCountReq)) as UserLoginCountReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserLoginCountReq create() => UserLoginCountReq._();
  @$core.override
  UserLoginCountReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserLoginCountReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserLoginCountReq>(create);
  static UserLoginCountReq? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get start => $_getI64(0);
  @$pb.TagNumber(1)
  set start($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get end => $_getI64(1);
  @$pb.TagNumber(2)
  set end($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);
}

class UserLoginCountResp extends $pb.GeneratedMessage {
  factory UserLoginCountResp({
    $fixnum.Int64? loginCount,
    $fixnum.Int64? unloginCount,
    $core.Iterable<$core.MapEntry<$core.String, $fixnum.Int64>>? count,
  }) {
    final result = create();
    if (loginCount != null) result.loginCount = loginCount;
    if (unloginCount != null) result.unloginCount = unloginCount;
    if (count != null) result.count.addEntries(count);
    return result;
  }

  UserLoginCountResp._();

  factory UserLoginCountResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserLoginCountResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserLoginCountResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'loginCount', protoName: 'loginCount')
    ..aInt64(2, _omitFieldNames ? '' : 'unloginCount', protoName: 'unloginCount')
    ..m<$core.String, $fixnum.Int64>(3, _omitFieldNames ? '' : 'count',
        entryClassName: 'UserLoginCountResp.CountEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O6,
        packageName: const $pb.PackageName('openim.chat'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLoginCountResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserLoginCountResp copyWith(void Function(UserLoginCountResp) updates) =>
      super.copyWith((message) => updates(message as UserLoginCountResp)) as UserLoginCountResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserLoginCountResp create() => UserLoginCountResp._();
  @$core.override
  UserLoginCountResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserLoginCountResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserLoginCountResp>(create);
  static UserLoginCountResp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get loginCount => $_getI64(0);
  @$pb.TagNumber(1)
  set loginCount($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLoginCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoginCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get unloginCount => $_getI64(1);
  @$pb.TagNumber(2)
  set unloginCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnloginCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnloginCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $fixnum.Int64> get count => $_getMap(2);
}

class LoginResp extends $pb.GeneratedMessage {
  factory LoginResp({
    $core.String? chatToken,
    $core.String? userID,
  }) {
    final result = create();
    if (chatToken != null) result.chatToken = chatToken;
    if (userID != null) result.userID = userID;
    return result;
  }

  LoginResp._();

  factory LoginResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'chatToken', protoName: 'chatToken')
    ..aOS(3, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResp copyWith(void Function(LoginResp) updates) =>
      super.copyWith((message) => updates(message as LoginResp)) as LoginResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResp create() => LoginResp._();
  @$core.override
  LoginResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginResp>(create);
  static LoginResp? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get chatToken => $_getSZ(0);
  @$pb.TagNumber(2)
  set chatToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasChatToken() => $_has(0);
  @$pb.TagNumber(2)
  void clearChatToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userID => $_getSZ(1);
  @$pb.TagNumber(3)
  set userID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(3)
  void clearUserID() => $_clearField(3);
}

class SearchUserInfoReq extends $pb.GeneratedMessage {
  factory SearchUserInfoReq({
    $core.String? keyword,
    $2.RequestPagination? pagination,
    $core.Iterable<$core.int>? genders,
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (pagination != null) result.pagination = pagination;
    if (genders != null) result.genders.addAll(genders);
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  SearchUserInfoReq._();

  factory SearchUserInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchUserInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SearchUserInfoReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aOM<$2.RequestPagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.RequestPagination.create)
    ..p<$core.int>(3, _omitFieldNames ? '' : 'genders', $pb.PbFieldType.K3)
    ..pPS(4, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserInfoReq copyWith(void Function(SearchUserInfoReq) updates) =>
      super.copyWith((message) => updates(message as SearchUserInfoReq)) as SearchUserInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchUserInfoReq create() => SearchUserInfoReq._();
  @$core.override
  SearchUserInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchUserInfoReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchUserInfoReq>(create);
  static SearchUserInfoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.RequestPagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.RequestPagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.RequestPagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.int> get genders => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get userIDs => $_getList(3);
}

class SearchUserInfoResp extends $pb.GeneratedMessage {
  factory SearchUserInfoResp({
    $core.int? total,
    $core.Iterable<$1.UserFullInfo>? users,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (users != null) result.users.addAll(users);
    return result;
  }

  SearchUserInfoResp._();

  factory SearchUserInfoResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchUserInfoResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SearchUserInfoResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPM<$1.UserFullInfo>(2, _omitFieldNames ? '' : 'users', subBuilder: $1.UserFullInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserInfoResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserInfoResp copyWith(void Function(SearchUserInfoResp) updates) =>
      super.copyWith((message) => updates(message as SearchUserInfoResp)) as SearchUserInfoResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchUserInfoResp create() => SearchUserInfoResp._();
  @$core.override
  SearchUserInfoResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchUserInfoResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchUserInfoResp>(create);
  static SearchUserInfoResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$1.UserFullInfo> get users => $_getList(1);
}

class GetTokenForVideoMeetingReq extends $pb.GeneratedMessage {
  factory GetTokenForVideoMeetingReq({
    $core.String? room,
    $core.String? identity,
  }) {
    final result = create();
    if (room != null) result.room = room;
    if (identity != null) result.identity = identity;
    return result;
  }

  GetTokenForVideoMeetingReq._();

  factory GetTokenForVideoMeetingReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTokenForVideoMeetingReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTokenForVideoMeetingReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'room')
    ..aOS(2, _omitFieldNames ? '' : 'identity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTokenForVideoMeetingReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTokenForVideoMeetingReq copyWith(void Function(GetTokenForVideoMeetingReq) updates) =>
      super.copyWith((message) => updates(message as GetTokenForVideoMeetingReq))
          as GetTokenForVideoMeetingReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTokenForVideoMeetingReq create() => GetTokenForVideoMeetingReq._();
  @$core.override
  GetTokenForVideoMeetingReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTokenForVideoMeetingReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTokenForVideoMeetingReq>(create);
  static GetTokenForVideoMeetingReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get room => $_getSZ(0);
  @$pb.TagNumber(1)
  set room($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get identity => $_getSZ(1);
  @$pb.TagNumber(2)
  set identity($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdentity() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdentity() => $_clearField(2);
}

class GetTokenForVideoMeetingResp extends $pb.GeneratedMessage {
  factory GetTokenForVideoMeetingResp({
    $core.String? serverUrl,
    $core.String? token,
  }) {
    final result = create();
    if (serverUrl != null) result.serverUrl = serverUrl;
    if (token != null) result.token = token;
    return result;
  }

  GetTokenForVideoMeetingResp._();

  factory GetTokenForVideoMeetingResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTokenForVideoMeetingResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTokenForVideoMeetingResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverUrl', protoName: 'serverUrl')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTokenForVideoMeetingResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTokenForVideoMeetingResp copyWith(void Function(GetTokenForVideoMeetingResp) updates) =>
      super.copyWith((message) => updates(message as GetTokenForVideoMeetingResp))
          as GetTokenForVideoMeetingResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTokenForVideoMeetingResp create() => GetTokenForVideoMeetingResp._();
  @$core.override
  GetTokenForVideoMeetingResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTokenForVideoMeetingResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTokenForVideoMeetingResp>(create);
  static GetTokenForVideoMeetingResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);
}

/// GetRTCToken - Custom RTC token generation
class GetRTCTokenReq extends $pb.GeneratedMessage {
  factory GetRTCTokenReq({
    $core.String? roomId,
    $core.String? userId,
    $core.int? expireTime,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (expireTime != null) result.expireTime = expireTime;
    return result;
  }

  GetRTCTokenReq._();

  factory GetRTCTokenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRTCTokenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetRTCTokenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId', protoName: 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aI(3, _omitFieldNames ? '' : 'expireTime', protoName: 'expireTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRTCTokenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRTCTokenReq copyWith(void Function(GetRTCTokenReq) updates) =>
      super.copyWith((message) => updates(message as GetRTCTokenReq)) as GetRTCTokenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRTCTokenReq create() => GetRTCTokenReq._();
  @$core.override
  GetRTCTokenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRTCTokenReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRTCTokenReq>(create);
  static GetRTCTokenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get expireTime => $_getIZ(2);
  @$pb.TagNumber(3)
  set expireTime($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpireTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpireTime() => $_clearField(3);
}

class GetRTCTokenResp extends $pb.GeneratedMessage {
  factory GetRTCTokenResp({
    $core.String? token,
    $core.String? appId,
    $core.String? roomId,
    $core.String? userId,
    $fixnum.Int64? expireAt,
  }) {
    final result = create();
    if (token != null) result.token = token;
    if (appId != null) result.appId = appId;
    if (roomId != null) result.roomId = roomId;
    if (userId != null) result.userId = userId;
    if (expireAt != null) result.expireAt = expireAt;
    return result;
  }

  GetRTCTokenResp._();

  factory GetRTCTokenResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRTCTokenResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetRTCTokenResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOS(2, _omitFieldNames ? '' : 'appId', protoName: 'appId')
    ..aOS(3, _omitFieldNames ? '' : 'roomId', protoName: 'roomId')
    ..aOS(4, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..aInt64(5, _omitFieldNames ? '' : 'expireAt', protoName: 'expireAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRTCTokenResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRTCTokenResp copyWith(void Function(GetRTCTokenResp) updates) =>
      super.copyWith((message) => updates(message as GetRTCTokenResp)) as GetRTCTokenResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRTCTokenResp create() => GetRTCTokenResp._();
  @$core.override
  GetRTCTokenResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRTCTokenResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRTCTokenResp>(create);
  static GetRTCTokenResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get appId => $_getSZ(1);
  @$pb.TagNumber(2)
  set appId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAppId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAppId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get roomId => $_getSZ(2);
  @$pb.TagNumber(3)
  set roomId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoomId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoomId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userId => $_getSZ(3);
  @$pb.TagNumber(4)
  set userId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserId() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expireAt => $_getI64(4);
  @$pb.TagNumber(5)
  set expireAt($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpireAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpireAt() => $_clearField(5);
}

class CheckUserExistReq extends $pb.GeneratedMessage {
  factory CheckUserExistReq({
    RegisterUserInfo? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  CheckUserExistReq._();

  factory CheckUserExistReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckUserExistReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CheckUserExistReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOM<RegisterUserInfo>(1, _omitFieldNames ? '' : 'user', subBuilder: RegisterUserInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckUserExistReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckUserExistReq copyWith(void Function(CheckUserExistReq) updates) =>
      super.copyWith((message) => updates(message as CheckUserExistReq)) as CheckUserExistReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckUserExistReq create() => CheckUserExistReq._();
  @$core.override
  CheckUserExistReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckUserExistReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckUserExistReq>(create);
  static CheckUserExistReq? _defaultInstance;

  @$pb.TagNumber(1)
  RegisterUserInfo get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(RegisterUserInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
  @$pb.TagNumber(1)
  RegisterUserInfo ensureUser() => $_ensure(0);
}

class CheckUserExistResp extends $pb.GeneratedMessage {
  factory CheckUserExistResp({
    $core.String? userid,
    $core.bool? isRegistered,
  }) {
    final result = create();
    if (userid != null) result.userid = userid;
    if (isRegistered != null) result.isRegistered = isRegistered;
    return result;
  }

  CheckUserExistResp._();

  factory CheckUserExistResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckUserExistResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CheckUserExistResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userid')
    ..aOB(2, _omitFieldNames ? '' : 'isRegistered', protoName: 'isRegistered')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckUserExistResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckUserExistResp copyWith(void Function(CheckUserExistResp) updates) =>
      super.copyWith((message) => updates(message as CheckUserExistResp)) as CheckUserExistResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckUserExistResp create() => CheckUserExistResp._();
  @$core.override
  CheckUserExistResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckUserExistResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckUserExistResp>(create);
  static CheckUserExistResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userid => $_getSZ(0);
  @$pb.TagNumber(1)
  set userid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isRegistered => $_getBF(1);
  @$pb.TagNumber(2)
  set isRegistered($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsRegistered() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsRegistered() => $_clearField(2);
}

class DelUserAccountReq extends $pb.GeneratedMessage {
  factory DelUserAccountReq({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  DelUserAccountReq._();

  factory DelUserAccountReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelUserAccountReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DelUserAccountReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelUserAccountReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelUserAccountReq copyWith(void Function(DelUserAccountReq) updates) =>
      super.copyWith((message) => updates(message as DelUserAccountReq)) as DelUserAccountReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelUserAccountReq create() => DelUserAccountReq._();
  @$core.override
  DelUserAccountReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelUserAccountReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DelUserAccountReq>(create);
  static DelUserAccountReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class DelUserAccountResp extends $pb.GeneratedMessage {
  factory DelUserAccountResp() => create();

  DelUserAccountResp._();

  factory DelUserAccountResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelUserAccountResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DelUserAccountResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelUserAccountResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelUserAccountResp copyWith(void Function(DelUserAccountResp) updates) =>
      super.copyWith((message) => updates(message as DelUserAccountResp)) as DelUserAccountResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelUserAccountResp create() => DelUserAccountResp._();
  @$core.override
  DelUserAccountResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelUserAccountResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DelUserAccountResp>(create);
  static DelUserAccountResp? _defaultInstance;
}

class SetAllowRegisterReq extends $pb.GeneratedMessage {
  factory SetAllowRegisterReq({
    $core.bool? allowRegister,
  }) {
    final result = create();
    if (allowRegister != null) result.allowRegister = allowRegister;
    return result;
  }

  SetAllowRegisterReq._();

  factory SetAllowRegisterReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAllowRegisterReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SetAllowRegisterReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'allowRegister', protoName: 'allowRegister')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAllowRegisterReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAllowRegisterReq copyWith(void Function(SetAllowRegisterReq) updates) =>
      super.copyWith((message) => updates(message as SetAllowRegisterReq)) as SetAllowRegisterReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAllowRegisterReq create() => SetAllowRegisterReq._();
  @$core.override
  SetAllowRegisterReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAllowRegisterReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetAllowRegisterReq>(create);
  static SetAllowRegisterReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allowRegister => $_getBF(0);
  @$pb.TagNumber(1)
  set allowRegister($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllowRegister() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllowRegister() => $_clearField(1);
}

class SetAllowRegisterResp extends $pb.GeneratedMessage {
  factory SetAllowRegisterResp() => create();

  SetAllowRegisterResp._();

  factory SetAllowRegisterResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAllowRegisterResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SetAllowRegisterResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAllowRegisterResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAllowRegisterResp copyWith(void Function(SetAllowRegisterResp) updates) =>
      super.copyWith((message) => updates(message as SetAllowRegisterResp)) as SetAllowRegisterResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAllowRegisterResp create() => SetAllowRegisterResp._();
  @$core.override
  SetAllowRegisterResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAllowRegisterResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetAllowRegisterResp>(create);
  static SetAllowRegisterResp? _defaultInstance;
}

class GetAllowRegisterReq extends $pb.GeneratedMessage {
  factory GetAllowRegisterReq() => create();

  GetAllowRegisterReq._();

  factory GetAllowRegisterReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAllowRegisterReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAllowRegisterReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllowRegisterReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllowRegisterReq copyWith(void Function(GetAllowRegisterReq) updates) =>
      super.copyWith((message) => updates(message as GetAllowRegisterReq)) as GetAllowRegisterReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAllowRegisterReq create() => GetAllowRegisterReq._();
  @$core.override
  GetAllowRegisterReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAllowRegisterReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAllowRegisterReq>(create);
  static GetAllowRegisterReq? _defaultInstance;
}

class GetAllowRegisterResp extends $pb.GeneratedMessage {
  factory GetAllowRegisterResp({
    $core.bool? allowRegister,
  }) {
    final result = create();
    if (allowRegister != null) result.allowRegister = allowRegister;
    return result;
  }

  GetAllowRegisterResp._();

  factory GetAllowRegisterResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAllowRegisterResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAllowRegisterResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.chat'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'allowRegister', protoName: 'allowRegister')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllowRegisterResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllowRegisterResp copyWith(void Function(GetAllowRegisterResp) updates) =>
      super.copyWith((message) => updates(message as GetAllowRegisterResp)) as GetAllowRegisterResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAllowRegisterResp create() => GetAllowRegisterResp._();
  @$core.override
  GetAllowRegisterResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAllowRegisterResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAllowRegisterResp>(create);
  static GetAllowRegisterResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allowRegister => $_getBF(0);
  @$pb.TagNumber(1)
  set allowRegister($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllowRegister() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllowRegister() => $_clearField(1);
}

class chatApi {
  final $pb.RpcClient _client;

  chatApi(this._client);

  /// Edit personal information - called by the user or an administrator
  $async.Future<UpdateUserInfoResp> updateUserInfo(
          $pb.ClientContext? ctx, UpdateUserInfoReq request) =>
      _client.invoke<UpdateUserInfoResp>(
          ctx, 'chat', 'UpdateUserInfo', request, UpdateUserInfoResp());
  $async.Future<AddUserAccountResp> addUserAccount(
          $pb.ClientContext? ctx, AddUserAccountReq request) =>
      _client.invoke<AddUserAccountResp>(
          ctx, 'chat', 'AddUserAccount', request, AddUserAccountResp());

  /// Get user's public information - called by strangers
  $async.Future<SearchUserPublicInfoResp> searchUserPublicInfo(
          $pb.ClientContext? ctx, SearchUserPublicInfoReq request) =>
      _client.invoke<SearchUserPublicInfoResp>(
          ctx, 'chat', 'SearchUserPublicInfo', request, SearchUserPublicInfoResp());
  $async.Future<FindUserPublicInfoResp> findUserPublicInfo(
          $pb.ClientContext? ctx, FindUserPublicInfoReq request) =>
      _client.invoke<FindUserPublicInfoResp>(
          ctx, 'chat', 'FindUserPublicInfo', request, FindUserPublicInfoResp());

  /// Search user information - called by administrators, other users get public fields
  $async.Future<SearchUserFullInfoResp> searchUserFullInfo(
          $pb.ClientContext? ctx, SearchUserFullInfoReq request) =>
      _client.invoke<SearchUserFullInfoResp>(
          ctx, 'chat', 'SearchUserFullInfo', request, SearchUserFullInfoResp());
  $async.Future<FindUserFullInfoResp> findUserFullInfo(
          $pb.ClientContext? ctx, FindUserFullInfoReq request) =>
      _client.invoke<FindUserFullInfoResp>(
          ctx, 'chat', 'FindUserFullInfo', request, FindUserFullInfoResp());
  $async.Future<SendVerifyCodeResp> sendVerifyCode(
          $pb.ClientContext? ctx, SendVerifyCodeReq request) =>
      _client.invoke<SendVerifyCodeResp>(
          ctx, 'chat', 'SendVerifyCode', request, SendVerifyCodeResp());
  $async.Future<VerifyCodeResp> verifyCode($pb.ClientContext? ctx, VerifyCodeReq request) =>
      _client.invoke<VerifyCodeResp>(ctx, 'chat', 'VerifyCode', request, VerifyCodeResp());
  $async.Future<RegisterUserResp> registerUser($pb.ClientContext? ctx, RegisterUserReq request) =>
      _client.invoke<RegisterUserResp>(ctx, 'chat', 'RegisterUser', request, RegisterUserResp());
  $async.Future<LoginResp> login($pb.ClientContext? ctx, LoginReq request) =>
      _client.invoke<LoginResp>(ctx, 'chat', 'Login', request, LoginResp());
  $async.Future<ResetPasswordResp> resetPassword(
          $pb.ClientContext? ctx, ResetPasswordReq request) =>
      _client.invoke<ResetPasswordResp>(ctx, 'chat', 'ResetPassword', request, ResetPasswordResp());
  $async.Future<ChangePasswordResp> changePassword(
          $pb.ClientContext? ctx, ChangePasswordReq request) =>
      _client.invoke<ChangePasswordResp>(
          ctx, 'chat', 'ChangePassword', request, ChangePasswordResp());
  $async.Future<CheckUserExistResp> checkUserExist(
          $pb.ClientContext? ctx, CheckUserExistReq request) =>
      _client.invoke<CheckUserExistResp>(
          ctx, 'chat', 'CheckUserExist', request, CheckUserExistResp());
  $async.Future<DelUserAccountResp> delUserAccount(
          $pb.ClientContext? ctx, DelUserAccountReq request) =>
      _client.invoke<DelUserAccountResp>(
          ctx, 'chat', 'DelUserAccount', request, DelUserAccountResp());
  $async.Future<FindUserAccountResp> findUserAccount(
          $pb.ClientContext? ctx, FindUserAccountReq request) =>
      _client.invoke<FindUserAccountResp>(
          ctx, 'chat', 'FindUserAccount', request, FindUserAccountResp());
  $async.Future<FindAccountUserResp> findAccountUser(
          $pb.ClientContext? ctx, FindAccountUserReq request) =>
      _client.invoke<FindAccountUserResp>(
          ctx, 'chat', 'FindAccountUser', request, FindAccountUserResp());
  $async.Future<OpenIMCallbackResp> openIMCallback(
          $pb.ClientContext? ctx, OpenIMCallbackReq request) =>
      _client.invoke<OpenIMCallbackResp>(
          ctx, 'chat', 'OpenIMCallback', request, OpenIMCallbackResp());

  /// Statistics
  $async.Future<UserLoginCountResp> userLoginCount(
          $pb.ClientContext? ctx, UserLoginCountReq request) =>
      _client.invoke<UserLoginCountResp>(
          ctx, 'chat', 'UserLoginCount', request, UserLoginCountResp());
  $async.Future<SearchUserInfoResp> searchUserInfo(
          $pb.ClientContext? ctx, SearchUserInfoReq request) =>
      _client.invoke<SearchUserInfoResp>(
          ctx, 'chat', 'SearchUserInfo', request, SearchUserInfoResp());

  /// Audio/video call and video meeting
  $async.Future<GetTokenForVideoMeetingResp> getTokenForVideoMeeting(
          $pb.ClientContext? ctx, GetTokenForVideoMeetingReq request) =>
      _client.invoke<GetTokenForVideoMeetingResp>(
          ctx, 'chat', 'GetTokenForVideoMeeting', request, GetTokenForVideoMeetingResp());

  /// Custom RTC token generation
  $async.Future<GetRTCTokenResp> getRTCToken($pb.ClientContext? ctx, GetRTCTokenReq request) =>
      _client.invoke<GetRTCTokenResp>(ctx, 'chat', 'GetRTCToken', request, GetRTCTokenResp());
  $async.Future<SetAllowRegisterResp> setAllowRegister(
          $pb.ClientContext? ctx, SetAllowRegisterReq request) =>
      _client.invoke<SetAllowRegisterResp>(
          ctx, 'chat', 'SetAllowRegister', request, SetAllowRegisterResp());
  $async.Future<GetAllowRegisterResp> getAllowRegister(
          $pb.ClientContext? ctx, GetAllowRegisterReq request) =>
      _client.invoke<GetAllowRegisterResp>(
          ctx, 'chat', 'GetAllowRegister', request, GetAllowRegisterResp());
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
