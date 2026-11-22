import 'package:material_ui/material_ui.dart';

import '../../app/theme/app_colors.dart';

/// 微信风格未读数红点角标组件。
///
/// WeChat-style unread count red badge widget.
class UnreadBadge extends StatelessWidget {
  /// 未读数量（`<= 0` 时不渲染）。
  final int count;

  /// 是否仅显示小红点（免打扰会话场景）。
  final bool dotOnly;

  /// 创建未读角标组件。
  const UnreadBadge({super.key, required this.count, this.dotOnly = false});

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const SizedBox.shrink();
    }
    if (dotOnly) {
      return Container(
        width: 9,
        height: 9,
        decoration: const BoxDecoration(
          color: AppColors.badgeRed,
          shape: BoxShape.circle,
        ),
      );
    }
    final String label = count > 99 ? '99+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.badgeRed,
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
      ),
    );
  }
}
