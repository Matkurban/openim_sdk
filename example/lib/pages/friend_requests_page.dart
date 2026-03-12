import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  List<FriendApplicationInfo> _received = [];
  List<FriendApplicationInfo> _sent = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      _received = await OpenIM.iMManager.friendshipManager.getFriendApplicationListAsRecipient();
      _sent = await OpenIM.iMManager.friendshipManager.getFriendApplicationListAsApplicant();
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _accept(FriendApplicationInfo info) async {
    try {
      await OpenIM.iMManager.friendshipManager.acceptFriendApplication(userID: info.fromUserID!);
      Get.snackbar('成功', '已接受', snackPosition: SnackPosition.BOTTOM);
      _load();
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _reject(FriendApplicationInfo info) async {
    try {
      await OpenIM.iMManager.friendshipManager.refuseFriendApplication(userID: info.fromUserID!);
      Get.snackbar('成功', '已拒绝', snackPosition: SnackPosition.BOTTOM);
      _load();
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('好友申请'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '收到的'),
              Tab(text: '发出的'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildList(_received, canAction: true),
                  _buildList(_sent, canAction: false),
                ],
              ),
      ),
    );
  }

  Widget _buildList(List<FriendApplicationInfo> list, {required bool canAction}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mail_outline, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text('暂无申请', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final r = list[index];
          final isPending = r.handleResult == 0;
          return ListTile(
            leading: CircleAvatar(
              child: Text((r.fromNickname ?? r.fromUserID ?? '?')[0].toUpperCase()),
            ),
            title: Text(r.fromNickname ?? r.fromUserID ?? ''),
            subtitle: Text(r.reqMsg ?? ''),
            trailing: canAction && isPending
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(onPressed: () => _reject(r), child: const Text('拒绝')),
                      const SizedBox(width: 4),
                      FilledButton(onPressed: () => _accept(r), child: const Text('接受')),
                    ],
                  )
                : Text(
                    isPending ? '等待处理' : (r.handleResult == 1 ? '已接受' : '已拒绝'),
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
          );
        },
      ),
    );
  }
}
