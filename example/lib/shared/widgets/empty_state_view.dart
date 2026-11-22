import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_animated_svg/xue_hua_animated_svg.dart';

/// 带矢量动效插画的空态占位组件（使用 `xue_hua_animated_svg`）。
///
/// Empty-state placeholder widget powered by `xue_hua_animated_svg`.
class EmptyStateView extends StatelessWidget {
  /// 主标题。
  final String title;

  /// 辅助说明（可选）。
  final String? subtitle;

  /// 可选操作按钮文字。
  final String? actionLabel;

  /// 可选操作回调。
  final VoidCallback? onAction;

  /// 创建空态占位组件。
  const EmptyStateView({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 96,
              height: 96,
              child: AnimatedSvgPicture.asset('assets/svg/empty_chat.svg'),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
