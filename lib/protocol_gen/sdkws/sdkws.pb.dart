// This is a generated file - do not edit.
//
// Generated from sdkws/sdkws.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../wrapperspb/wrapperspb.pb.dart' as $0;
import 'sdkws.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'sdkws.pbenum.dart';

class GroupInfo extends $pb.GeneratedMessage {
  factory GroupInfo({
    $core.String? groupID,
    $core.String? groupName,
    $core.String? notification,
    $core.String? introduction,
    $core.String? faceURL,
    $core.String? ownerUserID,
    $fixnum.Int64? createTime,
    $core.int? memberCount,
    $core.String? ex,
    $core.int? status,
    $core.String? creatorUserID,
    $core.int? groupType,
    $core.int? needVerification,
    $core.int? lookMemberInfo,
    $core.int? applyMemberFriend,
    $fixnum.Int64? notificationUpdateTime,
    $core.String? notificationUserID,
  }) {
    final result = create();
    if (groupID != null) result.groupID = groupID;
    if (groupName != null) result.groupName = groupName;
    if (notification != null) result.notification = notification;
    if (introduction != null) result.introduction = introduction;
    if (faceURL != null) result.faceURL = faceURL;
    if (ownerUserID != null) result.ownerUserID = ownerUserID;
    if (createTime != null) result.createTime = createTime;
    if (memberCount != null) result.memberCount = memberCount;
    if (ex != null) result.ex = ex;
    if (status != null) result.status = status;
    if (creatorUserID != null) result.creatorUserID = creatorUserID;
    if (groupType != null) result.groupType = groupType;
    if (needVerification != null) result.needVerification = needVerification;
    if (lookMemberInfo != null) result.lookMemberInfo = lookMemberInfo;
    if (applyMemberFriend != null) result.applyMemberFriend = applyMemberFriend;
    if (notificationUpdateTime != null)
      result.notificationUpdateTime = notificationUpdateTime;
    if (notificationUserID != null)
      result.notificationUserID = notificationUserID;
    return result;
  }

  GroupInfo._();

  factory GroupInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupID', protoName: 'groupID')
    ..aOS(2, _omitFieldNames ? '' : 'groupName', protoName: 'groupName')
    ..aOS(3, _omitFieldNames ? '' : 'notification')
    ..aOS(4, _omitFieldNames ? '' : 'introduction')
    ..aOS(5, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aOS(6, _omitFieldNames ? '' : 'ownerUserID', protoName: 'ownerUserID')
    ..aInt64(7, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aI(8, _omitFieldNames ? '' : 'memberCount',
        protoName: 'memberCount', fieldType: $pb.PbFieldType.OU3)
    ..aOS(9, _omitFieldNames ? '' : 'ex')
    ..aI(10, _omitFieldNames ? '' : 'status')
    ..aOS(11, _omitFieldNames ? '' : 'creatorUserID',
        protoName: 'creatorUserID')
    ..aI(12, _omitFieldNames ? '' : 'groupType', protoName: 'groupType')
    ..aI(13, _omitFieldNames ? '' : 'needVerification',
        protoName: 'needVerification')
    ..aI(14, _omitFieldNames ? '' : 'lookMemberInfo',
        protoName: 'lookMemberInfo')
    ..aI(15, _omitFieldNames ? '' : 'applyMemberFriend',
        protoName: 'applyMemberFriend')
    ..aInt64(16, _omitFieldNames ? '' : 'notificationUpdateTime',
        protoName: 'notificationUpdateTime')
    ..aOS(17, _omitFieldNames ? '' : 'notificationUserID',
        protoName: 'notificationUserID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupInfo copyWith(void Function(GroupInfo) updates) =>
      super.copyWith((message) => updates(message as GroupInfo)) as GroupInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupInfo create() => GroupInfo._();
  @$core.override
  GroupInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GroupInfo>(create);
  static GroupInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupID => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupID() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get groupName => $_getSZ(1);
  @$pb.TagNumber(2)
  set groupName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGroupName() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get notification => $_getSZ(2);
  @$pb.TagNumber(3)
  set notification($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNotification() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotification() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get introduction => $_getSZ(3);
  @$pb.TagNumber(4)
  set introduction($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIntroduction() => $_has(3);
  @$pb.TagNumber(4)
  void clearIntroduction() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get faceURL => $_getSZ(4);
  @$pb.TagNumber(5)
  set faceURL($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFaceURL() => $_has(4);
  @$pb.TagNumber(5)
  void clearFaceURL() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ownerUserID => $_getSZ(5);
  @$pb.TagNumber(6)
  set ownerUserID($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOwnerUserID() => $_has(5);
  @$pb.TagNumber(6)
  void clearOwnerUserID() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get createTime => $_getI64(6);
  @$pb.TagNumber(7)
  set createTime($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreateTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreateTime() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get memberCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set memberCount($core.int value) => $_setUnsignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMemberCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearMemberCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get ex => $_getSZ(8);
  @$pb.TagNumber(9)
  set ex($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEx() => $_has(8);
  @$pb.TagNumber(9)
  void clearEx() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get status => $_getIZ(9);
  @$pb.TagNumber(10)
  set status($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get creatorUserID => $_getSZ(10);
  @$pb.TagNumber(11)
  set creatorUserID($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCreatorUserID() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatorUserID() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get groupType => $_getIZ(11);
  @$pb.TagNumber(12)
  set groupType($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasGroupType() => $_has(11);
  @$pb.TagNumber(12)
  void clearGroupType() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get needVerification => $_getIZ(12);
  @$pb.TagNumber(13)
  set needVerification($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNeedVerification() => $_has(12);
  @$pb.TagNumber(13)
  void clearNeedVerification() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get lookMemberInfo => $_getIZ(13);
  @$pb.TagNumber(14)
  set lookMemberInfo($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasLookMemberInfo() => $_has(13);
  @$pb.TagNumber(14)
  void clearLookMemberInfo() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get applyMemberFriend => $_getIZ(14);
  @$pb.TagNumber(15)
  set applyMemberFriend($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasApplyMemberFriend() => $_has(14);
  @$pb.TagNumber(15)
  void clearApplyMemberFriend() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get notificationUpdateTime => $_getI64(15);
  @$pb.TagNumber(16)
  set notificationUpdateTime($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasNotificationUpdateTime() => $_has(15);
  @$pb.TagNumber(16)
  void clearNotificationUpdateTime() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get notificationUserID => $_getSZ(16);
  @$pb.TagNumber(17)
  set notificationUserID($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasNotificationUserID() => $_has(16);
  @$pb.TagNumber(17)
  void clearNotificationUserID() => $_clearField(17);
}

class GroupInfoForSet extends $pb.GeneratedMessage {
  factory GroupInfoForSet({
    $core.String? groupID,
    $core.String? groupName,
    $core.String? notification,
    $core.String? introduction,
    $core.String? faceURL,
    $0.StringValue? ex,
    $0.Int32Value? needVerification,
    $0.Int32Value? lookMemberInfo,
    $0.Int32Value? applyMemberFriend,
  }) {
    final result = create();
    if (groupID != null) result.groupID = groupID;
    if (groupName != null) result.groupName = groupName;
    if (notification != null) result.notification = notification;
    if (introduction != null) result.introduction = introduction;
    if (faceURL != null) result.faceURL = faceURL;
    if (ex != null) result.ex = ex;
    if (needVerification != null) result.needVerification = needVerification;
    if (lookMemberInfo != null) result.lookMemberInfo = lookMemberInfo;
    if (applyMemberFriend != null) result.applyMemberFriend = applyMemberFriend;
    return result;
  }

  GroupInfoForSet._();

  factory GroupInfoForSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupInfoForSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupInfoForSet',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupID', protoName: 'groupID')
    ..aOS(2, _omitFieldNames ? '' : 'groupName', protoName: 'groupName')
    ..aOS(3, _omitFieldNames ? '' : 'notification')
    ..aOS(4, _omitFieldNames ? '' : 'introduction')
    ..aOS(5, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aOM<$0.StringValue>(6, _omitFieldNames ? '' : 'ex',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.Int32Value>(7, _omitFieldNames ? '' : 'needVerification',
        protoName: 'needVerification', subBuilder: $0.Int32Value.create)
    ..aOM<$0.Int32Value>(8, _omitFieldNames ? '' : 'lookMemberInfo',
        protoName: 'lookMemberInfo', subBuilder: $0.Int32Value.create)
    ..aOM<$0.Int32Value>(9, _omitFieldNames ? '' : 'applyMemberFriend',
        protoName: 'applyMemberFriend', subBuilder: $0.Int32Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupInfoForSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupInfoForSet copyWith(void Function(GroupInfoForSet) updates) =>
      super.copyWith((message) => updates(message as GroupInfoForSet))
          as GroupInfoForSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupInfoForSet create() => GroupInfoForSet._();
  @$core.override
  GroupInfoForSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupInfoForSet getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupInfoForSet>(create);
  static GroupInfoForSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupID => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupID() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get groupName => $_getSZ(1);
  @$pb.TagNumber(2)
  set groupName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGroupName() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get notification => $_getSZ(2);
  @$pb.TagNumber(3)
  set notification($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNotification() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotification() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get introduction => $_getSZ(3);
  @$pb.TagNumber(4)
  set introduction($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIntroduction() => $_has(3);
  @$pb.TagNumber(4)
  void clearIntroduction() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get faceURL => $_getSZ(4);
  @$pb.TagNumber(5)
  set faceURL($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFaceURL() => $_has(4);
  @$pb.TagNumber(5)
  void clearFaceURL() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.StringValue get ex => $_getN(5);
  @$pb.TagNumber(6)
  set ex($0.StringValue value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEx() => $_has(5);
  @$pb.TagNumber(6)
  void clearEx() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.StringValue ensureEx() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Int32Value get needVerification => $_getN(6);
  @$pb.TagNumber(7)
  set needVerification($0.Int32Value value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasNeedVerification() => $_has(6);
  @$pb.TagNumber(7)
  void clearNeedVerification() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Int32Value ensureNeedVerification() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Int32Value get lookMemberInfo => $_getN(7);
  @$pb.TagNumber(8)
  set lookMemberInfo($0.Int32Value value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLookMemberInfo() => $_has(7);
  @$pb.TagNumber(8)
  void clearLookMemberInfo() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Int32Value ensureLookMemberInfo() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Int32Value get applyMemberFriend => $_getN(8);
  @$pb.TagNumber(9)
  set applyMemberFriend($0.Int32Value value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasApplyMemberFriend() => $_has(8);
  @$pb.TagNumber(9)
  void clearApplyMemberFriend() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Int32Value ensureApplyMemberFriend() => $_ensure(8);
}

class GroupMemberFullInfo extends $pb.GeneratedMessage {
  factory GroupMemberFullInfo({
    $core.String? groupID,
    $core.String? userID,
    $core.int? roleLevel,
    $fixnum.Int64? joinTime,
    $core.String? nickname,
    $core.String? faceURL,
    $core.int? appMangerLevel,
    $core.int? joinSource,
    $core.String? operatorUserID,
    $core.String? ex,
    $fixnum.Int64? muteEndTime,
    $core.String? inviterUserID,
  }) {
    final result = create();
    if (groupID != null) result.groupID = groupID;
    if (userID != null) result.userID = userID;
    if (roleLevel != null) result.roleLevel = roleLevel;
    if (joinTime != null) result.joinTime = joinTime;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    if (appMangerLevel != null) result.appMangerLevel = appMangerLevel;
    if (joinSource != null) result.joinSource = joinSource;
    if (operatorUserID != null) result.operatorUserID = operatorUserID;
    if (ex != null) result.ex = ex;
    if (muteEndTime != null) result.muteEndTime = muteEndTime;
    if (inviterUserID != null) result.inviterUserID = inviterUserID;
    return result;
  }

  GroupMemberFullInfo._();

  factory GroupMemberFullInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupMemberFullInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupMemberFullInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'groupID', protoName: 'groupID')
    ..aOS(2, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aI(3, _omitFieldNames ? '' : 'roleLevel', protoName: 'roleLevel')
    ..aInt64(4, _omitFieldNames ? '' : 'joinTime', protoName: 'joinTime')
    ..aOS(5, _omitFieldNames ? '' : 'nickname')
    ..aOS(6, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aI(7, _omitFieldNames ? '' : 'appMangerLevel',
        protoName: 'appMangerLevel')
    ..aI(8, _omitFieldNames ? '' : 'joinSource', protoName: 'joinSource')
    ..aOS(9, _omitFieldNames ? '' : 'operatorUserID',
        protoName: 'operatorUserID')
    ..aOS(10, _omitFieldNames ? '' : 'ex')
    ..aInt64(11, _omitFieldNames ? '' : 'muteEndTime', protoName: 'muteEndTime')
    ..aOS(12, _omitFieldNames ? '' : 'inviterUserID',
        protoName: 'inviterUserID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMemberFullInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMemberFullInfo copyWith(void Function(GroupMemberFullInfo) updates) =>
      super.copyWith((message) => updates(message as GroupMemberFullInfo))
          as GroupMemberFullInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupMemberFullInfo create() => GroupMemberFullInfo._();
  @$core.override
  GroupMemberFullInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupMemberFullInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupMemberFullInfo>(create);
  static GroupMemberFullInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get groupID => $_getSZ(0);
  @$pb.TagNumber(1)
  set groupID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGroupID() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroupID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userID => $_getSZ(1);
  @$pb.TagNumber(2)
  set userID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get roleLevel => $_getIZ(2);
  @$pb.TagNumber(3)
  set roleLevel($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoleLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoleLevel() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get joinTime => $_getI64(3);
  @$pb.TagNumber(4)
  set joinTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJoinTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearJoinTime() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get nickname => $_getSZ(4);
  @$pb.TagNumber(5)
  set nickname($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNickname() => $_has(4);
  @$pb.TagNumber(5)
  void clearNickname() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get faceURL => $_getSZ(5);
  @$pb.TagNumber(6)
  set faceURL($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFaceURL() => $_has(5);
  @$pb.TagNumber(6)
  void clearFaceURL() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get appMangerLevel => $_getIZ(6);
  @$pb.TagNumber(7)
  set appMangerLevel($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAppMangerLevel() => $_has(6);
  @$pb.TagNumber(7)
  void clearAppMangerLevel() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get joinSource => $_getIZ(7);
  @$pb.TagNumber(8)
  set joinSource($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasJoinSource() => $_has(7);
  @$pb.TagNumber(8)
  void clearJoinSource() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get operatorUserID => $_getSZ(8);
  @$pb.TagNumber(9)
  set operatorUserID($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOperatorUserID() => $_has(8);
  @$pb.TagNumber(9)
  void clearOperatorUserID() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get ex => $_getSZ(9);
  @$pb.TagNumber(10)
  set ex($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEx() => $_has(9);
  @$pb.TagNumber(10)
  void clearEx() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get muteEndTime => $_getI64(10);
  @$pb.TagNumber(11)
  set muteEndTime($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMuteEndTime() => $_has(10);
  @$pb.TagNumber(11)
  void clearMuteEndTime() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get inviterUserID => $_getSZ(11);
  @$pb.TagNumber(12)
  set inviterUserID($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasInviterUserID() => $_has(11);
  @$pb.TagNumber(12)
  void clearInviterUserID() => $_clearField(12);
}

class PublicUserInfo extends $pb.GeneratedMessage {
  factory PublicUserInfo({
    $core.String? userID,
    $core.String? nickname,
    $core.String? faceURL,
    $core.String? ex,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    if (ex != null) result.ex = ex;
    return result;
  }

  PublicUserInfo._();

  factory PublicUserInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublicUserInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublicUserInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'nickname')
    ..aOS(3, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aOS(4, _omitFieldNames ? '' : 'ex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublicUserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublicUserInfo copyWith(void Function(PublicUserInfo) updates) =>
      super.copyWith((message) => updates(message as PublicUserInfo))
          as PublicUserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublicUserInfo create() => PublicUserInfo._();
  @$core.override
  PublicUserInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublicUserInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublicUserInfo>(create);
  static PublicUserInfo? _defaultInstance;

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
  $core.String get ex => $_getSZ(3);
  @$pb.TagNumber(4)
  set ex($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEx() => $_has(3);
  @$pb.TagNumber(4)
  void clearEx() => $_clearField(4);
}

class UserInfo extends $pb.GeneratedMessage {
  factory UserInfo({
    $core.String? userID,
    $core.String? nickname,
    $core.String? faceURL,
    $core.String? ex,
    $fixnum.Int64? createTime,
    $core.int? appMangerLevel,
    $core.int? globalRecvMsgOpt,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    if (ex != null) result.ex = ex;
    if (createTime != null) result.createTime = createTime;
    if (appMangerLevel != null) result.appMangerLevel = appMangerLevel;
    if (globalRecvMsgOpt != null) result.globalRecvMsgOpt = globalRecvMsgOpt;
    return result;
  }

  UserInfo._();

  factory UserInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'nickname')
    ..aOS(3, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aOS(4, _omitFieldNames ? '' : 'ex')
    ..aInt64(5, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aI(6, _omitFieldNames ? '' : 'appMangerLevel',
        protoName: 'appMangerLevel')
    ..aI(7, _omitFieldNames ? '' : 'globalRecvMsgOpt',
        protoName: 'globalRecvMsgOpt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfo copyWith(void Function(UserInfo) updates) =>
      super.copyWith((message) => updates(message as UserInfo)) as UserInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserInfo create() => UserInfo._();
  @$core.override
  UserInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserInfo>(create);
  static UserInfo? _defaultInstance;

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
  $core.String get ex => $_getSZ(3);
  @$pb.TagNumber(4)
  set ex($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEx() => $_has(3);
  @$pb.TagNumber(4)
  void clearEx() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get createTime => $_getI64(4);
  @$pb.TagNumber(5)
  set createTime($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreateTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreateTime() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get appMangerLevel => $_getIZ(5);
  @$pb.TagNumber(6)
  set appMangerLevel($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAppMangerLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearAppMangerLevel() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get globalRecvMsgOpt => $_getIZ(6);
  @$pb.TagNumber(7)
  set globalRecvMsgOpt($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasGlobalRecvMsgOpt() => $_has(6);
  @$pb.TagNumber(7)
  void clearGlobalRecvMsgOpt() => $_clearField(7);
}

class UserInfoWithEx extends $pb.GeneratedMessage {
  factory UserInfoWithEx({
    $core.String? userID,
    $0.StringValue? nickname,
    $0.StringValue? faceURL,
    $0.StringValue? ex,
    $0.Int32Value? globalRecvMsgOpt,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    if (ex != null) result.ex = ex;
    if (globalRecvMsgOpt != null) result.globalRecvMsgOpt = globalRecvMsgOpt;
    return result;
  }

  UserInfoWithEx._();

  factory UserInfoWithEx.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserInfoWithEx.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserInfoWithEx',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOM<$0.StringValue>(2, _omitFieldNames ? '' : 'nickname',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(3, _omitFieldNames ? '' : 'faceURL',
        protoName: 'faceURL', subBuilder: $0.StringValue.create)
    ..aOM<$0.StringValue>(4, _omitFieldNames ? '' : 'ex',
        subBuilder: $0.StringValue.create)
    ..aOM<$0.Int32Value>(7, _omitFieldNames ? '' : 'globalRecvMsgOpt',
        protoName: 'globalRecvMsgOpt', subBuilder: $0.Int32Value.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfoWithEx clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfoWithEx copyWith(void Function(UserInfoWithEx) updates) =>
      super.copyWith((message) => updates(message as UserInfoWithEx))
          as UserInfoWithEx;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserInfoWithEx create() => UserInfoWithEx._();
  @$core.override
  UserInfoWithEx createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserInfoWithEx getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserInfoWithEx>(create);
  static UserInfoWithEx? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.StringValue get nickname => $_getN(1);
  @$pb.TagNumber(2)
  set nickname($0.StringValue value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNickname() => $_has(1);
  @$pb.TagNumber(2)
  void clearNickname() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.StringValue ensureNickname() => $_ensure(1);

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
  $0.StringValue get ex => $_getN(3);
  @$pb.TagNumber(4)
  set ex($0.StringValue value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEx() => $_has(3);
  @$pb.TagNumber(4)
  void clearEx() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.StringValue ensureEx() => $_ensure(3);

  @$pb.TagNumber(7)
  $0.Int32Value get globalRecvMsgOpt => $_getN(4);
  @$pb.TagNumber(7)
  set globalRecvMsgOpt($0.Int32Value value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasGlobalRecvMsgOpt() => $_has(4);
  @$pb.TagNumber(7)
  void clearGlobalRecvMsgOpt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Int32Value ensureGlobalRecvMsgOpt() => $_ensure(4);
}

class FriendInfo extends $pb.GeneratedMessage {
  factory FriendInfo({
    $core.String? ownerUserID,
    $core.String? remark,
    $fixnum.Int64? createTime,
    UserInfo? friendUser,
    $core.int? addSource,
    $core.String? operatorUserID,
    $core.String? ex,
    $core.bool? isPinned,
  }) {
    final result = create();
    if (ownerUserID != null) result.ownerUserID = ownerUserID;
    if (remark != null) result.remark = remark;
    if (createTime != null) result.createTime = createTime;
    if (friendUser != null) result.friendUser = friendUser;
    if (addSource != null) result.addSource = addSource;
    if (operatorUserID != null) result.operatorUserID = operatorUserID;
    if (ex != null) result.ex = ex;
    if (isPinned != null) result.isPinned = isPinned;
    return result;
  }

  FriendInfo._();

  factory FriendInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ownerUserID', protoName: 'ownerUserID')
    ..aOS(2, _omitFieldNames ? '' : 'remark')
    ..aInt64(3, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aOM<UserInfo>(4, _omitFieldNames ? '' : 'friendUser',
        protoName: 'friendUser', subBuilder: UserInfo.create)
    ..aI(5, _omitFieldNames ? '' : 'addSource', protoName: 'addSource')
    ..aOS(6, _omitFieldNames ? '' : 'operatorUserID',
        protoName: 'operatorUserID')
    ..aOS(7, _omitFieldNames ? '' : 'ex')
    ..aOB(8, _omitFieldNames ? '' : 'isPinned', protoName: 'isPinned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendInfo copyWith(void Function(FriendInfo) updates) =>
      super.copyWith((message) => updates(message as FriendInfo)) as FriendInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendInfo create() => FriendInfo._();
  @$core.override
  FriendInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendInfo>(create);
  static FriendInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ownerUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set ownerUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOwnerUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwnerUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get remark => $_getSZ(1);
  @$pb.TagNumber(2)
  set remark($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRemark() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemark() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get createTime => $_getI64(2);
  @$pb.TagNumber(3)
  set createTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreateTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreateTime() => $_clearField(3);

  @$pb.TagNumber(4)
  UserInfo get friendUser => $_getN(3);
  @$pb.TagNumber(4)
  set friendUser(UserInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFriendUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearFriendUser() => $_clearField(4);
  @$pb.TagNumber(4)
  UserInfo ensureFriendUser() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get addSource => $_getIZ(4);
  @$pb.TagNumber(5)
  set addSource($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAddSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddSource() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get operatorUserID => $_getSZ(5);
  @$pb.TagNumber(6)
  set operatorUserID($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOperatorUserID() => $_has(5);
  @$pb.TagNumber(6)
  void clearOperatorUserID() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get ex => $_getSZ(6);
  @$pb.TagNumber(7)
  set ex($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEx() => $_has(6);
  @$pb.TagNumber(7)
  void clearEx() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isPinned => $_getBF(7);
  @$pb.TagNumber(8)
  set isPinned($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsPinned() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsPinned() => $_clearField(8);
}

class BlackInfo extends $pb.GeneratedMessage {
  factory BlackInfo({
    $core.String? ownerUserID,
    $fixnum.Int64? createTime,
    PublicUserInfo? blackUserInfo,
    $core.int? addSource,
    $core.String? operatorUserID,
    $core.String? ex,
  }) {
    final result = create();
    if (ownerUserID != null) result.ownerUserID = ownerUserID;
    if (createTime != null) result.createTime = createTime;
    if (blackUserInfo != null) result.blackUserInfo = blackUserInfo;
    if (addSource != null) result.addSource = addSource;
    if (operatorUserID != null) result.operatorUserID = operatorUserID;
    if (ex != null) result.ex = ex;
    return result;
  }

  BlackInfo._();

  factory BlackInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlackInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlackInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ownerUserID', protoName: 'ownerUserID')
    ..aInt64(2, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aOM<PublicUserInfo>(3, _omitFieldNames ? '' : 'blackUserInfo',
        protoName: 'blackUserInfo', subBuilder: PublicUserInfo.create)
    ..aI(4, _omitFieldNames ? '' : 'addSource', protoName: 'addSource')
    ..aOS(5, _omitFieldNames ? '' : 'operatorUserID',
        protoName: 'operatorUserID')
    ..aOS(6, _omitFieldNames ? '' : 'ex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlackInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlackInfo copyWith(void Function(BlackInfo) updates) =>
      super.copyWith((message) => updates(message as BlackInfo)) as BlackInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlackInfo create() => BlackInfo._();
  @$core.override
  BlackInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlackInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BlackInfo>(create);
  static BlackInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ownerUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set ownerUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOwnerUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwnerUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get createTime => $_getI64(1);
  @$pb.TagNumber(2)
  set createTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreateTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreateTime() => $_clearField(2);

  @$pb.TagNumber(3)
  PublicUserInfo get blackUserInfo => $_getN(2);
  @$pb.TagNumber(3)
  set blackUserInfo(PublicUserInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBlackUserInfo() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlackUserInfo() => $_clearField(3);
  @$pb.TagNumber(3)
  PublicUserInfo ensureBlackUserInfo() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get addSource => $_getIZ(3);
  @$pb.TagNumber(4)
  set addSource($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddSource() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get operatorUserID => $_getSZ(4);
  @$pb.TagNumber(5)
  set operatorUserID($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOperatorUserID() => $_has(4);
  @$pb.TagNumber(5)
  void clearOperatorUserID() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ex => $_getSZ(5);
  @$pb.TagNumber(6)
  set ex($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEx() => $_has(5);
  @$pb.TagNumber(6)
  void clearEx() => $_clearField(6);
}

class GroupRequest extends $pb.GeneratedMessage {
  factory GroupRequest({
    PublicUserInfo? userInfo,
    GroupInfo? groupInfo,
    $core.int? handleResult,
    $core.String? reqMsg,
    $core.String? handleMsg,
    $fixnum.Int64? reqTime,
    $core.String? handleUserID,
    $fixnum.Int64? handleTime,
    $core.String? ex,
    $core.int? joinSource,
    $core.String? inviterUserID,
  }) {
    final result = create();
    if (userInfo != null) result.userInfo = userInfo;
    if (groupInfo != null) result.groupInfo = groupInfo;
    if (handleResult != null) result.handleResult = handleResult;
    if (reqMsg != null) result.reqMsg = reqMsg;
    if (handleMsg != null) result.handleMsg = handleMsg;
    if (reqTime != null) result.reqTime = reqTime;
    if (handleUserID != null) result.handleUserID = handleUserID;
    if (handleTime != null) result.handleTime = handleTime;
    if (ex != null) result.ex = ex;
    if (joinSource != null) result.joinSource = joinSource;
    if (inviterUserID != null) result.inviterUserID = inviterUserID;
    return result;
  }

  GroupRequest._();

  factory GroupRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<PublicUserInfo>(1, _omitFieldNames ? '' : 'userInfo',
        protoName: 'userInfo', subBuilder: PublicUserInfo.create)
    ..aOM<GroupInfo>(2, _omitFieldNames ? '' : 'groupInfo',
        protoName: 'groupInfo', subBuilder: GroupInfo.create)
    ..aI(3, _omitFieldNames ? '' : 'handleResult', protoName: 'handleResult')
    ..aOS(4, _omitFieldNames ? '' : 'reqMsg', protoName: 'reqMsg')
    ..aOS(5, _omitFieldNames ? '' : 'handleMsg', protoName: 'handleMsg')
    ..aInt64(6, _omitFieldNames ? '' : 'reqTime', protoName: 'reqTime')
    ..aOS(7, _omitFieldNames ? '' : 'handleUserID', protoName: 'handleUserID')
    ..aInt64(8, _omitFieldNames ? '' : 'handleTime', protoName: 'handleTime')
    ..aOS(9, _omitFieldNames ? '' : 'ex')
    ..aI(10, _omitFieldNames ? '' : 'joinSource', protoName: 'joinSource')
    ..aOS(11, _omitFieldNames ? '' : 'inviterUserID',
        protoName: 'inviterUserID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupRequest copyWith(void Function(GroupRequest) updates) =>
      super.copyWith((message) => updates(message as GroupRequest))
          as GroupRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupRequest create() => GroupRequest._();
  @$core.override
  GroupRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupRequest>(create);
  static GroupRequest? _defaultInstance;

  @$pb.TagNumber(1)
  PublicUserInfo get userInfo => $_getN(0);
  @$pb.TagNumber(1)
  set userInfo(PublicUserInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUserInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  PublicUserInfo ensureUserInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupInfo get groupInfo => $_getN(1);
  @$pb.TagNumber(2)
  set groupInfo(GroupInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGroupInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroupInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupInfo ensureGroupInfo() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get handleResult => $_getIZ(2);
  @$pb.TagNumber(3)
  set handleResult($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHandleResult() => $_has(2);
  @$pb.TagNumber(3)
  void clearHandleResult() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reqMsg => $_getSZ(3);
  @$pb.TagNumber(4)
  set reqMsg($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReqMsg() => $_has(3);
  @$pb.TagNumber(4)
  void clearReqMsg() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get handleMsg => $_getSZ(4);
  @$pb.TagNumber(5)
  set handleMsg($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHandleMsg() => $_has(4);
  @$pb.TagNumber(5)
  void clearHandleMsg() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get reqTime => $_getI64(5);
  @$pb.TagNumber(6)
  set reqTime($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReqTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearReqTime() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get handleUserID => $_getSZ(6);
  @$pb.TagNumber(7)
  set handleUserID($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHandleUserID() => $_has(6);
  @$pb.TagNumber(7)
  void clearHandleUserID() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get handleTime => $_getI64(7);
  @$pb.TagNumber(8)
  set handleTime($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHandleTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearHandleTime() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get ex => $_getSZ(8);
  @$pb.TagNumber(9)
  set ex($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEx() => $_has(8);
  @$pb.TagNumber(9)
  void clearEx() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get joinSource => $_getIZ(9);
  @$pb.TagNumber(10)
  set joinSource($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasJoinSource() => $_has(9);
  @$pb.TagNumber(10)
  void clearJoinSource() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get inviterUserID => $_getSZ(10);
  @$pb.TagNumber(11)
  set inviterUserID($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInviterUserID() => $_has(10);
  @$pb.TagNumber(11)
  void clearInviterUserID() => $_clearField(11);
}

class FriendRequest extends $pb.GeneratedMessage {
  factory FriendRequest({
    $core.String? fromUserID,
    $core.String? fromNickname,
    $core.String? fromFaceURL,
    $core.String? toUserID,
    $core.String? toNickname,
    $core.String? toFaceURL,
    $core.int? handleResult,
    $core.String? reqMsg,
    $fixnum.Int64? createTime,
    $core.String? handlerUserID,
    $core.String? handleMsg,
    $fixnum.Int64? handleTime,
    $core.String? ex,
  }) {
    final result = create();
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (fromNickname != null) result.fromNickname = fromNickname;
    if (fromFaceURL != null) result.fromFaceURL = fromFaceURL;
    if (toUserID != null) result.toUserID = toUserID;
    if (toNickname != null) result.toNickname = toNickname;
    if (toFaceURL != null) result.toFaceURL = toFaceURL;
    if (handleResult != null) result.handleResult = handleResult;
    if (reqMsg != null) result.reqMsg = reqMsg;
    if (createTime != null) result.createTime = createTime;
    if (handlerUserID != null) result.handlerUserID = handlerUserID;
    if (handleMsg != null) result.handleMsg = handleMsg;
    if (handleTime != null) result.handleTime = handleTime;
    if (ex != null) result.ex = ex;
    return result;
  }

  FriendRequest._();

  factory FriendRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromUserID', protoName: 'fromUserID')
    ..aOS(2, _omitFieldNames ? '' : 'fromNickname', protoName: 'fromNickname')
    ..aOS(3, _omitFieldNames ? '' : 'fromFaceURL', protoName: 'fromFaceURL')
    ..aOS(4, _omitFieldNames ? '' : 'toUserID', protoName: 'toUserID')
    ..aOS(5, _omitFieldNames ? '' : 'toNickname', protoName: 'toNickname')
    ..aOS(6, _omitFieldNames ? '' : 'toFaceURL', protoName: 'toFaceURL')
    ..aI(7, _omitFieldNames ? '' : 'handleResult', protoName: 'handleResult')
    ..aOS(8, _omitFieldNames ? '' : 'reqMsg', protoName: 'reqMsg')
    ..aInt64(9, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aOS(10, _omitFieldNames ? '' : 'handlerUserID',
        protoName: 'handlerUserID')
    ..aOS(11, _omitFieldNames ? '' : 'handleMsg', protoName: 'handleMsg')
    ..aInt64(12, _omitFieldNames ? '' : 'handleTime', protoName: 'handleTime')
    ..aOS(13, _omitFieldNames ? '' : 'ex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendRequest copyWith(void Function(FriendRequest) updates) =>
      super.copyWith((message) => updates(message as FriendRequest))
          as FriendRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendRequest create() => FriendRequest._();
  @$core.override
  FriendRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendRequest>(create);
  static FriendRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromNickname => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromNickname($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromNickname() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromNickname() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fromFaceURL => $_getSZ(2);
  @$pb.TagNumber(3)
  set fromFaceURL($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromFaceURL() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromFaceURL() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get toUserID => $_getSZ(3);
  @$pb.TagNumber(4)
  set toUserID($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToUserID() => $_has(3);
  @$pb.TagNumber(4)
  void clearToUserID() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get toNickname => $_getSZ(4);
  @$pb.TagNumber(5)
  set toNickname($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasToNickname() => $_has(4);
  @$pb.TagNumber(5)
  void clearToNickname() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get toFaceURL => $_getSZ(5);
  @$pb.TagNumber(6)
  set toFaceURL($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasToFaceURL() => $_has(5);
  @$pb.TagNumber(6)
  void clearToFaceURL() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get handleResult => $_getIZ(6);
  @$pb.TagNumber(7)
  set handleResult($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHandleResult() => $_has(6);
  @$pb.TagNumber(7)
  void clearHandleResult() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get reqMsg => $_getSZ(7);
  @$pb.TagNumber(8)
  set reqMsg($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReqMsg() => $_has(7);
  @$pb.TagNumber(8)
  void clearReqMsg() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createTime => $_getI64(8);
  @$pb.TagNumber(9)
  set createTime($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreateTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreateTime() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get handlerUserID => $_getSZ(9);
  @$pb.TagNumber(10)
  set handlerUserID($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHandlerUserID() => $_has(9);
  @$pb.TagNumber(10)
  void clearHandlerUserID() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get handleMsg => $_getSZ(10);
  @$pb.TagNumber(11)
  set handleMsg($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHandleMsg() => $_has(10);
  @$pb.TagNumber(11)
  void clearHandleMsg() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get handleTime => $_getI64(11);
  @$pb.TagNumber(12)
  set handleTime($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasHandleTime() => $_has(11);
  @$pb.TagNumber(12)
  void clearHandleTime() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get ex => $_getSZ(12);
  @$pb.TagNumber(13)
  set ex($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasEx() => $_has(12);
  @$pb.TagNumber(13)
  void clearEx() => $_clearField(13);
}

class PullMessageBySeqsReq extends $pb.GeneratedMessage {
  factory PullMessageBySeqsReq({
    $core.String? userID,
    $core.Iterable<SeqRange>? seqRanges,
    PullOrder? order,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (seqRanges != null) result.seqRanges.addAll(seqRanges);
    if (order != null) result.order = order;
    return result;
  }

  PullMessageBySeqsReq._();

  factory PullMessageBySeqsReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PullMessageBySeqsReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PullMessageBySeqsReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..pPM<SeqRange>(2, _omitFieldNames ? '' : 'seqRanges',
        protoName: 'seqRanges', subBuilder: SeqRange.create)
    ..aE<PullOrder>(3, _omitFieldNames ? '' : 'order',
        enumValues: PullOrder.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullMessageBySeqsReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullMessageBySeqsReq copyWith(void Function(PullMessageBySeqsReq) updates) =>
      super.copyWith((message) => updates(message as PullMessageBySeqsReq))
          as PullMessageBySeqsReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullMessageBySeqsReq create() => PullMessageBySeqsReq._();
  @$core.override
  PullMessageBySeqsReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PullMessageBySeqsReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PullMessageBySeqsReq>(create);
  static PullMessageBySeqsReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<SeqRange> get seqRanges => $_getList(1);

  @$pb.TagNumber(3)
  PullOrder get order => $_getN(2);
  @$pb.TagNumber(3)
  set order(PullOrder value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOrder() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrder() => $_clearField(3);
}

class SeqRange extends $pb.GeneratedMessage {
  factory SeqRange({
    $core.String? conversationID,
    $fixnum.Int64? begin,
    $fixnum.Int64? end,
    $fixnum.Int64? num,
  }) {
    final result = create();
    if (conversationID != null) result.conversationID = conversationID;
    if (begin != null) result.begin = begin;
    if (end != null) result.end = end;
    if (num != null) result.num = num;
    return result;
  }

  SeqRange._();

  factory SeqRange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SeqRange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeqRange',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'conversationID',
        protoName: 'conversationID')
    ..aInt64(2, _omitFieldNames ? '' : 'begin')
    ..aInt64(3, _omitFieldNames ? '' : 'end')
    ..aInt64(4, _omitFieldNames ? '' : 'num')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeqRange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeqRange copyWith(void Function(SeqRange) updates) =>
      super.copyWith((message) => updates(message as SeqRange)) as SeqRange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeqRange create() => SeqRange._();
  @$core.override
  SeqRange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SeqRange getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeqRange>(create);
  static SeqRange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationID => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConversationID() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get begin => $_getI64(1);
  @$pb.TagNumber(2)
  set begin($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBegin() => $_has(1);
  @$pb.TagNumber(2)
  void clearBegin() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get end => $_getI64(2);
  @$pb.TagNumber(3)
  set end($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnd() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get num => $_getI64(3);
  @$pb.TagNumber(4)
  set num($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNum() => $_has(3);
  @$pb.TagNumber(4)
  void clearNum() => $_clearField(4);
}

class PullMsgs extends $pb.GeneratedMessage {
  factory PullMsgs({
    $core.Iterable<MsgData>? msgs,
    $core.bool? isEnd,
  }) {
    final result = create();
    if (msgs != null) result.msgs.addAll(msgs);
    if (isEnd != null) result.isEnd = isEnd;
    return result;
  }

  PullMsgs._();

  factory PullMsgs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PullMsgs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PullMsgs',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..pPM<MsgData>(1, _omitFieldNames ? '' : 'Msgs',
        protoName: 'Msgs', subBuilder: MsgData.create)
    ..aOB(2, _omitFieldNames ? '' : 'isEnd', protoName: 'isEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullMsgs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullMsgs copyWith(void Function(PullMsgs) updates) =>
      super.copyWith((message) => updates(message as PullMsgs)) as PullMsgs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullMsgs create() => PullMsgs._();
  @$core.override
  PullMsgs createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PullMsgs getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PullMsgs>(create);
  static PullMsgs? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MsgData> get msgs => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get isEnd => $_getBF(1);
  @$pb.TagNumber(2)
  set isEnd($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsEnd() => $_clearField(2);
}

class PullMessageBySeqsResp extends $pb.GeneratedMessage {
  factory PullMessageBySeqsResp({
    $core.Iterable<$core.MapEntry<$core.String, PullMsgs>>? msgs,
    $core.Iterable<$core.MapEntry<$core.String, PullMsgs>>? notificationMsgs,
  }) {
    final result = create();
    if (msgs != null) result.msgs.addEntries(msgs);
    if (notificationMsgs != null)
      result.notificationMsgs.addEntries(notificationMsgs);
    return result;
  }

  PullMessageBySeqsResp._();

  factory PullMessageBySeqsResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PullMessageBySeqsResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PullMessageBySeqsResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..m<$core.String, PullMsgs>(1, _omitFieldNames ? '' : 'msgs',
        entryClassName: 'PullMessageBySeqsResp.MsgsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: PullMsgs.create,
        valueDefaultOrMaker: PullMsgs.getDefault,
        packageName: const $pb.PackageName('openim.sdkws'))
    ..m<$core.String, PullMsgs>(2, _omitFieldNames ? '' : 'notificationMsgs',
        protoName: 'notificationMsgs',
        entryClassName: 'PullMessageBySeqsResp.NotificationMsgsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: PullMsgs.create,
        valueDefaultOrMaker: PullMsgs.getDefault,
        packageName: const $pb.PackageName('openim.sdkws'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullMessageBySeqsResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PullMessageBySeqsResp copyWith(
          void Function(PullMessageBySeqsResp) updates) =>
      super.copyWith((message) => updates(message as PullMessageBySeqsResp))
          as PullMessageBySeqsResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PullMessageBySeqsResp create() => PullMessageBySeqsResp._();
  @$core.override
  PullMessageBySeqsResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PullMessageBySeqsResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PullMessageBySeqsResp>(create);
  static PullMessageBySeqsResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, PullMsgs> get msgs => $_getMap(0);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, PullMsgs> get notificationMsgs => $_getMap(1);
}

class GetMaxSeqReq extends $pb.GeneratedMessage {
  factory GetMaxSeqReq({
    $core.String? userID,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    return result;
  }

  GetMaxSeqReq._();

  factory GetMaxSeqReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMaxSeqReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMaxSeqReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMaxSeqReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMaxSeqReq copyWith(void Function(GetMaxSeqReq) updates) =>
      super.copyWith((message) => updates(message as GetMaxSeqReq))
          as GetMaxSeqReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMaxSeqReq create() => GetMaxSeqReq._();
  @$core.override
  GetMaxSeqReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMaxSeqReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMaxSeqReq>(create);
  static GetMaxSeqReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);
}

class GetMaxSeqResp extends $pb.GeneratedMessage {
  factory GetMaxSeqResp({
    $core.Iterable<$core.MapEntry<$core.String, $fixnum.Int64>>? maxSeqs,
    $core.Iterable<$core.MapEntry<$core.String, $fixnum.Int64>>? minSeqs,
  }) {
    final result = create();
    if (maxSeqs != null) result.maxSeqs.addEntries(maxSeqs);
    if (minSeqs != null) result.minSeqs.addEntries(minSeqs);
    return result;
  }

  GetMaxSeqResp._();

  factory GetMaxSeqResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMaxSeqResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMaxSeqResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..m<$core.String, $fixnum.Int64>(1, _omitFieldNames ? '' : 'maxSeqs',
        protoName: 'maxSeqs',
        entryClassName: 'GetMaxSeqResp.MaxSeqsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O6,
        packageName: const $pb.PackageName('openim.sdkws'))
    ..m<$core.String, $fixnum.Int64>(2, _omitFieldNames ? '' : 'minSeqs',
        protoName: 'minSeqs',
        entryClassName: 'GetMaxSeqResp.MinSeqsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O6,
        packageName: const $pb.PackageName('openim.sdkws'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMaxSeqResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMaxSeqResp copyWith(void Function(GetMaxSeqResp) updates) =>
      super.copyWith((message) => updates(message as GetMaxSeqResp))
          as GetMaxSeqResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMaxSeqResp create() => GetMaxSeqResp._();
  @$core.override
  GetMaxSeqResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMaxSeqResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMaxSeqResp>(create);
  static GetMaxSeqResp? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $fixnum.Int64> get maxSeqs => $_getMap(0);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $fixnum.Int64> get minSeqs => $_getMap(1);
}

class UserSendMsgResp extends $pb.GeneratedMessage {
  factory UserSendMsgResp({
    $core.String? serverMsgID,
    $core.String? clientMsgID,
    $fixnum.Int64? sendTime,
  }) {
    final result = create();
    if (serverMsgID != null) result.serverMsgID = serverMsgID;
    if (clientMsgID != null) result.clientMsgID = clientMsgID;
    if (sendTime != null) result.sendTime = sendTime;
    return result;
  }

  UserSendMsgResp._();

  factory UserSendMsgResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserSendMsgResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserSendMsgResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serverMsgID', protoName: 'serverMsgID')
    ..aOS(2, _omitFieldNames ? '' : 'clientMsgID', protoName: 'clientMsgID')
    ..aInt64(3, _omitFieldNames ? '' : 'sendTime', protoName: 'sendTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSendMsgResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSendMsgResp copyWith(void Function(UserSendMsgResp) updates) =>
      super.copyWith((message) => updates(message as UserSendMsgResp))
          as UserSendMsgResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserSendMsgResp create() => UserSendMsgResp._();
  @$core.override
  UserSendMsgResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserSendMsgResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserSendMsgResp>(create);
  static UserSendMsgResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serverMsgID => $_getSZ(0);
  @$pb.TagNumber(1)
  set serverMsgID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServerMsgID() => $_has(0);
  @$pb.TagNumber(1)
  void clearServerMsgID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientMsgID => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientMsgID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientMsgID() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientMsgID() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get sendTime => $_getI64(2);
  @$pb.TagNumber(3)
  set sendTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSendTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearSendTime() => $_clearField(3);
}

class MsgData extends $pb.GeneratedMessage {
  factory MsgData({
    $core.String? sendID,
    $core.String? recvID,
    $core.String? groupID,
    $core.String? clientMsgID,
    $core.String? serverMsgID,
    $core.int? senderPlatformID,
    $core.String? senderNickname,
    $core.String? senderFaceURL,
    $core.int? sessionType,
    $core.int? msgFrom,
    $core.int? contentType,
    $core.List<$core.int>? content,
    $fixnum.Int64? seq,
    $fixnum.Int64? sendTime,
    $fixnum.Int64? createTime,
    $core.int? status,
    $core.bool? isRead,
    $core.Iterable<$core.MapEntry<$core.String, $core.bool>>? options,
    OfflinePushInfo? offlinePushInfo,
    $core.Iterable<$core.String>? atUserIDList,
    $core.String? attachedInfo,
    $core.String? ex,
  }) {
    final result = create();
    if (sendID != null) result.sendID = sendID;
    if (recvID != null) result.recvID = recvID;
    if (groupID != null) result.groupID = groupID;
    if (clientMsgID != null) result.clientMsgID = clientMsgID;
    if (serverMsgID != null) result.serverMsgID = serverMsgID;
    if (senderPlatformID != null) result.senderPlatformID = senderPlatformID;
    if (senderNickname != null) result.senderNickname = senderNickname;
    if (senderFaceURL != null) result.senderFaceURL = senderFaceURL;
    if (sessionType != null) result.sessionType = sessionType;
    if (msgFrom != null) result.msgFrom = msgFrom;
    if (contentType != null) result.contentType = contentType;
    if (content != null) result.content = content;
    if (seq != null) result.seq = seq;
    if (sendTime != null) result.sendTime = sendTime;
    if (createTime != null) result.createTime = createTime;
    if (status != null) result.status = status;
    if (isRead != null) result.isRead = isRead;
    if (options != null) result.options.addEntries(options);
    if (offlinePushInfo != null) result.offlinePushInfo = offlinePushInfo;
    if (atUserIDList != null) result.atUserIDList.addAll(atUserIDList);
    if (attachedInfo != null) result.attachedInfo = attachedInfo;
    if (ex != null) result.ex = ex;
    return result;
  }

  MsgData._();

  factory MsgData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MsgData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MsgData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sendID', protoName: 'sendID')
    ..aOS(2, _omitFieldNames ? '' : 'recvID', protoName: 'recvID')
    ..aOS(3, _omitFieldNames ? '' : 'groupID', protoName: 'groupID')
    ..aOS(4, _omitFieldNames ? '' : 'clientMsgID', protoName: 'clientMsgID')
    ..aOS(5, _omitFieldNames ? '' : 'serverMsgID', protoName: 'serverMsgID')
    ..aI(6, _omitFieldNames ? '' : 'senderPlatformID',
        protoName: 'senderPlatformID')
    ..aOS(7, _omitFieldNames ? '' : 'senderNickname',
        protoName: 'senderNickname')
    ..aOS(8, _omitFieldNames ? '' : 'senderFaceURL', protoName: 'senderFaceURL')
    ..aI(9, _omitFieldNames ? '' : 'sessionType', protoName: 'sessionType')
    ..aI(10, _omitFieldNames ? '' : 'msgFrom', protoName: 'msgFrom')
    ..aI(11, _omitFieldNames ? '' : 'contentType', protoName: 'contentType')
    ..a<$core.List<$core.int>>(
        12, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..aInt64(14, _omitFieldNames ? '' : 'seq')
    ..aInt64(15, _omitFieldNames ? '' : 'sendTime', protoName: 'sendTime')
    ..aInt64(16, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aI(17, _omitFieldNames ? '' : 'status')
    ..aOB(18, _omitFieldNames ? '' : 'isRead', protoName: 'isRead')
    ..m<$core.String, $core.bool>(19, _omitFieldNames ? '' : 'options',
        entryClassName: 'MsgData.OptionsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OB,
        packageName: const $pb.PackageName('openim.sdkws'))
    ..aOM<OfflinePushInfo>(20, _omitFieldNames ? '' : 'offlinePushInfo',
        protoName: 'offlinePushInfo', subBuilder: OfflinePushInfo.create)
    ..pPS(21, _omitFieldNames ? '' : 'atUserIDList', protoName: 'atUserIDList')
    ..aOS(22, _omitFieldNames ? '' : 'attachedInfo', protoName: 'attachedInfo')
    ..aOS(23, _omitFieldNames ? '' : 'ex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MsgData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MsgData copyWith(void Function(MsgData) updates) =>
      super.copyWith((message) => updates(message as MsgData)) as MsgData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MsgData create() => MsgData._();
  @$core.override
  MsgData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MsgData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MsgData>(create);
  static MsgData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sendID => $_getSZ(0);
  @$pb.TagNumber(1)
  set sendID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSendID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSendID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recvID => $_getSZ(1);
  @$pb.TagNumber(2)
  set recvID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecvID() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecvID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get groupID => $_getSZ(2);
  @$pb.TagNumber(3)
  set groupID($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGroupID() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroupID() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get clientMsgID => $_getSZ(3);
  @$pb.TagNumber(4)
  set clientMsgID($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClientMsgID() => $_has(3);
  @$pb.TagNumber(4)
  void clearClientMsgID() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get serverMsgID => $_getSZ(4);
  @$pb.TagNumber(5)
  set serverMsgID($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasServerMsgID() => $_has(4);
  @$pb.TagNumber(5)
  void clearServerMsgID() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get senderPlatformID => $_getIZ(5);
  @$pb.TagNumber(6)
  set senderPlatformID($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSenderPlatformID() => $_has(5);
  @$pb.TagNumber(6)
  void clearSenderPlatformID() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get senderNickname => $_getSZ(6);
  @$pb.TagNumber(7)
  set senderNickname($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSenderNickname() => $_has(6);
  @$pb.TagNumber(7)
  void clearSenderNickname() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get senderFaceURL => $_getSZ(7);
  @$pb.TagNumber(8)
  set senderFaceURL($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSenderFaceURL() => $_has(7);
  @$pb.TagNumber(8)
  void clearSenderFaceURL() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get sessionType => $_getIZ(8);
  @$pb.TagNumber(9)
  set sessionType($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSessionType() => $_has(8);
  @$pb.TagNumber(9)
  void clearSessionType() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get msgFrom => $_getIZ(9);
  @$pb.TagNumber(10)
  set msgFrom($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMsgFrom() => $_has(9);
  @$pb.TagNumber(10)
  void clearMsgFrom() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get contentType => $_getIZ(10);
  @$pb.TagNumber(11)
  set contentType($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasContentType() => $_has(10);
  @$pb.TagNumber(11)
  void clearContentType() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.List<$core.int> get content => $_getN(11);
  @$pb.TagNumber(12)
  set content($core.List<$core.int> value) => $_setBytes(11, value);
  @$pb.TagNumber(12)
  $core.bool hasContent() => $_has(11);
  @$pb.TagNumber(12)
  void clearContent() => $_clearField(12);

  @$pb.TagNumber(14)
  $fixnum.Int64 get seq => $_getI64(12);
  @$pb.TagNumber(14)
  set seq($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(14)
  $core.bool hasSeq() => $_has(12);
  @$pb.TagNumber(14)
  void clearSeq() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get sendTime => $_getI64(13);
  @$pb.TagNumber(15)
  set sendTime($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(15)
  $core.bool hasSendTime() => $_has(13);
  @$pb.TagNumber(15)
  void clearSendTime() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get createTime => $_getI64(14);
  @$pb.TagNumber(16)
  set createTime($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(16)
  $core.bool hasCreateTime() => $_has(14);
  @$pb.TagNumber(16)
  void clearCreateTime() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get status => $_getIZ(15);
  @$pb.TagNumber(17)
  set status($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(17)
  $core.bool hasStatus() => $_has(15);
  @$pb.TagNumber(17)
  void clearStatus() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.bool get isRead => $_getBF(16);
  @$pb.TagNumber(18)
  set isRead($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(18)
  $core.bool hasIsRead() => $_has(16);
  @$pb.TagNumber(18)
  void clearIsRead() => $_clearField(18);

  @$pb.TagNumber(19)
  $pb.PbMap<$core.String, $core.bool> get options => $_getMap(17);

  @$pb.TagNumber(20)
  OfflinePushInfo get offlinePushInfo => $_getN(18);
  @$pb.TagNumber(20)
  set offlinePushInfo(OfflinePushInfo value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasOfflinePushInfo() => $_has(18);
  @$pb.TagNumber(20)
  void clearOfflinePushInfo() => $_clearField(20);
  @$pb.TagNumber(20)
  OfflinePushInfo ensureOfflinePushInfo() => $_ensure(18);

  @$pb.TagNumber(21)
  $pb.PbList<$core.String> get atUserIDList => $_getList(19);

  @$pb.TagNumber(22)
  $core.String get attachedInfo => $_getSZ(20);
  @$pb.TagNumber(22)
  set attachedInfo($core.String value) => $_setString(20, value);
  @$pb.TagNumber(22)
  $core.bool hasAttachedInfo() => $_has(20);
  @$pb.TagNumber(22)
  void clearAttachedInfo() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get ex => $_getSZ(21);
  @$pb.TagNumber(23)
  set ex($core.String value) => $_setString(21, value);
  @$pb.TagNumber(23)
  $core.bool hasEx() => $_has(21);
  @$pb.TagNumber(23)
  void clearEx() => $_clearField(23);
}

class PushMessages extends $pb.GeneratedMessage {
  factory PushMessages({
    $core.Iterable<$core.MapEntry<$core.String, PullMsgs>>? msgs,
    $core.Iterable<$core.MapEntry<$core.String, PullMsgs>>? notificationMsgs,
  }) {
    final result = create();
    if (msgs != null) result.msgs.addEntries(msgs);
    if (notificationMsgs != null)
      result.notificationMsgs.addEntries(notificationMsgs);
    return result;
  }

  PushMessages._();

  factory PushMessages.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushMessages.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PushMessages',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..m<$core.String, PullMsgs>(1, _omitFieldNames ? '' : 'msgs',
        entryClassName: 'PushMessages.MsgsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: PullMsgs.create,
        valueDefaultOrMaker: PullMsgs.getDefault,
        packageName: const $pb.PackageName('openim.sdkws'))
    ..m<$core.String, PullMsgs>(2, _omitFieldNames ? '' : 'notificationMsgs',
        protoName: 'notificationMsgs',
        entryClassName: 'PushMessages.NotificationMsgsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: PullMsgs.create,
        valueDefaultOrMaker: PullMsgs.getDefault,
        packageName: const $pb.PackageName('openim.sdkws'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushMessages clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushMessages copyWith(void Function(PushMessages) updates) =>
      super.copyWith((message) => updates(message as PushMessages))
          as PushMessages;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushMessages create() => PushMessages._();
  @$core.override
  PushMessages createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PushMessages getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PushMessages>(create);
  static PushMessages? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, PullMsgs> get msgs => $_getMap(0);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, PullMsgs> get notificationMsgs => $_getMap(1);
}

class OfflinePushInfo extends $pb.GeneratedMessage {
  factory OfflinePushInfo({
    $core.String? title,
    $core.String? desc,
    $core.String? ex,
    $core.String? iOSPushSound,
    $core.bool? iOSBadgeCount,
    $core.String? signalInfo,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (desc != null) result.desc = desc;
    if (ex != null) result.ex = ex;
    if (iOSPushSound != null) result.iOSPushSound = iOSPushSound;
    if (iOSBadgeCount != null) result.iOSBadgeCount = iOSBadgeCount;
    if (signalInfo != null) result.signalInfo = signalInfo;
    return result;
  }

  OfflinePushInfo._();

  factory OfflinePushInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OfflinePushInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfflinePushInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'desc')
    ..aOS(3, _omitFieldNames ? '' : 'ex')
    ..aOS(4, _omitFieldNames ? '' : 'iOSPushSound', protoName: 'iOSPushSound')
    ..aOB(5, _omitFieldNames ? '' : 'iOSBadgeCount', protoName: 'iOSBadgeCount')
    ..aOS(6, _omitFieldNames ? '' : 'signalInfo', protoName: 'signalInfo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfflinePushInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfflinePushInfo copyWith(void Function(OfflinePushInfo) updates) =>
      super.copyWith((message) => updates(message as OfflinePushInfo))
          as OfflinePushInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OfflinePushInfo create() => OfflinePushInfo._();
  @$core.override
  OfflinePushInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OfflinePushInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfflinePushInfo>(create);
  static OfflinePushInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get desc => $_getSZ(1);
  @$pb.TagNumber(2)
  set desc($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDesc() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesc() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ex => $_getSZ(2);
  @$pb.TagNumber(3)
  set ex($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEx() => $_has(2);
  @$pb.TagNumber(3)
  void clearEx() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get iOSPushSound => $_getSZ(3);
  @$pb.TagNumber(4)
  set iOSPushSound($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIOSPushSound() => $_has(3);
  @$pb.TagNumber(4)
  void clearIOSPushSound() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get iOSBadgeCount => $_getBF(4);
  @$pb.TagNumber(5)
  set iOSBadgeCount($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIOSBadgeCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearIOSBadgeCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get signalInfo => $_getSZ(5);
  @$pb.TagNumber(6)
  set signalInfo($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSignalInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearSignalInfo() => $_clearField(6);
}

class TipsComm extends $pb.GeneratedMessage {
  factory TipsComm({
    $core.List<$core.int>? detail,
    $core.String? defaultTips,
    $core.String? jsonDetail,
  }) {
    final result = create();
    if (detail != null) result.detail = detail;
    if (defaultTips != null) result.defaultTips = defaultTips;
    if (jsonDetail != null) result.jsonDetail = jsonDetail;
    return result;
  }

  TipsComm._();

  factory TipsComm.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TipsComm.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TipsComm',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'detail', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'defaultTips', protoName: 'defaultTips')
    ..aOS(3, _omitFieldNames ? '' : 'jsonDetail', protoName: 'jsonDetail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TipsComm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TipsComm copyWith(void Function(TipsComm) updates) =>
      super.copyWith((message) => updates(message as TipsComm)) as TipsComm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TipsComm create() => TipsComm._();
  @$core.override
  TipsComm createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TipsComm getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TipsComm>(create);
  static TipsComm? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get detail => $_getN(0);
  @$pb.TagNumber(1)
  set detail($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDetail() => $_has(0);
  @$pb.TagNumber(1)
  void clearDetail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get defaultTips => $_getSZ(1);
  @$pb.TagNumber(2)
  set defaultTips($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDefaultTips() => $_has(1);
  @$pb.TagNumber(2)
  void clearDefaultTips() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get jsonDetail => $_getSZ(2);
  @$pb.TagNumber(3)
  set jsonDetail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasJsonDetail() => $_has(2);
  @$pb.TagNumber(3)
  void clearJsonDetail() => $_clearField(3);
}

/// 	OnGroupCreated()
class GroupCreatedTips extends $pb.GeneratedMessage {
  factory GroupCreatedTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $core.Iterable<GroupMemberFullInfo>? memberList,
    $fixnum.Int64? operationTime,
    GroupMemberFullInfo? groupOwnerUser,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (memberList != null) result.memberList.addAll(memberList);
    if (operationTime != null) result.operationTime = operationTime;
    if (groupOwnerUser != null) result.groupOwnerUser = groupOwnerUser;
    return result;
  }

  GroupCreatedTips._();

  factory GroupCreatedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupCreatedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupCreatedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..pPM<GroupMemberFullInfo>(3, _omitFieldNames ? '' : 'memberList',
        protoName: 'memberList', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(4, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..aOM<GroupMemberFullInfo>(5, _omitFieldNames ? '' : 'groupOwnerUser',
        protoName: 'groupOwnerUser', subBuilder: GroupMemberFullInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupCreatedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupCreatedTips copyWith(void Function(GroupCreatedTips) updates) =>
      super.copyWith((message) => updates(message as GroupCreatedTips))
          as GroupCreatedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupCreatedTips create() => GroupCreatedTips._();
  @$core.override
  GroupCreatedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupCreatedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupCreatedTips>(create);
  static GroupCreatedTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<GroupMemberFullInfo> get memberList => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get operationTime => $_getI64(3);
  @$pb.TagNumber(4)
  set operationTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOperationTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearOperationTime() => $_clearField(4);

  @$pb.TagNumber(5)
  GroupMemberFullInfo get groupOwnerUser => $_getN(4);
  @$pb.TagNumber(5)
  set groupOwnerUser(GroupMemberFullInfo value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasGroupOwnerUser() => $_has(4);
  @$pb.TagNumber(5)
  void clearGroupOwnerUser() => $_clearField(5);
  @$pb.TagNumber(5)
  GroupMemberFullInfo ensureGroupOwnerUser() => $_ensure(4);
}

/// 	OnGroupInfoSet()
class GroupInfoSetTips extends $pb.GeneratedMessage {
  factory GroupInfoSetTips({
    GroupMemberFullInfo? opUser,
    $fixnum.Int64? muteTime,
    GroupInfo? group,
  }) {
    final result = create();
    if (opUser != null) result.opUser = opUser;
    if (muteTime != null) result.muteTime = muteTime;
    if (group != null) result.group = group;
    return result;
  }

  GroupInfoSetTips._();

  factory GroupInfoSetTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupInfoSetTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupInfoSetTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupMemberFullInfo>(1, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(2, _omitFieldNames ? '' : 'muteTime', protoName: 'muteTime')
    ..aOM<GroupInfo>(3, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupInfoSetTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupInfoSetTips copyWith(void Function(GroupInfoSetTips) updates) =>
      super.copyWith((message) => updates(message as GroupInfoSetTips))
          as GroupInfoSetTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupInfoSetTips create() => GroupInfoSetTips._();
  @$core.override
  GroupInfoSetTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupInfoSetTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupInfoSetTips>(create);
  static GroupInfoSetTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupMemberFullInfo get opUser => $_getN(0);
  @$pb.TagNumber(1)
  set opUser(GroupMemberFullInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpUser() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupMemberFullInfo ensureOpUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get muteTime => $_getI64(1);
  @$pb.TagNumber(2)
  set muteTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMuteTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearMuteTime() => $_clearField(2);

  @$pb.TagNumber(3)
  GroupInfo get group => $_getN(2);
  @$pb.TagNumber(3)
  set group(GroupInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGroup() => $_has(2);
  @$pb.TagNumber(3)
  void clearGroup() => $_clearField(3);
  @$pb.TagNumber(3)
  GroupInfo ensureGroup() => $_ensure(2);
}

class GroupInfoSetNameTips extends $pb.GeneratedMessage {
  factory GroupInfoSetNameTips({
    GroupMemberFullInfo? opUser,
    GroupInfo? group,
  }) {
    final result = create();
    if (opUser != null) result.opUser = opUser;
    if (group != null) result.group = group;
    return result;
  }

  GroupInfoSetNameTips._();

  factory GroupInfoSetNameTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupInfoSetNameTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupInfoSetNameTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupMemberFullInfo>(1, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aOM<GroupInfo>(2, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupInfoSetNameTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupInfoSetNameTips copyWith(void Function(GroupInfoSetNameTips) updates) =>
      super.copyWith((message) => updates(message as GroupInfoSetNameTips))
          as GroupInfoSetNameTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupInfoSetNameTips create() => GroupInfoSetNameTips._();
  @$core.override
  GroupInfoSetNameTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupInfoSetNameTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupInfoSetNameTips>(create);
  static GroupInfoSetNameTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupMemberFullInfo get opUser => $_getN(0);
  @$pb.TagNumber(1)
  set opUser(GroupMemberFullInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpUser() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupMemberFullInfo ensureOpUser() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupInfo get group => $_getN(1);
  @$pb.TagNumber(2)
  set group(GroupInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGroup() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroup() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupInfo ensureGroup() => $_ensure(1);
}

class GroupInfoSetAnnouncementTips extends $pb.GeneratedMessage {
  factory GroupInfoSetAnnouncementTips({
    GroupMemberFullInfo? opUser,
    GroupInfo? group,
  }) {
    final result = create();
    if (opUser != null) result.opUser = opUser;
    if (group != null) result.group = group;
    return result;
  }

  GroupInfoSetAnnouncementTips._();

  factory GroupInfoSetAnnouncementTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupInfoSetAnnouncementTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupInfoSetAnnouncementTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupMemberFullInfo>(1, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aOM<GroupInfo>(2, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupInfoSetAnnouncementTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupInfoSetAnnouncementTips copyWith(
          void Function(GroupInfoSetAnnouncementTips) updates) =>
      super.copyWith(
              (message) => updates(message as GroupInfoSetAnnouncementTips))
          as GroupInfoSetAnnouncementTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupInfoSetAnnouncementTips create() =>
      GroupInfoSetAnnouncementTips._();
  @$core.override
  GroupInfoSetAnnouncementTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupInfoSetAnnouncementTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupInfoSetAnnouncementTips>(create);
  static GroupInfoSetAnnouncementTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupMemberFullInfo get opUser => $_getN(0);
  @$pb.TagNumber(1)
  set opUser(GroupMemberFullInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpUser() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupMemberFullInfo ensureOpUser() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupInfo get group => $_getN(1);
  @$pb.TagNumber(2)
  set group(GroupInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGroup() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroup() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupInfo ensureGroup() => $_ensure(1);
}

/// 	OnJoinGroupApplication()
class JoinGroupApplicationTips extends $pb.GeneratedMessage {
  factory JoinGroupApplicationTips({
    GroupInfo? group,
    PublicUserInfo? applicant,
    $core.String? reqMsg,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (applicant != null) result.applicant = applicant;
    if (reqMsg != null) result.reqMsg = reqMsg;
    return result;
  }

  JoinGroupApplicationTips._();

  factory JoinGroupApplicationTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinGroupApplicationTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinGroupApplicationTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<PublicUserInfo>(2, _omitFieldNames ? '' : 'applicant',
        subBuilder: PublicUserInfo.create)
    ..aOS(3, _omitFieldNames ? '' : 'reqMsg', protoName: 'reqMsg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinGroupApplicationTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinGroupApplicationTips copyWith(
          void Function(JoinGroupApplicationTips) updates) =>
      super.copyWith((message) => updates(message as JoinGroupApplicationTips))
          as JoinGroupApplicationTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinGroupApplicationTips create() => JoinGroupApplicationTips._();
  @$core.override
  JoinGroupApplicationTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JoinGroupApplicationTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinGroupApplicationTips>(create);
  static JoinGroupApplicationTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  PublicUserInfo get applicant => $_getN(1);
  @$pb.TagNumber(2)
  set applicant(PublicUserInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasApplicant() => $_has(1);
  @$pb.TagNumber(2)
  void clearApplicant() => $_clearField(2);
  @$pb.TagNumber(2)
  PublicUserInfo ensureApplicant() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reqMsg => $_getSZ(2);
  @$pb.TagNumber(3)
  set reqMsg($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReqMsg() => $_has(2);
  @$pb.TagNumber(3)
  void clearReqMsg() => $_clearField(3);
}

/// 	OnQuitGroup()
/// Actively leave the group
class MemberQuitTips extends $pb.GeneratedMessage {
  factory MemberQuitTips({
    GroupInfo? group,
    GroupMemberFullInfo? quitUser,
    $fixnum.Int64? operationTime,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (quitUser != null) result.quitUser = quitUser;
    if (operationTime != null) result.operationTime = operationTime;
    return result;
  }

  MemberQuitTips._();

  factory MemberQuitTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberQuitTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberQuitTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'quitUser',
        protoName: 'quitUser', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(3, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberQuitTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberQuitTips copyWith(void Function(MemberQuitTips) updates) =>
      super.copyWith((message) => updates(message as MemberQuitTips))
          as MemberQuitTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberQuitTips create() => MemberQuitTips._();
  @$core.override
  MemberQuitTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberQuitTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberQuitTips>(create);
  static MemberQuitTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get quitUser => $_getN(1);
  @$pb.TagNumber(2)
  set quitUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasQuitUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuitUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureQuitUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get operationTime => $_getI64(2);
  @$pb.TagNumber(3)
  set operationTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationTime() => $_clearField(3);
}

/// 	OnApplicationGroupAccepted()
class GroupApplicationAcceptedTips extends $pb.GeneratedMessage {
  factory GroupApplicationAcceptedTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $core.String? handleMsg,
    $core.int? receiverAs,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (handleMsg != null) result.handleMsg = handleMsg;
    if (receiverAs != null) result.receiverAs = receiverAs;
    return result;
  }

  GroupApplicationAcceptedTips._();

  factory GroupApplicationAcceptedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupApplicationAcceptedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupApplicationAcceptedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aOS(4, _omitFieldNames ? '' : 'handleMsg', protoName: 'handleMsg')
    ..aI(5, _omitFieldNames ? '' : 'receiverAs', protoName: 'receiverAs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupApplicationAcceptedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupApplicationAcceptedTips copyWith(
          void Function(GroupApplicationAcceptedTips) updates) =>
      super.copyWith(
              (message) => updates(message as GroupApplicationAcceptedTips))
          as GroupApplicationAcceptedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupApplicationAcceptedTips create() =>
      GroupApplicationAcceptedTips._();
  @$core.override
  GroupApplicationAcceptedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupApplicationAcceptedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupApplicationAcceptedTips>(create);
  static GroupApplicationAcceptedTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(4)
  $core.String get handleMsg => $_getSZ(2);
  @$pb.TagNumber(4)
  set handleMsg($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasHandleMsg() => $_has(2);
  @$pb.TagNumber(4)
  void clearHandleMsg() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get receiverAs => $_getIZ(3);
  @$pb.TagNumber(5)
  set receiverAs($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(5)
  $core.bool hasReceiverAs() => $_has(3);
  @$pb.TagNumber(5)
  void clearReceiverAs() => $_clearField(5);
}

/// 	OnApplicationGroupRejected()
class GroupApplicationRejectedTips extends $pb.GeneratedMessage {
  factory GroupApplicationRejectedTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $core.String? handleMsg,
    $core.int? receiverAs,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (handleMsg != null) result.handleMsg = handleMsg;
    if (receiverAs != null) result.receiverAs = receiverAs;
    return result;
  }

  GroupApplicationRejectedTips._();

  factory GroupApplicationRejectedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupApplicationRejectedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupApplicationRejectedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aOS(4, _omitFieldNames ? '' : 'handleMsg', protoName: 'handleMsg')
    ..aI(5, _omitFieldNames ? '' : 'receiverAs', protoName: 'receiverAs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupApplicationRejectedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupApplicationRejectedTips copyWith(
          void Function(GroupApplicationRejectedTips) updates) =>
      super.copyWith(
              (message) => updates(message as GroupApplicationRejectedTips))
          as GroupApplicationRejectedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupApplicationRejectedTips create() =>
      GroupApplicationRejectedTips._();
  @$core.override
  GroupApplicationRejectedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupApplicationRejectedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupApplicationRejectedTips>(create);
  static GroupApplicationRejectedTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(4)
  $core.String get handleMsg => $_getSZ(2);
  @$pb.TagNumber(4)
  set handleMsg($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasHandleMsg() => $_has(2);
  @$pb.TagNumber(4)
  void clearHandleMsg() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get receiverAs => $_getIZ(3);
  @$pb.TagNumber(5)
  set receiverAs($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(5)
  $core.bool hasReceiverAs() => $_has(3);
  @$pb.TagNumber(5)
  void clearReceiverAs() => $_clearField(5);
}

/// 	OnTransferGroupOwner()
class GroupOwnerTransferredTips extends $pb.GeneratedMessage {
  factory GroupOwnerTransferredTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    GroupMemberFullInfo? newGroupOwner,
    $core.String? oldGroupOwner,
    $fixnum.Int64? operationTime,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (newGroupOwner != null) result.newGroupOwner = newGroupOwner;
    if (oldGroupOwner != null) result.oldGroupOwner = oldGroupOwner;
    if (operationTime != null) result.operationTime = operationTime;
    return result;
  }

  GroupOwnerTransferredTips._();

  factory GroupOwnerTransferredTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupOwnerTransferredTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupOwnerTransferredTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aOM<GroupMemberFullInfo>(3, _omitFieldNames ? '' : 'newGroupOwner',
        protoName: 'newGroupOwner', subBuilder: GroupMemberFullInfo.create)
    ..aOS(4, _omitFieldNames ? '' : 'oldGroupOwner', protoName: 'oldGroupOwner')
    ..aInt64(5, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupOwnerTransferredTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupOwnerTransferredTips copyWith(
          void Function(GroupOwnerTransferredTips) updates) =>
      super.copyWith((message) => updates(message as GroupOwnerTransferredTips))
          as GroupOwnerTransferredTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupOwnerTransferredTips create() => GroupOwnerTransferredTips._();
  @$core.override
  GroupOwnerTransferredTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupOwnerTransferredTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupOwnerTransferredTips>(create);
  static GroupOwnerTransferredTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(3)
  GroupMemberFullInfo get newGroupOwner => $_getN(2);
  @$pb.TagNumber(3)
  set newGroupOwner(GroupMemberFullInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewGroupOwner() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewGroupOwner() => $_clearField(3);
  @$pb.TagNumber(3)
  GroupMemberFullInfo ensureNewGroupOwner() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get oldGroupOwner => $_getSZ(3);
  @$pb.TagNumber(4)
  set oldGroupOwner($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOldGroupOwner() => $_has(3);
  @$pb.TagNumber(4)
  void clearOldGroupOwner() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get operationTime => $_getI64(4);
  @$pb.TagNumber(5)
  set operationTime($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOperationTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearOperationTime() => $_clearField(5);
}

/// 	OnMemberKicked()
class MemberKickedTips extends $pb.GeneratedMessage {
  factory MemberKickedTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $core.Iterable<GroupMemberFullInfo>? kickedUserList,
    $fixnum.Int64? operationTime,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (kickedUserList != null) result.kickedUserList.addAll(kickedUserList);
    if (operationTime != null) result.operationTime = operationTime;
    return result;
  }

  MemberKickedTips._();

  factory MemberKickedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberKickedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberKickedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..pPM<GroupMemberFullInfo>(3, _omitFieldNames ? '' : 'kickedUserList',
        protoName: 'kickedUserList', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(4, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberKickedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberKickedTips copyWith(void Function(MemberKickedTips) updates) =>
      super.copyWith((message) => updates(message as MemberKickedTips))
          as MemberKickedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberKickedTips create() => MemberKickedTips._();
  @$core.override
  MemberKickedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberKickedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberKickedTips>(create);
  static MemberKickedTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<GroupMemberFullInfo> get kickedUserList => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get operationTime => $_getI64(3);
  @$pb.TagNumber(4)
  set operationTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOperationTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearOperationTime() => $_clearField(4);
}

/// 	OnMemberInvited()
class MemberInvitedTips extends $pb.GeneratedMessage {
  factory MemberInvitedTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $core.Iterable<GroupMemberFullInfo>? invitedUserList,
    $fixnum.Int64? operationTime,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (invitedUserList != null) result.invitedUserList.addAll(invitedUserList);
    if (operationTime != null) result.operationTime = operationTime;
    return result;
  }

  MemberInvitedTips._();

  factory MemberInvitedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberInvitedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberInvitedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..pPM<GroupMemberFullInfo>(3, _omitFieldNames ? '' : 'invitedUserList',
        protoName: 'invitedUserList', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(4, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberInvitedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberInvitedTips copyWith(void Function(MemberInvitedTips) updates) =>
      super.copyWith((message) => updates(message as MemberInvitedTips))
          as MemberInvitedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberInvitedTips create() => MemberInvitedTips._();
  @$core.override
  MemberInvitedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberInvitedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberInvitedTips>(create);
  static MemberInvitedTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<GroupMemberFullInfo> get invitedUserList => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get operationTime => $_getI64(3);
  @$pb.TagNumber(4)
  set operationTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOperationTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearOperationTime() => $_clearField(4);
}

/// Actively join the group
class MemberEnterTips extends $pb.GeneratedMessage {
  factory MemberEnterTips({
    GroupInfo? group,
    GroupMemberFullInfo? entrantUser,
    $fixnum.Int64? operationTime,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (entrantUser != null) result.entrantUser = entrantUser;
    if (operationTime != null) result.operationTime = operationTime;
    return result;
  }

  MemberEnterTips._();

  factory MemberEnterTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MemberEnterTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MemberEnterTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'entrantUser',
        protoName: 'entrantUser', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(3, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberEnterTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MemberEnterTips copyWith(void Function(MemberEnterTips) updates) =>
      super.copyWith((message) => updates(message as MemberEnterTips))
          as MemberEnterTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MemberEnterTips create() => MemberEnterTips._();
  @$core.override
  MemberEnterTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MemberEnterTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MemberEnterTips>(create);
  static MemberEnterTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get entrantUser => $_getN(1);
  @$pb.TagNumber(2)
  set entrantUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEntrantUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntrantUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureEntrantUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get operationTime => $_getI64(2);
  @$pb.TagNumber(3)
  set operationTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationTime() => $_clearField(3);
}

class GroupDismissedTips extends $pb.GeneratedMessage {
  factory GroupDismissedTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $fixnum.Int64? operationTime,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (operationTime != null) result.operationTime = operationTime;
    return result;
  }

  GroupDismissedTips._();

  factory GroupDismissedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupDismissedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupDismissedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(3, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupDismissedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupDismissedTips copyWith(void Function(GroupDismissedTips) updates) =>
      super.copyWith((message) => updates(message as GroupDismissedTips))
          as GroupDismissedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupDismissedTips create() => GroupDismissedTips._();
  @$core.override
  GroupDismissedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupDismissedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupDismissedTips>(create);
  static GroupDismissedTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get operationTime => $_getI64(2);
  @$pb.TagNumber(3)
  set operationTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationTime() => $_clearField(3);
}

class GroupMemberMutedTips extends $pb.GeneratedMessage {
  factory GroupMemberMutedTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $fixnum.Int64? operationTime,
    GroupMemberFullInfo? mutedUser,
    $core.int? mutedSeconds,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (operationTime != null) result.operationTime = operationTime;
    if (mutedUser != null) result.mutedUser = mutedUser;
    if (mutedSeconds != null) result.mutedSeconds = mutedSeconds;
    return result;
  }

  GroupMemberMutedTips._();

  factory GroupMemberMutedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupMemberMutedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupMemberMutedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(3, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..aOM<GroupMemberFullInfo>(4, _omitFieldNames ? '' : 'mutedUser',
        protoName: 'mutedUser', subBuilder: GroupMemberFullInfo.create)
    ..aI(5, _omitFieldNames ? '' : 'mutedSeconds',
        protoName: 'mutedSeconds', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMemberMutedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMemberMutedTips copyWith(void Function(GroupMemberMutedTips) updates) =>
      super.copyWith((message) => updates(message as GroupMemberMutedTips))
          as GroupMemberMutedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupMemberMutedTips create() => GroupMemberMutedTips._();
  @$core.override
  GroupMemberMutedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupMemberMutedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupMemberMutedTips>(create);
  static GroupMemberMutedTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get operationTime => $_getI64(2);
  @$pb.TagNumber(3)
  set operationTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationTime() => $_clearField(3);

  @$pb.TagNumber(4)
  GroupMemberFullInfo get mutedUser => $_getN(3);
  @$pb.TagNumber(4)
  set mutedUser(GroupMemberFullInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMutedUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearMutedUser() => $_clearField(4);
  @$pb.TagNumber(4)
  GroupMemberFullInfo ensureMutedUser() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get mutedSeconds => $_getIZ(4);
  @$pb.TagNumber(5)
  set mutedSeconds($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMutedSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearMutedSeconds() => $_clearField(5);
}

class GroupMemberCancelMutedTips extends $pb.GeneratedMessage {
  factory GroupMemberCancelMutedTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $fixnum.Int64? operationTime,
    GroupMemberFullInfo? mutedUser,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (operationTime != null) result.operationTime = operationTime;
    if (mutedUser != null) result.mutedUser = mutedUser;
    return result;
  }

  GroupMemberCancelMutedTips._();

  factory GroupMemberCancelMutedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupMemberCancelMutedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupMemberCancelMutedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(3, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..aOM<GroupMemberFullInfo>(4, _omitFieldNames ? '' : 'mutedUser',
        protoName: 'mutedUser', subBuilder: GroupMemberFullInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMemberCancelMutedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMemberCancelMutedTips copyWith(
          void Function(GroupMemberCancelMutedTips) updates) =>
      super.copyWith(
              (message) => updates(message as GroupMemberCancelMutedTips))
          as GroupMemberCancelMutedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupMemberCancelMutedTips create() => GroupMemberCancelMutedTips._();
  @$core.override
  GroupMemberCancelMutedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupMemberCancelMutedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupMemberCancelMutedTips>(create);
  static GroupMemberCancelMutedTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get operationTime => $_getI64(2);
  @$pb.TagNumber(3)
  set operationTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationTime() => $_clearField(3);

  @$pb.TagNumber(4)
  GroupMemberFullInfo get mutedUser => $_getN(3);
  @$pb.TagNumber(4)
  set mutedUser(GroupMemberFullInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMutedUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearMutedUser() => $_clearField(4);
  @$pb.TagNumber(4)
  GroupMemberFullInfo ensureMutedUser() => $_ensure(3);
}

class GroupMutedTips extends $pb.GeneratedMessage {
  factory GroupMutedTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $fixnum.Int64? operationTime,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (operationTime != null) result.operationTime = operationTime;
    return result;
  }

  GroupMutedTips._();

  factory GroupMutedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupMutedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupMutedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(3, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMutedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMutedTips copyWith(void Function(GroupMutedTips) updates) =>
      super.copyWith((message) => updates(message as GroupMutedTips))
          as GroupMutedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupMutedTips create() => GroupMutedTips._();
  @$core.override
  GroupMutedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupMutedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupMutedTips>(create);
  static GroupMutedTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get operationTime => $_getI64(2);
  @$pb.TagNumber(3)
  set operationTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationTime() => $_clearField(3);
}

class GroupCancelMutedTips extends $pb.GeneratedMessage {
  factory GroupCancelMutedTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $fixnum.Int64? operationTime,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (operationTime != null) result.operationTime = operationTime;
    return result;
  }

  GroupCancelMutedTips._();

  factory GroupCancelMutedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupCancelMutedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupCancelMutedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(3, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupCancelMutedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupCancelMutedTips copyWith(void Function(GroupCancelMutedTips) updates) =>
      super.copyWith((message) => updates(message as GroupCancelMutedTips))
          as GroupCancelMutedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupCancelMutedTips create() => GroupCancelMutedTips._();
  @$core.override
  GroupCancelMutedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupCancelMutedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupCancelMutedTips>(create);
  static GroupCancelMutedTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get operationTime => $_getI64(2);
  @$pb.TagNumber(3)
  set operationTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationTime() => $_clearField(3);
}

class GroupMemberInfoSetTips extends $pb.GeneratedMessage {
  factory GroupMemberInfoSetTips({
    GroupInfo? group,
    GroupMemberFullInfo? opUser,
    $fixnum.Int64? operationTime,
    GroupMemberFullInfo? changedUser,
  }) {
    final result = create();
    if (group != null) result.group = group;
    if (opUser != null) result.opUser = opUser;
    if (operationTime != null) result.operationTime = operationTime;
    if (changedUser != null) result.changedUser = changedUser;
    return result;
  }

  GroupMemberInfoSetTips._();

  factory GroupMemberInfoSetTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GroupMemberInfoSetTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GroupMemberInfoSetTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<GroupInfo>(1, _omitFieldNames ? '' : 'group',
        subBuilder: GroupInfo.create)
    ..aOM<GroupMemberFullInfo>(2, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: GroupMemberFullInfo.create)
    ..aInt64(3, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..aOM<GroupMemberFullInfo>(4, _omitFieldNames ? '' : 'changedUser',
        protoName: 'changedUser', subBuilder: GroupMemberFullInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMemberInfoSetTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GroupMemberInfoSetTips copyWith(
          void Function(GroupMemberInfoSetTips) updates) =>
      super.copyWith((message) => updates(message as GroupMemberInfoSetTips))
          as GroupMemberInfoSetTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GroupMemberInfoSetTips create() => GroupMemberInfoSetTips._();
  @$core.override
  GroupMemberInfoSetTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GroupMemberInfoSetTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GroupMemberInfoSetTips>(create);
  static GroupMemberInfoSetTips? _defaultInstance;

  @$pb.TagNumber(1)
  GroupInfo get group => $_getN(0);
  @$pb.TagNumber(1)
  set group(GroupInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  GroupInfo ensureGroup() => $_ensure(0);

  @$pb.TagNumber(2)
  GroupMemberFullInfo get opUser => $_getN(1);
  @$pb.TagNumber(2)
  set opUser(GroupMemberFullInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpUser() => $_clearField(2);
  @$pb.TagNumber(2)
  GroupMemberFullInfo ensureOpUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get operationTime => $_getI64(2);
  @$pb.TagNumber(3)
  set operationTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationTime() => $_clearField(3);

  @$pb.TagNumber(4)
  GroupMemberFullInfo get changedUser => $_getN(3);
  @$pb.TagNumber(4)
  set changedUser(GroupMemberFullInfo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasChangedUser() => $_has(3);
  @$pb.TagNumber(4)
  void clearChangedUser() => $_clearField(4);
  @$pb.TagNumber(4)
  GroupMemberFullInfo ensureChangedUser() => $_ensure(3);
}

class FriendApplication extends $pb.GeneratedMessage {
  factory FriendApplication({
    $fixnum.Int64? addTime,
    $core.String? addSource,
    $core.String? addWording,
  }) {
    final result = create();
    if (addTime != null) result.addTime = addTime;
    if (addSource != null) result.addSource = addSource;
    if (addWording != null) result.addWording = addWording;
    return result;
  }

  FriendApplication._();

  factory FriendApplication.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendApplication.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendApplication',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'addTime', protoName: 'addTime')
    ..aOS(2, _omitFieldNames ? '' : 'addSource', protoName: 'addSource')
    ..aOS(3, _omitFieldNames ? '' : 'addWording', protoName: 'addWording')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendApplication clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendApplication copyWith(void Function(FriendApplication) updates) =>
      super.copyWith((message) => updates(message as FriendApplication))
          as FriendApplication;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendApplication create() => FriendApplication._();
  @$core.override
  FriendApplication createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendApplication getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendApplication>(create);
  static FriendApplication? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get addTime => $_getI64(0);
  @$pb.TagNumber(1)
  set addTime($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAddTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddTime() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get addSource => $_getSZ(1);
  @$pb.TagNumber(2)
  set addSource($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAddSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddSource() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get addWording => $_getSZ(2);
  @$pb.TagNumber(3)
  set addWording($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAddWording() => $_has(2);
  @$pb.TagNumber(3)
  void clearAddWording() => $_clearField(3);
}

class FromToUserID extends $pb.GeneratedMessage {
  factory FromToUserID({
    $core.String? fromUserID,
    $core.String? toUserID,
  }) {
    final result = create();
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (toUserID != null) result.toUserID = toUserID;
    return result;
  }

  FromToUserID._();

  factory FromToUserID.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FromToUserID.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FromToUserID',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromUserID', protoName: 'fromUserID')
    ..aOS(2, _omitFieldNames ? '' : 'toUserID', protoName: 'toUserID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FromToUserID clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FromToUserID copyWith(void Function(FromToUserID) updates) =>
      super.copyWith((message) => updates(message as FromToUserID))
          as FromToUserID;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FromToUserID create() => FromToUserID._();
  @$core.override
  FromToUserID createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FromToUserID getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FromToUserID>(create);
  static FromToUserID? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toUserID => $_getSZ(1);
  @$pb.TagNumber(2)
  set toUserID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUserID() => $_clearField(2);
}

/// FromUserID apply to add ToUserID
class FriendApplicationTips extends $pb.GeneratedMessage {
  factory FriendApplicationTips({
    FromToUserID? fromToUserID,
  }) {
    final result = create();
    if (fromToUserID != null) result.fromToUserID = fromToUserID;
    return result;
  }

  FriendApplicationTips._();

  factory FriendApplicationTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendApplicationTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendApplicationTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<FromToUserID>(1, _omitFieldNames ? '' : 'fromToUserID',
        protoName: 'fromToUserID', subBuilder: FromToUserID.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendApplicationTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendApplicationTips copyWith(
          void Function(FriendApplicationTips) updates) =>
      super.copyWith((message) => updates(message as FriendApplicationTips))
          as FriendApplicationTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendApplicationTips create() => FriendApplicationTips._();
  @$core.override
  FriendApplicationTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendApplicationTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendApplicationTips>(create);
  static FriendApplicationTips? _defaultInstance;

  @$pb.TagNumber(1)
  FromToUserID get fromToUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromToUserID(FromToUserID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFromToUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromToUserID() => $_clearField(1);
  @$pb.TagNumber(1)
  FromToUserID ensureFromToUserID() => $_ensure(0);
}

/// FromUserID accept or reject ToUserID
class FriendApplicationApprovedTips extends $pb.GeneratedMessage {
  factory FriendApplicationApprovedTips({
    FromToUserID? fromToUserID,
    $core.String? handleMsg,
  }) {
    final result = create();
    if (fromToUserID != null) result.fromToUserID = fromToUserID;
    if (handleMsg != null) result.handleMsg = handleMsg;
    return result;
  }

  FriendApplicationApprovedTips._();

  factory FriendApplicationApprovedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendApplicationApprovedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendApplicationApprovedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<FromToUserID>(1, _omitFieldNames ? '' : 'fromToUserID',
        protoName: 'fromToUserID', subBuilder: FromToUserID.create)
    ..aOS(2, _omitFieldNames ? '' : 'handleMsg', protoName: 'handleMsg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendApplicationApprovedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendApplicationApprovedTips copyWith(
          void Function(FriendApplicationApprovedTips) updates) =>
      super.copyWith(
              (message) => updates(message as FriendApplicationApprovedTips))
          as FriendApplicationApprovedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendApplicationApprovedTips create() =>
      FriendApplicationApprovedTips._();
  @$core.override
  FriendApplicationApprovedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendApplicationApprovedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendApplicationApprovedTips>(create);
  static FriendApplicationApprovedTips? _defaultInstance;

  @$pb.TagNumber(1)
  FromToUserID get fromToUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromToUserID(FromToUserID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFromToUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromToUserID() => $_clearField(1);
  @$pb.TagNumber(1)
  FromToUserID ensureFromToUserID() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get handleMsg => $_getSZ(1);
  @$pb.TagNumber(2)
  set handleMsg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHandleMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearHandleMsg() => $_clearField(2);
}

/// FromUserID accept or reject ToUserID
class FriendApplicationRejectedTips extends $pb.GeneratedMessage {
  factory FriendApplicationRejectedTips({
    FromToUserID? fromToUserID,
    $core.String? handleMsg,
  }) {
    final result = create();
    if (fromToUserID != null) result.fromToUserID = fromToUserID;
    if (handleMsg != null) result.handleMsg = handleMsg;
    return result;
  }

  FriendApplicationRejectedTips._();

  factory FriendApplicationRejectedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendApplicationRejectedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendApplicationRejectedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<FromToUserID>(1, _omitFieldNames ? '' : 'fromToUserID',
        protoName: 'fromToUserID', subBuilder: FromToUserID.create)
    ..aOS(2, _omitFieldNames ? '' : 'handleMsg', protoName: 'handleMsg')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendApplicationRejectedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendApplicationRejectedTips copyWith(
          void Function(FriendApplicationRejectedTips) updates) =>
      super.copyWith(
              (message) => updates(message as FriendApplicationRejectedTips))
          as FriendApplicationRejectedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendApplicationRejectedTips create() =>
      FriendApplicationRejectedTips._();
  @$core.override
  FriendApplicationRejectedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendApplicationRejectedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendApplicationRejectedTips>(create);
  static FriendApplicationRejectedTips? _defaultInstance;

  @$pb.TagNumber(1)
  FromToUserID get fromToUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromToUserID(FromToUserID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFromToUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromToUserID() => $_clearField(1);
  @$pb.TagNumber(1)
  FromToUserID ensureFromToUserID() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get handleMsg => $_getSZ(1);
  @$pb.TagNumber(2)
  set handleMsg($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHandleMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearHandleMsg() => $_clearField(2);
}

/// FromUserID  Added a friend ToUserID
class FriendAddedTips extends $pb.GeneratedMessage {
  factory FriendAddedTips({
    FriendInfo? friend,
    $fixnum.Int64? operationTime,
    PublicUserInfo? opUser,
  }) {
    final result = create();
    if (friend != null) result.friend = friend;
    if (operationTime != null) result.operationTime = operationTime;
    if (opUser != null) result.opUser = opUser;
    return result;
  }

  FriendAddedTips._();

  factory FriendAddedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendAddedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendAddedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<FriendInfo>(1, _omitFieldNames ? '' : 'friend',
        subBuilder: FriendInfo.create)
    ..aInt64(2, _omitFieldNames ? '' : 'operationTime',
        protoName: 'operationTime')
    ..aOM<PublicUserInfo>(3, _omitFieldNames ? '' : 'opUser',
        protoName: 'opUser', subBuilder: PublicUserInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendAddedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendAddedTips copyWith(void Function(FriendAddedTips) updates) =>
      super.copyWith((message) => updates(message as FriendAddedTips))
          as FriendAddedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendAddedTips create() => FriendAddedTips._();
  @$core.override
  FriendAddedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendAddedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendAddedTips>(create);
  static FriendAddedTips? _defaultInstance;

  @$pb.TagNumber(1)
  FriendInfo get friend => $_getN(0);
  @$pb.TagNumber(1)
  set friend(FriendInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFriend() => $_has(0);
  @$pb.TagNumber(1)
  void clearFriend() => $_clearField(1);
  @$pb.TagNumber(1)
  FriendInfo ensureFriend() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get operationTime => $_getI64(1);
  @$pb.TagNumber(2)
  set operationTime($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOperationTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearOperationTime() => $_clearField(2);

  @$pb.TagNumber(3)
  PublicUserInfo get opUser => $_getN(2);
  @$pb.TagNumber(3)
  set opUser(PublicUserInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOpUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpUser() => $_clearField(3);
  @$pb.TagNumber(3)
  PublicUserInfo ensureOpUser() => $_ensure(2);
}

/// FromUserID  deleted a friend ToUserID
class FriendDeletedTips extends $pb.GeneratedMessage {
  factory FriendDeletedTips({
    FromToUserID? fromToUserID,
  }) {
    final result = create();
    if (fromToUserID != null) result.fromToUserID = fromToUserID;
    return result;
  }

  FriendDeletedTips._();

  factory FriendDeletedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendDeletedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendDeletedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<FromToUserID>(1, _omitFieldNames ? '' : 'fromToUserID',
        protoName: 'fromToUserID', subBuilder: FromToUserID.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendDeletedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendDeletedTips copyWith(void Function(FriendDeletedTips) updates) =>
      super.copyWith((message) => updates(message as FriendDeletedTips))
          as FriendDeletedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendDeletedTips create() => FriendDeletedTips._();
  @$core.override
  FriendDeletedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendDeletedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendDeletedTips>(create);
  static FriendDeletedTips? _defaultInstance;

  @$pb.TagNumber(1)
  FromToUserID get fromToUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromToUserID(FromToUserID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFromToUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromToUserID() => $_clearField(1);
  @$pb.TagNumber(1)
  FromToUserID ensureFromToUserID() => $_ensure(0);
}

class BlackAddedTips extends $pb.GeneratedMessage {
  factory BlackAddedTips({
    FromToUserID? fromToUserID,
  }) {
    final result = create();
    if (fromToUserID != null) result.fromToUserID = fromToUserID;
    return result;
  }

  BlackAddedTips._();

  factory BlackAddedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlackAddedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlackAddedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<FromToUserID>(1, _omitFieldNames ? '' : 'fromToUserID',
        protoName: 'fromToUserID', subBuilder: FromToUserID.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlackAddedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlackAddedTips copyWith(void Function(BlackAddedTips) updates) =>
      super.copyWith((message) => updates(message as BlackAddedTips))
          as BlackAddedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlackAddedTips create() => BlackAddedTips._();
  @$core.override
  BlackAddedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlackAddedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlackAddedTips>(create);
  static BlackAddedTips? _defaultInstance;

  @$pb.TagNumber(1)
  FromToUserID get fromToUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromToUserID(FromToUserID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFromToUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromToUserID() => $_clearField(1);
  @$pb.TagNumber(1)
  FromToUserID ensureFromToUserID() => $_ensure(0);
}

class BlackDeletedTips extends $pb.GeneratedMessage {
  factory BlackDeletedTips({
    FromToUserID? fromToUserID,
  }) {
    final result = create();
    if (fromToUserID != null) result.fromToUserID = fromToUserID;
    return result;
  }

  BlackDeletedTips._();

  factory BlackDeletedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlackDeletedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlackDeletedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<FromToUserID>(1, _omitFieldNames ? '' : 'fromToUserID',
        protoName: 'fromToUserID', subBuilder: FromToUserID.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlackDeletedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlackDeletedTips copyWith(void Function(BlackDeletedTips) updates) =>
      super.copyWith((message) => updates(message as BlackDeletedTips))
          as BlackDeletedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlackDeletedTips create() => BlackDeletedTips._();
  @$core.override
  BlackDeletedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlackDeletedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlackDeletedTips>(create);
  static BlackDeletedTips? _defaultInstance;

  @$pb.TagNumber(1)
  FromToUserID get fromToUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromToUserID(FromToUserID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFromToUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromToUserID() => $_clearField(1);
  @$pb.TagNumber(1)
  FromToUserID ensureFromToUserID() => $_ensure(0);
}

class FriendInfoChangedTips extends $pb.GeneratedMessage {
  factory FriendInfoChangedTips({
    FromToUserID? fromToUserID,
  }) {
    final result = create();
    if (fromToUserID != null) result.fromToUserID = fromToUserID;
    return result;
  }

  FriendInfoChangedTips._();

  factory FriendInfoChangedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendInfoChangedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendInfoChangedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<FromToUserID>(1, _omitFieldNames ? '' : 'fromToUserID',
        protoName: 'fromToUserID', subBuilder: FromToUserID.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendInfoChangedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendInfoChangedTips copyWith(
          void Function(FriendInfoChangedTips) updates) =>
      super.copyWith((message) => updates(message as FriendInfoChangedTips))
          as FriendInfoChangedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendInfoChangedTips create() => FriendInfoChangedTips._();
  @$core.override
  FriendInfoChangedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendInfoChangedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendInfoChangedTips>(create);
  static FriendInfoChangedTips? _defaultInstance;

  @$pb.TagNumber(1)
  FromToUserID get fromToUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromToUserID(FromToUserID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFromToUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromToUserID() => $_clearField(1);
  @$pb.TagNumber(1)
  FromToUserID ensureFromToUserID() => $_ensure(0);
}

/// ////////////////////user/////////////////////
class UserInfoUpdatedTips extends $pb.GeneratedMessage {
  factory UserInfoUpdatedTips({
    $core.String? userID,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    return result;
  }

  UserInfoUpdatedTips._();

  factory UserInfoUpdatedTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserInfoUpdatedTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserInfoUpdatedTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfoUpdatedTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserInfoUpdatedTips copyWith(void Function(UserInfoUpdatedTips) updates) =>
      super.copyWith((message) => updates(message as UserInfoUpdatedTips))
          as UserInfoUpdatedTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserInfoUpdatedTips create() => UserInfoUpdatedTips._();
  @$core.override
  UserInfoUpdatedTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserInfoUpdatedTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserInfoUpdatedTips>(create);
  static UserInfoUpdatedTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);
}

class UserStatusChangeTips extends $pb.GeneratedMessage {
  factory UserStatusChangeTips({
    $core.String? fromUserID,
    $core.String? toUserID,
    $core.int? status,
    $core.int? platformID,
  }) {
    final result = create();
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (toUserID != null) result.toUserID = toUserID;
    if (status != null) result.status = status;
    if (platformID != null) result.platformID = platformID;
    return result;
  }

  UserStatusChangeTips._();

  factory UserStatusChangeTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserStatusChangeTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserStatusChangeTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromUserID', protoName: 'fromUserID')
    ..aOS(2, _omitFieldNames ? '' : 'toUserID', protoName: 'toUserID')
    ..aI(3, _omitFieldNames ? '' : 'status')
    ..aI(4, _omitFieldNames ? '' : 'platformID', protoName: 'platformID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserStatusChangeTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserStatusChangeTips copyWith(void Function(UserStatusChangeTips) updates) =>
      super.copyWith((message) => updates(message as UserStatusChangeTips))
          as UserStatusChangeTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserStatusChangeTips create() => UserStatusChangeTips._();
  @$core.override
  UserStatusChangeTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserStatusChangeTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserStatusChangeTips>(create);
  static UserStatusChangeTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toUserID => $_getSZ(1);
  @$pb.TagNumber(2)
  set toUserID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get status => $_getIZ(2);
  @$pb.TagNumber(3)
  set status($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get platformID => $_getIZ(3);
  @$pb.TagNumber(4)
  set platformID($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlatformID() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatformID() => $_clearField(4);
}

class UserCommandAddTips extends $pb.GeneratedMessage {
  factory UserCommandAddTips({
    $core.String? fromUserID,
    $core.String? toUserID,
  }) {
    final result = create();
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (toUserID != null) result.toUserID = toUserID;
    return result;
  }

  UserCommandAddTips._();

  factory UserCommandAddTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserCommandAddTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserCommandAddTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromUserID', protoName: 'fromUserID')
    ..aOS(2, _omitFieldNames ? '' : 'toUserID', protoName: 'toUserID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCommandAddTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCommandAddTips copyWith(void Function(UserCommandAddTips) updates) =>
      super.copyWith((message) => updates(message as UserCommandAddTips))
          as UserCommandAddTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserCommandAddTips create() => UserCommandAddTips._();
  @$core.override
  UserCommandAddTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserCommandAddTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserCommandAddTips>(create);
  static UserCommandAddTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toUserID => $_getSZ(1);
  @$pb.TagNumber(2)
  set toUserID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUserID() => $_clearField(2);
}

class UserCommandUpdateTips extends $pb.GeneratedMessage {
  factory UserCommandUpdateTips({
    $core.String? fromUserID,
    $core.String? toUserID,
  }) {
    final result = create();
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (toUserID != null) result.toUserID = toUserID;
    return result;
  }

  UserCommandUpdateTips._();

  factory UserCommandUpdateTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserCommandUpdateTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserCommandUpdateTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromUserID', protoName: 'fromUserID')
    ..aOS(2, _omitFieldNames ? '' : 'toUserID', protoName: 'toUserID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCommandUpdateTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCommandUpdateTips copyWith(
          void Function(UserCommandUpdateTips) updates) =>
      super.copyWith((message) => updates(message as UserCommandUpdateTips))
          as UserCommandUpdateTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserCommandUpdateTips create() => UserCommandUpdateTips._();
  @$core.override
  UserCommandUpdateTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserCommandUpdateTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserCommandUpdateTips>(create);
  static UserCommandUpdateTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toUserID => $_getSZ(1);
  @$pb.TagNumber(2)
  set toUserID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUserID() => $_clearField(2);
}

class UserCommandDeleteTips extends $pb.GeneratedMessage {
  factory UserCommandDeleteTips({
    $core.String? fromUserID,
    $core.String? toUserID,
  }) {
    final result = create();
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (toUserID != null) result.toUserID = toUserID;
    return result;
  }

  UserCommandDeleteTips._();

  factory UserCommandDeleteTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserCommandDeleteTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserCommandDeleteTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fromUserID', protoName: 'fromUserID')
    ..aOS(2, _omitFieldNames ? '' : 'toUserID', protoName: 'toUserID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCommandDeleteTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserCommandDeleteTips copyWith(
          void Function(UserCommandDeleteTips) updates) =>
      super.copyWith((message) => updates(message as UserCommandDeleteTips))
          as UserCommandDeleteTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserCommandDeleteTips create() => UserCommandDeleteTips._();
  @$core.override
  UserCommandDeleteTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserCommandDeleteTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserCommandDeleteTips>(create);
  static UserCommandDeleteTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toUserID => $_getSZ(1);
  @$pb.TagNumber(2)
  set toUserID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUserID() => $_clearField(2);
}

/// ////////////////////conversation/////////////////////
class ConversationUpdateTips extends $pb.GeneratedMessage {
  factory ConversationUpdateTips({
    $core.String? userID,
    $core.Iterable<$core.String>? conversationIDList,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (conversationIDList != null)
      result.conversationIDList.addAll(conversationIDList);
    return result;
  }

  ConversationUpdateTips._();

  factory ConversationUpdateTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConversationUpdateTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConversationUpdateTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..pPS(2, _omitFieldNames ? '' : 'conversationIDList',
        protoName: 'conversationIDList')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConversationUpdateTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConversationUpdateTips copyWith(
          void Function(ConversationUpdateTips) updates) =>
      super.copyWith((message) => updates(message as ConversationUpdateTips))
          as ConversationUpdateTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConversationUpdateTips create() => ConversationUpdateTips._();
  @$core.override
  ConversationUpdateTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConversationUpdateTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConversationUpdateTips>(create);
  static ConversationUpdateTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get conversationIDList => $_getList(1);
}

class ConversationSetPrivateTips extends $pb.GeneratedMessage {
  factory ConversationSetPrivateTips({
    $core.String? recvID,
    $core.String? sendID,
    $core.bool? isPrivate,
    $core.String? conversationID,
  }) {
    final result = create();
    if (recvID != null) result.recvID = recvID;
    if (sendID != null) result.sendID = sendID;
    if (isPrivate != null) result.isPrivate = isPrivate;
    if (conversationID != null) result.conversationID = conversationID;
    return result;
  }

  ConversationSetPrivateTips._();

  factory ConversationSetPrivateTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConversationSetPrivateTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConversationSetPrivateTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recvID', protoName: 'recvID')
    ..aOS(2, _omitFieldNames ? '' : 'sendID', protoName: 'sendID')
    ..aOB(3, _omitFieldNames ? '' : 'isPrivate', protoName: 'isPrivate')
    ..aOS(4, _omitFieldNames ? '' : 'conversationID',
        protoName: 'conversationID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConversationSetPrivateTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConversationSetPrivateTips copyWith(
          void Function(ConversationSetPrivateTips) updates) =>
      super.copyWith(
              (message) => updates(message as ConversationSetPrivateTips))
          as ConversationSetPrivateTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConversationSetPrivateTips create() => ConversationSetPrivateTips._();
  @$core.override
  ConversationSetPrivateTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConversationSetPrivateTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConversationSetPrivateTips>(create);
  static ConversationSetPrivateTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recvID => $_getSZ(0);
  @$pb.TagNumber(1)
  set recvID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecvID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecvID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sendID => $_getSZ(1);
  @$pb.TagNumber(2)
  set sendID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSendID() => $_has(1);
  @$pb.TagNumber(2)
  void clearSendID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isPrivate => $_getBF(2);
  @$pb.TagNumber(3)
  set isPrivate($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsPrivate() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsPrivate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get conversationID => $_getSZ(3);
  @$pb.TagNumber(4)
  set conversationID($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConversationID() => $_has(3);
  @$pb.TagNumber(4)
  void clearConversationID() => $_clearField(4);
}

class ConversationHasReadTips extends $pb.GeneratedMessage {
  factory ConversationHasReadTips({
    $core.String? userID,
    $core.String? conversationID,
    $fixnum.Int64? hasReadSeq,
    $fixnum.Int64? unreadCountTime,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (conversationID != null) result.conversationID = conversationID;
    if (hasReadSeq != null) result.hasReadSeq = hasReadSeq;
    if (unreadCountTime != null) result.unreadCountTime = unreadCountTime;
    return result;
  }

  ConversationHasReadTips._();

  factory ConversationHasReadTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConversationHasReadTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConversationHasReadTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'conversationID',
        protoName: 'conversationID')
    ..aInt64(3, _omitFieldNames ? '' : 'hasReadSeq', protoName: 'hasReadSeq')
    ..aInt64(4, _omitFieldNames ? '' : 'unreadCountTime',
        protoName: 'unreadCountTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConversationHasReadTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConversationHasReadTips copyWith(
          void Function(ConversationHasReadTips) updates) =>
      super.copyWith((message) => updates(message as ConversationHasReadTips))
          as ConversationHasReadTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConversationHasReadTips create() => ConversationHasReadTips._();
  @$core.override
  ConversationHasReadTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConversationHasReadTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConversationHasReadTips>(create);
  static ConversationHasReadTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get conversationID => $_getSZ(1);
  @$pb.TagNumber(2)
  set conversationID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConversationID() => $_has(1);
  @$pb.TagNumber(2)
  void clearConversationID() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get hasReadSeq => $_getI64(2);
  @$pb.TagNumber(3)
  set hasReadSeq($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasReadSeq() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasReadSeq() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get unreadCountTime => $_getI64(3);
  @$pb.TagNumber(4)
  set unreadCountTime($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnreadCountTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnreadCountTime() => $_clearField(4);
}

class NotificationElem extends $pb.GeneratedMessage {
  factory NotificationElem({
    $core.String? detail,
  }) {
    final result = create();
    if (detail != null) result.detail = detail;
    return result;
  }

  NotificationElem._();

  factory NotificationElem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotificationElem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationElem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationElem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationElem copyWith(void Function(NotificationElem) updates) =>
      super.copyWith((message) => updates(message as NotificationElem))
          as NotificationElem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotificationElem create() => NotificationElem._();
  @$core.override
  NotificationElem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotificationElem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationElem>(create);
  static NotificationElem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get detail => $_getSZ(0);
  @$pb.TagNumber(1)
  set detail($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDetail() => $_has(0);
  @$pb.TagNumber(1)
  void clearDetail() => $_clearField(1);
}

/// //////////////////message///////////////////////
class SeqList extends $pb.GeneratedMessage {
  factory SeqList({
    $core.Iterable<$fixnum.Int64>? seqs,
  }) {
    final result = create();
    if (seqs != null) result.seqs.addAll(seqs);
    return result;
  }

  SeqList._();

  factory SeqList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SeqList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeqList',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'seqs', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeqList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeqList copyWith(void Function(SeqList) updates) =>
      super.copyWith((message) => updates(message as SeqList)) as SeqList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeqList create() => SeqList._();
  @$core.override
  SeqList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SeqList getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SeqList>(create);
  static SeqList? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get seqs => $_getList(0);
}

class DeleteMessageTips extends $pb.GeneratedMessage {
  factory DeleteMessageTips({
    $core.String? opUserID,
    $core.String? userID,
    $core.Iterable<$fixnum.Int64>? seqs,
  }) {
    final result = create();
    if (opUserID != null) result.opUserID = opUserID;
    if (userID != null) result.userID = userID;
    if (seqs != null) result.seqs.addAll(seqs);
    return result;
  }

  DeleteMessageTips._();

  factory DeleteMessageTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteMessageTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteMessageTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'opUserID', protoName: 'opUserID')
    ..aOS(2, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..p<$fixnum.Int64>(3, _omitFieldNames ? '' : 'seqs', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMessageTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMessageTips copyWith(void Function(DeleteMessageTips) updates) =>
      super.copyWith((message) => updates(message as DeleteMessageTips))
          as DeleteMessageTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteMessageTips create() => DeleteMessageTips._();
  @$core.override
  DeleteMessageTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteMessageTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteMessageTips>(create);
  static DeleteMessageTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get opUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set opUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userID => $_getSZ(1);
  @$pb.TagNumber(2)
  set userID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get seqs => $_getList(2);
}

class RevokeMsgTips extends $pb.GeneratedMessage {
  factory RevokeMsgTips({
    $core.String? revokerUserID,
    $core.String? clientMsgID,
    $fixnum.Int64? revokeTime,
    $core.int? sesstionType,
    $fixnum.Int64? seq,
    $core.String? conversationID,
    $core.bool? isAdminRevoke,
  }) {
    final result = create();
    if (revokerUserID != null) result.revokerUserID = revokerUserID;
    if (clientMsgID != null) result.clientMsgID = clientMsgID;
    if (revokeTime != null) result.revokeTime = revokeTime;
    if (sesstionType != null) result.sesstionType = sesstionType;
    if (seq != null) result.seq = seq;
    if (conversationID != null) result.conversationID = conversationID;
    if (isAdminRevoke != null) result.isAdminRevoke = isAdminRevoke;
    return result;
  }

  RevokeMsgTips._();

  factory RevokeMsgTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RevokeMsgTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevokeMsgTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'revokerUserID', protoName: 'revokerUserID')
    ..aOS(2, _omitFieldNames ? '' : 'clientMsgID', protoName: 'clientMsgID')
    ..aInt64(3, _omitFieldNames ? '' : 'revokeTime', protoName: 'revokeTime')
    ..aI(5, _omitFieldNames ? '' : 'sesstionType', protoName: 'sesstionType')
    ..aInt64(6, _omitFieldNames ? '' : 'seq')
    ..aOS(7, _omitFieldNames ? '' : 'conversationID',
        protoName: 'conversationID')
    ..aOB(8, _omitFieldNames ? '' : 'isAdminRevoke', protoName: 'isAdminRevoke')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeMsgTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevokeMsgTips copyWith(void Function(RevokeMsgTips) updates) =>
      super.copyWith((message) => updates(message as RevokeMsgTips))
          as RevokeMsgTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevokeMsgTips create() => RevokeMsgTips._();
  @$core.override
  RevokeMsgTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RevokeMsgTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevokeMsgTips>(create);
  static RevokeMsgTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get revokerUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set revokerUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRevokerUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevokerUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientMsgID => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientMsgID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientMsgID() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientMsgID() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get revokeTime => $_getI64(2);
  @$pb.TagNumber(3)
  set revokeTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevokeTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevokeTime() => $_clearField(3);

  @$pb.TagNumber(5)
  $core.int get sesstionType => $_getIZ(3);
  @$pb.TagNumber(5)
  set sesstionType($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(5)
  $core.bool hasSesstionType() => $_has(3);
  @$pb.TagNumber(5)
  void clearSesstionType() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get seq => $_getI64(4);
  @$pb.TagNumber(6)
  set seq($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(6)
  $core.bool hasSeq() => $_has(4);
  @$pb.TagNumber(6)
  void clearSeq() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get conversationID => $_getSZ(5);
  @$pb.TagNumber(7)
  set conversationID($core.String value) => $_setString(5, value);
  @$pb.TagNumber(7)
  $core.bool hasConversationID() => $_has(5);
  @$pb.TagNumber(7)
  void clearConversationID() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isAdminRevoke => $_getBF(6);
  @$pb.TagNumber(8)
  set isAdminRevoke($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(8)
  $core.bool hasIsAdminRevoke() => $_has(6);
  @$pb.TagNumber(8)
  void clearIsAdminRevoke() => $_clearField(8);
}

class MessageRevokedContent extends $pb.GeneratedMessage {
  factory MessageRevokedContent({
    $core.String? revokerID,
    $core.int? revokerRole,
    $core.String? clientMsgID,
    $core.String? revokerNickname,
    $fixnum.Int64? revokeTime,
    $fixnum.Int64? sourceMessageSendTime,
    $core.String? sourceMessageSendID,
    $core.String? sourceMessageSenderNickname,
    $core.int? sessionType,
    $fixnum.Int64? seq,
    $core.String? ex,
  }) {
    final result = create();
    if (revokerID != null) result.revokerID = revokerID;
    if (revokerRole != null) result.revokerRole = revokerRole;
    if (clientMsgID != null) result.clientMsgID = clientMsgID;
    if (revokerNickname != null) result.revokerNickname = revokerNickname;
    if (revokeTime != null) result.revokeTime = revokeTime;
    if (sourceMessageSendTime != null)
      result.sourceMessageSendTime = sourceMessageSendTime;
    if (sourceMessageSendID != null)
      result.sourceMessageSendID = sourceMessageSendID;
    if (sourceMessageSenderNickname != null)
      result.sourceMessageSenderNickname = sourceMessageSenderNickname;
    if (sessionType != null) result.sessionType = sessionType;
    if (seq != null) result.seq = seq;
    if (ex != null) result.ex = ex;
    return result;
  }

  MessageRevokedContent._();

  factory MessageRevokedContent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageRevokedContent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MessageRevokedContent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'revokerID', protoName: 'revokerID')
    ..aI(2, _omitFieldNames ? '' : 'revokerRole', protoName: 'revokerRole')
    ..aOS(3, _omitFieldNames ? '' : 'clientMsgID', protoName: 'clientMsgID')
    ..aOS(4, _omitFieldNames ? '' : 'revokerNickname',
        protoName: 'revokerNickname')
    ..aInt64(5, _omitFieldNames ? '' : 'revokeTime', protoName: 'revokeTime')
    ..aInt64(6, _omitFieldNames ? '' : 'sourceMessageSendTime',
        protoName: 'sourceMessageSendTime')
    ..aOS(7, _omitFieldNames ? '' : 'sourceMessageSendID',
        protoName: 'sourceMessageSendID')
    ..aOS(8, _omitFieldNames ? '' : 'sourceMessageSenderNickname',
        protoName: 'sourceMessageSenderNickname')
    ..aI(10, _omitFieldNames ? '' : 'sessionType', protoName: 'sessionType')
    ..aInt64(11, _omitFieldNames ? '' : 'seq')
    ..aOS(12, _omitFieldNames ? '' : 'ex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageRevokedContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageRevokedContent copyWith(
          void Function(MessageRevokedContent) updates) =>
      super.copyWith((message) => updates(message as MessageRevokedContent))
          as MessageRevokedContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageRevokedContent create() => MessageRevokedContent._();
  @$core.override
  MessageRevokedContent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageRevokedContent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MessageRevokedContent>(create);
  static MessageRevokedContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get revokerID => $_getSZ(0);
  @$pb.TagNumber(1)
  set revokerID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRevokerID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevokerID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get revokerRole => $_getIZ(1);
  @$pb.TagNumber(2)
  set revokerRole($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevokerRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevokerRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get clientMsgID => $_getSZ(2);
  @$pb.TagNumber(3)
  set clientMsgID($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClientMsgID() => $_has(2);
  @$pb.TagNumber(3)
  void clearClientMsgID() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get revokerNickname => $_getSZ(3);
  @$pb.TagNumber(4)
  set revokerNickname($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevokerNickname() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevokerNickname() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get revokeTime => $_getI64(4);
  @$pb.TagNumber(5)
  set revokeTime($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRevokeTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearRevokeTime() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get sourceMessageSendTime => $_getI64(5);
  @$pb.TagNumber(6)
  set sourceMessageSendTime($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceMessageSendTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceMessageSendTime() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sourceMessageSendID => $_getSZ(6);
  @$pb.TagNumber(7)
  set sourceMessageSendID($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSourceMessageSendID() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceMessageSendID() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get sourceMessageSenderNickname => $_getSZ(7);
  @$pb.TagNumber(8)
  set sourceMessageSenderNickname($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSourceMessageSenderNickname() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceMessageSenderNickname() => $_clearField(8);

  @$pb.TagNumber(10)
  $core.int get sessionType => $_getIZ(8);
  @$pb.TagNumber(10)
  set sessionType($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(10)
  $core.bool hasSessionType() => $_has(8);
  @$pb.TagNumber(10)
  void clearSessionType() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get seq => $_getI64(9);
  @$pb.TagNumber(11)
  set seq($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(11)
  $core.bool hasSeq() => $_has(9);
  @$pb.TagNumber(11)
  void clearSeq() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get ex => $_getSZ(10);
  @$pb.TagNumber(12)
  set ex($core.String value) => $_setString(10, value);
  @$pb.TagNumber(12)
  $core.bool hasEx() => $_has(10);
  @$pb.TagNumber(12)
  void clearEx() => $_clearField(12);
}

class ClearConversationTips extends $pb.GeneratedMessage {
  factory ClearConversationTips({
    $core.String? userID,
    $core.Iterable<$core.String>? conversationIDs,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (conversationIDs != null) result.conversationIDs.addAll(conversationIDs);
    return result;
  }

  ClearConversationTips._();

  factory ClearConversationTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearConversationTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearConversationTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..pPS(2, _omitFieldNames ? '' : 'conversationIDs',
        protoName: 'conversationIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearConversationTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearConversationTips copyWith(
          void Function(ClearConversationTips) updates) =>
      super.copyWith((message) => updates(message as ClearConversationTips))
          as ClearConversationTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearConversationTips create() => ClearConversationTips._();
  @$core.override
  ClearConversationTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearConversationTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearConversationTips>(create);
  static ClearConversationTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get conversationIDs => $_getList(1);
}

class DeleteMsgsTips extends $pb.GeneratedMessage {
  factory DeleteMsgsTips({
    $core.String? userID,
    $core.String? conversationID,
    $core.Iterable<$fixnum.Int64>? seqs,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (conversationID != null) result.conversationID = conversationID;
    if (seqs != null) result.seqs.addAll(seqs);
    return result;
  }

  DeleteMsgsTips._();

  factory DeleteMsgsTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteMsgsTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteMsgsTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'conversationID',
        protoName: 'conversationID')
    ..p<$fixnum.Int64>(3, _omitFieldNames ? '' : 'seqs', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMsgsTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteMsgsTips copyWith(void Function(DeleteMsgsTips) updates) =>
      super.copyWith((message) => updates(message as DeleteMsgsTips))
          as DeleteMsgsTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteMsgsTips create() => DeleteMsgsTips._();
  @$core.override
  DeleteMsgsTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteMsgsTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteMsgsTips>(create);
  static DeleteMsgsTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get conversationID => $_getSZ(1);
  @$pb.TagNumber(2)
  set conversationID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConversationID() => $_has(1);
  @$pb.TagNumber(2)
  void clearConversationID() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get seqs => $_getList(2);
}

class MarkAsReadTips extends $pb.GeneratedMessage {
  factory MarkAsReadTips({
    $core.String? markAsReadUserID,
    $core.String? conversationID,
    $core.Iterable<$fixnum.Int64>? seqs,
    $fixnum.Int64? hasReadSeq,
  }) {
    final result = create();
    if (markAsReadUserID != null) result.markAsReadUserID = markAsReadUserID;
    if (conversationID != null) result.conversationID = conversationID;
    if (seqs != null) result.seqs.addAll(seqs);
    if (hasReadSeq != null) result.hasReadSeq = hasReadSeq;
    return result;
  }

  MarkAsReadTips._();

  factory MarkAsReadTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MarkAsReadTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MarkAsReadTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'markAsReadUserID',
        protoName: 'markAsReadUserID')
    ..aOS(2, _omitFieldNames ? '' : 'conversationID',
        protoName: 'conversationID')
    ..p<$fixnum.Int64>(3, _omitFieldNames ? '' : 'seqs', $pb.PbFieldType.K6)
    ..aInt64(4, _omitFieldNames ? '' : 'hasReadSeq', protoName: 'hasReadSeq')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAsReadTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MarkAsReadTips copyWith(void Function(MarkAsReadTips) updates) =>
      super.copyWith((message) => updates(message as MarkAsReadTips))
          as MarkAsReadTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarkAsReadTips create() => MarkAsReadTips._();
  @$core.override
  MarkAsReadTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MarkAsReadTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MarkAsReadTips>(create);
  static MarkAsReadTips? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get markAsReadUserID => $_getSZ(0);
  @$pb.TagNumber(1)
  set markAsReadUserID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMarkAsReadUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearMarkAsReadUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get conversationID => $_getSZ(1);
  @$pb.TagNumber(2)
  set conversationID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConversationID() => $_has(1);
  @$pb.TagNumber(2)
  void clearConversationID() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$fixnum.Int64> get seqs => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get hasReadSeq => $_getI64(3);
  @$pb.TagNumber(4)
  set hasReadSeq($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHasReadSeq() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasReadSeq() => $_clearField(4);
}

class SetAppBackgroundStatusReq extends $pb.GeneratedMessage {
  factory SetAppBackgroundStatusReq({
    $core.String? userID,
    $core.bool? isBackground,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (isBackground != null) result.isBackground = isBackground;
    return result;
  }

  SetAppBackgroundStatusReq._();

  factory SetAppBackgroundStatusReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAppBackgroundStatusReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAppBackgroundStatusReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOB(2, _omitFieldNames ? '' : 'isBackground', protoName: 'isBackground')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAppBackgroundStatusReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAppBackgroundStatusReq copyWith(
          void Function(SetAppBackgroundStatusReq) updates) =>
      super.copyWith((message) => updates(message as SetAppBackgroundStatusReq))
          as SetAppBackgroundStatusReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAppBackgroundStatusReq create() => SetAppBackgroundStatusReq._();
  @$core.override
  SetAppBackgroundStatusReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAppBackgroundStatusReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAppBackgroundStatusReq>(create);
  static SetAppBackgroundStatusReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isBackground => $_getBF(1);
  @$pb.TagNumber(2)
  set isBackground($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsBackground() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsBackground() => $_clearField(2);
}

class SetAppBackgroundStatusResp extends $pb.GeneratedMessage {
  factory SetAppBackgroundStatusResp() => create();

  SetAppBackgroundStatusResp._();

  factory SetAppBackgroundStatusResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAppBackgroundStatusResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAppBackgroundStatusResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAppBackgroundStatusResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAppBackgroundStatusResp copyWith(
          void Function(SetAppBackgroundStatusResp) updates) =>
      super.copyWith(
              (message) => updates(message as SetAppBackgroundStatusResp))
          as SetAppBackgroundStatusResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAppBackgroundStatusResp create() => SetAppBackgroundStatusResp._();
  @$core.override
  SetAppBackgroundStatusResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAppBackgroundStatusResp getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAppBackgroundStatusResp>(create);
  static SetAppBackgroundStatusResp? _defaultInstance;
}

class ProcessUserCommand extends $pb.GeneratedMessage {
  factory ProcessUserCommand({
    $core.String? userID,
    $core.int? type,
    $fixnum.Int64? createTime,
    $core.String? uuid,
    $core.String? value,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (type != null) result.type = type;
    if (createTime != null) result.createTime = createTime;
    if (uuid != null) result.uuid = uuid;
    if (value != null) result.value = value;
    return result;
  }

  ProcessUserCommand._();

  factory ProcessUserCommand.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProcessUserCommand.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProcessUserCommand',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aI(2, _omitFieldNames ? '' : 'type')
    ..aInt64(3, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..aOS(4, _omitFieldNames ? '' : 'uuid')
    ..aOS(5, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessUserCommand clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessUserCommand copyWith(void Function(ProcessUserCommand) updates) =>
      super.copyWith((message) => updates(message as ProcessUserCommand))
          as ProcessUserCommand;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProcessUserCommand create() => ProcessUserCommand._();
  @$core.override
  ProcessUserCommand createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProcessUserCommand getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProcessUserCommand>(create);
  static ProcessUserCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userID => $_getSZ(0);
  @$pb.TagNumber(1)
  set userID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get type => $_getIZ(1);
  @$pb.TagNumber(2)
  set type($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get createTime => $_getI64(2);
  @$pb.TagNumber(3)
  set createTime($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreateTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreateTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get uuid => $_getSZ(3);
  @$pb.TagNumber(4)
  set uuid($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUuid() => $_has(3);
  @$pb.TagNumber(4)
  void clearUuid() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get value => $_getSZ(4);
  @$pb.TagNumber(5)
  set value($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => $_clearField(5);
}

class RequestPagination extends $pb.GeneratedMessage {
  factory RequestPagination({
    $core.int? pageNumber,
    $core.int? showNumber,
  }) {
    final result = create();
    if (pageNumber != null) result.pageNumber = pageNumber;
    if (showNumber != null) result.showNumber = showNumber;
    return result;
  }

  RequestPagination._();

  factory RequestPagination.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestPagination.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestPagination',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageNumber', protoName: 'pageNumber')
    ..aI(2, _omitFieldNames ? '' : 'showNumber', protoName: 'showNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPagination clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestPagination copyWith(void Function(RequestPagination) updates) =>
      super.copyWith((message) => updates(message as RequestPagination))
          as RequestPagination;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestPagination create() => RequestPagination._();
  @$core.override
  RequestPagination createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestPagination getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestPagination>(create);
  static RequestPagination? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageNumber => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageNumber($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get showNumber => $_getIZ(1);
  @$pb.TagNumber(2)
  set showNumber($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShowNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearShowNumber() => $_clearField(2);
}

class FriendsInfoUpdateTips extends $pb.GeneratedMessage {
  factory FriendsInfoUpdateTips({
    FromToUserID? fromToUserID,
    $core.Iterable<$core.String>? friendIDs,
  }) {
    final result = create();
    if (fromToUserID != null) result.fromToUserID = fromToUserID;
    if (friendIDs != null) result.friendIDs.addAll(friendIDs);
    return result;
  }

  FriendsInfoUpdateTips._();

  factory FriendsInfoUpdateTips.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FriendsInfoUpdateTips.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FriendsInfoUpdateTips',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.sdkws'),
      createEmptyInstance: create)
    ..aOM<FromToUserID>(1, _omitFieldNames ? '' : 'fromToUserID',
        protoName: 'fromToUserID', subBuilder: FromToUserID.create)
    ..pPS(2, _omitFieldNames ? '' : 'friendIDs', protoName: 'friendIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendsInfoUpdateTips clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FriendsInfoUpdateTips copyWith(
          void Function(FriendsInfoUpdateTips) updates) =>
      super.copyWith((message) => updates(message as FriendsInfoUpdateTips))
          as FriendsInfoUpdateTips;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendsInfoUpdateTips create() => FriendsInfoUpdateTips._();
  @$core.override
  FriendsInfoUpdateTips createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FriendsInfoUpdateTips getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FriendsInfoUpdateTips>(create);
  static FriendsInfoUpdateTips? _defaultInstance;

  @$pb.TagNumber(1)
  FromToUserID get fromToUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromToUserID(FromToUserID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFromToUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromToUserID() => $_clearField(1);
  @$pb.TagNumber(1)
  FromToUserID ensureFromToUserID() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get friendIDs => $_getList(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
