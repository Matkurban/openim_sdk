// This is a generated file - do not edit.
//
// Generated from chat/chat.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'chat.pb.dart' as $3;
import 'chat.pbjson.dart';

export 'chat.pb.dart';

abstract class chatServiceBase extends $pb.GeneratedService {
  $async.Future<$3.UpdateUserInfoResp> updateUserInfo(
      $pb.ServerContext ctx, $3.UpdateUserInfoReq request);
  $async.Future<$3.AddUserAccountResp> addUserAccount(
      $pb.ServerContext ctx, $3.AddUserAccountReq request);
  $async.Future<$3.SearchUserPublicInfoResp> searchUserPublicInfo(
      $pb.ServerContext ctx, $3.SearchUserPublicInfoReq request);
  $async.Future<$3.FindUserPublicInfoResp> findUserPublicInfo(
      $pb.ServerContext ctx, $3.FindUserPublicInfoReq request);
  $async.Future<$3.SearchUserFullInfoResp> searchUserFullInfo(
      $pb.ServerContext ctx, $3.SearchUserFullInfoReq request);
  $async.Future<$3.FindUserFullInfoResp> findUserFullInfo(
      $pb.ServerContext ctx, $3.FindUserFullInfoReq request);
  $async.Future<$3.SendVerifyCodeResp> sendVerifyCode(
      $pb.ServerContext ctx, $3.SendVerifyCodeReq request);
  $async.Future<$3.VerifyCodeResp> verifyCode(
      $pb.ServerContext ctx, $3.VerifyCodeReq request);
  $async.Future<$3.RegisterUserResp> registerUser(
      $pb.ServerContext ctx, $3.RegisterUserReq request);
  $async.Future<$3.LoginResp> login($pb.ServerContext ctx, $3.LoginReq request);
  $async.Future<$3.ResetPasswordResp> resetPassword(
      $pb.ServerContext ctx, $3.ResetPasswordReq request);
  $async.Future<$3.ChangePasswordResp> changePassword(
      $pb.ServerContext ctx, $3.ChangePasswordReq request);
  $async.Future<$3.CheckUserExistResp> checkUserExist(
      $pb.ServerContext ctx, $3.CheckUserExistReq request);
  $async.Future<$3.DelUserAccountResp> delUserAccount(
      $pb.ServerContext ctx, $3.DelUserAccountReq request);
  $async.Future<$3.FindUserAccountResp> findUserAccount(
      $pb.ServerContext ctx, $3.FindUserAccountReq request);
  $async.Future<$3.FindAccountUserResp> findAccountUser(
      $pb.ServerContext ctx, $3.FindAccountUserReq request);
  $async.Future<$3.OpenIMCallbackResp> openIMCallback(
      $pb.ServerContext ctx, $3.OpenIMCallbackReq request);
  $async.Future<$3.UserLoginCountResp> userLoginCount(
      $pb.ServerContext ctx, $3.UserLoginCountReq request);
  $async.Future<$3.SearchUserInfoResp> searchUserInfo(
      $pb.ServerContext ctx, $3.SearchUserInfoReq request);
  $async.Future<$3.GetTokenForVideoMeetingResp> getTokenForVideoMeeting(
      $pb.ServerContext ctx, $3.GetTokenForVideoMeetingReq request);
  $async.Future<$3.GetRTCTokenResp> getRTCToken(
      $pb.ServerContext ctx, $3.GetRTCTokenReq request);
  $async.Future<$3.SetAllowRegisterResp> setAllowRegister(
      $pb.ServerContext ctx, $3.SetAllowRegisterReq request);
  $async.Future<$3.GetAllowRegisterResp> getAllowRegister(
      $pb.ServerContext ctx, $3.GetAllowRegisterReq request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'UpdateUserInfo':
        return $3.UpdateUserInfoReq();
      case 'AddUserAccount':
        return $3.AddUserAccountReq();
      case 'SearchUserPublicInfo':
        return $3.SearchUserPublicInfoReq();
      case 'FindUserPublicInfo':
        return $3.FindUserPublicInfoReq();
      case 'SearchUserFullInfo':
        return $3.SearchUserFullInfoReq();
      case 'FindUserFullInfo':
        return $3.FindUserFullInfoReq();
      case 'SendVerifyCode':
        return $3.SendVerifyCodeReq();
      case 'VerifyCode':
        return $3.VerifyCodeReq();
      case 'RegisterUser':
        return $3.RegisterUserReq();
      case 'Login':
        return $3.LoginReq();
      case 'ResetPassword':
        return $3.ResetPasswordReq();
      case 'ChangePassword':
        return $3.ChangePasswordReq();
      case 'CheckUserExist':
        return $3.CheckUserExistReq();
      case 'DelUserAccount':
        return $3.DelUserAccountReq();
      case 'FindUserAccount':
        return $3.FindUserAccountReq();
      case 'FindAccountUser':
        return $3.FindAccountUserReq();
      case 'OpenIMCallback':
        return $3.OpenIMCallbackReq();
      case 'UserLoginCount':
        return $3.UserLoginCountReq();
      case 'SearchUserInfo':
        return $3.SearchUserInfoReq();
      case 'GetTokenForVideoMeeting':
        return $3.GetTokenForVideoMeetingReq();
      case 'GetRTCToken':
        return $3.GetRTCTokenReq();
      case 'SetAllowRegister':
        return $3.SetAllowRegisterReq();
      case 'GetAllowRegister':
        return $3.GetAllowRegisterReq();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'UpdateUserInfo':
        return updateUserInfo(ctx, request as $3.UpdateUserInfoReq);
      case 'AddUserAccount':
        return addUserAccount(ctx, request as $3.AddUserAccountReq);
      case 'SearchUserPublicInfo':
        return searchUserPublicInfo(ctx, request as $3.SearchUserPublicInfoReq);
      case 'FindUserPublicInfo':
        return findUserPublicInfo(ctx, request as $3.FindUserPublicInfoReq);
      case 'SearchUserFullInfo':
        return searchUserFullInfo(ctx, request as $3.SearchUserFullInfoReq);
      case 'FindUserFullInfo':
        return findUserFullInfo(ctx, request as $3.FindUserFullInfoReq);
      case 'SendVerifyCode':
        return sendVerifyCode(ctx, request as $3.SendVerifyCodeReq);
      case 'VerifyCode':
        return verifyCode(ctx, request as $3.VerifyCodeReq);
      case 'RegisterUser':
        return registerUser(ctx, request as $3.RegisterUserReq);
      case 'Login':
        return login(ctx, request as $3.LoginReq);
      case 'ResetPassword':
        return resetPassword(ctx, request as $3.ResetPasswordReq);
      case 'ChangePassword':
        return changePassword(ctx, request as $3.ChangePasswordReq);
      case 'CheckUserExist':
        return checkUserExist(ctx, request as $3.CheckUserExistReq);
      case 'DelUserAccount':
        return delUserAccount(ctx, request as $3.DelUserAccountReq);
      case 'FindUserAccount':
        return findUserAccount(ctx, request as $3.FindUserAccountReq);
      case 'FindAccountUser':
        return findAccountUser(ctx, request as $3.FindAccountUserReq);
      case 'OpenIMCallback':
        return openIMCallback(ctx, request as $3.OpenIMCallbackReq);
      case 'UserLoginCount':
        return userLoginCount(ctx, request as $3.UserLoginCountReq);
      case 'SearchUserInfo':
        return searchUserInfo(ctx, request as $3.SearchUserInfoReq);
      case 'GetTokenForVideoMeeting':
        return getTokenForVideoMeeting(
            ctx, request as $3.GetTokenForVideoMeetingReq);
      case 'GetRTCToken':
        return getRTCToken(ctx, request as $3.GetRTCTokenReq);
      case 'SetAllowRegister':
        return setAllowRegister(ctx, request as $3.SetAllowRegisterReq);
      case 'GetAllowRegister':
        return getAllowRegister(ctx, request as $3.GetAllowRegisterReq);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => chatServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => chatServiceBase$messageJson;
}
