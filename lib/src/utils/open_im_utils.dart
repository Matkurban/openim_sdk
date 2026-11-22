import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'default_db_path_stub.dart' if (dart.library.io) 'default_db_path_io.dart';

/// OpenIM 通用工具类，提供操作 ID、MD5、数据库路径与会话 ID 生成方法。
///
/// Common OpenIM utility helpers for operation IDs, MD5 hashing, database paths,
/// and canonical conversation/message ID generation.
sealed class OpenImUtils {
  static final Random _rng = Random();

  /// 生成唯一的操作追踪 ID。
  ///
  /// Generates a unique operation tracing ID.
  ///
  /// - [operationName] 操作名称前缀，默认 `openim_sdk` / Prefix for the operation name, defaults to `openim_sdk`.
  /// - Returns: 唯一操作 ID 字符串 / Unique operation ID string.
  static String generateOperationID({String operationName = 'openim_sdk'}) {
    return '${operationName}_${DateTime.now().millisecondsSinceEpoch}_${_rng.nextInt(10000)}';
  }

  /// 计算字符串的 MD5 十六进制摘要。
  ///
  /// Computes the MD5 hex digest of [data].
  ///
  /// - [data] 待计算哈希的原始字符串，为 `null` 时返回 `null` / Input string, or `null`.
  /// - Returns: 32 位小写 MD5 摘要字符串，输入为 `null` 时返回 `null` / Lowercase MD5 hex string, or `null`.
  static String? generateMD5(String? data) {
    if (null == data) return null;
    final List<int> content = const Utf8Encoder().convert(data);
    final Digest digest = md5.convert(content);
    return digest.toString();
  }

  /// 根据用户 ID 生成隔离的 ToStore 数据库空间名。
  ///
  /// Generates an isolated ToStore database space name for [userID].
  ///
  /// - [userID] 用户 ID / User ID.
  /// - Returns: 数据库空间名称 / Database space name string.
  static String generateSpaceName(String userID) {
    return 'kurban_open_im_$userID';
  }

  /// 获取当前平台的默认本地数据库存储路径（Web 端返回 `null`）。
  ///
  /// Resolves the default local database directory path for the current platform (`null` on Web).
  ///
  /// - Returns: 默认数据库目录路径，Web 端返回 `null` / Default DB directory path, or `null` on Web.
  static Future<String?> defaultDbPath() async {
    return resolveDefaultDbPath();
  }

  /// 生成标准单聊会话 ID（`si_<minUserID>_<maxUserID>`）。
  ///
  /// Generates a canonical single-chat conversation ID (`si_<minUserID>_<maxUserID>`).
  ///
  /// - [userID1] 参与方用户 ID 1 / First participant user ID.
  /// - [userID2] 参与方用户 ID 2 / Second participant user ID.
  /// - Returns: 标准单聊会话 ID / Canonical single-chat conversation ID.
  static String genSingleConversationID(String userID1, String userID2) {
    final List<String> sorted = <String>[userID1, userID2]..sort();
    return 'si_${sorted[0]}_${sorted[1]}';
  }

  /// 生成标准群聊会话 ID（`sg_<groupID>`）。
  ///
  /// Generates a canonical group-chat conversation ID (`sg_<groupID>`).
  ///
  /// - [groupID] 群组 ID / Group ID.
  /// - Returns: 标准群聊会话 ID / Canonical group-chat conversation ID.
  static String genGroupConversationID(String groupID) {
    return 'sg_$groupID';
  }

  /// 生成标准系统通知会话 ID（`sn_<minUserID>_<maxUserID>`）。
  ///
  /// Generates a canonical notification conversation ID (`sn_<minUserID>_<maxUserID>`).
  ///
  /// - [userID1] 参与方用户 ID 1 / First participant user ID.
  /// - [userID2] 参与方用户 ID 2 / Second participant user ID.
  /// - Returns: 标准通知会话 ID / Canonical notification conversation ID.
  static String genNotificationConversationID(String userID1, String userID2) {
    final List<String> sorted = <String>[userID1, userID2]..sort();
    return 'sn_${sorted[0]}_${sorted[1]}';
  }

  /// 生成唯一客户端消息 ID（`clientMsgID`）。
  ///
  /// Generates a unique client-side message ID (`clientMsgID`).
  ///
  /// - [currentUserID] 当前登录用户 ID / Current logged-in user ID.
  /// - Returns: 32 位唯一 `clientMsgID` 字符串 / 32-character unique `clientMsgID` string.
  static String generateClientMsgID(String currentUserID) {
    final int timestamp = DateTime.now().microsecondsSinceEpoch;
    final int random = Random.secure().nextInt(999999999);
    final String raw = '$timestamp-$random-$currentUserID';
    return md5.convert(utf8.encode(raw)).toString();
  }
}
