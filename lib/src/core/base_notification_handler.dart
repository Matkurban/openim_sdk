import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// 系统通知策略处理器抽象基类（策略模式）。
///
/// Abstract base class for system notification strategy handlers (Strategy pattern).
///
/// 每类领域通知（好友、群组、会话、消息、用户）继承本基类并声明支持的 `contentType` 集合，
/// 由 `NotificationRouter` 统一路由。
/// Domain notification handlers (friend, group, conversation, message, user) extend this class
/// and are dispatched centrally by `NotificationRouter`.
abstract base class BaseNotificationHandler {
  final Logger _logger;

  /// 创建系统通知处理器基类实例。
  ///
  /// Creates a [BaseNotificationHandler] instance.
  ///
  /// - [name] 处理器名称，用于日志标识 / Handler name used for logging.
  BaseNotificationHandler(String name) : _logger = Logger('openim_sdk.$name');

  /// 当前处理器日志器。
  ///
  /// Logger instance for this notification handler.
  @protected
  Logger get logger => _logger;

  /// 判断当前处理器是否负责处理指定的 [contentType]。
  ///
  /// Returns whether this handler supports the given [contentType].
  ///
  /// - [contentType] 通知消息内容类型码 / Notification message content type code.
  /// - Returns: 支持处理返回 `true`，否则返回 `false` / `true` if handled, otherwise `false`.
  bool canHandle(int contentType);

  /// 异步处理通知内容 [detail]（已解包 `NotificationElem.detail`）。
  ///
  /// Asynchronously processes the parsed notification payload [detail].
  ///
  /// - [contentType] 通知消息内容类型码 / Notification message content type code.
  /// - [detail] 解析后的通知详情 JSON 字典 / Parsed JSON detail map.
  Future<void> handle(int contentType, Map<String, dynamic> detail);

  /// 释放内部定时器或缓冲状态（登出时调用）。
  ///
  /// Releases internal timers or buffered state on logout.
  void dispose() {}
}
