import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/empty_state_view.dart';

/// 群通知页：审批收到的入群申请与查看我发出的申请。
///
/// Group notifications page for incoming and outgoing join applications.
class GroupNotificationsPage extends StatefulWidget {
  /// 创建群通知页。
  const GroupNotificationsPage({super.key});

  @override
  State<GroupNotificationsPage> createState() => _GroupNotificationsPageState();
}

class _GroupNotificationsPageState extends State<GroupNotificationsPage> {
  List<GroupApplicationInfo> _received = <GroupApplicationInfo>[];
  List<GroupApplicationInfo> _sent = <GroupApplicationInfo>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final List<GroupApplicationInfo> rec = await OpenIM.iMManager.groupManager
          .getGroupApplicationListAsRecipient();
      final List<GroupApplicationInfo> sent = await OpenIM
          .iMManager
          .groupManager
          .getGroupApplicationListAsApplicant();
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

  Future<void> _handle(GroupApplicationInfo app, bool accept) async {
    final String gid = app.groupID ?? '';
    final String uid = app.userID ?? '';
    if (gid.isEmpty || uid.isEmpty) {
      return;
    }
    try {
      if (accept) {
        await OpenIM.iMManager.groupManager.acceptGroupApplication(
          groupID: gid,
          userID: uid,
        );
        await FlutterToastPro.success('已同意入群申请');
      } else {
        await OpenIM.iMManager.groupManager.refuseGroupApplication(
          groupID: gid,
          userID: uid,
        );
        await FlutterToastPro.info('已拒绝入群申请');
      }
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('操作失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('群通知'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: '收到的入群申请'),
              Tab(text: '我发出的申请'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: <Widget>[
                  _received.isEmpty
                      ? const EmptyStateView(title: '暂无收到的群通知')
                      : ListView.separated(
                          itemCount: _received.length,
                          separatorBuilder: (BuildContext _, int _) =>
                              const Divider(height: 1, indent: 68),
                          itemBuilder: (BuildContext _, int index) {
                            final GroupApplicationInfo item = _received[index];
                            return _GroupAppTile(
                              item: item,
                              isIncoming: true,
                              onAccept: () => _handle(item, true),
                              onRefuse: () => _handle(item, false),
                            );
                          },
                        ),
                  _sent.isEmpty
                      ? const EmptyStateView(title: '暂无发出的入群申请')
                      : ListView.separated(
                          itemCount: _sent.length,
                          separatorBuilder: (BuildContext _, int _) =>
                              const Divider(height: 1, indent: 68),
                          itemBuilder: (BuildContext _, int index) {
                            final GroupApplicationInfo item = _sent[index];
                            return _GroupAppTile(item: item, isIncoming: false);
                          },
                        ),
                ],
              ),
      ),
    );
  }
}

class _GroupAppTile extends StatelessWidget {
  final GroupApplicationInfo item;
  final bool isIncoming;
  final VoidCallback? onAccept;
  final VoidCallback? onRefuse;

  const _GroupAppTile({
    required this.item,
    required this.isIncoming,
    this.onAccept,
    this.onRefuse,
  });

  @override
  Widget build(BuildContext context) {
    final int result = item.handleResult ?? 0;
    final String status = switch (result) {
      1 => '已通过',
      -1 => '已拒绝',
      _ => '待审核',
    };
    return ListTile(
      leading: CachedAvatar(
        imageUrl: item.userFaceURL ?? item.groupFaceURL,
        fallbackName: item.nickname ?? item.groupName ?? item.groupID,
      ),
      title: Text(
        '${item.nickname ?? item.userID} 申请加入 ${item.groupName ?? item.groupID}',
      ),
      subtitle: Text(item.reqMsg ?? '请求加入群聊'),
      trailing: isIncoming && result == 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(onPressed: onRefuse, child: const Text('拒绝')),
                FilledButton(onPressed: onAccept, child: const Text('同意')),
              ],
            )
          : Text(status, style: TextStyle(color: Theme.of(context).hintColor)),
    );
  }
}
