/// 系统通知分类器，严格对齐 `xue_hua_sdk/rust/src/domain/notification/parse.rs`（修复 B-17）。
///
/// 明确区分：
/// 1. 隐藏控制通知（仅执行状态同步/回调副作用，**不写入 `local_chat_logs`**、不推送到聊天消息流）；
/// 2. 撤回通知 `2101`（由通知处理器原地改写原消息，**不二次落库**为独立消息）；
/// 3. 可见系统提示 Tip（如 `1201` 好友通过、群变更提示、`1701` 阅后即焚开关，既执行副作用又写入聊天记录展示）。
abstract final class NotificationClassifier {
  static const Set<int> _hiddenControlTypes = <int>{1300, 1703, 2001, 2102, 2200};

  static const Set<int> _visibleGroupTipTypes = <int>{
    1501,
    1502,
    1504,
    1507,
    1508,
    1509,
    1510,
    1511,
    1512,
    1513,
    1514,
    1515,
    1519,
    1520,
  };

  /// 是否需要路由到 `NotificationRouter` 执行控制副作用。
  ///
  /// - [contentType] 内容类型 / Content type.
  /// - Returns: 操作结果布尔值 / Boolean result.
  static bool isNotification(int contentType) => contentType >= 1000;

  /// 是否为 `2101` 撤回通知（改写原消息，不独立入库）。
  ///
  /// Whether revoke notification.
  ///
  /// - [contentType] 内容类型 / Content type.
  /// - Returns: 操作结果布尔值 / Boolean result.
  static bool isRevokeNotification(int contentType) => contentType == 2101;

  /// 是否允许写入 `local_chat_logs` 并在聊天界面可见。
  ///
  /// - [contentType] 内容类型 / Content type.
  /// - Returns: 操作结果布尔值 / Boolean result.
  static bool shouldPersistInChatLog(int contentType) {
    if (contentType < 1000) {
      return true;
    }
    if (contentType == 1400) {
      return true;
    }
    if (contentType == 2101) {
      return false;
    }
    if (_hiddenControlTypes.contains(contentType)) {
      return false;
    }
    if (contentType >= 1200 && contentType <= 1299) {
      return contentType == 1201;
    }
    if (contentType >= 1301 && contentType <= 1399) {
      return false;
    }
    if (contentType >= 1501 && contentType <= 1520) {
      return _visibleGroupTipTypes.contains(contentType);
    }
    if (contentType == 1701) {
      return true;
    }
    return false;
  }
}
