import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:aoiwe_logger/aoiwe_logger.dart';

import '../enums/web_socket_status.dart';
import '../models/web_socket_codec.dart';
import '../models/web_socket_identifier.dart';
// Web 热重启专用：JS interop 代码通过条件导入隔离，非 web 平台使用 stub。
import 'web_socket_js_interop_stub.dart'
    if (dart.library.js_interop) 'web_socket_js_interop_web.dart';

/// WebSocket 长连接管理器
class WebSocketService {
  final AoiweLogger _log = AoiweLogger('WebSocketService');

  final String wsUrl;

  final int platformID;

  final OnConnectListener connectListener;

  WebSocketService({required this.wsUrl, required this.platformID, required this.connectListener});

  late String _userID;
  late String _token;
  late bool _compression;
  bool _isBackground = false;

  // ---- 编解码 ----
  late WebSocketCodecs _codec;

  // ---- 连接 ----
  WebSocketChannel? _channel;
  WebSocketStatus _connStatus = WebSocketStatus.notConnected;
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

  ///发送完待处理的请求
  final Map<String, Completer<WebSocketResponse>> _pendingRequests = {};

  ///请求超时时间
  static const _requestTimeout = Duration(seconds: 10);

  /// 收到推送消息（原始 JSON data）
  void Function(WebSocketResponse response)? onPushMsg;

  /// 连接成功（含重连成功）后的统一回调
  void Function()? onConnected;

  /// 用户在线状态变更
  void Function(WebSocketResponse response)? onUserOnlineStatusChanged;

  /// 当前连接状态
  WebSocketStatus get connStatus => _connStatus;

  /// 是否已连接
  bool get isConnected => _connStatus == WebSocketStatus.connected;

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
    _log.info(
      'userID=$userID, compression=$compression, token=${token.isNotEmpty ? "***" : ""}',
      methodName: 'connect',
    );
    try {
      _userID = userID;
      _token = token;
      // dart:io 的 gzip 在 Web 平台不可用，自动禁用压缩
      _compression = kIsWeb ? false : compression;
      _codec = WebSocketCodecs(enableCompression: _compression);
      _userDisconnected = false;
      _isReconnecting = false;
      _reconnectAttempts = 0;
      _reconnectIndex = -1;
      await _doConnect();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'connect');
      rethrow;
    }
  }

  /// 主动断开连接
  Future<void> disconnect() async {
    _log.info('called', methodName: 'disconnect');
    try {
      _userDisconnected = true;
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      _stopHeartbeat();
      _cancelAllPendingRequests('connection closed by user');
      await _subscription?.cancel();
      _subscription = null;
      await _channel?.sink.close();
      _channel = null;
      _setStatus(WebSocketStatus.closed);
      _log.info('WebSocket 已主动断开');
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'disconnect');
      rethrow;
    }
  }

  /// 设置前后台状态
  void setBackground(bool isBackground) {
    _log.info('isBackground: $isBackground', methodName: 'setBackground');
    try {
      _isBackground = isBackground;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'setBackground');
      rethrow;
    }
  }

  /// 断开后重连（对应 Go SDK NetworkStatusChanged → Close → 自动重连）
  Future<void> reconnect() async {
    _log.info('called', methodName: 'reconnect');
    try {
      if (_userDisconnected) return;
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      _stopHeartbeat();
      _cancelAllPendingRequests('network status changed');
      await _subscription?.cancel();
      _subscription = null;
      await _channel?.sink.close();
      _channel = null;
      _reconnectAttempts = 0;
      _reconnectIndex = -1;
      await _doConnect();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'reconnect');
      rethrow;
    }
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
  Future<WebSocketResponse> sendRequestWaitResponse({
    required int reqIdentifier,
    Uint8List? data,
  }) async {
    _log.info('reqIdentifier=$reqIdentifier', methodName: 'sendRequestWaitResponse');
    try {
      if (!isConnected) {
        throw OpenIMException(
          code: SDKErrorCode.websocketNotConnected.code,
          message: 'WebSocket 未连接',
        );
      }
      final msgIncr = _generateMsgIncr();
      final req = WebSocketRequest(
        reqIdentifier: reqIdentifier,
        token: _token,
        sendID: _userID,
        operationID: OpenImUtils.generateOperationID(),
        msgIncr: msgIncr,
        data: data,
      );
      final completer = Completer<WebSocketResponse>();
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
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'sendRequestWaitResponse');
      rethrow;
    }
  }

  /// 处理握手阶段鉴权类错误（token 过期/无效/被踢）
  /// 返回值用于决定是否允许继续重连。
  bool _handleAuthHandshakeError(int? errCode, String? errMsg) {
    if (errCode == null) return false;
    // 这些错误属于鉴权失败：停止自动重连，并交由上层清理登录态
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
    // 优先匹配 4~5 位 errCode/codes，后续再粗匹配已知鉴权码
    final match = RegExp(r'(?:errCode|code)\s*[:=]\s*(\d{4,5})').firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '');
    }
    final known = RegExp(r'\b(1501|1502|1503|1504|1505|1506|1507)\b').firstMatch(text);
    if (known != null) {
      return int.tryParse(known.group(1) ?? '');
    }
    return null;
  }

  Future<void> _doConnect() async {
    try {
      // 热重启时先释放上一轮残留的 WebSocket 订阅，阻止其继续触发已销毁的 EngineFlutterView
      _disposeOldWebSocketFromJsGlobal();
      if (_connStatus == WebSocketStatus.connecting) return;
      _setStatus(WebSocketStatus.connecting);
      connectListener.onConnecting?.call();
      final url = _buildWsUrl();
      try {
        _channel = WebSocketChannel.connect(Uri.parse(url));
        await _channel!.ready;
        _startListening();
        // 连接成功后注册本次连接的释放回调，供下次热重启时调用
        _registerDisposeInJsGlobal();
        // 连接成功
        _setStatus(WebSocketStatus.connected);
        _reconnectAttempts = 0;
        _reconnectIndex = -1;
        _startHeartbeat();
        connectListener.onConnectSuccess?.call();
        onConnected?.call();
      } catch (e) {
        _setStatus(WebSocketStatus.closed);
        _stopHeartbeat();
        final errText = e.toString();
        final errCode = _tryParseErrCodeFromText(errText);
        // 鉴权类错误不允许重连（避免循环无效 token）
        final handledAuthError = _handleAuthHandshakeError(errCode, errText);
        connectListener.onConnectFailed?.call(errCode ?? -1, errText);
        if (!handledAuthError) {
          _scheduleReconnect();
        }
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_doConnect');
      rethrow;
    }
  }

  String _buildWsUrl() {
    try {
      final sb = StringBuffer(wsUrl);
      sb.write('?sendID=$_userID');
      sb.write('&token=$_token');
      sb.write('&platformID=$platformID');
      sb.write('&operationID=${OpenImUtils.generateOperationID()}');
      sb.write('&isBackground=$_isBackground');
      sb.write('&sdkType=js');
      sb.write('&isMsgResp=true');
      if (_compression) {
        sb.write('&compression=gzip');
      }
      return sb.toString();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_buildWsUrl');
      rethrow;
    }
  }

  void _startListening() {
    try {
      _subscription?.cancel();
      _subscription = _channel?.stream.listen(_onMessage, onError: _onError, onDone: _onDone);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_startListening');
      rethrow;
    }
  }

  void _onMessage(dynamic message) {
    try {
      // Uint8List 是 List<int> 的子类型，先检查更具体的类型以避免不必要的 copy
      if (message is Uint8List) {
        _handleBinaryMessage(message);
      } else if (message is List<int>) {
        _handleBinaryMessage(Uint8List.fromList(message));
      } else if (message is String) {
        _handleTextMessage(message);
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onMessage');
      rethrow;
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
        case '':
          // 服务端连接/握手响应 {errCode, errMsg, errDlt}，无 type 字段
          final errCodeNum = (msg['errCode'] as num?)?.toInt() ?? (msg['code'] as num?)?.toInt();
          if (errCodeNum != null && errCodeNum != 0) {
            _handleAuthHandshakeError(errCodeNum, msg['errMsg'] as String? ?? text);
          }
          break;
        default:
          _log.warning('未知文本消息类型: $type', methodName: '_handleTextMessage');
      }
    } catch (e, s) {
      _log.warning('解析文本消息失败:', error: e, stackTrace: s, methodName: '_handleTextMessage');
    }
  }

  void _onError(dynamic error) {
    try {
      _handleDisconnect();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onError');
      rethrow;
    }
  }

  void _onDone() {
    try {
      _handleDisconnect();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_onDone');
      rethrow;
    }
  }

  void _handleDisconnect() {
    try {
      _setStatus(WebSocketStatus.closed);
      _stopHeartbeat();
      _cancelAllPendingRequests('connection lost');
      if (!_userDisconnected) {
        _scheduleReconnect();
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_handleDisconnect');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 心跳（对应 Go SDK heartbeat + ws_js.go sendText）
  // ---------------------------------------------------------------------------

  void _startHeartbeat() {
    try {
      _stopHeartbeat();
      _lastPong = DateTime.now();
      _heartbeatTimer = Timer.periodic(_pingPeriod, (_) => _sendPing());
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_startHeartbeat');
      rethrow;
    }
  }

  void _stopHeartbeat() {
    try {
      _heartbeatTimer?.cancel();
      _heartbeatTimer = null;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_stopHeartbeat');
      rethrow;
    }
  }

  /// 发送 ping 文本消息（对应 ws_js.go WriteMessage(PingMessage, ...)）
  void _sendPing() {
    try {
      if (_channel == null || !isConnected) return;
      // 检测连接健康：如果超过 2 个心跳周期未收到 pong，视为连接断开
      if (_lastPong != null &&
          DateTime.now().difference(_lastPong!).inSeconds > _pingPeriod.inSeconds * 2) {
        _log.warning('超时未收到 pong，连接可能已断开', methodName: '_sendPing');
        _handleDisconnect();
        return;
      }
      final opID = OpenImUtils.generateOperationID();
      final ping = jsonEncode({'type': 'ping', 'body': opID});
      _channel!.sink.add(ping);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_sendPing');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 消息处理
  // ---------------------------------------------------------------------------

  void _handleBinaryMessage(Uint8List raw) {
    try {
      // gzip 解压 + JSON 解码（sdkType=js 协议，data 字段为 base64 编码的 protobuf）
      WebSocketResponse resp;
      try {
        resp = _codec.decodeResponse(raw);
      } catch (e, s) {
        _log.warning('消息解码失败,跳过此消息: ', error: e, stackTrace: s, methodName: '_handleBinaryMessage');
        return;
      }
      switch (resp.reqIdentifier) {
        case WebSocketIdentifier.pushMsg:
          onPushMsg?.call(resp);

        case WebSocketIdentifier.kickOnlineMsg:
          _log.warning('被踢下线', methodName: '_handleBinaryMessage');
          connectListener.onKickedOffline?.call();
          _userDisconnected = true;
          disconnect();

        case WebSocketIdentifier.logoutMsg:
          _notifyResponse(resp);
          _userDisconnected = true;
          disconnect();

        case WebSocketIdentifier.wsSubUserOnlineStatus:
          onUserOnlineStatusChanged?.call(resp);

        // 请求响应类消息，通过 msgIncr 匹配到对应的 Completer
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
          _log.warning(
            '未知的 reqIdentifier: ${resp.reqIdentifier}',
            methodName: '_handleBinaryMessage',
          );
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_handleBinaryMessage');
      rethrow;
    }
  }

  /// 将服务端响应路由到等待中的请求 Completer
  void _notifyResponse(WebSocketResponse resp) {
    try {
      final completer = _pendingRequests.remove(resp.msgIncr);
      if (completer != null && !completer.isCompleted) {
        completer.complete(resp);
      } else {
        _log.info('无匹配请求: msgIncr=${resp.msgIncr}', methodName: '_notifyResponse');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_notifyResponse');
      rethrow;
    }
  }

  void _sendBinary(WebSocketRequest req) {
    try {
      if (_channel == null) return;
      // JSON 编码 + gzip 压缩（sdkType=js 协议）
      final encoded = _codec.encodeRequest(req);
      _channel!.sink.add(encoded);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_sendBinary');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 重连
  // ---------------------------------------------------------------------------

  void _scheduleReconnect() {
    try {
      if (_userDisconnected || _isReconnecting) return;
      if (_reconnectAttempts >= _maxReconnectAttempts) {
        _log.error('已达最大重连次数 ($_maxReconnectAttempts)，停止重连', methodName: '_scheduleReconnect');
        connectListener.onConnectFailed?.call(-1, '超过最大重连次数');
        return;
      }

      _isReconnecting = true;
      _reconnectIndex++;
      final interval = _backoffIntervals[_reconnectIndex % _backoffIntervals.length];
      _reconnectAttempts++;

      _log.info('将在 ${interval}s 后重连 (第 $_reconnectAttempts 次)', methodName: '_scheduleReconnect');
      _reconnectTimer = Timer(Duration(seconds: interval), () async {
        _reconnectTimer = null;
        _isReconnecting = false;
        if (_userDisconnected) return;
        await _doConnect();
      });
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_scheduleReconnect');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // 工具方法
  // ---------------------------------------------------------------------------

  void _setStatus(WebSocketStatus status) {
    try {
      _connStatus = status;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_setStatus');
      rethrow;
    }
  }

  String _generateMsgIncr() {
    _msgIncrCounter++;
    return '${_userID}_${DateTime.now().millisecondsSinceEpoch}_$_msgIncrCounter';
  }

  void _cancelAllPendingRequests(String reason) {
    try {
      for (final entry in _pendingRequests.entries) {
        if (!entry.value.isCompleted) {
          entry.value.completeError(StateError(reason));
        }
      }
      _pendingRequests.clear();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: '_cancelAllPendingRequests');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Web 热重启支持：通过 JS 全局保存/恢复旧连接的释放回调
  // ---------------------------------------------------------------------------

  /// 热重启时调用上一轮注册的 JS 全局释放回调，终止残留 WebSocket 订阅（仅 Web）
  void _disposeOldWebSocketFromJsGlobal() {
    if (!kIsWeb) return;
    disposeOldWsFromJsGlobal();
  }

  /// 在 JS 全局注册当前连接的释放回调，供下次热重启时调用（仅 Web）
  void _registerDisposeInJsGlobal() {
    if (!kIsWeb) return;
    final sub = _subscription;
    final ch = _channel;
    registerDisposeInJsGlobal(() {
      sub?.cancel();
      ch?.sink.close();
    });
  }
}
