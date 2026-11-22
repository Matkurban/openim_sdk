import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../core/events/im_social_event.dart';
import '../../core/services/auth_session_service.dart';
import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/empty_state_view.dart';
import 'moments_controller.dart';
import 'widgets/moment_card.dart';

/// Tab 3：朋友圈主页（顶部封面与个人头像、未读互动消息提醒条、动态流与点赞评论浮层）。
///
/// Tab 3: WeChat-style Moments feed page.
class MomentsPage extends WireView<MomentsController> {
  /// 创建朋友圈主页。
  const MomentsPage({super.key});

  @override
  MomentsController? wire() => MomentsController();

  Future<void> _showCommentDialog(
    BuildContext context,
    MomentInfo moment,
  ) async {
    final TextEditingController textCtrl = TextEditingController();
    final String? text = await showDialog<String>(
      context: context,
      useRootNavigator: AdaptivePaneScope.maybeOf(context) != null,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('发表评论'),
        content: TextField(
          controller: textCtrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: '说点什么...'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => AdaptiveRouter.of(ctx).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => AdaptiveRouter.of(ctx).pop(textCtrl.text.trim()),
            child: const Text('发送'),
          ),
        ],
      ),
    );
    textCtrl.dispose();
    if (text != null && text.isNotEmpty) {
      await controller.addComment(moment: moment, content: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final AuthSessionService auth = Wire.find<AuthSessionService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('朋友圈'),
        actions: <Widget>[
          IconButton(
            tooltip: '发布动态',
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () async {
              await router.pushNamedAndRemoveUntil(
                AppRoutes.momentPublish,
                (AdaptiveRouteMatch _) => false,
              );
              await controller.loadMoments(fromServer: true);
            },
          ),
        ],
      ),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final UserInfo? self = auth.currentUser.value;
          final List<MomentInfo> list = controller.moments.value;
          final List<ImSocialEvent> unreadEvents =
              controller.notifications.value;

          return RefreshIndicator(
            onRefresh: () => controller.loadMoments(fromServer: true),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _MomentsCoverHeader(
                    nickname: self?.nickname ?? OpenIM.iMManager.userID,
                    avatarUrl: self?.faceURL,
                    onTapAvatar: () => router.pushNamedAndRemoveUntil(
                      AppRoutes.userMoments(OpenIM.iMManager.userID),
                      (AdaptiveRouteMatch _) => false,
                    ),
                  ),
                ),
                if (unreadEvents.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 4),
                        child: ActionChip(
                          avatar: const Icon(Icons.notifications, size: 16),
                          label: Text('${unreadEvents.length} 条新互动消息'),
                          onPressed: () {
                            router.pushNamedAndRemoveUntil(
                              AppRoutes.momentNotifications,
                              (AdaptiveRouteMatch _) => false,
                              arguments: unreadEvents,
                            );
                            controller.clearNotifications();
                          },
                        ),
                      ),
                    ),
                  ),
                if (controller.loading.value)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (list.isEmpty)
                  SliverFillRemaining(
                    child: EmptyStateView(
                      title: '朋友圈还没有动态',
                      subtitle: '点击右上角相机图标发布第一条图文或视频动态',
                      actionLabel: '发布动态',
                      onAction: () => router.pushNamedAndRemoveUntil(
                        AppRoutes.momentPublish,
                        (AdaptiveRouteMatch _) => false,
                      ),
                    ),
                  )
                else
                  SliverList.separated(
                    itemCount: list.length,
                    separatorBuilder: (BuildContext _, int _) =>
                        const Divider(height: 1),
                    itemBuilder: (BuildContext _, int index) {
                      final MomentInfo item = list[index];
                      return MomentCard(
                        moment: item,
                        onToggleLike: () => controller.toggleLike(item),
                        onComment: () => _showCommentDialog(context, item),
                        onFavorite: () => controller.favoriteMoment(item),
                        onDelete: () => controller.deleteMoment(item.momentID),
                        onOpenDetail: () => router.pushNamedAndRemoveUntil(
                          AppRoutes.momentDetail(item.momentID),
                          (AdaptiveRouteMatch _) => false,
                          arguments: item,
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MomentsCoverHeader extends StatelessWidget {
  final String nickname;
  final String? avatarUrl;
  final VoidCallback onTapAvatar;

  const _MomentsCoverHeader({
    required this.nickname,
    required this.avatarUrl,
    required this.onTapAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            bottom: 24,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFF1F3B4D), Color(0xFF07C160)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 4,
            child: GestureDetector(
              onTap: onTapAvatar,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, right: 12),
                    child: Text(
                      nickname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        shadows: <Shadow>[
                          Shadow(color: Colors.black54, blurRadius: 4),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedAvatar(
                      imageUrl: avatarUrl,
                      fallbackName: nickname,
                      size: 62,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
