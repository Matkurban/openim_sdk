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

import 'package:protobuf/protobuf.dart' as $pb;

/// /////////////////////////////////base end/////////////////////////////////////
class PullOrder extends $pb.ProtobufEnum {
  static const PullOrder PullOrderAsc = PullOrder._(0, _omitEnumNames ? '' : 'PullOrderAsc');
  static const PullOrder PullOrderDesc = PullOrder._(1, _omitEnumNames ? '' : 'PullOrderDesc');

  static const $core.List<PullOrder> values = <PullOrder>[
    PullOrderAsc,
    PullOrderDesc,
  ];

  static final $core.List<PullOrder?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static PullOrder? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PullOrder._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
