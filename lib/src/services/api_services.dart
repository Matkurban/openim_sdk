import 'package:openim_sdk/src/config/api_url.dart';
import 'package:openim_sdk/src/models/api_response.dart';
import 'package:openim_sdk/src/network/http_client.dart';
import 'package:openim_sdk/src/utils/im_utils.dart';
import 'package:openim_sdk/src/utils/platform_utils.dart';

/// Chat 业务 API（注册/登录/验证码）
class ApiServices {
  /// 登录接口，支持邮箱或手机号登录
  Future<ApiResponse> login({
    String? email,
    String? phoneNumber,
    String? password,
    String? areaCode,
  }) async {
    return await HttpClient().post(
      ChatApiUrl.login,
      data: {
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'areaCode': areaCode,
        'platform': PlatformUtils.platformID,
      },
    );
  }

  /// 注册接口，支持邮箱或手机号注册
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
  }) async {
    return await HttpClient().post(
      ChatApiUrl.register,
      data: {
        "deviceID": deviceID,
        "verifyCode": verificationCode,
        "platform": PlatformUtils.platformID,
        "invitationCode": invitationCode,
        "autoLogin": autoLogin,
        "user": {
          "nickname": nickname,
          "faceURL": faceURL,
          "birth": birth,
          "gender": gender,
          "email": email,
          "areaCode": areaCode,
          "phoneNumber": phoneNumber,
          "account": account,
          "password": ImUtils.generateMD5(password),
        },
      },
    );
  }
}
