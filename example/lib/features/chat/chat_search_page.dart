import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../core/utils/date_time_formatter.dart';
import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/empty_state_view.dart';

/// 单会话聊天记录搜索页（支持关键词搜索 + 按图片/视频/文件/语音类型筛选）。
///
/// Conversation-scoped local message search page with type filters.
class ChatSearchPage extends StatefulWidget {
  /// 会话 ID。
  final String conversationId;

  /// 创建单会话搜索页。
  const ChatSearchPage({super.key, required this.conversationId});

  @override
  State<ChatSearchPage> createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<ChatSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Message> _results = <Message>[];
  List<int> _typeFilter = const <int>[];
  bool _searching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final String kw = _controller.text.trim();
    if (kw.isEmpty && _typeFilter.isEmpty) {
      setState(() => _results = <Message>[]);
      return;
    }
    setState(() => _searching = true);
    try {
      final SearchResult res = await OpenIM.iMManager.messageManager
          .searchLocalMessages(
            conversationID: widget.conversationId,
            keywordList: kw.isNotEmpty ? <String>[kw] : const <String>[],
            messageTypeList: _typeFilter,
            count: 100,
          );
      final List<Message> msgs = <Message>[];
      for (final SearchResultItems item
          in res.searchResultItems ?? const <SearchResultItems>[]) {
        msgs.addAll(item.messageList ?? const <Message>[]);
      }
      if (mounted) {
        setState(() => _results = msgs);
      }
    } finally {
      if (mounted) {
        setState(() => _searching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onSubmitted: (String _) => _search(),
          decoration: const InputDecoration(
            hintText: '搜索聊天记录...',
            isDense: true,
          ),
        ),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.search), onPressed: _search),
        ],
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: <Widget>[
                for (final (String label, List<int> types)
                    in <(String, List<int>)>[
                      ('全部', const <int>[]),
                      (
                        '图片与视频',
                        <int>[
                          MessageType.picture.value,
                          MessageType.video.value,
                        ],
                      ),
                      ('文件', <int>[MessageType.file.value]),
                      ('语音', <int>[MessageType.voice.value]),
                    ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: _typeFilter.toString() == types.toString(),
                      onSelected: (bool _) {
                        setState(() => _typeFilter = types);
                        _search();
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _searching
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                ? const EmptyStateView(title: '未找到匹配的聊天记录')
                : ListView.separated(
                    itemCount: _results.length,
                    separatorBuilder: (BuildContext _, int _) =>
                        const Divider(height: 1, indent: 68),
                    itemBuilder: (BuildContext _, int index) {
                      final Message msg = _results[index];
                      return ListTile(
                        leading: CachedAvatar(
                          imageUrl: msg.senderFaceUrl,
                          fallbackName: msg.senderNickname ?? msg.sendID,
                        ),
                        title: Text(msg.senderNickname ?? msg.sendID ?? ''),
                        subtitle: Text(
                          msg.textElem?.content ??
                              msg.fileElem?.fileName ??
                              '[${msg.contentType?.name ?? '消息'}]',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          DateTimeFormatter.formatConversationTime(
                            msg.sendTime,
                          ),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        onTap: () {
                          if (msg.contentType == MessageType.picture) {
                            final String url =
                                msg.pictureElem?.sourcePicture?.url ?? '';
                            if (url.isNotEmpty) {
                              router.pushNamed(
                                AppRoutes.imagePreview,
                                arguments: <String, Object>{
                                  'urls': <String>[url],
                                  'index': 0,
                                },
                              );
                            }
                          } else if (msg.contentType == MessageType.file) {
                            router.pushNamed(
                              AppRoutes.filePreview,
                              arguments: <String, Object?>{
                                'fileName': msg.fileElem?.fileName ?? '文件',
                                'fileUrl': msg.fileElem?.sourceUrl ?? '',
                                'fileSize': msg.fileElem?.fileSize ?? 0,
                                'localPath': msg.fileElem?.filePath,
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
