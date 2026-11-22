import 'dart:convert';

import 'package:logging/logging.dart';

import '../../core/base_notification_handler.dart';

/// 通知策略路由器：解包 `NotificationElem.detail` 并按 `contentType` 路由至对应 [BaseNotificationHandler]。
///
/// 替代原 2,013 行巨型 `NotificationDispatcher`，新增通知类型只需注册新的策略处理器。
class NotificationRouter {
  final Logger _logger = Logger('openim_sdk.NotificationRouter');
  final List<BaseNotificationHandler> _handlers;

  NotificationRouter({required this._handlers});

  /// 解析通知正文并顺序分发给所有匹配的策略处理器。
  Future<void> dispatch(int contentType, String rawContent) async {
    final Map<String, dynamic> detail = _extractDetail(rawContent);
    for (final BaseNotificationHandler handler in _handlers) {
      if (!handler.canHandle(contentType)) {
        continue;
      }
      try {
        await handler.handle(contentType, detail);
      } on Object catch (error, stackTrace) {
        _logger.warning(
          'Notification handler failed for contentType=$contentType',
          error,
          stackTrace,
        );
      }
    }
  }

  /// 释放所有处理器持有的资源。
  void dispose() {
    for (final BaseNotificationHandler handler in _handlers) {
      handler.dispose();
    }
  }

  Map<String, dynamic> _extractDetail(String rawContent) {
    if (rawContent.isEmpty) {
      return <String, dynamic>{};
    }
    try {
      final dynamic decoded = jsonDecode(rawContent);
      if (decoded is! Map<String, dynamic>) {
        return <String, dynamic>{};
      }
      final dynamic detailField = decoded['detail'];
      if (detailField is String && detailField.isNotEmpty) {
        final dynamic nested = jsonDecode(detailField);
        if (nested is Map<String, dynamic>) {
          return nested;
        }
      }
      return decoded;
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}
