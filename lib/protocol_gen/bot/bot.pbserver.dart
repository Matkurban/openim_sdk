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

import 'package:protobuf/protobuf.dart' as $pb;

import 'bot.pb.dart' as $1;
import 'bot.pbjson.dart';

export 'bot.pb.dart';

abstract class botServiceBase extends $pb.GeneratedService {
  $async.Future<$1.CreateAgentResp> createAgent($pb.ServerContext ctx, $1.CreateAgentReq request);
  $async.Future<$1.UpdateAgentResp> updateAgent($pb.ServerContext ctx, $1.UpdateAgentReq request);
  $async.Future<$1.PageFindAgentResp> pageFindAgent(
      $pb.ServerContext ctx, $1.PageFindAgentReq request);
  $async.Future<$1.DeleteAgentResp> deleteAgent($pb.ServerContext ctx, $1.DeleteAgentReq request);
  $async.Future<$1.SendBotMessageResp> sendBotMessage(
      $pb.ServerContext ctx, $1.SendBotMessageReq request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateAgent':
        return $1.CreateAgentReq();
      case 'UpdateAgent':
        return $1.UpdateAgentReq();
      case 'PageFindAgent':
        return $1.PageFindAgentReq();
      case 'DeleteAgent':
        return $1.DeleteAgentReq();
      case 'SendBotMessage':
        return $1.SendBotMessageReq();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall(
      $pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateAgent':
        return createAgent(ctx, request as $1.CreateAgentReq);
      case 'UpdateAgent':
        return updateAgent(ctx, request as $1.UpdateAgentReq);
      case 'PageFindAgent':
        return pageFindAgent(ctx, request as $1.PageFindAgentReq);
      case 'DeleteAgent':
        return deleteAgent(ctx, request as $1.DeleteAgentReq);
      case 'SendBotMessage':
        return sendBotMessage(ctx, request as $1.SendBotMessageReq);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => botServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson =>
      botServiceBase$messageJson;
}
