sealed class CacheKey {
  static const String _baseName = 'kurban_openim_sdk_';

  ///登录的用户 ID和 Token
  static const String loginAuthData = '${_baseName}login_auth_data';

  ///登录的用户信息
  static const String loginUserInfo = '${_baseName}login_user_info';
}
