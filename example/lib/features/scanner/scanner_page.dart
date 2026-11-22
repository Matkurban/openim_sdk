import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_barcode_scanner/xue_hua_barcode_scanner.dart';
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';

import '../../app/router/app_routes.dart';
import '../../core/utils/qr_payload_codec.dart';
import '../../l10n/app_localizations.dart';

/// 扫一扫全屏页（基于 `xue_hua_barcode_scanner`，支持桌面扫码登录确认、加好友、入群与链接识别）。
///
/// Full-screen QR/barcode scanner page handling desktop login, user, group, and URL payloads.
class ScannerPage extends StatefulWidget {
  /// 创建扫一扫页。
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _handled = false;

  Future<void> _onResult(BarcodeResult result) async {
    if (_handled) {
      return;
    }
    _handled = true;
    final String raw = result.text;
    final (String type, String value) = QrPayloadCodec.decode(raw);
    if (!mounted) {
      return;
    }
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    switch (type) {
      case 'desktop_login':
        await router.pushReplacementNamed(
          AppRoutes.qrDesktopLoginConfirm,
          arguments: value,
        );
      case 'user':
        await router.pushReplacementNamed(AppRoutes.contactProfile(value));
      case 'group':
        await router.pushReplacementNamed(
          AppRoutes.joinGroup,
          arguments: value,
        );
      default:
        await XueHuaNaviteClipboard.instance.writeText(value);
        await FlutterToastPro.info('已识别内容并复制到剪切板：$value');
        router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return BarcodeScannerPage(
      autoPopOnDetect: false,
      texts: ScannerTexts(galleryLabel: l10n.selectFromAlbum),
      onDetect: (List<BarcodeResult> results) {
        if (results.isNotEmpty) {
          _onResult(results.first);
        }
      },
    );
  }
}
