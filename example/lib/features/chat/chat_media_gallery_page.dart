import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_cache_manager/xue_hua_navite_cache_manager.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/empty_state_view.dart';

/// 会话图片与视频网格画廊页。
///
/// Conversation media gallery page showing all images and videos in a grid.
class ChatMediaGalleryPage extends StatefulWidget {
  /// 会话 ID。
  final String conversationId;

  /// 创建媒体画廊页。
  const ChatMediaGalleryPage({super.key, required this.conversationId});

  @override
  State<ChatMediaGalleryPage> createState() => _ChatMediaGalleryPageState();
}

class _ChatMediaGalleryPageState extends State<ChatMediaGalleryPage> {
  List<Message> _mediaMessages = <Message>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final SearchResult res = await OpenIM.iMManager.messageManager
          .searchLocalMessages(
            conversationID: widget.conversationId,
            messageTypeList: <int>[
              MessageType.picture.value,
              MessageType.video.value,
            ],
            count: 200,
          );
      final List<Message> list = <Message>[];
      for (final SearchResultItems item
          in res.searchResultItems ?? const <SearchResultItems>[]) {
        list.addAll(item.messageList ?? const <Message>[]);
      }
      if (mounted) {
        setState(() => _mediaMessages = list);
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('图片与视频')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _mediaMessages.isEmpty
          ? const EmptyStateView(title: '该会话暂无图片或视频')
          : GridView.builder(
              padding: const EdgeInsets.all(4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: _mediaMessages.length,
              itemBuilder: (BuildContext _, int index) {
                final Message msg = _mediaMessages[index];
                final bool isVideo = msg.contentType == MessageType.video;
                final String thumbUrl = isVideo
                    ? (msg.videoElem?.snapshotUrl ?? '')
                    : (msg.pictureElem?.snapshotPicture?.url ??
                          msg.pictureElem?.sourcePicture?.url ??
                          '');
                return InkWell(
                  onTap: () {
                    if (isVideo) {
                      final String url = msg.videoElem?.videoUrl ?? '';
                      if (url.isNotEmpty) {
                        router.pushNamed(
                          AppRoutes.videoPreview,
                          arguments: <String, String?>{'url': url},
                        );
                      }
                    } else {
                      final String url =
                          msg.pictureElem?.sourcePicture?.url ?? thumbUrl;
                      if (url.isNotEmpty) {
                        router.pushNamed(
                          AppRoutes.imagePreview,
                          arguments: <String, Object>{
                            'urls': <String>[url],
                            'index': 0,
                          },
                        );
                      }
                    }
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (thumbUrl.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: thumbUrl,
                          tag: 'gallery_thumbs',
                          memCacheWidth: 240,
                          fit: BoxFit.cover,
                          errorBuilder: (
                            BuildContext _,
                            String _,
                            Object _,
                            StackTrace? _,
                          ) => const ColoredBox(color: Colors.black12),
                        )
                      else
                        const ColoredBox(
                          color: Colors.black12,
                          child: Icon(Icons.image_outlined),
                        ),
                      if (isVideo)
                        const Center(
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black54,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
