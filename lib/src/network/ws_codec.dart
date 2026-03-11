import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Go 的 GeneralWsReq 结构在 WebSocket 上的表示
class GeneralWsReq {
  final int reqIdentifier;
  final String token;
  final String sendID;
  final String operationID;
  final String msgIncr;
  final Uint8List data;

  GeneralWsReq({
    required this.reqIdentifier,
    this.token = '',
    this.sendID = '',
    this.operationID = '',
    this.msgIncr = '',
    Uint8List? data,
  }) : data = data ?? Uint8List(0);

  Map<String, dynamic> toJson() => {
    'reqIdentifier': reqIdentifier,
    'token': token,
    'sendID': sendID,
    'operationID': operationID,
    'msgIncr': msgIncr,
    'data': base64Encode(data),
  };
}

/// Go 的 GeneralWsResp 结构在 WebSocket 上的表示
class GeneralWsResp {
  final int reqIdentifier;
  final int errCode;
  final String errMsg;
  final String msgIncr;
  final String operationID;
  final Uint8List data;

  GeneralWsResp({
    this.reqIdentifier = 0,
    this.errCode = 0,
    this.errMsg = '',
    this.msgIncr = '',
    this.operationID = '',
    Uint8List? data,
  }) : data = data ?? Uint8List(0);

  factory GeneralWsResp.fromJson(Map<String, dynamic> json) {
    Uint8List data;
    if (json['data'] is String) {
      data = base64Decode(json['data'] as String);
    } else if (json['data'] is List) {
      data = Uint8List.fromList((json['data'] as List).cast<int>());
    } else {
      data = Uint8List(0);
    }
    return GeneralWsResp(
      reqIdentifier: json['reqIdentifier'] as int? ?? 0,
      errCode: json['errCode'] as int? ?? 0,
      errMsg: json['errMsg'] as String? ?? '',
      msgIncr: json['msgIncr'] as String? ?? '',
      operationID: json['operationID'] as String? ?? '',
      data: data,
    );
  }

  bool get isSuccess => errCode == 0;
}

/// 消息编解码工具
///
/// Go SDK 使用 GOB 编码 + Gzip 压缩。
/// 由于 GOB 是 Go 独有格式，Dart 无法直接解码。
/// OpenIM 在 JS/WASM 中使用 JSON 作为替代编码格式。
/// 本实现同样使用 JSON 编码（需后端配合开启 JSON 选项或直接连接 JS 网关）。
class WsCodec {
  final bool enableCompression;

  WsCodec({this.enableCompression = true});

  /// 编码请求为二进制数据
  Uint8List encode(GeneralWsReq req) {
    final jsonStr = jsonEncode(req.toJson());
    final raw = utf8.encode(jsonStr);
    if (enableCompression) {
      return Uint8List.fromList(gzip.encode(raw));
    }
    return Uint8List.fromList(raw);
  }

  /// 解码二进制数据为响应
  GeneralWsResp decode(Uint8List raw) {
    List<int> decompressed;
    if (enableCompression) {
      try {
        decompressed = gzip.decode(raw);
      } catch (_) {
        // 如果解压失败，尝试直接解析（可能未压缩）
        decompressed = raw;
      }
    } else {
      decompressed = raw;
    }
    final jsonStr = utf8.decode(decompressed);
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return GeneralWsResp.fromJson(json);
  }
}
