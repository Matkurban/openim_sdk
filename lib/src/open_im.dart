import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/network/http_client.dart';
import 'package:openim_sdk/src/services/api_services.dart';
import 'package:openim_sdk/src/services/connect_services.dart';
import 'package:openim_sdk/src/services/data_base_services.dart';

class OpenIm {
  OpenIm._();

  static final Logger log = Logger('OpenIm');

  ///初始化设置默认配置
  Future<bool> initSdk({required InitConfig config}) async {
    try {
      Logger.root.level = config.logLevel;
      GetIt getIt = GetIt.instance;
      getIt.registerSingleton<InitConfig>(config);
      _injectService(config: config);
      log.info('OpenIM SDK initialized successfully with config: ${config.toJson()}');
      return true;
    } catch (e, s) {
      log.severe(e.toString(), e, s);
      return false;
    }
  }

  ///注入初始服务
  Future<void> _injectService({required InitConfig config}) async {
    GetIt getIt = GetIt.instance;
    HttpClient().init(baseUrl: config.apiAddr);
    getIt.registerLazySingleton<ApiServices>(() => ApiServices());
    getIt.registerSingleton<ConnectServices>(ConnectServices(wsUrl: config.wsAddr));
    getIt.registerSingleton<DataBaseServices>(DataBaseServices(dataDir: config.dataDir));
  }
}
