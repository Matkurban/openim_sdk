import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import '../utils/gzip_util.dart';

/// 通用 WebSocket 请求
/// 对应 JS SDK 的 GeneralWsReq
///
/// WebSocket 协议（sdkType=js）：
/// 1. 消息编码：JSON（data 字段为 base64 编码的 protobuf 字节）
/// 2. 传输方式：二进制 (gzip 压缩的 JSON) 或文本 (ping/pong)
/// 3. 压缩：gzip（可选）
@internal
class WebSocketRequest {
  /// 请求参数标识符。
  ///
  /// Request identifier.
  final int reqIdentifier;

  /// 令牌。
  ///
  /// Token.
  final String token;

  /// 发送ID。
  ///
  /// Send ID.
  final String sendID;

  /// operationID。
  ///
  /// Operation ID.
  final String operationID;

  /// 消息递增。
  ///
  /// Message increment.
  String msgIncr;

  /// 数据。
  ///
  /// Data.
  final Uint8List data;

  /// 创建 `WebSocketRequest` 实例。
  ///
  /// Creates a `WebSocketRequest` instance.
  ///
  /// - [reqIdentifier] 请求参数标识符 / Request identifier.
  /// - [token] 令牌 / Token.
  /// - [sendID] 发送ID / Send ID.
  /// - [operationID] operationID / Operation ID.
  /// - [msgIncr] 消息递增 / Message increment.
  /// - [data] 数据 / Data.
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
  /// 请求参数标识符。
  ///
  /// Request identifier.
  final int reqIdentifier;

  /// 错误代码。
  ///
  /// Error code.
  final int errCode;

  /// 错误消息。
  ///
  /// Error message.
  final String errMsg;

  /// 消息递增。
  ///
  /// Message increment.
  final String msgIncr;

  /// operationID。
  ///
  /// Operation ID.
  final String operationID;

  /// 数据。
  ///
  /// Data.
  final Uint8List data;

  /// 创建 `WebSocketResponse` 实例。
  ///
  /// Creates a `WebSocketResponse` instance.
  ///
  /// - [reqIdentifier] 请求参数标识符 / Request identifier.
  /// - [errCode] 错误代码 / Error code.
  /// - [errMsg] 错误消息 / Error message.
  /// - [msgIncr] 消息递增 / Message increment.
  /// - [operationID] operationID / Operation ID.
  /// - [data] 数据 / Data.
  WebSocketResponse({
    this.reqIdentifier = 0,
    this.errCode = 0,
    this.errMsg = '',
    this.msgIncr = '',
    this.operationID = '',
    Uint8List? data,
  }) : data = data ?? Uint8List(0);

  /// 是否Success。
  ///
  /// Whether success.
  bool get isSuccess => errCode == 0;
}

// ==========================================================================
// WebSocket 编解码器（JSON + gzip，sdkType=js）
//
// 当 sdkType=js 时，服务端使用 JSON 协议：
//   发送: GeneralWsReq → JSON（data 为 base64） → gzip → conn.WriteMessage
//   接收: conn.ReadMessage → gzip 解压 → JSON → GeneralWsResp（data 从 base64 还原）
// ==========================================================================
/// WebSocket编解码器。
///
/// Web socket codecs.
@internal
class WebSocketCodecs {
  /// 是否启用压缩。
  ///
  /// Whether enabled compression.
  final bool enableCompression;

  /// 创建 `WebSocketCodecs` 实例。
  ///
  /// Creates a `WebSocketCodecs` instance.
  ///
  /// - [enableCompression] 是否启用压缩 / Whether enabled compression.
  WebSocketCodecs({this.enableCompression = true});

  /// 编码 GeneralWsReq 为可发送的二进制数据（JSON + gzip 压缩）
  ///
  /// data 字段使用 base64 编码，与 JS SDK 协议一致。
  ///
  /// - [request] 申请/请求 / Request.
  /// - Returns: `Uint8List` 结果 / Resulting `Uint8List`.
  Uint8List encodeRequest(WebSocketRequest request) {
    final Map<String, dynamic> map = <String, dynamic>{
      'reqIdentifier': request.reqIdentifier,
      'token': request.token,
      'sendID': request.sendID,
      'operationID': request.operationID,
      'msgIncr': request.msgIncr,
      'data': request.data.isNotEmpty ? base64Encode(request.data) : '',
    };
    final List<int> jsonBytes = utf8.encode(jsonEncode(map));
    if (enableCompression) {
      return Uint8List.fromList(gzipEncode(jsonBytes));
    }
    return Uint8List.fromList(jsonBytes);
  }

  /// 解码接收到的二进制数据为 GeneralWsResp（gzip 解压 + JSON 解码）
  ///
  /// 服务端返回 gzip 压缩的 JSON，其中 data 字段为 base64 编码的 protobuf 字节。
  ///
  /// - [data] 数据 / Data.
  /// - Returns: `WebSocketResponse` 结果 / Resulting `WebSocketResponse`.
  WebSocketResponse decodeResponse(Uint8List data) {
    Uint8List decompressed;
    if (enableCompression) {
      decompressed = Uint8List.fromList(gzipDecode(data));
    } else {
      decompressed = data;
    }
    final String jsonStr = utf8.decode(decompressed);
    final Map<String, dynamic> map = jsonDecode(jsonStr) as Map<String, dynamic>;

    final String dataStr = map['data'] as String? ?? '';
    final Uint8List dataBytes = dataStr.isNotEmpty
        ? Uint8List.fromList(base64Decode(dataStr))
        : Uint8List(0);

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
