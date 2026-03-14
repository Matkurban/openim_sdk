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
  List<GroupMembersInfo> _admins = [];
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
      final groups = await OpenIM.iMManager.groupManager.getGroupsInfo(
        groupIDList: [groupID],
      );
      if (groups.isNotEmpty) _group = groups.first;

      _members = await OpenIM.iMManager.groupManager.getGroupMemberList(
        groupID: groupID,
        count: 100,
      );

      _admins = await OpenIM.iMManager.groupManager.getGroupOwnerAndAdmin(
        groupID: groupID,
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
                const PopupMenuItem(
                  value: 'search_member',
                  child: Text('搜索成员'),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'mute_group',
                  child: Text(
                    (_group!.status == GroupStatus.muted) ? '取消全员禁言' : '全员禁言',
                  ),
                ),
                const PopupMenuItem(
                  value: 'check_users',
                  child: Text('检查用户是否在群'),
                ),
                const PopupMenuItem(
                  value: 'members_by_time',
                  child: Text('按入群时间查看'),
                ),
                const PopupMenuDivider(),
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
                  // 群头部信息
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue[100],
                          backgroundImage:
                              _group!.faceURL != null &&
                                  _group!.faceURL!.isNotEmpty
                              ? NetworkImage(_group!.faceURL!)
                              : null,
                          child:
                              _group!.faceURL == null ||
                                  _group!.faceURL!.isEmpty
                              ? const Icon(
                                  Icons.group,
                                  size: 40,
                                  color: Colors.blue,
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _group!.groupName ?? '',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${_group!.memberCount ?? 0} 人  |  群ID: $groupID',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        if (_group!.status == GroupStatus.muted)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Chip(
                              label: const Text(
                                '全员禁言中',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: Colors.red,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        if (_group!.notification != null &&
                            _group!.notification!.isNotEmpty)
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _group!.notification!,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // 管理员列表
                  if (_admins.isNotEmpty) ...[
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        '群主/管理员 (${_admins.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ..._admins.map(
                      (m) => _buildMemberTile(m, showAdmin: false),
                    ),
                  ],

                  // 全部成员
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      '全部成员 (${_members.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ..._members.map((m) => _buildMemberTile(m)),
                ],
              ),
            ),
    );
  }

  Widget _buildMemberTile(GroupMembersInfo m, {bool showAdmin = true}) {
    return ListTile(
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
      trailing: _isOwnerOrAdmin()
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (m.roleLevel != GroupRoleLevel.owner)
                  IconButton(
                    icon: const Icon(Icons.mic_off, size: 20),
                    tooltip: '禁言成员',
                    onPressed: () => _showMuteMemberDialog(m),
                  ),
                if (m.roleLevel != GroupRoleLevel.owner)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    tooltip: '修改信息',
                    onPressed: () => _showEditMemberDialog(m),
                  ),
                if (m.roleLevel != GroupRoleLevel.owner)
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    tooltip: '踢出',
                    onPressed: () => _kickMember(m),
                  ),
              ],
            )
          : null,
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
          (m.roleLevel == GroupRoleLevel.owner ||
              m.roleLevel == GroupRoleLevel.admin),
    );
  }

  // ---- 操作方法 ----

  Future<void> _kickMember(GroupMembersInfo m) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('移除成员'),
        content: Text('确定移除 ${m.nickname ?? m.userID} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('取消'),
          ),
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
      case 'search_member':
        _showSearchMembersDialog();
      case 'mute_group':
        _toggleGroupMute();
      case 'check_users':
        _showCheckUsersDialog();
      case 'members_by_time':
        _showMembersByTimeDialog();
      case 'transfer':
        _showTransferDialog();
      case 'dismiss':
        _dismissGroup();
    }
  }

  // ---- 全员禁言 ----

  Future<void> _toggleGroupMute() async {
    final isMuted = _group!.status == GroupStatus.muted;
    try {
      await OpenIM.iMManager.groupManager.changeGroupMute(
        groupID: groupID,
        mute: !isMuted,
      );
      await _load();
      Get.snackbar(
        '成功',
        isMuted ? '已取消全员禁言' : '已开启全员禁言',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ---- 成员禁言 ----

  void _showMuteMemberDialog(GroupMembersInfo m) {
    final ctrl = TextEditingController(text: '60');
    Get.dialog(
      AlertDialog(
        title: Text('禁言 ${m.nickname ?? m.userID}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('输入禁言秒数（0 = 取消禁言）'),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '禁言秒数'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              Get.back();
              try {
                await OpenIM.iMManager.groupManager.changeGroupMemberMute(
                  groupID: groupID,
                  userID: m.userID!,
                  seconds: int.tryParse(ctrl.text) ?? 0,
                );
                Get.snackbar(
                  '成功',
                  '已设置禁言',
                  snackPosition: SnackPosition.BOTTOM,
                );
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

  // ---- 修改成员信息 ----

  void _showEditMemberDialog(GroupMembersInfo m) {
    final nickCtrl = TextEditingController(text: m.nickname ?? '');
    final exCtrl = TextEditingController(text: m.ex ?? '');
    Get.dialog(
      AlertDialog(
        title: Text('修改 ${m.nickname ?? m.userID} 的信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nickCtrl,
              decoration: const InputDecoration(labelText: '群内昵称'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: exCtrl,
              decoration: const InputDecoration(labelText: '扩展信息'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          FilledButton(
            onPressed: () async {
              Get.back();
              try {
                await OpenIM.iMManager.groupManager.setGroupMemberInfo(
                  groupMembersInfo: SetGroupMemberInfo(
                    groupID: groupID,
                    userID: m.userID!,
                    nickname: nickCtrl.text.trim(),
                    ex: exCtrl.text.trim(),
                  ),
                );
                await _load();
                Get.snackbar('成功', '已修改', snackPosition: SnackPosition.BOTTOM);
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

  // ---- 搜索成员 ----

  void _showSearchMembersDialog() {
    final ctrl = TextEditingController();
    final results = <GroupMembersInfo>[].obs;
    Get.dialog(
      AlertDialog(
        title: const Text('搜索群成员'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                decoration: const InputDecoration(labelText: '关键词(ID/昵称)'),
                autofocus: true,
                onChanged: (v) async {
                  if (v.isEmpty) {
                    results.clear();
                    return;
                  }
                  try {
                    results.value = await OpenIM.iMManager.groupManager
                        .searchGroupMembers(
                          groupID: groupID,
                          keywordList: [v],
                          isSearchUserID: true,
                          isSearchMemberNickname: true,
                        );
                  } catch (_) {
                    results.clear();
                  }
                },
              ),
              const SizedBox(height: 8),
              Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: results.isEmpty
                      ? [
                          if (ctrl.text.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                '无匹配成员',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                        ]
                      : results
                            .take(10)
                            .map(
                              (m) => ListTile(
                                dense: true,
                                title: Text(m.nickname ?? m.userID ?? ''),
                                subtitle: Text(
                                  '${_roleName(m.roleLevel?.value)} | ID: ${m.userID}',
                                ),
                              ),
                            )
                            .toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('关闭')),
        ],
      ),
    );
  }

  // ---- 检查用户是否在群 ----

  void _showCheckUsersDialog() {
    final ctrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('检查用户是否在群'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'User ID(逗号分隔)'),
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
                final inGroup = await OpenIM.iMManager.groupManager
                    .getUsersInGroup(groupID: groupID, userIDList: ids);
                final notIn = ids.where((id) => !inGroup.contains(id)).toList();
                Get.snackbar(
                  '结果',
                  '在群: ${inGroup.join(", ")}\n不在群: ${notIn.join(", ")}',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 5),
                );
              } catch (e) {
                Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
              }
            },
            child: const Text('检查'),
          ),
        ],
      ),
    );
  }

  // ---- 按入群时间查看 ----

  void _showMembersByTimeDialog() async {
    try {
      final members = await OpenIM.iMManager.groupManager
          .getGroupMemberListByJoinTime(
            groupID: groupID,
            offset: 0,
            count: 50,
            joinTimeBegin: 0,
            joinTimeEnd: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          );
      Get.dialog(
        AlertDialog(
          title: Text('按入群时间 (${members.length} 人)'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (_, i) {
                final m = members[i];
                final joinTime = m.joinTime != null
                    ? DateTime.fromMillisecondsSinceEpoch(
                        m.joinTime! * 1000,
                      ).toString().substring(0, 16)
                    : '未知';
                return ListTile(
                  dense: true,
                  title: Text(m.nickname ?? m.userID ?? ''),
                  subtitle: Text('加入时间: $joinTime'),
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('关闭')),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ---- 邀请/编辑/转让/解散 ----

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
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('取消'),
          ),
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
