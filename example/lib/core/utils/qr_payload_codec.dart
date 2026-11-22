import 'dart:convert';

/// 二维码名片与桌面扫码登录协议编解码器。
///
/// 兼容 `xue_hua_im_data_type` JSON 协议与 `openim://` URI 协议：
/// - `user`：个人名片
/// - `group`：群聊名片
/// - `desktop_login`：桌面端扫码登录会话
abstract final class QrPayloadCodec {
  /// 编码个人名片二维码内容。
  static String encodeUser(String userID) {
    return jsonEncode(<String, Object>{
      'xue_hua_im_data_type': 'user',
      'xue_hua_im_id': userID,
    });
  }

  /// 编码群聊二维码内容。
  static String encodeGroup(String groupID) {
    return jsonEncode(<String, Object>{
      'xue_hua_im_data_type': 'group',
      'xue_hua_im_id': groupID,
    });
  }

  /// 编码桌面端扫码登录会话二维码内容。
  static String encodeDesktopLogin(String sessionId, {int expireAt = 0}) {
    return jsonEncode(<String, Object>{
      'xue_hua_im_data_type': 'desktop_login',
      'xue_hua_im_id': sessionId,
      'expire_at': expireAt,
    });
  }

  /// 解析二维码内容为 `(type, value)`；`type` 为 `user`、`group`、`desktop_login`、`url` 或 `text`。
  static (String type, String value) decode(String raw) {
    final String trimmed = raw.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      try {
        final Object? decoded = jsonDecode(trimmed);
        if (decoded is Map<String, dynamic>) {
          final String? dataType = decoded['xue_hua_im_data_type'] as String?;
          final String? id = decoded['xue_hua_im_id'] as String?;
          if (dataType != null && id != null && id.isNotEmpty) {
            return (dataType, id);
          }
        }
      } on Object catch (_) {}
    }
    if (trimmed.startsWith('openim://desktop_login/')) {
      return (
        'desktop_login',
        trimmed.substring('openim://desktop_login/'.length),
      );
    }
    if (trimmed.startsWith('openim://user/')) {
      return ('user', trimmed.substring('openim://user/'.length));
    }
    if (trimmed.startsWith('openim://group/')) {
      return ('group', trimmed.substring('openim://group/'.length));
    }
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return ('url', trimmed);
    }
    return ('text', trimmed);
  }
}
