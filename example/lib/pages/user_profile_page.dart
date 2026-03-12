import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserInfo? _user;
  bool _isFriend = false;
  bool _isLoading = true;

  String get userID => Get.arguments as String;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final users = await OpenIM.iMManager.userManager.getUsersInfo(userIDList: [userID]);
      if (users.isNotEmpty) _user = users.first;

      final checks = await OpenIM.iMManager.friendshipManager.checkFriend(userIDList: [userID]);
      _isFriend = checks.isNotEmpty && checks.first.result == 1;
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('用户资料')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text('用户不存在'))
          : ListView(
              children: [
                const SizedBox(height: 32),
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: _user!.faceURL != null && _user!.faceURL!.isNotEmpty
                        ? NetworkImage(_user!.faceURL!)
                        : null,
                    child: _user!.faceURL == null || _user!.faceURL!.isEmpty
                        ? Text(
                            (_user!.nickname ?? _user!.userID ?? '?')[0].toUpperCase(),
                            style: const TextStyle(fontSize: 36),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    _user!.nickname ?? '未设置昵称',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Center(
                  child: Text('ID: ${_user!.userID}', style: TextStyle(color: Colors.grey[600])),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      if (_isFriend) ...[
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            icon: const Icon(Icons.chat),
                            label: const Text('发消息'),
                            onPressed: () async {
                              try {
                                final conv = await OpenIM.iMManager.conversationManager
                                    .getOneConversation(
                                      sourceID: userID,
                                      sessionType: ConversationType.single.value,
                                    );
                                Get.toNamed('/chat', arguments: conv);
                              } catch (e) {
                                Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.person_remove, color: Colors.red),
                            label: const Text('删除好友', style: TextStyle(color: Colors.red)),
                            onPressed: () async {
                              try {
                                await OpenIM.iMManager.friendshipManager.deleteFriend(
                                  userID: userID,
                                );
                                Get.snackbar('成功', '已删除', snackPosition: SnackPosition.BOTTOM);
                                Get.back();
                              } catch (e) {
                                Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                          ),
                        ),
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            icon: const Icon(Icons.person_add),
                            label: const Text('添加好友'),
                            onPressed: () async {
                              try {
                                await OpenIM.iMManager.friendshipManager.addFriend(userID: userID);
                                Get.snackbar('成功', '好友申请已发送', snackPosition: SnackPosition.BOTTOM);
                              } catch (e) {
                                Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
