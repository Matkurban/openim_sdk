import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../../app/router/app_routes.dart';

/// 合并转发消息气泡（点击进入 `MergeMessageDetailPage`）。
///
/// Merged-forward message bubble navigating to `MergeMessageDetailPage`.
class MergeMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 所属会话 ID。
  final String conversationId;

  /// 创建合并转发消息气泡。
  const MergeMessageBubble({
    super.key,
    required this.message,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    final MergeElem? elem = message.mergeElem;
    final List<String> summaries = elem?.abstractList ?? const <String>[];
    return InkWell(
      onTap: () => AdaptiveRouter.of(context).pushNamed(
        AppRoutes.mergeMessageDetail(conversationId),
        arguments: elem,
      ),
      child: SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              elem?.title ?? '聊天记录',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            for (final String line in summaries.take(4))
              Text(
                line,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const Divider(height: 12),
            Text(
              '聊天记录',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
