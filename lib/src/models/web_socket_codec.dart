import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:meta/meta.dart';

/// 通用 WebSocket 请求
/// 对应 JS SDK 的 GeneralWsReq
///
/// WebSocket 协议（sdkType=js）：
/// 1. 消息编码：JSON（data 字段为 base64 编码的 protobuf 字节）
/// 2. 传输方式：二进制 (gzip 压缩的 JSON) 或文本 (ping/pong)
/// 3. 压缩：gzip（可选）
@internal
class WebSocketRequest {
  final int reqIdentifier;
  final String token;
  final String sendID;
  final String operationID;
  String msgIncr;
  final Uint8List data;

  WebSocketRequest({
    required this.reqIdentifier,
    this.token = '',
    this.sendID = '',
    this.operationID = '',
    this.msgIncr = '',
    Uint8List? data,
  }) : data = data ?? Uint8List(0);
}

/// 通用 WebSocket 响应
/// 对应 JS SDK 的 GeneralWsResp
class WebSocketResponse {
  final int reqIdentifier;
  final int errCode;
  final String errMsg;
  final String msgIncr;
  final String operationID;
  final Uint8List data;

  WebSocketResponse({
    this.reqIdentifier = 0,
    this.errCode = 0,
    this.errMsg = '',
    this.msgIncr = '',
    this.operationID = '',
    Uint8List? data,
  }) : data = data ?? Uint8List(0);

  bool get isSuccess => errCode == 0;
}

// ==========================================================================
// WebSocket 编解码器（JSON + gzip，sdkType=js）
//
// 当 sdkType=js 时，服务端使用 JSON 协议：
//   发送: GeneralWsReq → JSON（data 为 base64） → gzip → conn.WriteMessage
//   接收: conn.ReadMessage → gzip 解压 → JSON → GeneralWsResp（data 从 base64 还原）
// ==========================================================================
@internal
class WebSocketCodecs {
  final bool enableCompression;

  WebSocketCodecs({this.enableCompression = true});

  /// 编码 GeneralWsReq 为可发送的二进制数据（JSON + gzip 压缩）
  ///
  /// data 字段使用 base64 编码，与 JS SDK 协议一致。
  Uint8List encodeRequest(WebSocketRequest request) {
    final map = <String, dynamic>{
      'reqIdentifier': request.reqIdentifier,
      'token': request.token,
      'sendID': request.sendID,
      'operationID': request.operationID,
      'msgIncr': request.msgIncr,
      'data': request.data.isNotEmpty ? base64Encode(request.data) : '',
    };
    final jsonBytes = utf8.encode(jsonEncode(map));
    if (enableCompression) {
      return Uint8List.fromList(gzip.encode(jsonBytes));
    }
    return Uint8List.fromList(jsonBytes);
  }

  /// 解码接收到的二进制数据为 GeneralWsResp（gzip 解压 + JSON 解码）
  ///
  /// 服务端返回 gzip 压缩的 JSON，其中 data 字段为 base64 编码的 protobuf 字节。
  WebSocketResponse decodeResponse(Uint8List data) {
    Uint8List decompressed;
    if (enableCompression) {
      decompressed = Uint8List.fromList(gzip.decode(data));
    } else {
      decompressed = data;
    }
    final jsonStr = utf8.decode(decompressed);
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;

    final dataStr = map['data'] as String? ?? '';
    final dataBytes = dataStr.isNotEmpty ? Uint8List.fromList(base64Decode(dataStr)) : Uint8List(0);

    return WebSocketResponse(
      reqIdentifier: map['reqIdentifier'] as int? ?? 0,
      errCode: map['errCode'] as int? ?? 0,
      errMsg: map['errMsg'] as String? ?? '',
      msgIncr: map['msgIncr'] as String? ?? '',
      operationID: map['operationID'] as String? ?? '',
      data: dataBytes,
    );
  }
}
