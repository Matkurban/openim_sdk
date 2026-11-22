import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';
import '../utils/open_im_utils.dart';
import '../utils/platform_utils.dart';

/// 鉴权与账号注册/密码相关 API 客户端。
final class AuthApi extends BaseApiClient {
  AuthApi({required super.httpClient}) : super(name: 'AuthApi');

  Future<ApiResponse> parseToken({required String token}) {
    return postIm(ImApiUrl.parseToken, data: <String, dynamic>{'token': token});
  }

  Future<ApiResponse> getUserToken({required String userID, int? platformID}) {
    return postIm(
      ImApiUrl.getUserToken,
      data: <String, dynamic>{
        'userID': userID,
        'platformID': platformID ?? PlatformUtils.platformID,
      },
    );
  }

  Future<ApiResponse> chatLogin({required Map<String, dynamic> body}) {
    return postChat(ChatApiUrl.login, data: body);
  }

  Future<ApiResponse> register({
    required String nickname,
    required String password,
    String? faceURL,
    String? areaCode,
    String? phoneNumber,
    String? email,
    String? account,
    int birth = 0,
    int gender = 1,
    required String verificationCode,
    String? invitationCode,
    bool autoLogin = true,
    required String deviceID,
  }) {
    return postChat(
      ChatApiUrl.register,
      data: <String, dynamic>{
        'deviceID': deviceID,
        'verifyCode': verificationCode,
        'platform': PlatformUtils.platformID,
        'invitationCode': invitationCode,
        'autoLogin': autoLogin,
        'user': <String, dynamic>{
          'nickname': nickname,
          'faceURL': faceURL,
          'birth': birth,
          'gender': gender,
          'email': email,
          'areaCode': areaCode,
          'phoneNumber': phoneNumber,
          'account': account,
          'password': OpenImUtils.generateMD5(password),
        },
      },
    );
  }

  Future<ApiResponse> sendVerificationCode({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required int usedFor,
    String? invitationCode,
  }) {
    return postChat(
      ChatApiUrl.captcha,
      data: <String, dynamic>{
        'areaCode': ?areaCode,
        'phoneNumber': ?phoneNumber,
        'email': ?email,
        'usedFor': usedFor,
        'invitationCode': ?invitationCode,
      },
    );
  }

  Future<ApiResponse> changePassword({
    required String userID,
    required String currentPassword,
    required String newPassword,
  }) {
    return postChat(
      ChatApiUrl.changePassword,
      data: <String, dynamic>{
        'userID': userID,
        'currentPassword': OpenImUtils.generateMD5(currentPassword),
        'newPassword': OpenImUtils.generateMD5(newPassword),
      },
    );
  }

  Future<ApiResponse> resetPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verifyCode,
    required String newPassword,
  }) {
    return postChat(
      ChatApiUrl.resetPassword,
      data: <String, dynamic>{
        'areaCode': areaCode,
        'phoneNumber': phoneNumber,
        'email': email,
        'verifyCode': verifyCode,
        'password': OpenImUtils.generateMD5(newPassword),
      },
    );
  }

  Future<ApiResponse> deleteAccount({required String currentPassword}) {
    return postChat(
      ChatApiUrl.deleteAccount,
      data: <String, dynamic>{'currentPassword': OpenImUtils.generateMD5(currentPassword)},
    );
  }

  Future<ApiResponse> setPaymentPassword({
    required String paymentPassword,
    required String loginPassword,
  }) {
    return postChat(
      ChatApiUrl.setPaymentPassword,
      data: <String, dynamic>{
        'paymentPassword': paymentPassword,
        'loginPassword': OpenImUtils.generateMD5(loginPassword),
      },
    );
  }

  Future<ApiResponse> changePaymentPassword({
    required String currentPaymentPassword,
    required String newPaymentPassword,
  }) {
    return postChat(
      ChatApiUrl.changePaymentPassword,
      data: <String, dynamic>{
        'currentPaymentPassword': currentPaymentPassword,
        'newPaymentPassword': newPaymentPassword,
      },
    );
  }

  Future<ApiResponse> verifyPaymentPassword({required String paymentPassword}) {
    return postChat(
      ChatApiUrl.verifyPaymentPassword,
      data: <String, dynamic>{'paymentPassword': paymentPassword},
    );
  }

  Future<ApiResponse> checkPaymentPasswordSet() {
    return postChat(ChatApiUrl.checkPaymentPasswordSet);
  }

  Future<ApiResponse> resetPaymentPassword({
    String? areaCode,
    String? phoneNumber,
    String? email,
    required String verifyCode,
    required String newPaymentPassword,
  }) {
    return postChat(
      ChatApiUrl.resetPaymentPassword,
      data: <String, dynamic>{
        'areaCode': ?areaCode,
        'phoneNumber': ?phoneNumber,
        'email': ?email,
        'verifyCode': verifyCode,
        'newPaymentPassword': newPaymentPassword,
      },
    );
  }
}
