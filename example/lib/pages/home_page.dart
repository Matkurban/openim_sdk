import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';
import '../controllers/home_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/conversation_tile.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final unread = controller.totalUnread.value;
          return Text(unread > 0 ? 'OpenIM ($unread)' : 'OpenIM');
        }),
        leading: Obx(
          () => controller.isSyncing.value
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_alt),
            tooltip: '通讯录',
            onPressed: () => Get.toNamed(AppRoutes.contacts),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              switch (v) {
                case 'new_chat':
                  _showNewChatDialog(context);
                case 'create_group':
                  Get.toNamed(AppRoutes.createGroup);
                case 'add_friend':
                  Get.toNamed(AppRoutes.addFriend);
                case 'settings':
                  Get.toNamed(AppRoutes.settings);
                case 'logout':
                  controller.logout();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'new_chat',
                child: ListTile(leading: Icon(Icons.chat), title: Text('发起聊天'), dense: true),
              ),
              PopupMenuItem(
                value: 'create_group',
                child: ListTile(leading: Icon(Icons.group_add), title: Text('创建群组'), dense: true),
              ),
              PopupMenuItem(
                value: 'add_friend',
                child: ListTile(leading: Icon(Icons.person_add), title: Text('添加好友'), dense: true),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 'settings',
                child: ListTile(leading: Icon(Icons.settings), title: Text('设置'), dense: true),
              ),
              PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('退出登录', style: TextStyle(color: Colors.red)),
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.conversations.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('暂无会话', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => controller.refreshConversations(),
                  child: const Text('刷新'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshConversations,
          child: ListView.builder(
            itemCount: controller.conversations.length,
            itemBuilder: (context, index) {
              final conv = controller.conversations[index];
              return ConversationTile(
                conversation: conv,
                onTap: () => controller.openChat(conv),
                onLongPress: () => _showConversationActions(context, conv),
              );
            },
          ),
        );
      }),
    );
  }

  void _showNewChatDialog(BuildContext context) {
    final ctrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('发起聊天'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: '对方 User ID'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              final userID = ctrl.text.trim();
              if (userID.isEmpty) return;
              Get.back();
              try {
                final conv = await OpenIM.iMManager.conversationManager.getOneConversation(
                  sourceID: userID,
                  sessionType: 1,
                );
                Get.toNamed(AppRoutes.chat, arguments: conv);
              } catch (e) {
                Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: const Text('开始'),
          ),
        ],
      ),
    );
  }

  void _showConversationActions(BuildContext context, ConversationInfo conv) {
    Get.bottomSheet(
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon((conv.isPinned ?? false) ? Icons.push_pin_outlined : Icons.push_pin),
              title: Text((conv.isPinned ?? false) ? '取消置顶' : '置顶'),
              onTap: () {
                Get.back();
                controller.pinConversation(conv);
              },
            ),
            ListTile(
              leading: const Icon(Icons.done_all),
              title: const Text('标记已读'),
              onTap: () {
                Get.back();
                controller.markAsRead(conv);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('删除会话', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                Get.dialog(
                  AlertDialog(
                    title: const Text('确认删除'),
                    content: Text('删除与 ${conv.showName ?? "未知"} 的会话？'),
                    actions: [
                      TextButton(onPressed: () => Get.back(), child: const Text('取消')),
                      FilledButton(
                        onPressed: () {
                          Get.back();
                          controller.deleteConversation(conv);
                        },
                        style: FilledButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('删除'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}
