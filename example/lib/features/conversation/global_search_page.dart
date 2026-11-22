import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 全局聚合搜索页（同时检索联系人、群聊、会话与本地聊天记录）。
///
/// Global aggregated search page querying friends, groups, conversations, and local messages.
class GlobalSearchPage extends StatefulWidget {
  /// 创建全局搜索页。
  const GlobalSearchPage({super.key});

  @override
  State<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  final TextEditingController _keywordController = TextEditingController();
  List<SearchFriendsInfo> _friends = <SearchFriendsInfo>[];
  List<GroupInfo> _groups = <GroupInfo>[];
  List<ConversationInfo> _conversations = <ConversationInfo>[];
  List<SearchResultItems> _messageGroups = <SearchResultItems>[];
  bool _searching = false;

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _search(String raw) async {
    final String keyword = raw.trim();
    if (keyword.isEmpty) {
      setState(() {
        _friends = <SearchFriendsInfo>[];
        _groups = <GroupInfo>[];
        _conversations = <ConversationInfo>[];
        _messageGroups = <SearchResultItems>[];
      });
      return;
    }
    setState(() {
      _searching = true;
    });
    try {
      final List<SearchFriendsInfo> friends = await OpenIM
          .iMManager
          .friendshipManager
          .searchFriends(
            keywordList: <String>[keyword],
            isSearchUserID: true,
            isSearchNickname: true,
            isSearchRemark: true,
          );
      final List<GroupInfo> groups = await OpenIM.iMManager.groupManager
          .searchGroups(
            keywordList: <String>[keyword],
            isSearchGroupID: true,
            isSearchGroupName: true,
          );
      final List<ConversationInfo> convs = await OpenIM
          .iMManager
          .conversationManager
          .searchConversations(keyword);
      final SearchResult msgResult = await OpenIM.iMManager.messageManager
          .searchLocalMessages(keywordList: <String>[keyword]);
      if (mounted) {
        setState(() {
          _friends = friends;
          _groups = groups;
          _conversations = convs;
          _messageGroups = msgResult.searchResultItems ?? <SearchResultItems>[];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _searching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _keywordController,
          autofocus: true,
          onChanged: _search,
          decoration: const InputDecoration(
            hintText: '搜索联系人、群聊、会话或消息...',
            isDense: true,
          ),
        ),
      ),
      body: _searching
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                if (_friends.isNotEmpty) ...<Widget>[
                  const _SearchSectionHeader(title: '联系人'),
                  for (final SearchFriendsInfo friend in _friends)
                    ListTile(
                      leading: CachedAvatar(
                        imageUrl: friend.faceURL,
                        fallbackName: friend.getShowName(),
                      ),
                      title: Text(friend.getShowName()),
                      subtitle: Text(friend.friendUserID ?? ''),
                      onTap: () => router.pushNamed(
                        AppRoutes.contactProfile(friend.friendUserID ?? ''),
                      ),
                    ),
                ],
                if (_groups.isNotEmpty) ...<Widget>[
                  const _SearchSectionHeader(title: '群聊'),
                  for (final GroupInfo group in _groups)
                    ListTile(
                      leading: CachedAvatar(
                        imageUrl: group.faceURL,
                        fallbackName: group.groupName,
                      ),
                      title: Text(group.groupName ?? group.groupID),
                      subtitle: Text('${group.memberCount ?? 0} 人'),
                      onTap: () async {
                        final ConversationInfo conv = await OpenIM
                            .iMManager
                            .conversationManager
                            .getOneConversation(
                              sourceID: group.groupID,
                              sessionType: ConversationType.superGroup.value,
                            );
                        if (context.mounted) {
                          await router.pushNamed(
                            AppRoutes.chat(conv.conversationID),
                            arguments: conv,
                          );
                        }
                      },
                    ),
                ],
                if (_conversations.isNotEmpty) ...<Widget>[
                  const _SearchSectionHeader(title: '相关会话'),
                  for (final ConversationInfo conv in _conversations)
                    ListTile(
                      leading: CachedAvatar(
                        imageUrl: conv.faceURL,
                        fallbackName: conv.showName,
                      ),
                      title: Text(conv.showName ?? conv.conversationID),
                      onTap: () => router.pushNamed(
                        AppRoutes.chat(conv.conversationID),
                        arguments: conv,
                      ),
                    ),
                ],
                if (_messageGroups.isNotEmpty) ...<Widget>[
                  const _SearchSectionHeader(title: '聊天记录'),
                  for (final SearchResultItems item in _messageGroups)
                    ListTile(
                      leading: CachedAvatar(
                        imageUrl: item.faceURL,
                        fallbackName: item.showName,
                      ),
                      title: Text(item.showName ?? item.conversationID ?? ''),
                      subtitle: Text('${item.messageCount ?? 0} 条相关聊天记录'),
                      onTap: () {
                        final String cid = item.conversationID ?? '';
                        if (cid.isNotEmpty) {
                          router.pushNamed(AppRoutes.chatSearch(cid));
                        }
                      },
                    ),
                ],
              ],
            ),
    );
  }
}

class _SearchSectionHeader extends StatelessWidget {
  final String title;

  const _SearchSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).hintColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
