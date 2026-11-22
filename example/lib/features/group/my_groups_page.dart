import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/empty_state_view.dart';

/// 我的群聊列表页（按「我创建的群 / 我加入的群」分组，支持搜索与点击进群聊）。
///
/// My groups page grouped by owned vs. joined groups.
class MyGroupsPage extends StatefulWidget {
  /// 创建我的群聊页。
  const MyGroupsPage({super.key});

  @override
  State<MyGroupsPage> createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {
  List<GroupInfo> _all = <GroupInfo>[];
  String _keyword = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<GroupInfo> list = await OpenIM.iMManager.groupManager
        .getJoinedGroupList();
    if (mounted) {
      setState(() {
        _all = list;
        _loading = false;
      });
    }
  }

  Future<void> _openGroupChat(GroupInfo group) async {
    final ConversationInfo conv = await OpenIM.iMManager.conversationManager
        .getOneConversation(
          sourceID: group.groupID,
          sessionType: ConversationType.superGroup.value,
        );
    if (mounted) {
      await AdaptiveRouter.of(context)
          .pushNamed(AppRoutes.chat(conv.conversationID), arguments: conv);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String selfID = OpenIM.iMManager.userID;
    final List<GroupInfo> filtered = _keyword.isEmpty
        ? _all
        : _all
              .where(
                (GroupInfo g) =>
                    (g.groupName ?? '').toLowerCase().contains(
                      _keyword.toLowerCase(),
                    ) ||
                    g.groupID.contains(_keyword),
              )
              .toList();
    final List<GroupInfo> created = filtered
        .where((GroupInfo g) => g.ownerUserID == selfID)
        .toList();
    final List<GroupInfo> joined = filtered
        .where((GroupInfo g) => g.ownerUserID != selfID)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的群聊'),
        actions: <Widget>[
          IconButton(
            tooltip: '创建群聊',
            icon: const Icon(Icons.group_add_outlined),
            onPressed: () =>
                AdaptiveRouter.of(context).pushNamed(AppRoutes.createGroup),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (String v) => setState(() => _keyword = v.trim()),
              decoration: const InputDecoration(
                hintText: '搜索群名称或群 ID',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                ? const EmptyStateView(title: '暂未加入任何群聊')
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView(
                      children: <Widget>[
                        if (created.isNotEmpty) ...<Widget>[
                          _GroupSectionTitle(
                            title: '我创建的群聊（${created.length}）',
                          ),
                          for (final GroupInfo g in created)
                            _GroupItemTile(
                              group: g,
                              onTap: () => _openGroupChat(g),
                            ),
                        ],
                        if (joined.isNotEmpty) ...<Widget>[
                          _GroupSectionTitle(title: '我加入的群聊（${joined.length}）'),
                          for (final GroupInfo g in joined)
                            _GroupItemTile(
                              group: g,
                              onTap: () => _openGroupChat(g),
                            ),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _GroupSectionTitle extends StatelessWidget {
  final String title;

  const _GroupSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: Theme.of(context).hintColor),
      ),
    );
  }
}

class _GroupItemTile extends StatelessWidget {
  final GroupInfo group;
  final VoidCallback onTap;

  const _GroupItemTile({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedAvatar(
        imageUrl: group.faceURL,
        fallbackName: group.groupName,
      ),
      title: Text(group.groupName ?? group.groupID),
      subtitle: Text('${group.memberCount ?? 0} 人'),
      onTap: onTap,
    );
  }
}
