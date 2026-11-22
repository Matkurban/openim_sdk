import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';
import 'package:xue_hua_navite_share/xue_hua_navite_share.dart';

import '../../core/utils/date_time_formatter.dart';

/// 收藏条目详情预览页（支持复制与系统外部分享）。
///
/// Favorite item detail preview page with clipboard copy and OS share.
class FavoriteDetailPage extends StatelessWidget {
  /// 收藏条目。
  final FavoriteItem? item;

  /// 创建收藏详情页。
  const FavoriteDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final FavoriteItem? fav = item;
    if (fav == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('收藏详情')),
        body: const Center(child: Text('未找到收藏内容')),
      );
    }
    final String title = fav.linkInfo?.title ?? fav.favoriteType.name;
    final String bodyText =
        fav.noteInfo?.content ??
        fav.linkInfo?.description ??
        fav.message?.textElem?.content ??
        fav.momentInfo?.content ??
        fav.data;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            tooltip: '复制内容',
            icon: const Icon(Icons.copy_outlined),
            onPressed: () async {
              await XueHuaNaviteClipboard.instance.writeText(bodyText);
              await FlutterToastPro.success('已复制到剪切板');
            },
          ),
          IconButton(
            tooltip: '外部分享',
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              await XueHuaNaviteShare.instance.shareText(
                bodyText,
                subject: title,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '类型：${fav.favoriteType.name} · 收藏时间：${DateTimeFormatter.formatFullDateTime(fav.createTime)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Divider(height: 24),
          Text(
            bodyText.isEmpty ? '（无正文内容）' : bodyText,
            style: const TextStyle(fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }
}
