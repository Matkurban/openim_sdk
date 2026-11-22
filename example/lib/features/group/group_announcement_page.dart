import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

/// 群公告查看与发布编辑页。
///
/// Group announcement viewing and editing page.
class GroupAnnouncementPage extends StatefulWidget {
  /// 群信息。
  final GroupInfo? group;

  /// 是否允许编辑发布。
  final bool canEdit;

  /// 创建群公告页。
  const GroupAnnouncementPage({
    super.key,
    required this.group,
    this.canEdit = false,
  });

  @override
  State<GroupAnnouncementPage> createState() => _GroupAnnouncementPageState();
}

class _GroupAnnouncementPageState extends State<GroupAnnouncementPage> {
  late final TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.group?.notification ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final String gid = widget.group?.groupID ?? '';
    if (gid.isEmpty) {
      return;
    }
    setState(() => _saving = true);
    try {
      await OpenIM.iMManager.groupManager.setGroupInfo(
        groupInfo: GroupInfo(
          groupID: gid,
          notification: _controller.text.trim(),
        ),
      );
      await FlutterToastPro.success('群公告已发布');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('发布失败：$error');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('群公告'),
        actions: <Widget>[
          if (widget.canEdit)
            TextButton(
              onPressed: _saving ? null : _publish,
              child: Text(_saving ? '发布中...' : '发布'),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          readOnly: !widget.canEdit,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            hintText: widget.canEdit ? '请输入群公告内容...' : '暂无群公告',
          ),
        ),
      ),
    );
  }
}
