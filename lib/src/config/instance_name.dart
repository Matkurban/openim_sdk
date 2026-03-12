sealed class InstanceName {
  static const String _baseName = 'kurban_openim_sdk_';

  ///配置注入的名称
  static const String initConfig = "${_baseName}init_config";

  ///网络请求服务类
  static const String imApiService = '${_baseName}im_api_service';

  ///数据库服务类
  static const String databaseService = '${_baseName}database_service';

  ///WebSocket 服务类
  static const String webSocketService = '${_baseName}web_socket_service';
}
