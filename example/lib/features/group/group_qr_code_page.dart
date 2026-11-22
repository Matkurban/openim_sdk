import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';
import 'package:xue_hua_navite_share/xue_hua_navite_share.dart';
import 'package:xue_hua_qr_code/xue_hua_qr_code.dart';

import '../../core/utils/qr_payload_codec.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 群二维码名片页（基于 `xue_hua_qr_code` 与 `xue_hua_navite_share`）。
///
/// Group QR code card page powered by `xue_hua_qr_code` and `xue_hua_navite_share`.
class GroupQrCodePage extends StatelessWidget {
  /// 群信息。
  final GroupInfo? group;

  /// 创建群二维码页。
  const GroupQrCodePage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final String gid = group?.groupID ?? '';
    final String name = group?.groupName ?? gid;
    final String payload = QrPayloadCodec.encodeGroup(gid);

    return Scaffold(
      appBar: AppBar(title: const Text('群二维码')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CachedAvatar(
                      imageUrl: group?.faceURL,
                      fallbackName: name,
                      size: 48,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '群 ID: $gid',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                XueHuaQrCode(
                  value: payload,
                  size: 220,
                  errorBuilder: (BuildContext _, Object _, StackTrace? _) =>
                      const Icon(Icons.error_outline, size: 64),
                ),
                const SizedBox(height: 16),
                const Text('使用 OpenIM 扫一扫加入该群聊'),
                const SizedBox(height: 18),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    OutlinedButton.icon(
                      onPressed: () async {
                        await XueHuaNaviteClipboard.instance.writeText(gid);
                        await FlutterToastPro.success('已复制群 ID');
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('复制群 ID'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () async {
                        await XueHuaNaviteShare.instance.shareText(
                          '邀请你加入群聊「$name」，群链接：$payload',
                          subject: '群聊邀请',
                        );
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('分享给好友'),
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
