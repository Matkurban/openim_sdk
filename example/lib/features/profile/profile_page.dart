import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/auth_session_service.dart';
import '../../shared/widgets/cached_avatar.dart';

/// Tab 4：我的（个人信息卡片、二维码入口、我的相册、我的收藏、积分中心、通用与安全设置、退出登录）。
///
/// Tab 4: Profile page with QR card, favorites, points center, settings, and sign-out.
class ProfilePage extends StatelessWidget {
  /// 创建我的页面。
  const ProfilePage({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出当前账号并断开 IM 连接吗？'),
        actions: <Widget>[
          TextButton(
            onPressed: () => AdaptiveRouter.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => AdaptiveRouter.of(ctx).pop(true),
            child: const Text('退出登录'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await Wire.find<AuthSessionService>().logout();
    if (context.mounted) {
      await AdaptiveRouter.of(context).pushNamedAndRemoveUntil(
        AppRoutes.onboarding,
        (AdaptiveRouteMatch _) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final AuthSessionService auth = Wire.find<AuthSessionService>();
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('我')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final UserInfo? self = auth.currentUser.value;
          final String uid = self?.userID ?? OpenIM.iMManager.userID;
          final String nickname = self?.nickname ?? uid;

          return ListView(
            children: <Widget>[
              Material(
                color: theme.colorScheme.surface,
                child: InkWell(
                  onTap: () => router.pushNamedAndRemoveUntil(
                    AppRoutes.editProfile,
                    (AdaptiveRouteMatch m) =>
                        m.matchedLocation == AppRoutes.profile,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: <Widget>[
                        CachedAvatar(
                          imageUrl: self?.faceURL,
                          fallbackName: nickname,
                          size: 64,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                nickname,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '账号 ID：$uid',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: '我的二维码',
                          icon: const Icon(Icons.qr_code_2, size: 26),
                          onPressed: () => router.pushNamedAndRemoveUntil(
                            AppRoutes.myQr,
                            (AdaptiveRouteMatch m) =>
                                m.matchedLocation == AppRoutes.profile,
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.photo_album_outlined),
                title: const Text('我的朋友圈相册'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.userMoments(uid),
                  (AdaptiveRouteMatch m) =>
                      m.matchedLocation == AppRoutes.profile,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.star_outline),
                title: const Text('我的收藏'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.favorites,
                  (AdaptiveRouteMatch m) =>
                      m.matchedLocation == AppRoutes.profile,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: const Text('积分中心'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.points,
                  (AdaptiveRouteMatch m) =>
                      m.matchedLocation == AppRoutes.profile,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: theme.colorScheme.surface,
                leading: const Icon(Icons.settings_outlined),
                title: const Text('通用与安全设置'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.settings,
                  (AdaptiveRouteMatch m) =>
                      m.matchedLocation == AppRoutes.profile,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _confirmLogout(context),
                  child: const Text('退出登录'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
