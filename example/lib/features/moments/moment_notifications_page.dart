import 'package:material_ui/material_ui.dart';

import '../../core/events/im_social_event.dart';
import '../../shared/widgets/empty_state_view.dart';

/// 朋友圈未读互动消息通知页（点赞与评论提醒列表）。
///
/// Moments likes & comments notification feed page.
class MomentNotificationsPage extends StatelessWidget {
  /// 互动事件列表。
  final List<ImSocialEvent> events;

  /// 创建朋友圈互动消息页。
  const MomentNotificationsPage({
    super.key,
    this.events = const <ImSocialEvent>[],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('朋友圈消息')),
      body: events.isEmpty
          ? const EmptyStateView(title: '暂无新的互动消息')
          : ListView.separated(
              itemCount: events.length,
              separatorBuilder: (BuildContext _, int _) =>
                  const Divider(height: 1),
              itemBuilder: (BuildContext _, int index) {
                final ImSocialEvent e = events[index];
                final bool isLike = e.kind == 'momentLiked';
                return ListTile(
                  leading: Icon(
                    isLike ? Icons.favorite : Icons.mode_comment_outlined,
                    color: isLike ? Colors.red : Colors.blue,
                  ),
                  title: Text(
                    isLike
                        ? '${e.momentLike?.userInfo?.nickname ?? e.momentLike?.userID ?? '好友'} 赞了你的动态'
                        : '${e.momentComment?.userInfo?.nickname ?? e.momentComment?.userID ?? '好友'} 评论了你',
                  ),
                  subtitle: Text(e.momentComment?.content ?? '点赞互动'),
                );
              },
            ),
    );
  }
}
