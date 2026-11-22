import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/auth_session_service.dart';

/// 账号与安全页（修改密码、支付密码、黑名单、账号申诉、注销账号）。
///
/// Account security page (change password, payment password, blacklist, appeal, delete account).
class AccountSecurityPage extends StatelessWidget {
  /// 创建账号与安全页。
  const AccountSecurityPage({super.key});

  Future<void> _changePassword(BuildContext context) async {
    final TextEditingController oldCtrl = TextEditingController();
    final TextEditingController newCtrl = TextEditingController();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('修改登录密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: oldCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: '当前密码'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: '新密码'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => AdaptiveRouter.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => AdaptiveRouter.of(ctx).pop(true),
            child: const Text('确认修改'),
          ),
        ],
      ),
    );
    final String oldPwd = oldCtrl.text;
    final String newPwd = newCtrl.text;
    oldCtrl.dispose();
    newCtrl.dispose();
    if (confirmed != true || oldPwd.isEmpty || newPwd.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.userManager.changePassword(
        currentPassword: oldPwd,
        newPassword: newPwd,
      );
      await FlutterToastPro.success('密码修改成功');
    } on Object catch (error) {
      await FlutterToastPro.error('修改失败：$error');
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final TextEditingController pwdCtrl = TextEditingController();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('注销账号'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('注销后所有资料与消息将不可恢复，请输入当前密码确认：'),
            const SizedBox(height: 10),
            TextField(
              controller: pwdCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: '当前密码'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => AdaptiveRouter.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => AdaptiveRouter.of(ctx).pop(true),
            child: const Text('确认注销'),
          ),
        ],
      ),
    );
    final String pwd = pwdCtrl.text;
    pwdCtrl.dispose();
    if (confirmed != true || pwd.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.userManager.deleteAccount(currentPassword: pwd);
      await Wire.find<AuthSessionService>().logout();
      if (context.mounted) {
        await AdaptiveRouter.of(context).pushNamedAndRemoveUntil(
          AppRoutes.onboarding,
          (AdaptiveRouteMatch _) => false,
        );
      }
    } on Object catch (error) {
      await FlutterToastPro.error('注销失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('账号与安全')),
      body: ListView(
        children: <Widget>[
          ListTile(
            tileColor: theme.colorScheme.surface,
            title: const Text('修改登录密码'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _changePassword(context),
          ),
          const Divider(height: 1),
          ListTile(
            tileColor: theme.colorScheme.surface,
            title: const Text('支付密码管理'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => router.pushNamedAndRemoveUntil(
              AppRoutes.paymentPassword,
              (AdaptiveRouteMatch m) =>
                  m.matchedLocation == AppRoutes.accountSecurity,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            tileColor: theme.colorScheme.surface,
            title: const Text('通讯录黑名单'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => router.pushNamedAndRemoveUntil(
              AppRoutes.blacklist,
              (AdaptiveRouteMatch m) =>
                  m.matchedLocation == AppRoutes.accountSecurity,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            tileColor: theme.colorScheme.surface,
            title: const Text('账号申诉'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => router.pushNamed(AppRoutes.appeal),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
              ),
              onPressed: () => _deleteAccount(context),
              child: const Text('注销账号'),
            ),
          ),
        ],
      ),
    );
  }
}
