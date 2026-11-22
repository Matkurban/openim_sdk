import 'package:material_ui/material_ui.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_animated_svg/xue_hua_animated_svg.dart';

import '../../app/router/app_routes.dart';
import 'splash_controller.dart';

/// 启动页：冷启动入口，完成全局插件初始化与登录态分流。
///
/// Splash page: cold-start bootstrap and auth routing entry.
class SplashPage extends StatefulWidget {
  /// 创建启动页。
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with WireStateMixin<SplashPage, SplashController> {
  @override
  SplashController? wire() => SplashController();

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final bool loggedIn = await controller.runBootstrap();
    if (!mounted) {
      return;
    }
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    if (loggedIn) {
      await router.pushNamedAndRemoveUntil(
        AppRoutes.conversations,
        (AdaptiveRouteMatch _) => false,
      );
    } else {
      await router.pushNamedAndRemoveUntil(
        AppRoutes.onboarding,
        (AdaptiveRouteMatch _) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 108,
              height: 108,
              child: AnimatedSvgPicture.asset('assets/svg/brand_logo.svg'),
            ),
            const SizedBox(height: 20),
            Text(
              'OpenIM 聊天',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            SignalBuilder(
              builder: (BuildContext _) {
                return Text(
                  controller.statusText.value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
