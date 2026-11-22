import 'package:material_ui/material_ui.dart';
import 'package:xue_hua_animated_svg/xue_hua_animated_svg.dart';

/// 表情与 SVG 动效贴纸选择面板（集成 `xue_hua_animated_svg`）。
///
/// Emoji and animated SVG sticker picker panel.
class ChatEmojiPanel extends StatelessWidget {
  /// 选中普通 Emoji 回调。
  final ValueChanged<String> onSelectEmoji;

  /// 选中 SVG 动效贴纸回调（传入 asset 路径）。
  final ValueChanged<String> onSelectSvgSticker;

  /// 创建表情面板。
  const ChatEmojiPanel({
    super.key,
    required this.onSelectEmoji,
    required this.onSelectSvgSticker,
  });

  static const List<String> _emojis = <String>[
    '😀',
    '😄',
    '😂',
    '🥰',
    '😎',
    '🤔',
    '👍',
    '👏',
    '🎉',
    '❤️',
    '🔥',
    '🚀',
    '🙏',
    '👌',
    '😢',
    '😮',
  ];

  static const List<(String, String)> _svgStickers = <(String, String)>[
    ('assets/svg/sticker_smile.svg', '动效微笑'),
    ('assets/svg/sticker_heart.svg', '动效爱心'),
    ('assets/svg/brand_logo.svg', 'OpenIM 动效'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: <Widget>[
              for (final String emoji in _emojis)
                InkWell(
                  onTap: () => onSelectEmoji(emoji),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
            ],
          ),
          const Divider(height: 18),
          Text(
            '矢量动效贴纸 (xue_hua_animated_svg)',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              for (final (String asset, String label) in _svgStickers)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: InkWell(
                    onTap: () => onSelectSvgSticker(asset),
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: AnimatedSvgPicture.asset(asset),
                        ),
                        const SizedBox(height: 2),
                        Text(label, style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
