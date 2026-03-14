import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _nameCtrl = TextEditingController();
  final _memberCtrl = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _memberCtrl.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      Get.snackbar('提示', '请输入群名称', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isCreating = true);
    try {
      final memberIDs = _memberCtrl.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final group = await OpenIM.iMManager.groupManager.createGroup(
        groupInfo: GroupInfo(groupID: '', groupName: name, groupType: GroupType.work),
        memberUserIDs: memberIDs,
      );

      Get.snackbar(
        '创建成功',
        '群组: ${group.groupName} (${group.groupID})',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    } catch (e) {
      Get.snackbar('创建失败', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('创建群组')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: '群名称', prefixIcon: Icon(Icons.group)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _memberCtrl,
              decoration: const InputDecoration(
                labelText: '成员 User ID（逗号分隔）',
                prefixIcon: Icon(Icons.people),
                helperText: '例: user1, user2, user3',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isCreating ? null : _createGroup,
              child: _isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('创建群组'),
            ),
          ],
        ),
      ),
    );
  }
}
