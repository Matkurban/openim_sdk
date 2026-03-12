import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';
import '../routes/app_routes.dart';

class HomeController extends GetxController {
  final currentTab = 0.obs;
  final conversations = <ConversationInfo>[].obs;
  final totalUnread = 0.obs;
  final isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    _loadConversations();
  }

  void _setupListeners() {
    OpenIM.iMManager.conversationManager.setConversationListener(
      OnConversationListener(
        onConversationChanged: (list) {
          for (final c in list) {
            final idx = conversations.indexWhere((e) => e.conversationID == c.conversationID);
            if (idx >= 0) {
              conversations[idx] = c;
            } else {
              conversations.insert(0, c);
            }
          }
          _sortConversations();
        },
        onNewConversation: (list) {
          conversations.insertAll(0, list);
          _sortConversations();
        },
        onTotalUnreadMessageCountChanged: (count) {
          totalUnread.value = count;
        },
        onSyncServerStart: (_) => isSyncing.value = true,
        onSyncServerFinish: (_) {
          isSyncing.value = false;
          _loadConversations();
        },
        onSyncServerFailed: (_) => isSyncing.value = false,
      ),
    );

    OpenIM.iMManager.messageManager.setAdvancedMsgListener(
      OnAdvancedMsgListener(
        onRecvNewMessage: (msg) => _loadConversations(),
        onRecvOfflineNewMessage: (msg) => _loadConversations(),
      ),
    );
  }

  Future<void> _loadConversations() async {
    try {
      final list = await OpenIM.iMManager.conversationManager.getAllConversationList();
      conversations.value = OpenIM.iMManager.conversationManager.simpleSort(list);
      final count = await OpenIM.iMManager.conversationManager.getTotalUnreadMsgCount();
      totalUnread.value = count;
    } catch (_) {}
  }

  void _sortConversations() {
    conversations.value = OpenIM.iMManager.conversationManager.simpleSort(conversations.toList());
  }

  Future<void> refreshConversations() async {
    await _loadConversations();
  }

  void openChat(ConversationInfo conv) {
    Get.toNamed(AppRoutes.chat, arguments: conv);
  }

  Future<void> pinConversation(ConversationInfo conv) async {
    try {
      final newPin = !(conv.isPinned ?? false);
      await OpenIM.iMManager.conversationManager.pinConversation(
        conversationID: conv.conversationID,
        isPinned: newPin,
      );
      await _loadConversations();
    } catch (e) {
      Get.snackbar('错误', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteConversation(ConversationInfo conv) async {
    try {
      await OpenIM.iMManager.conversationManager.deleteConversationAndDeleteAllMsg(
        conversationID: conv.conversationID,
      );
      conversations.removeWhere((c) => c.conversationID == conv.conversationID);
    } catch (e) {
      Get.snackbar('错误', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> markAsRead(ConversationInfo conv) async {
    try {
      await OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
        conversationID: conv.conversationID,
      );
      await _loadConversations();
    } catch (e) {
      Get.snackbar('错误', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> logout() async {
    try {
      await OpenIM.iMManager.logout();
    } catch (_) {}
    Get.offAllNamed(AppRoutes.login);
  }
}
