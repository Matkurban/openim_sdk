import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/contacts_controller.dart';
import '../routes/app_routes.dart';

class ContactsPage extends GetView<ContactsController> {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('通讯录'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              tooltip: '添加好友',
              onPressed: () => Get.toNamed(AppRoutes.addFriend),
            ),
            IconButton(
              icon: const Icon(Icons.group_add),
              tooltip: '创建群组',
              onPressed: () => Get.toNamed(AppRoutes.createGroup),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Obx(() => Tab(text: '好友 (${controller.friends.length})')),
              Obx(() => Tab(text: '群组 (${controller.groups.length})')),
              Obx(() {
                final pending = controller.friendRequests
                    .where((r) => r.handleResult == 0)
                    .length;
                return Tab(text: pending > 0 ? '申请 ($pending)' : '申请');
              }),
              Obx(() => Tab(text: '黑名单 (${controller.blacklist.length})')),
            ],
            isScrollable: true,
            tabAlignment: TabAlignment.start,
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            children: [
              _buildFriendList(),
              _buildGroupList(),
              _buildRequestList(),
              _buildBlacklist(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFriendList() {
    return Obx(() {
      if (controller.friends.isEmpty) {
        return _emptyState(Icons.people_outline, '暂无好友');
      }
      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView.builder(
          itemCount: controller.friends.length,
          itemBuilder: (context, index) {
            final f = controller.friends[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  (f.remark ?? f.friendUserID ?? '?')[0].toUpperCase(),
                ),
              ),
              title: Text(f.remark ?? f.friendUserID ?? ''),
              subtitle: f.remark != null ? Text('ID: ${f.friendUserID}') : null,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => controller.startChat(f),
              onLongPress: () => _showFriendActions(context, f),
            );
          },
        ),
      );
    });
  }

  Widget _buildGroupList() {
    return Obx(() {
      if (controller.groups.isEmpty) {
        return _emptyState(Icons.group_outlined, '暂未加入任何群组');
      }
      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView.builder(
          itemCount: controller.groups.length,
          itemBuilder: (context, index) {
            final g = controller.groups[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: const Icon(Icons.group, color: Colors.blue),
              ),
              title: Text(g.groupName ?? g.groupID),
              subtitle: Text('${g.memberCount ?? 0} 人'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => controller.startGroupChat(g),
              onLongPress: () => _showGroupActions(context, g),
            );
          },
        ),
      );
    });
  }

  Widget _buildRequestList() {
    return Obx(() {
      final allRequests = <Widget>[];

      // Friend requests
      for (final r in controller.friendRequests) {
        final isPending = r.handleResult == 0;
        allRequests.add(
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange[100],
              child: const Icon(Icons.person_add, color: Colors.orange),
            ),
            title: Text(r.fromNickname ?? r.fromUserID ?? ''),
            subtitle: Text(r.reqMsg ?? '请求加为好友'),
            trailing: isPending
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => controller.rejectFriendRequest(r),
                        child: const Text('拒绝'),
                      ),
                      const SizedBox(width: 4),
                      FilledButton(
                        onPressed: () => controller.acceptFriendRequest(r),
                        child: const Text('接受'),
                      ),
                    ],
                  )
                : Text(
                    r.handleResult == 1 ? '已接受' : '已拒绝',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
          ),
        );
      }

      // Group requests
      for (final r in controller.groupRequests) {
        final isPending = r.handleResult == 0;
        allRequests.add(
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[100],
              child: const Icon(Icons.group_add, color: Colors.green),
            ),
            title: Text('${r.userID} 申请加入 ${r.groupName ?? r.groupID}'),
            subtitle: Text(r.reqMsg ?? ''),
            trailing: isPending
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => controller.rejectGroupRequest(r),
                        child: const Text('拒绝'),
                      ),
                      const SizedBox(width: 4),
                      FilledButton(
                        onPressed: () => controller.acceptGroupRequest(r),
                        child: const Text('接受'),
                      ),
                    ],
                  )
                : Text(
                    r.handleResult == 1 ? '已接受' : '已拒绝',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
          ),
        );
      }

      if (allRequests.isEmpty) {
        return _emptyState(Icons.mail_outline, '暂无申请');
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(children: allRequests),
      );
    });
  }

  Widget _buildBlacklist() {
    return Obx(() {
      if (controller.blacklist.isEmpty) {
        return _emptyState(Icons.block, '黑名单为空');
      }
      return ListView.builder(
        itemCount: controller.blacklist.length,
        itemBuilder: (context, index) {
          final b = controller.blacklist[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.black12,
              child: Icon(Icons.block, color: Colors.grey),
            ),
            title: Text(b.blockUserID ?? ''),
            trailing: TextButton(
              onPressed: () => controller.removeFromBlacklist(b.blockUserID!),
              child: const Text('移除'),
            ),
          );
        },
      );
    });
  }

  Widget _emptyState(IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 8),
          Text(text, style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  void _showFriendActions(BuildContext context, dynamic f) {
    Get.bottomSheet(
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('发消息'),
              onTap: () {
                Get.back();
                controller.startChat(f);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('查看资料'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.userProfile, arguments: f.friendUserID);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.orange),
              title: const Text(
                '加入黑名单',
                style: TextStyle(color: Colors.orange),
              ),
              onTap: () {
                Get.back();
                controller.addToBlacklist(f.friendUserID!);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_remove, color: Colors.red),
              title: const Text('删除好友', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                controller.deleteFriend(f.friendUserID!);
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

  void _showGroupActions(BuildContext context, dynamic g) {
    Get.bottomSheet(
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('进入群聊'),
              onTap: () {
                Get.back();
                controller.startGroupChat(g);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('群信息'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.groupInfo, arguments: g.groupID);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('退出群组', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                controller.quitGroup(g.groupID);
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
