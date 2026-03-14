import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';
import '../routes/app_routes.dart';
import 'im_listener_service.dart';

class HomeController extends GetxController {
  final currentTab = 0.obs;
  final pageController = PageController();
  final conversations = <ConversationInfo>[].obs;
  final totalUnread = 0.obs;
  final isSyncing = false.obs;
  final searchResults = <ConversationInfo>[].obs;
  final isSearching = false.obs;

  final _subs = <StreamSubscription>[];

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    _loadConversations();
  }

  void switchTab(int index) {
    currentTab.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void onClose() {
    pageController.dispose();
    for (final s in _subs) {
      s.cancel();
    }
    super.onClose();
  }

  void _setupListeners() {
    final svc = Get.find<IMListenerService>();

    _subs.add(
      svc.conversationChanged.stream.listen((list) {
        for (final c in list) {
          final idx = conversations.indexWhere(
            (e) => e.conversationID == c.conversationID,
          );
          if (idx >= 0) {
            conversations[idx] = c;
          } else {
            conversations.insert(0, c);
          }
        }
        _sortConversations();
      }),
    );

    _subs.add(
      svc.newConversation.stream.listen((list) {
        conversations.insertAll(0, list);
        _sortConversations();
      }),
    );

    _subs.add(
      svc.totalUnreadCount.stream.listen((count) {
        totalUnread.value = count;
      }),
    );

    _subs.add(svc.syncStarted.stream.listen((_) => isSyncing.value = true));

    _subs.add(
      svc.syncFinished.stream.listen((_) {
        isSyncing.value = false;
        _loadConversations();
      }),
    );

    _subs.add(svc.syncFailed.stream.listen((_) => isSyncing.value = false));

    _subs.add(svc.recvNewMessage.stream.listen((_) => _loadConversations()));
  }

  Future<void> _loadConversations() async {
    try {
      final list = await OpenIM.iMManager.conversationManager
          .getAllConversationList();
      conversations.value = OpenIM.iMManager.conversationManager.simpleSort(
        list,
      );
      final count = await OpenIM.iMManager.conversationManager
          .getTotalUnreadMsgCount();
      totalUnread.value = count;
    } catch (_) {}
  }

  void _sortConversations() {
    conversations.value = OpenIM.iMManager.conversationManager.simpleSort(
      conversations.toList(),
    );
  }

  Future<void> refreshConversations() async {
    await _loadConversations();
  }

  void openChat(ConversationInfo conv) {
    Get.toNamed(AppRoutes.chat, arguments: conv);
  }

  // ---- 会话操作 ----

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
      await OpenIM.iMManager.conversationManager
          .deleteConversationAndDeleteAllMsg(
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

  /// 全部标记已读
  Future<void> markAllAsRead() async {
    try {
      await OpenIM.iMManager.conversationManager
          .markAllConversationMessageAsRead();
      await _loadConversations();
      Get.snackbar('成功', '已全部标记已读', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('错误', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 隐藏会话
  Future<void> hideConversation(ConversationInfo conv) async {
    try {
      await OpenIM.iMManager.conversationManager.hideConversation(
        conversationID: conv.conversationID,
      );
      conversations.removeWhere((c) => c.conversationID == conv.conversationID);
      Get.snackbar('成功', '会话已隐藏', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('错误', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 隐藏所有会话
  Future<void> hideAllConversations() async {
    try {
      await OpenIM.iMManager.conversationManager.hideAllConversations();
      conversations.clear();
      Get.snackbar('成功', '已隐藏所有会话', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('错误', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 设置免打扰 (recvMsgOpt: 0=正常, 1=不接收, 2=接收但不提醒)
  Future<void> setConversationDND(ConversationInfo conv, int recvMsgOpt) async {
    try {
      await OpenIM.iMManager.conversationManager.setConversation(
        conversationID: conv.conversationID,
        req: ConversationReq(recvMsgOpt: recvMsgOpt),
      );
      await _loadConversations();
      final label = recvMsgOpt == 0
          ? '取消免打扰'
          : (recvMsgOpt == 2 ? '已设为免打扰' : '已屏蔽消息');
      Get.snackbar('成功', label, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('错误', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 设置阅后即焚
  Future<void> setConversationBurn(
    ConversationInfo conv,
    bool enable, {
    int burnDuration = 30,
  }) async {
    try {
      await OpenIM.iMManager.conversationManager.setConversation(
        conversationID: conv.conversationID,
        req: ConversationReq(
          isMsgDestruct: enable,
          msgDestructTime: burnDuration,
        ),
      );
      await _loadConversations();
      Get.snackbar(
        '成功',
        enable ? '已开启阅后即焚' : '已关闭阅后即焚',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('错误', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 设置会话草稿
  Future<void> setDraft(ConversationInfo conv, String draft) async {
    try {
      await OpenIM.iMManager.conversationManager.setConversationDraft(
        conversationID: conv.conversationID,
        draftText: draft,
      );
    } catch (_) {}
  }

  /// 搜索会话
  Future<void> searchConversations(String keyword) async {
    if (keyword.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      return;
    }
    isSearching.value = true;
    try {
      searchResults.value = await OpenIM.iMManager.conversationManager
          .searchConversations(keyword);
    } catch (_) {
      searchResults.clear();
    }
  }

  void clearSearch() {
    isSearching.value = false;
    searchResults.clear();
  }

  /// 分页加载会话
  Future<List<ConversationInfo>> getConversationListSplit({
    int offset = 0,
    int count = 20,
  }) async {
    try {
      return await OpenIM.iMManager.conversationManager
          .getConversationListSplit(offset: offset, count: count);
    } catch (_) {
      return [];
    }
  }

  /// 获取多个指定会话
  Future<List<ConversationInfo>> getMultipleConversation(
    List<String> ids,
  ) async {
    try {
      return await OpenIM.iMManager.conversationManager.getMultipleConversation(
        conversationIDList: ids,
      );
    } catch (_) {
      return [];
    }
  }

  Future<void> logout() async {
    try {
      await OpenIM.iMManager.logout();
    } catch (_) {}
    Get.offAllNamed(AppRoutes.login);
  }
}
