import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../app/theme/app_colors.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 红包领取详情与记录页（对接 `RedPacketManager.getRedPacketDetail`）。
///
/// Red packet detail and grab records page.
class RedPacketDetailPage extends StatefulWidget {
  /// 红包 ID。
  final String packetId;

  /// 创建红包详情页。
  const RedPacketDetailPage({super.key, required this.packetId});

  @override
  State<RedPacketDetailPage> createState() => _RedPacketDetailPageState();
}

class _RedPacketDetailPageState extends State<RedPacketDetailPage> {
  late final Signal<RedPacketDetail?> _detail = signal<RedPacketDetail?>(null);
  late final Signal<bool> _loading = signal<bool>(true);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final RedPacketDetail detail = await OpenIM.iMManager.redPacketManager
          .getRedPacketDetail(widget.packetId);
      if (mounted) {
        _detail.value = detail;
      }
    } finally {
      if (mounted) {
        _loading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('红包详情'),
        backgroundColor: AppColors.redPacketOrange,
        foregroundColor: Colors.white,
      ),
      body: SignalBuilder(
        builder: (BuildContext _) {
          if (_loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final RedPacketDetail? d = _detail.value;
          if (d == null) {
            return const Center(child: Text('未获取到红包详情'));
          }
          return ListView(
            children: <Widget>[
              Container(
                color: AppColors.redPacketOrange.withValues(alpha: 0.12),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: <Widget>[
                    CachedAvatar(
                      imageUrl: d.senderFaceURL,
                      fallbackName: d.senderNickname,
                      size: 56,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${d.senderNickname}的积分红包',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(d.greeting),
                    const SizedBox(height: 12),
                    Text(
                      '已领取 ${d.grabbedCount}/${d.totalCount} 个 · 共 ${d.totalAmount.toStringAsFixed(2)} 积分',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              for (final RedPacketGrabInfo r in d.grabs)
                ListTile(
                  leading: CachedAvatar(
                    imageUrl: r.faceURL,
                    fallbackName: r.nickname,
                  ),
                  title: Text(r.nickname),
                  subtitle: Text(
                    r.createTime.toLocal().toString().split('.').first,
                  ),
                  trailing: Text(
                    '${r.amount.toStringAsFixed(2)} 积分',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
