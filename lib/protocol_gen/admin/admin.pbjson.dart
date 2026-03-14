// This is a generated file - do not edit.
//
// Generated from admin/admin.proto.

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

import '../common/common.pbjson.dart' as $2;
import '../sdkws/sdkws.pbjson.dart' as $1;
import '../wrapperspb/wrapperspb.pbjson.dart' as $0;

@$core.Deprecated('Use loginReqDescriptor instead')
const LoginReq$json = {
  '1': 'LoginReq',
  '2': [
    {'1': 'account', '3': 1, '4': 1, '5': 9, '10': 'account'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `LoginReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginReqDescriptor = $convert
    .base64Decode('CghMb2dpblJlcRIYCgdhY2NvdW50GAEgASgJUgdhY2NvdW50EhoKCHBhc3N3b3JkGAIgASgJUg'
        'hwYXNzd29yZBIYCgd2ZXJzaW9uGAMgASgJUgd2ZXJzaW9u');

@$core.Deprecated('Use loginRespDescriptor instead')
const LoginResp$json = {
  '1': 'LoginResp',
  '2': [
    {'1': 'adminAccount', '3': 1, '4': 1, '5': 9, '10': 'adminAccount'},
    {'1': 'adminToken', '3': 2, '4': 1, '5': 9, '10': 'adminToken'},
    {'1': 'nickname', '3': 3, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'faceURL', '3': 4, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'level', '3': 5, '4': 1, '5': 5, '10': 'level'},
    {'1': 'adminUserID', '3': 6, '4': 1, '5': 9, '10': 'adminUserID'},
  ],
};

/// Descriptor for `LoginResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRespDescriptor = $convert
    .base64Decode('CglMb2dpblJlc3ASIgoMYWRtaW5BY2NvdW50GAEgASgJUgxhZG1pbkFjY291bnQSHgoKYWRtaW'
        '5Ub2tlbhgCIAEoCVIKYWRtaW5Ub2tlbhIaCghuaWNrbmFtZRgDIAEoCVIIbmlja25hbWUSGAoH'
        'ZmFjZVVSTBgEIAEoCVIHZmFjZVVSTBIUCgVsZXZlbBgFIAEoBVIFbGV2ZWwSIAoLYWRtaW5Vc2'
        'VySUQYBiABKAlSC2FkbWluVXNlcklE');

@$core.Deprecated('Use addAdminAccountReqDescriptor instead')
const AddAdminAccountReq$json = {
  '1': 'AddAdminAccountReq',
  '2': [
    {'1': 'account', '3': 1, '4': 1, '5': 9, '10': 'account'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'faceURL', '3': 3, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'nickname', '3': 4, '4': 1, '5': 9, '10': 'nickname'},
  ],
};

/// Descriptor for `AddAdminAccountReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAdminAccountReqDescriptor = $convert
    .base64Decode('ChJBZGRBZG1pbkFjY291bnRSZXESGAoHYWNjb3VudBgBIAEoCVIHYWNjb3VudBIaCghwYXNzd2'
        '9yZBgCIAEoCVIIcGFzc3dvcmQSGAoHZmFjZVVSTBgDIAEoCVIHZmFjZVVSTBIaCghuaWNrbmFt'
        'ZRgEIAEoCVIIbmlja25hbWU=');

@$core.Deprecated('Use addAdminAccountRespDescriptor instead')
const AddAdminAccountResp$json = {
  '1': 'AddAdminAccountResp',
};

/// Descriptor for `AddAdminAccountResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAdminAccountRespDescriptor =
    $convert.base64Decode('ChNBZGRBZG1pbkFjY291bnRSZXNw');

@$core.Deprecated('Use adminUpdateInfoReqDescriptor instead')
const AdminUpdateInfoReq$json = {
  '1': 'AdminUpdateInfoReq',
  '2': [
    {'1': 'account', '3': 1, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'account'},
    {
      '1': 'password',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'password'
    },
    {'1': 'faceURL', '3': 3, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'faceURL'},
    {
      '1': 'nickname',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'nickname'
    },
    {'1': 'level', '3': 6, '4': 1, '5': 11, '6': '.openim.protobuf.Int32Value', '10': 'level'},
  ],
};

/// Descriptor for `AdminUpdateInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adminUpdateInfoReqDescriptor = $convert
    .base64Decode('ChJBZG1pblVwZGF0ZUluZm9SZXESNgoHYWNjb3VudBgBIAEoCzIcLm9wZW5pbS5wcm90b2J1Zi'
        '5TdHJpbmdWYWx1ZVIHYWNjb3VudBI4CghwYXNzd29yZBgCIAEoCzIcLm9wZW5pbS5wcm90b2J1'
        'Zi5TdHJpbmdWYWx1ZVIIcGFzc3dvcmQSNgoHZmFjZVVSTBgDIAEoCzIcLm9wZW5pbS5wcm90b2'
        'J1Zi5TdHJpbmdWYWx1ZVIHZmFjZVVSTBI4CghuaWNrbmFtZRgEIAEoCzIcLm9wZW5pbS5wcm90'
        'b2J1Zi5TdHJpbmdWYWx1ZVIIbmlja25hbWUSMQoFbGV2ZWwYBiABKAsyGy5vcGVuaW0ucHJvdG'
        '9idWYuSW50MzJWYWx1ZVIFbGV2ZWw=');

@$core.Deprecated('Use adminUpdateInfoRespDescriptor instead')
const AdminUpdateInfoResp$json = {
  '1': 'AdminUpdateInfoResp',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'nickname', '3': 2, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'faceURL', '3': 3, '4': 1, '5': 9, '10': 'faceURL'},
  ],
};

/// Descriptor for `AdminUpdateInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adminUpdateInfoRespDescriptor = $convert
    .base64Decode('ChNBZG1pblVwZGF0ZUluZm9SZXNwEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEhoKCG5pY2tuYW'
        '1lGAIgASgJUghuaWNrbmFtZRIYCgdmYWNlVVJMGAMgASgJUgdmYWNlVVJM');

@$core.Deprecated('Use changePasswordReqDescriptor instead')
const ChangePasswordReq$json = {
  '1': 'ChangePasswordReq',
  '2': [
    {'1': 'password', '3': 1, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `ChangePasswordReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordReqDescriptor =
    $convert.base64Decode('ChFDaGFuZ2VQYXNzd29yZFJlcRIaCghwYXNzd29yZBgBIAEoCVIIcGFzc3dvcmQ=');

@$core.Deprecated('Use changePasswordRespDescriptor instead')
const ChangePasswordResp$json = {
  '1': 'ChangePasswordResp',
};

/// Descriptor for `ChangePasswordResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordRespDescriptor =
    $convert.base64Decode('ChJDaGFuZ2VQYXNzd29yZFJlc3A=');

@$core.Deprecated('Use getAdminInfoReqDescriptor instead')
const GetAdminInfoReq$json = {
  '1': 'GetAdminInfoReq',
};

/// Descriptor for `GetAdminInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAdminInfoReqDescriptor =
    $convert.base64Decode('Cg9HZXRBZG1pbkluZm9SZXE=');

@$core.Deprecated('Use changeAdminPasswordReqDescriptor instead')
const ChangeAdminPasswordReq$json = {
  '1': 'ChangeAdminPasswordReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'currentPassword', '3': 2, '4': 1, '5': 9, '10': 'currentPassword'},
    {'1': 'newPassword', '3': 3, '4': 1, '5': 9, '10': 'newPassword'},
  ],
};

/// Descriptor for `ChangeAdminPasswordReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeAdminPasswordReqDescriptor = $convert
    .base64Decode('ChZDaGFuZ2VBZG1pblBhc3N3b3JkUmVxEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEigKD2N1cn'
        'JlbnRQYXNzd29yZBgCIAEoCVIPY3VycmVudFBhc3N3b3JkEiAKC25ld1Bhc3N3b3JkGAMgASgJ'
        'UgtuZXdQYXNzd29yZA==');

@$core.Deprecated('Use changeAdminPasswordRespDescriptor instead')
const ChangeAdminPasswordResp$json = {
  '1': 'ChangeAdminPasswordResp',
};

/// Descriptor for `ChangeAdminPasswordResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeAdminPasswordRespDescriptor =
    $convert.base64Decode('ChdDaGFuZ2VBZG1pblBhc3N3b3JkUmVzcA==');

@$core.Deprecated('Use delAdminAccountReqDescriptor instead')
const DelAdminAccountReq$json = {
  '1': 'DelAdminAccountReq',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `DelAdminAccountReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delAdminAccountReqDescriptor =
    $convert.base64Decode('ChJEZWxBZG1pbkFjY291bnRSZXESGAoHdXNlcklEcxgBIAMoCVIHdXNlcklEcw==');

@$core.Deprecated('Use delAdminAccountRespDescriptor instead')
const DelAdminAccountResp$json = {
  '1': 'DelAdminAccountResp',
};

/// Descriptor for `DelAdminAccountResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delAdminAccountRespDescriptor =
    $convert.base64Decode('ChNEZWxBZG1pbkFjY291bnRSZXNw');

@$core.Deprecated('Use searchAdminAccountReqDescriptor instead')
const SearchAdminAccountReq$json = {
  '1': 'SearchAdminAccountReq',
  '2': [
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.RequestPagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `SearchAdminAccountReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchAdminAccountReqDescriptor = $convert
    .base64Decode('ChVTZWFyY2hBZG1pbkFjY291bnRSZXESPwoKcGFnaW5hdGlvbhgCIAEoCzIfLm9wZW5pbS5zZG'
        't3cy5SZXF1ZXN0UGFnaW5hdGlvblIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use searchAdminAccountRespDescriptor instead')
const SearchAdminAccountResp$json = {
  '1': 'SearchAdminAccountResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {
      '1': 'adminAccounts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.admin.GetAdminInfoResp',
      '10': 'adminAccounts'
    },
  ],
};

/// Descriptor for `SearchAdminAccountResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchAdminAccountRespDescriptor = $convert
    .base64Decode('ChZTZWFyY2hBZG1pbkFjY291bnRSZXNwEhQKBXRvdGFsGAEgASgNUgV0b3RhbBJECg1hZG1pbk'
        'FjY291bnRzGAIgAygLMh4ub3BlbmltLmFkbWluLkdldEFkbWluSW5mb1Jlc3BSDWFkbWluQWNj'
        'b3VudHM=');

@$core.Deprecated('Use getAdminInfoRespDescriptor instead')
const GetAdminInfoResp$json = {
  '1': 'GetAdminInfoResp',
  '2': [
    {'1': 'account', '3': 2, '4': 1, '5': 9, '10': 'account'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
    {'1': 'faceURL', '3': 4, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'nickname', '3': 5, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'userID', '3': 6, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'level', '3': 7, '4': 1, '5': 5, '10': 'level'},
    {'1': 'createTime', '3': 8, '4': 1, '5': 3, '10': 'createTime'},
  ],
};

/// Descriptor for `GetAdminInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAdminInfoRespDescriptor = $convert
    .base64Decode('ChBHZXRBZG1pbkluZm9SZXNwEhgKB2FjY291bnQYAiABKAlSB2FjY291bnQSGgoIcGFzc3dvcm'
        'QYAyABKAlSCHBhc3N3b3JkEhgKB2ZhY2VVUkwYBCABKAlSB2ZhY2VVUkwSGgoIbmlja25hbWUY'
        'BSABKAlSCG5pY2tuYW1lEhYKBnVzZXJJRBgGIAEoCVIGdXNlcklEEhQKBWxldmVsGAcgASgFUg'
        'VsZXZlbBIeCgpjcmVhdGVUaW1lGAggASgDUgpjcmVhdGVUaW1l');

@$core.Deprecated('Use addDefaultFriendReqDescriptor instead')
const AddDefaultFriendReq$json = {
  '1': 'AddDefaultFriendReq',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `AddDefaultFriendReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addDefaultFriendReqDescriptor =
    $convert.base64Decode('ChNBZGREZWZhdWx0RnJpZW5kUmVxEhgKB3VzZXJJRHMYASADKAlSB3VzZXJJRHM=');

@$core.Deprecated('Use addDefaultFriendRespDescriptor instead')
const AddDefaultFriendResp$json = {
  '1': 'AddDefaultFriendResp',
};

/// Descriptor for `AddDefaultFriendResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addDefaultFriendRespDescriptor =
    $convert.base64Decode('ChRBZGREZWZhdWx0RnJpZW5kUmVzcA==');

@$core.Deprecated('Use delDefaultFriendReqDescriptor instead')
const DelDefaultFriendReq$json = {
  '1': 'DelDefaultFriendReq',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `DelDefaultFriendReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delDefaultFriendReqDescriptor =
    $convert.base64Decode('ChNEZWxEZWZhdWx0RnJpZW5kUmVxEhgKB3VzZXJJRHMYASADKAlSB3VzZXJJRHM=');

@$core.Deprecated('Use delDefaultFriendRespDescriptor instead')
const DelDefaultFriendResp$json = {
  '1': 'DelDefaultFriendResp',
};

/// Descriptor for `DelDefaultFriendResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delDefaultFriendRespDescriptor =
    $convert.base64Decode('ChREZWxEZWZhdWx0RnJpZW5kUmVzcA==');

@$core.Deprecated('Use findDefaultFriendReqDescriptor instead')
const FindDefaultFriendReq$json = {
  '1': 'FindDefaultFriendReq',
};

/// Descriptor for `FindDefaultFriendReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findDefaultFriendReqDescriptor =
    $convert.base64Decode('ChRGaW5kRGVmYXVsdEZyaWVuZFJlcQ==');

@$core.Deprecated('Use findDefaultFriendRespDescriptor instead')
const FindDefaultFriendResp$json = {
  '1': 'FindDefaultFriendResp',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `FindDefaultFriendResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findDefaultFriendRespDescriptor =
    $convert.base64Decode('ChVGaW5kRGVmYXVsdEZyaWVuZFJlc3ASGAoHdXNlcklEcxgBIAMoCVIHdXNlcklEcw==');

@$core.Deprecated('Use searchDefaultFriendReqDescriptor instead')
const SearchDefaultFriendReq$json = {
  '1': 'SearchDefaultFriendReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.RequestPagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `SearchDefaultFriendReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchDefaultFriendReqDescriptor = $convert
    .base64Decode('ChZTZWFyY2hEZWZhdWx0RnJpZW5kUmVxEhgKB2tleXdvcmQYASABKAlSB2tleXdvcmQSPwoKcG'
        'FnaW5hdGlvbhgCIAEoCzIfLm9wZW5pbS5zZGt3cy5SZXF1ZXN0UGFnaW5hdGlvblIKcGFnaW5h'
        'dGlvbg==');

@$core.Deprecated('Use defaultFriendAttributeDescriptor instead')
const DefaultFriendAttribute$json = {
  '1': 'DefaultFriendAttribute',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'createTime', '3': 2, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'user', '3': 3, '4': 1, '5': 11, '6': '.openim.chat.common.UserPublicInfo', '10': 'user'},
  ],
};

/// Descriptor for `DefaultFriendAttribute`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defaultFriendAttributeDescriptor = $convert
    .base64Decode('ChZEZWZhdWx0RnJpZW5kQXR0cmlidXRlEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEh4KCmNyZW'
        'F0ZVRpbWUYAiABKANSCmNyZWF0ZVRpbWUSNgoEdXNlchgDIAEoCzIiLm9wZW5pbS5jaGF0LmNv'
        'bW1vbi5Vc2VyUHVibGljSW5mb1IEdXNlcg==');

@$core.Deprecated('Use searchDefaultFriendRespDescriptor instead')
const SearchDefaultFriendResp$json = {
  '1': 'SearchDefaultFriendResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {
      '1': 'users',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.admin.DefaultFriendAttribute',
      '10': 'users'
    },
  ],
};

/// Descriptor for `SearchDefaultFriendResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchDefaultFriendRespDescriptor = $convert
    .base64Decode('ChdTZWFyY2hEZWZhdWx0RnJpZW5kUmVzcBIUCgV0b3RhbBgBIAEoDVIFdG90YWwSOgoFdXNlcn'
        'MYAiADKAsyJC5vcGVuaW0uYWRtaW4uRGVmYXVsdEZyaWVuZEF0dHJpYnV0ZVIFdXNlcnM=');

@$core.Deprecated('Use addDefaultGroupReqDescriptor instead')
const AddDefaultGroupReq$json = {
  '1': 'AddDefaultGroupReq',
  '2': [
    {'1': 'groupIDs', '3': 1, '4': 3, '5': 9, '10': 'groupIDs'},
  ],
};

/// Descriptor for `AddDefaultGroupReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addDefaultGroupReqDescriptor =
    $convert.base64Decode('ChJBZGREZWZhdWx0R3JvdXBSZXESGgoIZ3JvdXBJRHMYASADKAlSCGdyb3VwSURz');

@$core.Deprecated('Use addDefaultGroupRespDescriptor instead')
const AddDefaultGroupResp$json = {
  '1': 'AddDefaultGroupResp',
};

/// Descriptor for `AddDefaultGroupResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addDefaultGroupRespDescriptor =
    $convert.base64Decode('ChNBZGREZWZhdWx0R3JvdXBSZXNw');

@$core.Deprecated('Use delDefaultGroupReqDescriptor instead')
const DelDefaultGroupReq$json = {
  '1': 'DelDefaultGroupReq',
  '2': [
    {'1': 'groupIDs', '3': 1, '4': 3, '5': 9, '10': 'groupIDs'},
  ],
};

/// Descriptor for `DelDefaultGroupReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delDefaultGroupReqDescriptor =
    $convert.base64Decode('ChJEZWxEZWZhdWx0R3JvdXBSZXESGgoIZ3JvdXBJRHMYASADKAlSCGdyb3VwSURz');

@$core.Deprecated('Use delDefaultGroupRespDescriptor instead')
const DelDefaultGroupResp$json = {
  '1': 'DelDefaultGroupResp',
};

/// Descriptor for `DelDefaultGroupResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delDefaultGroupRespDescriptor =
    $convert.base64Decode('ChNEZWxEZWZhdWx0R3JvdXBSZXNw');

@$core.Deprecated('Use findDefaultGroupReqDescriptor instead')
const FindDefaultGroupReq$json = {
  '1': 'FindDefaultGroupReq',
};

/// Descriptor for `FindDefaultGroupReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findDefaultGroupReqDescriptor =
    $convert.base64Decode('ChNGaW5kRGVmYXVsdEdyb3VwUmVx');

@$core.Deprecated('Use findDefaultGroupRespDescriptor instead')
const FindDefaultGroupResp$json = {
  '1': 'FindDefaultGroupResp',
  '2': [
    {'1': 'groupIDs', '3': 1, '4': 3, '5': 9, '10': 'groupIDs'},
  ],
};

/// Descriptor for `FindDefaultGroupResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findDefaultGroupRespDescriptor =
    $convert.base64Decode('ChRGaW5kRGVmYXVsdEdyb3VwUmVzcBIaCghncm91cElEcxgBIAMoCVIIZ3JvdXBJRHM=');

@$core.Deprecated('Use searchDefaultGroupReqDescriptor instead')
const SearchDefaultGroupReq$json = {
  '1': 'SearchDefaultGroupReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.RequestPagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `SearchDefaultGroupReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchDefaultGroupReqDescriptor = $convert
    .base64Decode('ChVTZWFyY2hEZWZhdWx0R3JvdXBSZXESGAoHa2V5d29yZBgBIAEoCVIHa2V5d29yZBI/CgpwYW'
        'dpbmF0aW9uGAIgASgLMh8ub3BlbmltLnNka3dzLlJlcXVlc3RQYWdpbmF0aW9uUgpwYWdpbmF0'
        'aW9u');

@$core.Deprecated('Use groupAttributeDescriptor instead')
const GroupAttribute$json = {
  '1': 'GroupAttribute',
  '2': [
    {'1': 'groupID', '3': 1, '4': 1, '5': 9, '10': 'groupID'},
    {'1': 'createTime', '3': 2, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'group', '3': 3, '4': 1, '5': 11, '6': '.openim.sdkws.GroupInfo', '10': 'group'},
  ],
};

/// Descriptor for `GroupAttribute`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupAttributeDescriptor = $convert
    .base64Decode('Cg5Hcm91cEF0dHJpYnV0ZRIYCgdncm91cElEGAEgASgJUgdncm91cElEEh4KCmNyZWF0ZVRpbW'
        'UYAiABKANSCmNyZWF0ZVRpbWUSLQoFZ3JvdXAYAyABKAsyFy5vcGVuaW0uc2Rrd3MuR3JvdXBJ'
        'bmZvUgVncm91cA==');

@$core.Deprecated('Use searchDefaultGroupRespDescriptor instead')
const SearchDefaultGroupResp$json = {
  '1': 'SearchDefaultGroupResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {'1': 'groupIDs', '3': 2, '4': 3, '5': 9, '10': 'groupIDs'},
  ],
};

/// Descriptor for `SearchDefaultGroupResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchDefaultGroupRespDescriptor = $convert
    .base64Decode('ChZTZWFyY2hEZWZhdWx0R3JvdXBSZXNwEhQKBXRvdGFsGAEgASgNUgV0b3RhbBIaCghncm91cE'
        'lEcxgCIAMoCVIIZ3JvdXBJRHM=');

@$core.Deprecated('Use addInvitationCodeReqDescriptor instead')
const AddInvitationCodeReq$json = {
  '1': 'AddInvitationCodeReq',
  '2': [
    {'1': 'codes', '3': 1, '4': 3, '5': 9, '10': 'codes'},
  ],
};

/// Descriptor for `AddInvitationCodeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addInvitationCodeReqDescriptor =
    $convert.base64Decode('ChRBZGRJbnZpdGF0aW9uQ29kZVJlcRIUCgVjb2RlcxgBIAMoCVIFY29kZXM=');

@$core.Deprecated('Use addInvitationCodeRespDescriptor instead')
const AddInvitationCodeResp$json = {
  '1': 'AddInvitationCodeResp',
};

/// Descriptor for `AddInvitationCodeResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addInvitationCodeRespDescriptor =
    $convert.base64Decode('ChVBZGRJbnZpdGF0aW9uQ29kZVJlc3A=');

@$core.Deprecated('Use genInvitationCodeReqDescriptor instead')
const GenInvitationCodeReq$json = {
  '1': 'GenInvitationCodeReq',
  '2': [
    {'1': 'len', '3': 1, '4': 1, '5': 5, '10': 'len'},
    {'1': 'num', '3': 2, '4': 1, '5': 5, '10': 'num'},
    {'1': 'chars', '3': 3, '4': 1, '5': 9, '10': 'chars'},
  ],
};

/// Descriptor for `GenInvitationCodeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genInvitationCodeReqDescriptor = $convert
    .base64Decode('ChRHZW5JbnZpdGF0aW9uQ29kZVJlcRIQCgNsZW4YASABKAVSA2xlbhIQCgNudW0YAiABKAVSA2'
        '51bRIUCgVjaGFycxgDIAEoCVIFY2hhcnM=');

@$core.Deprecated('Use genInvitationCodeRespDescriptor instead')
const GenInvitationCodeResp$json = {
  '1': 'GenInvitationCodeResp',
};

/// Descriptor for `GenInvitationCodeResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genInvitationCodeRespDescriptor =
    $convert.base64Decode('ChVHZW5JbnZpdGF0aW9uQ29kZVJlc3A=');

@$core.Deprecated('Use findInvitationCodeReqDescriptor instead')
const FindInvitationCodeReq$json = {
  '1': 'FindInvitationCodeReq',
  '2': [
    {'1': 'codes', '3': 1, '4': 3, '5': 9, '10': 'codes'},
  ],
};

/// Descriptor for `FindInvitationCodeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findInvitationCodeReqDescriptor =
    $convert.base64Decode('ChVGaW5kSW52aXRhdGlvbkNvZGVSZXESFAoFY29kZXMYASADKAlSBWNvZGVz');

@$core.Deprecated('Use findInvitationCodeRespDescriptor instead')
const FindInvitationCodeResp$json = {
  '1': 'FindInvitationCodeResp',
  '2': [
    {'1': 'codes', '3': 1, '4': 3, '5': 11, '6': '.openim.admin.InvitationRegister', '10': 'codes'},
  ],
};

/// Descriptor for `FindInvitationCodeResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findInvitationCodeRespDescriptor = $convert
    .base64Decode('ChZGaW5kSW52aXRhdGlvbkNvZGVSZXNwEjYKBWNvZGVzGAEgAygLMiAub3BlbmltLmFkbWluLk'
        'ludml0YXRpb25SZWdpc3RlclIFY29kZXM=');

@$core.Deprecated('Use useInvitationCodeReqDescriptor instead')
const UseInvitationCodeReq$json = {
  '1': 'UseInvitationCodeReq',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'userID', '3': 2, '4': 1, '5': 9, '10': 'userID'},
  ],
};

/// Descriptor for `UseInvitationCodeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List useInvitationCodeReqDescriptor = $convert
    .base64Decode('ChRVc2VJbnZpdGF0aW9uQ29kZVJlcRISCgRjb2RlGAEgASgJUgRjb2RlEhYKBnVzZXJJRBgCIA'
        'EoCVIGdXNlcklE');

@$core.Deprecated('Use useInvitationCodeRespDescriptor instead')
const UseInvitationCodeResp$json = {
  '1': 'UseInvitationCodeResp',
};

/// Descriptor for `UseInvitationCodeResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List useInvitationCodeRespDescriptor =
    $convert.base64Decode('ChVVc2VJbnZpdGF0aW9uQ29kZVJlc3A=');

@$core.Deprecated('Use delInvitationCodeReqDescriptor instead')
const DelInvitationCodeReq$json = {
  '1': 'DelInvitationCodeReq',
  '2': [
    {'1': 'codes', '3': 1, '4': 3, '5': 9, '10': 'codes'},
  ],
};

/// Descriptor for `DelInvitationCodeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delInvitationCodeReqDescriptor =
    $convert.base64Decode('ChREZWxJbnZpdGF0aW9uQ29kZVJlcRIUCgVjb2RlcxgBIAMoCVIFY29kZXM=');

@$core.Deprecated('Use delInvitationCodeRespDescriptor instead')
const DelInvitationCodeResp$json = {
  '1': 'DelInvitationCodeResp',
};

/// Descriptor for `DelInvitationCodeResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delInvitationCodeRespDescriptor =
    $convert.base64Decode('ChVEZWxJbnZpdGF0aW9uQ29kZVJlc3A=');

@$core.Deprecated('Use invitationRegisterDescriptor instead')
const InvitationRegister$json = {
  '1': 'InvitationRegister',
  '2': [
    {'1': 'invitationCode', '3': 1, '4': 1, '5': 9, '10': 'invitationCode'},
    {'1': 'createTime', '3': 2, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'usedUserID', '3': 3, '4': 1, '5': 9, '10': 'usedUserID'},
    {
      '1': 'usedUser',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.openim.chat.common.UserPublicInfo',
      '10': 'usedUser'
    },
  ],
};

/// Descriptor for `InvitationRegister`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invitationRegisterDescriptor = $convert
    .base64Decode('ChJJbnZpdGF0aW9uUmVnaXN0ZXISJgoOaW52aXRhdGlvbkNvZGUYASABKAlSDmludml0YXRpb2'
        '5Db2RlEh4KCmNyZWF0ZVRpbWUYAiABKANSCmNyZWF0ZVRpbWUSHgoKdXNlZFVzZXJJRBgDIAEo'
        'CVIKdXNlZFVzZXJJRBI+Cgh1c2VkVXNlchgEIAEoCzIiLm9wZW5pbS5jaGF0LmNvbW1vbi5Vc2'
        'VyUHVibGljSW5mb1IIdXNlZFVzZXI=');

@$core.Deprecated('Use searchInvitationCodeReqDescriptor instead')
const SearchInvitationCodeReq$json = {
  '1': 'SearchInvitationCodeReq',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
    {'1': 'userIDs', '3': 2, '4': 3, '5': 9, '10': 'userIDs'},
    {'1': 'codes', '3': 3, '4': 3, '5': 9, '10': 'codes'},
    {'1': 'keyword', '3': 4, '4': 1, '5': 9, '10': 'keyword'},
    {
      '1': 'pagination',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.RequestPagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `SearchInvitationCodeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchInvitationCodeReqDescriptor = $convert
    .base64Decode('ChdTZWFyY2hJbnZpdGF0aW9uQ29kZVJlcRIWCgZzdGF0dXMYASABKAVSBnN0YXR1cxIYCgd1c2'
        'VySURzGAIgAygJUgd1c2VySURzEhQKBWNvZGVzGAMgAygJUgVjb2RlcxIYCgdrZXl3b3JkGAQg'
        'ASgJUgdrZXl3b3JkEj8KCnBhZ2luYXRpb24YBSABKAsyHy5vcGVuaW0uc2Rrd3MuUmVxdWVzdF'
        'BhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use searchInvitationCodeRespDescriptor instead')
const SearchInvitationCodeResp$json = {
  '1': 'SearchInvitationCodeResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {'1': 'list', '3': 2, '4': 3, '5': 11, '6': '.openim.admin.InvitationRegister', '10': 'list'},
  ],
};

/// Descriptor for `SearchInvitationCodeResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchInvitationCodeRespDescriptor = $convert
    .base64Decode('ChhTZWFyY2hJbnZpdGF0aW9uQ29kZVJlc3ASFAoFdG90YWwYASABKA1SBXRvdGFsEjQKBGxpc3'
        'QYAiADKAsyIC5vcGVuaW0uYWRtaW4uSW52aXRhdGlvblJlZ2lzdGVyUgRsaXN0');

@$core.Deprecated('Use searchUserIPLimitLoginReqDescriptor instead')
const SearchUserIPLimitLoginReq$json = {
  '1': 'SearchUserIPLimitLoginReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.RequestPagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `SearchUserIPLimitLoginReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchUserIPLimitLoginReqDescriptor = $convert
    .base64Decode('ChlTZWFyY2hVc2VySVBMaW1pdExvZ2luUmVxEhgKB2tleXdvcmQYASABKAlSB2tleXdvcmQSPw'
        'oKcGFnaW5hdGlvbhgCIAEoCzIfLm9wZW5pbS5zZGt3cy5SZXF1ZXN0UGFnaW5hdGlvblIKcGFn'
        'aW5hdGlvbg==');

@$core.Deprecated('Use limitUserLoginIPDescriptor instead')
const LimitUserLoginIP$json = {
  '1': 'LimitUserLoginIP',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'ip', '3': 2, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'createTime', '3': 3, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'user', '3': 4, '4': 1, '5': 11, '6': '.openim.chat.common.UserPublicInfo', '10': 'user'},
  ],
};

/// Descriptor for `LimitUserLoginIP`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List limitUserLoginIPDescriptor = $convert
    .base64Decode('ChBMaW1pdFVzZXJMb2dpbklQEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEg4KAmlwGAIgASgJUg'
        'JpcBIeCgpjcmVhdGVUaW1lGAMgASgDUgpjcmVhdGVUaW1lEjYKBHVzZXIYBCABKAsyIi5vcGVu'
        'aW0uY2hhdC5jb21tb24uVXNlclB1YmxpY0luZm9SBHVzZXI=');

@$core.Deprecated('Use searchUserIPLimitLoginRespDescriptor instead')
const SearchUserIPLimitLoginResp$json = {
  '1': 'SearchUserIPLimitLoginResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {'1': 'limits', '3': 2, '4': 3, '5': 11, '6': '.openim.admin.LimitUserLoginIP', '10': 'limits'},
  ],
};

/// Descriptor for `SearchUserIPLimitLoginResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchUserIPLimitLoginRespDescriptor = $convert
    .base64Decode('ChpTZWFyY2hVc2VySVBMaW1pdExvZ2luUmVzcBIUCgV0b3RhbBgBIAEoDVIFdG90YWwSNgoGbG'
        'ltaXRzGAIgAygLMh4ub3BlbmltLmFkbWluLkxpbWl0VXNlckxvZ2luSVBSBmxpbWl0cw==');

@$core.Deprecated('Use userIPLimitLoginDescriptor instead')
const UserIPLimitLogin$json = {
  '1': 'UserIPLimitLogin',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'ip', '3': 2, '4': 1, '5': 9, '10': 'ip'},
  ],
};

/// Descriptor for `UserIPLimitLogin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userIPLimitLoginDescriptor = $convert
    .base64Decode('ChBVc2VySVBMaW1pdExvZ2luEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEg4KAmlwGAIgASgJUg'
        'JpcA==');

@$core.Deprecated('Use addUserIPLimitLoginReqDescriptor instead')
const AddUserIPLimitLoginReq$json = {
  '1': 'AddUserIPLimitLoginReq',
  '2': [
    {'1': 'limits', '3': 1, '4': 3, '5': 11, '6': '.openim.admin.UserIPLimitLogin', '10': 'limits'},
  ],
};

/// Descriptor for `AddUserIPLimitLoginReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addUserIPLimitLoginReqDescriptor = $convert
    .base64Decode('ChZBZGRVc2VySVBMaW1pdExvZ2luUmVxEjYKBmxpbWl0cxgBIAMoCzIeLm9wZW5pbS5hZG1pbi'
        '5Vc2VySVBMaW1pdExvZ2luUgZsaW1pdHM=');

@$core.Deprecated('Use addUserIPLimitLoginRespDescriptor instead')
const AddUserIPLimitLoginResp$json = {
  '1': 'AddUserIPLimitLoginResp',
};

/// Descriptor for `AddUserIPLimitLoginResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addUserIPLimitLoginRespDescriptor =
    $convert.base64Decode('ChdBZGRVc2VySVBMaW1pdExvZ2luUmVzcA==');

@$core.Deprecated('Use delUserIPLimitLoginReqDescriptor instead')
const DelUserIPLimitLoginReq$json = {
  '1': 'DelUserIPLimitLoginReq',
  '2': [
    {'1': 'limits', '3': 1, '4': 3, '5': 11, '6': '.openim.admin.UserIPLimitLogin', '10': 'limits'},
  ],
};

/// Descriptor for `DelUserIPLimitLoginReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delUserIPLimitLoginReqDescriptor = $convert
    .base64Decode('ChZEZWxVc2VySVBMaW1pdExvZ2luUmVxEjYKBmxpbWl0cxgBIAMoCzIeLm9wZW5pbS5hZG1pbi'
        '5Vc2VySVBMaW1pdExvZ2luUgZsaW1pdHM=');

@$core.Deprecated('Use delUserIPLimitLoginRespDescriptor instead')
const DelUserIPLimitLoginResp$json = {
  '1': 'DelUserIPLimitLoginResp',
};

/// Descriptor for `DelUserIPLimitLoginResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delUserIPLimitLoginRespDescriptor =
    $convert.base64Decode('ChdEZWxVc2VySVBMaW1pdExvZ2luUmVzcA==');

@$core.Deprecated('Use iPForbiddenDescriptor instead')
const IPForbidden$json = {
  '1': 'IPForbidden',
  '2': [
    {'1': 'ip', '3': 1, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'limitRegister', '3': 2, '4': 1, '5': 8, '10': 'limitRegister'},
    {'1': 'limitLogin', '3': 3, '4': 1, '5': 8, '10': 'limitLogin'},
    {'1': 'createTime', '3': 4, '4': 1, '5': 3, '10': 'createTime'},
  ],
};

/// Descriptor for `IPForbidden`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iPForbiddenDescriptor = $convert
    .base64Decode('CgtJUEZvcmJpZGRlbhIOCgJpcBgBIAEoCVICaXASJAoNbGltaXRSZWdpc3RlchgCIAEoCFINbG'
        'ltaXRSZWdpc3RlchIeCgpsaW1pdExvZ2luGAMgASgIUgpsaW1pdExvZ2luEh4KCmNyZWF0ZVRp'
        'bWUYBCABKANSCmNyZWF0ZVRpbWU=');

@$core.Deprecated('Use iPForbiddenAddDescriptor instead')
const IPForbiddenAdd$json = {
  '1': 'IPForbiddenAdd',
  '2': [
    {'1': 'ip', '3': 1, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'limitRegister', '3': 2, '4': 1, '5': 8, '10': 'limitRegister'},
    {'1': 'limitLogin', '3': 3, '4': 1, '5': 8, '10': 'limitLogin'},
  ],
};

/// Descriptor for `IPForbiddenAdd`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iPForbiddenAddDescriptor = $convert
    .base64Decode('Cg5JUEZvcmJpZGRlbkFkZBIOCgJpcBgBIAEoCVICaXASJAoNbGltaXRSZWdpc3RlchgCIAEoCF'
        'INbGltaXRSZWdpc3RlchIeCgpsaW1pdExvZ2luGAMgASgIUgpsaW1pdExvZ2lu');

@$core.Deprecated('Use searchIPForbiddenReqDescriptor instead')
const SearchIPForbiddenReq$json = {
  '1': 'SearchIPForbiddenReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {'1': 'status', '3': 2, '4': 1, '5': 5, '10': 'status'},
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.RequestPagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `SearchIPForbiddenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchIPForbiddenReqDescriptor = $convert
    .base64Decode('ChRTZWFyY2hJUEZvcmJpZGRlblJlcRIYCgdrZXl3b3JkGAEgASgJUgdrZXl3b3JkEhYKBnN0YX'
        'R1cxgCIAEoBVIGc3RhdHVzEj8KCnBhZ2luYXRpb24YAyABKAsyHy5vcGVuaW0uc2Rrd3MuUmVx'
        'dWVzdFBhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use searchIPForbiddenRespDescriptor instead')
const SearchIPForbiddenResp$json = {
  '1': 'SearchIPForbiddenResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {
      '1': 'forbiddens',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.admin.IPForbidden',
      '10': 'forbiddens'
    },
  ],
};

/// Descriptor for `SearchIPForbiddenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchIPForbiddenRespDescriptor = $convert
    .base64Decode('ChVTZWFyY2hJUEZvcmJpZGRlblJlc3ASFAoFdG90YWwYASABKA1SBXRvdGFsEjkKCmZvcmJpZG'
        'RlbnMYAiADKAsyGS5vcGVuaW0uYWRtaW4uSVBGb3JiaWRkZW5SCmZvcmJpZGRlbnM=');

@$core.Deprecated('Use addIPForbiddenReqDescriptor instead')
const AddIPForbiddenReq$json = {
  '1': 'AddIPForbiddenReq',
  '2': [
    {
      '1': 'forbiddens',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.admin.IPForbiddenAdd',
      '10': 'forbiddens'
    },
  ],
};

/// Descriptor for `AddIPForbiddenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addIPForbiddenReqDescriptor = $convert
    .base64Decode('ChFBZGRJUEZvcmJpZGRlblJlcRI8Cgpmb3JiaWRkZW5zGAEgAygLMhwub3BlbmltLmFkbWluLk'
        'lQRm9yYmlkZGVuQWRkUgpmb3JiaWRkZW5z');

@$core.Deprecated('Use addIPForbiddenRespDescriptor instead')
const AddIPForbiddenResp$json = {
  '1': 'AddIPForbiddenResp',
};

/// Descriptor for `AddIPForbiddenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addIPForbiddenRespDescriptor =
    $convert.base64Decode('ChJBZGRJUEZvcmJpZGRlblJlc3A=');

@$core.Deprecated('Use delIPForbiddenReqDescriptor instead')
const DelIPForbiddenReq$json = {
  '1': 'DelIPForbiddenReq',
  '2': [
    {'1': 'ips', '3': 1, '4': 3, '5': 9, '10': 'ips'},
  ],
};

/// Descriptor for `DelIPForbiddenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delIPForbiddenReqDescriptor =
    $convert.base64Decode('ChFEZWxJUEZvcmJpZGRlblJlcRIQCgNpcHMYASADKAlSA2lwcw==');

@$core.Deprecated('Use delIPForbiddenRespDescriptor instead')
const DelIPForbiddenResp$json = {
  '1': 'DelIPForbiddenResp',
};

/// Descriptor for `DelIPForbiddenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delIPForbiddenRespDescriptor =
    $convert.base64Decode('ChJEZWxJUEZvcmJpZGRlblJlc3A=');

@$core.Deprecated('Use checkRegisterForbiddenReqDescriptor instead')
const CheckRegisterForbiddenReq$json = {
  '1': 'CheckRegisterForbiddenReq',
  '2': [
    {'1': 'ip', '3': 1, '4': 1, '5': 9, '10': 'ip'},
  ],
};

/// Descriptor for `CheckRegisterForbiddenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkRegisterForbiddenReqDescriptor =
    $convert.base64Decode('ChlDaGVja1JlZ2lzdGVyRm9yYmlkZGVuUmVxEg4KAmlwGAEgASgJUgJpcA==');

@$core.Deprecated('Use checkRegisterForbiddenRespDescriptor instead')
const CheckRegisterForbiddenResp$json = {
  '1': 'CheckRegisterForbiddenResp',
};

/// Descriptor for `CheckRegisterForbiddenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkRegisterForbiddenRespDescriptor =
    $convert.base64Decode('ChpDaGVja1JlZ2lzdGVyRm9yYmlkZGVuUmVzcA==');

@$core.Deprecated('Use checkLoginForbiddenReqDescriptor instead')
const CheckLoginForbiddenReq$json = {
  '1': 'CheckLoginForbiddenReq',
  '2': [
    {'1': 'ip', '3': 1, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'userID', '3': 2, '4': 1, '5': 9, '10': 'userID'},
  ],
};

/// Descriptor for `CheckLoginForbiddenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkLoginForbiddenReqDescriptor = $convert
    .base64Decode('ChZDaGVja0xvZ2luRm9yYmlkZGVuUmVxEg4KAmlwGAEgASgJUgJpcBIWCgZ1c2VySUQYAiABKA'
        'lSBnVzZXJJRA==');

@$core.Deprecated('Use checkLoginForbiddenRespDescriptor instead')
const CheckLoginForbiddenResp$json = {
  '1': 'CheckLoginForbiddenResp',
};

/// Descriptor for `CheckLoginForbiddenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkLoginForbiddenRespDescriptor =
    $convert.base64Decode('ChdDaGVja0xvZ2luRm9yYmlkZGVuUmVzcA==');

@$core.Deprecated('Use cancellationUserReqDescriptor instead')
const CancellationUserReq$json = {
  '1': 'CancellationUserReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancellationUserReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancellationUserReqDescriptor = $convert
    .base64Decode('ChNDYW5jZWxsYXRpb25Vc2VyUmVxEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEhYKBnJlYXNvbh'
        'gCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use cancellationUserRespDescriptor instead')
const CancellationUserResp$json = {
  '1': 'CancellationUserResp',
};

/// Descriptor for `CancellationUserResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancellationUserRespDescriptor =
    $convert.base64Decode('ChRDYW5jZWxsYXRpb25Vc2VyUmVzcA==');

@$core.Deprecated('Use blockUserReqDescriptor instead')
const BlockUserReq$json = {
  '1': 'BlockUserReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `BlockUserReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockUserReqDescriptor = $convert
    .base64Decode('CgxCbG9ja1VzZXJSZXESFgoGdXNlcklEGAEgASgJUgZ1c2VySUQSFgoGcmVhc29uGAIgASgJUg'
        'ZyZWFzb24=');

@$core.Deprecated('Use blockUserRespDescriptor instead')
const BlockUserResp$json = {
  '1': 'BlockUserResp',
};

/// Descriptor for `BlockUserResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockUserRespDescriptor = $convert.base64Decode('Cg1CbG9ja1VzZXJSZXNw');

@$core.Deprecated('Use unblockUserReqDescriptor instead')
const UnblockUserReq$json = {
  '1': 'UnblockUserReq',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `UnblockUserReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unblockUserReqDescriptor =
    $convert.base64Decode('Cg5VbmJsb2NrVXNlclJlcRIYCgd1c2VySURzGAEgAygJUgd1c2VySURz');

@$core.Deprecated('Use unblockUserRespDescriptor instead')
const UnblockUserResp$json = {
  '1': 'UnblockUserResp',
};

/// Descriptor for `UnblockUserResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unblockUserRespDescriptor =
    $convert.base64Decode('Cg9VbmJsb2NrVXNlclJlc3A=');

@$core.Deprecated('Use searchBlockUserReqDescriptor instead')
const SearchBlockUserReq$json = {
  '1': 'SearchBlockUserReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.RequestPagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `SearchBlockUserReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchBlockUserReqDescriptor = $convert
    .base64Decode('ChJTZWFyY2hCbG9ja1VzZXJSZXESGAoHa2V5d29yZBgBIAEoCVIHa2V5d29yZBI/CgpwYWdpbm'
        'F0aW9uGAIgASgLMh8ub3BlbmltLnNka3dzLlJlcXVlc3RQYWdpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use blockUserInfoDescriptor instead')
const BlockUserInfo$json = {
  '1': 'BlockUserInfo',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'account', '3': 2, '4': 1, '5': 9, '10': 'account'},
    {'1': 'phoneNumber', '3': 3, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'areaCode', '3': 4, '4': 1, '5': 9, '10': 'areaCode'},
    {'1': 'email', '3': 5, '4': 1, '5': 9, '10': 'email'},
    {'1': 'nickname', '3': 6, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'faceURL', '3': 7, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'gender', '3': 8, '4': 1, '5': 5, '10': 'gender'},
    {'1': 'reason', '3': 9, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'opUserID', '3': 10, '4': 1, '5': 9, '10': 'opUserID'},
    {'1': 'createTime', '3': 11, '4': 1, '5': 3, '10': 'createTime'},
  ],
};

/// Descriptor for `BlockUserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockUserInfoDescriptor = $convert
    .base64Decode('Cg1CbG9ja1VzZXJJbmZvEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEhgKB2FjY291bnQYAiABKA'
        'lSB2FjY291bnQSIAoLcGhvbmVOdW1iZXIYAyABKAlSC3Bob25lTnVtYmVyEhoKCGFyZWFDb2Rl'
        'GAQgASgJUghhcmVhQ29kZRIUCgVlbWFpbBgFIAEoCVIFZW1haWwSGgoIbmlja25hbWUYBiABKA'
        'lSCG5pY2tuYW1lEhgKB2ZhY2VVUkwYByABKAlSB2ZhY2VVUkwSFgoGZ2VuZGVyGAggASgFUgZn'
        'ZW5kZXISFgoGcmVhc29uGAkgASgJUgZyZWFzb24SGgoIb3BVc2VySUQYCiABKAlSCG9wVXNlck'
        'lEEh4KCmNyZWF0ZVRpbWUYCyABKANSCmNyZWF0ZVRpbWU=');

@$core.Deprecated('Use searchBlockUserRespDescriptor instead')
const SearchBlockUserResp$json = {
  '1': 'SearchBlockUserResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {'1': 'users', '3': 2, '4': 3, '5': 11, '6': '.openim.admin.BlockUserInfo', '10': 'users'},
  ],
};

/// Descriptor for `SearchBlockUserResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchBlockUserRespDescriptor = $convert
    .base64Decode('ChNTZWFyY2hCbG9ja1VzZXJSZXNwEhQKBXRvdGFsGAEgASgNUgV0b3RhbBIxCgV1c2VycxgCIA'
        'MoCzIbLm9wZW5pbS5hZG1pbi5CbG9ja1VzZXJJbmZvUgV1c2Vycw==');

@$core.Deprecated('Use findUserBlockInfoReqDescriptor instead')
const FindUserBlockInfoReq$json = {
  '1': 'FindUserBlockInfoReq',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `FindUserBlockInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findUserBlockInfoReqDescriptor =
    $convert.base64Decode('ChRGaW5kVXNlckJsb2NrSW5mb1JlcRIYCgd1c2VySURzGAEgAygJUgd1c2VySURz');

@$core.Deprecated('Use blockInfoDescriptor instead')
const BlockInfo$json = {
  '1': 'BlockInfo',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'opUserID', '3': 3, '4': 1, '5': 9, '10': 'opUserID'},
    {'1': 'createTime', '3': 4, '4': 1, '5': 3, '10': 'createTime'},
  ],
};

/// Descriptor for `BlockInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockInfoDescriptor = $convert
    .base64Decode('CglCbG9ja0luZm8SFgoGdXNlcklEGAEgASgJUgZ1c2VySUQSFgoGcmVhc29uGAIgASgJUgZyZW'
        'Fzb24SGgoIb3BVc2VySUQYAyABKAlSCG9wVXNlcklEEh4KCmNyZWF0ZVRpbWUYBCABKANSCmNy'
        'ZWF0ZVRpbWU=');

@$core.Deprecated('Use findUserBlockInfoRespDescriptor instead')
const FindUserBlockInfoResp$json = {
  '1': 'FindUserBlockInfoResp',
  '2': [
    {'1': 'blocks', '3': 2, '4': 3, '5': 11, '6': '.openim.admin.BlockInfo', '10': 'blocks'},
  ],
};

/// Descriptor for `FindUserBlockInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findUserBlockInfoRespDescriptor = $convert
    .base64Decode('ChVGaW5kVXNlckJsb2NrSW5mb1Jlc3ASLwoGYmxvY2tzGAIgAygLMhcub3BlbmltLmFkbWluLk'
        'Jsb2NrSW5mb1IGYmxvY2tz');

@$core.Deprecated('Use createTokenReqDescriptor instead')
const CreateTokenReq$json = {
  '1': 'CreateTokenReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'userType', '3': 32, '4': 1, '5': 5, '10': 'userType'},
  ],
};

/// Descriptor for `CreateTokenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTokenReqDescriptor = $convert
    .base64Decode('Cg5DcmVhdGVUb2tlblJlcRIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBIaCgh1c2VyVHlwZRggIA'
        'EoBVIIdXNlclR5cGU=');

@$core.Deprecated('Use createTokenRespDescriptor instead')
const CreateTokenResp$json = {
  '1': 'CreateTokenResp',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `CreateTokenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTokenRespDescriptor =
    $convert.base64Decode('Cg9DcmVhdGVUb2tlblJlc3ASFAoFdG9rZW4YASABKAlSBXRva2Vu');

@$core.Deprecated('Use parseTokenReqDescriptor instead')
const ParseTokenReq$json = {
  '1': 'ParseTokenReq',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `ParseTokenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parseTokenReqDescriptor =
    $convert.base64Decode('Cg1QYXJzZVRva2VuUmVxEhQKBXRva2VuGAEgASgJUgV0b2tlbg==');

@$core.Deprecated('Use parseTokenRespDescriptor instead')
const ParseTokenResp$json = {
  '1': 'ParseTokenResp',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'userType', '3': 2, '4': 1, '5': 5, '10': 'userType'},
    {'1': 'expireTimeSeconds', '3': 3, '4': 1, '5': 3, '10': 'expireTimeSeconds'},
  ],
};

/// Descriptor for `ParseTokenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List parseTokenRespDescriptor = $convert
    .base64Decode('Cg5QYXJzZVRva2VuUmVzcBIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBIaCgh1c2VyVHlwZRgCIA'
        'EoBVIIdXNlclR5cGUSLAoRZXhwaXJlVGltZVNlY29uZHMYAyABKANSEWV4cGlyZVRpbWVTZWNv'
        'bmRz');

@$core.Deprecated('Use invalidateTokenReqDescriptor instead')
const InvalidateTokenReq$json = {
  '1': 'InvalidateTokenReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
  ],
};

/// Descriptor for `InvalidateTokenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invalidateTokenReqDescriptor =
    $convert.base64Decode('ChJJbnZhbGlkYXRlVG9rZW5SZXESFgoGdXNlcklEGAEgASgJUgZ1c2VySUQ=');

@$core.Deprecated('Use invalidateTokenRespDescriptor instead')
const InvalidateTokenResp$json = {
  '1': 'InvalidateTokenResp',
};

/// Descriptor for `InvalidateTokenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invalidateTokenRespDescriptor =
    $convert.base64Decode('ChNJbnZhbGlkYXRlVG9rZW5SZXNw');

@$core.Deprecated('Use addAppletReqDescriptor instead')
const AddAppletReq$json = {
  '1': 'AddAppletReq',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'appID', '3': 3, '4': 1, '5': 9, '10': 'appID'},
    {'1': 'icon', '3': 4, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'url', '3': 5, '4': 1, '5': 9, '10': 'url'},
    {'1': 'md5', '3': 6, '4': 1, '5': 9, '10': 'md5'},
    {'1': 'size', '3': 7, '4': 1, '5': 3, '10': 'size'},
    {'1': 'version', '3': 8, '4': 1, '5': 9, '10': 'version'},
    {'1': 'priority', '3': 9, '4': 1, '5': 13, '10': 'priority'},
    {'1': 'status', '3': 10, '4': 1, '5': 13, '10': 'status'},
    {'1': 'createTime', '3': 11, '4': 1, '5': 3, '10': 'createTime'},
  ],
};

/// Descriptor for `AddAppletReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAppletReqDescriptor = $convert
    .base64Decode('CgxBZGRBcHBsZXRSZXESDgoCaWQYASABKAlSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWUSFAoFYX'
        'BwSUQYAyABKAlSBWFwcElEEhIKBGljb24YBCABKAlSBGljb24SEAoDdXJsGAUgASgJUgN1cmwS'
        'EAoDbWQ1GAYgASgJUgNtZDUSEgoEc2l6ZRgHIAEoA1IEc2l6ZRIYCgd2ZXJzaW9uGAggASgJUg'
        'd2ZXJzaW9uEhoKCHByaW9yaXR5GAkgASgNUghwcmlvcml0eRIWCgZzdGF0dXMYCiABKA1SBnN0'
        'YXR1cxIeCgpjcmVhdGVUaW1lGAsgASgDUgpjcmVhdGVUaW1l');

@$core.Deprecated('Use addAppletRespDescriptor instead')
const AddAppletResp$json = {
  '1': 'AddAppletResp',
};

/// Descriptor for `AddAppletResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAppletRespDescriptor = $convert.base64Decode('Cg1BZGRBcHBsZXRSZXNw');

@$core.Deprecated('Use delAppletReqDescriptor instead')
const DelAppletReq$json = {
  '1': 'DelAppletReq',
  '2': [
    {'1': 'appletIds', '3': 1, '4': 3, '5': 9, '10': 'appletIds'},
  ],
};

/// Descriptor for `DelAppletReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delAppletReqDescriptor =
    $convert.base64Decode('CgxEZWxBcHBsZXRSZXESHAoJYXBwbGV0SWRzGAEgAygJUglhcHBsZXRJZHM=');

@$core.Deprecated('Use delAppletRespDescriptor instead')
const DelAppletResp$json = {
  '1': 'DelAppletResp',
};

/// Descriptor for `DelAppletResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delAppletRespDescriptor = $convert.base64Decode('Cg1EZWxBcHBsZXRSZXNw');

@$core.Deprecated('Use updateAppletReqDescriptor instead')
const UpdateAppletReq$json = {
  '1': 'UpdateAppletReq',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'name'},
    {'1': 'appID', '3': 3, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'appID'},
    {'1': 'icon', '3': 4, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'icon'},
    {'1': 'url', '3': 5, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'url'},
    {'1': 'md5', '3': 6, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'md5'},
    {'1': 'size', '3': 7, '4': 1, '5': 11, '6': '.openim.protobuf.Int64Value', '10': 'size'},
    {'1': 'version', '3': 8, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'version'},
    {
      '1': 'priority',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.UInt32Value',
      '10': 'priority'
    },
    {'1': 'status', '3': 10, '4': 1, '5': 11, '6': '.openim.protobuf.UInt32Value', '10': 'status'},
    {
      '1': 'createTime',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int64Value',
      '10': 'createTime'
    },
  ],
};

/// Descriptor for `UpdateAppletReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAppletReqDescriptor = $convert
    .base64Decode('Cg9VcGRhdGVBcHBsZXRSZXESDgoCaWQYASABKAlSAmlkEjAKBG5hbWUYAiABKAsyHC5vcGVuaW'
        '0ucHJvdG9idWYuU3RyaW5nVmFsdWVSBG5hbWUSMgoFYXBwSUQYAyABKAsyHC5vcGVuaW0ucHJv'
        'dG9idWYuU3RyaW5nVmFsdWVSBWFwcElEEjAKBGljb24YBCABKAsyHC5vcGVuaW0ucHJvdG9idW'
        'YuU3RyaW5nVmFsdWVSBGljb24SLgoDdXJsGAUgASgLMhwub3BlbmltLnByb3RvYnVmLlN0cmlu'
        'Z1ZhbHVlUgN1cmwSLgoDbWQ1GAYgASgLMhwub3BlbmltLnByb3RvYnVmLlN0cmluZ1ZhbHVlUg'
        'NtZDUSLwoEc2l6ZRgHIAEoCzIbLm9wZW5pbS5wcm90b2J1Zi5JbnQ2NFZhbHVlUgRzaXplEjYK'
        'B3ZlcnNpb24YCCABKAsyHC5vcGVuaW0ucHJvdG9idWYuU3RyaW5nVmFsdWVSB3ZlcnNpb24SOA'
        'oIcHJpb3JpdHkYCSABKAsyHC5vcGVuaW0ucHJvdG9idWYuVUludDMyVmFsdWVSCHByaW9yaXR5'
        'EjQKBnN0YXR1cxgKIAEoCzIcLm9wZW5pbS5wcm90b2J1Zi5VSW50MzJWYWx1ZVIGc3RhdHVzEj'
        'sKCmNyZWF0ZVRpbWUYCyABKAsyGy5vcGVuaW0ucHJvdG9idWYuSW50NjRWYWx1ZVIKY3JlYXRl'
        'VGltZQ==');

@$core.Deprecated('Use updateAppletRespDescriptor instead')
const UpdateAppletResp$json = {
  '1': 'UpdateAppletResp',
};

/// Descriptor for `UpdateAppletResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAppletRespDescriptor =
    $convert.base64Decode('ChBVcGRhdGVBcHBsZXRSZXNw');

@$core.Deprecated('Use findAppletReqDescriptor instead')
const FindAppletReq$json = {
  '1': 'FindAppletReq',
};

/// Descriptor for `FindAppletReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findAppletReqDescriptor = $convert.base64Decode('Cg1GaW5kQXBwbGV0UmVx');

@$core.Deprecated('Use findAppletRespDescriptor instead')
const FindAppletResp$json = {
  '1': 'FindAppletResp',
  '2': [
    {
      '1': 'applets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.common.AppletInfo',
      '10': 'applets'
    },
  ],
};

/// Descriptor for `FindAppletResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findAppletRespDescriptor = $convert
    .base64Decode('Cg5GaW5kQXBwbGV0UmVzcBI4CgdhcHBsZXRzGAEgAygLMh4ub3BlbmltLmNoYXQuY29tbW9uLk'
        'FwcGxldEluZm9SB2FwcGxldHM=');

@$core.Deprecated('Use searchAppletReqDescriptor instead')
const SearchAppletReq$json = {
  '1': 'SearchAppletReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.RequestPagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `SearchAppletReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchAppletReqDescriptor = $convert
    .base64Decode('Cg9TZWFyY2hBcHBsZXRSZXESGAoHa2V5d29yZBgBIAEoCVIHa2V5d29yZBI/CgpwYWdpbmF0aW'
        '9uGAIgASgLMh8ub3BlbmltLnNka3dzLlJlcXVlc3RQYWdpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use searchAppletRespDescriptor instead')
const SearchAppletResp$json = {
  '1': 'SearchAppletResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {
      '1': 'applets',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.common.AppletInfo',
      '10': 'applets'
    },
  ],
};

/// Descriptor for `SearchAppletResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchAppletRespDescriptor = $convert
    .base64Decode('ChBTZWFyY2hBcHBsZXRSZXNwEhQKBXRvdGFsGAEgASgNUgV0b3RhbBI4CgdhcHBsZXRzGAIgAy'
        'gLMh4ub3BlbmltLmNoYXQuY29tbW9uLkFwcGxldEluZm9SB2FwcGxldHM=');

@$core.Deprecated('Use setClientConfigReqDescriptor instead')
const SetClientConfigReq$json = {
  '1': 'SetClientConfigReq',
  '2': [
    {
      '1': 'config',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.admin.SetClientConfigReq.ConfigEntry',
      '10': 'config'
    },
  ],
  '3': [SetClientConfigReq_ConfigEntry$json],
};

@$core.Deprecated('Use setClientConfigReqDescriptor instead')
const SetClientConfigReq_ConfigEntry$json = {
  '1': 'ConfigEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SetClientConfigReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setClientConfigReqDescriptor = $convert
    .base64Decode('ChJTZXRDbGllbnRDb25maWdSZXESRAoGY29uZmlnGAEgAygLMiwub3BlbmltLmFkbWluLlNldE'
        'NsaWVudENvbmZpZ1JlcS5Db25maWdFbnRyeVIGY29uZmlnGjkKC0NvbmZpZ0VudHJ5EhAKA2tl'
        'eRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use setClientConfigRespDescriptor instead')
const SetClientConfigResp$json = {
  '1': 'SetClientConfigResp',
};

/// Descriptor for `SetClientConfigResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setClientConfigRespDescriptor =
    $convert.base64Decode('ChNTZXRDbGllbnRDb25maWdSZXNw');

@$core.Deprecated('Use delClientConfigReqDescriptor instead')
const DelClientConfigReq$json = {
  '1': 'DelClientConfigReq',
  '2': [
    {'1': 'keys', '3': 1, '4': 3, '5': 9, '10': 'keys'},
  ],
};

/// Descriptor for `DelClientConfigReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delClientConfigReqDescriptor =
    $convert.base64Decode('ChJEZWxDbGllbnRDb25maWdSZXESEgoEa2V5cxgBIAMoCVIEa2V5cw==');

@$core.Deprecated('Use delClientConfigRespDescriptor instead')
const DelClientConfigResp$json = {
  '1': 'DelClientConfigResp',
};

/// Descriptor for `DelClientConfigResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delClientConfigRespDescriptor =
    $convert.base64Decode('ChNEZWxDbGllbnRDb25maWdSZXNw');

@$core.Deprecated('Use getClientConfigReqDescriptor instead')
const GetClientConfigReq$json = {
  '1': 'GetClientConfigReq',
};

/// Descriptor for `GetClientConfigReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getClientConfigReqDescriptor =
    $convert.base64Decode('ChJHZXRDbGllbnRDb25maWdSZXE=');

@$core.Deprecated('Use getClientConfigRespDescriptor instead')
const GetClientConfigResp$json = {
  '1': 'GetClientConfigResp',
  '2': [
    {
      '1': 'config',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.admin.GetClientConfigResp.ConfigEntry',
      '10': 'config'
    },
  ],
  '3': [GetClientConfigResp_ConfigEntry$json],
};

@$core.Deprecated('Use getClientConfigRespDescriptor instead')
const GetClientConfigResp_ConfigEntry$json = {
  '1': 'ConfigEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `GetClientConfigResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getClientConfigRespDescriptor = $convert
    .base64Decode('ChNHZXRDbGllbnRDb25maWdSZXNwEkUKBmNvbmZpZxgBIAMoCzItLm9wZW5pbS5hZG1pbi5HZX'
        'RDbGllbnRDb25maWdSZXNwLkNvbmZpZ0VudHJ5UgZjb25maWcaOQoLQ29uZmlnRW50cnkSEAoD'
        'a2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use getUserTokenReqDescriptor instead')
const GetUserTokenReq$json = {
  '1': 'GetUserTokenReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
  ],
};

/// Descriptor for `GetUserTokenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserTokenReqDescriptor =
    $convert.base64Decode('Cg9HZXRVc2VyVG9rZW5SZXESFgoGdXNlcklEGAEgASgJUgZ1c2VySUQ=');

@$core.Deprecated('Use getUserTokenRespDescriptor instead')
const GetUserTokenResp$json = {
  '1': 'GetUserTokenResp',
  '2': [
    {
      '1': 'tokensMap',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.admin.GetUserTokenResp.TokensMapEntry',
      '10': 'tokensMap'
    },
  ],
  '3': [GetUserTokenResp_TokensMapEntry$json],
};

@$core.Deprecated('Use getUserTokenRespDescriptor instead')
const GetUserTokenResp_TokensMapEntry$json = {
  '1': 'TokensMapEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `GetUserTokenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserTokenRespDescriptor = $convert
    .base64Decode('ChBHZXRVc2VyVG9rZW5SZXNwEksKCXRva2Vuc01hcBgBIAMoCzItLm9wZW5pbS5hZG1pbi5HZX'
        'RVc2VyVG9rZW5SZXNwLlRva2Vuc01hcEVudHJ5Ugl0b2tlbnNNYXAaPAoOVG9rZW5zTWFwRW50'
        'cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAVSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use applicationVersionDescriptor instead')
const ApplicationVersion$json = {
  '1': 'ApplicationVersion',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
    {'1': 'text', '3': 5, '4': 1, '5': 9, '10': 'text'},
    {'1': 'force', '3': 6, '4': 1, '5': 8, '10': 'force'},
    {'1': 'latest', '3': 7, '4': 1, '5': 8, '10': 'latest'},
    {'1': 'hot', '3': 8, '4': 1, '5': 8, '10': 'hot'},
    {'1': 'createTime', '3': 9, '4': 1, '5': 3, '10': 'createTime'},
  ],
};

/// Descriptor for `ApplicationVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationVersionDescriptor = $convert
    .base64Decode('ChJBcHBsaWNhdGlvblZlcnNpb24SDgoCaWQYASABKAlSAmlkEhoKCHBsYXRmb3JtGAIgASgJUg'
        'hwbGF0Zm9ybRIYCgd2ZXJzaW9uGAMgASgJUgd2ZXJzaW9uEhAKA3VybBgEIAEoCVIDdXJsEhIK'
        'BHRleHQYBSABKAlSBHRleHQSFAoFZm9yY2UYBiABKAhSBWZvcmNlEhYKBmxhdGVzdBgHIAEoCF'
        'IGbGF0ZXN0EhAKA2hvdBgIIAEoCFIDaG90Eh4KCmNyZWF0ZVRpbWUYCSABKANSCmNyZWF0ZVRp'
        'bWU=');

@$core.Deprecated('Use latestApplicationVersionReqDescriptor instead')
const LatestApplicationVersionReq$json = {
  '1': 'LatestApplicationVersionReq',
  '2': [
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `LatestApplicationVersionReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latestApplicationVersionReqDescriptor = $convert
    .base64Decode('ChtMYXRlc3RBcHBsaWNhdGlvblZlcnNpb25SZXESGgoIcGxhdGZvcm0YAiABKAlSCHBsYXRmb3'
        'JtEhgKB3ZlcnNpb24YAyABKAlSB3ZlcnNpb24=');

@$core.Deprecated('Use latestApplicationVersionRespDescriptor instead')
const LatestApplicationVersionResp$json = {
  '1': 'LatestApplicationVersionResp',
  '2': [
    {
      '1': 'version',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.admin.ApplicationVersion',
      '10': 'version'
    },
  ],
};

/// Descriptor for `LatestApplicationVersionResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latestApplicationVersionRespDescriptor = $convert
    .base64Decode('ChxMYXRlc3RBcHBsaWNhdGlvblZlcnNpb25SZXNwEjoKB3ZlcnNpb24YASABKAsyIC5vcGVuaW'
        '0uYWRtaW4uQXBwbGljYXRpb25WZXJzaW9uUgd2ZXJzaW9u');

@$core.Deprecated('Use addApplicationVersionReqDescriptor instead')
const AddApplicationVersionReq$json = {
  '1': 'AddApplicationVersionReq',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
    {'1': 'text', '3': 4, '4': 1, '5': 9, '10': 'text'},
    {'1': 'force', '3': 5, '4': 1, '5': 8, '10': 'force'},
    {'1': 'latest', '3': 6, '4': 1, '5': 8, '10': 'latest'},
    {'1': 'hot', '3': 7, '4': 1, '5': 8, '10': 'hot'},
  ],
};

/// Descriptor for `AddApplicationVersionReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addApplicationVersionReqDescriptor = $convert
    .base64Decode('ChhBZGRBcHBsaWNhdGlvblZlcnNpb25SZXESGgoIcGxhdGZvcm0YASABKAlSCHBsYXRmb3JtEh'
        'gKB3ZlcnNpb24YAiABKAlSB3ZlcnNpb24SEAoDdXJsGAMgASgJUgN1cmwSEgoEdGV4dBgEIAEo'
        'CVIEdGV4dBIUCgVmb3JjZRgFIAEoCFIFZm9yY2USFgoGbGF0ZXN0GAYgASgIUgZsYXRlc3QSEA'
        'oDaG90GAcgASgIUgNob3Q=');

@$core.Deprecated('Use addApplicationVersionRespDescriptor instead')
const AddApplicationVersionResp$json = {
  '1': 'AddApplicationVersionResp',
};

/// Descriptor for `AddApplicationVersionResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addApplicationVersionRespDescriptor =
    $convert.base64Decode('ChlBZGRBcHBsaWNhdGlvblZlcnNpb25SZXNw');

@$core.Deprecated('Use updateApplicationVersionReqDescriptor instead')
const UpdateApplicationVersionReq$json = {
  '1': 'UpdateApplicationVersionReq',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'platform',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'platform'
    },
    {'1': 'version', '3': 3, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'version'},
    {'1': 'url', '3': 4, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'url'},
    {'1': 'text', '3': 5, '4': 1, '5': 11, '6': '.openim.protobuf.StringValue', '10': 'text'},
    {'1': 'force', '3': 6, '4': 1, '5': 11, '6': '.openim.protobuf.BoolValue', '10': 'force'},
    {'1': 'latest', '3': 7, '4': 1, '5': 11, '6': '.openim.protobuf.BoolValue', '10': 'latest'},
    {'1': 'hot', '3': 8, '4': 1, '5': 11, '6': '.openim.protobuf.BoolValue', '10': 'hot'},
  ],
};

/// Descriptor for `UpdateApplicationVersionReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateApplicationVersionReqDescriptor = $convert
    .base64Decode('ChtVcGRhdGVBcHBsaWNhdGlvblZlcnNpb25SZXESDgoCaWQYASABKAlSAmlkEjgKCHBsYXRmb3'
        'JtGAIgASgLMhwub3BlbmltLnByb3RvYnVmLlN0cmluZ1ZhbHVlUghwbGF0Zm9ybRI2Cgd2ZXJz'
        'aW9uGAMgASgLMhwub3BlbmltLnByb3RvYnVmLlN0cmluZ1ZhbHVlUgd2ZXJzaW9uEi4KA3VybB'
        'gEIAEoCzIcLm9wZW5pbS5wcm90b2J1Zi5TdHJpbmdWYWx1ZVIDdXJsEjAKBHRleHQYBSABKAsy'
        'HC5vcGVuaW0ucHJvdG9idWYuU3RyaW5nVmFsdWVSBHRleHQSMAoFZm9yY2UYBiABKAsyGi5vcG'
        'VuaW0ucHJvdG9idWYuQm9vbFZhbHVlUgVmb3JjZRIyCgZsYXRlc3QYByABKAsyGi5vcGVuaW0u'
        'cHJvdG9idWYuQm9vbFZhbHVlUgZsYXRlc3QSLAoDaG90GAggASgLMhoub3BlbmltLnByb3RvYn'
        'VmLkJvb2xWYWx1ZVIDaG90');

@$core.Deprecated('Use updateApplicationVersionRespDescriptor instead')
const UpdateApplicationVersionResp$json = {
  '1': 'UpdateApplicationVersionResp',
};

/// Descriptor for `UpdateApplicationVersionResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateApplicationVersionRespDescriptor =
    $convert.base64Decode('ChxVcGRhdGVBcHBsaWNhdGlvblZlcnNpb25SZXNw');

@$core.Deprecated('Use deleteApplicationVersionReqDescriptor instead')
const DeleteApplicationVersionReq$json = {
  '1': 'DeleteApplicationVersionReq',
  '2': [
    {'1': 'id', '3': 1, '4': 3, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteApplicationVersionReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteApplicationVersionReqDescriptor =
    $convert.base64Decode('ChtEZWxldGVBcHBsaWNhdGlvblZlcnNpb25SZXESDgoCaWQYASADKAlSAmlk');

@$core.Deprecated('Use deleteApplicationVersionRespDescriptor instead')
const DeleteApplicationVersionResp$json = {
  '1': 'DeleteApplicationVersionResp',
};

/// Descriptor for `DeleteApplicationVersionResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteApplicationVersionRespDescriptor =
    $convert.base64Decode('ChxEZWxldGVBcHBsaWNhdGlvblZlcnNpb25SZXNw');

@$core.Deprecated('Use pageApplicationVersionReqDescriptor instead')
const PageApplicationVersionReq$json = {
  '1': 'PageApplicationVersionReq',
  '2': [
    {'1': 'platform', '3': 1, '4': 3, '5': 9, '10': 'platform'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.sdkws.RequestPagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `PageApplicationVersionReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pageApplicationVersionReqDescriptor = $convert
    .base64Decode('ChlQYWdlQXBwbGljYXRpb25WZXJzaW9uUmVxEhoKCHBsYXRmb3JtGAEgAygJUghwbGF0Zm9ybR'
        'I/CgpwYWdpbmF0aW9uGAIgASgLMh8ub3BlbmltLnNka3dzLlJlcXVlc3RQYWdpbmF0aW9uUgpw'
        'YWdpbmF0aW9u');

@$core.Deprecated('Use pageApplicationVersionRespDescriptor instead')
const PageApplicationVersionResp$json = {
  '1': 'PageApplicationVersionResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 3, '10': 'total'},
    {
      '1': 'versions',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.admin.ApplicationVersion',
      '10': 'versions'
    },
  ],
};

/// Descriptor for `PageApplicationVersionResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pageApplicationVersionRespDescriptor = $convert
    .base64Decode('ChpQYWdlQXBwbGljYXRpb25WZXJzaW9uUmVzcBIUCgV0b3RhbBgBIAEoA1IFdG90YWwSPAoIdm'
        'Vyc2lvbnMYAiADKAsyIC5vcGVuaW0uYWRtaW4uQXBwbGljYXRpb25WZXJzaW9uUgh2ZXJzaW9u'
        'cw==');

const $core.Map<$core.String, $core.dynamic> adminServiceBase$json = {
  '1': 'admin',
  '2': [
    {'1': 'Login', '2': '.openim.admin.LoginReq', '3': '.openim.admin.LoginResp'},
    {
      '1': 'ChangePassword',
      '2': '.openim.admin.ChangePasswordReq',
      '3': '.openim.admin.ChangePasswordResp'
    },
    {
      '1': 'AdminUpdateInfo',
      '2': '.openim.admin.AdminUpdateInfoReq',
      '3': '.openim.admin.AdminUpdateInfoResp'
    },
    {
      '1': 'GetAdminInfo',
      '2': '.openim.admin.GetAdminInfoReq',
      '3': '.openim.admin.GetAdminInfoResp'
    },
    {
      '1': 'AddAdminAccount',
      '2': '.openim.admin.AddAdminAccountReq',
      '3': '.openim.admin.AddAdminAccountResp'
    },
    {
      '1': 'ChangeAdminPassword',
      '2': '.openim.admin.ChangeAdminPasswordReq',
      '3': '.openim.admin.ChangeAdminPasswordResp'
    },
    {
      '1': 'DelAdminAccount',
      '2': '.openim.admin.DelAdminAccountReq',
      '3': '.openim.admin.DelAdminAccountResp'
    },
    {
      '1': 'SearchAdminAccount',
      '2': '.openim.admin.SearchAdminAccountReq',
      '3': '.openim.admin.SearchAdminAccountResp'
    },
    {
      '1': 'AddDefaultFriend',
      '2': '.openim.admin.AddDefaultFriendReq',
      '3': '.openim.admin.AddDefaultFriendResp'
    },
    {
      '1': 'DelDefaultFriend',
      '2': '.openim.admin.DelDefaultFriendReq',
      '3': '.openim.admin.DelDefaultFriendResp'
    },
    {
      '1': 'FindDefaultFriend',
      '2': '.openim.admin.FindDefaultFriendReq',
      '3': '.openim.admin.FindDefaultFriendResp'
    },
    {
      '1': 'SearchDefaultFriend',
      '2': '.openim.admin.SearchDefaultFriendReq',
      '3': '.openim.admin.SearchDefaultFriendResp'
    },
    {
      '1': 'AddDefaultGroup',
      '2': '.openim.admin.AddDefaultGroupReq',
      '3': '.openim.admin.AddDefaultGroupResp'
    },
    {
      '1': 'DelDefaultGroup',
      '2': '.openim.admin.DelDefaultGroupReq',
      '3': '.openim.admin.DelDefaultGroupResp'
    },
    {
      '1': 'FindDefaultGroup',
      '2': '.openim.admin.FindDefaultGroupReq',
      '3': '.openim.admin.FindDefaultGroupResp'
    },
    {
      '1': 'SearchDefaultGroup',
      '2': '.openim.admin.SearchDefaultGroupReq',
      '3': '.openim.admin.SearchDefaultGroupResp'
    },
    {
      '1': 'AddInvitationCode',
      '2': '.openim.admin.AddInvitationCodeReq',
      '3': '.openim.admin.AddInvitationCodeResp'
    },
    {
      '1': 'GenInvitationCode',
      '2': '.openim.admin.GenInvitationCodeReq',
      '3': '.openim.admin.GenInvitationCodeResp'
    },
    {
      '1': 'FindInvitationCode',
      '2': '.openim.admin.FindInvitationCodeReq',
      '3': '.openim.admin.FindInvitationCodeResp'
    },
    {
      '1': 'UseInvitationCode',
      '2': '.openim.admin.UseInvitationCodeReq',
      '3': '.openim.admin.UseInvitationCodeResp'
    },
    {
      '1': 'DelInvitationCode',
      '2': '.openim.admin.DelInvitationCodeReq',
      '3': '.openim.admin.DelInvitationCodeResp'
    },
    {
      '1': 'SearchInvitationCode',
      '2': '.openim.admin.SearchInvitationCodeReq',
      '3': '.openim.admin.SearchInvitationCodeResp'
    },
    {
      '1': 'SearchUserIPLimitLogin',
      '2': '.openim.admin.SearchUserIPLimitLoginReq',
      '3': '.openim.admin.SearchUserIPLimitLoginResp'
    },
    {
      '1': 'AddUserIPLimitLogin',
      '2': '.openim.admin.AddUserIPLimitLoginReq',
      '3': '.openim.admin.AddUserIPLimitLoginResp'
    },
    {
      '1': 'DelUserIPLimitLogin',
      '2': '.openim.admin.DelUserIPLimitLoginReq',
      '3': '.openim.admin.DelUserIPLimitLoginResp'
    },
    {
      '1': 'SearchIPForbidden',
      '2': '.openim.admin.SearchIPForbiddenReq',
      '3': '.openim.admin.SearchIPForbiddenResp'
    },
    {
      '1': 'AddIPForbidden',
      '2': '.openim.admin.AddIPForbiddenReq',
      '3': '.openim.admin.AddIPForbiddenResp'
    },
    {
      '1': 'DelIPForbidden',
      '2': '.openim.admin.DelIPForbiddenReq',
      '3': '.openim.admin.DelIPForbiddenResp'
    },
    {
      '1': 'CancellationUser',
      '2': '.openim.admin.CancellationUserReq',
      '3': '.openim.admin.CancellationUserResp'
    },
    {'1': 'BlockUser', '2': '.openim.admin.BlockUserReq', '3': '.openim.admin.BlockUserResp'},
    {'1': 'UnblockUser', '2': '.openim.admin.UnblockUserReq', '3': '.openim.admin.UnblockUserResp'},
    {
      '1': 'SearchBlockUser',
      '2': '.openim.admin.SearchBlockUserReq',
      '3': '.openim.admin.SearchBlockUserResp'
    },
    {
      '1': 'FindUserBlockInfo',
      '2': '.openim.admin.FindUserBlockInfoReq',
      '3': '.openim.admin.FindUserBlockInfoResp'
    },
    {
      '1': 'CheckRegisterForbidden',
      '2': '.openim.admin.CheckRegisterForbiddenReq',
      '3': '.openim.admin.CheckRegisterForbiddenResp'
    },
    {
      '1': 'CheckLoginForbidden',
      '2': '.openim.admin.CheckLoginForbiddenReq',
      '3': '.openim.admin.CheckLoginForbiddenResp'
    },
    {'1': 'CreateToken', '2': '.openim.admin.CreateTokenReq', '3': '.openim.admin.CreateTokenResp'},
    {'1': 'ParseToken', '2': '.openim.admin.ParseTokenReq', '3': '.openim.admin.ParseTokenResp'},
    {'1': 'AddApplet', '2': '.openim.admin.AddAppletReq', '3': '.openim.admin.AddAppletResp'},
    {'1': 'DelApplet', '2': '.openim.admin.DelAppletReq', '3': '.openim.admin.DelAppletResp'},
    {
      '1': 'UpdateApplet',
      '2': '.openim.admin.UpdateAppletReq',
      '3': '.openim.admin.UpdateAppletResp'
    },
    {'1': 'FindApplet', '2': '.openim.admin.FindAppletReq', '3': '.openim.admin.FindAppletResp'},
    {
      '1': 'SearchApplet',
      '2': '.openim.admin.SearchAppletReq',
      '3': '.openim.admin.SearchAppletResp'
    },
    {
      '1': 'GetClientConfig',
      '2': '.openim.admin.GetClientConfigReq',
      '3': '.openim.admin.GetClientConfigResp'
    },
    {
      '1': 'SetClientConfig',
      '2': '.openim.admin.SetClientConfigReq',
      '3': '.openim.admin.SetClientConfigResp'
    },
    {
      '1': 'DelClientConfig',
      '2': '.openim.admin.DelClientConfigReq',
      '3': '.openim.admin.DelClientConfigResp'
    },
    {
      '1': 'GetUserToken',
      '2': '.openim.admin.GetUserTokenReq',
      '3': '.openim.admin.GetUserTokenResp'
    },
    {
      '1': 'InvalidateToken',
      '2': '.openim.admin.InvalidateTokenReq',
      '3': '.openim.admin.InvalidateTokenResp'
    },
    {
      '1': 'LatestApplicationVersion',
      '2': '.openim.admin.LatestApplicationVersionReq',
      '3': '.openim.admin.LatestApplicationVersionResp'
    },
    {
      '1': 'AddApplicationVersion',
      '2': '.openim.admin.AddApplicationVersionReq',
      '3': '.openim.admin.AddApplicationVersionResp'
    },
    {
      '1': 'UpdateApplicationVersion',
      '2': '.openim.admin.UpdateApplicationVersionReq',
      '3': '.openim.admin.UpdateApplicationVersionResp'
    },
    {
      '1': 'DeleteApplicationVersion',
      '2': '.openim.admin.DeleteApplicationVersionReq',
      '3': '.openim.admin.DeleteApplicationVersionResp'
    },
    {
      '1': 'PageApplicationVersion',
      '2': '.openim.admin.PageApplicationVersionReq',
      '3': '.openim.admin.PageApplicationVersionResp'
    },
  ],
};

@$core.Deprecated('Use adminServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> adminServiceBase$messageJson =
    {
  '.openim.admin.LoginReq': LoginReq$json,
  '.openim.admin.LoginResp': LoginResp$json,
  '.openim.admin.ChangePasswordReq': ChangePasswordReq$json,
  '.openim.admin.ChangePasswordResp': ChangePasswordResp$json,
  '.openim.admin.AdminUpdateInfoReq': AdminUpdateInfoReq$json,
  '.openim.protobuf.StringValue': $0.StringValue$json,
  '.openim.protobuf.Int32Value': $0.Int32Value$json,
  '.openim.admin.AdminUpdateInfoResp': AdminUpdateInfoResp$json,
  '.openim.admin.GetAdminInfoReq': GetAdminInfoReq$json,
  '.openim.admin.GetAdminInfoResp': GetAdminInfoResp$json,
  '.openim.admin.AddAdminAccountReq': AddAdminAccountReq$json,
  '.openim.admin.AddAdminAccountResp': AddAdminAccountResp$json,
  '.openim.admin.ChangeAdminPasswordReq': ChangeAdminPasswordReq$json,
  '.openim.admin.ChangeAdminPasswordResp': ChangeAdminPasswordResp$json,
  '.openim.admin.DelAdminAccountReq': DelAdminAccountReq$json,
  '.openim.admin.DelAdminAccountResp': DelAdminAccountResp$json,
  '.openim.admin.SearchAdminAccountReq': SearchAdminAccountReq$json,
  '.openim.sdkws.RequestPagination': $1.RequestPagination$json,
  '.openim.admin.SearchAdminAccountResp': SearchAdminAccountResp$json,
  '.openim.admin.AddDefaultFriendReq': AddDefaultFriendReq$json,
  '.openim.admin.AddDefaultFriendResp': AddDefaultFriendResp$json,
  '.openim.admin.DelDefaultFriendReq': DelDefaultFriendReq$json,
  '.openim.admin.DelDefaultFriendResp': DelDefaultFriendResp$json,
  '.openim.admin.FindDefaultFriendReq': FindDefaultFriendReq$json,
  '.openim.admin.FindDefaultFriendResp': FindDefaultFriendResp$json,
  '.openim.admin.SearchDefaultFriendReq': SearchDefaultFriendReq$json,
  '.openim.admin.SearchDefaultFriendResp': SearchDefaultFriendResp$json,
  '.openim.admin.DefaultFriendAttribute': DefaultFriendAttribute$json,
  '.openim.chat.common.UserPublicInfo': $2.UserPublicInfo$json,
  '.openim.admin.AddDefaultGroupReq': AddDefaultGroupReq$json,
  '.openim.admin.AddDefaultGroupResp': AddDefaultGroupResp$json,
  '.openim.admin.DelDefaultGroupReq': DelDefaultGroupReq$json,
  '.openim.admin.DelDefaultGroupResp': DelDefaultGroupResp$json,
  '.openim.admin.FindDefaultGroupReq': FindDefaultGroupReq$json,
  '.openim.admin.FindDefaultGroupResp': FindDefaultGroupResp$json,
  '.openim.admin.SearchDefaultGroupReq': SearchDefaultGroupReq$json,
  '.openim.admin.SearchDefaultGroupResp': SearchDefaultGroupResp$json,
  '.openim.admin.AddInvitationCodeReq': AddInvitationCodeReq$json,
  '.openim.admin.AddInvitationCodeResp': AddInvitationCodeResp$json,
  '.openim.admin.GenInvitationCodeReq': GenInvitationCodeReq$json,
  '.openim.admin.GenInvitationCodeResp': GenInvitationCodeResp$json,
  '.openim.admin.FindInvitationCodeReq': FindInvitationCodeReq$json,
  '.openim.admin.FindInvitationCodeResp': FindInvitationCodeResp$json,
  '.openim.admin.InvitationRegister': InvitationRegister$json,
  '.openim.admin.UseInvitationCodeReq': UseInvitationCodeReq$json,
  '.openim.admin.UseInvitationCodeResp': UseInvitationCodeResp$json,
  '.openim.admin.DelInvitationCodeReq': DelInvitationCodeReq$json,
  '.openim.admin.DelInvitationCodeResp': DelInvitationCodeResp$json,
  '.openim.admin.SearchInvitationCodeReq': SearchInvitationCodeReq$json,
  '.openim.admin.SearchInvitationCodeResp': SearchInvitationCodeResp$json,
  '.openim.admin.SearchUserIPLimitLoginReq': SearchUserIPLimitLoginReq$json,
  '.openim.admin.SearchUserIPLimitLoginResp': SearchUserIPLimitLoginResp$json,
  '.openim.admin.LimitUserLoginIP': LimitUserLoginIP$json,
  '.openim.admin.AddUserIPLimitLoginReq': AddUserIPLimitLoginReq$json,
  '.openim.admin.UserIPLimitLogin': UserIPLimitLogin$json,
  '.openim.admin.AddUserIPLimitLoginResp': AddUserIPLimitLoginResp$json,
  '.openim.admin.DelUserIPLimitLoginReq': DelUserIPLimitLoginReq$json,
  '.openim.admin.DelUserIPLimitLoginResp': DelUserIPLimitLoginResp$json,
  '.openim.admin.SearchIPForbiddenReq': SearchIPForbiddenReq$json,
  '.openim.admin.SearchIPForbiddenResp': SearchIPForbiddenResp$json,
  '.openim.admin.IPForbidden': IPForbidden$json,
  '.openim.admin.AddIPForbiddenReq': AddIPForbiddenReq$json,
  '.openim.admin.IPForbiddenAdd': IPForbiddenAdd$json,
  '.openim.admin.AddIPForbiddenResp': AddIPForbiddenResp$json,
  '.openim.admin.DelIPForbiddenReq': DelIPForbiddenReq$json,
  '.openim.admin.DelIPForbiddenResp': DelIPForbiddenResp$json,
  '.openim.admin.CancellationUserReq': CancellationUserReq$json,
  '.openim.admin.CancellationUserResp': CancellationUserResp$json,
  '.openim.admin.BlockUserReq': BlockUserReq$json,
  '.openim.admin.BlockUserResp': BlockUserResp$json,
  '.openim.admin.UnblockUserReq': UnblockUserReq$json,
  '.openim.admin.UnblockUserResp': UnblockUserResp$json,
  '.openim.admin.SearchBlockUserReq': SearchBlockUserReq$json,
  '.openim.admin.SearchBlockUserResp': SearchBlockUserResp$json,
  '.openim.admin.BlockUserInfo': BlockUserInfo$json,
  '.openim.admin.FindUserBlockInfoReq': FindUserBlockInfoReq$json,
  '.openim.admin.FindUserBlockInfoResp': FindUserBlockInfoResp$json,
  '.openim.admin.BlockInfo': BlockInfo$json,
  '.openim.admin.CheckRegisterForbiddenReq': CheckRegisterForbiddenReq$json,
  '.openim.admin.CheckRegisterForbiddenResp': CheckRegisterForbiddenResp$json,
  '.openim.admin.CheckLoginForbiddenReq': CheckLoginForbiddenReq$json,
  '.openim.admin.CheckLoginForbiddenResp': CheckLoginForbiddenResp$json,
  '.openim.admin.CreateTokenReq': CreateTokenReq$json,
  '.openim.admin.CreateTokenResp': CreateTokenResp$json,
  '.openim.admin.ParseTokenReq': ParseTokenReq$json,
  '.openim.admin.ParseTokenResp': ParseTokenResp$json,
  '.openim.admin.AddAppletReq': AddAppletReq$json,
  '.openim.admin.AddAppletResp': AddAppletResp$json,
  '.openim.admin.DelAppletReq': DelAppletReq$json,
  '.openim.admin.DelAppletResp': DelAppletResp$json,
  '.openim.admin.UpdateAppletReq': UpdateAppletReq$json,
  '.openim.protobuf.Int64Value': $0.Int64Value$json,
  '.openim.protobuf.UInt32Value': $0.UInt32Value$json,
  '.openim.admin.UpdateAppletResp': UpdateAppletResp$json,
  '.openim.admin.FindAppletReq': FindAppletReq$json,
  '.openim.admin.FindAppletResp': FindAppletResp$json,
  '.openim.chat.common.AppletInfo': $2.AppletInfo$json,
  '.openim.admin.SearchAppletReq': SearchAppletReq$json,
  '.openim.admin.SearchAppletResp': SearchAppletResp$json,
  '.openim.admin.GetClientConfigReq': GetClientConfigReq$json,
  '.openim.admin.GetClientConfigResp': GetClientConfigResp$json,
  '.openim.admin.GetClientConfigResp.ConfigEntry': GetClientConfigResp_ConfigEntry$json,
  '.openim.admin.SetClientConfigReq': SetClientConfigReq$json,
  '.openim.admin.SetClientConfigReq.ConfigEntry': SetClientConfigReq_ConfigEntry$json,
  '.openim.admin.SetClientConfigResp': SetClientConfigResp$json,
  '.openim.admin.DelClientConfigReq': DelClientConfigReq$json,
  '.openim.admin.DelClientConfigResp': DelClientConfigResp$json,
  '.openim.admin.GetUserTokenReq': GetUserTokenReq$json,
  '.openim.admin.GetUserTokenResp': GetUserTokenResp$json,
  '.openim.admin.GetUserTokenResp.TokensMapEntry': GetUserTokenResp_TokensMapEntry$json,
  '.openim.admin.InvalidateTokenReq': InvalidateTokenReq$json,
  '.openim.admin.InvalidateTokenResp': InvalidateTokenResp$json,
  '.openim.admin.LatestApplicationVersionReq': LatestApplicationVersionReq$json,
  '.openim.admin.LatestApplicationVersionResp': LatestApplicationVersionResp$json,
  '.openim.admin.ApplicationVersion': ApplicationVersion$json,
  '.openim.admin.AddApplicationVersionReq': AddApplicationVersionReq$json,
  '.openim.admin.AddApplicationVersionResp': AddApplicationVersionResp$json,
  '.openim.admin.UpdateApplicationVersionReq': UpdateApplicationVersionReq$json,
  '.openim.protobuf.BoolValue': $0.BoolValue$json,
  '.openim.admin.UpdateApplicationVersionResp': UpdateApplicationVersionResp$json,
  '.openim.admin.DeleteApplicationVersionReq': DeleteApplicationVersionReq$json,
  '.openim.admin.DeleteApplicationVersionResp': DeleteApplicationVersionResp$json,
  '.openim.admin.PageApplicationVersionReq': PageApplicationVersionReq$json,
  '.openim.admin.PageApplicationVersionResp': PageApplicationVersionResp$json,
};

/// Descriptor for `admin`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List adminServiceDescriptor = $convert
    .base64Decode('CgVhZG1pbhI4CgVMb2dpbhIWLm9wZW5pbS5hZG1pbi5Mb2dpblJlcRoXLm9wZW5pbS5hZG1pbi'
        '5Mb2dpblJlc3ASUwoOQ2hhbmdlUGFzc3dvcmQSHy5vcGVuaW0uYWRtaW4uQ2hhbmdlUGFzc3dv'
        'cmRSZXEaIC5vcGVuaW0uYWRtaW4uQ2hhbmdlUGFzc3dvcmRSZXNwElYKD0FkbWluVXBkYXRlSW'
        '5mbxIgLm9wZW5pbS5hZG1pbi5BZG1pblVwZGF0ZUluZm9SZXEaIS5vcGVuaW0uYWRtaW4uQWRt'
        'aW5VcGRhdGVJbmZvUmVzcBJNCgxHZXRBZG1pbkluZm8SHS5vcGVuaW0uYWRtaW4uR2V0QWRtaW'
        '5JbmZvUmVxGh4ub3BlbmltLmFkbWluLkdldEFkbWluSW5mb1Jlc3ASVgoPQWRkQWRtaW5BY2Nv'
        'dW50EiAub3BlbmltLmFkbWluLkFkZEFkbWluQWNjb3VudFJlcRohLm9wZW5pbS5hZG1pbi5BZG'
        'RBZG1pbkFjY291bnRSZXNwEmIKE0NoYW5nZUFkbWluUGFzc3dvcmQSJC5vcGVuaW0uYWRtaW4u'
        'Q2hhbmdlQWRtaW5QYXNzd29yZFJlcRolLm9wZW5pbS5hZG1pbi5DaGFuZ2VBZG1pblBhc3N3b3'
        'JkUmVzcBJWCg9EZWxBZG1pbkFjY291bnQSIC5vcGVuaW0uYWRtaW4uRGVsQWRtaW5BY2NvdW50'
        'UmVxGiEub3BlbmltLmFkbWluLkRlbEFkbWluQWNjb3VudFJlc3ASXwoSU2VhcmNoQWRtaW5BY2'
        'NvdW50EiMub3BlbmltLmFkbWluLlNlYXJjaEFkbWluQWNjb3VudFJlcRokLm9wZW5pbS5hZG1p'
        'bi5TZWFyY2hBZG1pbkFjY291bnRSZXNwElkKEEFkZERlZmF1bHRGcmllbmQSIS5vcGVuaW0uYW'
        'RtaW4uQWRkRGVmYXVsdEZyaWVuZFJlcRoiLm9wZW5pbS5hZG1pbi5BZGREZWZhdWx0RnJpZW5k'
        'UmVzcBJZChBEZWxEZWZhdWx0RnJpZW5kEiEub3BlbmltLmFkbWluLkRlbERlZmF1bHRGcmllbm'
        'RSZXEaIi5vcGVuaW0uYWRtaW4uRGVsRGVmYXVsdEZyaWVuZFJlc3ASXAoRRmluZERlZmF1bHRG'
        'cmllbmQSIi5vcGVuaW0uYWRtaW4uRmluZERlZmF1bHRGcmllbmRSZXEaIy5vcGVuaW0uYWRtaW'
        '4uRmluZERlZmF1bHRGcmllbmRSZXNwEmIKE1NlYXJjaERlZmF1bHRGcmllbmQSJC5vcGVuaW0u'
        'YWRtaW4uU2VhcmNoRGVmYXVsdEZyaWVuZFJlcRolLm9wZW5pbS5hZG1pbi5TZWFyY2hEZWZhdW'
        'x0RnJpZW5kUmVzcBJWCg9BZGREZWZhdWx0R3JvdXASIC5vcGVuaW0uYWRtaW4uQWRkRGVmYXVs'
        'dEdyb3VwUmVxGiEub3BlbmltLmFkbWluLkFkZERlZmF1bHRHcm91cFJlc3ASVgoPRGVsRGVmYX'
        'VsdEdyb3VwEiAub3BlbmltLmFkbWluLkRlbERlZmF1bHRHcm91cFJlcRohLm9wZW5pbS5hZG1p'
        'bi5EZWxEZWZhdWx0R3JvdXBSZXNwElkKEEZpbmREZWZhdWx0R3JvdXASIS5vcGVuaW0uYWRtaW'
        '4uRmluZERlZmF1bHRHcm91cFJlcRoiLm9wZW5pbS5hZG1pbi5GaW5kRGVmYXVsdEdyb3VwUmVz'
        'cBJfChJTZWFyY2hEZWZhdWx0R3JvdXASIy5vcGVuaW0uYWRtaW4uU2VhcmNoRGVmYXVsdEdyb3'
        'VwUmVxGiQub3BlbmltLmFkbWluLlNlYXJjaERlZmF1bHRHcm91cFJlc3ASXAoRQWRkSW52aXRh'
        'dGlvbkNvZGUSIi5vcGVuaW0uYWRtaW4uQWRkSW52aXRhdGlvbkNvZGVSZXEaIy5vcGVuaW0uYW'
        'RtaW4uQWRkSW52aXRhdGlvbkNvZGVSZXNwElwKEUdlbkludml0YXRpb25Db2RlEiIub3Blbmlt'
        'LmFkbWluLkdlbkludml0YXRpb25Db2RlUmVxGiMub3BlbmltLmFkbWluLkdlbkludml0YXRpb2'
        '5Db2RlUmVzcBJfChJGaW5kSW52aXRhdGlvbkNvZGUSIy5vcGVuaW0uYWRtaW4uRmluZEludml0'
        'YXRpb25Db2RlUmVxGiQub3BlbmltLmFkbWluLkZpbmRJbnZpdGF0aW9uQ29kZVJlc3ASXAoRVX'
        'NlSW52aXRhdGlvbkNvZGUSIi5vcGVuaW0uYWRtaW4uVXNlSW52aXRhdGlvbkNvZGVSZXEaIy5v'
        'cGVuaW0uYWRtaW4uVXNlSW52aXRhdGlvbkNvZGVSZXNwElwKEURlbEludml0YXRpb25Db2RlEi'
        'Iub3BlbmltLmFkbWluLkRlbEludml0YXRpb25Db2RlUmVxGiMub3BlbmltLmFkbWluLkRlbElu'
        'dml0YXRpb25Db2RlUmVzcBJlChRTZWFyY2hJbnZpdGF0aW9uQ29kZRIlLm9wZW5pbS5hZG1pbi'
        '5TZWFyY2hJbnZpdGF0aW9uQ29kZVJlcRomLm9wZW5pbS5hZG1pbi5TZWFyY2hJbnZpdGF0aW9u'
        'Q29kZVJlc3ASawoWU2VhcmNoVXNlcklQTGltaXRMb2dpbhInLm9wZW5pbS5hZG1pbi5TZWFyY2'
        'hVc2VySVBMaW1pdExvZ2luUmVxGigub3BlbmltLmFkbWluLlNlYXJjaFVzZXJJUExpbWl0TG9n'
        'aW5SZXNwEmIKE0FkZFVzZXJJUExpbWl0TG9naW4SJC5vcGVuaW0uYWRtaW4uQWRkVXNlcklQTG'
        'ltaXRMb2dpblJlcRolLm9wZW5pbS5hZG1pbi5BZGRVc2VySVBMaW1pdExvZ2luUmVzcBJiChNE'
        'ZWxVc2VySVBMaW1pdExvZ2luEiQub3BlbmltLmFkbWluLkRlbFVzZXJJUExpbWl0TG9naW5SZX'
        'EaJS5vcGVuaW0uYWRtaW4uRGVsVXNlcklQTGltaXRMb2dpblJlc3ASXAoRU2VhcmNoSVBGb3Ji'
        'aWRkZW4SIi5vcGVuaW0uYWRtaW4uU2VhcmNoSVBGb3JiaWRkZW5SZXEaIy5vcGVuaW0uYWRtaW'
        '4uU2VhcmNoSVBGb3JiaWRkZW5SZXNwElMKDkFkZElQRm9yYmlkZGVuEh8ub3BlbmltLmFkbWlu'
        'LkFkZElQRm9yYmlkZGVuUmVxGiAub3BlbmltLmFkbWluLkFkZElQRm9yYmlkZGVuUmVzcBJTCg'
        '5EZWxJUEZvcmJpZGRlbhIfLm9wZW5pbS5hZG1pbi5EZWxJUEZvcmJpZGRlblJlcRogLm9wZW5p'
        'bS5hZG1pbi5EZWxJUEZvcmJpZGRlblJlc3ASWQoQQ2FuY2VsbGF0aW9uVXNlchIhLm9wZW5pbS'
        '5hZG1pbi5DYW5jZWxsYXRpb25Vc2VyUmVxGiIub3BlbmltLmFkbWluLkNhbmNlbGxhdGlvblVz'
        'ZXJSZXNwEkQKCUJsb2NrVXNlchIaLm9wZW5pbS5hZG1pbi5CbG9ja1VzZXJSZXEaGy5vcGVuaW'
        '0uYWRtaW4uQmxvY2tVc2VyUmVzcBJKCgtVbmJsb2NrVXNlchIcLm9wZW5pbS5hZG1pbi5VbmJs'
        'b2NrVXNlclJlcRodLm9wZW5pbS5hZG1pbi5VbmJsb2NrVXNlclJlc3ASVgoPU2VhcmNoQmxvY2'
        'tVc2VyEiAub3BlbmltLmFkbWluLlNlYXJjaEJsb2NrVXNlclJlcRohLm9wZW5pbS5hZG1pbi5T'
        'ZWFyY2hCbG9ja1VzZXJSZXNwElwKEUZpbmRVc2VyQmxvY2tJbmZvEiIub3BlbmltLmFkbWluLk'
        'ZpbmRVc2VyQmxvY2tJbmZvUmVxGiMub3BlbmltLmFkbWluLkZpbmRVc2VyQmxvY2tJbmZvUmVz'
        'cBJrChZDaGVja1JlZ2lzdGVyRm9yYmlkZGVuEicub3BlbmltLmFkbWluLkNoZWNrUmVnaXN0ZX'
        'JGb3JiaWRkZW5SZXEaKC5vcGVuaW0uYWRtaW4uQ2hlY2tSZWdpc3RlckZvcmJpZGRlblJlc3AS'
        'YgoTQ2hlY2tMb2dpbkZvcmJpZGRlbhIkLm9wZW5pbS5hZG1pbi5DaGVja0xvZ2luRm9yYmlkZG'
        'VuUmVxGiUub3BlbmltLmFkbWluLkNoZWNrTG9naW5Gb3JiaWRkZW5SZXNwEkoKC0NyZWF0ZVRv'
        'a2VuEhwub3BlbmltLmFkbWluLkNyZWF0ZVRva2VuUmVxGh0ub3BlbmltLmFkbWluLkNyZWF0ZV'
        'Rva2VuUmVzcBJHCgpQYXJzZVRva2VuEhsub3BlbmltLmFkbWluLlBhcnNlVG9rZW5SZXEaHC5v'
        'cGVuaW0uYWRtaW4uUGFyc2VUb2tlblJlc3ASRAoJQWRkQXBwbGV0Ehoub3BlbmltLmFkbWluLk'
        'FkZEFwcGxldFJlcRobLm9wZW5pbS5hZG1pbi5BZGRBcHBsZXRSZXNwEkQKCURlbEFwcGxldBIa'
        'Lm9wZW5pbS5hZG1pbi5EZWxBcHBsZXRSZXEaGy5vcGVuaW0uYWRtaW4uRGVsQXBwbGV0UmVzcB'
        'JNCgxVcGRhdGVBcHBsZXQSHS5vcGVuaW0uYWRtaW4uVXBkYXRlQXBwbGV0UmVxGh4ub3Blbmlt'
        'LmFkbWluLlVwZGF0ZUFwcGxldFJlc3ASRwoKRmluZEFwcGxldBIbLm9wZW5pbS5hZG1pbi5GaW'
        '5kQXBwbGV0UmVxGhwub3BlbmltLmFkbWluLkZpbmRBcHBsZXRSZXNwEk0KDFNlYXJjaEFwcGxl'
        'dBIdLm9wZW5pbS5hZG1pbi5TZWFyY2hBcHBsZXRSZXEaHi5vcGVuaW0uYWRtaW4uU2VhcmNoQX'
        'BwbGV0UmVzcBJWCg9HZXRDbGllbnRDb25maWcSIC5vcGVuaW0uYWRtaW4uR2V0Q2xpZW50Q29u'
        'ZmlnUmVxGiEub3BlbmltLmFkbWluLkdldENsaWVudENvbmZpZ1Jlc3ASVgoPU2V0Q2xpZW50Q2'
        '9uZmlnEiAub3BlbmltLmFkbWluLlNldENsaWVudENvbmZpZ1JlcRohLm9wZW5pbS5hZG1pbi5T'
        'ZXRDbGllbnRDb25maWdSZXNwElYKD0RlbENsaWVudENvbmZpZxIgLm9wZW5pbS5hZG1pbi5EZW'
        'xDbGllbnRDb25maWdSZXEaIS5vcGVuaW0uYWRtaW4uRGVsQ2xpZW50Q29uZmlnUmVzcBJNCgxH'
        'ZXRVc2VyVG9rZW4SHS5vcGVuaW0uYWRtaW4uR2V0VXNlclRva2VuUmVxGh4ub3BlbmltLmFkbW'
        'luLkdldFVzZXJUb2tlblJlc3ASVgoPSW52YWxpZGF0ZVRva2VuEiAub3BlbmltLmFkbWluLklu'
        'dmFsaWRhdGVUb2tlblJlcRohLm9wZW5pbS5hZG1pbi5JbnZhbGlkYXRlVG9rZW5SZXNwEnEKGE'
        'xhdGVzdEFwcGxpY2F0aW9uVmVyc2lvbhIpLm9wZW5pbS5hZG1pbi5MYXRlc3RBcHBsaWNhdGlv'
        'blZlcnNpb25SZXEaKi5vcGVuaW0uYWRtaW4uTGF0ZXN0QXBwbGljYXRpb25WZXJzaW9uUmVzcB'
        'JoChVBZGRBcHBsaWNhdGlvblZlcnNpb24SJi5vcGVuaW0uYWRtaW4uQWRkQXBwbGljYXRpb25W'
        'ZXJzaW9uUmVxGicub3BlbmltLmFkbWluLkFkZEFwcGxpY2F0aW9uVmVyc2lvblJlc3AScQoYVX'
        'BkYXRlQXBwbGljYXRpb25WZXJzaW9uEikub3BlbmltLmFkbWluLlVwZGF0ZUFwcGxpY2F0aW9u'
        'VmVyc2lvblJlcRoqLm9wZW5pbS5hZG1pbi5VcGRhdGVBcHBsaWNhdGlvblZlcnNpb25SZXNwEn'
        'EKGERlbGV0ZUFwcGxpY2F0aW9uVmVyc2lvbhIpLm9wZW5pbS5hZG1pbi5EZWxldGVBcHBsaWNh'
        'dGlvblZlcnNpb25SZXEaKi5vcGVuaW0uYWRtaW4uRGVsZXRlQXBwbGljYXRpb25WZXJzaW9uUm'
        'VzcBJrChZQYWdlQXBwbGljYXRpb25WZXJzaW9uEicub3BlbmltLmFkbWluLlBhZ2VBcHBsaWNh'
        'dGlvblZlcnNpb25SZXEaKC5vcGVuaW0uYWRtaW4uUGFnZUFwcGxpY2F0aW9uVmVyc2lvblJlc3'
        'A=');
