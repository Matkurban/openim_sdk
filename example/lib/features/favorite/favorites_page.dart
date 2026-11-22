import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../core/utils/date_time_formatter.dart';
import '../../shared/widgets/empty_state_view.dart';

/// 我的收藏中心页（支持分类筛选：全部 / 消息 / 朋友圈 / 笔记 / 链接，支持新建笔记/链接与删除）。
///
/// Favorites center page with category filtering, note/link creation, and item preview.
class FavoritesPage extends StatefulWidget {
  /// 创建我的收藏页。
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final Signal<List<FavoriteItem>> _items = signal<List<FavoriteItem>>(
    <FavoriteItem>[],
  );
  late final Signal<String> _filterType = signal<String>('all');
  late final Signal<bool> _loading = signal<bool>(true);

  @override
  void initState() {
    super.initState();
    _load(fromServer: true);
  }

  Future<void> _load({bool fromServer = false}) async {
    try {
      final FavoriteListResponse res = fromServer
          ? await OpenIM.iMManager.favoriteManager.fetchFavoriteListFromServer(
              pageNumber: 1,
              showNumber: 50,
            )
          : await OpenIM.iMManager.favoriteManager.getFavoriteList(
              pageNumber: 1,
              showNumber: 50,
            );
      if (mounted) {
        _items.value = res.favorites;
      }
    } finally {
      if (mounted) {
        _loading.value = false;
      }
    }
  }

  Future<void> _remove(FavoriteItem item) async {
    try {
      await OpenIM.iMManager.favoriteManager.removeFavoriteItem(item);
      await FlutterToastPro.success('已取消收藏');
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('删除失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        actions: <Widget>[
          IconButton(
            tooltip: '新建笔记 / 链接',
            icon: const Icon(Icons.add),
            onPressed: () async {
              await router.pushNamedAndRemoveUntil(
                AppRoutes.favoriteNoteEditor,
                (AdaptiveRouteMatch m) =>
                    m.matchedLocation == AppRoutes.favorites,
              );
              await _load(fromServer: true);
            },
          ),
        ],
      ),
      body: SignalBuilder(
        builder: (BuildContext _) {
          final String filterType = _filterType.value;
          final List<FavoriteItem> items = _items.value;
          final bool loading = _loading.value;
          final List<FavoriteItem> visible = filterType == 'all'
              ? items
              : items
                    .where(
                      (FavoriteItem i) => i.favoriteType.name == filterType,
                    )
                    .toList();

          return Column(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: <Widget>[
                    for (final (String key, String label)
                        in const <(String, String)>[
                          ('all', '全部'),
                          ('message', '消息'),
                          ('moment', '朋友圈'),
                          ('note', '笔记'),
                          ('link', '链接'),
                        ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: filterType == key,
                          onSelected: (bool _) => _filterType.value = key,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : visible.isEmpty
                    ? EmptyStateView(
                        title: '暂无收藏内容',
                        subtitle: '可在聊天消息、朋友圈长按收藏，或点击右上角新建笔记',
                        actionLabel: '新建笔记',
                        onAction: () => router.pushNamedAndRemoveUntil(
                          AppRoutes.favoriteNoteEditor,
                          (AdaptiveRouteMatch m) =>
                              m.matchedLocation == AppRoutes.favorites,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _load(fromServer: true),
                        child: ListView.separated(
                          itemCount: visible.length,
                          separatorBuilder: (BuildContext _, int _) =>
                              const Divider(height: 1),
                          itemBuilder: (BuildContext _, int index) {
                            final FavoriteItem item = visible[index];
                            final String title =
                                item.linkInfo?.title ?? item.favoriteType.name;
                            final String body =
                                item.noteInfo?.content ??
                                item.linkInfo?.description ??
                                item.message?.textElem?.content ??
                                item.momentInfo?.content ??
                                item.data;
                            return ListTile(
                              leading: Icon(switch (item.favoriteType) {
                                FavoriteType.note => Icons.note_outlined,
                                FavoriteType.link => Icons.link,
                                _ => Icons.chat_bubble_outline,
                              }),
                              title: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '$body · ${DateTimeFormatter.formatFullDateTime(item.createTime)}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                ),
                                onPressed: () => _remove(item),
                              ),
                              onTap: () => router.pushNamedAndRemoveUntil(
                                AppRoutes.favoriteDetail,
                                (AdaptiveRouteMatch m) =>
                                    m.matchedLocation == AppRoutes.favorites,
                                arguments: item,
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
