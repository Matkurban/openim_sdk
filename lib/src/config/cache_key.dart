/// SDK 本地 KV 存储键名常量。
///
/// Local KV storage key constants used by the SDK.
sealed class CacheKey {
  static const String _baseName = 'kurban_openim_sdk_';

  /// 当前登录用户的认证数据键名（包含用户 ID 与 Token）。
  ///
  /// Key for cached login authentication data (user ID and tokens).
  static const String loginAuthData = '${_baseName}login_auth_data';

  /// 当前登录用户的资料缓存键名。
  ///
  /// Key for cached logged-in user profile information.
  static const String loginUserInfo = '${_baseName}login_user_info';
}
