/// 纯 Dart Worker 函数（6 端通用，可编译为 Web JS Worker）
///
/// **不允许** 导入 `package:flutter/*`、`dart:io`、`dart:ui`；否则 dart2js 无法
/// 编译到 `$shared_worker.js`。所有需要 Flutter / 文件 I/O 的 worker 请放到
/// [sdk_isolate_workers_io.dart]。
///
/// 所有函数必须是：
/// - 顶层函数（不在 class 里）
/// - 加 `@pragma('vm:entry-point')`（防止 tree-shaking）
/// - 加 `@isolateManagerSharedWorker`（生成器扫描这个注解）
/// - 参数/返回值只能是 `num`/`String`/`bool`/`null`/`Uint8List`/`List`/`Map`，
///   以满足 Web Worker `postMessage` 的结构化克隆限制。
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:isolate_manager/isolate_manager.dart';

// ============================================================
// MD5 / 哈希
// ============================================================

@pragma('vm:entry-point')
@isolateManagerSharedWorker
String md5Worker(Uint8List bytes) {
  return md5.convert(bytes).toString();
}

@pragma('vm:entry-point')
@isolateManagerSharedWorker
String combinedMd5Worker(List<String> partMd5s) {
  final combined = partMd5s.join(',');
  return md5.convert(utf8.encode(combined)).toString();
}

@pragma('vm:entry-point')
@isolateManagerSharedWorker
List<String> partMd5sFromBytesWorker(Map<String, dynamic> param) {
  final Uint8List fileBytes = param['fileBytes'] as Uint8List;
  final int partSize = (param['partSize'] as num).toInt();
  final int partNum = (param['partNum'] as num).toInt();
  final int fileSize = (param['fileSize'] as num).toInt();

  final results = <String>[];
  for (int i = 0; i < partNum; i++) {
    final start = i * partSize;
    final currentPartSize = (i < partNum - 1) ? partSize : fileSize - partSize * (partNum - 1);
    final end = (start + currentPartSize).clamp(0, fileSize);
    final partBytes = Uint8List.sublistView(fileBytes, start, end);
    results.add(md5.convert(partBytes).toString());
  }
  return results;
}

// ============================================================
// 图片尺寸解码（纯字节，无文件 I/O）
// ============================================================

@pragma('vm:entry-point')
@isolateManagerSharedWorker
Map<String, dynamic>? imageDimensionsWorker(Uint8List bytes) {
  return decodeImageDimensions(bytes);
}

/// 公开解码函数，给 io 版 worker 复用（io 版本只负责从文件读字节）。
Map<String, dynamic>? decodeImageDimensions(Uint8List bytes) {
  if (bytes.length < 24) return null;

  // PNG
  if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
    final w = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
    final h = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
    return {'w': w, 'h': h};
  }

  // JPEG
  if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
    int offset = 2;
    while (offset + 9 < bytes.length) {
      if (bytes[offset] != 0xFF) break;
      final marker = bytes[offset + 1];
      if (marker >= 0xC0 && marker <= 0xC3) {
        final h = (bytes[offset + 5] << 8) | bytes[offset + 6];
        final w = (bytes[offset + 7] << 8) | bytes[offset + 8];
        return {'w': w, 'h': h};
      }
      if (marker == 0xD9 || marker == 0xDA) break;
      final len = (bytes[offset + 2] << 8) | bytes[offset + 3];
      offset += 2 + len;
    }
  }

  // GIF
  if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes.length >= 10) {
    final w = bytes[6] | (bytes[7] << 8);
    final h = bytes[8] | (bytes[9] << 8);
    return {'w': w, 'h': h};
  }

  // BMP
  if (bytes[0] == 0x42 && bytes[1] == 0x4D && bytes.length >= 26) {
    final w = bytes[18] | (bytes[19] << 8) | (bytes[20] << 16) | (bytes[21] << 24);
    final h = bytes[22] | (bytes[23] << 8) | (bytes[24] << 16) | (bytes[25] << 24);
    return {'w': w, 'h': h.abs()};
  }

  // WEBP
  if (bytes.length >= 30 &&
      bytes[0] == 0x52 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x46 &&
      bytes[3] == 0x46 &&
      bytes[8] == 0x57 &&
      bytes[9] == 0x45 &&
      bytes[10] == 0x42 &&
      bytes[11] == 0x50) {
    if (bytes[12] == 0x56 && bytes[13] == 0x50 && bytes[14] == 0x38 && bytes[15] == 0x20) {
      if (bytes.length >= 30) {
        final w = (bytes[26] | (bytes[27] << 8)) & 0x3FFF;
        final h = (bytes[28] | (bytes[29] << 8)) & 0x3FFF;
        return {'w': w, 'h': h};
      }
    }
    if (bytes[12] == 0x56 && bytes[13] == 0x50 && bytes[14] == 0x38 && bytes[15] == 0x4C) {
      if (bytes.length >= 25) {
        final bits = bytes[21] | (bytes[22] << 8) | (bytes[23] << 16) | (bytes[24] << 24);
        final w = (bits & 0x3FFF) + 1;
        final h = ((bits >> 14) & 0x3FFF) + 1;
        return {'w': w, 'h': h};
      }
    }
  }

  return null;
}

// ============================================================
// 消息搜索过滤
// ============================================================

@pragma('vm:entry-point')
@isolateManagerSharedWorker
List<dynamic> searchFilterWorker(Map<String, dynamic> param) {
  final data = (param['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
  final String? keyword = param['keyword'] as String?;
  final List<int>? messageTypes = (param['messageTypes'] as List?)
      ?.map((e) => (e as num).toInt())
      .toList();
  final int? startTime = (param['startTime'] as num?)?.toInt();
  final int? endTime = (param['endTime'] as num?)?.toInt();
  final int offset = (param['offset'] as num?)?.toInt() ?? 0;
  final int count = (param['count'] as num?)?.toInt() ?? 40;

  var filtered = data.where((msg) {
    if (keyword != null && keyword.isNotEmpty) {
      final kw = keyword.toLowerCase();
      final ct = (msg['contentType'] as num?)?.toInt() ?? 0;
      final rawContent = msg['content'] as String? ?? '';
      if (ct == 102 || ct == 103 || ct == 104) return false;
      String searchText;
      try {
        final Map<String, dynamic> contentMap = jsonDecode(rawContent) as Map<String, dynamic>;
        switch (ct) {
          case 101:
            searchText = (contentMap['content'] as String? ?? '').toLowerCase();
          case 106:
            searchText = (contentMap['text'] as String? ?? '').toLowerCase();
          case 105:
            searchText = (contentMap['fileName'] as String? ?? '').toLowerCase();
          case 107:
            searchText = (contentMap['title'] as String? ?? '').toLowerCase();
          case 108:
            searchText = (contentMap['nickname'] as String? ?? '').toLowerCase();
          case 109:
            searchText = (contentMap['description'] as String? ?? '').toLowerCase();
          case 110:
            searchText = (contentMap['description'] as String? ?? '').toLowerCase();
          case 114:
            searchText = (contentMap['text'] as String? ?? '').toLowerCase();
          default:
            searchText = rawContent.toLowerCase();
        }
      } catch (_) {
        searchText = rawContent.toLowerCase();
      }
      if (!searchText.contains(kw)) return false;
    }
    if (messageTypes != null && messageTypes.isNotEmpty) {
      final ct = (msg['contentType'] as num?)?.toInt() ?? 0;
      if (!messageTypes.contains(ct)) return false;
    }
    if (startTime != null && startTime > 0) {
      final st = (msg['sendTime'] as num?)?.toInt() ?? 0;
      if (st < startTime) return false;
    }
    if (endTime != null && endTime > 0) {
      final st = (msg['sendTime'] as num?)?.toInt() ?? 0;
      if (st > endTime) return false;
    }
    return true;
  }).toList();

  if (offset > 0 && offset < filtered.length) {
    filtered = filtered.sublist(offset);
  } else if (offset >= filtered.length) {
    return <Map<String, dynamic>>[];
  }
  if (filtered.length > count) {
    filtered = filtered.sublist(0, count);
  }
  return filtered;
}

// ============================================================
// 历史消息过滤
// ============================================================

@pragma('vm:entry-point')
@isolateManagerSharedWorker
List<dynamic> historyFilterWorker(Map<String, dynamic> param) {
  var data = (param['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
  final int startTime = (param['startTime'] as num).toInt();
  final int startSeq = (param['startSeq'] as num).toInt();
  final String startClientMsgID = param['startClientMsgID'] as String;
  final int count = (param['count'] as num).toInt();

  if (startTime > 0 && data.isNotEmpty) {
    data = data.where((record) {
      final int sendTime = (record['sendTime'] as num?)?.toInt() ?? 0;
      final int seq = (record['seq'] as num?)?.toInt() ?? 0;
      final String clientMsgID = record['clientMsgID'] as String? ?? '';

      if (sendTime < startTime) return true;
      if (sendTime == startTime) {
        if (startSeq > 0) return seq < startSeq;
        return seq <= startSeq && clientMsgID != startClientMsgID;
      }
      return false;
    }).toList();
  }
  return data.take(count).toList();
}
