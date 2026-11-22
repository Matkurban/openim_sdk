/// 二维码名片协议编解码器（`openim://user/<id>` / `openim://group/<id>`）。
///
/// QR code payload encoder/decoder (`openim://user/<id>` / `openim://group/<id>`).
abstract final class QrPayloadCodec {
  /// 编码个人名片二维码内容。
  static String encodeUser(String userID) => 'openim://user/$userID';

  /// 编码群聊二维码内容。
  static String encodeGroup(String groupID) => 'openim://group/$groupID';

  /// 解析二维码内容为 `(type, value)`；`type` 为 `user`、`group`、`url` 或 `text`。
  static (String type, String value) decode(String raw) {
    final String trimmed = raw.trim();
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
