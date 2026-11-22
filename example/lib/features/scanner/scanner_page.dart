import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_barcode_scanner/xue_hua_barcode_scanner.dart';
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';

import '../../app/router/app_routes.dart';
import '../../core/utils/qr_payload_codec.dart';

/// 扫一扫全屏页（基于 `xue_hua_barcode_scanner`，识别好友名片/群二维码/链接并自动路由）。
///
/// Full-screen QR/barcode scanner page dispatching user/group/URL scan results.
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
    return BarcodeScannerPage(
      onDetect: (List<BarcodeResult> results) {
        if (results.isNotEmpty) {
          _onResult(results.first);
        }
      },
    );
  }
}
