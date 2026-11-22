import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../../app/router/app_routes.dart';
import '../../../shared/widgets/cached_avatar.dart';

/// 个人名片消息气泡（点击进入 `ContactProfilePage`）。
///
/// Contact card message bubble navigating to `ContactProfilePage`.
class CardMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建名片消息气泡。
  const CardMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final CardElem? card = message.cardElem;
    final String uid = card?.userID ?? '';
    return InkWell(
      onTap: uid.isEmpty
          ? null
          : () =>
                AdaptiveRouter.of(context)
                    .pushNamed(AppRoutes.contactProfile(uid)),
      child: SizedBox(
        width: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                CachedAvatar(
                  imageUrl: card?.faceURL,
                  fallbackName: card?.nickname ?? uid,
                  size: 42,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    card?.nickname ?? uid,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const Divider(height: 14),
            Text(
              '个人名片',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
