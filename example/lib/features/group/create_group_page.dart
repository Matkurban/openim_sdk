import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/contact_picker_page.dart';

/// 发起群聊页（选择好友、填写群名称后创建群并进入群聊）。
///
/// Create-group page selecting friends and launching the new group chat.
class CreateGroupPage extends StatefulWidget {
  /// 预选好友 ID 列表（如从私聊详情发起群聊）。
  final List<String> initialMemberIDs;

  /// 创建发起群聊页。
  const CreateGroupPage({super.key, this.initialMemberIDs = const <String>[]});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _nameController = TextEditingController();
  late final Signal<List<FriendInfo>> _selected = signal<List<FriendInfo>>(
    <FriendInfo>[],
  );
  late final Signal<bool> _creating = signal<bool>(false);

  @override
  void initState() {
    super.initState();
    if (widget.initialMemberIDs.isNotEmpty) {
      _preloadInitial();
    }
  }

  Future<void> _preloadInitial() async {
    final List<FriendInfo> infos = await OpenIM.iMManager.friendshipManager
        .getFriendsInfo(userIDList: widget.initialMemberIDs);
    if (mounted) {
      _selected.value = infos;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickMembers() async {
    final List<FriendInfo>? picked = await ContactPickerPage.pick(
      context,
      title: '选择群成员',
      multiSelect: true,
    );
    if (picked != null && mounted) {
      _selected.value = picked;
    }
  }

  Future<void> _create() async {
    final List<FriendInfo> selected = _selected.value;
    if (selected.isEmpty) {
      await FlutterToastPro.warning('请至少选择 1 位好友');
      return;
    }
    final String groupName = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : selected.take(3).map((FriendInfo f) => f.getShowName()).join('、');
    _creating.value = true;
    try {
      final GroupInfo created = await OpenIM.iMManager.groupManager.createGroup(
        groupInfo: GroupInfo(groupID: '', groupName: groupName),
        memberUserIDs: selected
            .map((FriendInfo f) => f.friendUserID ?? '')
            .where((String id) => id.isNotEmpty)
            .toList(),
      );
      final ConversationInfo conv = await OpenIM.iMManager.conversationManager
          .getOneConversation(
            sourceID: created.groupID,
            sessionType: ConversationType.superGroup.value,
          );
      await FlutterToastPro.success('群聊创建成功');
      if (mounted) {
        await AdaptiveRouter.of(context).pushReplacementNamed(
          AppRoutes.chat(conv.conversationID),
          arguments: conv,
        );
      }
    } on Object catch (error) {
      await FlutterToastPro.error('创建群聊失败：$error');
    } finally {
      if (mounted) {
        _creating.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext _) {
        final List<FriendInfo> selected = _selected.value;
        final bool creating = _creating.value;
        return Scaffold(
          appBar: AppBar(
            title: const Text('创建群聊'),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilledButton(
                  onPressed: creating ? null : _create,
                  child: Text(creating ? '创建中...' : '创建(${selected.length})'),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '群名称（留空则自动以成员昵称命名）',
                  prefixIcon: Icon(Icons.group_outlined),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                tileColor: Theme.of(context).colorScheme.surface,
                leading: const Icon(Icons.person_add_outlined),
                title: Text('已选成员（${selected.length} 人）'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _pickMembers,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  for (final FriendInfo friend in selected)
                    Chip(
                      avatar: CachedAvatar(
                        imageUrl: friend.faceURL,
                        fallbackName: friend.getShowName(),
                        size: 24,
                        borderRadius: 12,
                      ),
                      label: Text(friend.getShowName()),
                      onDeleted: () {
                        _selected.value = selected
                            .where(
                              (FriendInfo f) =>
                                  f.friendUserID != friend.friendUserID,
                            )
                            .toList();
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
