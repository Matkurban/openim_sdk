import 'package:chat_context_menu/chat_context_menu.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_cache_manager/xue_hua_navite_cache_manager.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/cached_avatar.dart';

/// 仿微信朋友圈动态卡片（含头像、文本、九宫格图文/视频、点赞评论浮层与互动区）。
///
/// WeChat-style moment feed card widget.
class MomentCard extends StatelessWidget {
  /// 动态数据。
  final MomentInfo moment;

  /// 点赞/取消点赞回调。
  final VoidCallback onToggleLike;

  /// 点击评论回调。
  final VoidCallback onComment;

  /// 点击收藏回调。
  final VoidCallback onFavorite;

  /// 点击删除回调（仅本人动态显示）。
  final VoidCallback onDelete;

  /// 点击进入详情回调。
  final VoidCallback onOpenDetail;

  /// 创建动态卡片。
  const MomentCard({
    super.key,
    required this.moment,
    required this.onToggleLike,
    required this.onComment,
    required this.onFavorite,
    required this.onDelete,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final ThemeData theme = Theme.of(context);
    final String selfId = OpenIM.iMManager.userID;
    final bool isSelf = moment.userID == selfId;
    final bool liked = moment.likes.any(
      (MomentLikeWithUser l) => l.userID == selfId,
    );
    final String authorName = moment.userID;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () =>
                router.pushNamed(AppRoutes.contactProfile(moment.userID)),
            child: CachedAvatar(fallbackName: authorName, size: 42),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  authorName,
                  style: const TextStyle(
                    color: AppColors.linkBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (moment.content.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onOpenDetail,
                    child: Text(
                      moment.content,
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
                if (moment.media.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  _MomentMediaGrid(mediaList: moment.media),
                ],
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Text(
                      moment.createTime,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    if (isSelf) ...<Widget>[
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: onDelete,
                        child: const Text(
                          '删除',
                          style: TextStyle(
                            color: AppColors.linkBlue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    ChatContextMenuWrapper(
                      barrierColor: Colors.transparent,
                      widgetBuilder:
                          (
                            BuildContext _,
                            VoidCallback showMenu,
                            VoidCallback _,
                          ) {
                            return InkWell(
                              onTap: showMenu,
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.more_horiz, size: 18),
                              ),
                            );
                          },
                      menuBuilder: (BuildContext _, VoidCallback hideMenu) {
                        return Material(
                          color: const Color(0xFF3A3A3C),
                          borderRadius: BorderRadius.circular(8),
                          elevation: 6,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextButton.icon(
                                onPressed: () {
                                  hideMenu();
                                  onToggleLike();
                                },
                                icon: Icon(
                                  liked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16,
                                  color: liked
                                      ? AppColors.danger
                                      : Colors.white,
                                ),
                                label: Text(
                                  liked ? '取消' : '赞',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  hideMenu();
                                  onComment();
                                },
                                icon: const Icon(
                                  Icons.mode_comment_outlined,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  '评论',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  hideMenu();
                                  onFavorite();
                                },
                                icon: const Icon(
                                  Icons.star_border,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  '收藏',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                if (moment.likes.isNotEmpty ||
                    moment.comments.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (moment.likes.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.favorite_border,
                                  size: 14,
                                  color: AppColors.linkBlue,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  moment.likes
                                      .map(
                                        (MomentLikeWithUser l) =>
                                            l.userInfo?.nickname ?? l.userID,
                                      )
                                      .join('，'),
                                  style: const TextStyle(
                                    color: AppColors.linkBlue,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (moment.likes.isNotEmpty &&
                            moment.comments.isNotEmpty)
                          const Divider(height: 10),
                        for (final MomentCommentWithUser c in moment.comments)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: c.userInfo?.nickname ?? c.userID,
                                    style: const TextStyle(
                                      color: AppColors.linkBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (c
                                      .replyToUserID
                                      .isNotEmpty) ...<InlineSpan>[
                                    const TextSpan(text: ' 回复 '),
                                    TextSpan(
                                      text:
                                          c.replyToUser?.nickname ??
                                          c.replyToUserID,
                                      style: const TextStyle(
                                        color: AppColors.linkBlue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                  TextSpan(text: '：${c.content}'),
                                ],
                              ),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MomentMediaGrid extends StatelessWidget {
  final List<MomentMedia> mediaList;

  const _MomentMediaGrid({required this.mediaList});

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final List<String> imageUrls = mediaList
        .where((MomentMedia m) => m.type != 'video' && m.url.isNotEmpty)
        .map((MomentMedia m) => m.url)
        .toList();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: <Widget>[
        for (int i = 0; i < mediaList.length; i++)
          GestureDetector(
            onTap: () {
              final MomentMedia media = mediaList[i];
              if (media.type == 'video' && media.url.isNotEmpty) {
                router.pushNamed(
                  AppRoutes.videoPreview,
                  arguments: <String, String?>{
                    'url': media.url,
                    'title': '动态视频',
                  },
                );
              } else if (imageUrls.isNotEmpty) {
                router.pushNamed(
                  AppRoutes.imagePreview,
                  arguments: <String, Object>{
                    'urls': imageUrls,
                    'index': imageUrls
                        .indexOf(media.url)
                        .clamp(0, imageUrls.length - 1),
                  },
                );
              }
            },
            child: SizedBox(
              width: mediaList.length == 1 ? 180 : 88,
              height: mediaList.length == 1 ? 140 : 88,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: mediaList[i].coverUrl ?? mediaList[i].url,
                    tag: 'moments_media',
                    memCacheWidth: 260,
                    borderRadius: BorderRadius.circular(4),
                    fit: BoxFit.cover,
                    errorBuilder:
                        (BuildContext _, String _, Object _, StackTrace? _) =>
                            const ColoredBox(
                              color: Colors.black12,
                              child: Icon(Icons.image_outlined),
                            ),
                  ),
                  if (mediaList[i].type == 'video')
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
            ),
          ),
      ],
    );
  }
}
