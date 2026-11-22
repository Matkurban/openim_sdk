import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';
import 'package:xue_hua_navite_share/xue_hua_navite_share.dart';

/// 位置消息详情预览页（展示地址描述与经纬度，支持复制与外部分享）。
///
/// Location message preview page with copy and OS share actions.
class LocationPreviewPage extends StatelessWidget {
  /// 位置描述。
  final String description;

  /// 纬度。
  final double latitude;

  /// 经度。
  final double longitude;

  /// 创建位置预览页。
  const LocationPreviewPage({
    super.key,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final String coords =
        '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
    return Scaffold(
      appBar: AppBar(title: const Text('位置详情')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.location_on, size: 64, color: Colors.red),
                const SizedBox(height: 14),
                Text(
                  description.isEmpty ? '分享的位置' : description,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '坐标：$coords',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    OutlinedButton.icon(
                      onPressed: () async {
                        await XueHuaNaviteClipboard.instance.writeText(
                          '$description ($coords)',
                        );
                        await FlutterToastPro.success('已复制位置信息');
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('复制坐标'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () async {
                        await XueHuaNaviteShare.instance.shareText(
                          '$description ($coords)',
                          subject: '位置分享',
                        );
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('外部分享'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
