import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_animated_svg/xue_hua_animated_svg.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/server_config_dialog.dart';

/// 引导页：展示应用简介，底部提供「登录」与「注册」两大入口。
///
/// Onboarding page introducing the app with Sign In and Sign Up entry actions.
class OnboardingPage extends StatelessWidget {
  /// 创建引导页。
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => ServerConfigDialog.show(context),
                      icon: const Icon(Icons.dns_outlined, size: 18),
                      label: const Text('服务器设置'),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: AnimatedSvgPicture.asset(
                      'assets/svg/brand_logo.svg',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'OpenIM 跨平台即时通讯',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '全功能类微信架构示例：单聊/群聊、全类型消息、群管理、朋友圈、收藏、积分红包与跨端桌面增强。',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FilledButton(
                          onPressed: () =>
                              AdaptiveRouter.of(context)
                                  .pushNamed(AppRoutes.login),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('登录'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              AdaptiveRouter.of(context)
                                  .pushNamed(AppRoutes.register),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('注册'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
