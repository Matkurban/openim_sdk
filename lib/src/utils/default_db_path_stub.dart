/// 解析 Web / 非 `dart:io` 平台的默认数据库路径（恒返回 `null`）。
///
/// Resolves the default database path on Web / non-`dart:io` platforms (always `null`).
///
/// - Returns: `null`（Web 端由 IndexedDB 自动管理存储） / `null` (Web uses IndexedDB automatically).
Future<String?> resolveDefaultDbPath() async => null;
