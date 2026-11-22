import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../shared/widgets/cached_avatar.dart';
import 'widgets/moment_card.dart';

/// 朋友圈动态详情页（完整点赞、楼层评论回复、删除与收藏）。
///
/// Moment detail page with full likes, threaded comment replies, delete, and favorite.
class MomentDetailPage extends StatefulWidget {
  /// 动态 ID。
  final String momentId;

  /// 初始动态对象。
  final MomentInfo? initialMoment;

  /// 创建动态详情页。
  const MomentDetailPage({
    super.key,
    required this.momentId,
    this.initialMoment,
  });

  @override
  State<MomentDetailPage> createState() => _MomentDetailPageState();
}

class _MomentDetailPageState extends State<MomentDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  MomentInfo? _moment;
  String? _replyUserID;
  String? _replyNickname;

  @override
  void initState() {
    super.initState();
    _moment = widget.initialMoment;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final MomentInfo? moment = _moment;
    final String text = _commentController.text.trim();
    if (moment == null || text.isEmpty) {
      return;
    }
    try {
      await OpenIM.iMManager.momentsManager.commentMoment(
        momentID: moment.momentID,
        content: text,
        replyToUserID: _replyUserID,
        ownerUserID: moment.userID,
      );
      _commentController.clear();
      setState(() {
        _replyUserID = null;
        _replyNickname = null;
      });
      await FlutterToastPro.success('评论已发送');
    } on Object catch (error) {
      await FlutterToastPro.error('评论失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final MomentInfo? moment = _moment;
    if (moment == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('动态详情')),
        body: const Center(child: Text('动态不存在或已被删除')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('动态详情')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                MomentCard(
                  moment: moment,
                  onToggleLike: () async {
                    await OpenIM.iMManager.momentsManager.likeMoment(
                      momentID: moment.momentID,
                      ownerUserID: moment.userID,
                    );
                  },
                  onComment: () {},
                  onFavorite: () async {
                    await OpenIM.iMManager.favoriteManager.addMoment(
                      moment: moment,
                    );
                    await FlutterToastPro.success('已收藏动态');
                  },
                  onDelete: () async {
                    await OpenIM.iMManager.momentsManager.deleteMoment(
                      momentID: moment.momentID,
                    );
                    if (context.mounted) {
                      AdaptiveRouter.of(context).pop();
                    }
                  },
                  onOpenDetail: () {},
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text('全部评论 (${moment.comments.length})'),
                ),
                for (final MomentCommentWithUser c in moment.comments)
                  ListTile(
                    leading: CachedAvatar(
                      imageUrl: c.userInfo?.faceURL,
                      fallbackName: c.userInfo?.nickname ?? c.userID,
                      size: 36,
                    ),
                    title: Text(c.userInfo?.nickname ?? c.userID),
                    subtitle: Text(c.content),
                    onTap: () {
                      setState(() {
                        _replyUserID = c.userID;
                        _replyNickname = c.userInfo?.nickname ?? c.userID;
                      });
                    },
                    trailing: c.userID == OpenIM.iMManager.userID
                        ? IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () async {
                              await OpenIM.iMManager.momentsManager
                                  .deleteComment(
                                    commentID: c.commentID,
                                    momentID: moment.momentID,
                                  );
                              await FlutterToastPro.success('已删除评论');
                            },
                          )
                        : null,
                  ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: _replyNickname != null
                            ? '回复 $_replyNickname...'
                            : '写一条评论...',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _sendComment,
                    child: const Text('发送'),
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
