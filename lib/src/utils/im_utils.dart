import 'dart:convert';

import 'package:crypto/crypto.dart';

sealed class ImUtils {
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
}
