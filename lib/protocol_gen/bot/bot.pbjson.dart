// This is a generated file - do not edit.
//
// Generated from bot/bot.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../sdkws/sdkws.pbjson.dart' as $0;

@$core.Deprecated('Use agentDescriptor instead')
const Agent$json = {
  '1': 'Agent',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'nickname', '3': 2, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'faceURL', '3': 3, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
    {'1': 'key', '3': 5, '4': 1, '5': 9, '10': 'key'},
    {'1': 'identity', '3': 6, '4': 1, '5': 9, '10': 'identity'},
    {'1': 'model', '3': 7, '4': 1, '5': 9, '10': 'model'},
    {'1': 'prompts', '3': 8, '4': 1, '5': 9, '10': 'prompts'},
    {'1': 'createTime', '3': 9, '4': 1, '5': 3, '10': 'createTime'},
  ],
};

/// Descriptor for `Agent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentDescriptor = $convert
    .base64Decode('CgVBZ2VudBIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBIaCghuaWNrbmFtZRgCIAEoCVIIbmlja2'
        '5hbWUSGAoHZmFjZVVSTBgDIAEoCVIHZmFjZVVSTBIQCgN1cmwYBCABKAlSA3VybBIQCgNrZXkY'
        'BSABKAlSA2tleRIaCghpZGVudGl0eRgGIAEoCVIIaWRlbnRpdHkSFAoFbW9kZWwYByABKAlSBW'
        '1vZGVsEhgKB3Byb21wdHMYCCABKAlSB3Byb21wdHMSHgoKY3JlYXRlVGltZRgJIAEoA1IKY3Jl'
        'YXRlVGltZQ==');

@$core.Deprecated('Use createAgentReqDescriptor instead')
const CreateAgentReq$json = {
  '1': 'CreateAgentReq',
  '2': [
    {'1': 'agent', '3': 1, '4': 1, '5': 11, '6': '.openim.bot.Agent', '10': 'agent'},
  ],
};

/// Descriptor for `CreateAgentReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAgentReqDescriptor = $convert
    .base64Decode('Cg5DcmVhdGVBZ2VudFJlcRInCgVhZ2VudBgBIAEoCzIRLm9wZW5pbS5ib3QuQWdlbnRSBWFnZW'
        '50');

@$core.Deprecated('Use createAgentRespDescriptor instead')
const CreateAgentResp$json = {
  '1': 'CreateAgentResp',
};

/// Descriptor for `CreateAgentResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAgentRespDescriptor =
    $convert.base64Decode('Cg9DcmVhdGVBZ2VudFJlc3A=');

@$core.Deprecated('Use updateAgentReqDescriptor instead')
const UpdateAgentReq$json = {
  '1': 'UpdateAgentReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'nickname', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'nickname', '17': true},
    {'1': 'faceURL', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'faceURL', '17': true},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'url', '17': true},
    {'1': 'key', '3': 5, '4': 1, '5': 9, '9': 3, '10': 'key', '17': true},
    {'1': 'identity', '3': 6, '4': 1, '5': 9, '9': 4, '10': 'identity', '17': true},
    {'1': 'model', '3': 7, '4': 1, '5': 9, '9': 5, '10': 'model', '17': true},
    {'1': 'prompts', '3': 8, '4': 1, '5': 9, '9': 6, '10': 'prompts', '17': true},
  ],
  '8': [
    {'1': '_nickname'},
    {'1': '_faceURL'},
    {'1': '_url'},
    {'1': '_key'},
    {'1': '_identity'},
    {'1': '_model'},
    {'1': '_prompts'},
  ],
};

/// Descriptor for `UpdateAgentReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAgentReqDescriptor = $convert
    .base64Decode('Cg5VcGRhdGVBZ2VudFJlcRIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBIfCghuaWNrbmFtZRgCIA'
        'EoCUgAUghuaWNrbmFtZYgBARIdCgdmYWNlVVJMGAMgASgJSAFSB2ZhY2VVUkyIAQESFQoDdXJs'
        'GAQgASgJSAJSA3VybIgBARIVCgNrZXkYBSABKAlIA1IDa2V5iAEBEh8KCGlkZW50aXR5GAYgAS'
        'gJSARSCGlkZW50aXR5iAEBEhkKBW1vZGVsGAcgASgJSAVSBW1vZGVsiAEBEh0KB3Byb21wdHMY'
        'CCABKAlIBlIHcHJvbXB0c4gBAUILCglfbmlja25hbWVCCgoIX2ZhY2VVUkxCBgoEX3VybEIGCg'
        'Rfa2V5QgsKCV9pZGVudGl0eUIICgZfbW9kZWxCCgoIX3Byb21wdHM=');

@$core.Deprecated('Use updateAgentRespDescriptor instead')
const UpdateAgentResp$json = {
  '1': 'UpdateAgentResp',
};

/// Descriptor for `UpdateAgentResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAgentRespDescriptor =
    $convert.base64Decode('Cg9VcGRhdGVBZ2VudFJlc3A=');

@$core.Deprecated('Use pageFindAgentReqDescriptor instead')
const PageFindAgentReq$json = {
  '1': 'PageFindAgentReq',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.RequestPagination',
      '10': 'pagination'
    },
    {'1': 'userIDs', '3': 2, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `PageFindAgentReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pageFindAgentReqDescriptor = $convert
    .base64Decode('ChBQYWdlRmluZEFnZW50UmVxEj8KCnBhZ2luYXRpb24YASABKAsyHy5vcGVuaW0uc2Rrd3MuUm'
        'VxdWVzdFBhZ2luYXRpb25SCnBhZ2luYXRpb24SGAoHdXNlcklEcxgCIAMoCVIHdXNlcklEcw==');

@$core.Deprecated('Use pageFindAgentRespDescriptor instead')
const PageFindAgentResp$json = {
  '1': 'PageFindAgentResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 3, '10': 'total'},
    {'1': 'agents', '3': 2, '4': 3, '5': 11, '6': '.openim.bot.Agent', '10': 'agents'},
  ],
};

/// Descriptor for `PageFindAgentResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pageFindAgentRespDescriptor = $convert
    .base64Decode('ChFQYWdlRmluZEFnZW50UmVzcBIUCgV0b3RhbBgBIAEoA1IFdG90YWwSKQoGYWdlbnRzGAIgAy'
        'gLMhEub3BlbmltLmJvdC5BZ2VudFIGYWdlbnRz');

@$core.Deprecated('Use deleteAgentReqDescriptor instead')
const DeleteAgentReq$json = {
  '1': 'DeleteAgentReq',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `DeleteAgentReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAgentReqDescriptor =
    $convert.base64Decode('Cg5EZWxldGVBZ2VudFJlcRIYCgd1c2VySURzGAEgAygJUgd1c2VySURz');

@$core.Deprecated('Use deleteAgentRespDescriptor instead')
const DeleteAgentResp$json = {
  '1': 'DeleteAgentResp',
};

/// Descriptor for `DeleteAgentResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAgentRespDescriptor =
    $convert.base64Decode('Cg9EZWxldGVBZ2VudFJlc3A=');

@$core.Deprecated('Use sendBotMessageReqDescriptor instead')
const SendBotMessageReq$json = {
  '1': 'SendBotMessageReq',
  '2': [
    {'1': 'agentID', '3': 1, '4': 1, '5': 9, '10': 'agentID'},
    {'1': 'conversationID', '3': 2, '4': 1, '5': 9, '10': 'conversationID'},
    {'1': 'contentType', '3': 3, '4': 1, '5': 5, '10': 'contentType'},
    {'1': 'content', '3': 4, '4': 1, '5': 9, '10': 'content'},
    {'1': 'ex', '3': 5, '4': 1, '5': 9, '10': 'ex'},
    {'1': 'key', '3': 6, '4': 1, '5': 9, '10': 'key'},
  ],
};

/// Descriptor for `SendBotMessageReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendBotMessageReqDescriptor = $convert
    .base64Decode('ChFTZW5kQm90TWVzc2FnZVJlcRIYCgdhZ2VudElEGAEgASgJUgdhZ2VudElEEiYKDmNvbnZlcn'
        'NhdGlvbklEGAIgASgJUg5jb252ZXJzYXRpb25JRBIgCgtjb250ZW50VHlwZRgDIAEoBVILY29u'
        'dGVudFR5cGUSGAoHY29udGVudBgEIAEoCVIHY29udGVudBIOCgJleBgFIAEoCVICZXgSEAoDa2'
        'V5GAYgASgJUgNrZXk=');

@$core.Deprecated('Use sendBotMessageRespDescriptor instead')
const SendBotMessageResp$json = {
  '1': 'SendBotMessageResp',
};

/// Descriptor for `SendBotMessageResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendBotMessageRespDescriptor =
    $convert.base64Decode('ChJTZW5kQm90TWVzc2FnZVJlc3A=');

const $core.Map<$core.String, $core.dynamic> botServiceBase$json = {
  '1': 'bot',
  '2': [
    {'1': 'CreateAgent', '2': '.openim.bot.CreateAgentReq', '3': '.openim.bot.CreateAgentResp'},
    {'1': 'UpdateAgent', '2': '.openim.bot.UpdateAgentReq', '3': '.openim.bot.UpdateAgentResp'},
    {
      '1': 'PageFindAgent',
      '2': '.openim.bot.PageFindAgentReq',
      '3': '.openim.bot.PageFindAgentResp'
    },
    {'1': 'DeleteAgent', '2': '.openim.bot.DeleteAgentReq', '3': '.openim.bot.DeleteAgentResp'},
    {
      '1': 'SendBotMessage',
      '2': '.openim.bot.SendBotMessageReq',
      '3': '.openim.bot.SendBotMessageResp'
    },
  ],
};

@$core.Deprecated('Use botServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> botServiceBase$messageJson = {
  '.openim.bot.CreateAgentReq': CreateAgentReq$json,
  '.openim.bot.Agent': Agent$json,
  '.openim.bot.CreateAgentResp': CreateAgentResp$json,
  '.openim.bot.UpdateAgentReq': UpdateAgentReq$json,
  '.openim.bot.UpdateAgentResp': UpdateAgentResp$json,
  '.openim.bot.PageFindAgentReq': PageFindAgentReq$json,
  '.openim.sdkws.RequestPagination': $0.RequestPagination$json,
  '.openim.bot.PageFindAgentResp': PageFindAgentResp$json,
  '.openim.bot.DeleteAgentReq': DeleteAgentReq$json,
  '.openim.bot.DeleteAgentResp': DeleteAgentResp$json,
  '.openim.bot.SendBotMessageReq': SendBotMessageReq$json,
  '.openim.bot.SendBotMessageResp': SendBotMessageResp$json,
};

/// Descriptor for `bot`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List botServiceDescriptor = $convert
    .base64Decode('CgNib3QSRgoLQ3JlYXRlQWdlbnQSGi5vcGVuaW0uYm90LkNyZWF0ZUFnZW50UmVxGhsub3Blbm'
        'ltLmJvdC5DcmVhdGVBZ2VudFJlc3ASRgoLVXBkYXRlQWdlbnQSGi5vcGVuaW0uYm90LlVwZGF0'
        'ZUFnZW50UmVxGhsub3BlbmltLmJvdC5VcGRhdGVBZ2VudFJlc3ASTAoNUGFnZUZpbmRBZ2VudB'
        'IcLm9wZW5pbS5ib3QuUGFnZUZpbmRBZ2VudFJlcRodLm9wZW5pbS5ib3QuUGFnZUZpbmRBZ2Vu'
        'dFJlc3ASRgoLRGVsZXRlQWdlbnQSGi5vcGVuaW0uYm90LkRlbGV0ZUFnZW50UmVxGhsub3Blbm'
        'ltLmJvdC5EZWxldGVBZ2VudFJlc3ASTwoOU2VuZEJvdE1lc3NhZ2USHS5vcGVuaW0uYm90LlNl'
        'bmRCb3RNZXNzYWdlUmVxGh4ub3BlbmltLmJvdC5TZW5kQm90TWVzc2FnZVJlc3A=');
