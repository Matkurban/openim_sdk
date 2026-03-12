import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../network/ws_codec.dart';
import '../network/ws_constants.dart';

/// WebSocket 长连接管理器
class WebSocketService {
  final Logger _log = Logger('WebSocketService');

  // ---- 配置 ----
  final String wsUrl;

  final int platformID;

  final OnConnectListener connectListener;

  WebSocketService({required this.wsUrl, required this.platformID, required this.connectListener});

  late String _userID;
  late String _token;
  late bool _compression;

  // ---- 编解码 ----
  late WsCodec _codec;

  // ---- 连接 ----
  WebSocketChannel? _channel;
  WsConnStatus _connStatus = WsConnStatus.notConnected;
  StreamSubscription? _subscription;

  // ---- 重连 ----
  static const _maxReconnectAttempts = 300;
  final _backoffIntervals = const [1, 2, 4, 8, 16];
  int _reconnectIndex = -1;
  int _reconnectAttempts = 0;
  bool _isReconnecting = false;
  bool _userDisconnected = false;

  // ---- 重连定时器 ----
  Timer? _reconnectTimer;

  // ---- 心跳 ----
  static const _pingPeriod = Duration(seconds: 24);
  Timer? _heartbeatTimer;
  DateTime? _lastPong;

  // ---- 请求/响应异步匹配 ----
  int _msgIncrCounter = 0;

  final Map<String, Completer<GeneralWsResp>> _pendingRequests = {};

  static const _requestTimeout = Duration(seconds: 10);

  /// 收到推送消息（原始 JSON data）
  void Function(GeneralWsResp resp)? onPushMsg;

  /// 用户在线状态变更
  void Function(GeneralWsResp resp)? onUserOnlineStatusChanged;

  /// 当前连接状态
  WsConnStatus get connStatus => _connStatus;

  /// 是否已连接
  bool get isConnected => _connStatus == WsConnStatus.connected;

  // ---------------------------------------------------------------------------
  // 连接生命周期
  // ---------------------------------------------------------------------------

  /// 初始化并建立连接
  ///
  /// [wsUrl] WebSocket 服务地址，如 ws://xxx:10001
  /// [userID] 当前用户 ID
  /// [token] 鉴权 token
  /// [platformID] 平台 ID
  /// [compression] 是否启用 gzip 压缩
  Future<void> connect({
    required String userID,
    required String token,
    bool compression = true,
  }) async {
    _userID = userID;
    _token = token;
    _compression = compression;
    _codec = WsCodec(enableCompression: compression);
    _userDisconnected = false;
    _reconnectAttempts = 0;
    _reconnectIndex = -1;
    await _doConnect();
  }

  /// 主动断开连接
  Future<void> disconnect() async {
    _userDisconnected = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _stopHeartbeat();
    _cancelAllPendingRequests('connection closed by user');
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
    _setStatus(WsConnStatus.closed);
    _log.info('WebSocket 已主动断开');
  }

  /// 发送请求并等待响应
  ///
  /// 对应 Go SDK SendReqWaitResp (long_conn_mgr.go)：
  ///   data, _ := proto.Marshal(m)       // protobuf 编码业务数据
  ///   msg := Message{Message: GeneralWsReq{..., Data: data}}
  ///   c.send <- msg
  ///
  /// [reqIdentifier] 请求类型
  /// [data] 请求数据（protobuf 序列化后的字节，即 proto.Marshal 的结果）
  /// 返回服务端响应
  Future<GeneralWsResp> sendReqWaitResp({
    required int reqIdentifier,
    Uint8List? data,
    String? operationID,
  }) async {
    if (!isConnected) {
      throw StateError('WebSocket 未连接');
    }
    final opID = operationID ?? _generateOperationID();
    final msgIncr = _generateMsgIncr();
    final req = GeneralWsReq(
      reqIdentifier: reqIdentifier,
      token: _token,
      sendID: _userID,
      operationID: opID,
      msgIncr: msgIncr,
      data: data,
    );

    final completer = Completer<GeneralWsResp>();
    _pendingRequests[msgIncr] = completer;

    // 超时处理
    final timer = Timer(_requestTimeout, () {
      if (_pendingRequests.containsKey(msgIncr)) {
        _pendingRequests.remove(msgIncr);
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('WebSocket 请求超时', _requestTimeout));
        }
      }
    });

    try {
      _sendBinary(req);
      final resp = await completer.future;
      return resp;
    } finally {
      timer.cancel();
      _pendingRequests.remove(msgIncr);
    }
  }

  // ---------------------------------------------------------------------------
  // 内部连接逻辑
  // ---------------------------------------------------------------------------

  Future<void> _doConnect() async {
    if (_connStatus == WsConnStatus.connecting) return;
    _setStatus(WsConnStatus.connecting);
    connectListener.onConnecting?.call();

    final url = _buildWsUrl();
    _log.info('正在连接 WebSocket: $url');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      await _channel!.ready;
      _startListening();

      // 连接成功
      _setStatus(WsConnStatus.connected);
      _reconnectAttempts = 0;
      _reconnectIndex = -1;

      _startHeartbeat();

      connectListener.onConnectSuccess?.call();
      _log.info('WebSocket 连接成功');
    } catch (e) {
      _log.warning('WebSocket 连接失败: $e');
      _setStatus(WsConnStatus.closed);
      _stopHeartbeat();
      connectListener.onConnectFailed?.call(-1, e.toString());
      _scheduleReconnect();
    }
  }

  String _buildWsUrl() {
    final sb = StringBuffer(wsUrl);
    sb.write('?sendID=$_userID');
    sb.write('&token=$_token');
    sb.write('&platformID=$platformID');
    sb.write('&operationID=${_generateOperationID()}');
    sb.write('&isBackground=false');
    sb.write('&sdkType=js');
    sb.write('&isMsgResp=true');
    if (_compression) {
      sb.write('&compression=gzip');
    }
    return sb.toString();
  }

  void _startListening() {
    _subscription?.cancel();
    _subscription = _channel?.stream.listen(_onMessage, onError: _onError, onDone: _onDone);
  }

  void _onMessage(dynamic message) {
    if (message is List<int>) {
      _handleBinaryMessage(Uint8List.fromList(message));
    } else if (message is String) {
      _handleTextMessage(message);
    }
  }

  /// 处理文本消息（ping/pong，对应 ws_js.go handlerText）
  void _handleTextMessage(String text) {
    try {
      final msg = jsonDecode(text) as Map<String, dynamic>;
      final type = msg['type'] as String? ?? '';
      switch (type) {
        case 'pong':
          _lastPong = DateTime.now();
          _log.fine('收到 pong');
        default:
          _log.warning('未知文本消息类型: $type');
      }
    } catch (e) {
      _log.warning('解析文本消息失败: $e');
    }
  }

  void _onError(dynamic error) {
    _log.warning('WebSocket 错误: $error');
    _handleDisconnect();
  }

  void _onDone() {
    _log.info('WebSocket 连接已关闭');
    _handleDisconnect();
  }

  void _handleDisconnect() {
    _setStatus(WsConnStatus.closed);
    _stopHeartbeat();
    _cancelAllPendingRequests('connection lost');
    if (!_userDisconnected) {
      _scheduleReconnect();
    }
  }

  // ---------------------------------------------------------------------------
  // 心跳（对应 Go SDK heartbeat + ws_js.go sendText）
  // ---------------------------------------------------------------------------

  void _startHeartbeat() {
    _stopHeartbeat();
    _lastPong = DateTime.now();
    _heartbeatTimer = Timer.periodic(_pingPeriod, (_) => _sendPing());
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// 发送 ping 文本消息（对应 ws_js.go WriteMessage(PingMessage, ...)）
  void _sendPing() {
    if (_channel == null || !isConnected) return;
    // 检测连接健康：如果超过 2 个心跳周期未收到 pong，视为连接断开
    if (_lastPong != null &&
        DateTime.now().difference(_lastPong!).inSeconds > _pingPeriod.inSeconds * 2) {
      _log.warning('超时未收到 pong，连接可能已断开');
      _handleDisconnect();
      return;
    }
    final opID = _generateOperationID();
    final ping = jsonEncode({'type': 'ping', 'body': jsonEncode(opID)});
    _channel!.sink.add(ping);
    _log.fine('发送 ping: $opID');
  }

  // ---------------------------------------------------------------------------
  // 消息处理
  // ---------------------------------------------------------------------------

  void _handleBinaryMessage(Uint8List raw) {
    // gzip 解压 + JSON 解码（sdkType=js 协议，data 字段为 base64 编码的 protobuf）
    GeneralWsResp resp;
    try {
      resp = _codec.decodeResp(raw);
    } catch (e) {
      _log.warning('消息解码失败: $e');
      return;
    }

    _log.fine(
      '收到消息: reqIdentifier=${resp.reqIdentifier}, '
      'errCode=${resp.errCode}, msgIncr=${resp.msgIncr}',
    );

    switch (resp.reqIdentifier) {
      case WsReqIdentifier.pushMsg:
        onPushMsg?.call(resp);

      case WsReqIdentifier.kickOnlineMsg:
        _log.warning('被踢下线');
        connectListener.onKickedOffline?.call();
        _userDisconnected = true;
        disconnect();

      case WsReqIdentifier.logoutMsg:
        _notifyResponse(resp);
        _userDisconnected = true;
        disconnect();

      case WsReqIdentifier.wsSubUserOnlineStatus:
        onUserOnlineStatusChanged?.call(resp);

      // 请求响应类消息，通过 msgIncr 匹配到对应的 Completer
      case WsReqIdentifier.getNewestSeq:
      case WsReqIdentifier.pullMsgByRange:
      case WsReqIdentifier.pullMsgBySeqList:
      case WsReqIdentifier.getConvMaxReadSeq:
      case WsReqIdentifier.pullConvLastMessage:
      case WsReqIdentifier.sendMsg:
      case WsReqIdentifier.sendSignalMsg:
      case WsReqIdentifier.setBackgroundStatus:
        _notifyResponse(resp);

      default:
        _log.warning('未知的 reqIdentifier: ${resp.reqIdentifier}');
    }
  }

  /// 将服务端响应路由到等待中的请求 Completer
  void _notifyResponse(GeneralWsResp resp) {
    final completer = _pendingRequests.remove(resp.msgIncr);
    if (completer != null && !completer.isCompleted) {
      completer.complete(resp);
    } else {
      _log.fine('无匹配请求: msgIncr=${resp.msgIncr}');
    }
  }

  void _sendBinary(GeneralWsReq req) {
    if (_channel == null) return;
    // JSON 编码 + gzip 压缩（sdkType=js 协议）
    final encoded = _codec.encodeReq(req);
    _channel!.sink.add(encoded);
  }

  // ---------------------------------------------------------------------------
  // 重连
  // ---------------------------------------------------------------------------

  void _scheduleReconnect() {
    if (_userDisconnected || _isReconnecting) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _log.severe('已达最大重连次数 ($_maxReconnectAttempts)，停止重连');
      connectListener.onConnectFailed?.call(-1, '超过最大重连次数');
      return;
    }

    _isReconnecting = true;
    _reconnectIndex++;
    final interval = _backoffIntervals[_reconnectIndex % _backoffIntervals.length];
    _reconnectAttempts++;

    _log.info('将在 ${interval}s 后重连 (第 $_reconnectAttempts 次)');
    _reconnectTimer = Timer(Duration(seconds: interval), () async {
      _reconnectTimer = null;
      _isReconnecting = false;
      if (_userDisconnected) return;
      await _doConnect();
    });
  }

  // ---------------------------------------------------------------------------
  // 工具方法
  // ---------------------------------------------------------------------------

  void _setStatus(WsConnStatus status) {
    _connStatus = status;
  }

  String _generateOperationID() {
    return '${_userID}_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateMsgIncr() {
    _msgIncrCounter++;
    return '${_userID}_${DateTime.now().millisecondsSinceEpoch}_$_msgIncrCounter';
  }

  void _cancelAllPendingRequests(String reason) {
    for (final entry in _pendingRequests.entries) {
      if (!entry.value.isCompleted) {
        entry.value.completeError(StateError(reason));
      }
    }
    _pendingRequests.clear();
  }
}
