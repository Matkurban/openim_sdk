/// 联系人 A-Z / # 分组首字母解析工具。
///
/// Contact A-Z / `#` section tag resolver.
abstract final class PinyinTagHelper {
  /// 提取显示名称的首字母标签（A-Z 或 `#`）。
  static String resolveTag(String? displayName) {
    final String trimmed = (displayName ?? '').trim();
    if (trimmed.isEmpty) {
      return '#';
    }
    final int codeUnit = trimmed.codeUnitAt(0);
    if ((codeUnit >= 65 && codeUnit <= 90) ||
        (codeUnit >= 97 && codeUnit <= 122)) {
      return trimmed[0].toUpperCase();
    }
    if (codeUnit >= 0x4E00 && codeUnit <= 0x9FFF) {
      return _chineseFirstLetter(codeUnit);
    }
    return '#';
  }

  static String _chineseFirstLetter(int codeUnit) {
    final int offset = codeUnit - 0x4E00;
    const List<String> letters = <String>[
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'W',
      'X',
      'Y',
      'Z',
    ];
    final int idx = (offset ~/ 910).clamp(0, letters.length - 1);
    return letters[idx];
  }
}
