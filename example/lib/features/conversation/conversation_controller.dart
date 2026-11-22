import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../core/events/im_conversation_event.dart';
import '../../core/events/im_event_bus.dart';
import '../../core/utils/message_summary_parser.dart';

/// 会话列表控制器（订阅 [ImEventBus] 实时刷新会话排序与未读数）。
///
/// Conversation list controller subscribing to [ImEventBus].
class ConversationController extends WireController {
  static final Logger _logger = Logger('ConversationController');

  /// 全部可见会话列表信号。
  late final Signal<List<ConversationInfo>> conversations =
      createSignal<List<ConversationInfo>>(<ConversationInfo>[]);

  /// 是否加载中。
  late final Signal<bool> loading = createSignal<bool>(true);

  /// 服务端同步进度（null 表示未在同步）。
  late final Signal<int?> syncProgress = createSignal<int?>(null);

  StreamSubscription<ImConversationEvent>? _convSub;

  @override
  void onInit() {
    super.onInit();
    final ImEventBus bus = Wire.find<ImEventBus>();
    _convSub = bus.conversationStream.listen((ImConversationEvent event) {
      switch (event.kind) {
        case 'changed':
        case 'added':
        case 'syncFinish':
          unawaited(loadConversations());
        case 'syncStart':
          syncProgress.value = 0;
        case 'syncProgress':
          syncProgress.value = event.syncProgress;
        case 'syncFailed':
          syncProgress.value = null;
        default:
          break;
      }
    });
    unawaited(loadConversations());
  }

  /// 加载并按置顶与时间排序会话列表。
  Future<void> loadConversations() async {
    try {
      final List<ConversationInfo> list = await OpenIM
          .iMManager
          .conversationManager
          .getAllConversationList();
      conversations.value = OpenIM.iMManager.conversationManager.simpleSort(
        list,
      );
      syncProgress.value = null;
    } on Object catch (error, stackTrace) {
      _logger.warning('loadConversations failed', error, stackTrace);
    } finally {
      loading.value = false;
    }
  }

  /// 置顶或取消置顶会话。
  Future<void> togglePin(ConversationInfo conv) async {
    try {
      await OpenIM.iMManager.conversationManager.pinConversation(
        conversationID: conv.conversationID,
        isPinned: !(conv.isPinned ?? false),
      );
      await loadConversations();
    } on Object catch (error) {
      await FlutterToastPro.error('操作失败：$error');
    }
  }

  /// 切换消息免打扰。
  Future<void> toggleMute(ConversationInfo conv) async {
    final bool isMuted = conv.recvMsgOpt == ReceiveMessageOpt.notNotify;
    try {
      await OpenIM.iMManager.conversationManager.setConversation(
        conversationID: conv.conversationID,
        req: ConversationReq(
          recvMsgOpt: isMuted
              ? ReceiveMessageOpt.receive.value
              : ReceiveMessageOpt.notNotify.value,
        ),
      );
      await loadConversations();
    } on Object catch (error) {
      await FlutterToastPro.error('设置免打扰失败：$error');
    }
  }

  /// 标记单个会话已读。
  Future<void> markAsRead(ConversationInfo conv) async {
    try {
      await OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
        conversationID: conv.conversationID,
      );
      await loadConversations();
    } on Object catch (error) {
      await FlutterToastPro.error('标记已读失败：$error');
    }
  }

  /// 标记全部会话已读。
  Future<void> markAllAsRead() async {
    try {
      await OpenIM.iMManager.conversationManager
          .markAllConversationMessageAsRead();
      await loadConversations();
      await FlutterToastPro.success('已全部标为已读');
    } on Object catch (error) {
      await FlutterToastPro.error('全部已读失败：$error');
    }
  }

  /// 隐藏会话。
  Future<void> hideConversation(ConversationInfo conv) async {
    try {
      await OpenIM.iMManager.conversationManager.hideConversation(
        conversationID: conv.conversationID,
      );
      await loadConversations();
    } on Object catch (error) {
      await FlutterToastPro.error('隐藏失败：$error');
    }
  }

  /// 清空会话消息。
  Future<void> clearHistory(ConversationInfo conv) async {
    try {
      await OpenIM.iMManager.conversationManager
          .clearConversationAndDeleteAllMsg(
            conversationID: conv.conversationID,
          );
      await loadConversations();
      await FlutterToastPro.success('已清空聊天记录');
    } on Object catch (error) {
      await FlutterToastPro.error('清空失败：$error');
    }
  }

  /// 删除会话并删除全部消息。
  Future<void> deleteConversation(ConversationInfo conv) async {
    try {
      await OpenIM.iMManager.conversationManager
          .deleteConversationAndDeleteAllMsg(
            conversationID: conv.conversationID,
          );
      await loadConversations();
      await FlutterToastPro.success('已删除会话');
    } on Object catch (error) {
      await FlutterToastPro.error('删除失败：$error');
    }
  }

  /// 解析会话最后一条消息摘要文本（委托给全类型 [MessageSummaryParser]）。
  static String formatLatestSummary(ConversationInfo conv) {
    return MessageSummaryParser.formatConversationSummary(
      conv,
      selfUserId: OpenIM.iMManager.userID,
    );
  }

  @override
  void onClose() {
    _convSub?.cancel();
    super.onClose();
  }
}
