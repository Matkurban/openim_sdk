import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              const PopupMenuItem(value: 'insert_local', child: Text('插入本地消息')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'clear', child: Text('清空聊天记录')),
              const PopupMenuItem(
                value: 'delete_all_svr',
                child: Text(
                  '删除所有消息(含服务端)',
                  style: TextStyle(color: Colors.red),
                ),
              ),
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

          // Quote bar
          Obx(() {
            final quote = controller.quoteMessage.value;
            if (quote == null) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.grey[100],
              child: Row(
                children: [
                  const Icon(Icons.reply, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '回复: ${controller.getMessageContent(quote)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.clearQuoteMessage,
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }),

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
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showMoreActions(context),
          ),
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
                  _actionButton(Icons.image, '图片', () {
                    Get.back();
                    _sendImage(context);
                  }),
                  _actionButton(Icons.mic, '语音', () {
                    Get.back();
                    _sendVoice(context);
                  }),
                  _actionButton(Icons.videocam, '视频', () {
                    Get.back();
                    _sendVideo(context);
                  }),
                  _actionButton(Icons.attach_file, '文件', () {
                    Get.back();
                    _sendFile(context);
                  }),
                ],
              ),
              const SizedBox(height: 12),
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
                  _actionButton(Icons.emoji_emotions, '表情', () {
                    Get.back();
                    _sendFace(context);
                  }),
                  _actionButton(Icons.extension, '自定义', () {
                    Get.back();
                    _sendCustom(context);
                  }),
                ],
              ),
              if (controller.conversation.isGroupChat) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton(Icons.alternate_email, '@提及', () {
                      Get.back();
                      _sendAtMessage(context);
                    }),
                    const SizedBox(width: 56 + 24), // placeholder
                    const SizedBox(width: 56 + 24),
                    const SizedBox(width: 56 + 24),
                  ],
                ),
              ],
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

  // ---- 各种消息发送对话框 ----

  void _sendImage(BuildContext context) {
    final urlCtrl = TextEditingController();
    _showInputDialog(
      '发送图片',
      [
        TextField(
          controller: urlCtrl,
          decoration: const InputDecoration(labelText: '图片 URL'),
        ),
      ],
      () {
        controller.sendImageMessageByURL(url: urlCtrl.text.trim());
      },
    );
  }

  void _sendVoice(BuildContext context) {
    final urlCtrl = TextEditingController();
    final durCtrl = TextEditingController(text: '5');
    _showInputDialog(
      '发送语音',
      [
        TextField(
          controller: urlCtrl,
          decoration: const InputDecoration(labelText: '音频 URL'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: durCtrl,
          decoration: const InputDecoration(labelText: '时长(秒)'),
          keyboardType: TextInputType.number,
        ),
      ],
      () {
        controller.sendSoundMessageByURL(
          url: urlCtrl.text.trim(),
          duration: int.tryParse(durCtrl.text) ?? 5,
        );
      },
    );
  }

  void _sendVideo(BuildContext context) {
    final urlCtrl = TextEditingController();
    final snapCtrl = TextEditingController();
    final durCtrl = TextEditingController(text: '10');
    _showInputDialog(
      '发送视频',
      [
        TextField(
          controller: urlCtrl,
          decoration: const InputDecoration(labelText: '视频 URL'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: snapCtrl,
          decoration: const InputDecoration(labelText: '封面 URL'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: durCtrl,
          decoration: const InputDecoration(labelText: '时长(秒)'),
          keyboardType: TextInputType.number,
        ),
      ],
      () {
        controller.sendVideoMessageByURL(
          videoUrl: urlCtrl.text.trim(),
          snapshotUrl: snapCtrl.text.trim(),
          duration: int.tryParse(durCtrl.text) ?? 10,
        );
      },
    );
  }

  void _sendFile(BuildContext context) {
    final urlCtrl = TextEditingController();
    final nameCtrl = TextEditingController(text: 'document.pdf');
    _showInputDialog(
      '发送文件',
      [
        TextField(
          controller: urlCtrl,
          decoration: const InputDecoration(labelText: '文件 URL'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: '文件名'),
        ),
      ],
      () {
        controller.sendFileMessageByURL(
          fileUrl: urlCtrl.text.trim(),
          fileName: nameCtrl.text.trim(),
        );
      },
    );
  }

  void _sendLocation(BuildContext context) {
    final latCtrl = TextEditingController(text: '39.9042');
    final lngCtrl = TextEditingController(text: '116.4074');
    final descCtrl = TextEditingController(text: '北京');
    _showInputDialog(
      '发送位置',
      [
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
      () {
        controller.sendLocationMessage(
          double.tryParse(latCtrl.text) ?? 0,
          double.tryParse(lngCtrl.text) ?? 0,
          descCtrl.text,
        );
      },
    );
  }

  void _sendCard(BuildContext context) {
    final idCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    _showInputDialog(
      '发送名片',
      [
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
      () {
        controller.sendCardMessage(idCtrl.text, nameCtrl.text, '');
      },
    );
  }

  void _sendFace(BuildContext context) {
    final indexCtrl = TextEditingController(text: '0');
    final dataCtrl = TextEditingController(text: '😀');
    _showInputDialog(
      '发送表情',
      [
        TextField(
          controller: indexCtrl,
          decoration: const InputDecoration(labelText: '表情索引'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: dataCtrl,
          decoration: const InputDecoration(labelText: '表情数据'),
        ),
      ],
      () {
        controller.sendFaceMessage(
          index: int.tryParse(indexCtrl.text) ?? 0,
          data: dataCtrl.text,
        );
      },
    );
  }

  void _sendCustom(BuildContext context) {
    final dataCtrl = TextEditingController(text: '{"type":"test"}');
    final descCtrl = TextEditingController(text: '自定义消息');
    _showInputDialog(
      '发送自定义消息',
      [
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
      () {
        controller.sendCustomMessage(dataCtrl.text, '', descCtrl.text);
      },
    );
  }

  void _sendAtMessage(BuildContext context) {
    final textCtrl = TextEditingController();
    final idsCtrl = TextEditingController();
    _showInputDialog(
      '发送@消息',
      [
        TextField(
          controller: idsCtrl,
          decoration: const InputDecoration(labelText: '@的用户ID(逗号分隔)'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textCtrl,
          decoration: const InputDecoration(labelText: '消息内容'),
        ),
      ],
      () {
        final ids = idsCtrl.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        controller.sendAtMessage(text: textCtrl.text, atUserIDList: ids);
      },
    );
  }

  void _showInputDialog(
    String title,
    List<Widget> fields,
    VoidCallback onSend,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: fields),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              Get.back();
              onSend();
            },
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }

  // ---- 消息操作菜单 ----

  void _showMessageActions(BuildContext context, Message msg, bool isMe) {
    Get.bottomSheet(
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('回复'),
              onTap: () {
                Get.back();
                controller.setQuoteMessage(msg);
              },
            ),
            ListTile(
              leading: const Icon(Icons.forward),
              title: const Text('转发'),
              onTap: () {
                Get.back();
                controller.forwardMessage(msg);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('复制'),
              onTap: () {
                Get.back();
                final text = controller.getMessageContent(msg);
                Clipboard.setData(ClipboardData(text: text));
                Get.snackbar('已复制', text, snackPosition: SnackPosition.BOTTOM);
              },
            ),
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
              leading: const Icon(Icons.delete_outline),
              title: const Text('删除(本地)'),
              onTap: () {
                Get.back();
                controller.deleteMessage(msg);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                '删除(本地+服务端)',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                controller.deleteMessageFromServer(msg);
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
      case 'insert_local':
        _showInsertLocalDialog(context);
      case 'clear':
        Get.dialog(
          AlertDialog(
            title: const Text('清空聊天记录'),
            content: const Text('确定要清空所有聊天记录吗？'),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('取消')),
              FilledButton(
                onPressed: () {
                  Get.back();
                  controller.clearAllMessages();
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('清空'),
              ),
            ],
          ),
        );
      case 'delete_all_svr':
        Get.dialog(
          AlertDialog(
            title: const Text('删除所有消息'),
            content: const Text('将同时删除本地和服务端的所有消息，此操作不可恢复。'),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('取消')),
              FilledButton(
                onPressed: () {
                  Get.back();
                  controller.deleteAllMsgFromLocalAndSvr();
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('删除'),
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
                final result = await controller.searchMessages(
                  keyword: searchCtrl.text,
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

  void _showInsertLocalDialog(BuildContext context) {
    final ctrl = TextEditingController(text: '这是一条本地测试消息');
    Get.dialog(
      AlertDialog(
        title: const Text('插入本地消息'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: '消息内容'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.insertLocalMessage(ctrl.text);
            },
            child: const Text('插入'),
          ),
        ],
      ),
    );
  }
}
