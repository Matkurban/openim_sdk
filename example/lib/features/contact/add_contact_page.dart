import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 添加联系人页（搜索用户 ID / 昵称 / 邮箱 + 扫一扫 / 我的二维码入口）。
///
/// Add-contact page supporting user lookup, QR scanner, and personal QR card.
class AddContactPage extends StatefulWidget {
  /// 创建添加联系人页。
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _keywordController = TextEditingController();
  late final Signal<List<UserFullInfo>> _results = signal<List<UserFullInfo>>(
    <UserFullInfo>[],
  );
  late final Signal<bool> _searching = signal<bool>(false);

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final String kw = _keywordController.text.trim();
    if (kw.isEmpty) {
      return;
    }
    _searching.value = true;
    try {
      final List<UserFullInfo> list = await OpenIM.iMManager.userManager
          .searchUserFullInfo(kw);
      if (mounted) {
        _results.value = list;
      }
      if (list.isEmpty) {
        await FlutterToastPro.info('未找到匹配的用户，可直接输入用户 ID 查看资料');
      }
    } on Object catch (error) {
      await FlutterToastPro.error('搜索失败：$error');
    } finally {
      if (mounted) {
        _searching.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('添加联系人')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final bool searching = _searching.value;
          final List<UserFullInfo> results = _results.value;
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _keywordController,
                        onSubmitted: (String _) => _search(),
                        decoration: const InputDecoration(
                          hintText: '输入用户 ID / 账号 / 邮箱 / 昵称',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: searching ? null : _search,
                      child: const Text('搜索'),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('扫一扫'),
                subtitle: const Text('扫描二维码名片加好友或进群'),
                onTap: () => router.pushNamed(AppRoutes.scanner),
              ),
              ListTile(
                leading: const Icon(Icons.qr_code_2),
                title: const Text('我的二维码'),
                subtitle: Text('我的用户 ID：${OpenIM.iMManager.userID}'),
                onTap: () => router.pushNamed(AppRoutes.myQr),
              ),
              const Divider(height: 1),
              Expanded(
                child: searching
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (BuildContext _, int _) =>
                            const Divider(height: 1, indent: 68),
                        itemBuilder: (BuildContext _, int index) {
                          final UserFullInfo user = results[index];
                          final String uid = user.userID;
                          return ListTile(
                            leading: CachedAvatar(
                              imageUrl: user.faceURL,
                              fallbackName: user.nickname ?? uid,
                            ),
                            title: Text(user.nickname ?? uid),
                            subtitle: Text('ID: $uid'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () =>
                                router.pushNamed(AppRoutes.contactProfile(uid)),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
