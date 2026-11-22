/// 对端输入状态（Typing）内存追踪器，对齐 `xue_hua_sdk/rust/src/core/typing/manager.rs`（修复 B-03）。
///
/// 按 `(conversationID, userID)` 记录正在输入的平台 ID 集合，支持自动过期清理。
class TypingStateTracker {
  static const Duration _defaultTtl = Duration(seconds: 10);

  final Map<String, Map<int, DateTime>> _entries = <String, Map<int, DateTime>>{};

  String _key(String conversationID, String userID) => '$conversationID|$userID';

  /// 更新某用户在某会话某平台的输入状态；返回该用户当前活跃的平台 ID 列表。
  ///
  /// Update.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [userID] 用户ID / User ID.
  /// - [platformID] 平台ID / Platform ID.
  /// - [isTyping] 是否正在输入 / Whether typing.
  /// - Returns: `List<int>` 列表结果 / Resulting `List<int>` list.
  List<int> update({
    required String conversationID,
    required String userID,
    required int platformID,
    required bool isTyping,
  }) {
    final String k = _key(conversationID, userID);
    final DateTime now = DateTime.now();
    final Map<int, DateTime> platforms = _entries.putIfAbsent(k, () => <int, DateTime>{});
    _pruneExpired(platforms, now);

    if (isTyping && platformID > 0) {
      platforms[platformID] = now.add(_defaultTtl);
    } else if (platformID > 0) {
      platforms.remove(platformID);
    } else {
      platforms.clear();
    }

    if (platforms.isEmpty) {
      _entries.remove(k);
      return <int>[];
    }
    return platforms.keys.toList();
  }

  /// 查询某用户在某会话当前正在输入的平台 ID 列表。
  ///
  /// Get active platforms.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [userID] 用户ID / User ID.
  /// - Returns: `List<int>` 列表结果 / Resulting `List<int>` list.
  List<int> getActivePlatforms(String conversationID, String userID) {
    final String k = _key(conversationID, userID);
    final Map<int, DateTime>? platforms = _entries[k];
    if (platforms == null) {
      return <int>[];
    }
    _pruneExpired(platforms, DateTime.now());
    if (platforms.isEmpty) {
      _entries.remove(k);
      return <int>[];
    }
    return platforms.keys.toList();
  }

  /// 清空。
  ///
  /// Clear.
  void clear() {
    _entries.clear();
  }

  void _pruneExpired(Map<int, DateTime> platforms, DateTime now) {
    platforms.removeWhere((int _, DateTime expireAt) => now.isAfter(expireAt));
  }
}
