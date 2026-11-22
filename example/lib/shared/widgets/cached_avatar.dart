import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_navite_cache_manager/xue_hua_navite_cache_manager.dart';

import '../../app/theme/app_colors.dart';

/// 基于 `xue_hua_navite_cache_manager` 的圆角缓存头像组件（直接使用高性能 `borderRadius` 属性）。
///
/// Rounded cached avatar widget using `CachedNetworkImage.borderRadius` directly (no `ClipRRect`).
class CachedAvatar extends StatelessWidget {
  /// 头像图片 URL。
  final String? imageUrl;

  /// 无头像时展示的名称首字。
  final String? fallbackName;

  /// 头像边长（像素）。
  final double size;

  /// 圆角半径。
  final double borderRadius;

  /// 创建缓存头像组件。
  const CachedAvatar({
    super.key,
    this.imageUrl,
    this.fallbackName,
    this.size = 44,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final String url = (imageUrl ?? '').trim();
    final int decodeSize = (size * 2).round().clamp(64, 512);
    final BorderRadius radius = BorderRadius.circular(borderRadius);
    if (url.isEmpty) {
      return _AvatarFallback(
        name: fallbackName,
        size: size,
        borderRadius: radius,
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      tag: 'avatars',
      width: size,
      height: size,
      memCacheWidth: decodeSize,
      memCacheHeight: decodeSize,
      borderRadius: radius,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext _, String _, Object _, StackTrace? _) {
        return _AvatarFallback(
          name: fallbackName,
          size: size,
          borderRadius: radius,
        );
      },
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String? name;
  final double size;
  final BorderRadius borderRadius;

  const _AvatarFallback({
    required this.name,
    required this.size,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final String trimmed = (name ?? '').trim();
    final String initial = trimmed.isNotEmpty ? trimmed[0].toUpperCase() : '?';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.16),
        borderRadius: borderRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: size * 0.42,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
