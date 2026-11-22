import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

/// 设置好友备注与星标页（对接 `FriendshipManager.updateFriends`）。
///
/// Friend remark and pinned-star settings page.
class FriendRemarkPage extends StatefulWidget {
  /// 目标好友用户 ID。
  final String userId;

  /// 已有好友信息（可选）。
  final FriendInfo? initialFriend;

  /// 创建设置备注页。
  const FriendRemarkPage({super.key, required this.userId, this.initialFriend});

  @override
  State<FriendRemarkPage> createState() => _FriendRemarkPageState();
}

class _FriendRemarkPageState extends State<FriendRemarkPage> {
  late final TextEditingController _remarkController;
  late final TextEditingController _exController;
  bool _isPinned = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _remarkController = TextEditingController(
      text: widget.initialFriend?.remark ?? '',
    );
    _exController = TextEditingController(text: widget.initialFriend?.ex ?? '');
    _isPinned = false;
  }

  @override
  void dispose() {
    _remarkController.dispose();
    _exController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
    });
    try {
      await OpenIM.iMManager.friendshipManager.updateFriends(
        updateFriendsReq: UpdateFriendsReq(
          friendUserIDs: <String>[widget.userId],
          remark: _remarkController.text.trim(),
          isPinned: _isPinned,
          ex: _exController.text.trim(),
        ),
      );
      await FlutterToastPro.success('备注已更新');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('保存失败：$error');
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置备注和标签'),
        actions: <Widget>[
          TextButton(
            onPressed: _saving ? null : _save,
            child: const Text('完成'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: _remarkController,
            decoration: const InputDecoration(labelText: '备注名'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _exController,
            decoration: const InputDecoration(labelText: '标签 / 扩展说明'),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('设为星标朋友'),
            value: _isPinned,
            onChanged: (bool value) => setState(() => _isPinned = value),
          ),
        ],
      ),
    );
  }
}
