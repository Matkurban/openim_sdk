/// 微信风格时间格式化工具。
///
/// WeChat-style timestamp formatting utility.
abstract final class DateTimeFormatter {
  /// 格式化会话列表时间（毫秒时间戳）。
  static String formatConversationTime(int? timestampMs) {
    if (timestampMs == null || timestampMs <= 0) {
      return '';
    }
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final DateTime now = DateTime.now();
    final DateTime todayStart = DateTime(now.year, now.month, now.day);
    final DateTime yesterdayStart = todayStart.subtract(
      const Duration(days: 1),
    );
    final String hm = '${_two(dateTime.hour)}:${_two(dateTime.minute)}';
    if (!dateTime.isBefore(todayStart)) {
      return hm;
    }
    if (!dateTime.isBefore(yesterdayStart)) {
      return '昨天 $hm';
    }
    if (dateTime.year == now.year) {
      return '${_two(dateTime.month)}/${_two(dateTime.day)}';
    }
    return '${dateTime.year}/${_two(dateTime.month)}/${_two(dateTime.day)}';
  }

  /// 格式化完整日期时间。
  static String formatFullDateTime(int? timestampMs) {
    if (timestampMs == null || timestampMs <= 0) {
      return '';
    }
    final DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    return '${dt.year}-${_two(dt.month)}-${_two(dt.day)} '
        '${_two(dt.hour)}:${_two(dt.minute)}';
  }

  /// 格式化文件体积为人类可读字符串。
  static String formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// 格式化音视频时长（秒）。
  static String formatDurationSeconds(int seconds) {
    final int safe = seconds < 0 ? 0 : seconds;
    final int mins = safe ~/ 60;
    final int secs = safe % 60;
    return '${_two(mins)}:${_two(secs)}';
  }

  static String _two(int n) => n < 10 ? '0$n' : '$n';
}
