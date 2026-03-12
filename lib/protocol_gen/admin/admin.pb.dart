// This is a generated file - do not edit.
//
// Generated from admin/admin.proto.

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

import '../common/common.pb.dart' as $2;
import '../sdkws/sdkws.pb.dart' as $1;
import '../wrapperspb/wrapperspb.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// login
class LoginReq extends $pb.GeneratedMessage {
  factory LoginReq({
    $core.String? account,
    $core.String? password,
    $core.String? version,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (password != null) result.password = password;
    if (version != null) result.version = version;
    return result;
  }

  LoginReq._();

  factory LoginReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'account')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'version')
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
  $core.String get account => $_getSZ(0);
  @$pb.TagNumber(1)
  set account($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(2);
  @$pb.TagNumber(3)
  set version($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class LoginResp extends $pb.GeneratedMessage {
  factory LoginResp({
    $core.String? adminAccount,
    $core.String? adminToken,
    $core.String? nickname,
    $core.String? faceURL,
    $core.int? level,
    $core.String? adminUserID,
  }) {
    final result = create();
    if (adminAccount != null) result.adminAccount = adminAccount;
    if (adminToken != null) result.adminToken = adminToken;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    if (level != null) result.level = level;
    if (adminUserID != null) result.adminUserID = adminUserID;
    return result;
  }

  LoginResp._();

  factory LoginResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'adminAccount', protoName: 'adminAccount')
    ..aOS(2, _omitFieldNames ? '' : 'adminToken', protoName: 'adminToken')
    ..aOS(3, _omitFieldNames ? '' : 'nickname')
    ..aOS(4, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aI(5, _omitFieldNames ? '' : 'level')
    ..aOS(6, _omitFieldNames ? '' : 'adminUserID', protoName: 'adminUserID')
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

  @$pb.TagNumber(1)
  $core.String get adminAccount => $_getSZ(0);
  @$pb.TagNumber(1)
  set adminAccount($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAdminAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdminAccount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get adminToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set adminToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAdminToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdminToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nickname => $_getSZ(2);
  @$pb.TagNumber(3)
  set nickname($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNickname() => $_has(2);
  @$pb.TagNumber(3)
  void clearNickname() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get faceURL => $_getSZ(3);
  @$pb.TagNumber(4)
  set faceURL($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFaceURL() => $_has(3);
  @$pb.TagNumber(4)
  void clearFaceURL() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get level => $_getIZ(4);
  @$pb.TagNumber(5)
  set level($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLevel() => $_has(4);
  @$pb.TagNumber(5)
  void clearLevel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get adminUserID => $_getSZ(5);
  @$pb.TagNumber(6)
  set adminUserID($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAdminUserID() => $_has(5);
  @$pb.TagNumber(6)
  void clearAdminUserID() => $_clearField(6);
}

class AddAdminAccountReq extends $pb.GeneratedMessage {
  factory AddAdminAccountReq({
    $core.String? account,
    $core.String? password,
    $core.String? faceURL,
    $core.String? nickname,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (password != null) result.password = password;
    if (faceURL != null) result.faceURL = faceURL;
    if (nickname != null) result.nickname = nickname;
    return result;
  }

  AddAdminAccountReq._();

  factory AddAdminAccountReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAdminAccountReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAdminAccountReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'account')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aOS(4, _omitFieldNames ? '' : 'nickname')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAdminAccountReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAdminAccountReq copyWith(void Function(AddAdminAccountReq) updates) =>
      super.copyWith((message) => updates(message as AddAdminAccountReq))
          as AddAdminAccountReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAdminAccountReq create() => AddAdminAccountReq._();
  @$core.override
  AddAdminAccountReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddAdminAccountReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAdminAccountReq>(create);
  static AddAdminAccountReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get account => $_getSZ(0);
  @$pb.TagNumber(1)
  set account($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get faceURL => $_getSZ(2);
  @$pb.TagNumber(3)
  set faceURL($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFaceURL() => $_has(2);
  @$pb.TagNumber(3)
  void clearFaceURL() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nickname => $_getSZ(3);
  @$pb.TagNumber(4)
  set nickname($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNickname() => $_has(3);
  @$pb.TagNumber(4)
  void clearNickname() => $_clearField(4);
}

class AddAdminAccountResp extends $pb.GeneratedMessage {
  factory AddAdminAccountResp() => create();

  AddAdminAccountResp._();

  factory AddAdminAccountResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAdminAccountResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAdminAccountResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAdminAccountResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAdminAccountResp copyWith(void Function(AddAdminAccountResp) updates) =>
      super.copyWith((message) => updates(message as AddAdminAccountResp))
          as AddAdminAccountResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAdminAccountResp create() => AddAdminAccountResp._();
  @$core.override
  AddAdminAccountResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddAdminAccountResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAdminAccountResp>(create);
  static AddAdminAccountResp? _defaultInstance;
}

class AdminUpdateInfoReq extends $pb.GeneratedMessage {
  factory AdminUpdateInfoReq({
    $0.StringValue? account,
    $0.StringValue? password,
    $0.StringValue? faceURL,
    $0.StringValue? nickname,
    $0.Int32Value? level,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (password != null) result.password = password;
    if (faceURL != null) result.faceURL = faceURL;
    if (nickname != null) result.nickname = nickname;
    if (level != null) result.level = level;
    return result;
  }

  AdminUpdateInfoReq._();

  factory AdminUpdateInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdminUpdateInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdminUpdateInfoReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOM<$0.StringValue>(1, _omitFieldNames ? '' : 'account',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(2, _omitFieldNames ? '' : 'password',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(3, _omitFieldNames ? '' : 'faceURL',
        protoName: 'faceURL', subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(4, _omitFieldNames ? '' : 'nickname',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.Int32Value>(6, _omitFieldNames ? '' : 'level',
        subBuilder: $0.Int32Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminUpdateInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminUpdateInfoReq copyWith(void Function(AdminUpdateInfoReq) updates) =>
      super.copyWith((message) => updates(message as AdminUpdateInfoReq))
          as AdminUpdateInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdminUpdateInfoReq create() => AdminUpdateInfoReq._();
  @$core.override
  AdminUpdateInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdminUpdateInfoReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdminUpdateInfoReq>(create);
  static AdminUpdateInfoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $0.StringValue get account => $_getN(0);
  @$pb.TagNumber(1)
  set account($0.StringValue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.StringValue ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.StringValue get password => $_getN(1);
  @$pb.TagNumber(2)
  set password($0.StringValue value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.StringValue ensurePassword() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.StringValue get faceURL => $_getN(2);
  @$pb.TagNumber(3)
  set faceURL($0.StringValue value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFaceURL() => $_has(2);
  @$pb.TagNumber(3)
  void clearFaceURL() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.StringValue ensureFaceURL() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.StringValue get nickname => $_getN(3);
  @$pb.TagNumber(4)
  set nickname($0.StringValue value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNickname() => $_has(3);
  @$pb.TagNumber(4)
  void clearNickname() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.StringValue ensureNickname() => $_ensure(3);

  @$pb.TagNumber(6)
  $0.Int32Value get level => $_getN(4);
  @$pb.TagNumber(6)
  set level($0.Int32Value value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLevel() => $_has(4);
  @$pb.TagNumber(6)
  void clearLevel() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Int32Value ensureLevel() => $_ensure(4);
}

class AdminUpdateInfoResp extends $pb.GeneratedMessage {
  factory AdminUpdateInfoResp({
    $core.String? userID,
    $core.String? nickname,
    $core.String? faceURL,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    return result;
  }

  AdminUpdateInfoResp._();

  factory AdminUpdateInfoResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdminUpdateInfoResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdminUpdateInfoResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'nickname')
    ..aOS(3, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminUpdateInfoResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdminUpdateInfoResp copyWith(void Function(AdminUpdateInfoResp) updates) =>
      super.copyWith((message) => updates(message as AdminUpdateInfoResp))
          as AdminUpdateInfoResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdminUpdateInfoResp create() => AdminUpdateInfoResp._();
  @$core.override
  AdminUpdateInfoResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdminUpdateInfoResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdminUpdateInfoResp>(create);
  static AdminUpdateInfoResp? _defaultInstance;

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
}

class ChangePasswordReq extends $pb.GeneratedMessage {
  factory ChangePasswordReq({
    $core.String? password,
  }) {
    final result = create();
    if (password != null) result.password = password;
    return result;
  }

  ChangePasswordReq._();

  factory ChangePasswordReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangePasswordReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePasswordReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordReq copyWith(void Function(ChangePasswordReq) updates) =>
      super.copyWith((message) => updates(message as ChangePasswordReq))
          as ChangePasswordReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePasswordReq create() => ChangePasswordReq._();
  @$core.override
  ChangePasswordReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangePasswordReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePasswordReq>(create);
  static ChangePasswordReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get password => $_getSZ(0);
  @$pb.TagNumber(1)
  set password($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassword() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassword() => $_clearField(1);
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePasswordResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePasswordResp copyWith(void Function(ChangePasswordResp) updates) =>
      super.copyWith((message) => updates(message as ChangePasswordResp))
          as ChangePasswordResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangePasswordResp create() => ChangePasswordResp._();
  @$core.override
  ChangePasswordResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangePasswordResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePasswordResp>(create);
  static ChangePasswordResp? _defaultInstance;
}

class GetAdminInfoReq extends $pb.GeneratedMessage {
  factory GetAdminInfoReq() => create();

  GetAdminInfoReq._();

  factory GetAdminInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAdminInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAdminInfoReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAdminInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAdminInfoReq copyWith(void Function(GetAdminInfoReq) updates) =>
      super.copyWith((message) => updates(message as GetAdminInfoReq))
          as GetAdminInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAdminInfoReq create() => GetAdminInfoReq._();
  @$core.override
  GetAdminInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAdminInfoReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAdminInfoReq>(create);
  static GetAdminInfoReq? _defaultInstance;
}

class ChangeAdminPasswordReq extends $pb.GeneratedMessage {
  factory ChangeAdminPasswordReq({
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

  ChangeAdminPasswordReq._();

  factory ChangeAdminPasswordReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeAdminPasswordReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeAdminPasswordReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'currentPassword',
        protoName: 'currentPassword')
    ..aOS(3, _omitFieldNames ? '' : 'newPassword', protoName: 'newPassword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeAdminPasswordReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeAdminPasswordReq copyWith(
          void Function(ChangeAdminPasswordReq) updates) =>
      super.copyWith((message) => updates(message as ChangeAdminPasswordReq))
          as ChangeAdminPasswordReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeAdminPasswordReq create() => ChangeAdminPasswordReq._();
  @$core.override
  ChangeAdminPasswordReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeAdminPasswordReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeAdminPasswordReq>(create);
  static ChangeAdminPasswordReq? _defaultInstance;

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

class ChangeAdminPasswordResp extends $pb.GeneratedMessage {
  factory ChangeAdminPasswordResp() => create();

  ChangeAdminPasswordResp._();

  factory ChangeAdminPasswordResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeAdminPasswordResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeAdminPasswordResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeAdminPasswordResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeAdminPasswordResp copyWith(
          void Function(ChangeAdminPasswordResp) updates) =>
      super.copyWith((message) => updates(message as ChangeAdminPasswordResp))
          as ChangeAdminPasswordResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeAdminPasswordResp create() => ChangeAdminPasswordResp._();
  @$core.override
  ChangeAdminPasswordResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeAdminPasswordResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeAdminPasswordResp>(create);
  static ChangeAdminPasswordResp? _defaultInstance;
}

class DelAdminAccountReq extends $pb.GeneratedMessage {
  factory DelAdminAccountReq({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  DelAdminAccountReq._();

  factory DelAdminAccountReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelAdminAccountReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelAdminAccountReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelAdminAccountReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelAdminAccountReq copyWith(void Function(DelAdminAccountReq) updates) =>
      super.copyWith((message) => updates(message as DelAdminAccountReq))
          as DelAdminAccountReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelAdminAccountReq create() => DelAdminAccountReq._();
  @$core.override
  DelAdminAccountReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelAdminAccountReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelAdminAccountReq>(create);
  static DelAdminAccountReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class DelAdminAccountResp extends $pb.GeneratedMessage {
  factory DelAdminAccountResp() => create();

  DelAdminAccountResp._();

  factory DelAdminAccountResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelAdminAccountResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelAdminAccountResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelAdminAccountResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelAdminAccountResp copyWith(void Function(DelAdminAccountResp) updates) =>
      super.copyWith((message) => updates(message as DelAdminAccountResp))
          as DelAdminAccountResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelAdminAccountResp create() => DelAdminAccountResp._();
  @$core.override
  DelAdminAccountResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelAdminAccountResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelAdminAccountResp>(create);
  static DelAdminAccountResp? _defaultInstance;
}

class SearchAdminAccountReq extends $pb.GeneratedMessage {
  factory SearchAdminAccountReq({
    $1.RequestPagination? pagination,
  }) {
    final result = create();
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchAdminAccountReq._();

  factory SearchAdminAccountReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchAdminAccountReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchAdminAccountReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOM<$1.RequestPagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.RequestPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchAdminAccountReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchAdminAccountReq copyWith(
          void Function(SearchAdminAccountReq) updates) =>
      super.copyWith((message) => updates(message as SearchAdminAccountReq))
          as SearchAdminAccountReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchAdminAccountReq create() => SearchAdminAccountReq._();
  @$core.override
  SearchAdminAccountReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchAdminAccountReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchAdminAccountReq>(create);
  static SearchAdminAccountReq? _defaultInstance;

  @$pb.TagNumber(2)
  $1.RequestPagination get pagination => $_getN(0);
  @$pb.TagNumber(2)
  set pagination($1.RequestPagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.RequestPagination ensurePagination() => $_ensure(0);
}

class SearchAdminAccountResp extends $pb.GeneratedMessage {
  factory SearchAdminAccountResp({
    $core.int? total,
    $core.Iterable<GetAdminInfoResp>? adminAccounts,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (adminAccounts != null) result.adminAccounts.addAll(adminAccounts);
    return result;
  }

  SearchAdminAccountResp._();

  factory SearchAdminAccountResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchAdminAccountResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchAdminAccountResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPM<GetAdminInfoResp>(2, _omitFieldNames ? '' : 'adminAccounts',
        protoName: 'adminAccounts', subBuilder: GetAdminInfoResp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchAdminAccountResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchAdminAccountResp copyWith(
          void Function(SearchAdminAccountResp) updates) =>
      super.copyWith((message) => updates(message as SearchAdminAccountResp))
          as SearchAdminAccountResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchAdminAccountResp create() => SearchAdminAccountResp._();
  @$core.override
  SearchAdminAccountResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchAdminAccountResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchAdminAccountResp>(create);
  static SearchAdminAccountResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<GetAdminInfoResp> get adminAccounts => $_getList(1);
}

class GetAdminInfoResp extends $pb.GeneratedMessage {
  factory GetAdminInfoResp({
    $core.String? account,
    $core.String? password,
    $core.String? faceURL,
    $core.String? nickname,
    $core.String? userID,
    $core.int? level,
    $fixnum.Int64? createTime,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (password != null) result.password = password;
    if (faceURL != null) result.faceURL = faceURL;
    if (nickname != null) result.nickname = nickname;
    if (userID != null) result.userID = userID;
    if (level != null) result.level = level;
    if (createTime != null) result.createTime = createTime;
    return result;
  }

  GetAdminInfoResp._();

  factory GetAdminInfoResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAdminInfoResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAdminInfoResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'account')
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..aOS(4, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aOS(5, _omitFieldNames ? '' : 'nickname')
    ..aOS(6, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aI(7, _omitFieldNames ? '' : 'level')
    ..aInt64(8, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAdminInfoResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAdminInfoResp copyWith(void Function(GetAdminInfoResp) updates) =>
      super.copyWith((message) => updates(message as GetAdminInfoResp))
          as GetAdminInfoResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAdminInfoResp create() => GetAdminInfoResp._();
  @$core.override
  GetAdminInfoResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAdminInfoResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAdminInfoResp>(create);
  static GetAdminInfoResp? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get account => $_getSZ(0);
  @$pb.TagNumber(2)
  set account($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(2)
  void clearAccount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(3)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(3)
  void clearPassword() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get faceURL => $_getSZ(2);
  @$pb.TagNumber(4)
  set faceURL($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasFaceURL() => $_has(2);
  @$pb.TagNumber(4)
  void clearFaceURL() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get nickname => $_getSZ(3);
  @$pb.TagNumber(5)
  set nickname($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasNickname() => $_has(3);
  @$pb.TagNumber(5)
  void clearNickname() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get userID => $_getSZ(4);
  @$pb.TagNumber(6)
  set userID($core.String value) => $_setString(4, value);
  @$pb.TagNumber(6)
  $core.bool hasUserID() => $_has(4);
  @$pb.TagNumber(6)
  void clearUserID() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get level => $_getIZ(5);
  @$pb.TagNumber(7)
  set level($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(7)
  $core.bool hasLevel() => $_has(5);
  @$pb.TagNumber(7)
  void clearLevel() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createTime => $_getI64(6);
  @$pb.TagNumber(8)
  set createTime($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(8)
  $core.bool hasCreateTime() => $_has(6);
  @$pb.TagNumber(8)
  void clearCreateTime() => $_clearField(8);
}

class AddDefaultFriendReq extends $pb.GeneratedMessage {
  factory AddDefaultFriendReq({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  AddDefaultFriendReq._();

  factory AddDefaultFriendReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddDefaultFriendReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddDefaultFriendReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddDefaultFriendReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddDefaultFriendReq copyWith(void Function(AddDefaultFriendReq) updates) =>
      super.copyWith((message) => updates(message as AddDefaultFriendReq))
          as AddDefaultFriendReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddDefaultFriendReq create() => AddDefaultFriendReq._();
  @$core.override
  AddDefaultFriendReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddDefaultFriendReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddDefaultFriendReq>(create);
  static AddDefaultFriendReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class AddDefaultFriendResp extends $pb.GeneratedMessage {
  factory AddDefaultFriendResp() => create();

  AddDefaultFriendResp._();

  factory AddDefaultFriendResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddDefaultFriendResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddDefaultFriendResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddDefaultFriendResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddDefaultFriendResp copyWith(void Function(AddDefaultFriendResp) updates) =>
      super.copyWith((message) => updates(message as AddDefaultFriendResp))
          as AddDefaultFriendResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddDefaultFriendResp create() => AddDefaultFriendResp._();
  @$core.override
  AddDefaultFriendResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddDefaultFriendResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddDefaultFriendResp>(create);
  static AddDefaultFriendResp? _defaultInstance;
}

class DelDefaultFriendReq extends $pb.GeneratedMessage {
  factory DelDefaultFriendReq({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  DelDefaultFriendReq._();

  factory DelDefaultFriendReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelDefaultFriendReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelDefaultFriendReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelDefaultFriendReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelDefaultFriendReq copyWith(void Function(DelDefaultFriendReq) updates) =>
      super.copyWith((message) => updates(message as DelDefaultFriendReq))
          as DelDefaultFriendReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelDefaultFriendReq create() => DelDefaultFriendReq._();
  @$core.override
  DelDefaultFriendReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelDefaultFriendReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelDefaultFriendReq>(create);
  static DelDefaultFriendReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class DelDefaultFriendResp extends $pb.GeneratedMessage {
  factory DelDefaultFriendResp() => create();

  DelDefaultFriendResp._();

  factory DelDefaultFriendResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelDefaultFriendResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelDefaultFriendResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelDefaultFriendResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelDefaultFriendResp copyWith(void Function(DelDefaultFriendResp) updates) =>
      super.copyWith((message) => updates(message as DelDefaultFriendResp))
          as DelDefaultFriendResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelDefaultFriendResp create() => DelDefaultFriendResp._();
  @$core.override
  DelDefaultFriendResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelDefaultFriendResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelDefaultFriendResp>(create);
  static DelDefaultFriendResp? _defaultInstance;
}

class FindDefaultFriendReq extends $pb.GeneratedMessage {
  factory FindDefaultFriendReq() => create();

  FindDefaultFriendReq._();

  factory FindDefaultFriendReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindDefaultFriendReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindDefaultFriendReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindDefaultFriendReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindDefaultFriendReq copyWith(void Function(FindDefaultFriendReq) updates) =>
      super.copyWith((message) => updates(message as FindDefaultFriendReq))
          as FindDefaultFriendReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindDefaultFriendReq create() => FindDefaultFriendReq._();
  @$core.override
  FindDefaultFriendReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindDefaultFriendReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindDefaultFriendReq>(create);
  static FindDefaultFriendReq? _defaultInstance;
}

class FindDefaultFriendResp extends $pb.GeneratedMessage {
  factory FindDefaultFriendResp({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  FindDefaultFriendResp._();

  factory FindDefaultFriendResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindDefaultFriendResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindDefaultFriendResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindDefaultFriendResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindDefaultFriendResp copyWith(
          void Function(FindDefaultFriendResp) updates) =>
      super.copyWith((message) => updates(message as FindDefaultFriendResp))
          as FindDefaultFriendResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindDefaultFriendResp create() => FindDefaultFriendResp._();
  @$core.override
  FindDefaultFriendResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindDefaultFriendResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindDefaultFriendResp>(create);
  static FindDefaultFriendResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class SearchDefaultFriendReq extends $pb.GeneratedMessage {
  factory SearchDefaultFriendReq({
    $core.String? keyword,
    $1.RequestPagination? pagination,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchDefaultFriendReq._();

  factory SearchDefaultFriendReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchDefaultFriendReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchDefaultFriendReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aOM<$1.RequestPagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.RequestPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDefaultFriendReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDefaultFriendReq copyWith(
          void Function(SearchDefaultFriendReq) updates) =>
      super.copyWith((message) => updates(message as SearchDefaultFriendReq))
          as SearchDefaultFriendReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchDefaultFriendReq create() => SearchDefaultFriendReq._();
  @$core.override
  SearchDefaultFriendReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchDefaultFriendReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchDefaultFriendReq>(create);
  static SearchDefaultFriendReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.RequestPagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.RequestPagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.RequestPagination ensurePagination() => $_ensure(1);
}

class DefaultFriendAttribute extends $pb.GeneratedMessage {
  factory DefaultFriendAttribute({
    $core.String? userID,
    $fixnum.Int64? createTime,
    $2.UserPublicInfo? user,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (createTime != null) result.createTime = createTime;
    if (user != null) result.user = user;
    return result;
  }

  DefaultFriendAttribute._();

  factory DefaultFriendAttribute.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefaultFriendAttribute.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefaultFriendAttribute',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aInt64(2, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aOM<$2.UserPublicInfo>(3, _omitFieldNames ? '' : 'user',
        subBuilder: $2.UserPublicInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefaultFriendAttribute clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefaultFriendAttribute copyWith(
          void Function(DefaultFriendAttribute) updates) =>
      super.copyWith((message) => updates(message as DefaultFriendAttribute))
          as DefaultFriendAttribute;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefaultFriendAttribute create() => DefaultFriendAttribute._();
  @$core.override
  DefaultFriendAttribute createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefaultFriendAttribute getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefaultFriendAttribute>(create);
  static DefaultFriendAttribute? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get createTime => $_getI64(1);
  @$pb.TagNumber(2)
  set createTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreateTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreateTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.UserPublicInfo get user => $_getN(2);
  @$pb.TagNumber(3)
  set user($2.UserPublicInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.UserPublicInfo ensureUser() => $_ensure(2);
}

class SearchDefaultFriendResp extends $pb.GeneratedMessage {
  factory SearchDefaultFriendResp({
    $core.int? total,
    $core.Iterable<DefaultFriendAttribute>? users,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (users != null) result.users.addAll(users);
    return result;
  }

  SearchDefaultFriendResp._();

  factory SearchDefaultFriendResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchDefaultFriendResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchDefaultFriendResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPM<DefaultFriendAttribute>(2, _omitFieldNames ? '' : 'users',
        subBuilder: DefaultFriendAttribute.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDefaultFriendResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDefaultFriendResp copyWith(
          void Function(SearchDefaultFriendResp) updates) =>
      super.copyWith((message) => updates(message as SearchDefaultFriendResp))
          as SearchDefaultFriendResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchDefaultFriendResp create() => SearchDefaultFriendResp._();
  @$core.override
  SearchDefaultFriendResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchDefaultFriendResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchDefaultFriendResp>(create);
  static SearchDefaultFriendResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<DefaultFriendAttribute> get users => $_getList(1);
}

class AddDefaultGroupReq extends $pb.GeneratedMessage {
  factory AddDefaultGroupReq({
    $core.Iterable<$core.String>? groupIDs,
  }) {
    final result = create();
    if (groupIDs != null) result.groupIDs.addAll(groupIDs);
    return result;
  }

  AddDefaultGroupReq._();

  factory AddDefaultGroupReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddDefaultGroupReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddDefaultGroupReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'groupIDs', protoName: 'groupIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddDefaultGroupReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddDefaultGroupReq copyWith(void Function(AddDefaultGroupReq) updates) =>
      super.copyWith((message) => updates(message as AddDefaultGroupReq))
          as AddDefaultGroupReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddDefaultGroupReq create() => AddDefaultGroupReq._();
  @$core.override
  AddDefaultGroupReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddDefaultGroupReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddDefaultGroupReq>(create);
  static AddDefaultGroupReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get groupIDs => $_getList(0);
}

class AddDefaultGroupResp extends $pb.GeneratedMessage {
  factory AddDefaultGroupResp() => create();

  AddDefaultGroupResp._();

  factory AddDefaultGroupResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddDefaultGroupResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddDefaultGroupResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddDefaultGroupResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddDefaultGroupResp copyWith(void Function(AddDefaultGroupResp) updates) =>
      super.copyWith((message) => updates(message as AddDefaultGroupResp))
          as AddDefaultGroupResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddDefaultGroupResp create() => AddDefaultGroupResp._();
  @$core.override
  AddDefaultGroupResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddDefaultGroupResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddDefaultGroupResp>(create);
  static AddDefaultGroupResp? _defaultInstance;
}

class DelDefaultGroupReq extends $pb.GeneratedMessage {
  factory DelDefaultGroupReq({
    $core.Iterable<$core.String>? groupIDs,
  }) {
    final result = create();
    if (groupIDs != null) result.groupIDs.addAll(groupIDs);
    return result;
  }

  DelDefaultGroupReq._();

  factory DelDefaultGroupReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelDefaultGroupReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelDefaultGroupReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'groupIDs', protoName: 'groupIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelDefaultGroupReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelDefaultGroupReq copyWith(void Function(DelDefaultGroupReq) updates) =>
      super.copyWith((message) => updates(message as DelDefaultGroupReq))
          as DelDefaultGroupReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelDefaultGroupReq create() => DelDefaultGroupReq._();
  @$core.override
  DelDefaultGroupReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelDefaultGroupReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelDefaultGroupReq>(create);
  static DelDefaultGroupReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get groupIDs => $_getList(0);
}

class DelDefaultGroupResp extends $pb.GeneratedMessage {
  factory DelDefaultGroupResp() => create();

  DelDefaultGroupResp._();

  factory DelDefaultGroupResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelDefaultGroupResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelDefaultGroupResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelDefaultGroupResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelDefaultGroupResp copyWith(void Function(DelDefaultGroupResp) updates) =>
      super.copyWith((message) => updates(message as DelDefaultGroupResp))
          as DelDefaultGroupResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelDefaultGroupResp create() => DelDefaultGroupResp._();
  @$core.override
  DelDefaultGroupResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelDefaultGroupResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelDefaultGroupResp>(create);
  static DelDefaultGroupResp? _defaultInstance;
}

class FindDefaultGroupReq extends $pb.GeneratedMessage {
  factory FindDefaultGroupReq() => create();

  FindDefaultGroupReq._();

  factory FindDefaultGroupReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindDefaultGroupReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindDefaultGroupReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindDefaultGroupReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindDefaultGroupReq copyWith(void Function(FindDefaultGroupReq) updates) =>
      super.copyWith((message) => updates(message as FindDefaultGroupReq))
          as FindDefaultGroupReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindDefaultGroupReq create() => FindDefaultGroupReq._();
  @$core.override
  FindDefaultGroupReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindDefaultGroupReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindDefaultGroupReq>(create);
  static FindDefaultGroupReq? _defaultInstance;
}

class FindDefaultGroupResp extends $pb.GeneratedMessage {
  factory FindDefaultGroupResp({
    $core.Iterable<$core.String>? groupIDs,
  }) {
    final result = create();
    if (groupIDs != null) result.groupIDs.addAll(groupIDs);
    return result;
  }

  FindDefaultGroupResp._();

  factory FindDefaultGroupResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindDefaultGroupResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindDefaultGroupResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'groupIDs', protoName: 'groupIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindDefaultGroupResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindDefaultGroupResp copyWith(void Function(FindDefaultGroupResp) updates) =>
      super.copyWith((message) => updates(message as FindDefaultGroupResp))
          as FindDefaultGroupResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindDefaultGroupResp create() => FindDefaultGroupResp._();
  @$core.override
  FindDefaultGroupResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindDefaultGroupResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindDefaultGroupResp>(create);
  static FindDefaultGroupResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get groupIDs => $_getList(0);
}

class SearchDefaultGroupReq extends $pb.GeneratedMessage {
  factory SearchDefaultGroupReq({
    $core.String? keyword,
    $1.RequestPagination? pagination,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchDefaultGroupReq._();

  factory SearchDefaultGroupReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchDefaultGroupReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchDefaultGroupReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aOM<$1.RequestPagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.RequestPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDefaultGroupReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDefaultGroupReq copyWith(
          void Function(SearchDefaultGroupReq) updates) =>
      super.copyWith((message) => updates(message as SearchDefaultGroupReq))
          as SearchDefaultGroupReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchDefaultGroupReq create() => SearchDefaultGroupReq._();
  @$core.override
  SearchDefaultGroupReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchDefaultGroupReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchDefaultGroupReq>(create);
  static SearchDefaultGroupReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.RequestPagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.RequestPagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.RequestPagination ensurePagination() => $_ensure(1);
}

class GroupAttribute extends $pb.GeneratedMessage {
  factory GroupAttribute({
    $core.String? groupID,
    $fixnum.Int64? createTime,
    $1.GroupInfo? group,
  }) {
    final result = create();
    if (groupID != null) result.groupID = groupID;
    if (createTime != null) result.createTime = createTime;
    if (group != null) result.group = group;
    return result;
  }

  GroupAttribute._();

  factory GroupAttribute.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupAttribute.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupAttribute',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupID', protoName: 'groupID')
    ..aInt64(2, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aOM<$1.GroupInfo>(3, _omitFieldNames ? '' : 'group',
        subBuilder: $1.GroupInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupAttribute clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupAttribute copyWith(void Function(GroupAttribute) updates) =>
      super.copyWith((message) => updates(message as GroupAttribute))
          as GroupAttribute;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupAttribute create() => GroupAttribute._();
  @$core.override
  GroupAttribute createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupAttribute getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupAttribute>(create);
  static GroupAttribute? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupID => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupID() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get createTime => $_getI64(1);
  @$pb.TagNumber(2)
  set createTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreateTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreateTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.GroupInfo get group => $_getN(2);
  @$pb.TagNumber(3)
  set group($1.GroupInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGroup() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroup() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.GroupInfo ensureGroup() => $_ensure(2);
}

class SearchDefaultGroupResp extends $pb.GeneratedMessage {
  factory SearchDefaultGroupResp({
    $core.int? total,
    $core.Iterable<$core.String>? groupIDs,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (groupIDs != null) result.groupIDs.addAll(groupIDs);
    return result;
  }

  SearchDefaultGroupResp._();

  factory SearchDefaultGroupResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchDefaultGroupResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchDefaultGroupResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPS(2, _omitFieldNames ? '' : 'groupIDs', protoName: 'groupIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDefaultGroupResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchDefaultGroupResp copyWith(
          void Function(SearchDefaultGroupResp) updates) =>
      super.copyWith((message) => updates(message as SearchDefaultGroupResp))
          as SearchDefaultGroupResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchDefaultGroupResp create() => SearchDefaultGroupResp._();
  @$core.override
  SearchDefaultGroupResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchDefaultGroupResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchDefaultGroupResp>(create);
  static SearchDefaultGroupResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get groupIDs => $_getList(1);
}

class AddInvitationCodeReq extends $pb.GeneratedMessage {
  factory AddInvitationCodeReq({
    $core.Iterable<$core.String>? codes,
  }) {
    final result = create();
    if (codes != null) result.codes.addAll(codes);
    return result;
  }

  AddInvitationCodeReq._();

  factory AddInvitationCodeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddInvitationCodeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddInvitationCodeReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'codes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddInvitationCodeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddInvitationCodeReq copyWith(void Function(AddInvitationCodeReq) updates) =>
      super.copyWith((message) => updates(message as AddInvitationCodeReq))
          as AddInvitationCodeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddInvitationCodeReq create() => AddInvitationCodeReq._();
  @$core.override
  AddInvitationCodeReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddInvitationCodeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddInvitationCodeReq>(create);
  static AddInvitationCodeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get codes => $_getList(0);
}

class AddInvitationCodeResp extends $pb.GeneratedMessage {
  factory AddInvitationCodeResp() => create();

  AddInvitationCodeResp._();

  factory AddInvitationCodeResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddInvitationCodeResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddInvitationCodeResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddInvitationCodeResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddInvitationCodeResp copyWith(
          void Function(AddInvitationCodeResp) updates) =>
      super.copyWith((message) => updates(message as AddInvitationCodeResp))
          as AddInvitationCodeResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddInvitationCodeResp create() => AddInvitationCodeResp._();
  @$core.override
  AddInvitationCodeResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddInvitationCodeResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddInvitationCodeResp>(create);
  static AddInvitationCodeResp? _defaultInstance;
}

class GenInvitationCodeReq extends $pb.GeneratedMessage {
  factory GenInvitationCodeReq({
    $core.int? len,
    $core.int? num,
    $core.String? chars,
  }) {
    final result = create();
    if (len != null) result.len = len;
    if (num != null) result.num = num;
    if (chars != null) result.chars = chars;
    return result;
  }

  GenInvitationCodeReq._();

  factory GenInvitationCodeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GenInvitationCodeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenInvitationCodeReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'len')
    ..aI(2, _omitFieldNames ? '' : 'num')
    ..aOS(3, _omitFieldNames ? '' : 'chars')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenInvitationCodeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenInvitationCodeReq copyWith(void Function(GenInvitationCodeReq) updates) =>
      super.copyWith((message) => updates(message as GenInvitationCodeReq))
          as GenInvitationCodeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenInvitationCodeReq create() => GenInvitationCodeReq._();
  @$core.override
  GenInvitationCodeReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GenInvitationCodeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenInvitationCodeReq>(create);
  static GenInvitationCodeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get len => $_getIZ(0);
  @$pb.TagNumber(1)
  set len($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLen() => $_has(0);
  @$pb.TagNumber(1)
  void clearLen() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get num => $_getIZ(1);
  @$pb.TagNumber(2)
  set num($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNum() => $_has(1);
  @$pb.TagNumber(2)
  void clearNum() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get chars => $_getSZ(2);
  @$pb.TagNumber(3)
  set chars($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChars() => $_has(2);
  @$pb.TagNumber(3)
  void clearChars() => $_clearField(3);
}

class GenInvitationCodeResp extends $pb.GeneratedMessage {
  factory GenInvitationCodeResp() => create();

  GenInvitationCodeResp._();

  factory GenInvitationCodeResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GenInvitationCodeResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenInvitationCodeResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenInvitationCodeResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenInvitationCodeResp copyWith(
          void Function(GenInvitationCodeResp) updates) =>
      super.copyWith((message) => updates(message as GenInvitationCodeResp))
          as GenInvitationCodeResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenInvitationCodeResp create() => GenInvitationCodeResp._();
  @$core.override
  GenInvitationCodeResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GenInvitationCodeResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenInvitationCodeResp>(create);
  static GenInvitationCodeResp? _defaultInstance;
}

class FindInvitationCodeReq extends $pb.GeneratedMessage {
  factory FindInvitationCodeReq({
    $core.Iterable<$core.String>? codes,
  }) {
    final result = create();
    if (codes != null) result.codes.addAll(codes);
    return result;
  }

  FindInvitationCodeReq._();

  factory FindInvitationCodeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindInvitationCodeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindInvitationCodeReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'codes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindInvitationCodeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindInvitationCodeReq copyWith(
          void Function(FindInvitationCodeReq) updates) =>
      super.copyWith((message) => updates(message as FindInvitationCodeReq))
          as FindInvitationCodeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindInvitationCodeReq create() => FindInvitationCodeReq._();
  @$core.override
  FindInvitationCodeReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindInvitationCodeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindInvitationCodeReq>(create);
  static FindInvitationCodeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get codes => $_getList(0);
}

class FindInvitationCodeResp extends $pb.GeneratedMessage {
  factory FindInvitationCodeResp({
    $core.Iterable<InvitationRegister>? codes,
  }) {
    final result = create();
    if (codes != null) result.codes.addAll(codes);
    return result;
  }

  FindInvitationCodeResp._();

  factory FindInvitationCodeResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindInvitationCodeResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindInvitationCodeResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPM<InvitationRegister>(1, _omitFieldNames ? '' : 'codes',
        subBuilder: InvitationRegister.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindInvitationCodeResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindInvitationCodeResp copyWith(
          void Function(FindInvitationCodeResp) updates) =>
      super.copyWith((message) => updates(message as FindInvitationCodeResp))
          as FindInvitationCodeResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindInvitationCodeResp create() => FindInvitationCodeResp._();
  @$core.override
  FindInvitationCodeResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindInvitationCodeResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindInvitationCodeResp>(create);
  static FindInvitationCodeResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InvitationRegister> get codes => $_getList(0);
}

class UseInvitationCodeReq extends $pb.GeneratedMessage {
  factory UseInvitationCodeReq({
    $core.String? code,
    $core.String? userID,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (userID != null) result.userID = userID;
    return result;
  }

  UseInvitationCodeReq._();

  factory UseInvitationCodeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UseInvitationCodeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UseInvitationCodeReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UseInvitationCodeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UseInvitationCodeReq copyWith(void Function(UseInvitationCodeReq) updates) =>
      super.copyWith((message) => updates(message as UseInvitationCodeReq))
          as UseInvitationCodeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UseInvitationCodeReq create() => UseInvitationCodeReq._();
  @$core.override
  UseInvitationCodeReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UseInvitationCodeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UseInvitationCodeReq>(create);
  static UseInvitationCodeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userID => $_getSZ(1);
  @$pb.TagNumber(2)
  set userID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);
}

class UseInvitationCodeResp extends $pb.GeneratedMessage {
  factory UseInvitationCodeResp() => create();

  UseInvitationCodeResp._();

  factory UseInvitationCodeResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UseInvitationCodeResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UseInvitationCodeResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UseInvitationCodeResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UseInvitationCodeResp copyWith(
          void Function(UseInvitationCodeResp) updates) =>
      super.copyWith((message) => updates(message as UseInvitationCodeResp))
          as UseInvitationCodeResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UseInvitationCodeResp create() => UseInvitationCodeResp._();
  @$core.override
  UseInvitationCodeResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UseInvitationCodeResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UseInvitationCodeResp>(create);
  static UseInvitationCodeResp? _defaultInstance;
}

class DelInvitationCodeReq extends $pb.GeneratedMessage {
  factory DelInvitationCodeReq({
    $core.Iterable<$core.String>? codes,
  }) {
    final result = create();
    if (codes != null) result.codes.addAll(codes);
    return result;
  }

  DelInvitationCodeReq._();

  factory DelInvitationCodeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelInvitationCodeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelInvitationCodeReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'codes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelInvitationCodeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelInvitationCodeReq copyWith(void Function(DelInvitationCodeReq) updates) =>
      super.copyWith((message) => updates(message as DelInvitationCodeReq))
          as DelInvitationCodeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelInvitationCodeReq create() => DelInvitationCodeReq._();
  @$core.override
  DelInvitationCodeReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelInvitationCodeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelInvitationCodeReq>(create);
  static DelInvitationCodeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get codes => $_getList(0);
}

class DelInvitationCodeResp extends $pb.GeneratedMessage {
  factory DelInvitationCodeResp() => create();

  DelInvitationCodeResp._();

  factory DelInvitationCodeResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelInvitationCodeResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelInvitationCodeResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelInvitationCodeResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelInvitationCodeResp copyWith(
          void Function(DelInvitationCodeResp) updates) =>
      super.copyWith((message) => updates(message as DelInvitationCodeResp))
          as DelInvitationCodeResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelInvitationCodeResp create() => DelInvitationCodeResp._();
  @$core.override
  DelInvitationCodeResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelInvitationCodeResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelInvitationCodeResp>(create);
  static DelInvitationCodeResp? _defaultInstance;
}

class InvitationRegister extends $pb.GeneratedMessage {
  factory InvitationRegister({
    $core.String? invitationCode,
    $fixnum.Int64? createTime,
    $core.String? usedUserID,
    $2.UserPublicInfo? usedUser,
  }) {
    final result = create();
    if (invitationCode != null) result.invitationCode = invitationCode;
    if (createTime != null) result.createTime = createTime;
    if (usedUserID != null) result.usedUserID = usedUserID;
    if (usedUser != null) result.usedUser = usedUser;
    return result;
  }

  InvitationRegister._();

  factory InvitationRegister.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InvitationRegister.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvitationRegister',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'invitationCode',
        protoName: 'invitationCode')
    ..aInt64(2, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aOS(3, _omitFieldNames ? '' : 'usedUserID', protoName: 'usedUserID')
    ..aOM<$2.UserPublicInfo>(4, _omitFieldNames ? '' : 'usedUser',
        protoName: 'usedUser', subBuilder: $2.UserPublicInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvitationRegister clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvitationRegister copyWith(void Function(InvitationRegister) updates) =>
      super.copyWith((message) => updates(message as InvitationRegister))
          as InvitationRegister;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvitationRegister create() => InvitationRegister._();
  @$core.override
  InvitationRegister createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InvitationRegister getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvitationRegister>(create);
  static InvitationRegister? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get invitationCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set invitationCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInvitationCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvitationCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get createTime => $_getI64(1);
  @$pb.TagNumber(2)
  set createTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreateTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreateTime() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get usedUserID => $_getSZ(2);
  @$pb.TagNumber(3)
  set usedUserID($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUsedUserID() => $_has(2);
  @$pb.TagNumber(3)
  void clearUsedUserID() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.UserPublicInfo get usedUser => $_getN(3);
  @$pb.TagNumber(4)
  set usedUser($2.UserPublicInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUsedUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUsedUser() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.UserPublicInfo ensureUsedUser() => $_ensure(3);
}

class SearchInvitationCodeReq extends $pb.GeneratedMessage {
  factory SearchInvitationCodeReq({
    $core.int? status,
    $core.Iterable<$core.String>? userIDs,
    $core.Iterable<$core.String>? codes,
    $core.String? keyword,
    $1.RequestPagination? pagination,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (userIDs != null) result.userIDs.addAll(userIDs);
    if (codes != null) result.codes.addAll(codes);
    if (keyword != null) result.keyword = keyword;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchInvitationCodeReq._();

  factory SearchInvitationCodeReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchInvitationCodeReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchInvitationCodeReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'status')
    ..pPS(2, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..pPS(3, _omitFieldNames ? '' : 'codes')
    ..aOS(4, _omitFieldNames ? '' : 'keyword')
    ..aOM<$1.RequestPagination>(5, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.RequestPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchInvitationCodeReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchInvitationCodeReq copyWith(
          void Function(SearchInvitationCodeReq) updates) =>
      super.copyWith((message) => updates(message as SearchInvitationCodeReq))
          as SearchInvitationCodeReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchInvitationCodeReq create() => SearchInvitationCodeReq._();
  @$core.override
  SearchInvitationCodeReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchInvitationCodeReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchInvitationCodeReq>(create);
  static SearchInvitationCodeReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get userIDs => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get codes => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get keyword => $_getSZ(3);
  @$pb.TagNumber(4)
  set keyword($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKeyword() => $_has(3);
  @$pb.TagNumber(4)
  void clearKeyword() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.RequestPagination get pagination => $_getN(4);
  @$pb.TagNumber(5)
  set pagination($1.RequestPagination value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPagination() => $_has(4);
  @$pb.TagNumber(5)
  void clearPagination() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.RequestPagination ensurePagination() => $_ensure(4);
}

class SearchInvitationCodeResp extends $pb.GeneratedMessage {
  factory SearchInvitationCodeResp({
    $core.int? total,
    $core.Iterable<InvitationRegister>? list,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (list != null) result.list.addAll(list);
    return result;
  }

  SearchInvitationCodeResp._();

  factory SearchInvitationCodeResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchInvitationCodeResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchInvitationCodeResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPM<InvitationRegister>(2, _omitFieldNames ? '' : 'list',
        subBuilder: InvitationRegister.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchInvitationCodeResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchInvitationCodeResp copyWith(
          void Function(SearchInvitationCodeResp) updates) =>
      super.copyWith((message) => updates(message as SearchInvitationCodeResp))
          as SearchInvitationCodeResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchInvitationCodeResp create() => SearchInvitationCodeResp._();
  @$core.override
  SearchInvitationCodeResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchInvitationCodeResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchInvitationCodeResp>(create);
  static SearchInvitationCodeResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<InvitationRegister> get list => $_getList(1);
}

class SearchUserIPLimitLoginReq extends $pb.GeneratedMessage {
  factory SearchUserIPLimitLoginReq({
    $core.String? keyword,
    $1.RequestPagination? pagination,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchUserIPLimitLoginReq._();

  factory SearchUserIPLimitLoginReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchUserIPLimitLoginReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchUserIPLimitLoginReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aOM<$1.RequestPagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.RequestPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserIPLimitLoginReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserIPLimitLoginReq copyWith(
          void Function(SearchUserIPLimitLoginReq) updates) =>
      super.copyWith((message) => updates(message as SearchUserIPLimitLoginReq))
          as SearchUserIPLimitLoginReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchUserIPLimitLoginReq create() => SearchUserIPLimitLoginReq._();
  @$core.override
  SearchUserIPLimitLoginReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchUserIPLimitLoginReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchUserIPLimitLoginReq>(create);
  static SearchUserIPLimitLoginReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.RequestPagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.RequestPagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.RequestPagination ensurePagination() => $_ensure(1);
}

class LimitUserLoginIP extends $pb.GeneratedMessage {
  factory LimitUserLoginIP({
    $core.String? userID,
    $core.String? ip,
    $fixnum.Int64? createTime,
    $2.UserPublicInfo? user,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (ip != null) result.ip = ip;
    if (createTime != null) result.createTime = createTime;
    if (user != null) result.user = user;
    return result;
  }

  LimitUserLoginIP._();

  factory LimitUserLoginIP.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LimitUserLoginIP.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LimitUserLoginIP',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'ip')
    ..aInt64(3, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aOM<$2.UserPublicInfo>(4, _omitFieldNames ? '' : 'user',
        subBuilder: $2.UserPublicInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LimitUserLoginIP clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LimitUserLoginIP copyWith(void Function(LimitUserLoginIP) updates) =>
      super.copyWith((message) => updates(message as LimitUserLoginIP))
          as LimitUserLoginIP;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LimitUserLoginIP create() => LimitUserLoginIP._();
  @$core.override
  LimitUserLoginIP createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LimitUserLoginIP getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LimitUserLoginIP>(create);
  static LimitUserLoginIP? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ip => $_getSZ(1);
  @$pb.TagNumber(2)
  set ip($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIp() => $_has(1);
  @$pb.TagNumber(2)
  void clearIp() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get createTime => $_getI64(2);
  @$pb.TagNumber(3)
  set createTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreateTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreateTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.UserPublicInfo get user => $_getN(3);
  @$pb.TagNumber(4)
  set user($2.UserPublicInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearUser() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.UserPublicInfo ensureUser() => $_ensure(3);
}

class SearchUserIPLimitLoginResp extends $pb.GeneratedMessage {
  factory SearchUserIPLimitLoginResp({
    $core.int? total,
    $core.Iterable<LimitUserLoginIP>? limits,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (limits != null) result.limits.addAll(limits);
    return result;
  }

  SearchUserIPLimitLoginResp._();

  factory SearchUserIPLimitLoginResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchUserIPLimitLoginResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchUserIPLimitLoginResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPM<LimitUserLoginIP>(2, _omitFieldNames ? '' : 'limits',
        subBuilder: LimitUserLoginIP.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserIPLimitLoginResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchUserIPLimitLoginResp copyWith(
          void Function(SearchUserIPLimitLoginResp) updates) =>
      super.copyWith(
              (message) => updates(message as SearchUserIPLimitLoginResp))
          as SearchUserIPLimitLoginResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchUserIPLimitLoginResp create() => SearchUserIPLimitLoginResp._();
  @$core.override
  SearchUserIPLimitLoginResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchUserIPLimitLoginResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchUserIPLimitLoginResp>(create);
  static SearchUserIPLimitLoginResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<LimitUserLoginIP> get limits => $_getList(1);
}

class UserIPLimitLogin extends $pb.GeneratedMessage {
  factory UserIPLimitLogin({
    $core.String? userID,
    $core.String? ip,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (ip != null) result.ip = ip;
    return result;
  }

  UserIPLimitLogin._();

  factory UserIPLimitLogin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserIPLimitLogin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserIPLimitLogin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'ip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserIPLimitLogin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserIPLimitLogin copyWith(void Function(UserIPLimitLogin) updates) =>
      super.copyWith((message) => updates(message as UserIPLimitLogin))
          as UserIPLimitLogin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserIPLimitLogin create() => UserIPLimitLogin._();
  @$core.override
  UserIPLimitLogin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserIPLimitLogin getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserIPLimitLogin>(create);
  static UserIPLimitLogin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ip => $_getSZ(1);
  @$pb.TagNumber(2)
  set ip($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIp() => $_has(1);
  @$pb.TagNumber(2)
  void clearIp() => $_clearField(2);
}

class AddUserIPLimitLoginReq extends $pb.GeneratedMessage {
  factory AddUserIPLimitLoginReq({
    $core.Iterable<UserIPLimitLogin>? limits,
  }) {
    final result = create();
    if (limits != null) result.limits.addAll(limits);
    return result;
  }

  AddUserIPLimitLoginReq._();

  factory AddUserIPLimitLoginReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddUserIPLimitLoginReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddUserIPLimitLoginReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPM<UserIPLimitLogin>(1, _omitFieldNames ? '' : 'limits',
        subBuilder: UserIPLimitLogin.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserIPLimitLoginReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserIPLimitLoginReq copyWith(
          void Function(AddUserIPLimitLoginReq) updates) =>
      super.copyWith((message) => updates(message as AddUserIPLimitLoginReq))
          as AddUserIPLimitLoginReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddUserIPLimitLoginReq create() => AddUserIPLimitLoginReq._();
  @$core.override
  AddUserIPLimitLoginReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddUserIPLimitLoginReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddUserIPLimitLoginReq>(create);
  static AddUserIPLimitLoginReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<UserIPLimitLogin> get limits => $_getList(0);
}

class AddUserIPLimitLoginResp extends $pb.GeneratedMessage {
  factory AddUserIPLimitLoginResp() => create();

  AddUserIPLimitLoginResp._();

  factory AddUserIPLimitLoginResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddUserIPLimitLoginResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddUserIPLimitLoginResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserIPLimitLoginResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddUserIPLimitLoginResp copyWith(
          void Function(AddUserIPLimitLoginResp) updates) =>
      super.copyWith((message) => updates(message as AddUserIPLimitLoginResp))
          as AddUserIPLimitLoginResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddUserIPLimitLoginResp create() => AddUserIPLimitLoginResp._();
  @$core.override
  AddUserIPLimitLoginResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddUserIPLimitLoginResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddUserIPLimitLoginResp>(create);
  static AddUserIPLimitLoginResp? _defaultInstance;
}

class DelUserIPLimitLoginReq extends $pb.GeneratedMessage {
  factory DelUserIPLimitLoginReq({
    $core.Iterable<UserIPLimitLogin>? limits,
  }) {
    final result = create();
    if (limits != null) result.limits.addAll(limits);
    return result;
  }

  DelUserIPLimitLoginReq._();

  factory DelUserIPLimitLoginReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelUserIPLimitLoginReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelUserIPLimitLoginReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPM<UserIPLimitLogin>(1, _omitFieldNames ? '' : 'limits',
        subBuilder: UserIPLimitLogin.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelUserIPLimitLoginReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelUserIPLimitLoginReq copyWith(
          void Function(DelUserIPLimitLoginReq) updates) =>
      super.copyWith((message) => updates(message as DelUserIPLimitLoginReq))
          as DelUserIPLimitLoginReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelUserIPLimitLoginReq create() => DelUserIPLimitLoginReq._();
  @$core.override
  DelUserIPLimitLoginReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelUserIPLimitLoginReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelUserIPLimitLoginReq>(create);
  static DelUserIPLimitLoginReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<UserIPLimitLogin> get limits => $_getList(0);
}

class DelUserIPLimitLoginResp extends $pb.GeneratedMessage {
  factory DelUserIPLimitLoginResp() => create();

  DelUserIPLimitLoginResp._();

  factory DelUserIPLimitLoginResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelUserIPLimitLoginResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelUserIPLimitLoginResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelUserIPLimitLoginResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelUserIPLimitLoginResp copyWith(
          void Function(DelUserIPLimitLoginResp) updates) =>
      super.copyWith((message) => updates(message as DelUserIPLimitLoginResp))
          as DelUserIPLimitLoginResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelUserIPLimitLoginResp create() => DelUserIPLimitLoginResp._();
  @$core.override
  DelUserIPLimitLoginResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelUserIPLimitLoginResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelUserIPLimitLoginResp>(create);
  static DelUserIPLimitLoginResp? _defaultInstance;
}

class IPForbidden extends $pb.GeneratedMessage {
  factory IPForbidden({
    $core.String? ip,
    $core.bool? limitRegister,
    $core.bool? limitLogin,
    $fixnum.Int64? createTime,
  }) {
    final result = create();
    if (ip != null) result.ip = ip;
    if (limitRegister != null) result.limitRegister = limitRegister;
    if (limitLogin != null) result.limitLogin = limitLogin;
    if (createTime != null) result.createTime = createTime;
    return result;
  }

  IPForbidden._();

  factory IPForbidden.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IPForbidden.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IPForbidden',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ip')
    ..aOB(2, _omitFieldNames ? '' : 'limitRegister', protoName: 'limitRegister')
    ..aOB(3, _omitFieldNames ? '' : 'limitLogin', protoName: 'limitLogin')
    ..aInt64(4, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IPForbidden clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IPForbidden copyWith(void Function(IPForbidden) updates) =>
      super.copyWith((message) => updates(message as IPForbidden))
          as IPForbidden;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IPForbidden create() => IPForbidden._();
  @$core.override
  IPForbidden createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IPForbidden getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IPForbidden>(create);
  static IPForbidden? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ip => $_getSZ(0);
  @$pb.TagNumber(1)
  set ip($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIp() => $_has(0);
  @$pb.TagNumber(1)
  void clearIp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get limitRegister => $_getBF(1);
  @$pb.TagNumber(2)
  set limitRegister($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimitRegister() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimitRegister() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get limitLogin => $_getBF(2);
  @$pb.TagNumber(3)
  set limitLogin($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimitLogin() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimitLogin() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get createTime => $_getI64(3);
  @$pb.TagNumber(4)
  set createTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreateTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreateTime() => $_clearField(4);
}

class IPForbiddenAdd extends $pb.GeneratedMessage {
  factory IPForbiddenAdd({
    $core.String? ip,
    $core.bool? limitRegister,
    $core.bool? limitLogin,
  }) {
    final result = create();
    if (ip != null) result.ip = ip;
    if (limitRegister != null) result.limitRegister = limitRegister;
    if (limitLogin != null) result.limitLogin = limitLogin;
    return result;
  }

  IPForbiddenAdd._();

  factory IPForbiddenAdd.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IPForbiddenAdd.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IPForbiddenAdd',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ip')
    ..aOB(2, _omitFieldNames ? '' : 'limitRegister', protoName: 'limitRegister')
    ..aOB(3, _omitFieldNames ? '' : 'limitLogin', protoName: 'limitLogin')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IPForbiddenAdd clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IPForbiddenAdd copyWith(void Function(IPForbiddenAdd) updates) =>
      super.copyWith((message) => updates(message as IPForbiddenAdd))
          as IPForbiddenAdd;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IPForbiddenAdd create() => IPForbiddenAdd._();
  @$core.override
  IPForbiddenAdd createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IPForbiddenAdd getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IPForbiddenAdd>(create);
  static IPForbiddenAdd? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ip => $_getSZ(0);
  @$pb.TagNumber(1)
  set ip($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIp() => $_has(0);
  @$pb.TagNumber(1)
  void clearIp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get limitRegister => $_getBF(1);
  @$pb.TagNumber(2)
  set limitRegister($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimitRegister() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimitRegister() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get limitLogin => $_getBF(2);
  @$pb.TagNumber(3)
  set limitLogin($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimitLogin() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimitLogin() => $_clearField(3);
}

class SearchIPForbiddenReq extends $pb.GeneratedMessage {
  factory SearchIPForbiddenReq({
    $core.String? keyword,
    $core.int? status,
    $1.RequestPagination? pagination,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (status != null) result.status = status;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchIPForbiddenReq._();

  factory SearchIPForbiddenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchIPForbiddenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchIPForbiddenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aI(2, _omitFieldNames ? '' : 'status')
    ..aOM<$1.RequestPagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.RequestPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchIPForbiddenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchIPForbiddenReq copyWith(void Function(SearchIPForbiddenReq) updates) =>
      super.copyWith((message) => updates(message as SearchIPForbiddenReq))
          as SearchIPForbiddenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchIPForbiddenReq create() => SearchIPForbiddenReq._();
  @$core.override
  SearchIPForbiddenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchIPForbiddenReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchIPForbiddenReq>(create);
  static SearchIPForbiddenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get status => $_getIZ(1);
  @$pb.TagNumber(2)
  set status($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.RequestPagination get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($1.RequestPagination value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.RequestPagination ensurePagination() => $_ensure(2);
}

class SearchIPForbiddenResp extends $pb.GeneratedMessage {
  factory SearchIPForbiddenResp({
    $core.int? total,
    $core.Iterable<IPForbidden>? forbiddens,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (forbiddens != null) result.forbiddens.addAll(forbiddens);
    return result;
  }

  SearchIPForbiddenResp._();

  factory SearchIPForbiddenResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchIPForbiddenResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchIPForbiddenResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPM<IPForbidden>(2, _omitFieldNames ? '' : 'forbiddens',
        subBuilder: IPForbidden.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchIPForbiddenResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchIPForbiddenResp copyWith(
          void Function(SearchIPForbiddenResp) updates) =>
      super.copyWith((message) => updates(message as SearchIPForbiddenResp))
          as SearchIPForbiddenResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchIPForbiddenResp create() => SearchIPForbiddenResp._();
  @$core.override
  SearchIPForbiddenResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchIPForbiddenResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchIPForbiddenResp>(create);
  static SearchIPForbiddenResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<IPForbidden> get forbiddens => $_getList(1);
}

class AddIPForbiddenReq extends $pb.GeneratedMessage {
  factory AddIPForbiddenReq({
    $core.Iterable<IPForbiddenAdd>? forbiddens,
  }) {
    final result = create();
    if (forbiddens != null) result.forbiddens.addAll(forbiddens);
    return result;
  }

  AddIPForbiddenReq._();

  factory AddIPForbiddenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddIPForbiddenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddIPForbiddenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPM<IPForbiddenAdd>(1, _omitFieldNames ? '' : 'forbiddens',
        subBuilder: IPForbiddenAdd.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddIPForbiddenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddIPForbiddenReq copyWith(void Function(AddIPForbiddenReq) updates) =>
      super.copyWith((message) => updates(message as AddIPForbiddenReq))
          as AddIPForbiddenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddIPForbiddenReq create() => AddIPForbiddenReq._();
  @$core.override
  AddIPForbiddenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddIPForbiddenReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddIPForbiddenReq>(create);
  static AddIPForbiddenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<IPForbiddenAdd> get forbiddens => $_getList(0);
}

class AddIPForbiddenResp extends $pb.GeneratedMessage {
  factory AddIPForbiddenResp() => create();

  AddIPForbiddenResp._();

  factory AddIPForbiddenResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddIPForbiddenResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddIPForbiddenResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddIPForbiddenResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddIPForbiddenResp copyWith(void Function(AddIPForbiddenResp) updates) =>
      super.copyWith((message) => updates(message as AddIPForbiddenResp))
          as AddIPForbiddenResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddIPForbiddenResp create() => AddIPForbiddenResp._();
  @$core.override
  AddIPForbiddenResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddIPForbiddenResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddIPForbiddenResp>(create);
  static AddIPForbiddenResp? _defaultInstance;
}

class DelIPForbiddenReq extends $pb.GeneratedMessage {
  factory DelIPForbiddenReq({
    $core.Iterable<$core.String>? ips,
  }) {
    final result = create();
    if (ips != null) result.ips.addAll(ips);
    return result;
  }

  DelIPForbiddenReq._();

  factory DelIPForbiddenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelIPForbiddenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelIPForbiddenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'ips')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelIPForbiddenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelIPForbiddenReq copyWith(void Function(DelIPForbiddenReq) updates) =>
      super.copyWith((message) => updates(message as DelIPForbiddenReq))
          as DelIPForbiddenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelIPForbiddenReq create() => DelIPForbiddenReq._();
  @$core.override
  DelIPForbiddenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelIPForbiddenReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelIPForbiddenReq>(create);
  static DelIPForbiddenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get ips => $_getList(0);
}

class DelIPForbiddenResp extends $pb.GeneratedMessage {
  factory DelIPForbiddenResp() => create();

  DelIPForbiddenResp._();

  factory DelIPForbiddenResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelIPForbiddenResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelIPForbiddenResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelIPForbiddenResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelIPForbiddenResp copyWith(void Function(DelIPForbiddenResp) updates) =>
      super.copyWith((message) => updates(message as DelIPForbiddenResp))
          as DelIPForbiddenResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelIPForbiddenResp create() => DelIPForbiddenResp._();
  @$core.override
  DelIPForbiddenResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelIPForbiddenResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelIPForbiddenResp>(create);
  static DelIPForbiddenResp? _defaultInstance;
}

/// ################### User Limit ###################
class CheckRegisterForbiddenReq extends $pb.GeneratedMessage {
  factory CheckRegisterForbiddenReq({
    $core.String? ip,
  }) {
    final result = create();
    if (ip != null) result.ip = ip;
    return result;
  }

  CheckRegisterForbiddenReq._();

  factory CheckRegisterForbiddenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckRegisterForbiddenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckRegisterForbiddenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRegisterForbiddenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRegisterForbiddenReq copyWith(
          void Function(CheckRegisterForbiddenReq) updates) =>
      super.copyWith((message) => updates(message as CheckRegisterForbiddenReq))
          as CheckRegisterForbiddenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckRegisterForbiddenReq create() => CheckRegisterForbiddenReq._();
  @$core.override
  CheckRegisterForbiddenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckRegisterForbiddenReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckRegisterForbiddenReq>(create);
  static CheckRegisterForbiddenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ip => $_getSZ(0);
  @$pb.TagNumber(1)
  set ip($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIp() => $_has(0);
  @$pb.TagNumber(1)
  void clearIp() => $_clearField(1);
}

class CheckRegisterForbiddenResp extends $pb.GeneratedMessage {
  factory CheckRegisterForbiddenResp() => create();

  CheckRegisterForbiddenResp._();

  factory CheckRegisterForbiddenResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckRegisterForbiddenResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckRegisterForbiddenResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRegisterForbiddenResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRegisterForbiddenResp copyWith(
          void Function(CheckRegisterForbiddenResp) updates) =>
      super.copyWith(
              (message) => updates(message as CheckRegisterForbiddenResp))
          as CheckRegisterForbiddenResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckRegisterForbiddenResp create() => CheckRegisterForbiddenResp._();
  @$core.override
  CheckRegisterForbiddenResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckRegisterForbiddenResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckRegisterForbiddenResp>(create);
  static CheckRegisterForbiddenResp? _defaultInstance;
}

class CheckLoginForbiddenReq extends $pb.GeneratedMessage {
  factory CheckLoginForbiddenReq({
    $core.String? ip,
    $core.String? userID,
  }) {
    final result = create();
    if (ip != null) result.ip = ip;
    if (userID != null) result.userID = userID;
    return result;
  }

  CheckLoginForbiddenReq._();

  factory CheckLoginForbiddenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckLoginForbiddenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckLoginForbiddenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ip')
    ..aOS(2, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckLoginForbiddenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckLoginForbiddenReq copyWith(
          void Function(CheckLoginForbiddenReq) updates) =>
      super.copyWith((message) => updates(message as CheckLoginForbiddenReq))
          as CheckLoginForbiddenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckLoginForbiddenReq create() => CheckLoginForbiddenReq._();
  @$core.override
  CheckLoginForbiddenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckLoginForbiddenReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckLoginForbiddenReq>(create);
  static CheckLoginForbiddenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ip => $_getSZ(0);
  @$pb.TagNumber(1)
  set ip($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIp() => $_has(0);
  @$pb.TagNumber(1)
  void clearIp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userID => $_getSZ(1);
  @$pb.TagNumber(2)
  set userID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);
}

class CheckLoginForbiddenResp extends $pb.GeneratedMessage {
  factory CheckLoginForbiddenResp() => create();

  CheckLoginForbiddenResp._();

  factory CheckLoginForbiddenResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckLoginForbiddenResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckLoginForbiddenResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckLoginForbiddenResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckLoginForbiddenResp copyWith(
          void Function(CheckLoginForbiddenResp) updates) =>
      super.copyWith((message) => updates(message as CheckLoginForbiddenResp))
          as CheckLoginForbiddenResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckLoginForbiddenResp create() => CheckLoginForbiddenResp._();
  @$core.override
  CheckLoginForbiddenResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckLoginForbiddenResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckLoginForbiddenResp>(create);
  static CheckLoginForbiddenResp? _defaultInstance;
}

/// ################### login out ###################
class CancellationUserReq extends $pb.GeneratedMessage {
  factory CancellationUserReq({
    $core.String? userID,
    $core.String? reason,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (reason != null) result.reason = reason;
    return result;
  }

  CancellationUserReq._();

  factory CancellationUserReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancellationUserReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancellationUserReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancellationUserReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancellationUserReq copyWith(void Function(CancellationUserReq) updates) =>
      super.copyWith((message) => updates(message as CancellationUserReq))
          as CancellationUserReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancellationUserReq create() => CancellationUserReq._();
  @$core.override
  CancellationUserReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancellationUserReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancellationUserReq>(create);
  static CancellationUserReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class CancellationUserResp extends $pb.GeneratedMessage {
  factory CancellationUserResp() => create();

  CancellationUserResp._();

  factory CancellationUserResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancellationUserResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancellationUserResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancellationUserResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancellationUserResp copyWith(void Function(CancellationUserResp) updates) =>
      super.copyWith((message) => updates(message as CancellationUserResp))
          as CancellationUserResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancellationUserResp create() => CancellationUserResp._();
  @$core.override
  CancellationUserResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancellationUserResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancellationUserResp>(create);
  static CancellationUserResp? _defaultInstance;
}

/// ################### Block User, Unblock User ###################
class BlockUserReq extends $pb.GeneratedMessage {
  factory BlockUserReq({
    $core.String? userID,
    $core.String? reason,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (reason != null) result.reason = reason;
    return result;
  }

  BlockUserReq._();

  factory BlockUserReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlockUserReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockUserReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockUserReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockUserReq copyWith(void Function(BlockUserReq) updates) =>
      super.copyWith((message) => updates(message as BlockUserReq))
          as BlockUserReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockUserReq create() => BlockUserReq._();
  @$core.override
  BlockUserReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlockUserReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlockUserReq>(create);
  static BlockUserReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class BlockUserResp extends $pb.GeneratedMessage {
  factory BlockUserResp() => create();

  BlockUserResp._();

  factory BlockUserResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlockUserResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockUserResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockUserResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockUserResp copyWith(void Function(BlockUserResp) updates) =>
      super.copyWith((message) => updates(message as BlockUserResp))
          as BlockUserResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockUserResp create() => BlockUserResp._();
  @$core.override
  BlockUserResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlockUserResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlockUserResp>(create);
  static BlockUserResp? _defaultInstance;
}

class UnblockUserReq extends $pb.GeneratedMessage {
  factory UnblockUserReq({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  UnblockUserReq._();

  factory UnblockUserReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnblockUserReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnblockUserReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnblockUserReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnblockUserReq copyWith(void Function(UnblockUserReq) updates) =>
      super.copyWith((message) => updates(message as UnblockUserReq))
          as UnblockUserReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnblockUserReq create() => UnblockUserReq._();
  @$core.override
  UnblockUserReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnblockUserReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnblockUserReq>(create);
  static UnblockUserReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class UnblockUserResp extends $pb.GeneratedMessage {
  factory UnblockUserResp() => create();

  UnblockUserResp._();

  factory UnblockUserResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnblockUserResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnblockUserResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnblockUserResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnblockUserResp copyWith(void Function(UnblockUserResp) updates) =>
      super.copyWith((message) => updates(message as UnblockUserResp))
          as UnblockUserResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnblockUserResp create() => UnblockUserResp._();
  @$core.override
  UnblockUserResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnblockUserResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnblockUserResp>(create);
  static UnblockUserResp? _defaultInstance;
}

class SearchBlockUserReq extends $pb.GeneratedMessage {
  factory SearchBlockUserReq({
    $core.String? keyword,
    $1.RequestPagination? pagination,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchBlockUserReq._();

  factory SearchBlockUserReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchBlockUserReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchBlockUserReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aOM<$1.RequestPagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.RequestPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchBlockUserReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchBlockUserReq copyWith(void Function(SearchBlockUserReq) updates) =>
      super.copyWith((message) => updates(message as SearchBlockUserReq))
          as SearchBlockUserReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchBlockUserReq create() => SearchBlockUserReq._();
  @$core.override
  SearchBlockUserReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchBlockUserReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchBlockUserReq>(create);
  static SearchBlockUserReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.RequestPagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.RequestPagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.RequestPagination ensurePagination() => $_ensure(1);
}

class BlockUserInfo extends $pb.GeneratedMessage {
  factory BlockUserInfo({
    $core.String? userID,
    $core.String? account,
    $core.String? phoneNumber,
    $core.String? areaCode,
    $core.String? email,
    $core.String? nickname,
    $core.String? faceURL,
    $core.int? gender,
    $core.String? reason,
    $core.String? opUserID,
    $fixnum.Int64? createTime,
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
    if (reason != null) result.reason = reason;
    if (opUserID != null) result.opUserID = opUserID;
    if (createTime != null) result.createTime = createTime;
    return result;
  }

  BlockUserInfo._();

  factory BlockUserInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlockUserInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockUserInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'account')
    ..aOS(3, _omitFieldNames ? '' : 'phoneNumber', protoName: 'phoneNumber')
    ..aOS(4, _omitFieldNames ? '' : 'areaCode', protoName: 'areaCode')
    ..aOS(5, _omitFieldNames ? '' : 'email')
    ..aOS(6, _omitFieldNames ? '' : 'nickname')
    ..aOS(7, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aI(8, _omitFieldNames ? '' : 'gender')
    ..aOS(9, _omitFieldNames ? '' : 'reason')
    ..aOS(10, _omitFieldNames ? '' : 'opUserID', protoName: 'opUserID')
    ..aInt64(11, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockUserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockUserInfo copyWith(void Function(BlockUserInfo) updates) =>
      super.copyWith((message) => updates(message as BlockUserInfo))
          as BlockUserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockUserInfo create() => BlockUserInfo._();
  @$core.override
  BlockUserInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlockUserInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlockUserInfo>(create);
  static BlockUserInfo? _defaultInstance;

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
  $core.String get phoneNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set phoneNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhoneNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhoneNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get areaCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set areaCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAreaCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearAreaCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get email => $_getSZ(4);
  @$pb.TagNumber(5)
  set email($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearEmail() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get nickname => $_getSZ(5);
  @$pb.TagNumber(6)
  set nickname($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNickname() => $_has(5);
  @$pb.TagNumber(6)
  void clearNickname() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get faceURL => $_getSZ(6);
  @$pb.TagNumber(7)
  set faceURL($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFaceURL() => $_has(6);
  @$pb.TagNumber(7)
  void clearFaceURL() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get gender => $_getIZ(7);
  @$pb.TagNumber(8)
  set gender($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasGender() => $_has(7);
  @$pb.TagNumber(8)
  void clearGender() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get reason => $_getSZ(8);
  @$pb.TagNumber(9)
  set reason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get opUserID => $_getSZ(9);
  @$pb.TagNumber(10)
  set opUserID($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOpUserID() => $_has(9);
  @$pb.TagNumber(10)
  void clearOpUserID() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get createTime => $_getI64(10);
  @$pb.TagNumber(11)
  set createTime($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCreateTime() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreateTime() => $_clearField(11);
}

class SearchBlockUserResp extends $pb.GeneratedMessage {
  factory SearchBlockUserResp({
    $core.int? total,
    $core.Iterable<BlockUserInfo>? users,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (users != null) result.users.addAll(users);
    return result;
  }

  SearchBlockUserResp._();

  factory SearchBlockUserResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchBlockUserResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchBlockUserResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPM<BlockUserInfo>(2, _omitFieldNames ? '' : 'users',
        subBuilder: BlockUserInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchBlockUserResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchBlockUserResp copyWith(void Function(SearchBlockUserResp) updates) =>
      super.copyWith((message) => updates(message as SearchBlockUserResp))
          as SearchBlockUserResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchBlockUserResp create() => SearchBlockUserResp._();
  @$core.override
  SearchBlockUserResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchBlockUserResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchBlockUserResp>(create);
  static SearchBlockUserResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<BlockUserInfo> get users => $_getList(1);
}

class FindUserBlockInfoReq extends $pb.GeneratedMessage {
  factory FindUserBlockInfoReq({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  FindUserBlockInfoReq._();

  factory FindUserBlockInfoReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindUserBlockInfoReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindUserBlockInfoReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserBlockInfoReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserBlockInfoReq copyWith(void Function(FindUserBlockInfoReq) updates) =>
      super.copyWith((message) => updates(message as FindUserBlockInfoReq))
          as FindUserBlockInfoReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindUserBlockInfoReq create() => FindUserBlockInfoReq._();
  @$core.override
  FindUserBlockInfoReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindUserBlockInfoReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindUserBlockInfoReq>(create);
  static FindUserBlockInfoReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class BlockInfo extends $pb.GeneratedMessage {
  factory BlockInfo({
    $core.String? userID,
    $core.String? reason,
    $core.String? opUserID,
    $fixnum.Int64? createTime,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (reason != null) result.reason = reason;
    if (opUserID != null) result.opUserID = opUserID;
    if (createTime != null) result.createTime = createTime;
    return result;
  }

  BlockInfo._();

  factory BlockInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlockInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOS(3, _omitFieldNames ? '' : 'opUserID', protoName: 'opUserID')
    ..aInt64(4, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockInfo copyWith(void Function(BlockInfo) updates) =>
      super.copyWith((message) => updates(message as BlockInfo)) as BlockInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockInfo create() => BlockInfo._();
  @$core.override
  BlockInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlockInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BlockInfo>(create);
  static BlockInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get opUserID => $_getSZ(2);
  @$pb.TagNumber(3)
  set opUserID($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOpUserID() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpUserID() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get createTime => $_getI64(3);
  @$pb.TagNumber(4)
  set createTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreateTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreateTime() => $_clearField(4);
}

class FindUserBlockInfoResp extends $pb.GeneratedMessage {
  factory FindUserBlockInfoResp({
    $core.Iterable<BlockInfo>? blocks,
  }) {
    final result = create();
    if (blocks != null) result.blocks.addAll(blocks);
    return result;
  }

  FindUserBlockInfoResp._();

  factory FindUserBlockInfoResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindUserBlockInfoResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindUserBlockInfoResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPM<BlockInfo>(2, _omitFieldNames ? '' : 'blocks',
        subBuilder: BlockInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserBlockInfoResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindUserBlockInfoResp copyWith(
          void Function(FindUserBlockInfoResp) updates) =>
      super.copyWith((message) => updates(message as FindUserBlockInfoResp))
          as FindUserBlockInfoResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindUserBlockInfoResp create() => FindUserBlockInfoResp._();
  @$core.override
  FindUserBlockInfoResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindUserBlockInfoResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindUserBlockInfoResp>(create);
  static FindUserBlockInfoResp? _defaultInstance;

  @$pb.TagNumber(2)
  $pb.PbList<BlockInfo> get blocks => $_getList(0);
}

class CreateTokenReq extends $pb.GeneratedMessage {
  factory CreateTokenReq({
    $core.String? userID,
    $core.int? userType,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (userType != null) result.userType = userType;
    return result;
  }

  CreateTokenReq._();

  factory CreateTokenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTokenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTokenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aI(32, _omitFieldNames ? '' : 'userType', protoName: 'userType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTokenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTokenReq copyWith(void Function(CreateTokenReq) updates) =>
      super.copyWith((message) => updates(message as CreateTokenReq))
          as CreateTokenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTokenReq create() => CreateTokenReq._();
  @$core.override
  CreateTokenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateTokenReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTokenReq>(create);
  static CreateTokenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(32)
  $core.int get userType => $_getIZ(1);
  @$pb.TagNumber(32)
  set userType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(32)
  $core.bool hasUserType() => $_has(1);
  @$pb.TagNumber(32)
  void clearUserType() => $_clearField(32);
}

class CreateTokenResp extends $pb.GeneratedMessage {
  factory CreateTokenResp({
    $core.String? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
    return result;
  }

  CreateTokenResp._();

  factory CreateTokenResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTokenResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTokenResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTokenResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTokenResp copyWith(void Function(CreateTokenResp) updates) =>
      super.copyWith((message) => updates(message as CreateTokenResp))
          as CreateTokenResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTokenResp create() => CreateTokenResp._();
  @$core.override
  CreateTokenResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateTokenResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTokenResp>(create);
  static CreateTokenResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class ParseTokenReq extends $pb.GeneratedMessage {
  factory ParseTokenReq({
    $core.String? token,
  }) {
    final result = create();
    if (token != null) result.token = token;
    return result;
  }

  ParseTokenReq._();

  factory ParseTokenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParseTokenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParseTokenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParseTokenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParseTokenReq copyWith(void Function(ParseTokenReq) updates) =>
      super.copyWith((message) => updates(message as ParseTokenReq))
          as ParseTokenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParseTokenReq create() => ParseTokenReq._();
  @$core.override
  ParseTokenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ParseTokenReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParseTokenReq>(create);
  static ParseTokenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => $_clearField(1);
}

class ParseTokenResp extends $pb.GeneratedMessage {
  factory ParseTokenResp({
    $core.String? userID,
    $core.int? userType,
    $fixnum.Int64? expireTimeSeconds,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (userType != null) result.userType = userType;
    if (expireTimeSeconds != null) result.expireTimeSeconds = expireTimeSeconds;
    return result;
  }

  ParseTokenResp._();

  factory ParseTokenResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParseTokenResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParseTokenResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aI(2, _omitFieldNames ? '' : 'userType', protoName: 'userType')
    ..aInt64(3, _omitFieldNames ? '' : 'expireTimeSeconds',
        protoName: 'expireTimeSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParseTokenResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParseTokenResp copyWith(void Function(ParseTokenResp) updates) =>
      super.copyWith((message) => updates(message as ParseTokenResp))
          as ParseTokenResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParseTokenResp create() => ParseTokenResp._();
  @$core.override
  ParseTokenResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ParseTokenResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ParseTokenResp>(create);
  static ParseTokenResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get userType => $_getIZ(1);
  @$pb.TagNumber(2)
  set userType($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserType() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expireTimeSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set expireTimeSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpireTimeSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpireTimeSeconds() => $_clearField(3);
}

class InvalidateTokenReq extends $pb.GeneratedMessage {
  factory InvalidateTokenReq({
    $core.String? userID,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    return result;
  }

  InvalidateTokenReq._();

  factory InvalidateTokenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InvalidateTokenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvalidateTokenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvalidateTokenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvalidateTokenReq copyWith(void Function(InvalidateTokenReq) updates) =>
      super.copyWith((message) => updates(message as InvalidateTokenReq))
          as InvalidateTokenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvalidateTokenReq create() => InvalidateTokenReq._();
  @$core.override
  InvalidateTokenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InvalidateTokenReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvalidateTokenReq>(create);
  static InvalidateTokenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);
}

class InvalidateTokenResp extends $pb.GeneratedMessage {
  factory InvalidateTokenResp() => create();

  InvalidateTokenResp._();

  factory InvalidateTokenResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InvalidateTokenResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvalidateTokenResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvalidateTokenResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvalidateTokenResp copyWith(void Function(InvalidateTokenResp) updates) =>
      super.copyWith((message) => updates(message as InvalidateTokenResp))
          as InvalidateTokenResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvalidateTokenResp create() => InvalidateTokenResp._();
  @$core.override
  InvalidateTokenResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InvalidateTokenResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvalidateTokenResp>(create);
  static InvalidateTokenResp? _defaultInstance;
}

class AddAppletReq extends $pb.GeneratedMessage {
  factory AddAppletReq({
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

  AddAppletReq._();

  factory AddAppletReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAppletReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAppletReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
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
  AddAppletReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAppletReq copyWith(void Function(AddAppletReq) updates) =>
      super.copyWith((message) => updates(message as AddAppletReq))
          as AddAppletReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAppletReq create() => AddAppletReq._();
  @$core.override
  AddAppletReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddAppletReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAppletReq>(create);
  static AddAppletReq? _defaultInstance;

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

class AddAppletResp extends $pb.GeneratedMessage {
  factory AddAppletResp() => create();

  AddAppletResp._();

  factory AddAppletResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAppletResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAppletResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAppletResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAppletResp copyWith(void Function(AddAppletResp) updates) =>
      super.copyWith((message) => updates(message as AddAppletResp))
          as AddAppletResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAppletResp create() => AddAppletResp._();
  @$core.override
  AddAppletResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddAppletResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAppletResp>(create);
  static AddAppletResp? _defaultInstance;
}

class DelAppletReq extends $pb.GeneratedMessage {
  factory DelAppletReq({
    $core.Iterable<$core.String>? appletIds,
  }) {
    final result = create();
    if (appletIds != null) result.appletIds.addAll(appletIds);
    return result;
  }

  DelAppletReq._();

  factory DelAppletReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelAppletReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelAppletReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'appletIds', protoName: 'appletIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelAppletReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelAppletReq copyWith(void Function(DelAppletReq) updates) =>
      super.copyWith((message) => updates(message as DelAppletReq))
          as DelAppletReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelAppletReq create() => DelAppletReq._();
  @$core.override
  DelAppletReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelAppletReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelAppletReq>(create);
  static DelAppletReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get appletIds => $_getList(0);
}

class DelAppletResp extends $pb.GeneratedMessage {
  factory DelAppletResp() => create();

  DelAppletResp._();

  factory DelAppletResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelAppletResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelAppletResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelAppletResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelAppletResp copyWith(void Function(DelAppletResp) updates) =>
      super.copyWith((message) => updates(message as DelAppletResp))
          as DelAppletResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelAppletResp create() => DelAppletResp._();
  @$core.override
  DelAppletResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelAppletResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelAppletResp>(create);
  static DelAppletResp? _defaultInstance;
}

class UpdateAppletReq extends $pb.GeneratedMessage {
  factory UpdateAppletReq({
    $core.String? id,
    $0.StringValue? name,
    $0.StringValue? appID,
    $0.StringValue? icon,
    $0.StringValue? url,
    $0.StringValue? md5,
    $0.Int64Value? size,
    $0.StringValue? version,
    $0.UInt32Value? priority,
    $0.UInt32Value? status,
    $0.Int64Value? createTime,
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

  UpdateAppletReq._();

  factory UpdateAppletReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateAppletReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAppletReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$0.StringValue>(2, _omitFieldNames ? '' : 'name',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(3, _omitFieldNames ? '' : 'appID',
        protoName: 'appID', subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(4, _omitFieldNames ? '' : 'icon',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(5, _omitFieldNames ? '' : 'url',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(6, _omitFieldNames ? '' : 'md5',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.Int64Value>(7, _omitFieldNames ? '' : 'size',
        subBuilder: $0.Int64Value.create)
    ..aOM<$0.StringValue>(8, _omitFieldNames ? '' : 'version',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.UInt32Value>(9, _omitFieldNames ? '' : 'priority',
        subBuilder: $0.UInt32Value.create)
    ..aOM<$0.UInt32Value>(10, _omitFieldNames ? '' : 'status',
        subBuilder: $0.UInt32Value.create)
    ..aOM<$0.Int64Value>(11, _omitFieldNames ? '' : 'createTime',
        protoName: 'createTime', subBuilder: $0.Int64Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAppletReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAppletReq copyWith(void Function(UpdateAppletReq) updates) =>
      super.copyWith((message) => updates(message as UpdateAppletReq))
          as UpdateAppletReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAppletReq create() => UpdateAppletReq._();
  @$core.override
  UpdateAppletReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateAppletReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAppletReq>(create);
  static UpdateAppletReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.StringValue get name => $_getN(1);
  @$pb.TagNumber(2)
  set name($0.StringValue value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.StringValue ensureName() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.StringValue get appID => $_getN(2);
  @$pb.TagNumber(3)
  set appID($0.StringValue value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAppID() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppID() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.StringValue ensureAppID() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.StringValue get icon => $_getN(3);
  @$pb.TagNumber(4)
  set icon($0.StringValue value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasIcon() => $_has(3);
  @$pb.TagNumber(4)
  void clearIcon() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.StringValue ensureIcon() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.StringValue get url => $_getN(4);
  @$pb.TagNumber(5)
  set url($0.StringValue value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearUrl() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.StringValue ensureUrl() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.StringValue get md5 => $_getN(5);
  @$pb.TagNumber(6)
  set md5($0.StringValue value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMd5() => $_has(5);
  @$pb.TagNumber(6)
  void clearMd5() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.StringValue ensureMd5() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Int64Value get size => $_getN(6);
  @$pb.TagNumber(7)
  set size($0.Int64Value value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearSize() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Int64Value ensureSize() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.StringValue get version => $_getN(7);
  @$pb.TagNumber(8)
  set version($0.StringValue value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasVersion() => $_has(7);
  @$pb.TagNumber(8)
  void clearVersion() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.StringValue ensureVersion() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.UInt32Value get priority => $_getN(8);
  @$pb.TagNumber(9)
  set priority($0.UInt32Value value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPriority() => $_has(8);
  @$pb.TagNumber(9)
  void clearPriority() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.UInt32Value ensurePriority() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.UInt32Value get status => $_getN(9);
  @$pb.TagNumber(10)
  set status($0.UInt32Value value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.UInt32Value ensureStatus() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Int64Value get createTime => $_getN(10);
  @$pb.TagNumber(11)
  set createTime($0.Int64Value value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCreateTime() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreateTime() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Int64Value ensureCreateTime() => $_ensure(10);
}

class UpdateAppletResp extends $pb.GeneratedMessage {
  factory UpdateAppletResp() => create();

  UpdateAppletResp._();

  factory UpdateAppletResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateAppletResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAppletResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAppletResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAppletResp copyWith(void Function(UpdateAppletResp) updates) =>
      super.copyWith((message) => updates(message as UpdateAppletResp))
          as UpdateAppletResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAppletResp create() => UpdateAppletResp._();
  @$core.override
  UpdateAppletResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateAppletResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAppletResp>(create);
  static UpdateAppletResp? _defaultInstance;
}

class FindAppletReq extends $pb.GeneratedMessage {
  factory FindAppletReq() => create();

  FindAppletReq._();

  factory FindAppletReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindAppletReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindAppletReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindAppletReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindAppletReq copyWith(void Function(FindAppletReq) updates) =>
      super.copyWith((message) => updates(message as FindAppletReq))
          as FindAppletReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindAppletReq create() => FindAppletReq._();
  @$core.override
  FindAppletReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindAppletReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindAppletReq>(create);
  static FindAppletReq? _defaultInstance;
}

class FindAppletResp extends $pb.GeneratedMessage {
  factory FindAppletResp({
    $core.Iterable<$2.AppletInfo>? applets,
  }) {
    final result = create();
    if (applets != null) result.applets.addAll(applets);
    return result;
  }

  FindAppletResp._();

  factory FindAppletResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FindAppletResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FindAppletResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPM<$2.AppletInfo>(1, _omitFieldNames ? '' : 'applets',
        subBuilder: $2.AppletInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindAppletResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FindAppletResp copyWith(void Function(FindAppletResp) updates) =>
      super.copyWith((message) => updates(message as FindAppletResp))
          as FindAppletResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindAppletResp create() => FindAppletResp._();
  @$core.override
  FindAppletResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FindAppletResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FindAppletResp>(create);
  static FindAppletResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$2.AppletInfo> get applets => $_getList(0);
}

class SearchAppletReq extends $pb.GeneratedMessage {
  factory SearchAppletReq({
    $core.String? keyword,
    $1.RequestPagination? pagination,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchAppletReq._();

  factory SearchAppletReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchAppletReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchAppletReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..aOM<$1.RequestPagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.RequestPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchAppletReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchAppletReq copyWith(void Function(SearchAppletReq) updates) =>
      super.copyWith((message) => updates(message as SearchAppletReq))
          as SearchAppletReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchAppletReq create() => SearchAppletReq._();
  @$core.override
  SearchAppletReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchAppletReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchAppletReq>(create);
  static SearchAppletReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.RequestPagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.RequestPagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.RequestPagination ensurePagination() => $_ensure(1);
}

class SearchAppletResp extends $pb.GeneratedMessage {
  factory SearchAppletResp({
    $core.int? total,
    $core.Iterable<$2.AppletInfo>? applets,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (applets != null) result.applets.addAll(applets);
    return result;
  }

  SearchAppletResp._();

  factory SearchAppletResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchAppletResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchAppletResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'total', fieldType: $pb.PbFieldType.OU3)
    ..pPM<$2.AppletInfo>(2, _omitFieldNames ? '' : 'applets',
        subBuilder: $2.AppletInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchAppletResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchAppletResp copyWith(void Function(SearchAppletResp) updates) =>
      super.copyWith((message) => updates(message as SearchAppletResp))
          as SearchAppletResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchAppletResp create() => SearchAppletResp._();
  @$core.override
  SearchAppletResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchAppletResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchAppletResp>(create);
  static SearchAppletResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get total => $_getIZ(0);
  @$pb.TagNumber(1)
  set total($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$2.AppletInfo> get applets => $_getList(1);
}

class SetClientConfigReq extends $pb.GeneratedMessage {
  factory SetClientConfigReq({
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? config,
  }) {
    final result = create();
    if (config != null) result.config.addEntries(config);
    return result;
  }

  SetClientConfigReq._();

  factory SetClientConfigReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetClientConfigReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetClientConfigReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'config',
        entryClassName: 'SetClientConfigReq.ConfigEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('openim.admin'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetClientConfigReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetClientConfigReq copyWith(void Function(SetClientConfigReq) updates) =>
      super.copyWith((message) => updates(message as SetClientConfigReq))
          as SetClientConfigReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetClientConfigReq create() => SetClientConfigReq._();
  @$core.override
  SetClientConfigReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetClientConfigReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetClientConfigReq>(create);
  static SetClientConfigReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.String> get config => $_getMap(0);
}

class SetClientConfigResp extends $pb.GeneratedMessage {
  factory SetClientConfigResp() => create();

  SetClientConfigResp._();

  factory SetClientConfigResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetClientConfigResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetClientConfigResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetClientConfigResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetClientConfigResp copyWith(void Function(SetClientConfigResp) updates) =>
      super.copyWith((message) => updates(message as SetClientConfigResp))
          as SetClientConfigResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetClientConfigResp create() => SetClientConfigResp._();
  @$core.override
  SetClientConfigResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetClientConfigResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetClientConfigResp>(create);
  static SetClientConfigResp? _defaultInstance;
}

class DelClientConfigReq extends $pb.GeneratedMessage {
  factory DelClientConfigReq({
    $core.Iterable<$core.String>? keys,
  }) {
    final result = create();
    if (keys != null) result.keys.addAll(keys);
    return result;
  }

  DelClientConfigReq._();

  factory DelClientConfigReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelClientConfigReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelClientConfigReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'keys')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelClientConfigReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelClientConfigReq copyWith(void Function(DelClientConfigReq) updates) =>
      super.copyWith((message) => updates(message as DelClientConfigReq))
          as DelClientConfigReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelClientConfigReq create() => DelClientConfigReq._();
  @$core.override
  DelClientConfigReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelClientConfigReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelClientConfigReq>(create);
  static DelClientConfigReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get keys => $_getList(0);
}

class DelClientConfigResp extends $pb.GeneratedMessage {
  factory DelClientConfigResp() => create();

  DelClientConfigResp._();

  factory DelClientConfigResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DelClientConfigResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DelClientConfigResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelClientConfigResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DelClientConfigResp copyWith(void Function(DelClientConfigResp) updates) =>
      super.copyWith((message) => updates(message as DelClientConfigResp))
          as DelClientConfigResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DelClientConfigResp create() => DelClientConfigResp._();
  @$core.override
  DelClientConfigResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DelClientConfigResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DelClientConfigResp>(create);
  static DelClientConfigResp? _defaultInstance;
}

class GetClientConfigReq extends $pb.GeneratedMessage {
  factory GetClientConfigReq() => create();

  GetClientConfigReq._();

  factory GetClientConfigReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetClientConfigReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetClientConfigReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClientConfigReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClientConfigReq copyWith(void Function(GetClientConfigReq) updates) =>
      super.copyWith((message) => updates(message as GetClientConfigReq))
          as GetClientConfigReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetClientConfigReq create() => GetClientConfigReq._();
  @$core.override
  GetClientConfigReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetClientConfigReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetClientConfigReq>(create);
  static GetClientConfigReq? _defaultInstance;
}

class GetClientConfigResp extends $pb.GeneratedMessage {
  factory GetClientConfigResp({
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? config,
  }) {
    final result = create();
    if (config != null) result.config.addEntries(config);
    return result;
  }

  GetClientConfigResp._();

  factory GetClientConfigResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetClientConfigResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetClientConfigResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'config',
        entryClassName: 'GetClientConfigResp.ConfigEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('openim.admin'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClientConfigResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClientConfigResp copyWith(void Function(GetClientConfigResp) updates) =>
      super.copyWith((message) => updates(message as GetClientConfigResp))
          as GetClientConfigResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetClientConfigResp create() => GetClientConfigResp._();
  @$core.override
  GetClientConfigResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetClientConfigResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetClientConfigResp>(create);
  static GetClientConfigResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.String> get config => $_getMap(0);
}

class GetUserTokenReq extends $pb.GeneratedMessage {
  factory GetUserTokenReq({
    $core.String? userID,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    return result;
  }

  GetUserTokenReq._();

  factory GetUserTokenReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserTokenReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserTokenReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserTokenReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserTokenReq copyWith(void Function(GetUserTokenReq) updates) =>
      super.copyWith((message) => updates(message as GetUserTokenReq))
          as GetUserTokenReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserTokenReq create() => GetUserTokenReq._();
  @$core.override
  GetUserTokenReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUserTokenReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserTokenReq>(create);
  static GetUserTokenReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);
}

class GetUserTokenResp extends $pb.GeneratedMessage {
  factory GetUserTokenResp({
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? tokensMap,
  }) {
    final result = create();
    if (tokensMap != null) result.tokensMap.addEntries(tokensMap);
    return result;
  }

  GetUserTokenResp._();

  factory GetUserTokenResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserTokenResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserTokenResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..m<$core.String, $core.int>(1, _omitFieldNames ? '' : 'tokensMap',
        protoName: 'tokensMap',
        entryClassName: 'GetUserTokenResp.TokensMapEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('openim.admin'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserTokenResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserTokenResp copyWith(void Function(GetUserTokenResp) updates) =>
      super.copyWith((message) => updates(message as GetUserTokenResp))
          as GetUserTokenResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserTokenResp create() => GetUserTokenResp._();
  @$core.override
  GetUserTokenResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUserTokenResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserTokenResp>(create);
  static GetUserTokenResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.int> get tokensMap => $_getMap(0);
}

class ApplicationVersion extends $pb.GeneratedMessage {
  factory ApplicationVersion({
    $core.String? id,
    $core.String? platform,
    $core.String? version,
    $core.String? url,
    $core.String? text,
    $core.bool? force,
    $core.bool? latest,
    $core.bool? hot,
    $fixnum.Int64? createTime,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (platform != null) result.platform = platform;
    if (version != null) result.version = version;
    if (url != null) result.url = url;
    if (text != null) result.text = text;
    if (force != null) result.force = force;
    if (latest != null) result.latest = latest;
    if (hot != null) result.hot = hot;
    if (createTime != null) result.createTime = createTime;
    return result;
  }

  ApplicationVersion._();

  factory ApplicationVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApplicationVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplicationVersion',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'version')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..aOS(5, _omitFieldNames ? '' : 'text')
    ..aOB(6, _omitFieldNames ? '' : 'force')
    ..aOB(7, _omitFieldNames ? '' : 'latest')
    ..aOB(8, _omitFieldNames ? '' : 'hot')
    ..aInt64(9, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplicationVersion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplicationVersion copyWith(void Function(ApplicationVersion) updates) =>
      super.copyWith((message) => updates(message as ApplicationVersion))
          as ApplicationVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplicationVersion create() => ApplicationVersion._();
  @$core.override
  ApplicationVersion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApplicationVersion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplicationVersion>(create);
  static ApplicationVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(2);
  @$pb.TagNumber(3)
  set version($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get text => $_getSZ(4);
  @$pb.TagNumber(5)
  set text($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasText() => $_has(4);
  @$pb.TagNumber(5)
  void clearText() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get force => $_getBF(5);
  @$pb.TagNumber(6)
  set force($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasForce() => $_has(5);
  @$pb.TagNumber(6)
  void clearForce() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get latest => $_getBF(6);
  @$pb.TagNumber(7)
  set latest($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLatest() => $_has(6);
  @$pb.TagNumber(7)
  void clearLatest() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get hot => $_getBF(7);
  @$pb.TagNumber(8)
  set hot($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHot() => $_has(7);
  @$pb.TagNumber(8)
  void clearHot() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createTime => $_getI64(8);
  @$pb.TagNumber(9)
  set createTime($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreateTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreateTime() => $_clearField(9);
}

class LatestApplicationVersionReq extends $pb.GeneratedMessage {
  factory LatestApplicationVersionReq({
    $core.String? platform,
    $core.String? version,
  }) {
    final result = create();
    if (platform != null) result.platform = platform;
    if (version != null) result.version = version;
    return result;
  }

  LatestApplicationVersionReq._();

  factory LatestApplicationVersionReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LatestApplicationVersionReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LatestApplicationVersionReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatestApplicationVersionReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatestApplicationVersionReq copyWith(
          void Function(LatestApplicationVersionReq) updates) =>
      super.copyWith(
              (message) => updates(message as LatestApplicationVersionReq))
          as LatestApplicationVersionReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LatestApplicationVersionReq create() =>
      LatestApplicationVersionReq._();
  @$core.override
  LatestApplicationVersionReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LatestApplicationVersionReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LatestApplicationVersionReq>(create);
  static LatestApplicationVersionReq? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(3)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class LatestApplicationVersionResp extends $pb.GeneratedMessage {
  factory LatestApplicationVersionResp({
    ApplicationVersion? version,
  }) {
    final result = create();
    if (version != null) result.version = version;
    return result;
  }

  LatestApplicationVersionResp._();

  factory LatestApplicationVersionResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LatestApplicationVersionResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LatestApplicationVersionResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOM<ApplicationVersion>(1, _omitFieldNames ? '' : 'version',
        subBuilder: ApplicationVersion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatestApplicationVersionResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LatestApplicationVersionResp copyWith(
          void Function(LatestApplicationVersionResp) updates) =>
      super.copyWith(
              (message) => updates(message as LatestApplicationVersionResp))
          as LatestApplicationVersionResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LatestApplicationVersionResp create() =>
      LatestApplicationVersionResp._();
  @$core.override
  LatestApplicationVersionResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LatestApplicationVersionResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LatestApplicationVersionResp>(create);
  static LatestApplicationVersionResp? _defaultInstance;

  @$pb.TagNumber(1)
  ApplicationVersion get version => $_getN(0);
  @$pb.TagNumber(1)
  set version(ApplicationVersion value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  ApplicationVersion ensureVersion() => $_ensure(0);
}

class AddApplicationVersionReq extends $pb.GeneratedMessage {
  factory AddApplicationVersionReq({
    $core.String? platform,
    $core.String? version,
    $core.String? url,
    $core.String? text,
    $core.bool? force,
    $core.bool? latest,
    $core.bool? hot,
  }) {
    final result = create();
    if (platform != null) result.platform = platform;
    if (version != null) result.version = version;
    if (url != null) result.url = url;
    if (text != null) result.text = text;
    if (force != null) result.force = force;
    if (latest != null) result.latest = latest;
    if (hot != null) result.hot = hot;
    return result;
  }

  AddApplicationVersionReq._();

  factory AddApplicationVersionReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddApplicationVersionReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddApplicationVersionReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..aOS(4, _omitFieldNames ? '' : 'text')
    ..aOB(5, _omitFieldNames ? '' : 'force')
    ..aOB(6, _omitFieldNames ? '' : 'latest')
    ..aOB(7, _omitFieldNames ? '' : 'hot')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddApplicationVersionReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddApplicationVersionReq copyWith(
          void Function(AddApplicationVersionReq) updates) =>
      super.copyWith((message) => updates(message as AddApplicationVersionReq))
          as AddApplicationVersionReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddApplicationVersionReq create() => AddApplicationVersionReq._();
  @$core.override
  AddApplicationVersionReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddApplicationVersionReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddApplicationVersionReq>(create);
  static AddApplicationVersionReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get text => $_getSZ(3);
  @$pb.TagNumber(4)
  set text($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasText() => $_has(3);
  @$pb.TagNumber(4)
  void clearText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get force => $_getBF(4);
  @$pb.TagNumber(5)
  set force($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasForce() => $_has(4);
  @$pb.TagNumber(5)
  void clearForce() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get latest => $_getBF(5);
  @$pb.TagNumber(6)
  set latest($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLatest() => $_has(5);
  @$pb.TagNumber(6)
  void clearLatest() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get hot => $_getBF(6);
  @$pb.TagNumber(7)
  set hot($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHot() => $_has(6);
  @$pb.TagNumber(7)
  void clearHot() => $_clearField(7);
}

class AddApplicationVersionResp extends $pb.GeneratedMessage {
  factory AddApplicationVersionResp() => create();

  AddApplicationVersionResp._();

  factory AddApplicationVersionResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddApplicationVersionResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddApplicationVersionResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddApplicationVersionResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddApplicationVersionResp copyWith(
          void Function(AddApplicationVersionResp) updates) =>
      super.copyWith((message) => updates(message as AddApplicationVersionResp))
          as AddApplicationVersionResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddApplicationVersionResp create() => AddApplicationVersionResp._();
  @$core.override
  AddApplicationVersionResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddApplicationVersionResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddApplicationVersionResp>(create);
  static AddApplicationVersionResp? _defaultInstance;
}

class UpdateApplicationVersionReq extends $pb.GeneratedMessage {
  factory UpdateApplicationVersionReq({
    $core.String? id,
    $0.StringValue? platform,
    $0.StringValue? version,
    $0.StringValue? url,
    $0.StringValue? text,
    $0.BoolValue? force,
    $0.BoolValue? latest,
    $0.BoolValue? hot,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (platform != null) result.platform = platform;
    if (version != null) result.version = version;
    if (url != null) result.url = url;
    if (text != null) result.text = text;
    if (force != null) result.force = force;
    if (latest != null) result.latest = latest;
    if (hot != null) result.hot = hot;
    return result;
  }

  UpdateApplicationVersionReq._();

  factory UpdateApplicationVersionReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateApplicationVersionReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateApplicationVersionReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$0.StringValue>(2, _omitFieldNames ? '' : 'platform',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(3, _omitFieldNames ? '' : 'version',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(4, _omitFieldNames ? '' : 'url',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(5, _omitFieldNames ? '' : 'text',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.BoolValue>(6, _omitFieldNames ? '' : 'force',
        subBuilder: $0.BoolValue.create)
    ..aOM<$0.BoolValue>(7, _omitFieldNames ? '' : 'latest',
        subBuilder: $0.BoolValue.create)
    ..aOM<$0.BoolValue>(8, _omitFieldNames ? '' : 'hot',
        subBuilder: $0.BoolValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateApplicationVersionReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateApplicationVersionReq copyWith(
          void Function(UpdateApplicationVersionReq) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateApplicationVersionReq))
          as UpdateApplicationVersionReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateApplicationVersionReq create() =>
      UpdateApplicationVersionReq._();
  @$core.override
  UpdateApplicationVersionReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateApplicationVersionReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateApplicationVersionReq>(create);
  static UpdateApplicationVersionReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.StringValue get platform => $_getN(1);
  @$pb.TagNumber(2)
  set platform($0.StringValue value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.StringValue ensurePlatform() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.StringValue get version => $_getN(2);
  @$pb.TagNumber(3)
  set version($0.StringValue value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.StringValue ensureVersion() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.StringValue get url => $_getN(3);
  @$pb.TagNumber(4)
  set url($0.StringValue value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.StringValue ensureUrl() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.StringValue get text => $_getN(4);
  @$pb.TagNumber(5)
  set text($0.StringValue value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasText() => $_has(4);
  @$pb.TagNumber(5)
  void clearText() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.StringValue ensureText() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.BoolValue get force => $_getN(5);
  @$pb.TagNumber(6)
  set force($0.BoolValue value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasForce() => $_has(5);
  @$pb.TagNumber(6)
  void clearForce() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.BoolValue ensureForce() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.BoolValue get latest => $_getN(6);
  @$pb.TagNumber(7)
  set latest($0.BoolValue value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLatest() => $_has(6);
  @$pb.TagNumber(7)
  void clearLatest() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.BoolValue ensureLatest() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.BoolValue get hot => $_getN(7);
  @$pb.TagNumber(8)
  set hot($0.BoolValue value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasHot() => $_has(7);
  @$pb.TagNumber(8)
  void clearHot() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.BoolValue ensureHot() => $_ensure(7);
}

class UpdateApplicationVersionResp extends $pb.GeneratedMessage {
  factory UpdateApplicationVersionResp() => create();

  UpdateApplicationVersionResp._();

  factory UpdateApplicationVersionResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateApplicationVersionResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateApplicationVersionResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateApplicationVersionResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateApplicationVersionResp copyWith(
          void Function(UpdateApplicationVersionResp) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateApplicationVersionResp))
          as UpdateApplicationVersionResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateApplicationVersionResp create() =>
      UpdateApplicationVersionResp._();
  @$core.override
  UpdateApplicationVersionResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateApplicationVersionResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateApplicationVersionResp>(create);
  static UpdateApplicationVersionResp? _defaultInstance;
}

class DeleteApplicationVersionReq extends $pb.GeneratedMessage {
  factory DeleteApplicationVersionReq({
    $core.Iterable<$core.String>? id,
  }) {
    final result = create();
    if (id != null) result.id.addAll(id);
    return result;
  }

  DeleteApplicationVersionReq._();

  factory DeleteApplicationVersionReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteApplicationVersionReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteApplicationVersionReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteApplicationVersionReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteApplicationVersionReq copyWith(
          void Function(DeleteApplicationVersionReq) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteApplicationVersionReq))
          as DeleteApplicationVersionReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteApplicationVersionReq create() =>
      DeleteApplicationVersionReq._();
  @$core.override
  DeleteApplicationVersionReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteApplicationVersionReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteApplicationVersionReq>(create);
  static DeleteApplicationVersionReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get id => $_getList(0);
}

class DeleteApplicationVersionResp extends $pb.GeneratedMessage {
  factory DeleteApplicationVersionResp() => create();

  DeleteApplicationVersionResp._();

  factory DeleteApplicationVersionResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteApplicationVersionResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteApplicationVersionResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteApplicationVersionResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteApplicationVersionResp copyWith(
          void Function(DeleteApplicationVersionResp) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteApplicationVersionResp))
          as DeleteApplicationVersionResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteApplicationVersionResp create() =>
      DeleteApplicationVersionResp._();
  @$core.override
  DeleteApplicationVersionResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteApplicationVersionResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteApplicationVersionResp>(create);
  static DeleteApplicationVersionResp? _defaultInstance;
}

class PageApplicationVersionReq extends $pb.GeneratedMessage {
  factory PageApplicationVersionReq({
    $core.Iterable<$core.String>? platform,
    $1.RequestPagination? pagination,
  }) {
    final result = create();
    if (platform != null) result.platform.addAll(platform);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  PageApplicationVersionReq._();

  factory PageApplicationVersionReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PageApplicationVersionReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PageApplicationVersionReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'platform')
    ..aOM<$1.RequestPagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.RequestPagination.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageApplicationVersionReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageApplicationVersionReq copyWith(
          void Function(PageApplicationVersionReq) updates) =>
      super.copyWith((message) => updates(message as PageApplicationVersionReq))
          as PageApplicationVersionReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PageApplicationVersionReq create() => PageApplicationVersionReq._();
  @$core.override
  PageApplicationVersionReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PageApplicationVersionReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PageApplicationVersionReq>(create);
  static PageApplicationVersionReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get platform => $_getList(0);

  @$pb.TagNumber(2)
  $1.RequestPagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.RequestPagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.RequestPagination ensurePagination() => $_ensure(1);
}

class PageApplicationVersionResp extends $pb.GeneratedMessage {
  factory PageApplicationVersionResp({
    $fixnum.Int64? total,
    $core.Iterable<ApplicationVersion>? versions,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (versions != null) result.versions.addAll(versions);
    return result;
  }

  PageApplicationVersionResp._();

  factory PageApplicationVersionResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PageApplicationVersionResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PageApplicationVersionResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.admin'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'total')
    ..pPM<ApplicationVersion>(2, _omitFieldNames ? '' : 'versions',
        subBuilder: ApplicationVersion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageApplicationVersionResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageApplicationVersionResp copyWith(
          void Function(PageApplicationVersionResp) updates) =>
      super.copyWith(
              (message) => updates(message as PageApplicationVersionResp))
          as PageApplicationVersionResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PageApplicationVersionResp create() => PageApplicationVersionResp._();
  @$core.override
  PageApplicationVersionResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PageApplicationVersionResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PageApplicationVersionResp>(create);
  static PageApplicationVersionResp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get total => $_getI64(0);
  @$pb.TagNumber(1)
  set total($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ApplicationVersion> get versions => $_getList(1);
}

class adminApi {
  final $pb.RpcClient _client;

  adminApi(this._client);

  /// Login
  $async.Future<LoginResp> login($pb.ClientContext? ctx, LoginReq request) =>
      _client.invoke<LoginResp>(ctx, 'admin', 'Login', request, LoginResp());
  $async.Future<ChangePasswordResp> changePassword(
          $pb.ClientContext? ctx, ChangePasswordReq request) =>
      _client.invoke<ChangePasswordResp>(
          ctx, 'admin', 'ChangePassword', request, ChangePasswordResp());
  $async.Future<AdminUpdateInfoResp> adminUpdateInfo(
          $pb.ClientContext? ctx, AdminUpdateInfoReq request) =>
      _client.invoke<AdminUpdateInfoResp>(
          ctx, 'admin', 'AdminUpdateInfo', request, AdminUpdateInfoResp());

  /// Get administrator information
  $async.Future<GetAdminInfoResp> getAdminInfo(
          $pb.ClientContext? ctx, GetAdminInfoReq request) =>
      _client.invoke<GetAdminInfoResp>(
          ctx, 'admin', 'GetAdminInfo', request, GetAdminInfoResp());
  $async.Future<AddAdminAccountResp> addAdminAccount(
          $pb.ClientContext? ctx, AddAdminAccountReq request) =>
      _client.invoke<AddAdminAccountResp>(
          ctx, 'admin', 'AddAdminAccount', request, AddAdminAccountResp());
  $async.Future<ChangeAdminPasswordResp> changeAdminPassword(
          $pb.ClientContext? ctx, ChangeAdminPasswordReq request) =>
      _client.invoke<ChangeAdminPasswordResp>(ctx, 'admin',
          'ChangeAdminPassword', request, ChangeAdminPasswordResp());
  $async.Future<DelAdminAccountResp> delAdminAccount(
          $pb.ClientContext? ctx, DelAdminAccountReq request) =>
      _client.invoke<DelAdminAccountResp>(
          ctx, 'admin', 'DelAdminAccount', request, DelAdminAccountResp());
  $async.Future<SearchAdminAccountResp> searchAdminAccount(
          $pb.ClientContext? ctx, SearchAdminAccountReq request) =>
      _client.invoke<SearchAdminAccountResp>(ctx, 'admin', 'SearchAdminAccount',
          request, SearchAdminAccountResp());

  /// Add Remove Get default friend list on registration
  $async.Future<AddDefaultFriendResp> addDefaultFriend(
          $pb.ClientContext? ctx, AddDefaultFriendReq request) =>
      _client.invoke<AddDefaultFriendResp>(
          ctx, 'admin', 'AddDefaultFriend', request, AddDefaultFriendResp());
  $async.Future<DelDefaultFriendResp> delDefaultFriend(
          $pb.ClientContext? ctx, DelDefaultFriendReq request) =>
      _client.invoke<DelDefaultFriendResp>(
          ctx, 'admin', 'DelDefaultFriend', request, DelDefaultFriendResp());
  $async.Future<FindDefaultFriendResp> findDefaultFriend(
          $pb.ClientContext? ctx, FindDefaultFriendReq request) =>
      _client.invoke<FindDefaultFriendResp>(
          ctx, 'admin', 'FindDefaultFriend', request, FindDefaultFriendResp());
  $async.Future<SearchDefaultFriendResp> searchDefaultFriend(
          $pb.ClientContext? ctx, SearchDefaultFriendReq request) =>
      _client.invoke<SearchDefaultFriendResp>(ctx, 'admin',
          'SearchDefaultFriend', request, SearchDefaultFriendResp());
  $async.Future<AddDefaultGroupResp> addDefaultGroup(
          $pb.ClientContext? ctx, AddDefaultGroupReq request) =>
      _client.invoke<AddDefaultGroupResp>(
          ctx, 'admin', 'AddDefaultGroup', request, AddDefaultGroupResp());
  $async.Future<DelDefaultGroupResp> delDefaultGroup(
          $pb.ClientContext? ctx, DelDefaultGroupReq request) =>
      _client.invoke<DelDefaultGroupResp>(
          ctx, 'admin', 'DelDefaultGroup', request, DelDefaultGroupResp());
  $async.Future<FindDefaultGroupResp> findDefaultGroup(
          $pb.ClientContext? ctx, FindDefaultGroupReq request) =>
      _client.invoke<FindDefaultGroupResp>(
          ctx, 'admin', 'FindDefaultGroup', request, FindDefaultGroupResp());
  $async.Future<SearchDefaultGroupResp> searchDefaultGroup(
          $pb.ClientContext? ctx, SearchDefaultGroupReq request) =>
      _client.invoke<SearchDefaultGroupResp>(ctx, 'admin', 'SearchDefaultGroup',
          request, SearchDefaultGroupResp());

  /// Invitation Code Generate Query Get
  $async.Future<AddInvitationCodeResp> addInvitationCode(
          $pb.ClientContext? ctx, AddInvitationCodeReq request) =>
      _client.invoke<AddInvitationCodeResp>(
          ctx, 'admin', 'AddInvitationCode', request, AddInvitationCodeResp());
  $async.Future<GenInvitationCodeResp> genInvitationCode(
          $pb.ClientContext? ctx, GenInvitationCodeReq request) =>
      _client.invoke<GenInvitationCodeResp>(
          ctx, 'admin', 'GenInvitationCode', request, GenInvitationCodeResp());
  $async.Future<FindInvitationCodeResp> findInvitationCode(
          $pb.ClientContext? ctx, FindInvitationCodeReq request) =>
      _client.invoke<FindInvitationCodeResp>(ctx, 'admin', 'FindInvitationCode',
          request, FindInvitationCodeResp());
  $async.Future<UseInvitationCodeResp> useInvitationCode(
          $pb.ClientContext? ctx, UseInvitationCodeReq request) =>
      _client.invoke<UseInvitationCodeResp>(
          ctx, 'admin', 'UseInvitationCode', request, UseInvitationCodeResp());
  $async.Future<DelInvitationCodeResp> delInvitationCode(
          $pb.ClientContext? ctx, DelInvitationCodeReq request) =>
      _client.invoke<DelInvitationCodeResp>(
          ctx, 'admin', 'DelInvitationCode', request, DelInvitationCodeResp());
  $async.Future<SearchInvitationCodeResp> searchInvitationCode(
          $pb.ClientContext? ctx, SearchInvitationCodeReq request) =>
      _client.invoke<SearchInvitationCodeResp>(ctx, 'admin',
          'SearchInvitationCode', request, SearchInvitationCodeResp());

  /// User login ip limit Query Add Remove
  $async.Future<SearchUserIPLimitLoginResp> searchUserIPLimitLogin(
          $pb.ClientContext? ctx, SearchUserIPLimitLoginReq request) =>
      _client.invoke<SearchUserIPLimitLoginResp>(ctx, 'admin',
          'SearchUserIPLimitLogin', request, SearchUserIPLimitLoginResp());
  $async.Future<AddUserIPLimitLoginResp> addUserIPLimitLogin(
          $pb.ClientContext? ctx, AddUserIPLimitLoginReq request) =>
      _client.invoke<AddUserIPLimitLoginResp>(ctx, 'admin',
          'AddUserIPLimitLogin', request, AddUserIPLimitLoginResp());
  $async.Future<DelUserIPLimitLoginResp> delUserIPLimitLogin(
          $pb.ClientContext? ctx, DelUserIPLimitLoginReq request) =>
      _client.invoke<DelUserIPLimitLoginResp>(ctx, 'admin',
          'DelUserIPLimitLogin', request, DelUserIPLimitLoginResp());

  /// Prohibit users from registering at certain ip Query Add Remove
  $async.Future<SearchIPForbiddenResp> searchIPForbidden(
          $pb.ClientContext? ctx, SearchIPForbiddenReq request) =>
      _client.invoke<SearchIPForbiddenResp>(
          ctx, 'admin', 'SearchIPForbidden', request, SearchIPForbiddenResp());
  $async.Future<AddIPForbiddenResp> addIPForbidden(
          $pb.ClientContext? ctx, AddIPForbiddenReq request) =>
      _client.invoke<AddIPForbiddenResp>(
          ctx, 'admin', 'AddIPForbidden', request, AddIPForbiddenResp());
  $async.Future<DelIPForbiddenResp> delIPForbidden(
          $pb.ClientContext? ctx, DelIPForbiddenReq request) =>
      _client.invoke<DelIPForbiddenResp>(
          ctx, 'admin', 'DelIPForbidden', request, DelIPForbiddenResp());

  /// User Management Related Add Block/Unblock Pull
  $async.Future<CancellationUserResp> cancellationUser(
          $pb.ClientContext? ctx, CancellationUserReq request) =>
      _client.invoke<CancellationUserResp>(
          ctx, 'admin', 'CancellationUser', request, CancellationUserResp());
  $async.Future<BlockUserResp> blockUser(
          $pb.ClientContext? ctx, BlockUserReq request) =>
      _client.invoke<BlockUserResp>(
          ctx, 'admin', 'BlockUser', request, BlockUserResp());
  $async.Future<UnblockUserResp> unblockUser(
          $pb.ClientContext? ctx, UnblockUserReq request) =>
      _client.invoke<UnblockUserResp>(
          ctx, 'admin', 'UnblockUser', request, UnblockUserResp());
  $async.Future<SearchBlockUserResp> searchBlockUser(
          $pb.ClientContext? ctx, SearchBlockUserReq request) =>
      _client.invoke<SearchBlockUserResp>(
          ctx, 'admin', 'SearchBlockUser', request, SearchBlockUserResp());
  $async.Future<FindUserBlockInfoResp> findUserBlockInfo(
          $pb.ClientContext? ctx, FindUserBlockInfoReq request) =>
      _client.invoke<FindUserBlockInfoResp>(
          ctx, 'admin', 'FindUserBlockInfo', request, FindUserBlockInfoResp());
  $async.Future<CheckRegisterForbiddenResp> checkRegisterForbidden(
          $pb.ClientContext? ctx, CheckRegisterForbiddenReq request) =>
      _client.invoke<CheckRegisterForbiddenResp>(ctx, 'admin',
          'CheckRegisterForbidden', request, CheckRegisterForbiddenResp());
  $async.Future<CheckLoginForbiddenResp> checkLoginForbidden(
          $pb.ClientContext? ctx, CheckLoginForbiddenReq request) =>
      _client.invoke<CheckLoginForbiddenResp>(ctx, 'admin',
          'CheckLoginForbidden', request, CheckLoginForbiddenResp());

  /// create token
  $async.Future<CreateTokenResp> createToken(
          $pb.ClientContext? ctx, CreateTokenReq request) =>
      _client.invoke<CreateTokenResp>(
          ctx, 'admin', 'CreateToken', request, CreateTokenResp());

  /// parse token
  $async.Future<ParseTokenResp> parseToken(
          $pb.ClientContext? ctx, ParseTokenReq request) =>
      _client.invoke<ParseTokenResp>(
          ctx, 'admin', 'ParseToken', request, ParseTokenResp());

  /// app
  $async.Future<AddAppletResp> addApplet(
          $pb.ClientContext? ctx, AddAppletReq request) =>
      _client.invoke<AddAppletResp>(
          ctx, 'admin', 'AddApplet', request, AddAppletResp());
  $async.Future<DelAppletResp> delApplet(
          $pb.ClientContext? ctx, DelAppletReq request) =>
      _client.invoke<DelAppletResp>(
          ctx, 'admin', 'DelApplet', request, DelAppletResp());
  $async.Future<UpdateAppletResp> updateApplet(
          $pb.ClientContext? ctx, UpdateAppletReq request) =>
      _client.invoke<UpdateAppletResp>(
          ctx, 'admin', 'UpdateApplet', request, UpdateAppletResp());
  $async.Future<FindAppletResp> findApplet(
          $pb.ClientContext? ctx, FindAppletReq request) =>
      _client.invoke<FindAppletResp>(
          ctx, 'admin', 'FindApplet', request, FindAppletResp());
  $async.Future<SearchAppletResp> searchApplet(
          $pb.ClientContext? ctx, SearchAppletReq request) =>
      _client.invoke<SearchAppletResp>(
          ctx, 'admin', 'SearchApplet', request, SearchAppletResp());

  /// Client Configuration
  $async.Future<GetClientConfigResp> getClientConfig(
          $pb.ClientContext? ctx, GetClientConfigReq request) =>
      _client.invoke<GetClientConfigResp>(
          ctx, 'admin', 'GetClientConfig', request, GetClientConfigResp());
  $async.Future<SetClientConfigResp> setClientConfig(
          $pb.ClientContext? ctx, SetClientConfigReq request) =>
      _client.invoke<SetClientConfigResp>(
          ctx, 'admin', 'SetClientConfig', request, SetClientConfigResp());
  $async.Future<DelClientConfigResp> delClientConfig(
          $pb.ClientContext? ctx, DelClientConfigReq request) =>
      _client.invoke<DelClientConfigResp>(
          ctx, 'admin', 'DelClientConfig', request, DelClientConfigResp());
  $async.Future<GetUserTokenResp> getUserToken(
          $pb.ClientContext? ctx, GetUserTokenReq request) =>
      _client.invoke<GetUserTokenResp>(
          ctx, 'admin', 'GetUserToken', request, GetUserTokenResp());

  /// invalidate token
  $async.Future<InvalidateTokenResp> invalidateToken(
          $pb.ClientContext? ctx, InvalidateTokenReq request) =>
      _client.invoke<InvalidateTokenResp>(
          ctx, 'admin', 'InvalidateToken', request, InvalidateTokenResp());
  $async.Future<LatestApplicationVersionResp> latestApplicationVersion(
          $pb.ClientContext? ctx, LatestApplicationVersionReq request) =>
      _client.invoke<LatestApplicationVersionResp>(ctx, 'admin',
          'LatestApplicationVersion', request, LatestApplicationVersionResp());
  $async.Future<AddApplicationVersionResp> addApplicationVersion(
          $pb.ClientContext? ctx, AddApplicationVersionReq request) =>
      _client.invoke<AddApplicationVersionResp>(ctx, 'admin',
          'AddApplicationVersion', request, AddApplicationVersionResp());
  $async.Future<UpdateApplicationVersionResp> updateApplicationVersion(
          $pb.ClientContext? ctx, UpdateApplicationVersionReq request) =>
      _client.invoke<UpdateApplicationVersionResp>(ctx, 'admin',
          'UpdateApplicationVersion', request, UpdateApplicationVersionResp());
  $async.Future<DeleteApplicationVersionResp> deleteApplicationVersion(
          $pb.ClientContext? ctx, DeleteApplicationVersionReq request) =>
      _client.invoke<DeleteApplicationVersionResp>(ctx, 'admin',
          'DeleteApplicationVersion', request, DeleteApplicationVersionResp());
  $async.Future<PageApplicationVersionResp> pageApplicationVersion(
          $pb.ClientContext? ctx, PageApplicationVersionReq request) =>
      _client.invoke<PageApplicationVersionResp>(ctx, 'admin',
          'PageApplicationVersion', request, PageApplicationVersionResp());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
