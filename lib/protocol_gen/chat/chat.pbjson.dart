// This is a generated file - do not edit.
//
// Generated from chat/chat.proto.

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

import '../common/common.pbjson.dart' as $1;
import '../sdkws/sdkws.pbjson.dart' as $2;
import '../wrapperspb/wrapperspb.pbjson.dart' as $0;

@$core.Deprecated('Use userIdentityDescriptor instead')
const UserIdentity$json = {
  '1': 'UserIdentity',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'areaCode', '3': 2, '4': 1, '5': 9, '10': 'areaCode'},
    {'1': 'phoneNumber', '3': 3, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'deviceID', '3': 4, '4': 1, '5': 9, '10': 'deviceID'},
    {'1': 'platform', '3': 5, '4': 1, '5': 5, '10': 'platform'},
    {'1': 'account', '3': 6, '4': 1, '5': 9, '10': 'account'},
  ],
};

/// Descriptor for `UserIdentity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userIdentityDescriptor = $convert.base64Decode(
    'CgxVc2VySWRlbnRpdHkSFAoFZW1haWwYASABKAlSBWVtYWlsEhoKCGFyZWFDb2RlGAIgASgJUg'
    'hhcmVhQ29kZRIgCgtwaG9uZU51bWJlchgDIAEoCVILcGhvbmVOdW1iZXISGgoIZGV2aWNlSUQY'
    'BCABKAlSCGRldmljZUlEEhoKCHBsYXRmb3JtGAUgASgFUghwbGF0Zm9ybRIYCgdhY2NvdW50GA'
    'YgASgJUgdhY2NvdW50');

@$core.Deprecated('Use updateUserInfoReqDescriptor instead')
const UpdateUserInfoReq$json = {
  '1': 'UpdateUserInfoReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {
      '1': 'account',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'account'
    },
    {
      '1': 'phoneNumber',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'phoneNumber'
    },
    {
      '1': 'areaCode',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'areaCode'
    },
    {
      '1': 'email',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'email'
    },
    {
      '1': 'nickname',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'nickname'
    },
    {
      '1': 'faceURL',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.StringValue',
      '10': 'faceURL'
    },
    {
      '1': 'gender',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'gender'
    },
    {
      '1': 'level',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'level'
    },
    {
      '1': 'birth',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int64Value',
      '10': 'birth'
    },
    {
      '1': 'allowAddFriend',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'allowAddFriend'
    },
    {
      '1': 'allowBeep',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'allowBeep'
    },
    {
      '1': 'allowVibration',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'allowVibration'
    },
    {
      '1': 'globalRecvMsgOpt',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'globalRecvMsgOpt'
    },
    {
      '1': 'RegisterType',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.openim.protobuf.Int32Value',
      '10': 'RegisterType'
    },
  ],
};

/// Descriptor for `UpdateUserInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserInfoReqDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVVc2VySW5mb1JlcRIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBI2CgdhY2NvdW50GA'
    'IgASgLMhwub3BlbmltLnByb3RvYnVmLlN0cmluZ1ZhbHVlUgdhY2NvdW50Ej4KC3Bob25lTnVt'
    'YmVyGAMgASgLMhwub3BlbmltLnByb3RvYnVmLlN0cmluZ1ZhbHVlUgtwaG9uZU51bWJlchI4Cg'
    'hhcmVhQ29kZRgEIAEoCzIcLm9wZW5pbS5wcm90b2J1Zi5TdHJpbmdWYWx1ZVIIYXJlYUNvZGUS'
    'MgoFZW1haWwYBSABKAsyHC5vcGVuaW0ucHJvdG9idWYuU3RyaW5nVmFsdWVSBWVtYWlsEjgKCG'
    '5pY2tuYW1lGAYgASgLMhwub3BlbmltLnByb3RvYnVmLlN0cmluZ1ZhbHVlUghuaWNrbmFtZRI2'
    'CgdmYWNlVVJMGAcgASgLMhwub3BlbmltLnByb3RvYnVmLlN0cmluZ1ZhbHVlUgdmYWNlVVJMEj'
    'MKBmdlbmRlchgIIAEoCzIbLm9wZW5pbS5wcm90b2J1Zi5JbnQzMlZhbHVlUgZnZW5kZXISMQoF'
    'bGV2ZWwYCSABKAsyGy5vcGVuaW0ucHJvdG9idWYuSW50MzJWYWx1ZVIFbGV2ZWwSMQoFYmlydG'
    'gYCiABKAsyGy5vcGVuaW0ucHJvdG9idWYuSW50NjRWYWx1ZVIFYmlydGgSQwoOYWxsb3dBZGRG'
    'cmllbmQYCyABKAsyGy5vcGVuaW0ucHJvdG9idWYuSW50MzJWYWx1ZVIOYWxsb3dBZGRGcmllbm'
    'QSOQoJYWxsb3dCZWVwGAwgASgLMhsub3BlbmltLnByb3RvYnVmLkludDMyVmFsdWVSCWFsbG93'
    'QmVlcBJDCg5hbGxvd1ZpYnJhdGlvbhgNIAEoCzIbLm9wZW5pbS5wcm90b2J1Zi5JbnQzMlZhbH'
    'VlUg5hbGxvd1ZpYnJhdGlvbhJHChBnbG9iYWxSZWN2TXNnT3B0GA4gASgLMhsub3BlbmltLnBy'
    'b3RvYnVmLkludDMyVmFsdWVSEGdsb2JhbFJlY3ZNc2dPcHQSPwoMUmVnaXN0ZXJUeXBlGA8gAS'
    'gLMhsub3BlbmltLnByb3RvYnVmLkludDMyVmFsdWVSDFJlZ2lzdGVyVHlwZQ==');

@$core.Deprecated('Use updateUserInfoRespDescriptor instead')
const UpdateUserInfoResp$json = {
  '1': 'UpdateUserInfoResp',
  '2': [
    {'1': 'faceUrl', '3': 1, '4': 1, '5': 9, '10': 'faceUrl'},
    {'1': 'nickName', '3': 2, '4': 1, '5': 9, '10': 'nickName'},
  ],
};

/// Descriptor for `UpdateUserInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserInfoRespDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVVc2VySW5mb1Jlc3ASGAoHZmFjZVVybBgBIAEoCVIHZmFjZVVybBIaCghuaWNrTm'
    'FtZRgCIAEoCVIIbmlja05hbWU=');

@$core.Deprecated('Use findUserPublicInfoReqDescriptor instead')
const FindUserPublicInfoReq$json = {
  '1': 'FindUserPublicInfoReq',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `FindUserPublicInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findUserPublicInfoReqDescriptor =
    $convert.base64Decode(
        'ChVGaW5kVXNlclB1YmxpY0luZm9SZXESGAoHdXNlcklEcxgBIAMoCVIHdXNlcklEcw==');

@$core.Deprecated('Use findUserPublicInfoRespDescriptor instead')
const FindUserPublicInfoResp$json = {
  '1': 'FindUserPublicInfoResp',
  '2': [
    {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.common.UserPublicInfo',
      '10': 'users'
    },
  ],
};

/// Descriptor for `FindUserPublicInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findUserPublicInfoRespDescriptor =
    $convert.base64Decode(
        'ChZGaW5kVXNlclB1YmxpY0luZm9SZXNwEjgKBXVzZXJzGAEgAygLMiIub3BlbmltLmNoYXQuY2'
        '9tbW9uLlVzZXJQdWJsaWNJbmZvUgV1c2Vycw==');

@$core.Deprecated('Use searchUserPublicInfoReqDescriptor instead')
const SearchUserPublicInfoReq$json = {
  '1': 'SearchUserPublicInfoReq',
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
    {'1': 'genders', '3': 3, '4': 1, '5': 5, '10': 'genders'},
  ],
};

/// Descriptor for `SearchUserPublicInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchUserPublicInfoReqDescriptor = $convert.base64Decode(
    'ChdTZWFyY2hVc2VyUHVibGljSW5mb1JlcRIYCgdrZXl3b3JkGAEgASgJUgdrZXl3b3JkEj8KCn'
    'BhZ2luYXRpb24YAiABKAsyHy5vcGVuaW0uc2Rrd3MuUmVxdWVzdFBhZ2luYXRpb25SCnBhZ2lu'
    'YXRpb24SGAoHZ2VuZGVycxgDIAEoBVIHZ2VuZGVycw==');

@$core.Deprecated('Use searchUserPublicInfoRespDescriptor instead')
const SearchUserPublicInfoResp$json = {
  '1': 'SearchUserPublicInfoResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {
      '1': 'users',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.common.UserPublicInfo',
      '10': 'users'
    },
  ],
};

/// Descriptor for `SearchUserPublicInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchUserPublicInfoRespDescriptor =
    $convert.base64Decode(
        'ChhTZWFyY2hVc2VyUHVibGljSW5mb1Jlc3ASFAoFdG90YWwYASABKA1SBXRvdGFsEjgKBXVzZX'
        'JzGAIgAygLMiIub3BlbmltLmNoYXQuY29tbW9uLlVzZXJQdWJsaWNJbmZvUgV1c2Vycw==');

@$core.Deprecated('Use findUserFullInfoReqDescriptor instead')
const FindUserFullInfoReq$json = {
  '1': 'FindUserFullInfoReq',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `FindUserFullInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findUserFullInfoReqDescriptor =
    $convert.base64Decode(
        'ChNGaW5kVXNlckZ1bGxJbmZvUmVxEhgKB3VzZXJJRHMYASADKAlSB3VzZXJJRHM=');

@$core.Deprecated('Use findUserFullInfoRespDescriptor instead')
const FindUserFullInfoResp$json = {
  '1': 'FindUserFullInfoResp',
  '2': [
    {
      '1': 'users',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.common.UserFullInfo',
      '10': 'users'
    },
  ],
};

/// Descriptor for `FindUserFullInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findUserFullInfoRespDescriptor = $convert.base64Decode(
    'ChRGaW5kVXNlckZ1bGxJbmZvUmVzcBI2CgV1c2VycxgBIAMoCzIgLm9wZW5pbS5jaGF0LmNvbW'
    '1vbi5Vc2VyRnVsbEluZm9SBXVzZXJz');

@$core.Deprecated('Use sendVerifyCodeReqDescriptor instead')
const SendVerifyCodeReq$json = {
  '1': 'SendVerifyCodeReq',
  '2': [
    {'1': 'usedFor', '3': 1, '4': 1, '5': 5, '10': 'usedFor'},
    {'1': 'ip', '3': 2, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'invitationCode', '3': 3, '4': 1, '5': 9, '10': 'invitationCode'},
    {'1': 'deviceID', '3': 4, '4': 1, '5': 9, '10': 'deviceID'},
    {'1': 'platform', '3': 5, '4': 1, '5': 5, '10': 'platform'},
    {'1': 'areaCode', '3': 6, '4': 1, '5': 9, '10': 'areaCode'},
    {'1': 'phoneNumber', '3': 7, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'email', '3': 8, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `SendVerifyCodeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerifyCodeReqDescriptor = $convert.base64Decode(
    'ChFTZW5kVmVyaWZ5Q29kZVJlcRIYCgd1c2VkRm9yGAEgASgFUgd1c2VkRm9yEg4KAmlwGAIgAS'
    'gJUgJpcBImCg5pbnZpdGF0aW9uQ29kZRgDIAEoCVIOaW52aXRhdGlvbkNvZGUSGgoIZGV2aWNl'
    'SUQYBCABKAlSCGRldmljZUlEEhoKCHBsYXRmb3JtGAUgASgFUghwbGF0Zm9ybRIaCghhcmVhQ2'
    '9kZRgGIAEoCVIIYXJlYUNvZGUSIAoLcGhvbmVOdW1iZXIYByABKAlSC3Bob25lTnVtYmVyEhQK'
    'BWVtYWlsGAggASgJUgVlbWFpbA==');

@$core.Deprecated('Use sendVerifyCodeRespDescriptor instead')
const SendVerifyCodeResp$json = {
  '1': 'SendVerifyCodeResp',
};

/// Descriptor for `SendVerifyCodeResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerifyCodeRespDescriptor =
    $convert.base64Decode('ChJTZW5kVmVyaWZ5Q29kZVJlc3A=');

@$core.Deprecated('Use verifyCodeReqDescriptor instead')
const VerifyCodeReq$json = {
  '1': 'VerifyCodeReq',
  '2': [
    {'1': 'areaCode', '3': 1, '4': 1, '5': 9, '10': 'areaCode'},
    {'1': 'phoneNumber', '3': 2, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'verifyCode', '3': 3, '4': 1, '5': 9, '10': 'verifyCode'},
    {'1': 'email', '3': 4, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `VerifyCodeReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyCodeReqDescriptor = $convert.base64Decode(
    'Cg1WZXJpZnlDb2RlUmVxEhoKCGFyZWFDb2RlGAEgASgJUghhcmVhQ29kZRIgCgtwaG9uZU51bW'
    'JlchgCIAEoCVILcGhvbmVOdW1iZXISHgoKdmVyaWZ5Q29kZRgDIAEoCVIKdmVyaWZ5Q29kZRIU'
    'CgVlbWFpbBgEIAEoCVIFZW1haWw=');

@$core.Deprecated('Use verifyCodeRespDescriptor instead')
const VerifyCodeResp$json = {
  '1': 'VerifyCodeResp',
};

/// Descriptor for `VerifyCodeResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyCodeRespDescriptor =
    $convert.base64Decode('Cg5WZXJpZnlDb2RlUmVzcA==');

@$core.Deprecated('Use registerUserInfoDescriptor instead')
const RegisterUserInfo$json = {
  '1': 'RegisterUserInfo',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'nickname', '3': 2, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'faceURL', '3': 3, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'birth', '3': 4, '4': 1, '5': 3, '10': 'birth'},
    {'1': 'gender', '3': 5, '4': 1, '5': 5, '10': 'gender'},
    {'1': 'areaCode', '3': 6, '4': 1, '5': 9, '10': 'areaCode'},
    {'1': 'phoneNumber', '3': 7, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'email', '3': 8, '4': 1, '5': 9, '10': 'email'},
    {'1': 'account', '3': 9, '4': 1, '5': 9, '10': 'account'},
    {'1': 'password', '3': 10, '4': 1, '5': 9, '10': 'password'},
    {'1': 'RegisterType', '3': 11, '4': 1, '5': 5, '10': 'RegisterType'},
  ],
};

/// Descriptor for `RegisterUserInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerUserInfoDescriptor = $convert.base64Decode(
    'ChBSZWdpc3RlclVzZXJJbmZvEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEhoKCG5pY2tuYW1lGA'
    'IgASgJUghuaWNrbmFtZRIYCgdmYWNlVVJMGAMgASgJUgdmYWNlVVJMEhQKBWJpcnRoGAQgASgD'
    'UgViaXJ0aBIWCgZnZW5kZXIYBSABKAVSBmdlbmRlchIaCghhcmVhQ29kZRgGIAEoCVIIYXJlYU'
    'NvZGUSIAoLcGhvbmVOdW1iZXIYByABKAlSC3Bob25lTnVtYmVyEhQKBWVtYWlsGAggASgJUgVl'
    'bWFpbBIYCgdhY2NvdW50GAkgASgJUgdhY2NvdW50EhoKCHBhc3N3b3JkGAogASgJUghwYXNzd2'
    '9yZBIiCgxSZWdpc3RlclR5cGUYCyABKAVSDFJlZ2lzdGVyVHlwZQ==');

@$core.Deprecated('Use registerUserReqDescriptor instead')
const RegisterUserReq$json = {
  '1': 'RegisterUserReq',
  '2': [
    {'1': 'invitationCode', '3': 1, '4': 1, '5': 9, '10': 'invitationCode'},
    {'1': 'verifyCode', '3': 2, '4': 1, '5': 9, '10': 'verifyCode'},
    {'1': 'ip', '3': 3, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'deviceID', '3': 4, '4': 1, '5': 9, '10': 'deviceID'},
    {'1': 'platform', '3': 5, '4': 1, '5': 5, '10': 'platform'},
    {'1': 'autoLogin', '3': 6, '4': 1, '5': 8, '10': 'autoLogin'},
    {
      '1': 'user',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.openim.chat.RegisterUserInfo',
      '10': 'user'
    },
  ],
};

/// Descriptor for `RegisterUserReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerUserReqDescriptor = $convert.base64Decode(
    'Cg9SZWdpc3RlclVzZXJSZXESJgoOaW52aXRhdGlvbkNvZGUYASABKAlSDmludml0YXRpb25Db2'
    'RlEh4KCnZlcmlmeUNvZGUYAiABKAlSCnZlcmlmeUNvZGUSDgoCaXAYAyABKAlSAmlwEhoKCGRl'
    'dmljZUlEGAQgASgJUghkZXZpY2VJRBIaCghwbGF0Zm9ybRgFIAEoBVIIcGxhdGZvcm0SHAoJYX'
    'V0b0xvZ2luGAYgASgIUglhdXRvTG9naW4SMQoEdXNlchgHIAEoCzIdLm9wZW5pbS5jaGF0LlJl'
    'Z2lzdGVyVXNlckluZm9SBHVzZXI=');

@$core.Deprecated('Use registerUserRespDescriptor instead')
const RegisterUserResp$json = {
  '1': 'RegisterUserResp',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'chatToken', '3': 3, '4': 1, '5': 9, '10': 'chatToken'},
  ],
};

/// Descriptor for `RegisterUserResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerUserRespDescriptor = $convert.base64Decode(
    'ChBSZWdpc3RlclVzZXJSZXNwEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEhwKCWNoYXRUb2tlbh'
    'gDIAEoCVIJY2hhdFRva2Vu');

@$core.Deprecated('Use addUserAccountReqDescriptor instead')
const AddUserAccountReq$json = {
  '1': 'AddUserAccountReq',
  '2': [
    {'1': 'ip', '3': 1, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'deviceID', '3': 2, '4': 1, '5': 9, '10': 'deviceID'},
    {'1': 'platform', '3': 3, '4': 1, '5': 5, '10': 'platform'},
    {
      '1': 'user',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.openim.chat.RegisterUserInfo',
      '10': 'user'
    },
  ],
};

/// Descriptor for `AddUserAccountReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addUserAccountReqDescriptor = $convert.base64Decode(
    'ChFBZGRVc2VyQWNjb3VudFJlcRIOCgJpcBgBIAEoCVICaXASGgoIZGV2aWNlSUQYAiABKAlSCG'
    'RldmljZUlEEhoKCHBsYXRmb3JtGAMgASgFUghwbGF0Zm9ybRIxCgR1c2VyGAQgASgLMh0ub3Bl'
    'bmltLmNoYXQuUmVnaXN0ZXJVc2VySW5mb1IEdXNlcg==');

@$core.Deprecated('Use addUserAccountRespDescriptor instead')
const AddUserAccountResp$json = {
  '1': 'AddUserAccountResp',
};

/// Descriptor for `AddUserAccountResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addUserAccountRespDescriptor =
    $convert.base64Decode('ChJBZGRVc2VyQWNjb3VudFJlc3A=');

@$core.Deprecated('Use loginReqDescriptor instead')
const LoginReq$json = {
  '1': 'LoginReq',
  '2': [
    {'1': 'areaCode', '3': 1, '4': 1, '5': 9, '10': 'areaCode'},
    {'1': 'phoneNumber', '3': 2, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'verifyCode', '3': 3, '4': 1, '5': 9, '10': 'verifyCode'},
    {'1': 'account', '3': 4, '4': 1, '5': 9, '10': 'account'},
    {'1': 'password', '3': 5, '4': 1, '5': 9, '10': 'password'},
    {'1': 'platform', '3': 6, '4': 1, '5': 5, '10': 'platform'},
    {'1': 'deviceID', '3': 7, '4': 1, '5': 9, '10': 'deviceID'},
    {'1': 'ip', '3': 8, '4': 1, '5': 9, '10': 'ip'},
    {'1': 'email', '3': 9, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `LoginReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginReqDescriptor = $convert.base64Decode(
    'CghMb2dpblJlcRIaCghhcmVhQ29kZRgBIAEoCVIIYXJlYUNvZGUSIAoLcGhvbmVOdW1iZXIYAi'
    'ABKAlSC3Bob25lTnVtYmVyEh4KCnZlcmlmeUNvZGUYAyABKAlSCnZlcmlmeUNvZGUSGAoHYWNj'
    'b3VudBgEIAEoCVIHYWNjb3VudBIaCghwYXNzd29yZBgFIAEoCVIIcGFzc3dvcmQSGgoIcGxhdG'
    'Zvcm0YBiABKAVSCHBsYXRmb3JtEhoKCGRldmljZUlEGAcgASgJUghkZXZpY2VJRBIOCgJpcBgI'
    'IAEoCVICaXASFAoFZW1haWwYCSABKAlSBWVtYWls');

@$core.Deprecated('Use resetPasswordReqDescriptor instead')
const ResetPasswordReq$json = {
  '1': 'ResetPasswordReq',
  '2': [
    {'1': 'areaCode', '3': 1, '4': 1, '5': 9, '10': 'areaCode'},
    {'1': 'phoneNumber', '3': 2, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'verifyCode', '3': 3, '4': 1, '5': 9, '10': 'verifyCode'},
    {'1': 'password', '3': 4, '4': 1, '5': 9, '10': 'password'},
    {'1': 'email', '3': 5, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `ResetPasswordReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetPasswordReqDescriptor = $convert.base64Decode(
    'ChBSZXNldFBhc3N3b3JkUmVxEhoKCGFyZWFDb2RlGAEgASgJUghhcmVhQ29kZRIgCgtwaG9uZU'
    '51bWJlchgCIAEoCVILcGhvbmVOdW1iZXISHgoKdmVyaWZ5Q29kZRgDIAEoCVIKdmVyaWZ5Q29k'
    'ZRIaCghwYXNzd29yZBgEIAEoCVIIcGFzc3dvcmQSFAoFZW1haWwYBSABKAlSBWVtYWls');

@$core.Deprecated('Use resetPasswordRespDescriptor instead')
const ResetPasswordResp$json = {
  '1': 'ResetPasswordResp',
};

/// Descriptor for `ResetPasswordResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetPasswordRespDescriptor =
    $convert.base64Decode('ChFSZXNldFBhc3N3b3JkUmVzcA==');

@$core.Deprecated('Use changePasswordReqDescriptor instead')
const ChangePasswordReq$json = {
  '1': 'ChangePasswordReq',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'currentPassword', '3': 2, '4': 1, '5': 9, '10': 'currentPassword'},
    {'1': 'newPassword', '3': 3, '4': 1, '5': 9, '10': 'newPassword'},
  ],
};

/// Descriptor for `ChangePasswordReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordReqDescriptor = $convert.base64Decode(
    'ChFDaGFuZ2VQYXNzd29yZFJlcRIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBIoCg9jdXJyZW50UG'
    'Fzc3dvcmQYAiABKAlSD2N1cnJlbnRQYXNzd29yZBIgCgtuZXdQYXNzd29yZBgDIAEoCVILbmV3'
    'UGFzc3dvcmQ=');

@$core.Deprecated('Use changePasswordRespDescriptor instead')
const ChangePasswordResp$json = {
  '1': 'ChangePasswordResp',
};

/// Descriptor for `ChangePasswordResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordRespDescriptor =
    $convert.base64Decode('ChJDaGFuZ2VQYXNzd29yZFJlc3A=');

@$core.Deprecated('Use findUserAccountReqDescriptor instead')
const FindUserAccountReq$json = {
  '1': 'FindUserAccountReq',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `FindUserAccountReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findUserAccountReqDescriptor =
    $convert.base64Decode(
        'ChJGaW5kVXNlckFjY291bnRSZXESGAoHdXNlcklEcxgBIAMoCVIHdXNlcklEcw==');

@$core.Deprecated('Use findUserAccountRespDescriptor instead')
const FindUserAccountResp$json = {
  '1': 'FindUserAccountResp',
  '2': [
    {
      '1': 'userAccountMap',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.FindUserAccountResp.UserAccountMapEntry',
      '10': 'userAccountMap'
    },
  ],
  '3': [FindUserAccountResp_UserAccountMapEntry$json],
};

@$core.Deprecated('Use findUserAccountRespDescriptor instead')
const FindUserAccountResp_UserAccountMapEntry$json = {
  '1': 'UserAccountMapEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `FindUserAccountResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findUserAccountRespDescriptor = $convert.base64Decode(
    'ChNGaW5kVXNlckFjY291bnRSZXNwElwKDnVzZXJBY2NvdW50TWFwGAEgAygLMjQub3BlbmltLm'
    'NoYXQuRmluZFVzZXJBY2NvdW50UmVzcC5Vc2VyQWNjb3VudE1hcEVudHJ5Ug51c2VyQWNjb3Vu'
    'dE1hcBpBChNVc2VyQWNjb3VudE1hcEVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGA'
    'IgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use findAccountUserReqDescriptor instead')
const FindAccountUserReq$json = {
  '1': 'FindAccountUserReq',
  '2': [
    {'1': 'accounts', '3': 1, '4': 3, '5': 9, '10': 'accounts'},
  ],
};

/// Descriptor for `FindAccountUserReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findAccountUserReqDescriptor =
    $convert.base64Decode(
        'ChJGaW5kQWNjb3VudFVzZXJSZXESGgoIYWNjb3VudHMYASADKAlSCGFjY291bnRz');

@$core.Deprecated('Use findAccountUserRespDescriptor instead')
const FindAccountUserResp$json = {
  '1': 'FindAccountUserResp',
  '2': [
    {
      '1': 'accountUserMap',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.FindAccountUserResp.AccountUserMapEntry',
      '10': 'accountUserMap'
    },
  ],
  '3': [FindAccountUserResp_AccountUserMapEntry$json],
};

@$core.Deprecated('Use findAccountUserRespDescriptor instead')
const FindAccountUserResp_AccountUserMapEntry$json = {
  '1': 'AccountUserMapEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `FindAccountUserResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findAccountUserRespDescriptor = $convert.base64Decode(
    'ChNGaW5kQWNjb3VudFVzZXJSZXNwElwKDmFjY291bnRVc2VyTWFwGAEgAygLMjQub3BlbmltLm'
    'NoYXQuRmluZEFjY291bnRVc2VyUmVzcC5BY2NvdW50VXNlck1hcEVudHJ5Ug5hY2NvdW50VXNl'
    'ck1hcBpBChNBY2NvdW50VXNlck1hcEVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGA'
    'IgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use signalRecordDescriptor instead')
const SignalRecord$json = {
  '1': 'SignalRecord',
  '2': [
    {'1': 'fileName', '3': 1, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'mediaType', '3': 2, '4': 1, '5': 9, '10': 'mediaType'},
    {'1': 'roomType', '3': 3, '4': 1, '5': 9, '10': 'roomType'},
    {'1': 'senderID', '3': 4, '4': 1, '5': 9, '10': 'senderID'},
    {'1': 'senderNickname', '3': 5, '4': 1, '5': 9, '10': 'senderNickname'},
    {'1': 'recvID', '3': 6, '4': 1, '5': 9, '10': 'recvID'},
    {'1': 'recvNickname', '3': 7, '4': 1, '5': 9, '10': 'recvNickname'},
    {'1': 'groupID', '3': 8, '4': 1, '5': 9, '10': 'groupID'},
    {'1': 'groupName', '3': 9, '4': 1, '5': 9, '10': 'groupName'},
    {
      '1': 'inviterUserList',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.common.UserPublicInfo',
      '10': 'inviterUserList'
    },
    {'1': 'duration', '3': 11, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'createTime', '3': 12, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'size', '3': 13, '4': 1, '5': 9, '10': 'size'},
    {'1': 'downloadURL', '3': 14, '4': 1, '5': 9, '10': 'downloadURL'},
  ],
};

/// Descriptor for `SignalRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalRecordDescriptor = $convert.base64Decode(
    'CgxTaWduYWxSZWNvcmQSGgoIZmlsZU5hbWUYASABKAlSCGZpbGVOYW1lEhwKCW1lZGlhVHlwZR'
    'gCIAEoCVIJbWVkaWFUeXBlEhoKCHJvb21UeXBlGAMgASgJUghyb29tVHlwZRIaCghzZW5kZXJJ'
    'RBgEIAEoCVIIc2VuZGVySUQSJgoOc2VuZGVyTmlja25hbWUYBSABKAlSDnNlbmRlck5pY2tuYW'
    '1lEhYKBnJlY3ZJRBgGIAEoCVIGcmVjdklEEiIKDHJlY3ZOaWNrbmFtZRgHIAEoCVIMcmVjdk5p'
    'Y2tuYW1lEhgKB2dyb3VwSUQYCCABKAlSB2dyb3VwSUQSHAoJZ3JvdXBOYW1lGAkgASgJUglncm'
    '91cE5hbWUSTAoPaW52aXRlclVzZXJMaXN0GAogAygLMiIub3BlbmltLmNoYXQuY29tbW9uLlVz'
    'ZXJQdWJsaWNJbmZvUg9pbnZpdGVyVXNlckxpc3QSGgoIZHVyYXRpb24YCyABKAVSCGR1cmF0aW'
    '9uEh4KCmNyZWF0ZVRpbWUYDCABKANSCmNyZWF0ZVRpbWUSEgoEc2l6ZRgNIAEoCVIEc2l6ZRIg'
    'Cgtkb3dubG9hZFVSTBgOIAEoCVILZG93bmxvYWRVUkw=');

@$core.Deprecated('Use openIMCallbackReqDescriptor instead')
const OpenIMCallbackReq$json = {
  '1': 'OpenIMCallbackReq',
  '2': [
    {'1': 'command', '3': 1, '4': 1, '5': 9, '10': 'command'},
    {'1': 'body', '3': 2, '4': 1, '5': 9, '10': 'body'},
  ],
};

/// Descriptor for `OpenIMCallbackReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openIMCallbackReqDescriptor = $convert.base64Decode(
    'ChFPcGVuSU1DYWxsYmFja1JlcRIYCgdjb21tYW5kGAEgASgJUgdjb21tYW5kEhIKBGJvZHkYAi'
    'ABKAlSBGJvZHk=');

@$core.Deprecated('Use openIMCallbackRespDescriptor instead')
const OpenIMCallbackResp$json = {
  '1': 'OpenIMCallbackResp',
};

/// Descriptor for `OpenIMCallbackResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openIMCallbackRespDescriptor =
    $convert.base64Decode('ChJPcGVuSU1DYWxsYmFja1Jlc3A=');

@$core.Deprecated('Use searchUserFullInfoReqDescriptor instead')
const SearchUserFullInfoReq$json = {
  '1': 'SearchUserFullInfoReq',
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
    {'1': 'genders', '3': 3, '4': 1, '5': 5, '10': 'genders'},
    {'1': 'normal', '3': 4, '4': 1, '5': 5, '10': 'normal'},
  ],
};

/// Descriptor for `SearchUserFullInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchUserFullInfoReqDescriptor = $convert.base64Decode(
    'ChVTZWFyY2hVc2VyRnVsbEluZm9SZXESGAoHa2V5d29yZBgBIAEoCVIHa2V5d29yZBI/CgpwYW'
    'dpbmF0aW9uGAIgASgLMh8ub3BlbmltLnNka3dzLlJlcXVlc3RQYWdpbmF0aW9uUgpwYWdpbmF0'
    'aW9uEhgKB2dlbmRlcnMYAyABKAVSB2dlbmRlcnMSFgoGbm9ybWFsGAQgASgFUgZub3JtYWw=');

@$core.Deprecated('Use searchUserFullInfoRespDescriptor instead')
const SearchUserFullInfoResp$json = {
  '1': 'SearchUserFullInfoResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {
      '1': 'users',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.common.UserFullInfo',
      '10': 'users'
    },
  ],
};

/// Descriptor for `SearchUserFullInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchUserFullInfoRespDescriptor =
    $convert.base64Decode(
        'ChZTZWFyY2hVc2VyRnVsbEluZm9SZXNwEhQKBXRvdGFsGAEgASgNUgV0b3RhbBI2CgV1c2Vycx'
        'gCIAMoCzIgLm9wZW5pbS5jaGF0LmNvbW1vbi5Vc2VyRnVsbEluZm9SBXVzZXJz');

@$core.Deprecated('Use userLoginCountReqDescriptor instead')
const UserLoginCountReq$json = {
  '1': 'UserLoginCountReq',
  '2': [
    {'1': 'start', '3': 1, '4': 1, '5': 3, '10': 'start'},
    {'1': 'end', '3': 2, '4': 1, '5': 3, '10': 'end'},
  ],
};

/// Descriptor for `UserLoginCountReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userLoginCountReqDescriptor = $convert.base64Decode(
    'ChFVc2VyTG9naW5Db3VudFJlcRIUCgVzdGFydBgBIAEoA1IFc3RhcnQSEAoDZW5kGAIgASgDUg'
    'NlbmQ=');

@$core.Deprecated('Use userLoginCountRespDescriptor instead')
const UserLoginCountResp$json = {
  '1': 'UserLoginCountResp',
  '2': [
    {'1': 'loginCount', '3': 1, '4': 1, '5': 3, '10': 'loginCount'},
    {'1': 'unloginCount', '3': 2, '4': 1, '5': 3, '10': 'unloginCount'},
    {
      '1': 'count',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.UserLoginCountResp.CountEntry',
      '10': 'count'
    },
  ],
  '3': [UserLoginCountResp_CountEntry$json],
};

@$core.Deprecated('Use userLoginCountRespDescriptor instead')
const UserLoginCountResp_CountEntry$json = {
  '1': 'CountEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `UserLoginCountResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userLoginCountRespDescriptor = $convert.base64Decode(
    'ChJVc2VyTG9naW5Db3VudFJlc3ASHgoKbG9naW5Db3VudBgBIAEoA1IKbG9naW5Db3VudBIiCg'
    'x1bmxvZ2luQ291bnQYAiABKANSDHVubG9naW5Db3VudBJACgVjb3VudBgDIAMoCzIqLm9wZW5p'
    'bS5jaGF0LlVzZXJMb2dpbkNvdW50UmVzcC5Db3VudEVudHJ5UgVjb3VudBo4CgpDb3VudEVudH'
    'J5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgDUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use loginRespDescriptor instead')
const LoginResp$json = {
  '1': 'LoginResp',
  '2': [
    {'1': 'chatToken', '3': 2, '4': 1, '5': 9, '10': 'chatToken'},
    {'1': 'userID', '3': 3, '4': 1, '5': 9, '10': 'userID'},
  ],
};

/// Descriptor for `LoginResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRespDescriptor = $convert.base64Decode(
    'CglMb2dpblJlc3ASHAoJY2hhdFRva2VuGAIgASgJUgljaGF0VG9rZW4SFgoGdXNlcklEGAMgAS'
    'gJUgZ1c2VySUQ=');

@$core.Deprecated('Use searchUserInfoReqDescriptor instead')
const SearchUserInfoReq$json = {
  '1': 'SearchUserInfoReq',
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
    {'1': 'genders', '3': 3, '4': 3, '5': 5, '10': 'genders'},
    {'1': 'userIDs', '3': 4, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `SearchUserInfoReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchUserInfoReqDescriptor = $convert.base64Decode(
    'ChFTZWFyY2hVc2VySW5mb1JlcRIYCgdrZXl3b3JkGAEgASgJUgdrZXl3b3JkEj8KCnBhZ2luYX'
    'Rpb24YAiABKAsyHy5vcGVuaW0uc2Rrd3MuUmVxdWVzdFBhZ2luYXRpb25SCnBhZ2luYXRpb24S'
    'GAoHZ2VuZGVycxgDIAMoBVIHZ2VuZGVycxIYCgd1c2VySURzGAQgAygJUgd1c2VySURz');

@$core.Deprecated('Use searchUserInfoRespDescriptor instead')
const SearchUserInfoResp$json = {
  '1': 'SearchUserInfoResp',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 13, '10': 'total'},
    {
      '1': 'users',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.openim.chat.common.UserFullInfo',
      '10': 'users'
    },
  ],
};

/// Descriptor for `SearchUserInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchUserInfoRespDescriptor = $convert.base64Decode(
    'ChJTZWFyY2hVc2VySW5mb1Jlc3ASFAoFdG90YWwYASABKA1SBXRvdGFsEjYKBXVzZXJzGAIgAy'
    'gLMiAub3BlbmltLmNoYXQuY29tbW9uLlVzZXJGdWxsSW5mb1IFdXNlcnM=');

@$core.Deprecated('Use getTokenForVideoMeetingReqDescriptor instead')
const GetTokenForVideoMeetingReq$json = {
  '1': 'GetTokenForVideoMeetingReq',
  '2': [
    {'1': 'room', '3': 1, '4': 1, '5': 9, '10': 'room'},
    {'1': 'identity', '3': 2, '4': 1, '5': 9, '10': 'identity'},
  ],
};

/// Descriptor for `GetTokenForVideoMeetingReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTokenForVideoMeetingReqDescriptor =
    $convert.base64Decode(
        'ChpHZXRUb2tlbkZvclZpZGVvTWVldGluZ1JlcRISCgRyb29tGAEgASgJUgRyb29tEhoKCGlkZW'
        '50aXR5GAIgASgJUghpZGVudGl0eQ==');

@$core.Deprecated('Use getTokenForVideoMeetingRespDescriptor instead')
const GetTokenForVideoMeetingResp$json = {
  '1': 'GetTokenForVideoMeetingResp',
  '2': [
    {'1': 'serverUrl', '3': 1, '4': 1, '5': 9, '10': 'serverUrl'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `GetTokenForVideoMeetingResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTokenForVideoMeetingRespDescriptor =
    $convert.base64Decode(
        'ChtHZXRUb2tlbkZvclZpZGVvTWVldGluZ1Jlc3ASHAoJc2VydmVyVXJsGAEgASgJUglzZXJ2ZX'
        'JVcmwSFAoFdG9rZW4YAiABKAlSBXRva2Vu');

@$core.Deprecated('Use getRTCTokenReqDescriptor instead')
const GetRTCTokenReq$json = {
  '1': 'GetRTCTokenReq',
  '2': [
    {'1': 'roomId', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'userId', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'expireTime', '3': 3, '4': 1, '5': 5, '10': 'expireTime'},
  ],
};

/// Descriptor for `GetRTCTokenReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRTCTokenReqDescriptor = $convert.base64Decode(
    'Cg5HZXRSVENUb2tlblJlcRIWCgZyb29tSWQYASABKAlSBnJvb21JZBIWCgZ1c2VySWQYAiABKA'
    'lSBnVzZXJJZBIeCgpleHBpcmVUaW1lGAMgASgFUgpleHBpcmVUaW1l');

@$core.Deprecated('Use getRTCTokenRespDescriptor instead')
const GetRTCTokenResp$json = {
  '1': 'GetRTCTokenResp',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'appId', '3': 2, '4': 1, '5': 9, '10': 'appId'},
    {'1': 'roomId', '3': 3, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'userId', '3': 4, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'expireAt', '3': 5, '4': 1, '5': 3, '10': 'expireAt'},
  ],
};

/// Descriptor for `GetRTCTokenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRTCTokenRespDescriptor = $convert.base64Decode(
    'Cg9HZXRSVENUb2tlblJlc3ASFAoFdG9rZW4YASABKAlSBXRva2VuEhQKBWFwcElkGAIgASgJUg'
    'VhcHBJZBIWCgZyb29tSWQYAyABKAlSBnJvb21JZBIWCgZ1c2VySWQYBCABKAlSBnVzZXJJZBIa'
    'CghleHBpcmVBdBgFIAEoA1IIZXhwaXJlQXQ=');

@$core.Deprecated('Use checkUserExistReqDescriptor instead')
const CheckUserExistReq$json = {
  '1': 'CheckUserExistReq',
  '2': [
    {
      '1': 'user',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.openim.chat.RegisterUserInfo',
      '10': 'user'
    },
  ],
};

/// Descriptor for `CheckUserExistReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkUserExistReqDescriptor = $convert.base64Decode(
    'ChFDaGVja1VzZXJFeGlzdFJlcRIxCgR1c2VyGAEgASgLMh0ub3BlbmltLmNoYXQuUmVnaXN0ZX'
    'JVc2VySW5mb1IEdXNlcg==');

@$core.Deprecated('Use checkUserExistRespDescriptor instead')
const CheckUserExistResp$json = {
  '1': 'CheckUserExistResp',
  '2': [
    {'1': 'userid', '3': 1, '4': 1, '5': 9, '10': 'userid'},
    {'1': 'isRegistered', '3': 2, '4': 1, '5': 8, '10': 'isRegistered'},
  ],
};

/// Descriptor for `CheckUserExistResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkUserExistRespDescriptor = $convert.base64Decode(
    'ChJDaGVja1VzZXJFeGlzdFJlc3ASFgoGdXNlcmlkGAEgASgJUgZ1c2VyaWQSIgoMaXNSZWdpc3'
    'RlcmVkGAIgASgIUgxpc1JlZ2lzdGVyZWQ=');

@$core.Deprecated('Use delUserAccountReqDescriptor instead')
const DelUserAccountReq$json = {
  '1': 'DelUserAccountReq',
  '2': [
    {'1': 'userIDs', '3': 1, '4': 3, '5': 9, '10': 'userIDs'},
  ],
};

/// Descriptor for `DelUserAccountReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delUserAccountReqDescriptor = $convert.base64Decode(
    'ChFEZWxVc2VyQWNjb3VudFJlcRIYCgd1c2VySURzGAEgAygJUgd1c2VySURz');

@$core.Deprecated('Use delUserAccountRespDescriptor instead')
const DelUserAccountResp$json = {
  '1': 'DelUserAccountResp',
};

/// Descriptor for `DelUserAccountResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delUserAccountRespDescriptor =
    $convert.base64Decode('ChJEZWxVc2VyQWNjb3VudFJlc3A=');

@$core.Deprecated('Use setAllowRegisterReqDescriptor instead')
const SetAllowRegisterReq$json = {
  '1': 'SetAllowRegisterReq',
  '2': [
    {'1': 'allowRegister', '3': 1, '4': 1, '5': 8, '10': 'allowRegister'},
  ],
};

/// Descriptor for `SetAllowRegisterReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAllowRegisterReqDescriptor = $convert.base64Decode(
    'ChNTZXRBbGxvd1JlZ2lzdGVyUmVxEiQKDWFsbG93UmVnaXN0ZXIYASABKAhSDWFsbG93UmVnaX'
    'N0ZXI=');

@$core.Deprecated('Use setAllowRegisterRespDescriptor instead')
const SetAllowRegisterResp$json = {
  '1': 'SetAllowRegisterResp',
};

/// Descriptor for `SetAllowRegisterResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAllowRegisterRespDescriptor =
    $convert.base64Decode('ChRTZXRBbGxvd1JlZ2lzdGVyUmVzcA==');

@$core.Deprecated('Use getAllowRegisterReqDescriptor instead')
const GetAllowRegisterReq$json = {
  '1': 'GetAllowRegisterReq',
};

/// Descriptor for `GetAllowRegisterReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAllowRegisterReqDescriptor =
    $convert.base64Decode('ChNHZXRBbGxvd1JlZ2lzdGVyUmVx');

@$core.Deprecated('Use getAllowRegisterRespDescriptor instead')
const GetAllowRegisterResp$json = {
  '1': 'GetAllowRegisterResp',
  '2': [
    {'1': 'allowRegister', '3': 1, '4': 1, '5': 8, '10': 'allowRegister'},
  ],
};

/// Descriptor for `GetAllowRegisterResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAllowRegisterRespDescriptor = $convert.base64Decode(
    'ChRHZXRBbGxvd1JlZ2lzdGVyUmVzcBIkCg1hbGxvd1JlZ2lzdGVyGAEgASgIUg1hbGxvd1JlZ2'
    'lzdGVy');

const $core.Map<$core.String, $core.dynamic> chatServiceBase$json = {
  '1': 'chat',
  '2': [
    {
      '1': 'UpdateUserInfo',
      '2': '.openim.chat.UpdateUserInfoReq',
      '3': '.openim.chat.UpdateUserInfoResp'
    },
    {
      '1': 'AddUserAccount',
      '2': '.openim.chat.AddUserAccountReq',
      '3': '.openim.chat.AddUserAccountResp'
    },
    {
      '1': 'SearchUserPublicInfo',
      '2': '.openim.chat.SearchUserPublicInfoReq',
      '3': '.openim.chat.SearchUserPublicInfoResp'
    },
    {
      '1': 'FindUserPublicInfo',
      '2': '.openim.chat.FindUserPublicInfoReq',
      '3': '.openim.chat.FindUserPublicInfoResp'
    },
    {
      '1': 'SearchUserFullInfo',
      '2': '.openim.chat.SearchUserFullInfoReq',
      '3': '.openim.chat.SearchUserFullInfoResp'
    },
    {
      '1': 'FindUserFullInfo',
      '2': '.openim.chat.FindUserFullInfoReq',
      '3': '.openim.chat.FindUserFullInfoResp'
    },
    {
      '1': 'SendVerifyCode',
      '2': '.openim.chat.SendVerifyCodeReq',
      '3': '.openim.chat.SendVerifyCodeResp'
    },
    {
      '1': 'VerifyCode',
      '2': '.openim.chat.VerifyCodeReq',
      '3': '.openim.chat.VerifyCodeResp'
    },
    {
      '1': 'RegisterUser',
      '2': '.openim.chat.RegisterUserReq',
      '3': '.openim.chat.RegisterUserResp'
    },
    {'1': 'Login', '2': '.openim.chat.LoginReq', '3': '.openim.chat.LoginResp'},
    {
      '1': 'ResetPassword',
      '2': '.openim.chat.ResetPasswordReq',
      '3': '.openim.chat.ResetPasswordResp'
    },
    {
      '1': 'ChangePassword',
      '2': '.openim.chat.ChangePasswordReq',
      '3': '.openim.chat.ChangePasswordResp'
    },
    {
      '1': 'CheckUserExist',
      '2': '.openim.chat.CheckUserExistReq',
      '3': '.openim.chat.CheckUserExistResp'
    },
    {
      '1': 'DelUserAccount',
      '2': '.openim.chat.DelUserAccountReq',
      '3': '.openim.chat.DelUserAccountResp'
    },
    {
      '1': 'FindUserAccount',
      '2': '.openim.chat.FindUserAccountReq',
      '3': '.openim.chat.FindUserAccountResp'
    },
    {
      '1': 'FindAccountUser',
      '2': '.openim.chat.FindAccountUserReq',
      '3': '.openim.chat.FindAccountUserResp'
    },
    {
      '1': 'OpenIMCallback',
      '2': '.openim.chat.OpenIMCallbackReq',
      '3': '.openim.chat.OpenIMCallbackResp'
    },
    {
      '1': 'UserLoginCount',
      '2': '.openim.chat.UserLoginCountReq',
      '3': '.openim.chat.UserLoginCountResp'
    },
    {
      '1': 'SearchUserInfo',
      '2': '.openim.chat.SearchUserInfoReq',
      '3': '.openim.chat.SearchUserInfoResp'
    },
    {
      '1': 'GetTokenForVideoMeeting',
      '2': '.openim.chat.GetTokenForVideoMeetingReq',
      '3': '.openim.chat.GetTokenForVideoMeetingResp'
    },
    {
      '1': 'GetRTCToken',
      '2': '.openim.chat.GetRTCTokenReq',
      '3': '.openim.chat.GetRTCTokenResp'
    },
    {
      '1': 'SetAllowRegister',
      '2': '.openim.chat.SetAllowRegisterReq',
      '3': '.openim.chat.SetAllowRegisterResp'
    },
    {
      '1': 'GetAllowRegister',
      '2': '.openim.chat.GetAllowRegisterReq',
      '3': '.openim.chat.GetAllowRegisterResp'
    },
  ],
};

@$core.Deprecated('Use chatServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    chatServiceBase$messageJson = {
  '.openim.chat.UpdateUserInfoReq': UpdateUserInfoReq$json,
  '.openim.protobuf.StringValue': $0.StringValue$json,
  '.openim.protobuf.Int32Value': $0.Int32Value$json,
  '.openim.protobuf.Int64Value': $0.Int64Value$json,
  '.openim.chat.UpdateUserInfoResp': UpdateUserInfoResp$json,
  '.openim.chat.AddUserAccountReq': AddUserAccountReq$json,
  '.openim.chat.RegisterUserInfo': RegisterUserInfo$json,
  '.openim.chat.AddUserAccountResp': AddUserAccountResp$json,
  '.openim.chat.SearchUserPublicInfoReq': SearchUserPublicInfoReq$json,
  '.openim.sdkws.RequestPagination': $2.RequestPagination$json,
  '.openim.chat.SearchUserPublicInfoResp': SearchUserPublicInfoResp$json,
  '.openim.chat.common.UserPublicInfo': $1.UserPublicInfo$json,
  '.openim.chat.FindUserPublicInfoReq': FindUserPublicInfoReq$json,
  '.openim.chat.FindUserPublicInfoResp': FindUserPublicInfoResp$json,
  '.openim.chat.SearchUserFullInfoReq': SearchUserFullInfoReq$json,
  '.openim.chat.SearchUserFullInfoResp': SearchUserFullInfoResp$json,
  '.openim.chat.common.UserFullInfo': $1.UserFullInfo$json,
  '.openim.chat.FindUserFullInfoReq': FindUserFullInfoReq$json,
  '.openim.chat.FindUserFullInfoResp': FindUserFullInfoResp$json,
  '.openim.chat.SendVerifyCodeReq': SendVerifyCodeReq$json,
  '.openim.chat.SendVerifyCodeResp': SendVerifyCodeResp$json,
  '.openim.chat.VerifyCodeReq': VerifyCodeReq$json,
  '.openim.chat.VerifyCodeResp': VerifyCodeResp$json,
  '.openim.chat.RegisterUserReq': RegisterUserReq$json,
  '.openim.chat.RegisterUserResp': RegisterUserResp$json,
  '.openim.chat.LoginReq': LoginReq$json,
  '.openim.chat.LoginResp': LoginResp$json,
  '.openim.chat.ResetPasswordReq': ResetPasswordReq$json,
  '.openim.chat.ResetPasswordResp': ResetPasswordResp$json,
  '.openim.chat.ChangePasswordReq': ChangePasswordReq$json,
  '.openim.chat.ChangePasswordResp': ChangePasswordResp$json,
  '.openim.chat.CheckUserExistReq': CheckUserExistReq$json,
  '.openim.chat.CheckUserExistResp': CheckUserExistResp$json,
  '.openim.chat.DelUserAccountReq': DelUserAccountReq$json,
  '.openim.chat.DelUserAccountResp': DelUserAccountResp$json,
  '.openim.chat.FindUserAccountReq': FindUserAccountReq$json,
  '.openim.chat.FindUserAccountResp': FindUserAccountResp$json,
  '.openim.chat.FindUserAccountResp.UserAccountMapEntry':
      FindUserAccountResp_UserAccountMapEntry$json,
  '.openim.chat.FindAccountUserReq': FindAccountUserReq$json,
  '.openim.chat.FindAccountUserResp': FindAccountUserResp$json,
  '.openim.chat.FindAccountUserResp.AccountUserMapEntry':
      FindAccountUserResp_AccountUserMapEntry$json,
  '.openim.chat.OpenIMCallbackReq': OpenIMCallbackReq$json,
  '.openim.chat.OpenIMCallbackResp': OpenIMCallbackResp$json,
  '.openim.chat.UserLoginCountReq': UserLoginCountReq$json,
  '.openim.chat.UserLoginCountResp': UserLoginCountResp$json,
  '.openim.chat.UserLoginCountResp.CountEntry':
      UserLoginCountResp_CountEntry$json,
  '.openim.chat.SearchUserInfoReq': SearchUserInfoReq$json,
  '.openim.chat.SearchUserInfoResp': SearchUserInfoResp$json,
  '.openim.chat.GetTokenForVideoMeetingReq': GetTokenForVideoMeetingReq$json,
  '.openim.chat.GetTokenForVideoMeetingResp': GetTokenForVideoMeetingResp$json,
  '.openim.chat.GetRTCTokenReq': GetRTCTokenReq$json,
  '.openim.chat.GetRTCTokenResp': GetRTCTokenResp$json,
  '.openim.chat.SetAllowRegisterReq': SetAllowRegisterReq$json,
  '.openim.chat.SetAllowRegisterResp': SetAllowRegisterResp$json,
  '.openim.chat.GetAllowRegisterReq': GetAllowRegisterReq$json,
  '.openim.chat.GetAllowRegisterResp': GetAllowRegisterResp$json,
};

/// Descriptor for `chat`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List chatServiceDescriptor = $convert.base64Decode(
    'CgRjaGF0ElEKDlVwZGF0ZVVzZXJJbmZvEh4ub3BlbmltLmNoYXQuVXBkYXRlVXNlckluZm9SZX'
    'EaHy5vcGVuaW0uY2hhdC5VcGRhdGVVc2VySW5mb1Jlc3ASUQoOQWRkVXNlckFjY291bnQSHi5v'
    'cGVuaW0uY2hhdC5BZGRVc2VyQWNjb3VudFJlcRofLm9wZW5pbS5jaGF0LkFkZFVzZXJBY2NvdW'
    '50UmVzcBJjChRTZWFyY2hVc2VyUHVibGljSW5mbxIkLm9wZW5pbS5jaGF0LlNlYXJjaFVzZXJQ'
    'dWJsaWNJbmZvUmVxGiUub3BlbmltLmNoYXQuU2VhcmNoVXNlclB1YmxpY0luZm9SZXNwEl0KEk'
    'ZpbmRVc2VyUHVibGljSW5mbxIiLm9wZW5pbS5jaGF0LkZpbmRVc2VyUHVibGljSW5mb1JlcRoj'
    'Lm9wZW5pbS5jaGF0LkZpbmRVc2VyUHVibGljSW5mb1Jlc3ASXQoSU2VhcmNoVXNlckZ1bGxJbm'
    'ZvEiIub3BlbmltLmNoYXQuU2VhcmNoVXNlckZ1bGxJbmZvUmVxGiMub3BlbmltLmNoYXQuU2Vh'
    'cmNoVXNlckZ1bGxJbmZvUmVzcBJXChBGaW5kVXNlckZ1bGxJbmZvEiAub3BlbmltLmNoYXQuRm'
    'luZFVzZXJGdWxsSW5mb1JlcRohLm9wZW5pbS5jaGF0LkZpbmRVc2VyRnVsbEluZm9SZXNwElEK'
    'DlNlbmRWZXJpZnlDb2RlEh4ub3BlbmltLmNoYXQuU2VuZFZlcmlmeUNvZGVSZXEaHy5vcGVuaW'
    '0uY2hhdC5TZW5kVmVyaWZ5Q29kZVJlc3ASRQoKVmVyaWZ5Q29kZRIaLm9wZW5pbS5jaGF0LlZl'
    'cmlmeUNvZGVSZXEaGy5vcGVuaW0uY2hhdC5WZXJpZnlDb2RlUmVzcBJLCgxSZWdpc3RlclVzZX'
    'ISHC5vcGVuaW0uY2hhdC5SZWdpc3RlclVzZXJSZXEaHS5vcGVuaW0uY2hhdC5SZWdpc3RlclVz'
    'ZXJSZXNwEjYKBUxvZ2luEhUub3BlbmltLmNoYXQuTG9naW5SZXEaFi5vcGVuaW0uY2hhdC5Mb2'
    'dpblJlc3ASTgoNUmVzZXRQYXNzd29yZBIdLm9wZW5pbS5jaGF0LlJlc2V0UGFzc3dvcmRSZXEa'
    'Hi5vcGVuaW0uY2hhdC5SZXNldFBhc3N3b3JkUmVzcBJRCg5DaGFuZ2VQYXNzd29yZBIeLm9wZW'
    '5pbS5jaGF0LkNoYW5nZVBhc3N3b3JkUmVxGh8ub3BlbmltLmNoYXQuQ2hhbmdlUGFzc3dvcmRS'
    'ZXNwElEKDkNoZWNrVXNlckV4aXN0Eh4ub3BlbmltLmNoYXQuQ2hlY2tVc2VyRXhpc3RSZXEaHy'
    '5vcGVuaW0uY2hhdC5DaGVja1VzZXJFeGlzdFJlc3ASUQoORGVsVXNlckFjY291bnQSHi5vcGVu'
    'aW0uY2hhdC5EZWxVc2VyQWNjb3VudFJlcRofLm9wZW5pbS5jaGF0LkRlbFVzZXJBY2NvdW50Um'
    'VzcBJUCg9GaW5kVXNlckFjY291bnQSHy5vcGVuaW0uY2hhdC5GaW5kVXNlckFjY291bnRSZXEa'
    'IC5vcGVuaW0uY2hhdC5GaW5kVXNlckFjY291bnRSZXNwElQKD0ZpbmRBY2NvdW50VXNlchIfLm'
    '9wZW5pbS5jaGF0LkZpbmRBY2NvdW50VXNlclJlcRogLm9wZW5pbS5jaGF0LkZpbmRBY2NvdW50'
    'VXNlclJlc3ASUQoOT3BlbklNQ2FsbGJhY2sSHi5vcGVuaW0uY2hhdC5PcGVuSU1DYWxsYmFja1'
    'JlcRofLm9wZW5pbS5jaGF0Lk9wZW5JTUNhbGxiYWNrUmVzcBJRCg5Vc2VyTG9naW5Db3VudBIe'
    'Lm9wZW5pbS5jaGF0LlVzZXJMb2dpbkNvdW50UmVxGh8ub3BlbmltLmNoYXQuVXNlckxvZ2luQ2'
    '91bnRSZXNwElEKDlNlYXJjaFVzZXJJbmZvEh4ub3BlbmltLmNoYXQuU2VhcmNoVXNlckluZm9S'
    'ZXEaHy5vcGVuaW0uY2hhdC5TZWFyY2hVc2VySW5mb1Jlc3ASbAoXR2V0VG9rZW5Gb3JWaWRlb0'
    '1lZXRpbmcSJy5vcGVuaW0uY2hhdC5HZXRUb2tlbkZvclZpZGVvTWVldGluZ1JlcRooLm9wZW5p'
    'bS5jaGF0LkdldFRva2VuRm9yVmlkZW9NZWV0aW5nUmVzcBJICgtHZXRSVENUb2tlbhIbLm9wZW'
    '5pbS5jaGF0LkdldFJUQ1Rva2VuUmVxGhwub3BlbmltLmNoYXQuR2V0UlRDVG9rZW5SZXNwElcK'
    'EFNldEFsbG93UmVnaXN0ZXISIC5vcGVuaW0uY2hhdC5TZXRBbGxvd1JlZ2lzdGVyUmVxGiEub3'
    'BlbmltLmNoYXQuU2V0QWxsb3dSZWdpc3RlclJlc3ASVwoQR2V0QWxsb3dSZWdpc3RlchIgLm9w'
    'ZW5pbS5jaGF0LkdldEFsbG93UmVnaXN0ZXJSZXEaIS5vcGVuaW0uY2hhdC5HZXRBbGxvd1JlZ2'
    'lzdGVyUmVzcA==');
