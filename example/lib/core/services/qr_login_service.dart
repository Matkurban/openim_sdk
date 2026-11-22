import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

import '../utils/qr_payload_codec.dart';
import 'auth_session_service.dart';
import 'settings_service.dart';

/// 桌面端扫码登录会话数据与后端接口服务（对齐 `xue_hua_sdk` `/account/qr/*` 协议）。
///
/// Desktop QR code login service calling `/account/qr/*` endpoints on `authAddr`.
class QrLoginService extends WireService {
  static final Logger _logger = Logger('QrLoginService');

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  int get _platformId {
    if (kIsWeb) {
      return 5;
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => 1,
      TargetPlatform.android => 2,
      TargetPlatform.windows => 3,
      TargetPlatform.macOS => 4,
      TargetPlatform.linux => 7,
      _ => 5,
    };
  }

  String _endpoint(String path) {
    final String base = Wire.find<SettingsService>().serverConfig.value.authAddr
        .replaceAll(RegExp(r'/+$'), '');
    return '$base$path';
  }

  Map<String, String> _headers() {
    final String token = OpenIM.iMManager.authData.chatToken ?? '';
    return <String, String>{
      'operationID': '${DateTime.now().millisecondsSinceEpoch}',
      if (token.isNotEmpty) 'token': token,
    };
  }

  /// 桌面端创建扫码登录会话，返回 `(sessionId, expireAt, qrContent)`。
  Future<(String sessionId, int expireAt, String qrContent)>
  createSession() async {
    final String deviceId = Wire.find<AuthSessionService>().deviceID.value;
    final Response<dynamic> resp = await _dio.post<dynamic>(
      _endpoint('/account/qr/create'),
      data: <String, Object>{'platform': _platformId, 'deviceID': deviceId},
      options: Options(headers: _headers()),
    );
    final Map<String, dynamic> data = _extractData(resp);
    final String sessionId = (data['sessionID'] as String?) ?? '';
    final int expireAt = (data['expireAt'] as num?)?.toInt() ?? 0;
    final String qrContent = QrPayloadCodec.encodeDesktopLogin(
      sessionId,
      expireAt: expireAt,
    );
    return (sessionId, expireAt, qrContent);
  }

  /// 桌面端轮询扫码登录状态，返回原始状态 Map。
  Future<Map<String, dynamic>> pollStatus(String sessionId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      _endpoint('/account/qr/status'),
      data: <String, Object>{'sessionID': sessionId},
      options: Options(headers: _headers()),
    );
    return _extractData(resp);
  }

  /// 桌面端在状态为 `confirmed` 时用返回的 `userID` 与 `imToken` 完成 SDK 登录。
  Future<UserInfo> completeDesktopLogin(Map<String, dynamic> statusData) async {
    final String userID = (statusData['userID'] as String?) ?? '';
    final String imToken = (statusData['imToken'] as String?) ?? '';
    if (userID.isEmpty || imToken.isEmpty) {
      throw StateError('Missing userID or imToken from QR login response');
    }
    final UserInfo user = await OpenIM.iMManager.login(
      userID: userID,
      token: imToken,
    );
    Wire.find<AuthSessionService>().currentUser.value = user;
    return user;
  }

  /// 移动端扫码后上报已扫描并获取桌面端平台与 IP 信息。
  Future<Map<String, dynamic>> scanSession(String sessionId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      _endpoint('/account/qr/scan'),
      data: <String, Object>{'sessionID': sessionId},
      options: Options(headers: _headers()),
    );
    return _extractData(resp);
  }

  /// 移动端确认授权桌面端登录。
  Future<void> confirmSession(String sessionId) async {
    await _dio.post<dynamic>(
      _endpoint('/account/qr/confirm'),
      data: <String, Object>{'sessionID': sessionId},
      options: Options(headers: _headers()),
    );
  }

  /// 取消扫码登录会话。
  Future<void> cancelSession(String sessionId) async {
    try {
      await _dio.post<dynamic>(
        _endpoint('/account/qr/cancel'),
        data: <String, Object>{'sessionID': sessionId},
        options: Options(headers: _headers()),
      );
    } on Object catch (error, stackTrace) {
      _logger.fine('cancelSession ignored', error, stackTrace);
    }
  }

  Map<String, dynamic> _extractData(Response<dynamic> resp) {
    final Object? raw = resp.data;
    if (raw is Map<String, dynamic>) {
      final int errCode = (raw['errCode'] as num?)?.toInt() ?? 0;
      if (errCode != 0) {
        throw StateError(
          (raw['errMsg'] as String?) ?? 'QR login API error $errCode',
        );
      }
      final Object? inner = raw['data'];
      if (inner is Map<String, dynamic>) {
        return inner;
      }
      return raw;
    }
    return <String, dynamic>{};
  }

  @override
  void onClose() {
    _dio.close(force: true);
    super.onClose();
  }
}
