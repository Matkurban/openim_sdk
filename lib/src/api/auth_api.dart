import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';
import '../utils/open_im_utils.dart';
import '../utils/platform_utils.dart';

/// 鉴权与账号注册/密码相关 API 客户端。
final class AuthApi extends BaseApiClient {
  /// 创建 `AuthApi` 实例。
  ///
  /// Creates a `AuthApi` instance.
  ///
  /// - [httpClient] HTTP客户端 / HTTP client.
  AuthApi({required super.httpClient}) : super(name: 'AuthApi');

  /// 解析令牌。
  ///
  /// Parse token.
  ///
  /// - [token] 令牌 / Token.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> parseToken({required String token}) {
    return postIm(ImApiUrl.parseToken, data: <String, dynamic>{'token': token});
  }

  /// 获取用户令牌。
  ///
  /// Get user token.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [platformID] 平台ID / Platform ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getUserToken({required String userID, int? platformID}) {
    return postIm(
      ImApiUrl.getUserToken,
      data: <String, dynamic>{
        'userID': userID,
        'platformID': platformID ?? PlatformUtils.platformID,
      },
    );
  }

  /// chat登录。
  ///
  /// Chat login.
  ///
  /// - [body] body / Body.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> chatLogin({required Map<String, dynamic> body}) {
    return postChat(ChatApiUrl.login, data: body);
  }

  /// 注册。
  ///
  /// Register.
  ///
  /// - [nickname] 昵称 / Nickname.
  /// - [password] 密码 / Password.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [areaCode] 区号代码 / Area code.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [email] 邮箱 / Email.
  /// - [account] 账号 / Account.
  /// - [birth] 生日 / Birth date.
  /// - [gender] 性别 / Gender.
  /// - [verificationCode] 验证代码 / Verification code.
  /// - [invitationCode] invitation代码 / Invitation code.
  /// - [autoLogin] auto登录 / Auto login.
  /// - [deviceID] deviceID / Device ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 发送验证代码。
  ///
  /// Send verification code.
  ///
  /// - [areaCode] 区号代码 / Area code.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [email] 邮箱 / Email.
  /// - [usedFor] usedFor / Used for.
  /// - [invitationCode] invitation代码 / Invitation code.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 变更密码。
  ///
  /// Change password.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [currentPassword] current密码 / Current password.
  /// - [newPassword] new密码 / New password.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 重置密码。
  ///
  /// Reset password.
  ///
  /// - [areaCode] 区号代码 / Area code.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [email] 邮箱 / Email.
  /// - [verifyCode] 校验代码 / Verify code.
  /// - [newPassword] new密码 / New password.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 删除账号。
  ///
  /// Delete account.
  ///
  /// - [currentPassword] current密码 / Current password.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> deleteAccount({required String currentPassword}) {
    return postChat(
      ChatApiUrl.deleteAccount,
      data: <String, dynamic>{'currentPassword': OpenImUtils.generateMD5(currentPassword)},
    );
  }

  /// 设置支付密码。
  ///
  /// Set payment password.
  ///
  /// - [paymentPassword] 支付密码 / Payment password.
  /// - [loginPassword] 登录密码 / Login password.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 变更支付密码。
  ///
  /// Change payment password.
  ///
  /// - [currentPaymentPassword] current支付密码 / Current payment password.
  /// - [newPaymentPassword] new支付密码 / New payment password.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 校验支付密码。
  ///
  /// Verify payment password.
  ///
  /// - [paymentPassword] 支付密码 / Payment password.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> verifyPaymentPassword({required String paymentPassword}) {
    return postChat(
      ChatApiUrl.verifyPaymentPassword,
      data: <String, dynamic>{'paymentPassword': paymentPassword},
    );
  }

  /// 检查支付密码设置。
  ///
  /// Check payment password set.
  ///
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> checkPaymentPasswordSet() {
    return postChat(ChatApiUrl.checkPaymentPasswordSet);
  }

  /// 重置支付密码。
  ///
  /// Reset payment password.
  ///
  /// - [areaCode] 区号代码 / Area code.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [email] 邮箱 / Email.
  /// - [verifyCode] 校验代码 / Verify code.
  /// - [newPaymentPassword] new支付密码 / New payment password.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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
