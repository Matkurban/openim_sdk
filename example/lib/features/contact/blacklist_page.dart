import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/empty_state_view.dart';

/// 通讯录黑名单管理页。
///
/// Blacklist management page.
class BlacklistPage extends StatefulWidget {
  /// 创建黑名单管理页。
  const BlacklistPage({super.key});

  @override
  State<BlacklistPage> createState() => _BlacklistPageState();
}

class _BlacklistPageState extends State<BlacklistPage> {
  late final Signal<List<BlacklistInfo>> _list = signal<List<BlacklistInfo>>(
    <BlacklistInfo>[],
  );
  late final Signal<bool> _loading = signal<bool>(true);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<BlacklistInfo> list = await OpenIM.iMManager.friendshipManager
        .getBlacklist();
    if (mounted) {
      batch(() {
        _list.value = list;
        _loading.value = false;
      });
    }
  }

  Future<void> _remove(String userId) async {
    try {
      await OpenIM.iMManager.friendshipManager.removeBlacklist(userID: userId);
      await FlutterToastPro.success('已移出黑名单');
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('移出失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('通讯录黑名单')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          if (_loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<BlacklistInfo> list = _list.value;
          if (list.isEmpty) {
            return const EmptyStateView(title: '黑名单为空');
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (BuildContext _, int _) =>
                const Divider(height: 1, indent: 68),
            itemBuilder: (BuildContext _, int index) {
              final BlacklistInfo item = list[index];
              final String uid = item.blockUserID ?? '';
              return ListTile(
                leading: CachedAvatar(
                  imageUrl: item.faceURL,
                  fallbackName: item.nickname ?? uid,
                ),
                title: Text(item.nickname ?? uid),
                trailing: TextButton(
                  onPressed: () => _remove(uid),
                  child: const Text('移出'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
