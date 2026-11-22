import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';

/// 微信风格积分红包消息气泡（点击领取或查看红包详情）。
///
/// WeChat-style red packet message bubble.
class RedPacketMessageBubble extends StatelessWidget {
  /// 消息对象。
  final Message message;

  /// 所属会话 ID。
  final String conversationId;

  /// 创建红包消息气泡。
  const RedPacketMessageBubble({
    super.key,
    required this.message,
    required this.conversationId,
  });

  Future<void> _onTap(BuildContext context) async {
    final String packetId = message.redPacketElem?.packetID ?? '';
    if (packetId.isEmpty) {
      return;
    }
    final bool grabbed = OpenIM.iMManager.redPacketManager.isGrabbed(packetId);
    if (!grabbed) {
      try {
        final double amount = await OpenIM.iMManager.redPacketManager
            .grabRedPacket(packetId);
        await FlutterToastPro.success('领取成功：+${amount.toStringAsFixed(2)} 积分');
      } on Object catch (error) {
        await FlutterToastPro.info('$error');
      }
    }
    if (context.mounted) {
      await AdaptiveRouter.of(context)
          .pushNamed(AppRoutes.redPacketDetail(conversationId, packetId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final RedPacketElem? elem = message.redPacketElem;
    final String packetId = elem?.packetID ?? '';
    final bool grabbed = OpenIM.iMManager.redPacketManager.isGrabbed(packetId);
    return InkWell(
      onTap: () => _onTap(context),
      child: Container(
        width: 225,
        decoration: BoxDecoration(
          color: grabbed
              ? AppColors.redPacketClaimed
              : AppColors.redPacketOrange,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.card_giftcard, color: Colors.white, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        elem?.greeting ?? '恭喜发财，大吉大利',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        grabbed ? '已领取' : '领取红包',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 16),
            const Text(
              'OpenIM 积分红包',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
