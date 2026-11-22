import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';
import 'package:xue_hua_navite_share/xue_hua_navite_share.dart';
import 'package:xue_hua_qr_code/xue_hua_qr_code.dart';

import '../../core/services/auth_session_service.dart';
import '../../core/utils/qr_payload_codec.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 我的二维码名片页（基于 `xue_hua_qr_code` 与 `xue_hua_navite_share`）。
///
/// Personal QR code card page powered by `xue_hua_qr_code` and `xue_hua_navite_share`.
class MyQrCodePage extends StatelessWidget {
  /// 创建我的二维码页。
  const MyQrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserInfo? self = Wire.find<AuthSessionService>().currentUser.value;
    final String uid = self?.userID ?? OpenIM.iMManager.userID;
    final String name = self?.nickname ?? uid;
    final String payload = QrPayloadCodec.encodeUser(uid);

    return Scaffold(
      appBar: AppBar(title: const Text('我的二维码')),
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
                      imageUrl: self?.faceURL,
                      fallbackName: name,
                      size: 52,
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
                          'ID: $uid',
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
                const Text('扫一扫上面的二维码，加我为好友'),
                const SizedBox(height: 18),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    OutlinedButton.icon(
                      onPressed: () async {
                        await XueHuaNaviteClipboard.instance.writeText(uid);
                        await FlutterToastPro.success('已复制我的 ID');
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('复制 ID'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: () async {
                        await XueHuaNaviteShare.instance.shareText(
                          '这是我的 OpenIM 名片：$payload',
                          subject: '我的名片',
                        );
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('分享名片'),
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
