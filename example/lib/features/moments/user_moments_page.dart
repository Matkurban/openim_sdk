import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/empty_state_view.dart';
import 'widgets/moment_card.dart';

/// 个人 / 好友朋友圈相册时间轴页。
///
/// User moments album timeline page.
class UserMomentsPage extends StatefulWidget {
  /// 目标用户 ID。
  final String userId;

  /// 创建用户相册页。
  const UserMomentsPage({super.key, required this.userId});

  @override
  State<UserMomentsPage> createState() => _UserMomentsPageState();
}

class _UserMomentsPageState extends State<UserMomentsPage> {
  late final Signal<List<MomentInfo>> _list = signal<List<MomentInfo>>(
    <MomentInfo>[],
  );
  late final Signal<bool> _loading = signal<bool>(true);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final MomentListResponse res = await OpenIM.iMManager.momentsManager
          .getMomentList(
            ownerUserID: widget.userId,
            pageNumber: 1,
            showNumber: 50,
          );
      if (mounted) {
        _list.value = res.moments;
      }
    } finally {
      if (mounted) {
        _loading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('TA 的朋友圈')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          if (_loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<MomentInfo> list = _list.value;
          if (list.isEmpty) {
            return const EmptyStateView(title: '暂无公开动态');
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (BuildContext _, int _) =>
                const Divider(height: 1),
            itemBuilder: (BuildContext _, int index) {
              final MomentInfo m = list[index];
              return MomentCard(
                moment: m,
                onToggleLike: () async {
                  await OpenIM.iMManager.momentsManager.likeMoment(
                    momentID: m.momentID,
                    ownerUserID: m.userID,
                  );
                  await _load();
                },
                onComment: () => router.pushNamed(
                  AppRoutes.momentDetail(m.momentID),
                  arguments: m,
                ),
                onFavorite: () =>
                    OpenIM.iMManager.favoriteManager.addMoment(moment: m),
                onDelete: () async {
                  await OpenIM.iMManager.momentsManager.deleteMoment(
                    momentID: m.momentID,
                  );
                  await _load();
                },
                onOpenDetail: () => router.pushNamed(
                  AppRoutes.momentDetail(m.momentID),
                  arguments: m,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
