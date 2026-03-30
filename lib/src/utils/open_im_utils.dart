import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

sealed class OpenImUtils {
  // 复用同一个 Random 实例，避免每次 generateOperationID 时分配新对象
  static final Random _rng = Random();

  ///生成唯一的操作ID
  static String generateOperationID({String operationName = 'openim_sdk'}) {
    return '${operationName}_${DateTime.now().millisecondsSinceEpoch}_${_rng.nextInt(10000)}';
  }

  ///生成md5
  static String? generateMD5(String? data) {
    if (null == data) return null;
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  ///根据用户名生成空间名
  static String generateSpaceName(String userID) {
    return 'kurban_open_im_$userID';
  }

  static Future<String?> defaultDbPath() async {
    if (kIsWeb) return null;
    Directory directory = await getApplicationSupportDirectory();
    return '${directory.path}/kurban_open_im_sdk';
  }

  /// 生成单聊会话ID
  static String genSingleConversationID(String userID1, String userID2) {
    final sorted = [userID1, userID2]..sort();
    return 'si_${sorted[0]}_${sorted[1]}';
  }

  /// 生成群聊会话ID
  static String genGroupConversationID(String groupID) {
    return 'sg_$groupID';
  }

  /// 生成通知会话ID
  static String genNotificationConversationID(String userID1, String userID2) {
    final sorted = [userID1, userID2]..sort();
    return 'sn_${sorted[0]}_${sorted[1]}';
  }

  /// 生成唯一消息 ID
  static String generateClientMsgID(String currentUserID) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = Random.secure().nextInt(999999999);
    final raw = '$timestamp-$random-$currentUserID';
    return md5.convert(utf8.encode(raw)).toString();
  }
}
