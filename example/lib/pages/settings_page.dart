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
            // Profile card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            user.faceURL != null && user.faceURL!.isNotEmpty
                            ? NetworkImage(user.faceURL!)
                            : null,
                        child: user.faceURL == null || user.faceURL!.isEmpty
                            ? Text(
                                (user.nickname ?? user.userID ?? '?')[0]
                                    .toUpperCase(),
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
                                    decoration: const InputDecoration(
                                      labelText: '昵称',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: controller.faceURLCtrl,
                                    decoration: const InputDecoration(
                                      labelText: '头像URL',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () =>
                                            controller.isEditing.value = false,
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
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'ID: ${user.userID}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 8),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      controller.nicknameCtrl.text =
                                          user.nickname ?? '';
                                      controller.faceURLCtrl.text =
                                          user.faceURL ?? '';
                                      controller.isEditing.value = true;
                                    },
                                    icon: const Icon(Icons.edit, size: 16),
                                    label: const Text('编辑资料'),
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

            // Quick actions
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '快捷操作',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_search),
              title: const Text('查询用户状态'),
              onTap: () => _showStatusDialog(context),
            ),
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

            // Logout
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
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        );
      }),
    );
  }

  void _showStatusDialog(BuildContext context) {
    final ctrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('查询用户在线状态'),
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
              controller.subscribeUserStatus(ctrl.text.trim());
            },
            child: const Text('查询'),
          ),
        ],
      ),
    );
  }
}
