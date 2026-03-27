/// OpenIM SDK Isolate 工具：将 CPU 密集型操作从主线程卸载到后台 Isolate。
///
/// 设计原则：
/// - 使用 Flutter 的 `compute()` 实现简单高效的 Isolate 调用
/// - 所有函数参数和返回值必须可序列化（Isolate 通信限制）
/// - 提供语义化的顶层函数，各 manager 直接调用
/// - Web 平台自动降级为主线程执行（`compute` 在 Web 上直接同步执行）
library;

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

// ============================================================
// 1. MD5 哈希计算（上传分片、消息 ID 生成）
// ============================================================

/// 计算 bytes 的 MD5 哈希，返回 hex 字符串
Future<String> computeMd5(Uint8List bytes) {
  return compute(_md5Worker, bytes);
}

String _md5Worker(Uint8List bytes) {
  return md5.convert(bytes).toString();
}

/// 批量计算多个分片的 MD5（上传流程用）
/// 输入: 文件路径 + 分片参数列表
/// 输出: 每个分片的 MD5 hex 字符串列表
Future<List<String>> computePartMd5s(ComputePartMd5sParam param) {
  return compute(_partMd5sWorker, param);
}

class ComputePartMd5sParam {
  final String? filePath;
  final Uint8List? fileBytes;
  final int partSize;
  final int partNum;
  final int fileSize;

  const ComputePartMd5sParam({
    this.filePath,
    this.fileBytes,
    required this.partSize,
    required this.partNum,
    required this.fileSize,
  });
}

List<String> _partMd5sWorker(ComputePartMd5sParam param) {
  final results = <String>[];
  for (int i = 0; i < param.partNum; i++) {
    final start = i * param.partSize;
    final currentPartSize = (i < param.partNum - 1)
        ? param.partSize
        : param.fileSize - param.partSize * (param.partNum - 1);
    final end = (start + currentPartSize).clamp(0, param.fileSize);

    Uint8List partBytes;
    if (param.fileBytes != null) {
      partBytes = Uint8List.sublistView(param.fileBytes!, start, end);
    } else if (param.filePath != null) {
      // 在 Isolate 内使用 dart:io 文件读取（不影响主线程）
      final file = _openFileSync(param.filePath!);
      file.setPositionSync(start);
      partBytes = file.readSync(end - start);
      file.closeSync();
    } else {
      throw ArgumentError('filePath 或 fileBytes 必须提供其中一个');
    }
    results.add(md5.convert(partBytes).toString());
  }
  return results;
}

/// 计算组合 MD5：所有分片 MD5 用逗号拼接后再取 MD5
Future<String> computeCombinedMd5(List<String> partMd5s) {
  return compute(_combinedMd5Worker, partMd5s);
}

String _combinedMd5Worker(List<String> partMd5s) {
  final combined = partMd5s.join(',');
  return md5.convert(utf8.encode(combined)).toString();
}

// ============================================================
// 2. 文件分片读取（上传流程用，避免主线程 I/O 阻塞）
// ============================================================

class ReadFilePartParam {
  final String filePath;
  final int start;
  final int length;

  const ReadFilePartParam({required this.filePath, required this.start, required this.length});
}

/// 在 Isolate 中读取文件的指定部分
Future<Uint8List> readFilePart(ReadFilePartParam param) {
  return compute(_readFilePartWorker, param);
}

Uint8List _readFilePartWorker(ReadFilePartParam param) {
  final file = _openFileSync(param.filePath);
  file.setPositionSync(param.start);
  final bytes = file.readSync(param.length);
  file.closeSync();
  return bytes;
}

// ============================================================
// 3. 图片尺寸解码（消息创建时，避免主线程二进制解析）
// ============================================================

class ImageDimensions {
  final int width;
  final int height;

  ImageDimensions(this.width, this.height);
}

/// 在 Isolate 中读取文件并解码图片尺寸
Future<ImageDimensions?> computeImageDimensions(Uint8List bytes) {
  return compute(_imageDimensionsWorker, bytes);
}

/// 在 Isolate 中从文件路径读取并解码图片尺寸
Future<ImageDimensions?> computeImageDimensionsFromFile(String filePath) {
  return compute(_imageDimensionsFromFileWorker, filePath);
}

ImageDimensions? _imageDimensionsFromFileWorker(String filePath) {
  final file = _openFileSync(filePath);
  // 只需读取头部数据即可解析尺寸（最多几KB）
  final headerBytes = file.readSync(65536);
  file.closeSync();
  return _imageDimensionsWorker(headerBytes);
}

ImageDimensions? _imageDimensionsWorker(Uint8List bytes) {
  if (bytes.length < 24) return null;

  // PNG
  if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
    final w = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
    final h = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
    return ImageDimensions(w, h);
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
        return ImageDimensions(w, h);
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
    return ImageDimensions(w, h);
  }

  // BMP
  if (bytes[0] == 0x42 && bytes[1] == 0x4D && bytes.length >= 26) {
    final w = bytes[18] | (bytes[19] << 8) | (bytes[20] << 16) | (bytes[21] << 24);
    final h = bytes[22] | (bytes[23] << 8) | (bytes[24] << 16) | (bytes[25] << 24);
    return ImageDimensions(w, h.abs());
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
    // VP8
    if (bytes[12] == 0x56 && bytes[13] == 0x50 && bytes[14] == 0x38 && bytes[15] == 0x20) {
      if (bytes.length >= 30) {
        final w = (bytes[26] | (bytes[27] << 8)) & 0x3FFF;
        final h = (bytes[28] | (bytes[29] << 8)) & 0x3FFF;
        return ImageDimensions(w, h);
      }
    }
    // VP8L
    if (bytes[12] == 0x56 && bytes[13] == 0x50 && bytes[14] == 0x38 && bytes[15] == 0x4C) {
      if (bytes.length >= 25) {
        final bits = bytes[21] | (bytes[22] << 8) | (bytes[23] << 16) | (bytes[24] << 24);
        final w = (bits & 0x3FFF) + 1;
        final h = ((bits >> 14) & 0x3FFF) + 1;
        return ImageDimensions(w, h);
      }
    }
  }

  return null;
}

// ============================================================
// 5. 消息搜索过滤（数据库查询后的 Dart 层过滤）
// ============================================================

class SearchFilterParam {
  final List<Map<String, dynamic>> data;
  final String? keyword;
  final List<int>? messageTypes;
  final int? startTime;
  final int? endTime;
  final int offset;
  final int count;

  const SearchFilterParam({
    required this.data,
    this.keyword,
    this.messageTypes,
    this.startTime,
    this.endTime,
    this.offset = 0,
    this.count = 40,
  });
}

class SearchFilterResult {
  final List<Map<String, dynamic>> filtered;

  SearchFilterResult(this.filtered);
}

/// 在 Isolate 中执行消息搜索的过滤逻辑
Future<SearchFilterResult> computeSearchFilter(SearchFilterParam param) {
  return compute(_searchFilterWorker, param);
}

SearchFilterResult _searchFilterWorker(SearchFilterParam param) {
  var filtered = param.data.where((msg) {
    if (param.keyword != null && param.keyword!.isNotEmpty) {
      final keyword = param.keyword!.toLowerCase();
      final ct = (msg['contentType'] as num?)?.toInt() ?? 0;
      final rawContent = msg['content'] as String? ?? '';
      // 图片(102)、语音(103)、视频(104) 有关键词时排除，与 Go SDK filterMsg 逻辑保持一致
      if (ct == 102 || ct == 103 || ct == 104) return false;
      // 其他类型解析内容 JSON，仅搜索对应文本字段
      String searchText;
      try {
        final Map<String, dynamic> contentMap = jsonDecode(rawContent) as Map<String, dynamic>;
        switch (ct) {
          case 101: // text
            searchText = (contentMap['content'] as String? ?? '').toLowerCase();
          case 106: // atText
            searchText = (contentMap['text'] as String? ?? '').toLowerCase();
          case 105: // file
            searchText = (contentMap['fileName'] as String? ?? '').toLowerCase();
          case 107: // merger
            searchText = (contentMap['title'] as String? ?? '').toLowerCase();
          case 108: // card
            searchText = (contentMap['nickname'] as String? ?? '').toLowerCase();
          case 109: // location
            searchText = (contentMap['description'] as String? ?? '').toLowerCase();
          case 110: // custom
            searchText = (contentMap['description'] as String? ?? '').toLowerCase();
          case 114: // quote
            searchText = (contentMap['text'] as String? ?? '').toLowerCase();
          default:
            searchText = rawContent.toLowerCase();
        }
      } catch (_) {
        searchText = rawContent.toLowerCase();
      }
      if (!searchText.contains(keyword)) return false;
    }
    if (param.messageTypes != null && param.messageTypes!.isNotEmpty) {
      final ct = (msg['contentType'] as num?)?.toInt() ?? 0;
      if (!param.messageTypes!.contains(ct)) return false;
    }
    if (param.startTime != null && param.startTime! > 0) {
      final st = (msg['sendTime'] as num?)?.toInt() ?? 0;
      if (st < param.startTime!) return false;
    }
    if (param.endTime != null && param.endTime! > 0) {
      final st = (msg['sendTime'] as num?)?.toInt() ?? 0;
      if (st > param.endTime!) return false;
    }
    return true;
  }).toList();

  if (param.offset > 0 && param.offset < filtered.length) {
    filtered = filtered.sublist(param.offset);
  } else if (param.offset >= filtered.length) {
    return SearchFilterResult([]);
  }
  if (filtered.length > param.count) {
    filtered = filtered.sublist(0, param.count);
  }
  return SearchFilterResult(filtered);
}

// ============================================================
// 6. 历史消息 Dart 层过滤
// ============================================================

class HistoryFilterParam {
  final List<Map<String, dynamic>> data;
  final int startTime;
  final int startSeq;
  final String startClientMsgID;
  final int count;

  const HistoryFilterParam({
    required this.data,
    required this.startTime,
    required this.startSeq,
    required this.startClientMsgID,
    required this.count,
  });
}

/// 在 Isolate 中过滤历史消息列表
Future<List<Map<String, dynamic>>> computeHistoryFilter(HistoryFilterParam param) {
  return compute(_historyFilterWorker, param);
}

List<Map<String, dynamic>> _historyFilterWorker(HistoryFilterParam param) {
  var data = param.data;
  if (param.startTime > 0 && data.isNotEmpty) {
    data = data.where((record) {
      final int sendTime = record['sendTime'] ?? 0;
      final int seq = record['seq'] ?? 0;
      final String clientMsgID = record['clientMsgID'] ?? '';

      if (sendTime < param.startTime) return true;
      if (sendTime == param.startTime) {
        if (param.startSeq > 0) return seq < param.startSeq;
        return seq <= param.startSeq && clientMsgID != param.startClientMsgID;
      }
      return false;
    }).toList();
  }
  return data.take(param.count).toList();
}

// ============================================================
// 内部工具
// ============================================================

/// 打开文件的同步方法（仅在 Isolate 内部使用，不影响主线程）
RandomAccessFile _openFileSync(String path) {
  return File(path).openSync();
}
