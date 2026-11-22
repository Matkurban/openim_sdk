import 'dart:async';
import 'dart:convert';
import 'dart:math' show min;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../enums/sdk_error_code.dart';
import '../enums/web_socket_status.dart';
import '../listener/connect_listener.dart';
import '../models/openim_exception.dart';
import '../models/web_socket_codec.dart';
import '../models/web_socket_identifier.dart';
import '../utils/open_im_utils.dart';
import 'web_socket_js_interop_stub.dart'
    if (dart.library.js_interop) 'web_socket_js_interop_web.dart';

/// WebSocket 长连接管理器。
///
/// 对齐 `xue_hua_sdk/rust/src/core/connection.rs` 修复：
/// - B-12：引入 `_connGeneration` 连接代际号，彻底屏蔽旧连接的延迟 onError/onDone 误杀新连接；
/// - B-13：`setBackground` 主动发送 `SET_BACKGROUND_STATUS`；心跳超时主动关闭半开连接；
///   指数退避封顶 16s（不再 `%` 取模回绕成重连风暴）。
class WebSocketService {
  final Logger _logger = Logger('openim_sdk.WebSocketService');

  final String wsUrl;
  final int platformID;
  final OnConnectListener connectListener;

  WebSocketService({required this.wsUrl, required this.platformID, required this.connectListener});

  String _userID = '';
  String _token = '';
  bool _compression = false;
  bool _isBackground = false;

  late WebSocketCodecs _codec;

  WebSocketChannel? _channel;
  WebSocketStatus _connStatus = WebSocketStatus.notConnected;
  StreamSubscription<dynamic>? _subscription;

  /// 连接代际号：每次建连自增，过滤已被取代连接的迟到回调。
  int _connGeneration = 0;

  static const int _maxReconnectAttempts = 300;
  static const List<int> _backoffIntervals = <int>[1, 2, 4, 8, 16];
  int _reconnectAttempts = 0;
  bool _isReconnecting = false;
  bool _userDisconnected = false;
  Timer? _reconnectTimer;

  static const Duration _pingPeriod = Duration(seconds: 24);
  Timer? _heartbeatTimer;
  DateTime? _lastPong;

  int _msgIncrCounter = 0;
  final Map<String, Completer<WebSocketResponse>> _pendingRequests =
      <String, Completer<WebSocketResponse>>{};
  static const Duration _requestTimeout = Duration(seconds: 10);

  void Function(WebSocketResponse response)? onPushMsg;
  void Function()? onConnected;
  void Function(WebSocketResponse response)? onUserOnlineStatusChanged;

  WebSocketStatus get connStatus => _connStatus;

  bool get isConnected => _connStatus == WebSocketStatus.connected;

  /// 建立 WebSocket 长连接。
  Future<void> connect({
    required String userID,
    required String token,
    bool compression = true,
  }) async {
    _logger.info('connect userID=$userID compression=$compression');
    _userID = userID;
    _token = token;
    _compression = kIsWeb ? false : compression;
    _codec = WebSocketCodecs(enableCompression: _compression);
    _userDisconnected = false;
    _isReconnecting = false;
    _reconnectAttempts = 0;
    await _doConnect();
  }

  /// 主动断开连接并清理所有回调与定时器。
  Future<void> disconnect() async {
    _logger.info('disconnect called');
    _userDisconnected = true;
    _connGeneration++;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _isReconnecting = false;
    _stopHeartbeat();
    _cancelAllPendingRequests('connection closed by user');
    await _closeCurrentTransport();
    _connStatus = WebSocketStatus.closed;
  }

  /// 上报前后台状态到服务端（对齐 `connection.rs:set_background`，修复 B-13）。
  Future<void> setBackground(bool isBackground) async {
    _logger.fine('setBackground=$isBackground');
    _isBackground = isBackground;
    if (!isConnected) {
      return;
    }
    try {
      final Uint8List payload = Uint8List.fromList(
        utf8.encode(jsonEncode(<String, dynamic>{'isBackground': isBackground})),
      );
      await sendRequestWaitResponse(
        reqIdentifier: WebSocketIdentifier.setBackgroundStatus,
        data: payload,
      );
    } on Object catch (error, stackTrace) {
      _logger.warning('Failed to report background status', error, stackTrace);
    }
  }

  /// 网络状态变化时强制断开旧连接并立即触发重连。
  Future<void> reconnect() async {
    _logger.info('reconnect called');
    if (_userDisconnected) {
      return;
    }
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _isReconnecting = false;
    _stopHeartbeat();
    _cancelAllPendingRequests('network status changed');
    await _closeCurrentTransport();
    _reconnectAttempts = 0;
    await _doConnect();
  }

  /// 发送二进制协议请求并等待匹配的响应。
  Future<WebSocketResponse> sendRequestWaitResponse({
    required int reqIdentifier,
    Uint8List? data,
  }) async {
    if (!isConnected) {
      throw OpenIMException(
        code: SDKErrorCode.websocketNotConnected.code,
        message: SDKErrorCode.websocketNotConnected.message,
      );
    }
    final String msgIncr = _generateMsgIncr();
    final WebSocketRequest req = WebSocketRequest(
      reqIdentifier: reqIdentifier,
      token: _token,
      sendID: _userID,
      operationID: OpenImUtils.generateOperationID(),
      msgIncr: msgIncr,
      data: data,
    );
    final Completer<WebSocketResponse> completer = Completer<WebSocketResponse>();
    _pendingRequests[msgIncr] = completer;

    final Timer timer = Timer(_requestTimeout, () {
      if (_pendingRequests.remove(msgIncr) != null && !completer.isCompleted) {
        completer.completeError(TimeoutException('WebSocket 请求超时', _requestTimeout));
      }
    });

    try {
      _sendBinary(req);
      return await completer.future;
    } finally {
      timer.cancel();
      _pendingRequests.remove(msgIncr);
    }
  }

  Future<void> _doConnect() async {
    if (kIsWeb) {
      disposeOldWsFromJsGlobal();
    }
    if (_connStatus == WebSocketStatus.connecting) {
      return;
    }

    final int generation = ++_connGeneration;
    _connStatus = WebSocketStatus.connecting;
    connectListener.onConnecting?.call();

    final String url = _buildWsUrl();
    try {
      await _closeCurrentTransport();
      final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(url));
      await channel.ready;

      if (generation != _connGeneration || _userDisconnected) {
        await channel.sink.close();
        return;
      }

      _channel = channel;
      _subscription = channel.stream.listen(
        (dynamic message) => _onMessage(generation, message),
        onError: (Object error) => _onTransportClosed(generation, 'socket error: $error'),
        onDone: () => _onTransportClosed(generation, 'socket closed'),
      );

      if (kIsWeb) {
        final StreamSubscription<dynamic>? sub = _subscription;
        registerDisposeInJsGlobal(() {
          sub?.cancel();
          channel.sink.close();
        });
      }

      _connStatus = WebSocketStatus.connected;
      _reconnectAttempts = 0;
      _startHeartbeat(generation);
      connectListener.onConnectSuccess?.call();
      onConnected?.call();
    } on Object catch (error) {
      if (generation != _connGeneration) {
        return;
      }
      _connStatus = WebSocketStatus.closed;
      _stopHeartbeat();
      final String errText = error.toString();
      final int? errCode = _tryParseErrCodeFromText(errText);
      final bool handledAuthError = _handleAuthHandshakeError(errCode);
      connectListener.onConnectFailed?.call(errCode ?? -1, errText);
      if (!handledAuthError) {
        _scheduleReconnect();
      }
    }
  }

  Future<void> _closeCurrentTransport() async {
    final StreamSubscription<dynamic>? sub = _subscription;
    _subscription = null;
    final WebSocketChannel? ch = _channel;
    _channel = null;
    try {
      await sub?.cancel();
    } catch (_) {}
    try {
      await ch?.sink.close();
    } catch (_) {}
  }

  String _buildWsUrl() {
    final StringBuffer buffer = StringBuffer(wsUrl)
      ..write('?sendID=$_userID')
      ..write('&token=$_token')
      ..write('&platformID=$platformID')
      ..write('&operationID=${OpenImUtils.generateOperationID()}')
      ..write('&isBackground=$_isBackground')
      ..write('&sdkType=js')
      ..write('&isMsgResp=true');
    if (_compression) {
      buffer.write('&compression=gzip');
    }
    return buffer.toString();
  }

  void _onMessage(int generation, dynamic message) {
    if (generation != _connGeneration) {
      return;
    }
    if (message is Uint8List) {
      _handleBinaryMessage(message);
    } else if (message is List<int>) {
      _handleBinaryMessage(Uint8List.fromList(message));
    } else if (message is String) {
      _handleTextMessage(message);
    }
  }

  void _onTransportClosed(int generation, String reason) {
    if (generation != _connGeneration) {
      _logger.fine('Ignore stale disconnect gen=$generation current=$_connGeneration');
      return;
    }
    _logger.warning('WebSocket disconnected: $reason');
    _connStatus = WebSocketStatus.closed;
    _stopHeartbeat();
    _cancelAllPendingRequests(reason);
    unawaited(_closeCurrentTransport());
    if (!_userDisconnected) {
      _scheduleReconnect();
    }
  }

  void _handleTextMessage(String text) {
    try {
      final Map<String, dynamic> msg = jsonDecode(text) as Map<String, dynamic>;
      final String type = msg['type'] as String? ?? '';
      if (type == 'pong') {
        _lastPong = DateTime.now();
        return;
      }
      if (type.isEmpty) {
        final int? errCode = (msg['errCode'] as num?)?.toInt() ?? (msg['code'] as num?)?.toInt();
        if (errCode != null && errCode != 0) {
          _handleAuthHandshakeError(errCode);
        }
        return;
      }
      _logger.warning('Unknown WS text message type: $type');
    } on Object catch (error, stackTrace) {
      _logger.warning('Failed to parse WS text message', error, stackTrace);
    }
  }

  void _handleBinaryMessage(Uint8List raw) {
    final WebSocketResponse resp;
    try {
      resp = _codec.decodeResponse(raw);
    } on Object catch (error, stackTrace) {
      _logger.warning('Failed to decode WS binary frame', error, stackTrace);
      return;
    }

    switch (resp.reqIdentifier) {
      case WebSocketIdentifier.pushMsg:
        onPushMsg?.call(resp);
      case WebSocketIdentifier.kickOnlineMsg:
        _logger.warning('Received kickOnlineMsg');
        connectListener.onKickedOffline?.call();
        unawaited(disconnect());
      case WebSocketIdentifier.logoutMsg:
        _notifyResponse(resp);
        unawaited(disconnect());
      case WebSocketIdentifier.wsSubUserOnlineStatus:
        onUserOnlineStatusChanged?.call(resp);
      case WebSocketIdentifier.getNewestSeq:
      case WebSocketIdentifier.pullMsgByRange:
      case WebSocketIdentifier.pullMsgBySeqList:
      case WebSocketIdentifier.getConvMaxReadSeq:
      case WebSocketIdentifier.pullConvLastMessage:
      case WebSocketIdentifier.sendMsg:
      case WebSocketIdentifier.sendSignalMsg:
      case WebSocketIdentifier.setBackgroundStatus:
        _notifyResponse(resp);
      default:
        _logger.warning('Unknown reqIdentifier: ${resp.reqIdentifier}');
    }
  }

  void _notifyResponse(WebSocketResponse resp) {
    final Completer<WebSocketResponse>? completer = _pendingRequests.remove(resp.msgIncr);
    if (completer != null && !completer.isCompleted) {
      completer.complete(resp);
    }
  }

  void _sendBinary(WebSocketRequest req) {
    final WebSocketChannel? ch = _channel;
    if (ch == null) {
      return;
    }
    final Uint8List encoded = _codec.encodeRequest(req);
    ch.sink.add(encoded);
  }

  void _startHeartbeat(int generation) {
    _stopHeartbeat();
    _lastPong = DateTime.now();
    _heartbeatTimer = Timer.periodic(_pingPeriod, (_) => _sendPing(generation));
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _sendPing(int generation) {
    if (generation != _connGeneration || _channel == null || !isConnected) {
      return;
    }
    if (_lastPong != null &&
        DateTime.now().difference(_lastPong!).inSeconds > _pingPeriod.inSeconds * 2) {
      _logger.warning('Heartbeat pong timeout, closing stale socket');
      _onTransportClosed(generation, 'heartbeat timeout');
      return;
    }
    final String ping = jsonEncode(<String, String>{
      'type': 'ping',
      'body': OpenImUtils.generateOperationID(),
    });
    _channel?.sink.add(ping);
  }

  void _scheduleReconnect() {
    if (_userDisconnected || _isReconnecting) {
      return;
    }
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _logger.severe('Exceeded max reconnect attempts ($_maxReconnectAttempts)');
      connectListener.onConnectFailed?.call(-1, '超过最大重连次数');
      return;
    }
    _isReconnecting = true;
    final int backoffIndex = min(_reconnectAttempts, _backoffIntervals.length - 1);
    final int interval = _backoffIntervals[backoffIndex];
    _reconnectAttempts++;
    _logger.info('Scheduling reconnect in ${interval}s (attempt $_reconnectAttempts)');
    _reconnectTimer = Timer(Duration(seconds: interval), () async {
      _reconnectTimer = null;
      _isReconnecting = false;
      if (_userDisconnected) {
        return;
      }
      await _doConnect();
    });
  }

  bool _handleAuthHandshakeError(int? errCode) {
    if (errCode == null) {
      return false;
    }
    if (errCode == 1501) {
      connectListener.userTokenExpired();
    } else if (errCode == 1506) {
      connectListener.kickedOffline();
    } else if (errCode == 1502 ||
        errCode == 1503 ||
        errCode == 1504 ||
        errCode == 1505 ||
        errCode == 1507) {
      connectListener.userTokenInvalid();
    } else {
      return false;
    }
    _userDisconnected = true;
    return true;
  }

  int? _tryParseErrCodeFromText(String text) {
    final RegExpMatch? match = RegExp(r'(?:errCode|code)\s*[:=]\s*(\d{4,5})').firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '');
    }
    final RegExpMatch? known = RegExp(r'\b(1501|1502|1503|1504|1505|1506|1507)\b').firstMatch(text);
    if (known != null) {
      return int.tryParse(known.group(1) ?? '');
    }
    return null;
  }

  String _generateMsgIncr() {
    _msgIncrCounter++;
    return '${_userID}_${DateTime.now().millisecondsSinceEpoch}_$_msgIncrCounter';
  }

  void _cancelAllPendingRequests(String reason) {
    for (final Completer<WebSocketResponse> completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError(StateError(reason));
      }
    }
    _pendingRequests.clear();
  }
}
