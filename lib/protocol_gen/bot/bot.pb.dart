// This is a generated file - do not edit.
//
// Generated from bot/bot.proto.

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

import '../sdkws/sdkws.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Agent extends $pb.GeneratedMessage {
  factory Agent({
    $core.String? userID,
    $core.String? nickname,
    $core.String? faceURL,
    $core.String? url,
    $core.String? key,
    $core.String? identity,
    $core.String? model,
    $core.String? prompts,
    $fixnum.Int64? createTime,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    if (url != null) result.url = url;
    if (key != null) result.key = key;
    if (identity != null) result.identity = identity;
    if (model != null) result.model = model;
    if (prompts != null) result.prompts = prompts;
    if (createTime != null) result.createTime = createTime;
    return result;
  }

  Agent._();

  factory Agent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Agent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Agent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'nickname')
    ..aOS(3, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..aOS(5, _omitFieldNames ? '' : 'key')
    ..aOS(6, _omitFieldNames ? '' : 'identity')
    ..aOS(7, _omitFieldNames ? '' : 'model')
    ..aOS(8, _omitFieldNames ? '' : 'prompts')
    ..aInt64(9, _omitFieldNames ? '' : 'createTime', protoName: 'createTime')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Agent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Agent copyWith(void Function(Agent) updates) =>
      super.copyWith((message) => updates(message as Agent)) as Agent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Agent create() => Agent._();
  @$core.override
  Agent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Agent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Agent>(create);
  static Agent? _defaultInstance;

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
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get key => $_getSZ(4);
  @$pb.TagNumber(5)
  set key($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get identity => $_getSZ(5);
  @$pb.TagNumber(6)
  set identity($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIdentity() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdentity() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get model => $_getSZ(6);
  @$pb.TagNumber(7)
  set model($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasModel() => $_has(6);
  @$pb.TagNumber(7)
  void clearModel() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get prompts => $_getSZ(7);
  @$pb.TagNumber(8)
  set prompts($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPrompts() => $_has(7);
  @$pb.TagNumber(8)
  void clearPrompts() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createTime => $_getI64(8);
  @$pb.TagNumber(9)
  set createTime($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreateTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreateTime() => $_clearField(9);
}

class CreateAgentReq extends $pb.GeneratedMessage {
  factory CreateAgentReq({
    Agent? agent,
  }) {
    final result = create();
    if (agent != null) result.agent = agent;
    return result;
  }

  CreateAgentReq._();

  factory CreateAgentReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateAgentReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateAgentReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..aOM<Agent>(1, _omitFieldNames ? '' : 'agent', subBuilder: Agent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAgentReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAgentReq copyWith(void Function(CreateAgentReq) updates) =>
      super.copyWith((message) => updates(message as CreateAgentReq)) as CreateAgentReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAgentReq create() => CreateAgentReq._();
  @$core.override
  CreateAgentReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateAgentReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateAgentReq>(create);
  static CreateAgentReq? _defaultInstance;

  @$pb.TagNumber(1)
  Agent get agent => $_getN(0);
  @$pb.TagNumber(1)
  set agent(Agent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAgent() => $_has(0);
  @$pb.TagNumber(1)
  void clearAgent() => $_clearField(1);
  @$pb.TagNumber(1)
  Agent ensureAgent() => $_ensure(0);
}

class CreateAgentResp extends $pb.GeneratedMessage {
  factory CreateAgentResp() => create();

  CreateAgentResp._();

  factory CreateAgentResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateAgentResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateAgentResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAgentResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateAgentResp copyWith(void Function(CreateAgentResp) updates) =>
      super.copyWith((message) => updates(message as CreateAgentResp)) as CreateAgentResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAgentResp create() => CreateAgentResp._();
  @$core.override
  CreateAgentResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateAgentResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateAgentResp>(create);
  static CreateAgentResp? _defaultInstance;
}

class UpdateAgentReq extends $pb.GeneratedMessage {
  factory UpdateAgentReq({
    $core.String? userID,
    $core.String? nickname,
    $core.String? faceURL,
    $core.String? url,
    $core.String? key,
    $core.String? identity,
    $core.String? model,
    $core.String? prompts,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (nickname != null) result.nickname = nickname;
    if (faceURL != null) result.faceURL = faceURL;
    if (url != null) result.url = url;
    if (key != null) result.key = key;
    if (identity != null) result.identity = identity;
    if (model != null) result.model = model;
    if (prompts != null) result.prompts = prompts;
    return result;
  }

  UpdateAgentReq._();

  factory UpdateAgentReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateAgentReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateAgentReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userID', protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'nickname')
    ..aOS(3, _omitFieldNames ? '' : 'faceURL', protoName: 'faceURL')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..aOS(5, _omitFieldNames ? '' : 'key')
    ..aOS(6, _omitFieldNames ? '' : 'identity')
    ..aOS(7, _omitFieldNames ? '' : 'model')
    ..aOS(8, _omitFieldNames ? '' : 'prompts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAgentReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAgentReq copyWith(void Function(UpdateAgentReq) updates) =>
      super.copyWith((message) => updates(message as UpdateAgentReq)) as UpdateAgentReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAgentReq create() => UpdateAgentReq._();
  @$core.override
  UpdateAgentReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateAgentReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateAgentReq>(create);
  static UpdateAgentReq? _defaultInstance;

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
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get key => $_getSZ(4);
  @$pb.TagNumber(5)
  set key($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get identity => $_getSZ(5);
  @$pb.TagNumber(6)
  set identity($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIdentity() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdentity() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get model => $_getSZ(6);
  @$pb.TagNumber(7)
  set model($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasModel() => $_has(6);
  @$pb.TagNumber(7)
  void clearModel() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get prompts => $_getSZ(7);
  @$pb.TagNumber(8)
  set prompts($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPrompts() => $_has(7);
  @$pb.TagNumber(8)
  void clearPrompts() => $_clearField(8);
}

class UpdateAgentResp extends $pb.GeneratedMessage {
  factory UpdateAgentResp() => create();

  UpdateAgentResp._();

  factory UpdateAgentResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateAgentResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateAgentResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAgentResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAgentResp copyWith(void Function(UpdateAgentResp) updates) =>
      super.copyWith((message) => updates(message as UpdateAgentResp)) as UpdateAgentResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAgentResp create() => UpdateAgentResp._();
  @$core.override
  UpdateAgentResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateAgentResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateAgentResp>(create);
  static UpdateAgentResp? _defaultInstance;
}

class PageFindAgentReq extends $pb.GeneratedMessage {
  factory PageFindAgentReq({
    $0.RequestPagination? pagination,
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (pagination != null) result.pagination = pagination;
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  PageFindAgentReq._();

  factory PageFindAgentReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PageFindAgentReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PageFindAgentReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..aOM<$0.RequestPagination>(1, _omitFieldNames ? '' : 'pagination',
        subBuilder: $0.RequestPagination.create)
    ..pPS(2, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageFindAgentReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageFindAgentReq copyWith(void Function(PageFindAgentReq) updates) =>
      super.copyWith((message) => updates(message as PageFindAgentReq)) as PageFindAgentReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PageFindAgentReq create() => PageFindAgentReq._();
  @$core.override
  PageFindAgentReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PageFindAgentReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PageFindAgentReq>(create);
  static PageFindAgentReq? _defaultInstance;

  @$pb.TagNumber(1)
  $0.RequestPagination get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($0.RequestPagination value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.RequestPagination ensurePagination() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get userIDs => $_getList(1);
}

class PageFindAgentResp extends $pb.GeneratedMessage {
  factory PageFindAgentResp({
    $fixnum.Int64? total,
    $core.Iterable<Agent>? agents,
  }) {
    final result = create();
    if (total != null) result.total = total;
    if (agents != null) result.agents.addAll(agents);
    return result;
  }

  PageFindAgentResp._();

  factory PageFindAgentResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PageFindAgentResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PageFindAgentResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'total')
    ..pPM<Agent>(2, _omitFieldNames ? '' : 'agents', subBuilder: Agent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageFindAgentResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageFindAgentResp copyWith(void Function(PageFindAgentResp) updates) =>
      super.copyWith((message) => updates(message as PageFindAgentResp)) as PageFindAgentResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PageFindAgentResp create() => PageFindAgentResp._();
  @$core.override
  PageFindAgentResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PageFindAgentResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PageFindAgentResp>(create);
  static PageFindAgentResp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get total => $_getI64(0);
  @$pb.TagNumber(1)
  set total($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Agent> get agents => $_getList(1);
}

class DeleteAgentReq extends $pb.GeneratedMessage {
  factory DeleteAgentReq({
    $core.Iterable<$core.String>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  DeleteAgentReq._();

  factory DeleteAgentReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteAgentReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteAgentReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIDs', protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAgentReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAgentReq copyWith(void Function(DeleteAgentReq) updates) =>
      super.copyWith((message) => updates(message as DeleteAgentReq)) as DeleteAgentReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteAgentReq create() => DeleteAgentReq._();
  @$core.override
  DeleteAgentReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteAgentReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteAgentReq>(create);
  static DeleteAgentReq? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIDs => $_getList(0);
}

class DeleteAgentResp extends $pb.GeneratedMessage {
  factory DeleteAgentResp() => create();

  DeleteAgentResp._();

  factory DeleteAgentResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteAgentResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteAgentResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAgentResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAgentResp copyWith(void Function(DeleteAgentResp) updates) =>
      super.copyWith((message) => updates(message as DeleteAgentResp)) as DeleteAgentResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteAgentResp create() => DeleteAgentResp._();
  @$core.override
  DeleteAgentResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteAgentResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteAgentResp>(create);
  static DeleteAgentResp? _defaultInstance;
}

class SendBotMessageReq extends $pb.GeneratedMessage {
  factory SendBotMessageReq({
    $core.String? agentID,
    $core.String? conversationID,
    $core.int? contentType,
    $core.String? content,
    $core.String? ex,
    $core.String? key,
  }) {
    final result = create();
    if (agentID != null) result.agentID = agentID;
    if (conversationID != null) result.conversationID = conversationID;
    if (contentType != null) result.contentType = contentType;
    if (content != null) result.content = content;
    if (ex != null) result.ex = ex;
    if (key != null) result.key = key;
    return result;
  }

  SendBotMessageReq._();

  factory SendBotMessageReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendBotMessageReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SendBotMessageReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'agentID', protoName: 'agentID')
    ..aOS(2, _omitFieldNames ? '' : 'conversationID', protoName: 'conversationID')
    ..aI(3, _omitFieldNames ? '' : 'contentType', protoName: 'contentType')
    ..aOS(4, _omitFieldNames ? '' : 'content')
    ..aOS(5, _omitFieldNames ? '' : 'ex')
    ..aOS(6, _omitFieldNames ? '' : 'key')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendBotMessageReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendBotMessageReq copyWith(void Function(SendBotMessageReq) updates) =>
      super.copyWith((message) => updates(message as SendBotMessageReq)) as SendBotMessageReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendBotMessageReq create() => SendBotMessageReq._();
  @$core.override
  SendBotMessageReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendBotMessageReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendBotMessageReq>(create);
  static SendBotMessageReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get agentID => $_getSZ(0);
  @$pb.TagNumber(1)
  set agentID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAgentID() => $_has(0);
  @$pb.TagNumber(1)
  void clearAgentID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get conversationID => $_getSZ(1);
  @$pb.TagNumber(2)
  set conversationID($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConversationID() => $_has(1);
  @$pb.TagNumber(2)
  void clearConversationID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get contentType => $_getIZ(2);
  @$pb.TagNumber(3)
  set contentType($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearContentType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(4)
  set content($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get ex => $_getSZ(4);
  @$pb.TagNumber(5)
  set ex($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEx() => $_has(4);
  @$pb.TagNumber(5)
  void clearEx() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get key => $_getSZ(5);
  @$pb.TagNumber(6)
  set key($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearKey() => $_clearField(6);
}

class SendBotMessageResp extends $pb.GeneratedMessage {
  factory SendBotMessageResp() => create();

  SendBotMessageResp._();

  factory SendBotMessageResp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendBotMessageResp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SendBotMessageResp',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'openim.bot'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendBotMessageResp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendBotMessageResp copyWith(void Function(SendBotMessageResp) updates) =>
      super.copyWith((message) => updates(message as SendBotMessageResp)) as SendBotMessageResp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendBotMessageResp create() => SendBotMessageResp._();
  @$core.override
  SendBotMessageResp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SendBotMessageResp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendBotMessageResp>(create);
  static SendBotMessageResp? _defaultInstance;
}

class botApi {
  final $pb.RpcClient _client;

  botApi(this._client);

  $async.Future<CreateAgentResp> createAgent($pb.ClientContext? ctx, CreateAgentReq request) =>
      _client.invoke<CreateAgentResp>(ctx, 'bot', 'CreateAgent', request, CreateAgentResp());
  $async.Future<UpdateAgentResp> updateAgent($pb.ClientContext? ctx, UpdateAgentReq request) =>
      _client.invoke<UpdateAgentResp>(ctx, 'bot', 'UpdateAgent', request, UpdateAgentResp());
  $async.Future<PageFindAgentResp> pageFindAgent(
          $pb.ClientContext? ctx, PageFindAgentReq request) =>
      _client.invoke<PageFindAgentResp>(ctx, 'bot', 'PageFindAgent', request, PageFindAgentResp());
  $async.Future<DeleteAgentResp> deleteAgent($pb.ClientContext? ctx, DeleteAgentReq request) =>
      _client.invoke<DeleteAgentResp>(ctx, 'bot', 'DeleteAgent', request, DeleteAgentResp());
  $async.Future<SendBotMessageResp> sendBotMessage(
          $pb.ClientContext? ctx, SendBotMessageReq request) =>
      _client.invoke<SendBotMessageResp>(
          ctx, 'bot', 'SendBotMessage', request, SendBotMessageResp());
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
