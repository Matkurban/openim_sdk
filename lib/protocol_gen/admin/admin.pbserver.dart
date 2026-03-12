// This is a generated file - do not edit.
//
// Generated from admin/admin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'admin.pb.dart' as $3;
import 'admin.pbjson.dart';

export 'admin.pb.dart';

abstract class adminServiceBase extends $pb.GeneratedService {
  $async.Future<$3.LoginResp> login($pb.ServerContext ctx, $3.LoginReq request);
  $async.Future<$3.ChangePasswordResp> changePassword(
      $pb.ServerContext ctx, $3.ChangePasswordReq request);
  $async.Future<$3.AdminUpdateInfoResp> adminUpdateInfo(
      $pb.ServerContext ctx, $3.AdminUpdateInfoReq request);
  $async.Future<$3.GetAdminInfoResp> getAdminInfo(
      $pb.ServerContext ctx, $3.GetAdminInfoReq request);
  $async.Future<$3.AddAdminAccountResp> addAdminAccount(
      $pb.ServerContext ctx, $3.AddAdminAccountReq request);
  $async.Future<$3.ChangeAdminPasswordResp> changeAdminPassword(
      $pb.ServerContext ctx, $3.ChangeAdminPasswordReq request);
  $async.Future<$3.DelAdminAccountResp> delAdminAccount(
      $pb.ServerContext ctx, $3.DelAdminAccountReq request);
  $async.Future<$3.SearchAdminAccountResp> searchAdminAccount(
      $pb.ServerContext ctx, $3.SearchAdminAccountReq request);
  $async.Future<$3.AddDefaultFriendResp> addDefaultFriend(
      $pb.ServerContext ctx, $3.AddDefaultFriendReq request);
  $async.Future<$3.DelDefaultFriendResp> delDefaultFriend(
      $pb.ServerContext ctx, $3.DelDefaultFriendReq request);
  $async.Future<$3.FindDefaultFriendResp> findDefaultFriend(
      $pb.ServerContext ctx, $3.FindDefaultFriendReq request);
  $async.Future<$3.SearchDefaultFriendResp> searchDefaultFriend(
      $pb.ServerContext ctx, $3.SearchDefaultFriendReq request);
  $async.Future<$3.AddDefaultGroupResp> addDefaultGroup(
      $pb.ServerContext ctx, $3.AddDefaultGroupReq request);
  $async.Future<$3.DelDefaultGroupResp> delDefaultGroup(
      $pb.ServerContext ctx, $3.DelDefaultGroupReq request);
  $async.Future<$3.FindDefaultGroupResp> findDefaultGroup(
      $pb.ServerContext ctx, $3.FindDefaultGroupReq request);
  $async.Future<$3.SearchDefaultGroupResp> searchDefaultGroup(
      $pb.ServerContext ctx, $3.SearchDefaultGroupReq request);
  $async.Future<$3.AddInvitationCodeResp> addInvitationCode(
      $pb.ServerContext ctx, $3.AddInvitationCodeReq request);
  $async.Future<$3.GenInvitationCodeResp> genInvitationCode(
      $pb.ServerContext ctx, $3.GenInvitationCodeReq request);
  $async.Future<$3.FindInvitationCodeResp> findInvitationCode(
      $pb.ServerContext ctx, $3.FindInvitationCodeReq request);
  $async.Future<$3.UseInvitationCodeResp> useInvitationCode(
      $pb.ServerContext ctx, $3.UseInvitationCodeReq request);
  $async.Future<$3.DelInvitationCodeResp> delInvitationCode(
      $pb.ServerContext ctx, $3.DelInvitationCodeReq request);
  $async.Future<$3.SearchInvitationCodeResp> searchInvitationCode(
      $pb.ServerContext ctx, $3.SearchInvitationCodeReq request);
  $async.Future<$3.SearchUserIPLimitLoginResp> searchUserIPLimitLogin(
      $pb.ServerContext ctx, $3.SearchUserIPLimitLoginReq request);
  $async.Future<$3.AddUserIPLimitLoginResp> addUserIPLimitLogin(
      $pb.ServerContext ctx, $3.AddUserIPLimitLoginReq request);
  $async.Future<$3.DelUserIPLimitLoginResp> delUserIPLimitLogin(
      $pb.ServerContext ctx, $3.DelUserIPLimitLoginReq request);
  $async.Future<$3.SearchIPForbiddenResp> searchIPForbidden(
      $pb.ServerContext ctx, $3.SearchIPForbiddenReq request);
  $async.Future<$3.AddIPForbiddenResp> addIPForbidden(
      $pb.ServerContext ctx, $3.AddIPForbiddenReq request);
  $async.Future<$3.DelIPForbiddenResp> delIPForbidden(
      $pb.ServerContext ctx, $3.DelIPForbiddenReq request);
  $async.Future<$3.CancellationUserResp> cancellationUser(
      $pb.ServerContext ctx, $3.CancellationUserReq request);
  $async.Future<$3.BlockUserResp> blockUser(
      $pb.ServerContext ctx, $3.BlockUserReq request);
  $async.Future<$3.UnblockUserResp> unblockUser(
      $pb.ServerContext ctx, $3.UnblockUserReq request);
  $async.Future<$3.SearchBlockUserResp> searchBlockUser(
      $pb.ServerContext ctx, $3.SearchBlockUserReq request);
  $async.Future<$3.FindUserBlockInfoResp> findUserBlockInfo(
      $pb.ServerContext ctx, $3.FindUserBlockInfoReq request);
  $async.Future<$3.CheckRegisterForbiddenResp> checkRegisterForbidden(
      $pb.ServerContext ctx, $3.CheckRegisterForbiddenReq request);
  $async.Future<$3.CheckLoginForbiddenResp> checkLoginForbidden(
      $pb.ServerContext ctx, $3.CheckLoginForbiddenReq request);
  $async.Future<$3.CreateTokenResp> createToken(
      $pb.ServerContext ctx, $3.CreateTokenReq request);
  $async.Future<$3.ParseTokenResp> parseToken(
      $pb.ServerContext ctx, $3.ParseTokenReq request);
  $async.Future<$3.AddAppletResp> addApplet(
      $pb.ServerContext ctx, $3.AddAppletReq request);
  $async.Future<$3.DelAppletResp> delApplet(
      $pb.ServerContext ctx, $3.DelAppletReq request);
  $async.Future<$3.UpdateAppletResp> updateApplet(
      $pb.ServerContext ctx, $3.UpdateAppletReq request);
  $async.Future<$3.FindAppletResp> findApplet(
      $pb.ServerContext ctx, $3.FindAppletReq request);
  $async.Future<$3.SearchAppletResp> searchApplet(
      $pb.ServerContext ctx, $3.SearchAppletReq request);
  $async.Future<$3.GetClientConfigResp> getClientConfig(
      $pb.ServerContext ctx, $3.GetClientConfigReq request);
  $async.Future<$3.SetClientConfigResp> setClientConfig(
      $pb.ServerContext ctx, $3.SetClientConfigReq request);
  $async.Future<$3.DelClientConfigResp> delClientConfig(
      $pb.ServerContext ctx, $3.DelClientConfigReq request);
  $async.Future<$3.GetUserTokenResp> getUserToken(
      $pb.ServerContext ctx, $3.GetUserTokenReq request);
  $async.Future<$3.InvalidateTokenResp> invalidateToken(
      $pb.ServerContext ctx, $3.InvalidateTokenReq request);
  $async.Future<$3.LatestApplicationVersionResp> latestApplicationVersion(
      $pb.ServerContext ctx, $3.LatestApplicationVersionReq request);
  $async.Future<$3.AddApplicationVersionResp> addApplicationVersion(
      $pb.ServerContext ctx, $3.AddApplicationVersionReq request);
  $async.Future<$3.UpdateApplicationVersionResp> updateApplicationVersion(
      $pb.ServerContext ctx, $3.UpdateApplicationVersionReq request);
  $async.Future<$3.DeleteApplicationVersionResp> deleteApplicationVersion(
      $pb.ServerContext ctx, $3.DeleteApplicationVersionReq request);
  $async.Future<$3.PageApplicationVersionResp> pageApplicationVersion(
      $pb.ServerContext ctx, $3.PageApplicationVersionReq request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Login':
        return $3.LoginReq();
      case 'ChangePassword':
        return $3.ChangePasswordReq();
      case 'AdminUpdateInfo':
        return $3.AdminUpdateInfoReq();
      case 'GetAdminInfo':
        return $3.GetAdminInfoReq();
      case 'AddAdminAccount':
        return $3.AddAdminAccountReq();
      case 'ChangeAdminPassword':
        return $3.ChangeAdminPasswordReq();
      case 'DelAdminAccount':
        return $3.DelAdminAccountReq();
      case 'SearchAdminAccount':
        return $3.SearchAdminAccountReq();
      case 'AddDefaultFriend':
        return $3.AddDefaultFriendReq();
      case 'DelDefaultFriend':
        return $3.DelDefaultFriendReq();
      case 'FindDefaultFriend':
        return $3.FindDefaultFriendReq();
      case 'SearchDefaultFriend':
        return $3.SearchDefaultFriendReq();
      case 'AddDefaultGroup':
        return $3.AddDefaultGroupReq();
      case 'DelDefaultGroup':
        return $3.DelDefaultGroupReq();
      case 'FindDefaultGroup':
        return $3.FindDefaultGroupReq();
      case 'SearchDefaultGroup':
        return $3.SearchDefaultGroupReq();
      case 'AddInvitationCode':
        return $3.AddInvitationCodeReq();
      case 'GenInvitationCode':
        return $3.GenInvitationCodeReq();
      case 'FindInvitationCode':
        return $3.FindInvitationCodeReq();
      case 'UseInvitationCode':
        return $3.UseInvitationCodeReq();
      case 'DelInvitationCode':
        return $3.DelInvitationCodeReq();
      case 'SearchInvitationCode':
        return $3.SearchInvitationCodeReq();
      case 'SearchUserIPLimitLogin':
        return $3.SearchUserIPLimitLoginReq();
      case 'AddUserIPLimitLogin':
        return $3.AddUserIPLimitLoginReq();
      case 'DelUserIPLimitLogin':
        return $3.DelUserIPLimitLoginReq();
      case 'SearchIPForbidden':
        return $3.SearchIPForbiddenReq();
      case 'AddIPForbidden':
        return $3.AddIPForbiddenReq();
      case 'DelIPForbidden':
        return $3.DelIPForbiddenReq();
      case 'CancellationUser':
        return $3.CancellationUserReq();
      case 'BlockUser':
        return $3.BlockUserReq();
      case 'UnblockUser':
        return $3.UnblockUserReq();
      case 'SearchBlockUser':
        return $3.SearchBlockUserReq();
      case 'FindUserBlockInfo':
        return $3.FindUserBlockInfoReq();
      case 'CheckRegisterForbidden':
        return $3.CheckRegisterForbiddenReq();
      case 'CheckLoginForbidden':
        return $3.CheckLoginForbiddenReq();
      case 'CreateToken':
        return $3.CreateTokenReq();
      case 'ParseToken':
        return $3.ParseTokenReq();
      case 'AddApplet':
        return $3.AddAppletReq();
      case 'DelApplet':
        return $3.DelAppletReq();
      case 'UpdateApplet':
        return $3.UpdateAppletReq();
      case 'FindApplet':
        return $3.FindAppletReq();
      case 'SearchApplet':
        return $3.SearchAppletReq();
      case 'GetClientConfig':
        return $3.GetClientConfigReq();
      case 'SetClientConfig':
        return $3.SetClientConfigReq();
      case 'DelClientConfig':
        return $3.DelClientConfigReq();
      case 'GetUserToken':
        return $3.GetUserTokenReq();
      case 'InvalidateToken':
        return $3.InvalidateTokenReq();
      case 'LatestApplicationVersion':
        return $3.LatestApplicationVersionReq();
      case 'AddApplicationVersion':
        return $3.AddApplicationVersionReq();
      case 'UpdateApplicationVersion':
        return $3.UpdateApplicationVersionReq();
      case 'DeleteApplicationVersion':
        return $3.DeleteApplicationVersionReq();
      case 'PageApplicationVersion':
        return $3.PageApplicationVersionReq();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Login':
        return login(ctx, request as $3.LoginReq);
      case 'ChangePassword':
        return changePassword(ctx, request as $3.ChangePasswordReq);
      case 'AdminUpdateInfo':
        return adminUpdateInfo(ctx, request as $3.AdminUpdateInfoReq);
      case 'GetAdminInfo':
        return getAdminInfo(ctx, request as $3.GetAdminInfoReq);
      case 'AddAdminAccount':
        return addAdminAccount(ctx, request as $3.AddAdminAccountReq);
      case 'ChangeAdminPassword':
        return changeAdminPassword(ctx, request as $3.ChangeAdminPasswordReq);
      case 'DelAdminAccount':
        return delAdminAccount(ctx, request as $3.DelAdminAccountReq);
      case 'SearchAdminAccount':
        return searchAdminAccount(ctx, request as $3.SearchAdminAccountReq);
      case 'AddDefaultFriend':
        return addDefaultFriend(ctx, request as $3.AddDefaultFriendReq);
      case 'DelDefaultFriend':
        return delDefaultFriend(ctx, request as $3.DelDefaultFriendReq);
      case 'FindDefaultFriend':
        return findDefaultFriend(ctx, request as $3.FindDefaultFriendReq);
      case 'SearchDefaultFriend':
        return searchDefaultFriend(ctx, request as $3.SearchDefaultFriendReq);
      case 'AddDefaultGroup':
        return addDefaultGroup(ctx, request as $3.AddDefaultGroupReq);
      case 'DelDefaultGroup':
        return delDefaultGroup(ctx, request as $3.DelDefaultGroupReq);
      case 'FindDefaultGroup':
        return findDefaultGroup(ctx, request as $3.FindDefaultGroupReq);
      case 'SearchDefaultGroup':
        return searchDefaultGroup(ctx, request as $3.SearchDefaultGroupReq);
      case 'AddInvitationCode':
        return addInvitationCode(ctx, request as $3.AddInvitationCodeReq);
      case 'GenInvitationCode':
        return genInvitationCode(ctx, request as $3.GenInvitationCodeReq);
      case 'FindInvitationCode':
        return findInvitationCode(ctx, request as $3.FindInvitationCodeReq);
      case 'UseInvitationCode':
        return useInvitationCode(ctx, request as $3.UseInvitationCodeReq);
      case 'DelInvitationCode':
        return delInvitationCode(ctx, request as $3.DelInvitationCodeReq);
      case 'SearchInvitationCode':
        return searchInvitationCode(ctx, request as $3.SearchInvitationCodeReq);
      case 'SearchUserIPLimitLogin':
        return searchUserIPLimitLogin(
            ctx, request as $3.SearchUserIPLimitLoginReq);
      case 'AddUserIPLimitLogin':
        return addUserIPLimitLogin(ctx, request as $3.AddUserIPLimitLoginReq);
      case 'DelUserIPLimitLogin':
        return delUserIPLimitLogin(ctx, request as $3.DelUserIPLimitLoginReq);
      case 'SearchIPForbidden':
        return searchIPForbidden(ctx, request as $3.SearchIPForbiddenReq);
      case 'AddIPForbidden':
        return addIPForbidden(ctx, request as $3.AddIPForbiddenReq);
      case 'DelIPForbidden':
        return delIPForbidden(ctx, request as $3.DelIPForbiddenReq);
      case 'CancellationUser':
        return cancellationUser(ctx, request as $3.CancellationUserReq);
      case 'BlockUser':
        return blockUser(ctx, request as $3.BlockUserReq);
      case 'UnblockUser':
        return unblockUser(ctx, request as $3.UnblockUserReq);
      case 'SearchBlockUser':
        return searchBlockUser(ctx, request as $3.SearchBlockUserReq);
      case 'FindUserBlockInfo':
        return findUserBlockInfo(ctx, request as $3.FindUserBlockInfoReq);
      case 'CheckRegisterForbidden':
        return checkRegisterForbidden(
            ctx, request as $3.CheckRegisterForbiddenReq);
      case 'CheckLoginForbidden':
        return checkLoginForbidden(ctx, request as $3.CheckLoginForbiddenReq);
      case 'CreateToken':
        return createToken(ctx, request as $3.CreateTokenReq);
      case 'ParseToken':
        return parseToken(ctx, request as $3.ParseTokenReq);
      case 'AddApplet':
        return addApplet(ctx, request as $3.AddAppletReq);
      case 'DelApplet':
        return delApplet(ctx, request as $3.DelAppletReq);
      case 'UpdateApplet':
        return updateApplet(ctx, request as $3.UpdateAppletReq);
      case 'FindApplet':
        return findApplet(ctx, request as $3.FindAppletReq);
      case 'SearchApplet':
        return searchApplet(ctx, request as $3.SearchAppletReq);
      case 'GetClientConfig':
        return getClientConfig(ctx, request as $3.GetClientConfigReq);
      case 'SetClientConfig':
        return setClientConfig(ctx, request as $3.SetClientConfigReq);
      case 'DelClientConfig':
        return delClientConfig(ctx, request as $3.DelClientConfigReq);
      case 'GetUserToken':
        return getUserToken(ctx, request as $3.GetUserTokenReq);
      case 'InvalidateToken':
        return invalidateToken(ctx, request as $3.InvalidateTokenReq);
      case 'LatestApplicationVersion':
        return latestApplicationVersion(
            ctx, request as $3.LatestApplicationVersionReq);
      case 'AddApplicationVersion':
        return addApplicationVersion(
            ctx, request as $3.AddApplicationVersionReq);
      case 'UpdateApplicationVersion':
        return updateApplicationVersion(
            ctx, request as $3.UpdateApplicationVersionReq);
      case 'DeleteApplicationVersion':
        return deleteApplicationVersion(
            ctx, request as $3.DeleteApplicationVersionReq);
      case 'PageApplicationVersion':
        return pageApplicationVersion(
            ctx, request as $3.PageApplicationVersionReq);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => adminServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => adminServiceBase$messageJson;
}
