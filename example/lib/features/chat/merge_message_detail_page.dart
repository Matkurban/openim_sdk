import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../core/utils/date_time_formatter.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 合并转发聊天记录详情页（支持嵌套合并消息继续下钻与媒体点击预览）。
///
/// Merged-forward chat history detail page supporting nested drill-down.
class MergeMessageDetailPage extends StatelessWidget {
  /// 合并消息元素。
  final MergeElem? mergeElem;

  /// 会话 ID（用于嵌套合并消息继续跳转）。
  final String conversationId;

  /// 创建合并转发详情页。
  const MergeMessageDetailPage({
    super.key,
    required this.mergeElem,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final List<Message> items = mergeElem?.multiMessage ?? const <Message>[];
    return Scaffold(
      appBar: AppBar(title: Text(mergeElem?.title ?? '聊天记录')),
      body: ListView.separated(
        padding: const EdgeInsets.all(14),
        itemCount: items.length,
        separatorBuilder: (BuildContext _, int _) => const Divider(height: 18),
        itemBuilder: (BuildContext _, int index) {
          final Message msg = items[index];
          return InkWell(
            onTap: () {
              if (msg.contentType == MessageType.merger &&
                  msg.mergeElem != null) {
                router.pushNamed(
                  AppRoutes.mergeMessageDetail(conversationId),
                  arguments: msg.mergeElem,
                );
              } else if (msg.contentType == MessageType.picture) {
                final String url = msg.pictureElem?.sourcePicture?.url ?? '';
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CachedAvatar(
                  imageUrl: msg.senderFaceUrl,
                  fallbackName: msg.senderNickname ?? msg.sendID,
                  size: 38,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            msg.senderNickname ?? msg.sendID ?? '',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const Spacer(),
                          Text(
                            DateTimeFormatter.formatFullDateTime(msg.sendTime),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        msg.textElem?.content ??
                            msg.quoteElem?.text ??
                            msg.fileElem?.fileName ??
                            '[${msg.contentType?.name ?? '消息'}]',
                      ),
                    ],
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
