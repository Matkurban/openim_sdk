import 'package:openim_sdk/openim_sdk.dart';

///全局配置类
class GlobalConfig {
  InitConfig? initConfig;

  void setConfig(InitConfig config) {
    initConfig = config;
  }

  bool get hasInit => initConfig != null;
}
