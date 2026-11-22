import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 加入群聊页（搜索群 ID/名称并提交入群申请）。
///
/// Join-group page searching groups by ID and submitting join applications.
class JoinGroupPage extends StatefulWidget {
  /// 预填群 ID（如扫码跳转）。
  final String? initialGroupId;

  /// 创建加入群聊页。
  const JoinGroupPage({super.key, this.initialGroupId});

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  late final TextEditingController _groupIdController;
  final TextEditingController _reasonController = TextEditingController();
  GroupInfo? _foundGroup;
  bool _searching = false;
  bool _joining = false;

  @override
  void initState() {
    super.initState();
    _groupIdController = TextEditingController(
      text: widget.initialGroupId ?? '',
    );
    if ((widget.initialGroupId ?? '').isNotEmpty) {
      _search();
    }
  }

  @override
  void dispose() {
    _groupIdController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final String gid = _groupIdController.text.trim();
    if (gid.isEmpty) {
      return;
    }
    setState(() {
      _searching = true;
    });
    try {
      final List<GroupInfo> infos = await OpenIM.iMManager.groupManager
          .getGroupsInfo(groupIDList: <String>[gid]);
      if (mounted) {
        setState(() {
          _foundGroup = infos.isNotEmpty ? infos.first : null;
        });
      }
      if (infos.isEmpty) {
        await FlutterToastPro.info('未找到该群聊，请确认群 ID');
      }
    } on Object catch (error) {
      await FlutterToastPro.error('查询失败：$error');
    } finally {
      if (mounted) {
        setState(() {
          _searching = false;
        });
      }
    }
  }

  Future<void> _join() async {
    final GroupInfo? group = _foundGroup;
    if (group == null) {
      return;
    }
    setState(() {
      _joining = true;
    });
    try {
      final bool joined = await OpenIM.iMManager.groupManager.isJoinedGroup(
        groupID: group.groupID,
      );
      if (joined) {
        final ConversationInfo conv = await OpenIM.iMManager.conversationManager
            .getOneConversation(
              sourceID: group.groupID,
              sessionType: ConversationType.superGroup.value,
            );
        if (mounted) {
          await AdaptiveRouter.of(context).pushReplacementNamed(
            AppRoutes.chat(conv.conversationID),
            arguments: conv,
          );
        }
        return;
      }
      await OpenIM.iMManager.groupManager.joinGroup(
        groupID: group.groupID,
        reason: _reasonController.text.trim(),
        joinSource: JoinSource.search.value,
      );
      await FlutterToastPro.success('入群申请已提交');
      if (mounted) {
        AdaptiveRouter.of(context).pop();
      }
    } on Object catch (error) {
      await FlutterToastPro.error('加入失败：$error');
    } finally {
      if (mounted) {
        setState(() {
          _joining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('加入群聊')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _groupIdController,
                  onSubmitted: (String _) => _search(),
                  decoration: const InputDecoration(
                    labelText: '输入群 ID',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: _searching ? null : _search,
                child: const Text('查找'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_foundGroup != null) ...<Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CachedAvatar(
                          imageUrl: _foundGroup!.faceURL,
                          fallbackName: _foundGroup!.groupName,
                          size: 54,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _foundGroup!.groupName ?? _foundGroup!.groupID,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '群 ID: ${_foundGroup!.groupID} · ${_foundGroup!.memberCount ?? 0} 人',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _reasonController,
                      decoration: const InputDecoration(
                        labelText: '验证申请理由（选填）',
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _joining ? null : _join,
                      child: Text(_joining ? '提交中...' : '申请加入该群'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
