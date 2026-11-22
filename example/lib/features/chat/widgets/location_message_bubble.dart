import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../../app/router/app_routes.dart';

/// 位置消息气泡（点击进入 `LocationPreviewPage`）。
///
/// Location message bubble navigating to `LocationPreviewPage`.
class LocationMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 创建位置消息气泡。
  const LocationMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final LocationElem? loc = message.locationElem;
    final String desc = loc?.description ?? '分享的位置';
    final double lat = loc?.latitude ?? 0;
    final double lng = loc?.longitude ?? 0;
    return InkWell(
      onTap: () => AdaptiveRouter.of(context).pushNamed(
        AppRoutes.locationPreview,
        arguments: <String, Object>{
          'description': desc,
          'latitude': lat,
          'longitude': lng,
        },
      ),
      child: SizedBox(
        width: 210,
        child: Row(
          children: <Widget>[
            const Icon(Icons.location_on, color: Colors.red, size: 32),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
