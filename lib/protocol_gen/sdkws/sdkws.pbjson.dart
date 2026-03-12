// This is a generated file - do not edit.
//
// Generated from sdkws/sdkws.proto.

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

@$core.Deprecated('Use pullOrderDescriptor instead')
const PullOrder$json = {
  '1': 'PullOrder',
  '2': [
    {'1': 'PullOrderAsc', '2': 0},
    {'1': 'PullOrderDesc', '2': 1},
  ],
};

/// Descriptor for `PullOrder`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pullOrderDescriptor = $convert.base64Decode(
    'CglQdWxsT3JkZXISEAoMUHVsbE9yZGVyQXNjEAASEQoNUHVsbE9yZGVyRGVzYxAB');

@$core.Deprecated('Use groupInfoDescriptor instead')
const GroupInfo$json = {
  '1': 'GroupInfo',
  '2': [
    {'1': 'groupID', '3': 1, '4': 1, '5': 9, '10': 'groupID'},
    {'1': 'groupName', '3': 2, '4': 1, '5': 9, '10': 'groupName'},
    {'1': 'notification', '3': 3, '4': 1, '5': 9, '10': 'notification'},
    {'1': 'introduction', '3': 4, '4': 1, '5': 9, '10': 'introduction'},
    {'1': 'faceURL', '3': 5, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'ownerUserID', '3': 6, '4': 1, '5': 9, '10': 'ownerUserID'},
    {'1': 'createTime', '3': 7, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'memberCount', '3': 8, '4': 1, '5': 13, '10': 'memberCount'},
    {'1': 'ex', '3': 9, '4': 1, '5': 9, '10': 'ex'},
    {'1': 'status', '3': 10, '4': 1, '5': 5, '10': 'status'},
    {'1': 'creatorUserID', '3': 11, '4': 1, '5': 9, '10': 'creatorUserID'},
    {'1': 'groupType', '3': 12, '4': 1, '5': 5, '10': 'groupType'},
    {
      '1': 'needVerification',
      '3': 13,
      '4': 1,
      '5': 5,
      '10': 'needVerification'
    },
    {'1': 'lookMemberInfo', '3': 14, '4': 1, '5': 5, '10': 'lookMemberInfo'},
    {
      '1': 'applyMemberFriend',
      '3': 15,
      '4': 1,
      '5': 5,
      '10': 'applyMemberFriend'
    },
    {
      '1': 'notificationUpdateTime',
      '3': 16,
      '4': 1,
      '5': 3,
      '10': 'notificationUpdateTime'
    },
    {
      '1': 'notificationUserID',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'notificationUserID'
    },
  ],
};

/// Descriptor for `GroupInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupInfoDescriptor = $convert.base64Decode(
    'CglHcm91cEluZm8SGAoHZ3JvdXBJRBgBIAEoCVIHZ3JvdXBJRBIcCglncm91cE5hbWUYAiABKA'
    'lSCWdyb3VwTmFtZRIiCgxub3RpZmljYXRpb24YAyABKAlSDG5vdGlmaWNhdGlvbhIiCgxpbnRy'
    'b2R1Y3Rpb24YBCABKAlSDGludHJvZHVjdGlvbhIYCgdmYWNlVVJMGAUgASgJUgdmYWNlVVJMEi'
    'AKC293bmVyVXNlcklEGAYgASgJUgtvd25lclVzZXJJRBIeCgpjcmVhdGVUaW1lGAcgASgDUgpj'
    'cmVhdGVUaW1lEiAKC21lbWJlckNvdW50GAggASgNUgttZW1iZXJDb3VudBIOCgJleBgJIAEoCV'
    'ICZXgSFgoGc3RhdHVzGAogASgFUgZzdGF0dXMSJAoNY3JlYXRvclVzZXJJRBgLIAEoCVINY3Jl'
    'YXRvclVzZXJJRBIcCglncm91cFR5cGUYDCABKAVSCWdyb3VwVHlwZRIqChBuZWVkVmVyaWZpY2'
    'F0aW9uGA0gASgFUhBuZWVkVmVyaWZpY2F0aW9uEiYKDmxvb2tNZW1iZXJJbmZvGA4gASgFUg5s'
    'b29rTWVtYmVySW5mbxIsChFhcHBseU1lbWJlckZyaWVuZBgPIAEoBVIRYXBwbHlNZW1iZXJGcm'
    'llbmQSNgoWbm90aWZpY2F0aW9uVXBkYXRlVGltZRgQIAEoA1IWbm90aWZpY2F0aW9uVXBkYXRl'
    'VGltZRIuChJub3RpZmljYXRpb25Vc2VySUQYESABKAlSEm5vdGlmaWNhdGlvblVzZXJJRA==');

@$core.Deprecated('Use groupInfoForSetDescriptor instead')
const GroupInfoForSet$json = {
  '1': 'GroupInfoForSet',
  '2': [
    {'1': 'groupID', '3': 1, '4': 1, '5': 9, '10': 'groupID'},
    {'1': 'groupName', '3': 2, '4': 1, '5': 9, '10': 'groupName'},
    {'1': 'notification', '3': 3, '4': 1, '5': 9, '10': 'notification'},
    {'1': 'introduction', '3': 4, '4': 1, '5': 9, '10': 'introduction'},
    {'1': 'faceURL', '3': 5, '4': 1, '5': 9, '10': 'faceURL'},
    {
      '1': 'ex',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'ex'
    },
    {
      '1': 'needVerification',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'needVerification'
    },
    {
      '1': 'lookMemberInfo',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'lookMemberInfo'
    },
    {
      '1': 'applyMemberFriend',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'applyMemberFriend'
    },
  ],
};

/// Descriptor for `GroupInfoForSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupInfoForSetDescriptor = $convert.base64Decode(
    'Cg9Hcm91cEluZm9Gb3JTZXQSGAoHZ3JvdXBJRBgBIAEoCVIHZ3JvdXBJRBIcCglncm91cE5hbW'
    'UYAiABKAlSCWdyb3VwTmFtZRIiCgxub3RpZmljYXRpb24YAyABKAlSDG5vdGlmaWNhdGlvbhIi'
    'CgxpbnRyb2R1Y3Rpb24YBCABKAlSDGludHJvZHVjdGlvbhIYCgdmYWNlVVJMGAUgASgJUgdmYW'
    'NlVVJMEiwKAmV4GAYgASgLMhwub3BlbmltLnByb3RvYnVmLlN0cmluZ1ZhbHVlUgJleBJHChBu'
    'ZWVkVmVyaWZpY2F0aW9uGAcgASgLMhsub3BlbmltLnByb3RvYnVmLkludDMyVmFsdWVSEG5lZW'
    'RWZXJpZmljYXRpb24SQwoObG9va01lbWJlckluZm8YCCABKAsyGy5vcGVuaW0ucHJvdG9idWYu'
    'SW50MzJWYWx1ZVIObG9va01lbWJlckluZm8SSQoRYXBwbHlNZW1iZXJGcmllbmQYCSABKAsyGy'
    '5vcGVuaW0ucHJvdG9idWYuSW50MzJWYWx1ZVIRYXBwbHlNZW1iZXJGcmllbmQ=');

@$core.Deprecated('Use groupMemberFullInfoDescriptor instead')
const GroupMemberFullInfo$json = {
  '1': 'GroupMemberFullInfo',
  '2': [
    {'1': 'groupID', '3': 1, '4': 1, '5': 9, '10': 'groupID'},
    {'1': 'userID', '3': 2, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'roleLevel', '3': 3, '4': 1, '5': 5, '10': 'roleLevel'},
    {'1': 'joinTime', '3': 4, '4': 1, '5': 3, '10': 'joinTime'},
    {'1': 'nickname', '3': 5, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'faceURL', '3': 6, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'appMangerLevel', '3': 7, '4': 1, '5': 5, '10': 'appMangerLevel'},
    {'1': 'joinSource', '3': 8, '4': 1, '5': 5, '10': 'joinSource'},
    {'1': 'operatorUserID', '3': 9, '4': 1, '5': 9, '10': 'operatorUserID'},
    {'1': 'ex', '3': 10, '4': 1, '5': 9, '10': 'ex'},
    {'1': 'muteEndTime', '3': 11, '4': 1, '5': 3, '10': 'muteEndTime'},
    {'1': 'inviterUserID', '3': 12, '4': 1, '5': 9, '10': 'inviterUserID'},
  ],
};

/// Descriptor for `GroupMemberFullInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupMemberFullInfoDescriptor = $convert.base64Decode(
    'ChNHcm91cE1lbWJlckZ1bGxJbmZvEhgKB2dyb3VwSUQYASABKAlSB2dyb3VwSUQSFgoGdXNlck'
    'lEGAIgASgJUgZ1c2VySUQSHAoJcm9sZUxldmVsGAMgASgFUglyb2xlTGV2ZWwSGgoIam9pblRp'
    'bWUYBCABKANSCGpvaW5UaW1lEhoKCG5pY2tuYW1lGAUgASgJUghuaWNrbmFtZRIYCgdmYWNlVV'
    'JMGAYgASgJUgdmYWNlVVJMEiYKDmFwcE1hbmdlckxldmVsGAcgASgFUg5hcHBNYW5nZXJMZXZl'
    'bBIeCgpqb2luU291cmNlGAggASgFUgpqb2luU291cmNlEiYKDm9wZXJhdG9yVXNlcklEGAkgAS'
    'gJUg5vcGVyYXRvclVzZXJJRBIOCgJleBgKIAEoCVICZXgSIAoLbXV0ZUVuZFRpbWUYCyABKANS'
    'C211dGVFbmRUaW1lEiQKDWludml0ZXJVc2VySUQYDCABKAlSDWludml0ZXJVc2VySUQ=');

@$core.Deprecated('Use publicUserInfoDescriptor instead')
const PublicUserInfo$json = {
  '1': 'PublicUserInfo',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'nickname', '3': 2, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'faceURL', '3': 3, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'ex', '3': 4, '4': 1, '5': 9, '10': 'ex'},
  ],
};

/// Descriptor for `PublicUserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publicUserInfoDescriptor = $convert.base64Decode(
    'Cg5QdWJsaWNVc2VySW5mbxIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBIaCghuaWNrbmFtZRgCIA'
    'EoCVIIbmlja25hbWUSGAoHZmFjZVVSTBgDIAEoCVIHZmFjZVVSTBIOCgJleBgEIAEoCVICZXg=');

@$core.Deprecated('Use userInfoDescriptor instead')
const UserInfo$json = {
  '1': 'UserInfo',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'nickname', '3': 2, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'faceURL', '3': 3, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'ex', '3': 4, '4': 1, '5': 9, '10': 'ex'},
    {'1': 'createTime', '3': 5, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'appMangerLevel', '3': 6, '4': 1, '5': 5, '10': 'appMangerLevel'},
    {'1': 'globalRecvMsgOpt', '3': 7, '4': 1, '5': 5, '10': 'globalRecvMsgOpt'},
  ],
};

/// Descriptor for `UserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoDescriptor = $convert.base64Decode(
    'CghVc2VySW5mbxIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBIaCghuaWNrbmFtZRgCIAEoCVIIbm'
    'lja25hbWUSGAoHZmFjZVVSTBgDIAEoCVIHZmFjZVVSTBIOCgJleBgEIAEoCVICZXgSHgoKY3Jl'
    'YXRlVGltZRgFIAEoA1IKY3JlYXRlVGltZRImCg5hcHBNYW5nZXJMZXZlbBgGIAEoBVIOYXBwTW'
    'FuZ2VyTGV2ZWwSKgoQZ2xvYmFsUmVjdk1zZ09wdBgHIAEoBVIQZ2xvYmFsUmVjdk1zZ09wdA==');

@$core.Deprecated('Use userInfoWithExDescriptor instead')
const UserInfoWithEx$json = {
  '1': 'UserInfoWithEx',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {
      '1': 'nickname',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'nickname'
    },
    {
      '1': 'faceURL',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'faceURL'
    },
    {
      '1': 'ex',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'ex'
    },
    {
      '1': 'globalRecvMsgOpt',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'globalRecvMsgOpt'
    },
  ],
};

/// Descriptor for `UserInfoWithEx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoWithExDescriptor = $convert.base64Decode(
    'Cg5Vc2VySW5mb1dpdGhFeBIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBI4CghuaWNrbmFtZRgCIA'
    'EoCzIcLm9wZW5pbS5wcm90b2J1Zi5TdHJpbmdWYWx1ZVIIbmlja25hbWUSNgoHZmFjZVVSTBgD'
    'IAEoCzIcLm9wZW5pbS5wcm90b2J1Zi5TdHJpbmdWYWx1ZVIHZmFjZVVSTBIsCgJleBgEIAEoCz'
    'IcLm9wZW5pbS5wcm90b2J1Zi5TdHJpbmdWYWx1ZVICZXgSRwoQZ2xvYmFsUmVjdk1zZ09wdBgH'
    'IAEoCzIbLm9wZW5pbS5wcm90b2J1Zi5JbnQzMlZhbHVlUhBnbG9iYWxSZWN2TXNnT3B0');

@$core.Deprecated('Use friendInfoDescriptor instead')
const FriendInfo$json = {
  '1': 'FriendInfo',
  '2': [
    {'1': 'ownerUserID', '3': 1, '4': 1, '5': 9, '10': 'ownerUserID'},
    {'1': 'remark', '3': 2, '4': 1, '5': 9, '10': 'remark'},
    {'1': 'createTime', '3': 3, '4': 1, '5': 3, '10': 'createTime'},
    {
      '1': 'friendUser',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.UserInfo',
      '10': 'friendUser'
    },
    {'1': 'addSource', '3': 5, '4': 1, '5': 5, '10': 'addSource'},
    {'1': 'operatorUserID', '3': 6, '4': 1, '5': 9, '10': 'operatorUserID'},
    {'1': 'ex', '3': 7, '4': 1, '5': 9, '10': 'ex'},
    {'1': 'isPinned', '3': 8, '4': 1, '5': 8, '10': 'isPinned'},
  ],
};

/// Descriptor for `FriendInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendInfoDescriptor = $convert.base64Decode(
    'CgpGcmllbmRJbmZvEiAKC293bmVyVXNlcklEGAEgASgJUgtvd25lclVzZXJJRBIWCgZyZW1hcm'
    'sYAiABKAlSBnJlbWFyaxIeCgpjcmVhdGVUaW1lGAMgASgDUgpjcmVhdGVUaW1lEjYKCmZyaWVu'
    'ZFVzZXIYBCABKAsyFi5vcGVuaW0uc2Rrd3MuVXNlckluZm9SCmZyaWVuZFVzZXISHAoJYWRkU2'
    '91cmNlGAUgASgFUglhZGRTb3VyY2USJgoOb3BlcmF0b3JVc2VySUQYBiABKAlSDm9wZXJhdG9y'
    'VXNlcklEEg4KAmV4GAcgASgJUgJleBIaCghpc1Bpbm5lZBgIIAEoCFIIaXNQaW5uZWQ=');

@$core.Deprecated('Use blackInfoDescriptor instead')
const BlackInfo$json = {
  '1': 'BlackInfo',
  '2': [
    {'1': 'ownerUserID', '3': 1, '4': 1, '5': 9, '10': 'ownerUserID'},
    {'1': 'createTime', '3': 2, '4': 1, '5': 3, '10': 'createTime'},
    {
      '1': 'blackUserInfo',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.PublicUserInfo',
      '10': 'blackUserInfo'
    },
    {'1': 'addSource', '3': 4, '4': 1, '5': 5, '10': 'addSource'},
    {'1': 'operatorUserID', '3': 5, '4': 1, '5': 9, '10': 'operatorUserID'},
    {'1': 'ex', '3': 6, '4': 1, '5': 9, '10': 'ex'},
  ],
};

/// Descriptor for `BlackInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blackInfoDescriptor = $convert.base64Decode(
    'CglCbGFja0luZm8SIAoLb3duZXJVc2VySUQYASABKAlSC293bmVyVXNlcklEEh4KCmNyZWF0ZV'
    'RpbWUYAiABKANSCmNyZWF0ZVRpbWUSQgoNYmxhY2tVc2VySW5mbxgDIAEoCzIcLm9wZW5pbS5z'
    'ZGt3cy5QdWJsaWNVc2VySW5mb1INYmxhY2tVc2VySW5mbxIcCglhZGRTb3VyY2UYBCABKAVSCW'
    'FkZFNvdXJjZRImCg5vcGVyYXRvclVzZXJJRBgFIAEoCVIOb3BlcmF0b3JVc2VySUQSDgoCZXgY'
    'BiABKAlSAmV4');

@$core.Deprecated('Use groupRequestDescriptor instead')
const GroupRequest$json = {
  '1': 'GroupRequest',
  '2': [
    {
      '1': 'userInfo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.PublicUserInfo',
      '10': 'userInfo'
    },
    {
      '1': 'groupInfo',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'groupInfo'
    },
    {'1': 'handleResult', '3': 3, '4': 1, '5': 5, '10': 'handleResult'},
    {'1': 'reqMsg', '3': 4, '4': 1, '5': 9, '10': 'reqMsg'},
    {'1': 'handleMsg', '3': 5, '4': 1, '5': 9, '10': 'handleMsg'},
    {'1': 'reqTime', '3': 6, '4': 1, '5': 3, '10': 'reqTime'},
    {'1': 'handleUserID', '3': 7, '4': 1, '5': 9, '10': 'handleUserID'},
    {'1': 'handleTime', '3': 8, '4': 1, '5': 3, '10': 'handleTime'},
    {'1': 'ex', '3': 9, '4': 1, '5': 9, '10': 'ex'},
    {'1': 'joinSource', '3': 10, '4': 1, '5': 5, '10': 'joinSource'},
    {'1': 'inviterUserID', '3': 11, '4': 1, '5': 9, '10': 'inviterUserID'},
  ],
};

/// Descriptor for `GroupRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupRequestDescriptor = $convert.base64Decode(
    'CgxHcm91cFJlcXVlc3QSOAoIdXNlckluZm8YASABKAsyHC5vcGVuaW0uc2Rrd3MuUHVibGljVX'
    'NlckluZm9SCHVzZXJJbmZvEjUKCWdyb3VwSW5mbxgCIAEoCzIXLm9wZW5pbS5zZGt3cy5Hcm91'
    'cEluZm9SCWdyb3VwSW5mbxIiCgxoYW5kbGVSZXN1bHQYAyABKAVSDGhhbmRsZVJlc3VsdBIWCg'
    'ZyZXFNc2cYBCABKAlSBnJlcU1zZxIcCgloYW5kbGVNc2cYBSABKAlSCWhhbmRsZU1zZxIYCgdy'
    'ZXFUaW1lGAYgASgDUgdyZXFUaW1lEiIKDGhhbmRsZVVzZXJJRBgHIAEoCVIMaGFuZGxlVXNlck'
    'lEEh4KCmhhbmRsZVRpbWUYCCABKANSCmhhbmRsZVRpbWUSDgoCZXgYCSABKAlSAmV4Eh4KCmpv'
    'aW5Tb3VyY2UYCiABKAVSCmpvaW5Tb3VyY2USJAoNaW52aXRlclVzZXJJRBgLIAEoCVINaW52aX'
    'RlclVzZXJJRA==');

@$core.Deprecated('Use friendRequestDescriptor instead')
const FriendRequest$json = {
  '1': 'FriendRequest',
  '2': [
    {'1': 'fromUserID', '3': 1, '4': 1, '5': 9, '10': 'fromUserID'},
    {'1': 'fromNickname', '3': 2, '4': 1, '5': 9, '10': 'fromNickname'},
    {'1': 'fromFaceURL', '3': 3, '4': 1, '5': 9, '10': 'fromFaceURL'},
    {'1': 'toUserID', '3': 4, '4': 1, '5': 9, '10': 'toUserID'},
    {'1': 'toNickname', '3': 5, '4': 1, '5': 9, '10': 'toNickname'},
    {'1': 'toFaceURL', '3': 6, '4': 1, '5': 9, '10': 'toFaceURL'},
    {'1': 'handleResult', '3': 7, '4': 1, '5': 5, '10': 'handleResult'},
    {'1': 'reqMsg', '3': 8, '4': 1, '5': 9, '10': 'reqMsg'},
    {'1': 'createTime', '3': 9, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'handlerUserID', '3': 10, '4': 1, '5': 9, '10': 'handlerUserID'},
    {'1': 'handleMsg', '3': 11, '4': 1, '5': 9, '10': 'handleMsg'},
    {'1': 'handleTime', '3': 12, '4': 1, '5': 3, '10': 'handleTime'},
    {'1': 'ex', '3': 13, '4': 1, '5': 9, '10': 'ex'},
  ],
};

/// Descriptor for `FriendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendRequestDescriptor = $convert.base64Decode(
    'Cg1GcmllbmRSZXF1ZXN0Eh4KCmZyb21Vc2VySUQYASABKAlSCmZyb21Vc2VySUQSIgoMZnJvbU'
    '5pY2tuYW1lGAIgASgJUgxmcm9tTmlja25hbWUSIAoLZnJvbUZhY2VVUkwYAyABKAlSC2Zyb21G'
    'YWNlVVJMEhoKCHRvVXNlcklEGAQgASgJUgh0b1VzZXJJRBIeCgp0b05pY2tuYW1lGAUgASgJUg'
    'p0b05pY2tuYW1lEhwKCXRvRmFjZVVSTBgGIAEoCVIJdG9GYWNlVVJMEiIKDGhhbmRsZVJlc3Vs'
    'dBgHIAEoBVIMaGFuZGxlUmVzdWx0EhYKBnJlcU1zZxgIIAEoCVIGcmVxTXNnEh4KCmNyZWF0ZV'
    'RpbWUYCSABKANSCmNyZWF0ZVRpbWUSJAoNaGFuZGxlclVzZXJJRBgKIAEoCVINaGFuZGxlclVz'
    'ZXJJRBIcCgloYW5kbGVNc2cYCyABKAlSCWhhbmRsZU1zZxIeCgpoYW5kbGVUaW1lGAwgASgDUg'
    'poYW5kbGVUaW1lEg4KAmV4GA0gASgJUgJleA==');

@$core.Deprecated('Use pullMessageBySeqsReqDescriptor instead')
const PullMessageBySeqsReq$json = {
  '1': 'PullMessageBySeqsReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {
      '1': 'seqRanges',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.SeqRange',
      '10': 'seqRanges'
    },
    {
      '1': 'order',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.openim.sdkws.PullOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `PullMessageBySeqsReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullMessageBySeqsReqDescriptor = $convert.base64Decode(
    'ChRQdWxsTWVzc2FnZUJ5U2Vxc1JlcRIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBI0CglzZXFSYW'
    '5nZXMYAiADKAsyFi5vcGVuaW0uc2Rrd3MuU2VxUmFuZ2VSCXNlcVJhbmdlcxItCgVvcmRlchgD'
    'IAEoDjIXLm9wZW5pbS5zZGt3cy5QdWxsT3JkZXJSBW9yZGVy');

@$core.Deprecated('Use seqRangeDescriptor instead')
const SeqRange$json = {
  '1': 'SeqRange',
  '2': [
    {'1': 'conversationID', '3': 1, '4': 1, '5': 9, '10': 'conversationID'},
    {'1': 'begin', '3': 2, '4': 1, '5': 3, '10': 'begin'},
    {'1': 'end', '3': 3, '4': 1, '5': 3, '10': 'end'},
    {'1': 'num', '3': 4, '4': 1, '5': 3, '10': 'num'},
  ],
};

/// Descriptor for `SeqRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seqRangeDescriptor = $convert.base64Decode(
    'CghTZXFSYW5nZRImCg5jb252ZXJzYXRpb25JRBgBIAEoCVIOY29udmVyc2F0aW9uSUQSFAoFYm'
    'VnaW4YAiABKANSBWJlZ2luEhAKA2VuZBgDIAEoA1IDZW5kEhAKA251bRgEIAEoA1IDbnVt');

@$core.Deprecated('Use pullMsgsDescriptor instead')
const PullMsgs$json = {
  '1': 'PullMsgs',
  '2': [
    {
      '1': 'Msgs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.MsgData',
      '10': 'Msgs'
    },
    {'1': 'isEnd', '3': 2, '4': 1, '5': 8, '10': 'isEnd'},
  ],
};

/// Descriptor for `PullMsgs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullMsgsDescriptor = $convert.base64Decode(
    'CghQdWxsTXNncxIpCgRNc2dzGAEgAygLMhUub3BlbmltLnNka3dzLk1zZ0RhdGFSBE1zZ3MSFA'
    'oFaXNFbmQYAiABKAhSBWlzRW5k');

@$core.Deprecated('Use pullMessageBySeqsRespDescriptor instead')
const PullMessageBySeqsResp$json = {
  '1': 'PullMessageBySeqsResp',
  '2': [
    {
      '1': 'msgs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.PullMessageBySeqsResp.MsgsEntry',
      '10': 'msgs'
    },
    {
      '1': 'notificationMsgs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.PullMessageBySeqsResp.NotificationMsgsEntry',
      '10': 'notificationMsgs'
    },
  ],
  '3': [
    PullMessageBySeqsResp_MsgsEntry$json,
    PullMessageBySeqsResp_NotificationMsgsEntry$json
  ],
};

@$core.Deprecated('Use pullMessageBySeqsRespDescriptor instead')
const PullMessageBySeqsResp_MsgsEntry$json = {
  '1': 'MsgsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.PullMsgs',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use pullMessageBySeqsRespDescriptor instead')
const PullMessageBySeqsResp_NotificationMsgsEntry$json = {
  '1': 'NotificationMsgsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.PullMsgs',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `PullMessageBySeqsResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pullMessageBySeqsRespDescriptor = $convert.base64Decode(
    'ChVQdWxsTWVzc2FnZUJ5U2Vxc1Jlc3ASQQoEbXNncxgBIAMoCzItLm9wZW5pbS5zZGt3cy5QdW'
    'xsTWVzc2FnZUJ5U2Vxc1Jlc3AuTXNnc0VudHJ5UgRtc2dzEmUKEG5vdGlmaWNhdGlvbk1zZ3MY'
    'AiADKAsyOS5vcGVuaW0uc2Rrd3MuUHVsbE1lc3NhZ2VCeVNlcXNSZXNwLk5vdGlmaWNhdGlvbk'
    '1zZ3NFbnRyeVIQbm90aWZpY2F0aW9uTXNncxpPCglNc2dzRW50cnkSEAoDa2V5GAEgASgJUgNr'
    'ZXkSLAoFdmFsdWUYAiABKAsyFi5vcGVuaW0uc2Rrd3MuUHVsbE1zZ3NSBXZhbHVlOgI4ARpbCh'
    'VOb3RpZmljYXRpb25Nc2dzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSLAoFdmFsdWUYAiABKAsy'
    'Fi5vcGVuaW0uc2Rrd3MuUHVsbE1zZ3NSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use getMaxSeqReqDescriptor instead')
const GetMaxSeqReq$json = {
  '1': 'GetMaxSeqReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
  ],
};

/// Descriptor for `GetMaxSeqReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMaxSeqReqDescriptor = $convert
    .base64Decode('CgxHZXRNYXhTZXFSZXESFgoGdXNlcklEGAEgASgJUgZ1c2VySUQ=');

@$core.Deprecated('Use getMaxSeqRespDescriptor instead')
const GetMaxSeqResp$json = {
  '1': 'GetMaxSeqResp',
  '2': [
    {
      '1': 'maxSeqs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.GetMaxSeqResp.MaxSeqsEntry',
      '10': 'maxSeqs'
    },
    {
      '1': 'minSeqs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.GetMaxSeqResp.MinSeqsEntry',
      '10': 'minSeqs'
    },
  ],
  '3': [GetMaxSeqResp_MaxSeqsEntry$json, GetMaxSeqResp_MinSeqsEntry$json],
};

@$core.Deprecated('Use getMaxSeqRespDescriptor instead')
const GetMaxSeqResp_MaxSeqsEntry$json = {
  '1': 'MaxSeqsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use getMaxSeqRespDescriptor instead')
const GetMaxSeqResp_MinSeqsEntry$json = {
  '1': 'MinSeqsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `GetMaxSeqResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMaxSeqRespDescriptor = $convert.base64Decode(
    'Cg1HZXRNYXhTZXFSZXNwEkIKB21heFNlcXMYASADKAsyKC5vcGVuaW0uc2Rrd3MuR2V0TWF4U2'
    'VxUmVzcC5NYXhTZXFzRW50cnlSB21heFNlcXMSQgoHbWluU2VxcxgCIAMoCzIoLm9wZW5pbS5z'
    'ZGt3cy5HZXRNYXhTZXFSZXNwLk1pblNlcXNFbnRyeVIHbWluU2Vxcxo6CgxNYXhTZXFzRW50cn'
    'kSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKANSBXZhbHVlOgI4ARo6CgxNaW5TZXFz'
    'RW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKANSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use userSendMsgRespDescriptor instead')
const UserSendMsgResp$json = {
  '1': 'UserSendMsgResp',
  '2': [
    {'1': 'serverMsgID', '3': 1, '4': 1, '5': 9, '10': 'serverMsgID'},
    {'1': 'clientMsgID', '3': 2, '4': 1, '5': 9, '10': 'clientMsgID'},
    {'1': 'sendTime', '3': 3, '4': 1, '5': 3, '10': 'sendTime'},
  ],
};

/// Descriptor for `UserSendMsgResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userSendMsgRespDescriptor = $convert.base64Decode(
    'Cg9Vc2VyU2VuZE1zZ1Jlc3ASIAoLc2VydmVyTXNnSUQYASABKAlSC3NlcnZlck1zZ0lEEiAKC2'
    'NsaWVudE1zZ0lEGAIgASgJUgtjbGllbnRNc2dJRBIaCghzZW5kVGltZRgDIAEoA1IIc2VuZFRp'
    'bWU=');

@$core.Deprecated('Use msgDataDescriptor instead')
const MsgData$json = {
  '1': 'MsgData',
  '2': [
    {'1': 'sendID', '3': 1, '4': 1, '5': 9, '10': 'sendID'},
    {'1': 'recvID', '3': 2, '4': 1, '5': 9, '10': 'recvID'},
    {'1': 'groupID', '3': 3, '4': 1, '5': 9, '10': 'groupID'},
    {'1': 'clientMsgID', '3': 4, '4': 1, '5': 9, '10': 'clientMsgID'},
    {'1': 'serverMsgID', '3': 5, '4': 1, '5': 9, '10': 'serverMsgID'},
    {'1': 'senderPlatformID', '3': 6, '4': 1, '5': 5, '10': 'senderPlatformID'},
    {'1': 'senderNickname', '3': 7, '4': 1, '5': 9, '10': 'senderNickname'},
    {'1': 'senderFaceURL', '3': 8, '4': 1, '5': 9, '10': 'senderFaceURL'},
    {'1': 'sessionType', '3': 9, '4': 1, '5': 5, '10': 'sessionType'},
    {'1': 'msgFrom', '3': 10, '4': 1, '5': 5, '10': 'msgFrom'},
    {'1': 'contentType', '3': 11, '4': 1, '5': 5, '10': 'contentType'},
    {'1': 'content', '3': 12, '4': 1, '5': 12, '10': 'content'},
    {'1': 'seq', '3': 14, '4': 1, '5': 3, '10': 'seq'},
    {'1': 'sendTime', '3': 15, '4': 1, '5': 3, '10': 'sendTime'},
    {'1': 'createTime', '3': 16, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'status', '3': 17, '4': 1, '5': 5, '10': 'status'},
    {'1': 'isRead', '3': 18, '4': 1, '5': 8, '10': 'isRead'},
    {
      '1': 'options',
      '3': 19,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.MsgData.OptionsEntry',
      '10': 'options'
    },
    {
      '1': 'offlinePushInfo',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.OfflinePushInfo',
      '10': 'offlinePushInfo'
    },
    {'1': 'atUserIDList', '3': 21, '4': 3, '5': 9, '10': 'atUserIDList'},
    {'1': 'attachedInfo', '3': 22, '4': 1, '5': 9, '10': 'attachedInfo'},
    {'1': 'ex', '3': 23, '4': 1, '5': 9, '10': 'ex'},
  ],
  '3': [MsgData_OptionsEntry$json],
};

@$core.Deprecated('Use msgDataDescriptor instead')
const MsgData_OptionsEntry$json = {
  '1': 'OptionsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 8, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `MsgData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgDataDescriptor = $convert.base64Decode(
    'CgdNc2dEYXRhEhYKBnNlbmRJRBgBIAEoCVIGc2VuZElEEhYKBnJlY3ZJRBgCIAEoCVIGcmVjdk'
    'lEEhgKB2dyb3VwSUQYAyABKAlSB2dyb3VwSUQSIAoLY2xpZW50TXNnSUQYBCABKAlSC2NsaWVu'
    'dE1zZ0lEEiAKC3NlcnZlck1zZ0lEGAUgASgJUgtzZXJ2ZXJNc2dJRBIqChBzZW5kZXJQbGF0Zm'
    '9ybUlEGAYgASgFUhBzZW5kZXJQbGF0Zm9ybUlEEiYKDnNlbmRlck5pY2tuYW1lGAcgASgJUg5z'
    'ZW5kZXJOaWNrbmFtZRIkCg1zZW5kZXJGYWNlVVJMGAggASgJUg1zZW5kZXJGYWNlVVJMEiAKC3'
    'Nlc3Npb25UeXBlGAkgASgFUgtzZXNzaW9uVHlwZRIYCgdtc2dGcm9tGAogASgFUgdtc2dGcm9t'
    'EiAKC2NvbnRlbnRUeXBlGAsgASgFUgtjb250ZW50VHlwZRIYCgdjb250ZW50GAwgASgMUgdjb2'
    '50ZW50EhAKA3NlcRgOIAEoA1IDc2VxEhoKCHNlbmRUaW1lGA8gASgDUghzZW5kVGltZRIeCgpj'
    'cmVhdGVUaW1lGBAgASgDUgpjcmVhdGVUaW1lEhYKBnN0YXR1cxgRIAEoBVIGc3RhdHVzEhYKBm'
    'lzUmVhZBgSIAEoCFIGaXNSZWFkEjwKB29wdGlvbnMYEyADKAsyIi5vcGVuaW0uc2Rrd3MuTXNn'
    'RGF0YS5PcHRpb25zRW50cnlSB29wdGlvbnMSRwoPb2ZmbGluZVB1c2hJbmZvGBQgASgLMh0ub3'
    'BlbmltLnNka3dzLk9mZmxpbmVQdXNoSW5mb1IPb2ZmbGluZVB1c2hJbmZvEiIKDGF0VXNlcklE'
    'TGlzdBgVIAMoCVIMYXRVc2VySURMaXN0EiIKDGF0dGFjaGVkSW5mbxgWIAEoCVIMYXR0YWNoZW'
    'RJbmZvEg4KAmV4GBcgASgJUgJleBo6CgxPcHRpb25zRW50cnkSEAoDa2V5GAEgASgJUgNrZXkS'
    'FAoFdmFsdWUYAiABKAhSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use pushMessagesDescriptor instead')
const PushMessages$json = {
  '1': 'PushMessages',
  '2': [
    {
      '1': 'msgs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.PushMessages.MsgsEntry',
      '10': 'msgs'
    },
    {
      '1': 'notificationMsgs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.PushMessages.NotificationMsgsEntry',
      '10': 'notificationMsgs'
    },
  ],
  '3': [PushMessages_MsgsEntry$json, PushMessages_NotificationMsgsEntry$json],
};

@$core.Deprecated('Use pushMessagesDescriptor instead')
const PushMessages_MsgsEntry$json = {
  '1': 'MsgsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.PullMsgs',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use pushMessagesDescriptor instead')
const PushMessages_NotificationMsgsEntry$json = {
  '1': 'NotificationMsgsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.PullMsgs',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `PushMessages`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pushMessagesDescriptor = $convert.base64Decode(
    'CgxQdXNoTWVzc2FnZXMSOAoEbXNncxgBIAMoCzIkLm9wZW5pbS5zZGt3cy5QdXNoTWVzc2FnZX'
    'MuTXNnc0VudHJ5UgRtc2dzElwKEG5vdGlmaWNhdGlvbk1zZ3MYAiADKAsyMC5vcGVuaW0uc2Rr'
    'd3MuUHVzaE1lc3NhZ2VzLk5vdGlmaWNhdGlvbk1zZ3NFbnRyeVIQbm90aWZpY2F0aW9uTXNncx'
    'pPCglNc2dzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSLAoFdmFsdWUYAiABKAsyFi5vcGVuaW0u'
    'c2Rrd3MuUHVsbE1zZ3NSBXZhbHVlOgI4ARpbChVOb3RpZmljYXRpb25Nc2dzRW50cnkSEAoDa2'
    'V5GAEgASgJUgNrZXkSLAoFdmFsdWUYAiABKAsyFi5vcGVuaW0uc2Rrd3MuUHVsbE1zZ3NSBXZh'
    'bHVlOgI4AQ==');

@$core.Deprecated('Use offlinePushInfoDescriptor instead')
const OfflinePushInfo$json = {
  '1': 'OfflinePushInfo',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'desc', '3': 2, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'ex', '3': 3, '4': 1, '5': 9, '10': 'ex'},
    {'1': 'iOSPushSound', '3': 4, '4': 1, '5': 9, '10': 'iOSPushSound'},
    {'1': 'iOSBadgeCount', '3': 5, '4': 1, '5': 8, '10': 'iOSBadgeCount'},
    {'1': 'signalInfo', '3': 6, '4': 1, '5': 9, '10': 'signalInfo'},
  ],
};

/// Descriptor for `OfflinePushInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offlinePushInfoDescriptor = $convert.base64Decode(
    'Cg9PZmZsaW5lUHVzaEluZm8SFAoFdGl0bGUYASABKAlSBXRpdGxlEhIKBGRlc2MYAiABKAlSBG'
    'Rlc2MSDgoCZXgYAyABKAlSAmV4EiIKDGlPU1B1c2hTb3VuZBgEIAEoCVIMaU9TUHVzaFNvdW5k'
    'EiQKDWlPU0JhZGdlQ291bnQYBSABKAhSDWlPU0JhZGdlQ291bnQSHgoKc2lnbmFsSW5mbxgGIA'
    'EoCVIKc2lnbmFsSW5mbw==');

@$core.Deprecated('Use tipsCommDescriptor instead')
const TipsComm$json = {
  '1': 'TipsComm',
  '2': [
    {'1': 'detail', '3': 1, '4': 1, '5': 12, '10': 'detail'},
    {'1': 'defaultTips', '3': 2, '4': 1, '5': 9, '10': 'defaultTips'},
    {'1': 'jsonDetail', '3': 3, '4': 1, '5': 9, '10': 'jsonDetail'},
  ],
};

/// Descriptor for `TipsComm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tipsCommDescriptor = $convert.base64Decode(
    'CghUaXBzQ29tbRIWCgZkZXRhaWwYASABKAxSBmRldGFpbBIgCgtkZWZhdWx0VGlwcxgCIAEoCV'
    'ILZGVmYXVsdFRpcHMSHgoKanNvbkRldGFpbBgDIAEoCVIKanNvbkRldGFpbA==');

@$core.Deprecated('Use groupCreatedTipsDescriptor instead')
const GroupCreatedTips$json = {
  '1': 'GroupCreatedTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {
      '1': 'memberList',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'memberList'
    },
    {'1': 'operationTime', '3': 4, '4': 1, '5': 3, '10': 'operationTime'},
    {
      '1': 'groupOwnerUser',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'groupOwnerUser'
    },
  ],
};

/// Descriptor for `GroupCreatedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupCreatedTipsDescriptor = $convert.base64Decode(
    'ChBHcm91cENyZWF0ZWRUaXBzEi0KBWdyb3VwGAEgASgLMhcub3BlbmltLnNka3dzLkdyb3VwSW'
    '5mb1IFZ3JvdXASOQoGb3BVc2VyGAIgASgLMiEub3BlbmltLnNka3dzLkdyb3VwTWVtYmVyRnVs'
    'bEluZm9SBm9wVXNlchJBCgptZW1iZXJMaXN0GAMgAygLMiEub3BlbmltLnNka3dzLkdyb3VwTW'
    'VtYmVyRnVsbEluZm9SCm1lbWJlckxpc3QSJAoNb3BlcmF0aW9uVGltZRgEIAEoA1INb3BlcmF0'
    'aW9uVGltZRJJCg5ncm91cE93bmVyVXNlchgFIAEoCzIhLm9wZW5pbS5zZGt3cy5Hcm91cE1lbW'
    'JlckZ1bGxJbmZvUg5ncm91cE93bmVyVXNlcg==');

@$core.Deprecated('Use groupInfoSetTipsDescriptor instead')
const GroupInfoSetTips$json = {
  '1': 'GroupInfoSetTips',
  '2': [
    {
      '1': 'opUser',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {'1': 'muteTime', '3': 2, '4': 1, '5': 3, '10': 'muteTime'},
    {
      '1': 'group',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
  ],
};

/// Descriptor for `GroupInfoSetTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupInfoSetTipsDescriptor = $convert.base64Decode(
    'ChBHcm91cEluZm9TZXRUaXBzEjkKBm9wVXNlchgBIAEoCzIhLm9wZW5pbS5zZGt3cy5Hcm91cE'
    '1lbWJlckZ1bGxJbmZvUgZvcFVzZXISGgoIbXV0ZVRpbWUYAiABKANSCG11dGVUaW1lEi0KBWdy'
    'b3VwGAMgASgLMhcub3BlbmltLnNka3dzLkdyb3VwSW5mb1IFZ3JvdXA=');

@$core.Deprecated('Use groupInfoSetNameTipsDescriptor instead')
const GroupInfoSetNameTips$json = {
  '1': 'GroupInfoSetNameTips',
  '2': [
    {
      '1': 'opUser',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {
      '1': 'group',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
  ],
};

/// Descriptor for `GroupInfoSetNameTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupInfoSetNameTipsDescriptor = $convert.base64Decode(
    'ChRHcm91cEluZm9TZXROYW1lVGlwcxI5CgZvcFVzZXIYASABKAsyIS5vcGVuaW0uc2Rrd3MuR3'
    'JvdXBNZW1iZXJGdWxsSW5mb1IGb3BVc2VyEi0KBWdyb3VwGAIgASgLMhcub3BlbmltLnNka3dz'
    'Lkdyb3VwSW5mb1IFZ3JvdXA=');

@$core.Deprecated('Use groupInfoSetAnnouncementTipsDescriptor instead')
const GroupInfoSetAnnouncementTips$json = {
  '1': 'GroupInfoSetAnnouncementTips',
  '2': [
    {
      '1': 'opUser',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {
      '1': 'group',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
  ],
};

/// Descriptor for `GroupInfoSetAnnouncementTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupInfoSetAnnouncementTipsDescriptor =
    $convert.base64Decode(
        'ChxHcm91cEluZm9TZXRBbm5vdW5jZW1lbnRUaXBzEjkKBm9wVXNlchgBIAEoCzIhLm9wZW5pbS'
        '5zZGt3cy5Hcm91cE1lbWJlckZ1bGxJbmZvUgZvcFVzZXISLQoFZ3JvdXAYAiABKAsyFy5vcGVu'
        'aW0uc2Rrd3MuR3JvdXBJbmZvUgVncm91cA==');

@$core.Deprecated('Use joinGroupApplicationTipsDescriptor instead')
const JoinGroupApplicationTips$json = {
  '1': 'JoinGroupApplicationTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'applicant',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.PublicUserInfo',
      '10': 'applicant'
    },
    {'1': 'reqMsg', '3': 3, '4': 1, '5': 9, '10': 'reqMsg'},
  ],
};

/// Descriptor for `JoinGroupApplicationTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinGroupApplicationTipsDescriptor = $convert.base64Decode(
    'ChhKb2luR3JvdXBBcHBsaWNhdGlvblRpcHMSLQoFZ3JvdXAYASABKAsyFy5vcGVuaW0uc2Rrd3'
    'MuR3JvdXBJbmZvUgVncm91cBI6CglhcHBsaWNhbnQYAiABKAsyHC5vcGVuaW0uc2Rrd3MuUHVi'
    'bGljVXNlckluZm9SCWFwcGxpY2FudBIWCgZyZXFNc2cYAyABKAlSBnJlcU1zZw==');

@$core.Deprecated('Use memberQuitTipsDescriptor instead')
const MemberQuitTips$json = {
  '1': 'MemberQuitTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'quitUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'quitUser'
    },
    {'1': 'operationTime', '3': 3, '4': 1, '5': 3, '10': 'operationTime'},
  ],
};

/// Descriptor for `MemberQuitTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberQuitTipsDescriptor = $convert.base64Decode(
    'Cg5NZW1iZXJRdWl0VGlwcxItCgVncm91cBgBIAEoCzIXLm9wZW5pbS5zZGt3cy5Hcm91cEluZm'
    '9SBWdyb3VwEj0KCHF1aXRVc2VyGAIgASgLMiEub3BlbmltLnNka3dzLkdyb3VwTWVtYmVyRnVs'
    'bEluZm9SCHF1aXRVc2VyEiQKDW9wZXJhdGlvblRpbWUYAyABKANSDW9wZXJhdGlvblRpbWU=');

@$core.Deprecated('Use groupApplicationAcceptedTipsDescriptor instead')
const GroupApplicationAcceptedTips$json = {
  '1': 'GroupApplicationAcceptedTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {'1': 'handleMsg', '3': 4, '4': 1, '5': 9, '10': 'handleMsg'},
    {'1': 'receiverAs', '3': 5, '4': 1, '5': 5, '10': 'receiverAs'},
  ],
};

/// Descriptor for `GroupApplicationAcceptedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupApplicationAcceptedTipsDescriptor = $convert.base64Decode(
    'ChxHcm91cEFwcGxpY2F0aW9uQWNjZXB0ZWRUaXBzEi0KBWdyb3VwGAEgASgLMhcub3BlbmltLn'
    'Nka3dzLkdyb3VwSW5mb1IFZ3JvdXASOQoGb3BVc2VyGAIgASgLMiEub3BlbmltLnNka3dzLkdy'
    'b3VwTWVtYmVyRnVsbEluZm9SBm9wVXNlchIcCgloYW5kbGVNc2cYBCABKAlSCWhhbmRsZU1zZx'
    'IeCgpyZWNlaXZlckFzGAUgASgFUgpyZWNlaXZlckFz');

@$core.Deprecated('Use groupApplicationRejectedTipsDescriptor instead')
const GroupApplicationRejectedTips$json = {
  '1': 'GroupApplicationRejectedTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {'1': 'handleMsg', '3': 4, '4': 1, '5': 9, '10': 'handleMsg'},
    {'1': 'receiverAs', '3': 5, '4': 1, '5': 5, '10': 'receiverAs'},
  ],
};

/// Descriptor for `GroupApplicationRejectedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupApplicationRejectedTipsDescriptor = $convert.base64Decode(
    'ChxHcm91cEFwcGxpY2F0aW9uUmVqZWN0ZWRUaXBzEi0KBWdyb3VwGAEgASgLMhcub3BlbmltLn'
    'Nka3dzLkdyb3VwSW5mb1IFZ3JvdXASOQoGb3BVc2VyGAIgASgLMiEub3BlbmltLnNka3dzLkdy'
    'b3VwTWVtYmVyRnVsbEluZm9SBm9wVXNlchIcCgloYW5kbGVNc2cYBCABKAlSCWhhbmRsZU1zZx'
    'IeCgpyZWNlaXZlckFzGAUgASgFUgpyZWNlaXZlckFz');

@$core.Deprecated('Use groupOwnerTransferredTipsDescriptor instead')
const GroupOwnerTransferredTips$json = {
  '1': 'GroupOwnerTransferredTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {
      '1': 'newGroupOwner',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'newGroupOwner'
    },
    {'1': 'oldGroupOwner', '3': 4, '4': 1, '5': 9, '10': 'oldGroupOwner'},
    {'1': 'operationTime', '3': 5, '4': 1, '5': 3, '10': 'operationTime'},
  ],
};

/// Descriptor for `GroupOwnerTransferredTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupOwnerTransferredTipsDescriptor = $convert.base64Decode(
    'ChlHcm91cE93bmVyVHJhbnNmZXJyZWRUaXBzEi0KBWdyb3VwGAEgASgLMhcub3BlbmltLnNka3'
    'dzLkdyb3VwSW5mb1IFZ3JvdXASOQoGb3BVc2VyGAIgASgLMiEub3BlbmltLnNka3dzLkdyb3Vw'
    'TWVtYmVyRnVsbEluZm9SBm9wVXNlchJHCg1uZXdHcm91cE93bmVyGAMgASgLMiEub3BlbmltLn'
    'Nka3dzLkdyb3VwTWVtYmVyRnVsbEluZm9SDW5ld0dyb3VwT3duZXISJAoNb2xkR3JvdXBPd25l'
    'chgEIAEoCVINb2xkR3JvdXBPd25lchIkCg1vcGVyYXRpb25UaW1lGAUgASgDUg1vcGVyYXRpb2'
    '5UaW1l');

@$core.Deprecated('Use memberKickedTipsDescriptor instead')
const MemberKickedTips$json = {
  '1': 'MemberKickedTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {
      '1': 'kickedUserList',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'kickedUserList'
    },
    {'1': 'operationTime', '3': 4, '4': 1, '5': 3, '10': 'operationTime'},
  ],
};

/// Descriptor for `MemberKickedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberKickedTipsDescriptor = $convert.base64Decode(
    'ChBNZW1iZXJLaWNrZWRUaXBzEi0KBWdyb3VwGAEgASgLMhcub3BlbmltLnNka3dzLkdyb3VwSW'
    '5mb1IFZ3JvdXASOQoGb3BVc2VyGAIgASgLMiEub3BlbmltLnNka3dzLkdyb3VwTWVtYmVyRnVs'
    'bEluZm9SBm9wVXNlchJJCg5raWNrZWRVc2VyTGlzdBgDIAMoCzIhLm9wZW5pbS5zZGt3cy5Hcm'
    '91cE1lbWJlckZ1bGxJbmZvUg5raWNrZWRVc2VyTGlzdBIkCg1vcGVyYXRpb25UaW1lGAQgASgD'
    'Ug1vcGVyYXRpb25UaW1l');

@$core.Deprecated('Use memberInvitedTipsDescriptor instead')
const MemberInvitedTips$json = {
  '1': 'MemberInvitedTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {
      '1': 'invitedUserList',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'invitedUserList'
    },
    {'1': 'operationTime', '3': 4, '4': 1, '5': 3, '10': 'operationTime'},
  ],
};

/// Descriptor for `MemberInvitedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberInvitedTipsDescriptor = $convert.base64Decode(
    'ChFNZW1iZXJJbnZpdGVkVGlwcxItCgVncm91cBgBIAEoCzIXLm9wZW5pbS5zZGt3cy5Hcm91cE'
    'luZm9SBWdyb3VwEjkKBm9wVXNlchgCIAEoCzIhLm9wZW5pbS5zZGt3cy5Hcm91cE1lbWJlckZ1'
    'bGxJbmZvUgZvcFVzZXISSwoPaW52aXRlZFVzZXJMaXN0GAMgAygLMiEub3BlbmltLnNka3dzLk'
    'dyb3VwTWVtYmVyRnVsbEluZm9SD2ludml0ZWRVc2VyTGlzdBIkCg1vcGVyYXRpb25UaW1lGAQg'
    'ASgDUg1vcGVyYXRpb25UaW1l');

@$core.Deprecated('Use memberEnterTipsDescriptor instead')
const MemberEnterTips$json = {
  '1': 'MemberEnterTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'entrantUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'entrantUser'
    },
    {'1': 'operationTime', '3': 3, '4': 1, '5': 3, '10': 'operationTime'},
  ],
};

/// Descriptor for `MemberEnterTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List memberEnterTipsDescriptor = $convert.base64Decode(
    'Cg9NZW1iZXJFbnRlclRpcHMSLQoFZ3JvdXAYASABKAsyFy5vcGVuaW0uc2Rrd3MuR3JvdXBJbm'
    'ZvUgVncm91cBJDCgtlbnRyYW50VXNlchgCIAEoCzIhLm9wZW5pbS5zZGt3cy5Hcm91cE1lbWJl'
    'ckZ1bGxJbmZvUgtlbnRyYW50VXNlchIkCg1vcGVyYXRpb25UaW1lGAMgASgDUg1vcGVyYXRpb2'
    '5UaW1l');

@$core.Deprecated('Use groupDismissedTipsDescriptor instead')
const GroupDismissedTips$json = {
  '1': 'GroupDismissedTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {'1': 'operationTime', '3': 3, '4': 1, '5': 3, '10': 'operationTime'},
  ],
};

/// Descriptor for `GroupDismissedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupDismissedTipsDescriptor = $convert.base64Decode(
    'ChJHcm91cERpc21pc3NlZFRpcHMSLQoFZ3JvdXAYASABKAsyFy5vcGVuaW0uc2Rrd3MuR3JvdX'
    'BJbmZvUgVncm91cBI5CgZvcFVzZXIYAiABKAsyIS5vcGVuaW0uc2Rrd3MuR3JvdXBNZW1iZXJG'
    'dWxsSW5mb1IGb3BVc2VyEiQKDW9wZXJhdGlvblRpbWUYAyABKANSDW9wZXJhdGlvblRpbWU=');

@$core.Deprecated('Use groupMemberMutedTipsDescriptor instead')
const GroupMemberMutedTips$json = {
  '1': 'GroupMemberMutedTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {'1': 'operationTime', '3': 3, '4': 1, '5': 3, '10': 'operationTime'},
    {
      '1': 'mutedUser',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'mutedUser'
    },
    {'1': 'mutedSeconds', '3': 5, '4': 1, '5': 13, '10': 'mutedSeconds'},
  ],
};

/// Descriptor for `GroupMemberMutedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupMemberMutedTipsDescriptor = $convert.base64Decode(
    'ChRHcm91cE1lbWJlck11dGVkVGlwcxItCgVncm91cBgBIAEoCzIXLm9wZW5pbS5zZGt3cy5Hcm'
    '91cEluZm9SBWdyb3VwEjkKBm9wVXNlchgCIAEoCzIhLm9wZW5pbS5zZGt3cy5Hcm91cE1lbWJl'
    'ckZ1bGxJbmZvUgZvcFVzZXISJAoNb3BlcmF0aW9uVGltZRgDIAEoA1INb3BlcmF0aW9uVGltZR'
    'I/CgltdXRlZFVzZXIYBCABKAsyIS5vcGVuaW0uc2Rrd3MuR3JvdXBNZW1iZXJGdWxsSW5mb1IJ'
    'bXV0ZWRVc2VyEiIKDG11dGVkU2Vjb25kcxgFIAEoDVIMbXV0ZWRTZWNvbmRz');

@$core.Deprecated('Use groupMemberCancelMutedTipsDescriptor instead')
const GroupMemberCancelMutedTips$json = {
  '1': 'GroupMemberCancelMutedTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {'1': 'operationTime', '3': 3, '4': 1, '5': 3, '10': 'operationTime'},
    {
      '1': 'mutedUser',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'mutedUser'
    },
  ],
};

/// Descriptor for `GroupMemberCancelMutedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupMemberCancelMutedTipsDescriptor = $convert.base64Decode(
    'ChpHcm91cE1lbWJlckNhbmNlbE11dGVkVGlwcxItCgVncm91cBgBIAEoCzIXLm9wZW5pbS5zZG'
    't3cy5Hcm91cEluZm9SBWdyb3VwEjkKBm9wVXNlchgCIAEoCzIhLm9wZW5pbS5zZGt3cy5Hcm91'
    'cE1lbWJlckZ1bGxJbmZvUgZvcFVzZXISJAoNb3BlcmF0aW9uVGltZRgDIAEoA1INb3BlcmF0aW'
    '9uVGltZRI/CgltdXRlZFVzZXIYBCABKAsyIS5vcGVuaW0uc2Rrd3MuR3JvdXBNZW1iZXJGdWxs'
    'SW5mb1IJbXV0ZWRVc2Vy');

@$core.Deprecated('Use groupMutedTipsDescriptor instead')
const GroupMutedTips$json = {
  '1': 'GroupMutedTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {'1': 'operationTime', '3': 3, '4': 1, '5': 3, '10': 'operationTime'},
  ],
};

/// Descriptor for `GroupMutedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupMutedTipsDescriptor = $convert.base64Decode(
    'Cg5Hcm91cE11dGVkVGlwcxItCgVncm91cBgBIAEoCzIXLm9wZW5pbS5zZGt3cy5Hcm91cEluZm'
    '9SBWdyb3VwEjkKBm9wVXNlchgCIAEoCzIhLm9wZW5pbS5zZGt3cy5Hcm91cE1lbWJlckZ1bGxJ'
    'bmZvUgZvcFVzZXISJAoNb3BlcmF0aW9uVGltZRgDIAEoA1INb3BlcmF0aW9uVGltZQ==');

@$core.Deprecated('Use groupCancelMutedTipsDescriptor instead')
const GroupCancelMutedTips$json = {
  '1': 'GroupCancelMutedTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {'1': 'operationTime', '3': 3, '4': 1, '5': 3, '10': 'operationTime'},
  ],
};

/// Descriptor for `GroupCancelMutedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupCancelMutedTipsDescriptor = $convert.base64Decode(
    'ChRHcm91cENhbmNlbE11dGVkVGlwcxItCgVncm91cBgBIAEoCzIXLm9wZW5pbS5zZGt3cy5Hcm'
    '91cEluZm9SBWdyb3VwEjkKBm9wVXNlchgCIAEoCzIhLm9wZW5pbS5zZGt3cy5Hcm91cE1lbWJl'
    'ckZ1bGxJbmZvUgZvcFVzZXISJAoNb3BlcmF0aW9uVGltZRgDIAEoA1INb3BlcmF0aW9uVGltZQ'
    '==');

@$core.Deprecated('Use groupMemberInfoSetTipsDescriptor instead')
const GroupMemberInfoSetTips$json = {
  '1': 'GroupMemberInfoSetTips',
  '2': [
    {
      '1': 'group',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupInfo',
      '10': 'group'
    },
    {
      '1': 'opUser',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'opUser'
    },
    {'1': 'operationTime', '3': 3, '4': 1, '5': 3, '10': 'operationTime'},
    {
      '1': 'changedUser',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.GroupMemberFullInfo',
      '10': 'changedUser'
    },
  ],
};

/// Descriptor for `GroupMemberInfoSetTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupMemberInfoSetTipsDescriptor = $convert.base64Decode(
    'ChZHcm91cE1lbWJlckluZm9TZXRUaXBzEi0KBWdyb3VwGAEgASgLMhcub3BlbmltLnNka3dzLk'
    'dyb3VwSW5mb1IFZ3JvdXASOQoGb3BVc2VyGAIgASgLMiEub3BlbmltLnNka3dzLkdyb3VwTWVt'
    'YmVyRnVsbEluZm9SBm9wVXNlchIkCg1vcGVyYXRpb25UaW1lGAMgASgDUg1vcGVyYXRpb25UaW'
    '1lEkMKC2NoYW5nZWRVc2VyGAQgASgLMiEub3BlbmltLnNka3dzLkdyb3VwTWVtYmVyRnVsbElu'
    'Zm9SC2NoYW5nZWRVc2Vy');

@$core.Deprecated('Use friendApplicationDescriptor instead')
const FriendApplication$json = {
  '1': 'FriendApplication',
  '2': [
    {'1': 'addTime', '3': 1, '4': 1, '5': 3, '10': 'addTime'},
    {'1': 'addSource', '3': 2, '4': 1, '5': 9, '10': 'addSource'},
    {'1': 'addWording', '3': 3, '4': 1, '5': 9, '10': 'addWording'},
  ],
};

/// Descriptor for `FriendApplication`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendApplicationDescriptor = $convert.base64Decode(
    'ChFGcmllbmRBcHBsaWNhdGlvbhIYCgdhZGRUaW1lGAEgASgDUgdhZGRUaW1lEhwKCWFkZFNvdX'
    'JjZRgCIAEoCVIJYWRkU291cmNlEh4KCmFkZFdvcmRpbmcYAyABKAlSCmFkZFdvcmRpbmc=');

@$core.Deprecated('Use fromToUserIDDescriptor instead')
const FromToUserID$json = {
  '1': 'FromToUserID',
  '2': [
    {'1': 'fromUserID', '3': 1, '4': 1, '5': 9, '10': 'fromUserID'},
    {'1': 'toUserID', '3': 2, '4': 1, '5': 9, '10': 'toUserID'},
  ],
};

/// Descriptor for `FromToUserID`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fromToUserIDDescriptor = $convert.base64Decode(
    'CgxGcm9tVG9Vc2VySUQSHgoKZnJvbVVzZXJJRBgBIAEoCVIKZnJvbVVzZXJJRBIaCgh0b1VzZX'
    'JJRBgCIAEoCVIIdG9Vc2VySUQ=');

@$core.Deprecated('Use friendApplicationTipsDescriptor instead')
const FriendApplicationTips$json = {
  '1': 'FriendApplicationTips',
  '2': [
    {
      '1': 'fromToUserID',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.FromToUserID',
      '10': 'fromToUserID'
    },
  ],
};

/// Descriptor for `FriendApplicationTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendApplicationTipsDescriptor = $convert.base64Decode(
    'ChVGcmllbmRBcHBsaWNhdGlvblRpcHMSPgoMZnJvbVRvVXNlcklEGAEgASgLMhoub3BlbmltLn'
    'Nka3dzLkZyb21Ub1VzZXJJRFIMZnJvbVRvVXNlcklE');

@$core.Deprecated('Use friendApplicationApprovedTipsDescriptor instead')
const FriendApplicationApprovedTips$json = {
  '1': 'FriendApplicationApprovedTips',
  '2': [
    {
      '1': 'fromToUserID',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.FromToUserID',
      '10': 'fromToUserID'
    },
    {'1': 'handleMsg', '3': 2, '4': 1, '5': 9, '10': 'handleMsg'},
  ],
};

/// Descriptor for `FriendApplicationApprovedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendApplicationApprovedTipsDescriptor =
    $convert.base64Decode(
        'Ch1GcmllbmRBcHBsaWNhdGlvbkFwcHJvdmVkVGlwcxI+Cgxmcm9tVG9Vc2VySUQYASABKAsyGi'
        '5vcGVuaW0uc2Rrd3MuRnJvbVRvVXNlcklEUgxmcm9tVG9Vc2VySUQSHAoJaGFuZGxlTXNnGAIg'
        'ASgJUgloYW5kbGVNc2c=');

@$core.Deprecated('Use friendApplicationRejectedTipsDescriptor instead')
const FriendApplicationRejectedTips$json = {
  '1': 'FriendApplicationRejectedTips',
  '2': [
    {
      '1': 'fromToUserID',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.FromToUserID',
      '10': 'fromToUserID'
    },
    {'1': 'handleMsg', '3': 2, '4': 1, '5': 9, '10': 'handleMsg'},
  ],
};

/// Descriptor for `FriendApplicationRejectedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendApplicationRejectedTipsDescriptor =
    $convert.base64Decode(
        'Ch1GcmllbmRBcHBsaWNhdGlvblJlamVjdGVkVGlwcxI+Cgxmcm9tVG9Vc2VySUQYASABKAsyGi'
        '5vcGVuaW0uc2Rrd3MuRnJvbVRvVXNlcklEUgxmcm9tVG9Vc2VySUQSHAoJaGFuZGxlTXNnGAIg'
        'ASgJUgloYW5kbGVNc2c=');

@$core.Deprecated('Use friendAddedTipsDescriptor instead')
const FriendAddedTips$json = {
  '1': 'FriendAddedTips',
  '2': [
    {
      '1': 'friend',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.FriendInfo',
      '10': 'friend'
    },
    {'1': 'operationTime', '3': 2, '4': 1, '5': 3, '10': 'operationTime'},
    {
      '1': 'opUser',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.PublicUserInfo',
      '10': 'opUser'
    },
  ],
};

/// Descriptor for `FriendAddedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendAddedTipsDescriptor = $convert.base64Decode(
    'Cg9GcmllbmRBZGRlZFRpcHMSMAoGZnJpZW5kGAEgASgLMhgub3BlbmltLnNka3dzLkZyaWVuZE'
    'luZm9SBmZyaWVuZBIkCg1vcGVyYXRpb25UaW1lGAIgASgDUg1vcGVyYXRpb25UaW1lEjQKBm9w'
    'VXNlchgDIAEoCzIcLm9wZW5pbS5zZGt3cy5QdWJsaWNVc2VySW5mb1IGb3BVc2Vy');

@$core.Deprecated('Use friendDeletedTipsDescriptor instead')
const FriendDeletedTips$json = {
  '1': 'FriendDeletedTips',
  '2': [
    {
      '1': 'fromToUserID',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.FromToUserID',
      '10': 'fromToUserID'
    },
  ],
};

/// Descriptor for `FriendDeletedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendDeletedTipsDescriptor = $convert.base64Decode(
    'ChFGcmllbmREZWxldGVkVGlwcxI+Cgxmcm9tVG9Vc2VySUQYASABKAsyGi5vcGVuaW0uc2Rrd3'
    'MuRnJvbVRvVXNlcklEUgxmcm9tVG9Vc2VySUQ=');

@$core.Deprecated('Use blackAddedTipsDescriptor instead')
const BlackAddedTips$json = {
  '1': 'BlackAddedTips',
  '2': [
    {
      '1': 'fromToUserID',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.FromToUserID',
      '10': 'fromToUserID'
    },
  ],
};

/// Descriptor for `BlackAddedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blackAddedTipsDescriptor = $convert.base64Decode(
    'Cg5CbGFja0FkZGVkVGlwcxI+Cgxmcm9tVG9Vc2VySUQYASABKAsyGi5vcGVuaW0uc2Rrd3MuRn'
    'JvbVRvVXNlcklEUgxmcm9tVG9Vc2VySUQ=');

@$core.Deprecated('Use blackDeletedTipsDescriptor instead')
const BlackDeletedTips$json = {
  '1': 'BlackDeletedTips',
  '2': [
    {
      '1': 'fromToUserID',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.FromToUserID',
      '10': 'fromToUserID'
    },
  ],
};

/// Descriptor for `BlackDeletedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blackDeletedTipsDescriptor = $convert.base64Decode(
    'ChBCbGFja0RlbGV0ZWRUaXBzEj4KDGZyb21Ub1VzZXJJRBgBIAEoCzIaLm9wZW5pbS5zZGt3cy'
    '5Gcm9tVG9Vc2VySURSDGZyb21Ub1VzZXJJRA==');

@$core.Deprecated('Use friendInfoChangedTipsDescriptor instead')
const FriendInfoChangedTips$json = {
  '1': 'FriendInfoChangedTips',
  '2': [
    {
      '1': 'fromToUserID',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.FromToUserID',
      '10': 'fromToUserID'
    },
  ],
};

/// Descriptor for `FriendInfoChangedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendInfoChangedTipsDescriptor = $convert.base64Decode(
    'ChVGcmllbmRJbmZvQ2hhbmdlZFRpcHMSPgoMZnJvbVRvVXNlcklEGAEgASgLMhoub3BlbmltLn'
    'Nka3dzLkZyb21Ub1VzZXJJRFIMZnJvbVRvVXNlcklE');

@$core.Deprecated('Use userInfoUpdatedTipsDescriptor instead')
const UserInfoUpdatedTips$json = {
  '1': 'UserInfoUpdatedTips',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
  ],
};

/// Descriptor for `UserInfoUpdatedTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoUpdatedTipsDescriptor =
    $convert.base64Decode(
        'ChNVc2VySW5mb1VwZGF0ZWRUaXBzEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklE');

@$core.Deprecated('Use userStatusChangeTipsDescriptor instead')
const UserStatusChangeTips$json = {
  '1': 'UserStatusChangeTips',
  '2': [
    {'1': 'fromUserID', '3': 1, '4': 1, '5': 9, '10': 'fromUserID'},
    {'1': 'toUserID', '3': 2, '4': 1, '5': 9, '10': 'toUserID'},
    {'1': 'status', '3': 3, '4': 1, '5': 5, '10': 'status'},
    {'1': 'platformID', '3': 4, '4': 1, '5': 5, '10': 'platformID'},
  ],
};

/// Descriptor for `UserStatusChangeTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userStatusChangeTipsDescriptor = $convert.base64Decode(
    'ChRVc2VyU3RhdHVzQ2hhbmdlVGlwcxIeCgpmcm9tVXNlcklEGAEgASgJUgpmcm9tVXNlcklEEh'
    'oKCHRvVXNlcklEGAIgASgJUgh0b1VzZXJJRBIWCgZzdGF0dXMYAyABKAVSBnN0YXR1cxIeCgpw'
    'bGF0Zm9ybUlEGAQgASgFUgpwbGF0Zm9ybUlE');

@$core.Deprecated('Use userCommandAddTipsDescriptor instead')
const UserCommandAddTips$json = {
  '1': 'UserCommandAddTips',
  '2': [
    {'1': 'fromUserID', '3': 1, '4': 1, '5': 9, '10': 'fromUserID'},
    {'1': 'toUserID', '3': 2, '4': 1, '5': 9, '10': 'toUserID'},
  ],
};

/// Descriptor for `UserCommandAddTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userCommandAddTipsDescriptor = $convert.base64Decode(
    'ChJVc2VyQ29tbWFuZEFkZFRpcHMSHgoKZnJvbVVzZXJJRBgBIAEoCVIKZnJvbVVzZXJJRBIaCg'
    'h0b1VzZXJJRBgCIAEoCVIIdG9Vc2VySUQ=');

@$core.Deprecated('Use userCommandUpdateTipsDescriptor instead')
const UserCommandUpdateTips$json = {
  '1': 'UserCommandUpdateTips',
  '2': [
    {'1': 'fromUserID', '3': 1, '4': 1, '5': 9, '10': 'fromUserID'},
    {'1': 'toUserID', '3': 2, '4': 1, '5': 9, '10': 'toUserID'},
  ],
};

/// Descriptor for `UserCommandUpdateTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userCommandUpdateTipsDescriptor = $convert.base64Decode(
    'ChVVc2VyQ29tbWFuZFVwZGF0ZVRpcHMSHgoKZnJvbVVzZXJJRBgBIAEoCVIKZnJvbVVzZXJJRB'
    'IaCgh0b1VzZXJJRBgCIAEoCVIIdG9Vc2VySUQ=');

@$core.Deprecated('Use userCommandDeleteTipsDescriptor instead')
const UserCommandDeleteTips$json = {
  '1': 'UserCommandDeleteTips',
  '2': [
    {'1': 'fromUserID', '3': 1, '4': 1, '5': 9, '10': 'fromUserID'},
    {'1': 'toUserID', '3': 2, '4': 1, '5': 9, '10': 'toUserID'},
  ],
};

/// Descriptor for `UserCommandDeleteTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userCommandDeleteTipsDescriptor = $convert.base64Decode(
    'ChVVc2VyQ29tbWFuZERlbGV0ZVRpcHMSHgoKZnJvbVVzZXJJRBgBIAEoCVIKZnJvbVVzZXJJRB'
    'IaCgh0b1VzZXJJRBgCIAEoCVIIdG9Vc2VySUQ=');

@$core.Deprecated('Use conversationUpdateTipsDescriptor instead')
const ConversationUpdateTips$json = {
  '1': 'ConversationUpdateTips',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {
      '1': 'conversationIDList',
      '3': 2,
      '4': 3,
      '5': 9,
      '10': 'conversationIDList'
    },
  ],
};

/// Descriptor for `ConversationUpdateTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conversationUpdateTipsDescriptor =
    $convert.base64Decode(
        'ChZDb252ZXJzYXRpb25VcGRhdGVUaXBzEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEi4KEmNvbn'
        'ZlcnNhdGlvbklETGlzdBgCIAMoCVISY29udmVyc2F0aW9uSURMaXN0');

@$core.Deprecated('Use conversationSetPrivateTipsDescriptor instead')
const ConversationSetPrivateTips$json = {
  '1': 'ConversationSetPrivateTips',
  '2': [
    {'1': 'recvID', '3': 1, '4': 1, '5': 9, '10': 'recvID'},
    {'1': 'sendID', '3': 2, '4': 1, '5': 9, '10': 'sendID'},
    {'1': 'isPrivate', '3': 3, '4': 1, '5': 8, '10': 'isPrivate'},
    {'1': 'conversationID', '3': 4, '4': 1, '5': 9, '10': 'conversationID'},
  ],
};

/// Descriptor for `ConversationSetPrivateTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conversationSetPrivateTipsDescriptor =
    $convert.base64Decode(
        'ChpDb252ZXJzYXRpb25TZXRQcml2YXRlVGlwcxIWCgZyZWN2SUQYASABKAlSBnJlY3ZJRBIWCg'
        'ZzZW5kSUQYAiABKAlSBnNlbmRJRBIcCglpc1ByaXZhdGUYAyABKAhSCWlzUHJpdmF0ZRImCg5j'
        'b252ZXJzYXRpb25JRBgEIAEoCVIOY29udmVyc2F0aW9uSUQ=');

@$core.Deprecated('Use conversationHasReadTipsDescriptor instead')
const ConversationHasReadTips$json = {
  '1': 'ConversationHasReadTips',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'conversationID', '3': 2, '4': 1, '5': 9, '10': 'conversationID'},
    {'1': 'hasReadSeq', '3': 3, '4': 1, '5': 3, '10': 'hasReadSeq'},
    {'1': 'unreadCountTime', '3': 4, '4': 1, '5': 3, '10': 'unreadCountTime'},
  ],
};

/// Descriptor for `ConversationHasReadTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conversationHasReadTipsDescriptor = $convert.base64Decode(
    'ChdDb252ZXJzYXRpb25IYXNSZWFkVGlwcxIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBImCg5jb2'
    '52ZXJzYXRpb25JRBgCIAEoCVIOY29udmVyc2F0aW9uSUQSHgoKaGFzUmVhZFNlcRgDIAEoA1IK'
    'aGFzUmVhZFNlcRIoCg91bnJlYWRDb3VudFRpbWUYBCABKANSD3VucmVhZENvdW50VGltZQ==');

@$core.Deprecated('Use notificationElemDescriptor instead')
const NotificationElem$json = {
  '1': 'NotificationElem',
  '2': [
    {'1': 'detail', '3': 1, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `NotificationElem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationElemDescriptor = $convert
    .base64Decode('ChBOb3RpZmljYXRpb25FbGVtEhYKBmRldGFpbBgBIAEoCVIGZGV0YWls');

@$core.Deprecated('Use seqListDescriptor instead')
const SeqList$json = {
  '1': 'SeqList',
  '2': [
    {'1': 'seqs', '3': 1, '4': 3, '5': 3, '10': 'seqs'},
  ],
};

/// Descriptor for `SeqList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seqListDescriptor =
    $convert.base64Decode('CgdTZXFMaXN0EhIKBHNlcXMYASADKANSBHNlcXM=');

@$core.Deprecated('Use deleteMessageTipsDescriptor instead')
const DeleteMessageTips$json = {
  '1': 'DeleteMessageTips',
  '2': [
    {'1': 'opUserID', '3': 1, '4': 1, '5': 9, '10': 'opUserID'},
    {'1': 'userID', '3': 2, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'seqs', '3': 3, '4': 3, '5': 3, '10': 'seqs'},
  ],
};

/// Descriptor for `DeleteMessageTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMessageTipsDescriptor = $convert.base64Decode(
    'ChFEZWxldGVNZXNzYWdlVGlwcxIaCghvcFVzZXJJRBgBIAEoCVIIb3BVc2VySUQSFgoGdXNlck'
    'lEGAIgASgJUgZ1c2VySUQSEgoEc2VxcxgDIAMoA1IEc2Vxcw==');

@$core.Deprecated('Use revokeMsgTipsDescriptor instead')
const RevokeMsgTips$json = {
  '1': 'RevokeMsgTips',
  '2': [
    {'1': 'revokerUserID', '3': 1, '4': 1, '5': 9, '10': 'revokerUserID'},
    {'1': 'clientMsgID', '3': 2, '4': 1, '5': 9, '10': 'clientMsgID'},
    {'1': 'revokeTime', '3': 3, '4': 1, '5': 3, '10': 'revokeTime'},
    {'1': 'sesstionType', '3': 5, '4': 1, '5': 5, '10': 'sesstionType'},
    {'1': 'seq', '3': 6, '4': 1, '5': 3, '10': 'seq'},
    {'1': 'conversationID', '3': 7, '4': 1, '5': 9, '10': 'conversationID'},
    {'1': 'isAdminRevoke', '3': 8, '4': 1, '5': 8, '10': 'isAdminRevoke'},
  ],
};

/// Descriptor for `RevokeMsgTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revokeMsgTipsDescriptor = $convert.base64Decode(
    'Cg1SZXZva2VNc2dUaXBzEiQKDXJldm9rZXJVc2VySUQYASABKAlSDXJldm9rZXJVc2VySUQSIA'
    'oLY2xpZW50TXNnSUQYAiABKAlSC2NsaWVudE1zZ0lEEh4KCnJldm9rZVRpbWUYAyABKANSCnJl'
    'dm9rZVRpbWUSIgoMc2Vzc3Rpb25UeXBlGAUgASgFUgxzZXNzdGlvblR5cGUSEAoDc2VxGAYgAS'
    'gDUgNzZXESJgoOY29udmVyc2F0aW9uSUQYByABKAlSDmNvbnZlcnNhdGlvbklEEiQKDWlzQWRt'
    'aW5SZXZva2UYCCABKAhSDWlzQWRtaW5SZXZva2U=');

@$core.Deprecated('Use messageRevokedContentDescriptor instead')
const MessageRevokedContent$json = {
  '1': 'MessageRevokedContent',
  '2': [
    {'1': 'revokerID', '3': 1, '4': 1, '5': 9, '10': 'revokerID'},
    {'1': 'revokerRole', '3': 2, '4': 1, '5': 5, '10': 'revokerRole'},
    {'1': 'clientMsgID', '3': 3, '4': 1, '5': 9, '10': 'clientMsgID'},
    {'1': 'revokerNickname', '3': 4, '4': 1, '5': 9, '10': 'revokerNickname'},
    {'1': 'revokeTime', '3': 5, '4': 1, '5': 3, '10': 'revokeTime'},
    {
      '1': 'sourceMessageSendTime',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'sourceMessageSendTime'
    },
    {
      '1': 'sourceMessageSendID',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'sourceMessageSendID'
    },
    {
      '1': 'sourceMessageSenderNickname',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'sourceMessageSenderNickname'
    },
    {'1': 'sessionType', '3': 10, '4': 1, '5': 5, '10': 'sessionType'},
    {'1': 'seq', '3': 11, '4': 1, '5': 3, '10': 'seq'},
    {'1': 'ex', '3': 12, '4': 1, '5': 9, '10': 'ex'},
  ],
};

/// Descriptor for `MessageRevokedContent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageRevokedContentDescriptor = $convert.base64Decode(
    'ChVNZXNzYWdlUmV2b2tlZENvbnRlbnQSHAoJcmV2b2tlcklEGAEgASgJUglyZXZva2VySUQSIA'
    'oLcmV2b2tlclJvbGUYAiABKAVSC3Jldm9rZXJSb2xlEiAKC2NsaWVudE1zZ0lEGAMgASgJUgtj'
    'bGllbnRNc2dJRBIoCg9yZXZva2VyTmlja25hbWUYBCABKAlSD3Jldm9rZXJOaWNrbmFtZRIeCg'
    'pyZXZva2VUaW1lGAUgASgDUgpyZXZva2VUaW1lEjQKFXNvdXJjZU1lc3NhZ2VTZW5kVGltZRgG'
    'IAEoA1IVc291cmNlTWVzc2FnZVNlbmRUaW1lEjAKE3NvdXJjZU1lc3NhZ2VTZW5kSUQYByABKA'
    'lSE3NvdXJjZU1lc3NhZ2VTZW5kSUQSQAobc291cmNlTWVzc2FnZVNlbmRlck5pY2tuYW1lGAgg'
    'ASgJUhtzb3VyY2VNZXNzYWdlU2VuZGVyTmlja25hbWUSIAoLc2Vzc2lvblR5cGUYCiABKAVSC3'
    'Nlc3Npb25UeXBlEhAKA3NlcRgLIAEoA1IDc2VxEg4KAmV4GAwgASgJUgJleA==');

@$core.Deprecated('Use clearConversationTipsDescriptor instead')
const ClearConversationTips$json = {
  '1': 'ClearConversationTips',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'conversationIDs', '3': 2, '4': 3, '5': 9, '10': 'conversationIDs'},
  ],
};

/// Descriptor for `ClearConversationTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearConversationTipsDescriptor = $convert.base64Decode(
    'ChVDbGVhckNvbnZlcnNhdGlvblRpcHMSFgoGdXNlcklEGAEgASgJUgZ1c2VySUQSKAoPY29udm'
    'Vyc2F0aW9uSURzGAIgAygJUg9jb252ZXJzYXRpb25JRHM=');

@$core.Deprecated('Use deleteMsgsTipsDescriptor instead')
const DeleteMsgsTips$json = {
  '1': 'DeleteMsgsTips',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'conversationID', '3': 2, '4': 1, '5': 9, '10': 'conversationID'},
    {'1': 'seqs', '3': 3, '4': 3, '5': 3, '10': 'seqs'},
  ],
};

/// Descriptor for `DeleteMsgsTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteMsgsTipsDescriptor = $convert.base64Decode(
    'Cg5EZWxldGVNc2dzVGlwcxIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBImCg5jb252ZXJzYXRpb2'
    '5JRBgCIAEoCVIOY29udmVyc2F0aW9uSUQSEgoEc2VxcxgDIAMoA1IEc2Vxcw==');

@$core.Deprecated('Use markAsReadTipsDescriptor instead')
const MarkAsReadTips$json = {
  '1': 'MarkAsReadTips',
  '2': [
    {'1': 'markAsReadUserID', '3': 1, '4': 1, '5': 9, '10': 'markAsReadUserID'},
    {'1': 'conversationID', '3': 2, '4': 1, '5': 9, '10': 'conversationID'},
    {'1': 'seqs', '3': 3, '4': 3, '5': 3, '10': 'seqs'},
    {'1': 'hasReadSeq', '3': 4, '4': 1, '5': 3, '10': 'hasReadSeq'},
  ],
};

/// Descriptor for `MarkAsReadTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markAsReadTipsDescriptor = $convert.base64Decode(
    'Cg5NYXJrQXNSZWFkVGlwcxIqChBtYXJrQXNSZWFkVXNlcklEGAEgASgJUhBtYXJrQXNSZWFkVX'
    'NlcklEEiYKDmNvbnZlcnNhdGlvbklEGAIgASgJUg5jb252ZXJzYXRpb25JRBISCgRzZXFzGAMg'
    'AygDUgRzZXFzEh4KCmhhc1JlYWRTZXEYBCABKANSCmhhc1JlYWRTZXE=');

@$core.Deprecated('Use setAppBackgroundStatusReqDescriptor instead')
const SetAppBackgroundStatusReq$json = {
  '1': 'SetAppBackgroundStatusReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'isBackground', '3': 2, '4': 1, '5': 8, '10': 'isBackground'},
  ],
};

/// Descriptor for `SetAppBackgroundStatusReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAppBackgroundStatusReqDescriptor =
    $convert.base64Decode(
        'ChlTZXRBcHBCYWNrZ3JvdW5kU3RhdHVzUmVxEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEiIKDG'
        'lzQmFja2dyb3VuZBgCIAEoCFIMaXNCYWNrZ3JvdW5k');

@$core.Deprecated('Use setAppBackgroundStatusRespDescriptor instead')
const SetAppBackgroundStatusResp$json = {
  '1': 'SetAppBackgroundStatusResp',
};

/// Descriptor for `SetAppBackgroundStatusResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAppBackgroundStatusRespDescriptor =
    $convert.base64Decode('ChpTZXRBcHBCYWNrZ3JvdW5kU3RhdHVzUmVzcA==');

@$core.Deprecated('Use processUserCommandDescriptor instead')
const ProcessUserCommand$json = {
  '1': 'ProcessUserCommand',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'type', '3': 2, '4': 1, '5': 5, '10': 'type'},
    {'1': 'createTime', '3': 3, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'uuid', '3': 4, '4': 1, '5': 9, '10': 'uuid'},
    {'1': 'value', '3': 5, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `ProcessUserCommand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List processUserCommandDescriptor = $convert.base64Decode(
    'ChJQcm9jZXNzVXNlckNvbW1hbmQSFgoGdXNlcklEGAEgASgJUgZ1c2VySUQSEgoEdHlwZRgCIA'
    'EoBVIEdHlwZRIeCgpjcmVhdGVUaW1lGAMgASgDUgpjcmVhdGVUaW1lEhIKBHV1aWQYBCABKAlS'
    'BHV1aWQSFAoFdmFsdWUYBSABKAlSBXZhbHVl');

@$core.Deprecated('Use requestPaginationDescriptor instead')
const RequestPagination$json = {
  '1': 'RequestPagination',
  '2': [
    {'1': 'pageNumber', '3': 1, '4': 1, '5': 5, '10': 'pageNumber'},
    {'1': 'showNumber', '3': 2, '4': 1, '5': 5, '10': 'showNumber'},
  ],
};

/// Descriptor for `RequestPagination`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestPaginationDescriptor = $convert.base64Decode(
    'ChFSZXF1ZXN0UGFnaW5hdGlvbhIeCgpwYWdlTnVtYmVyGAEgASgFUgpwYWdlTnVtYmVyEh4KCn'
    'Nob3dOdW1iZXIYAiABKAVSCnNob3dOdW1iZXI=');

@$core.Deprecated('Use friendsInfoUpdateTipsDescriptor instead')
const FriendsInfoUpdateTips$json = {
  '1': 'FriendsInfoUpdateTips',
  '2': [
    {
      '1': 'fromToUserID',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.FromToUserID',
      '10': 'fromToUserID'
    },
    {'1': 'friendIDs', '3': 2, '4': 3, '5': 9, '10': 'friendIDs'},
  ],
};

/// Descriptor for `FriendsInfoUpdateTips`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendsInfoUpdateTipsDescriptor = $convert.base64Decode(
    'ChVGcmllbmRzSW5mb1VwZGF0ZVRpcHMSPgoMZnJvbVRvVXNlcklEGAEgASgLMhoub3BlbmltLn'
    'Nka3dzLkZyb21Ub1VzZXJJRFIMZnJvbVRvVXNlcklEEhwKCWZyaWVuZElEcxgCIAMoCVIJZnJp'
    'ZW5kSURz');
