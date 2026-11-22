import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

/// 新建收藏笔记与网页链接页（对接 `FavoriteManager.addNote` / `addLink`）。
///
/// Favorite note and web link composer page.
class FavoriteNoteEditorPage extends StatefulWidget {
  /// 创建收藏笔记编辑页。
  const FavoriteNoteEditorPage({super.key});

  @override
  State<FavoriteNoteEditorPage> createState() => _FavoriteNoteEditorPageState();
}

class _FavoriteNoteEditorPageState extends State<FavoriteNoteEditorPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  late final Signal<bool> _isLink = signal<bool>(false);
  late final Signal<bool> _saving = signal<bool>(false);

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();
    if (title.isEmpty) {
      await FlutterToastPro.warning('请输入标题');
      return;
    }
    _saving.value = true;
    try {
      if (_isLink.value) {
        await OpenIM.iMManager.favoriteManager.addLink(
          link: LinkInfo(
            url: _urlController.text.trim(),
            title: title,
            description: content,
          ),
        );
      } else {
        await OpenIM.iMManager.favoriteManager.addNote(
          title: title,
          content: content,
        );
      }
      await FlutterToastPro.success('保存成功');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('保存失败：$error');
    } finally {
      if (mounted) {
        _saving.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新建收藏'),
        actions: <Widget>[
          SignalBuilder(
            builder: (BuildContext _) {
              return TextButton(
                onPressed: _saving.value ? null : _save,
                child: const Text('保存'),
              );
            },
          ),
        ],
      ),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final bool isLink = _isLink.value;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              SegmentedButton<bool>(
                segments: const <ButtonSegment<bool>>[
                  ButtonSegment<bool>(value: false, label: Text('收藏笔记')),
                  ButtonSegment<bool>(value: true, label: Text('收藏链接')),
                ],
                selected: <bool>{isLink},
                onSelectionChanged: (Set<bool> next) {
                  _isLink.value = next.first;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '标题'),
              ),
              if (isLink) ...<Widget>[
                const SizedBox(height: 12),
                TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(labelText: '网页 URL'),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: _contentController,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: isLink ? '链接描述' : '笔记正文',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
