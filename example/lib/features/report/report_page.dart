import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

/// 投诉举报页（支持举报用户、群组与单条消息，对接 `ReportAppealManager`）。
///
/// Unified abuse reporting page for users, groups, and messages.
class ReportPage extends StatefulWidget {
  /// 举报类型：`user`、`group`、`message`。
  final String targetType;

  /// 目标 ID。
  final String targetId;

  /// 创建投诉举报页。
  const ReportPage({
    super.key,
    required this.targetType,
    required this.targetId,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _descController = TextEditingController();
  late final Signal<String> _category = signal<String>('spam');
  late final Signal<bool> _submitting = signal<bool>(false);

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    _submitting.value = true;
    try {
      final String desc = _descController.text.trim();
      final String category = _category.value;
      switch (widget.targetType) {
        case 'group':
          await OpenIM.iMManager.reportAppealManager.reportGroup(
            targetGroupID: widget.targetId,
            category: category,
            description: desc,
          );
        case 'message':
          await OpenIM.iMManager.reportAppealManager.reportMessage(
            targetUserID: OpenIM.iMManager.userID,
            messageID: widget.targetId,
            category: category,
            description: desc,
          );
        default:
          await OpenIM.iMManager.reportAppealManager.reportUser(
            targetUserID: widget.targetId,
            category: category,
            description: desc,
          );
      }
      await FlutterToastPro.success('投诉已提交，感谢反馈');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('提交失败：$error');
    } finally {
      if (mounted) {
        _submitting.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('投诉举报')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final String category = _category.value;
          final bool submitting = _submitting.value;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text('举报对象（${widget.targetType}）：${widget.targetId}'),
              const SizedBox(height: 12),
              RadioGroup<String>(
                groupValue: category,
                onChanged: (String? v) {
                  if (v != null) {
                    _category.value = v;
                  }
                },
                child: Column(
                  children: const <Widget>[
                    RadioListTile<String>(
                      title: Text('垃圾广告 / 营销骚扰'),
                      value: 'spam',
                    ),
                    RadioListTile<String>(
                      title: Text('色情低俗 / 违规内容'),
                      value: 'nsfw',
                    ),
                    RadioListTile<String>(
                      title: Text('欺诈钓鱼 / 冒充他人'),
                      value: 'fraud',
                    ),
                    RadioListTile<String>(
                      title: Text('人身攻击 / 违法违规'),
                      value: 'harassment',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: '补充说明（选填）'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: submitting ? null : _submit,
                child: Text(submitting ? '提交中...' : '提交投诉'),
              ),
            ],
          );
        },
      ),
    );
  }
}
