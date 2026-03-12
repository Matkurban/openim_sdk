import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final _userIDCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  var _searchResults = <UserInfo>[];
  bool _isSearching = false;
  bool _isSending = false;

  @override
  void dispose() {
    _userIDCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _searchUser() async {
    final userID = _userIDCtrl.text.trim();
    if (userID.isEmpty) return;

    setState(() => _isSearching = true);
    try {
      final users = await OpenIM.iMManager.userManager.getUsersInfo(userIDList: [userID]);
      setState(() => _searchResults = users);
      if (users.isEmpty) {
        Get.snackbar('提示', '未找到该用户', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('搜索失败', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _addFriend(String userID) async {
    setState(() => _isSending = true);
    try {
      await OpenIM.iMManager.friendshipManager.addFriend(
        userID: userID,
        reason: _reasonCtrl.text.trim(),
      );
      Get.snackbar('成功', '好友申请已发送', snackPosition: SnackPosition.BOTTOM);
      Get.back();
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('添加好友')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _userIDCtrl,
                    decoration: const InputDecoration(
                      labelText: '用户 ID',
                      prefixIcon: Icon(Icons.search),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _searchUser(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _isSearching ? null : _searchUser,
                  child: _isSearching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('搜索'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonCtrl,
              decoration: const InputDecoration(
                labelText: '验证消息（可选）',
                prefixIcon: Icon(Icons.message),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(
                      child: Text('输入用户ID搜索', style: TextStyle(color: Colors.grey[500])),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: user.faceURL != null && user.faceURL!.isNotEmpty
                                  ? NetworkImage(user.faceURL!)
                                  : null,
                              child: user.faceURL == null || user.faceURL!.isEmpty
                                  ? Text((user.nickname ?? user.userID ?? '?')[0].toUpperCase())
                                  : null,
                            ),
                            title: Text(user.nickname ?? user.userID ?? ''),
                            subtitle: Text('ID: ${user.userID}'),
                            trailing: FilledButton(
                              onPressed: _isSending ? null : () => _addFriend(user.userID!),
                              child: _isSending
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('添加'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
