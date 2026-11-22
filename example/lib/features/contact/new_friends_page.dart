import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/empty_state_view.dart';

/// 新的朋友页：处理收到的好友申请与查看我发出的申请。
///
/// New friends page for incoming and outgoing friend applications.
class NewFriendsPage extends StatefulWidget {
  /// 创建新的朋友页。
  const NewFriendsPage({super.key});

  @override
  State<NewFriendsPage> createState() => _NewFriendsPageState();
}

class _NewFriendsPageState extends State<NewFriendsPage> {
  List<FriendApplicationInfo> _received = <FriendApplicationInfo>[];
  List<FriendApplicationInfo> _sent = <FriendApplicationInfo>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final List<FriendApplicationInfo> rec = await OpenIM
          .iMManager
          .friendshipManager
          .getFriendApplicationListAsRecipient();
      final List<FriendApplicationInfo> sent = await OpenIM
          .iMManager
          .friendshipManager
          .getFriendApplicationListAsApplicant();
      if (mounted) {
        setState(() {
          _received = rec;
          _sent = sent;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _handle(FriendApplicationInfo info, bool accept) async {
    final String uid = info.fromUserID ?? '';
    if (uid.isEmpty) {
      return;
    }
    try {
      if (accept) {
        await OpenIM.iMManager.friendshipManager.acceptFriendApplication(
          userID: uid,
        );
        await FlutterToastPro.success('已同意好友申请');
      } else {
        await OpenIM.iMManager.friendshipManager.refuseFriendApplication(
          userID: uid,
        );
        await FlutterToastPro.info('已拒绝好友申请');
      }
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('处理失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新的朋友'),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  AdaptiveRouter.of(context).pushNamed(AppRoutes.addContact),
              child: const Text('添加朋友'),
            ),
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: '收到的申请'),
              Tab(text: '发出的申请'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: <Widget>[
                  _received.isEmpty
                      ? const EmptyStateView(title: '暂无收到的好友申请')
                      : ListView.separated(
                          itemCount: _received.length,
                          separatorBuilder: (BuildContext _, int _) =>
                              const Divider(height: 1, indent: 68),
                          itemBuilder: (BuildContext _, int index) {
                            final FriendApplicationInfo item = _received[index];
                            return _FriendApplicationTile(
                              name: item.fromNickname ?? item.fromUserID ?? '',
                              avatar: item.fromFaceURL,
                              reason: item.reqMsg ?? '请求添加你为好友',
                              handleResult: item.handleResult ?? 0,
                              isIncoming: true,
                              onAccept: () => _handle(item, true),
                              onRefuse: () => _handle(item, false),
                            );
                          },
                        ),
                  _sent.isEmpty
                      ? const EmptyStateView(title: '暂无发出的好友申请')
                      : ListView.separated(
                          itemCount: _sent.length,
                          separatorBuilder: (BuildContext _, int _) =>
                              const Divider(height: 1, indent: 68),
                          itemBuilder: (BuildContext _, int index) {
                            final FriendApplicationInfo item = _sent[index];
                            return _FriendApplicationTile(
                              name: item.toNickname ?? item.toUserID ?? '',
                              avatar: item.toFaceURL,
                              reason: item.reqMsg ?? '已发送验证请求',
                              handleResult: item.handleResult ?? 0,
                              isIncoming: false,
                            );
                          },
                        ),
                ],
              ),
      ),
    );
  }
}

class _FriendApplicationTile extends StatelessWidget {
  final String name;
  final String? avatar;
  final String reason;
  final int handleResult;
  final bool isIncoming;
  final VoidCallback? onAccept;
  final VoidCallback? onRefuse;

  const _FriendApplicationTile({
    required this.name,
    required this.avatar,
    required this.reason,
    required this.handleResult,
    required this.isIncoming,
    this.onAccept,
    this.onRefuse,
  });

  @override
  Widget build(BuildContext context) {
    final String statusLabel = switch (handleResult) {
      1 => '已同意',
      -1 => '已拒绝',
      _ => '待验证',
    };
    return ListTile(
      leading: CachedAvatar(imageUrl: avatar, fallbackName: name),
      title: Text(name),
      subtitle: Text(reason, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: isIncoming && handleResult == 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(onPressed: onRefuse, child: const Text('拒绝')),
                FilledButton(onPressed: onAccept, child: const Text('接受')),
              ],
            )
          : Text(
              statusLabel,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
    );
  }
}
