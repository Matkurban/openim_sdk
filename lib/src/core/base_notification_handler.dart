import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// 系统通知策略处理器抽象基类（策略模式）。
///
/// 每类领域通知（好友、群组、会话、消息、用户）继承本基类并声明支持的 `contentType` 集合，
/// 由 `NotificationRouter` 统一路由，替代原 2,013 行的巨型 `switch`。
abstract base class BaseNotificationHandler {
  final Logger _logger;

  BaseNotificationHandler(String name) : _logger = Logger('openim_sdk.$name');

  @protected
  Logger get logger => _logger;

  /// 判断当前处理器是否负责处理指定的 [contentType]。
  bool canHandle(int contentType);

  /// 异步处理通知内容 [detail]（已解包 `NotificationElem.detail`）。
  Future<void> handle(int contentType, Map<String, dynamic> detail);

  /// 释放内部定时器或缓冲状态（登出时调用）。
  void dispose() {}
}
