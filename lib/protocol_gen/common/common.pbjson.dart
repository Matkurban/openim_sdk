// This is a generated file - do not edit.
//
// Generated from common/common.proto.

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

@$core.Deprecated('Use userFullInfoDescriptor instead')
const UserFullInfo$json = {
  '1': 'UserFullInfo',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'account', '3': 3, '4': 1, '5': 9, '10': 'account'},
    {'1': 'phoneNumber', '3': 4, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'areaCode', '3': 5, '4': 1, '5': 9, '10': 'areaCode'},
    {'1': 'email', '3': 6, '4': 1, '5': 9, '10': 'email'},
    {'1': 'nickname', '3': 7, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'faceURL', '3': 8, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'gender', '3': 9, '4': 1, '5': 5, '10': 'gender'},
    {'1': 'level', '3': 10, '4': 1, '5': 5, '10': 'level'},
    {'1': 'birth', '3': 11, '4': 1, '5': 3, '10': 'birth'},
    {'1': 'allowAddFriend', '3': 12, '4': 1, '5': 5, '10': 'allowAddFriend'},
    {'1': 'allowBeep', '3': 13, '4': 1, '5': 5, '10': 'allowBeep'},
    {'1': 'allowVibration', '3': 14, '4': 1, '5': 5, '10': 'allowVibration'},
    {
      '1': 'globalRecvMsgOpt',
      '3': 15,
      '4': 1,
      '5': 5,
      '10': 'globalRecvMsgOpt'
    },
    {'1': 'registerType', '3': 16, '4': 1, '5': 5, '10': 'registerType'},
  ],
};

/// Descriptor for `UserFullInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userFullInfoDescriptor = $convert.base64Decode(
    'CgxVc2VyRnVsbEluZm8SFgoGdXNlcklEGAEgASgJUgZ1c2VySUQSGgoIcGFzc3dvcmQYAiABKA'
    'lSCHBhc3N3b3JkEhgKB2FjY291bnQYAyABKAlSB2FjY291bnQSIAoLcGhvbmVOdW1iZXIYBCAB'
    'KAlSC3Bob25lTnVtYmVyEhoKCGFyZWFDb2RlGAUgASgJUghhcmVhQ29kZRIUCgVlbWFpbBgGIA'
    'EoCVIFZW1haWwSGgoIbmlja25hbWUYByABKAlSCG5pY2tuYW1lEhgKB2ZhY2VVUkwYCCABKAlS'
    'B2ZhY2VVUkwSFgoGZ2VuZGVyGAkgASgFUgZnZW5kZXISFAoFbGV2ZWwYCiABKAVSBWxldmVsEh'
    'QKBWJpcnRoGAsgASgDUgViaXJ0aBImCg5hbGxvd0FkZEZyaWVuZBgMIAEoBVIOYWxsb3dBZGRG'
    'cmllbmQSHAoJYWxsb3dCZWVwGA0gASgFUglhbGxvd0JlZXASJgoOYWxsb3dWaWJyYXRpb24YDi'
    'ABKAVSDmFsbG93VmlicmF0aW9uEioKEGdsb2JhbFJlY3ZNc2dPcHQYDyABKAVSEGdsb2JhbFJl'
    'Y3ZNc2dPcHQSIgoMcmVnaXN0ZXJUeXBlGBAgASgFUgxyZWdpc3RlclR5cGU=');

@$core.Deprecated('Use userPublicInfoDescriptor instead')
const UserPublicInfo$json = {
  '1': 'UserPublicInfo',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'account', '3': 2, '4': 1, '5': 9, '10': 'account'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'nickname', '3': 4, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'faceURL', '3': 5, '4': 1, '5': 9, '10': 'faceURL'},
    {'1': 'gender', '3': 6, '4': 1, '5': 5, '10': 'gender'},
    {'1': 'level', '3': 7, '4': 1, '5': 5, '10': 'level'},
  ],
};

/// Descriptor for `UserPublicInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userPublicInfoDescriptor = $convert.base64Decode(
    'Cg5Vc2VyUHVibGljSW5mbxIWCgZ1c2VySUQYASABKAlSBnVzZXJJRBIYCgdhY2NvdW50GAIgAS'
    'gJUgdhY2NvdW50EhQKBWVtYWlsGAMgASgJUgVlbWFpbBIaCghuaWNrbmFtZRgEIAEoCVIIbmlj'
    'a25hbWUSGAoHZmFjZVVSTBgFIAEoCVIHZmFjZVVSTBIWCgZnZW5kZXIYBiABKAVSBmdlbmRlch'
    'IUCgVsZXZlbBgHIAEoBVIFbGV2ZWw=');

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

@$core.Deprecated('Use appletInfoDescriptor instead')
const AppletInfo$json = {
  '1': 'AppletInfo',
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

/// Descriptor for `AppletInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appletInfoDescriptor = $convert.base64Decode(
    'CgpBcHBsZXRJbmZvEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhQKBWFwcE'
    'lEGAMgASgJUgVhcHBJRBISCgRpY29uGAQgASgJUgRpY29uEhAKA3VybBgFIAEoCVIDdXJsEhAK'
    'A21kNRgGIAEoCVIDbWQ1EhIKBHNpemUYByABKANSBHNpemUSGAoHdmVyc2lvbhgIIAEoCVIHdm'
    'Vyc2lvbhIaCghwcmlvcml0eRgJIAEoDVIIcHJpb3JpdHkSFgoGc3RhdHVzGAogASgNUgZzdGF0'
    'dXMSHgoKY3JlYXRlVGltZRgLIAEoA1IKY3JlYXRlVGltZQ==');

@$core.Deprecated('Use logInfoDescriptor instead')
const LogInfo$json = {
  '1': 'LogInfo',
  '2': [
    {'1': 'userID', '3': 1, '4': 1, '5': 9, '10': 'userID'},
    {'1': 'platform', '3': 2, '4': 1, '5': 5, '10': 'platform'},
    {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
    {'1': 'createTime', '3': 4, '4': 1, '5': 3, '10': 'createTime'},
    {'1': 'nickname', '3': 5, '4': 1, '5': 9, '10': 'nickname'},
    {'1': 'logID', '3': 6, '4': 1, '5': 9, '10': 'logID'},
    {'1': 'filename', '3': 7, '4': 1, '5': 9, '10': 'filename'},
    {'1': 'systemType', '3': 8, '4': 1, '5': 9, '10': 'systemType'},
    {'1': 'ex', '3': 9, '4': 1, '5': 9, '10': 'ex'},
    {'1': 'version', '3': 10, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `LogInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logInfoDescriptor = $convert.base64Decode(
    'CgdMb2dJbmZvEhYKBnVzZXJJRBgBIAEoCVIGdXNlcklEEhoKCHBsYXRmb3JtGAIgASgFUghwbG'
    'F0Zm9ybRIQCgN1cmwYAyABKAlSA3VybBIeCgpjcmVhdGVUaW1lGAQgASgDUgpjcmVhdGVUaW1l'
    'EhoKCG5pY2tuYW1lGAUgASgJUghuaWNrbmFtZRIUCgVsb2dJRBgGIAEoCVIFbG9nSUQSGgoIZm'
    'lsZW5hbWUYByABKAlSCGZpbGVuYW1lEh4KCnN5c3RlbVR5cGUYCCABKAlSCnN5c3RlbVR5cGUS'
    'DgoCZXgYCSABKAlSAmV4EhgKB3ZlcnNpb24YCiABKAlSB3ZlcnNpb24=');
