import 'package:logging/logging.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../core/services/app_bootstrap_service.dart';

/// 启动页控制器：执行全局初始化与自动登录态检测。
///
/// Splash page controller executing cold-start bootstrap and session restoration.
class SplashController extends WireController {
  static final Logger _logger = Logger('SplashController');

  /// 当前初始化状态文案信号。
  late final Signal<String> statusText = createSignal<String>(
    '正在初始化插件与 IM 引擎...',
  );

  /// 启动完成回调，传入是否已登录。
  Future<bool> runBootstrap() async {
    try {
      final AppBootstrapService bootstrap = Wire.find<AppBootstrapService>();
      statusText.value = '正在检测本地登录状态...';
      return await bootstrap.bootstrap();
    } on Object catch (error, stackTrace) {
      _logger.severe('Bootstrap error', error, stackTrace);
      statusText.value = '初始化异常，即将进入引导页';
      return false;
    }
  }
}
