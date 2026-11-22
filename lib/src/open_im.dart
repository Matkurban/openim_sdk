import 'package:openim_sdk/src/manager/im_manager.dart';

/// OpenIM SDK 静态入口门面类。
///
/// Static entry-point facade for the OpenIM SDK.
class OpenIM {
  OpenIM._();

  /// 全局单例 [IMManager] 实例。
  ///
  /// Global singleton [IMManager] instance.
  static final IMManager iMManager = IMManager();

  /// 群聊 `@所有人` 保留标签常量。
  ///
  /// Reserved tag constant for mentioning all members (`@All`) in group chats.
  static const String atAllTag = 'AtAllTag';
}
