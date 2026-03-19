import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';
import '../controllers/settings_controller.dart';
import '../routes/app_routes.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: Obx(() {
        final user = controller.userInfo.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            const SizedBox(height: 16),
            // 个人资料卡片
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: user.faceURL != null && user.faceURL!.isNotEmpty
                            ? NetworkImage(user.faceURL!)
                            : null,
                        child: user.faceURL == null || user.faceURL!.isEmpty
                            ? Text(
                                (user.nickname ?? user.userID)[0].toUpperCase(),
                                style: const TextStyle(fontSize: 32),
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => controller.isEditing.value
                            ? Column(
                                children: [
                                  TextField(
                                    controller: controller.nicknameCtrl,
                                    decoration: const InputDecoration(labelText: '昵称'),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: controller.faceURLCtrl,
                                    decoration: const InputDecoration(labelText: '头像URL'),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () => controller.isEditing.value = false,
                                        child: const Text('取消'),
                                      ),
                                      const SizedBox(width: 12),
                                      FilledButton(
                                        onPressed: controller.updateProfile,
                                        child: const Text('保存'),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    user.nickname ?? '未设置昵称',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'ID: ${user.userID}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          controller.nicknameCtrl.text = user.nickname ?? '';
                                          controller.faceURLCtrl.text = user.faceURL ?? '';
                                          controller.isEditing.value = true;
                                        },
                                        icon: const Icon(Icons.edit, size: 16),
                                        label: const Text('编辑资料'),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton.icon(
                                        onPressed: controller.getSelfUserInfo,
                                        icon: const Icon(Icons.refresh, size: 16),
                                        label: const Text('同步服务器'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // SDK 信息
            _sectionTitle('SDK 信息'),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('SDK 版本'),
              trailing: Obx(
                () => Text(controller.sdkVersion.value, style: TextStyle(color: Colors.grey[600])),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings_suggest),
              title: const Text('客户端配置'),
              trailing: const Icon(Icons.chevron_right),
              onTap: controller.loadClientConfig,
            ),
            Obx(() {
              final config = controller.clientConfig.value;
              if (config == null || config.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: Colors.grey[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: config.entries
                          .map(
                            (e) =>
                                Text('${e.key}: ${e.value}', style: const TextStyle(fontSize: 12)),
                          )
                          .toList(),
                    ),
                  ),
                ),
              );
            }),

            const Divider(height: 32),

            // 应用控制
            _sectionTitle('应用控制'),
            Obx(
              () => SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('后台模式'),
                subtitle: const Text('通知服务端当前为后台状态'),
                value: controller.isBackground.value,
                onChanged: (v) => controller.setBackgroundStatus(v),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text('网络重连'),
              subtitle: const Text('通知SDK网络已恢复，触发重连'),
              onTap: controller.notifyNetworkChanged,
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('设置角标'),
              subtitle: const Text('设置应用图标未读数角标'),
              onTap: () => _showBadgeDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload),
              title: const Text('更新 FCM Token'),
              onTap: () => _showFcmDialog(context),
            ),

            const Divider(height: 32),

            // 用户状态
            _sectionTitle('用户状态'),
            ListTile(
              leading: const Icon(Icons.person_search),
              title: const Text('订阅用户状态'),
              onTap: () => _showUserIDDialog(context, '订阅用户状态', controller.subscribeUserStatus),
            ),
            ListTile(
              leading: const Icon(Icons.person_off),
              title: const Text('取消订阅'),
              onTap: () => _showUserIDDialog(context, '取消订阅', controller.unsubscribeUserStatus),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('查看已订阅状态'),
              onTap: controller.getSubscribedStatuses,
            ),
            ListTile(
              leading: const Icon(Icons.online_prediction),
              title: const Text('查询用户在线状态'),
              onTap: () => _showUserIDDialog(context, '查询状态', controller.getUserStatus),
            ),

            const Divider(height: 32),

            // 快捷操作
            _sectionTitle('快捷操作'),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('好友申请'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(AppRoutes.friendRequests),
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('黑名单管理'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(AppRoutes.contacts),
            ),

            const Divider(height: 32),

            // 退出
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () async {
                  try {
                    await OpenIM.iMManager.logout();
                  } catch (_) {}
                  Get.offAllNamed(AppRoutes.login);
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('退出登录', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        );
      }),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  void _showUserIDDialog(BuildContext context, String title, Future<void> Function(String) action) {
    final ctrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'User ID'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              Get.back();
              action(ctrl.text.trim());
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  void _showBadgeDialog(BuildContext context) {
    final ctrl = TextEditingController(text: '0');
    Get.dialog(
      AlertDialog(
        title: const Text('设置角标'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: '未读数'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.setAppBadge(int.tryParse(ctrl.text) ?? 0);
            },
            child: const Text('设置'),
          ),
        ],
      ),
    );
  }

  void _showFcmDialog(BuildContext context) {
    final ctrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('更新 FCM Token'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'FCM Token'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.updateFcmToken(ctrl.text.trim());
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );
  }
}
