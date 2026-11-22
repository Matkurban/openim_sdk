import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../shared/widgets/cached_avatar.dart';

/// 群主管理权转让页（对接 `GroupManager.transferGroupOwner`）。
///
/// Group ownership transfer selection page.
class GroupTransferOwnerPage extends StatefulWidget {
  /// 群信息。
  final GroupInfo? group;

  /// 创建群主转让页。
  const GroupTransferOwnerPage({super.key, required this.group});

  @override
  State<GroupTransferOwnerPage> createState() => _GroupTransferOwnerPageState();
}

class _GroupTransferOwnerPageState extends State<GroupTransferOwnerPage> {
  late final Signal<List<GroupMembersInfo>> _candidates =
      signal<List<GroupMembersInfo>>(<GroupMembersInfo>[]);
  late final Signal<bool> _loading = signal<bool>(true);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final String gid = widget.group?.groupID ?? '';
    if (gid.isEmpty) {
      _loading.value = false;
      return;
    }
    final List<GroupMembersInfo> all = await OpenIM.iMManager.groupManager
        .getGroupMemberList(groupID: gid, count: 100);
    final String selfID = OpenIM.iMManager.userID;
    if (mounted) {
      batch(() {
        _candidates.value = all
            .where((GroupMembersInfo m) => m.userID != selfID)
            .toList();
        _loading.value = false;
      });
    }
  }

  Future<void> _transfer(GroupMembersInfo member) async {
    final String gid = widget.group?.groupID ?? '';
    final String uid = member.userID ?? '';
    if (gid.isEmpty || uid.isEmpty) {
      return;
    }
    final bool? confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: AdaptivePaneScope.maybeOf(context) != null,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('确认转让群主'),
        content: Text('确定将群主身份转让给「${member.nickname ?? uid}」吗？转让后你将变为普通成员。'),
        actions: <Widget>[
          TextButton(
            onPressed: () => AdaptiveRouter.of(ctx).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => AdaptiveRouter.of(ctx).pop(true),
            child: const Text('确认转让'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    try {
      await OpenIM.iMManager.groupManager.transferGroupOwner(
        groupID: gid,
        userID: uid,
      );
      await FlutterToastPro.success('已成功转让群主');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('转让失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择新群主')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          if (_loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<GroupMembersInfo> candidates = _candidates.value;
          return ListView.separated(
            itemCount: candidates.length,
            separatorBuilder: (BuildContext _, int _) =>
                const Divider(height: 1, indent: 68),
            itemBuilder: (BuildContext _, int index) {
              final GroupMembersInfo m = candidates[index];
              return ListTile(
                leading: CachedAvatar(
                  imageUrl: m.faceURL,
                  fallbackName: m.nickname ?? m.userID,
                ),
                title: Text(m.nickname ?? m.userID ?? ''),
                subtitle: Text(
                  m.roleLevel == GroupRoleLevel.admin ? '管理员' : '群成员',
                ),
                onTap: () => _transfer(m),
              );
            },
          );
        },
      ),
    );
  }
}
