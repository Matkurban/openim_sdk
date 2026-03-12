import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';

class GroupInfoPage extends StatefulWidget {
  const GroupInfoPage({super.key});

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  GroupInfo? _group;
  List<GroupMembersInfo> _members = [];
  bool _isLoading = true;

  String get groupID => Get.arguments as String;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final groups = await OpenIM.iMManager.groupManager.getGroupsInfo(groupIDList: [groupID]);
      if (groups.isNotEmpty) _group = groups.first;

      _members = await OpenIM.iMManager.groupManager.getGroupMemberList(
        groupID: groupID,
        count: 100,
      );
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('群信息'),
        actions: [
          if (_group != null)
            PopupMenuButton<String>(
              onSelected: _handleAction,
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'invite', child: Text('邀请成员')),
                const PopupMenuItem(value: 'edit', child: Text('编辑群信息')),
                const PopupMenuItem(value: 'transfer', child: Text('转让群主')),
                const PopupMenuItem(
                  value: 'dismiss',
                  child: Text('解散群组', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _group == null
          ? const Center(child: Text('群组不存在'))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                children: [
                  // Group header
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue[100],
                          backgroundImage: _group!.faceURL != null && _group!.faceURL!.isNotEmpty
                              ? NetworkImage(_group!.faceURL!)
                              : null,
                          child: _group!.faceURL == null || _group!.faceURL!.isEmpty
                              ? const Icon(Icons.group, size: 40, color: Colors.blue)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _group!.groupName ?? '',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${_group!.memberCount ?? 0} 人',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        if (_group!.notification != null && _group!.notification!.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '群公告',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Text(_group!.notification!, style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // Members
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      '成员 (${_members.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ..._members.map(
                    (m) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage: m.faceURL != null && m.faceURL!.isNotEmpty
                            ? NetworkImage(m.faceURL!)
                            : null,
                        child: m.faceURL == null || m.faceURL!.isEmpty
                            ? Text((m.nickname ?? m.userID ?? '?')[0].toUpperCase())
                            : null,
                      ),
                      title: Text(m.nickname ?? m.userID ?? ''),
                      subtitle: Text(_roleName(m.roleLevel?.value)),
                      trailing: m.roleLevel != GroupRoleLevel.owner && _isOwnerOrAdmin()
                          ? IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () => _kickMember(m),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _roleName(int? level) {
    switch (level) {
      case 100:
        return '群主';
      case 60:
        return '管理员';
      default:
        return '成员';
    }
  }

  bool _isOwnerOrAdmin() {
    final myID = OpenIM.iMManager.userID;
    return _members.any(
      (m) =>
          m.userID == myID &&
          (m.roleLevel == GroupRoleLevel.owner || m.roleLevel == GroupRoleLevel.admin),
    );
  }

  Future<void> _kickMember(GroupMembersInfo m) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('移除成员'),
        content: Text('确定移除 ${m.nickname ?? m.userID} 吗？'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('取消')),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('移除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await OpenIM.iMManager.groupManager.kickGroupMember(
          groupID: groupID,
          userIDList: [m.userID!],
        );
        await _load();
        Get.snackbar('成功', '已移除', snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void _handleAction(String action) {
    switch (action) {
      case 'invite':
        _showInviteDialog();
      case 'edit':
        _showEditDialog();
      case 'transfer':
        _showTransferDialog();
      case 'dismiss':
        _dismissGroup();
    }
  }

  void _showInviteDialog() {
    final ctrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('邀请成员'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            labelText: 'User ID（逗号分隔）',
            helperText: '例: user1, user2',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              Get.back();
              final ids = ctrl.text
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              try {
                await OpenIM.iMManager.groupManager.inviteUserToGroup(
                  groupID: groupID,
                  userIDList: ids,
                );
                await _load();
                Get.snackbar('成功', '已邀请', snackPosition: SnackPosition.BOTTOM);
              } catch (e) {
                Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: const Text('邀请'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    final nameCtrl = TextEditingController(text: _group!.groupName);
    final noticeCtrl = TextEditingController(text: _group!.notification);
    Get.dialog(
      AlertDialog(
        title: const Text('编辑群信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: '群名称'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noticeCtrl,
              decoration: const InputDecoration(labelText: '群公告'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              Get.back();
              try {
                await OpenIM.iMManager.groupManager.setGroupInfo(
                  groupInfo: GroupInfo(
                    groupID: groupID,
                    groupName: nameCtrl.text.trim(),
                    notification: noticeCtrl.text.trim(),
                  ),
                );
                await _load();
                Get.snackbar('成功', '已更新', snackPosition: SnackPosition.BOTTOM);
              } catch (e) {
                Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showTransferDialog() {
    final ctrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('转让群主'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: '新群主 User ID'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              Get.back();
              try {
                await OpenIM.iMManager.groupManager.transferGroupOwner(
                  groupID: groupID,
                  userID: ctrl.text.trim(),
                );
                await _load();
                Get.snackbar('成功', '已转让', snackPosition: SnackPosition.BOTTOM);
              } catch (e) {
                Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  void _dismissGroup() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('解散群组'),
        content: const Text('确定要解散群组吗？此操作不可撤销。'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('取消')),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('解散'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await OpenIM.iMManager.groupManager.dismissGroup(groupID: groupID);
        Get.snackbar('成功', '群组已解散', snackPosition: SnackPosition.BOTTOM);
        Get.back();
      } catch (e) {
        Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
