import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';
import '../controllers/chat_controller.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              controller.conversation.showName ?? '聊天',
              overflow: TextOverflow.ellipsis,
            ),
            Obx(
              () => controller.isTyping.value
                  ? Text(
                      '对方正在输入...',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        actions: [
          if (controller.conversation.isGroupChat)
            IconButton(
              icon: const Icon(Icons.group),
              tooltip: '群信息',
              onPressed: () => Get.toNamed(
                '/group-info',
                arguments: controller.conversation.groupID,
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (v) => _handleMenuAction(context, v),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'search', child: Text('搜索消息')),
              const PopupMenuItem(value: 'clear', child: Text('清空聊天')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: Obx(() {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.pixels >=
                          notification.metrics.maxScrollExtent - 100) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: controller.scrollCtrl,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final isMe = controller.isMyMessage(msg);

                    // Show time header for messages > 5 min apart
                    Widget? timeHeader;
                    if (index < controller.messages.length - 1) {
                      final next = controller.messages[index + 1];
                      final diff = (msg.sendTime ?? 0) - (next.sendTime ?? 0);
                      if (diff > 300000) {
                        timeHeader = _buildTimeHeader(msg.sendTime ?? 0);
                      }
                    } else {
                      timeHeader = _buildTimeHeader(msg.sendTime ?? 0);
                    }

                    return Column(
                      children: [
                        ?timeHeader,
                        MessageBubble(
                          message: msg,
                          isMe: isMe,
                          content: controller.getMessageContent(msg),
                          onLongPress: () =>
                              _showMessageActions(context, msg, isMe),
                        ),
                      ],
                    );
                  },
                ),
              );
            }),
          ),

          // Input bar
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildTimeHeader(int timestamp) {
    if (timestamp == 0) return const SizedBox.shrink();
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    String text;
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      text =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else {
      text =
          '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        children: [
          // More actions
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showMoreActions(context),
          ),
          // Text field
          Expanded(
            child: TextField(
              controller: controller.inputCtrl,
              decoration: InputDecoration(
                hintText: '输入消息...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                isDense: true,
              ),
              textInputAction: TextInputAction.send,
              onChanged: controller.onInputChanged,
              onSubmitted: (_) => controller.sendTextMessage(),
              maxLines: 4,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          // Send
          Obx(
            () => IconButton.filled(
              icon: controller.isSending.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              onPressed: controller.isSending.value
                  ? null
                  : controller.sendTextMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreActions(BuildContext context) {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(Icons.location_on, '位置', () {
                    Get.back();
                    _sendLocation(context);
                  }),
                  _actionButton(Icons.contact_page, '名片', () {
                    Get.back();
                    _sendCard(context);
                  }),
                  _actionButton(Icons.extension, '自定义', () {
                    Get.back();
                    _sendCustom(context);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: Colors.grey[700]),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _sendLocation(BuildContext context) {
    final latCtrl = TextEditingController(text: '39.9042');
    final lngCtrl = TextEditingController(text: '116.4074');
    final descCtrl = TextEditingController(text: '北京');
    Get.dialog(
      AlertDialog(
        title: const Text('发送位置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: latCtrl,
              decoration: const InputDecoration(labelText: '纬度'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: lngCtrl,
              decoration: const InputDecoration(labelText: '经度'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: '描述'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.sendLocationMessage(
                double.tryParse(latCtrl.text) ?? 0,
                double.tryParse(lngCtrl.text) ?? 0,
                descCtrl.text,
              );
            },
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }

  void _sendCard(BuildContext context) {
    final idCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('发送名片'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: idCtrl,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: '昵称'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.sendCardMessage(idCtrl.text, nameCtrl.text, '');
            },
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }

  void _sendCustom(BuildContext context) {
    final dataCtrl = TextEditingController(text: '{"type":"test"}');
    final descCtrl = TextEditingController(text: '自定义消息');
    Get.dialog(
      AlertDialog(
        title: const Text('发送自定义消息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dataCtrl,
              decoration: const InputDecoration(labelText: 'JSON数据'),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: '描述'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.sendCustomMessage(dataCtrl.text, '', descCtrl.text);
            },
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }

  void _showMessageActions(BuildContext context, Message msg, bool isMe) {
    Get.bottomSheet(
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isMe)
              ListTile(
                leading: const Icon(Icons.undo),
                title: const Text('撤回'),
                onTap: () {
                  Get.back();
                  controller.revokeMessage(msg);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('删除', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                controller.deleteMessage(msg);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('复制'),
              onTap: () {
                Get.back();
                // Copy text content
                final text = controller.getMessageContent(msg);
                if (text.isNotEmpty) {
                  // ignore: unused_import
                  Get.snackbar(
                    '已复制',
                    text,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
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

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'search':
        _showSearchDialog(context);
      case 'clear':
        Get.dialog(
          AlertDialog(
            title: const Text('清空聊天记录'),
            content: const Text('确定要清空所有聊天记录吗？'),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('取消')),
              FilledButton(
                onPressed: () async {
                  Get.back();
                  try {
                    await OpenIM.iMManager.conversationManager
                        .clearConversationAndDeleteAllMsg(
                          conversationID:
                              controller.conversation.conversationID,
                        );
                    controller.messages.clear();
                  } catch (e) {
                    Get.snackbar(
                      '失败',
                      '$e',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('清空'),
              ),
            ],
          ),
        );
    }
  }

  void _showSearchDialog(BuildContext context) {
    final searchCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('搜索消息'),
        content: TextField(
          controller: searchCtrl,
          decoration: const InputDecoration(labelText: '关键词'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              Get.back();
              try {
                final result = await OpenIM.iMManager.messageManager
                    .searchLocalMessages(
                      conversationID: controller.conversation.conversationID,
                      keywordList: [searchCtrl.text],
                      pageIndex: 1,
                      count: 50,
                    );
                Get.snackbar(
                  '搜索结果',
                  '找到 ${result.totalCount} 条消息',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e) {
                Get.snackbar('搜索失败', '$e', snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: const Text('搜索'),
          ),
        ],
      ),
    );
  }
}
