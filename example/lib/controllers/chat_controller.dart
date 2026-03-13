import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'im_listener_service.dart';

class ChatController extends GetxController {
  late final ConversationInfo conversation;
  final messages = <Message>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;
  final hasMore = true.obs;
  final isTyping = false.obs;
  final inputCtrl = TextEditingController();
  final scrollCtrl = ScrollController();

  Timer? _typingTimer;
  final _subs = <StreamSubscription>[];

  @override
  void onInit() {
    super.onInit();
    conversation = Get.arguments as ConversationInfo;
    _setupListener();
    _loadHistory();

    // Mark as read when entering
    OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
      conversationID: conversation.conversationID,
    );
  }

  @override
  void onClose() {
    for (final s in _subs) {
      s.cancel();
    }
    inputCtrl.dispose();
    scrollCtrl.dispose();
    _typingTimer?.cancel();
    super.onClose();
  }

  void _setupListener() {
    final svc = Get.find<IMListenerService>();

    _subs.add(
      svc.recvNewMessage.stream.listen((msg) {
        if (_belongsToThisConversation(msg)) {
          messages.insert(0, msg);
          _scrollToBottom();
          OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
            conversationID: conversation.conversationID,
          );
        }
      }),
    );

    _subs.add(
      svc.recvMessageRevoked.stream.listen((info) {
        final idx = messages.indexWhere((m) => m.clientMsgID == info.clientMsgID);
        if (idx >= 0) {
          messages.removeAt(idx);
        }
      }),
    );

    _subs.add(
      svc.msgDeleted.stream.listen((msg) {
        messages.removeWhere((m) => m.clientMsgID == msg.clientMsgID);
      }),
    );

    _subs.add(
      svc.inputStatusChanged.stream.listen((data) {
        if (data.conversationID == conversation.conversationID) {
          isTyping.value = true;
          _typingTimer?.cancel();
          _typingTimer = Timer(const Duration(seconds: 3), () {
            isTyping.value = false;
          });
        }
      }),
    );
  }

  bool _belongsToThisConversation(Message msg) {
    if (conversation.isSingleChat) {
      return msg.sendID == conversation.userID || msg.recvID == conversation.userID;
    }
    if (conversation.isGroupChat) {
      return msg.groupID == conversation.groupID;
    }
    return false;
  }

  Future<void> _loadHistory() async {
    if (isLoading.value || !hasMore.value) return;
    isLoading.value = true;

    try {
      final list = await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
        conversationID: conversation.conversationID,
        count: 40,
        startMsg: messages.isNotEmpty ? messages.last : null,
      );
      final msgList = list.messageList ?? [];
      if (msgList.isEmpty) {
        hasMore.value = false;
      } else {
        messages.addAll(msgList);
        if (list.isEnd == true) hasMore.value = false;
      }
    } catch (e) {
      Get.snackbar('加载失败', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    await _loadHistory();
  }

  Future<void> sendTextMessage() async {
    final text = inputCtrl.text.trim();
    if (text.isEmpty) return;

    inputCtrl.clear();
    isSending.value = true;

    try {
      final msg = OpenIM.iMManager.messageManager.createTextMessage(text: text);
      final sent = await OpenIM.iMManager.messageManager.sendMessage(
        message: msg,
        userID: conversation.isSingleChat ? conversation.userID : null,
        groupID: conversation.isGroupChat ? conversation.groupID : null,
        offlinePushInfo: OfflinePushInfo(
          title: OpenIM.iMManager.userInfo.nickname ?? '',
          desc: text,
        ),
      );
      messages.insert(0, sent);
      _scrollToBottom();
    } catch (e) {
      Get.snackbar('发送失败', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSending.value = false;
    }
  }

  Future<void> sendLocationMessage(double lat, double lng, String desc) async {
    try {
      final msg = OpenIM.iMManager.messageManager.createLocationMessage(
        latitude: lat,
        longitude: lng,
        description: desc,
      );
      final sent = await OpenIM.iMManager.messageManager.sendMessage(
        message: msg,
        userID: conversation.isSingleChat ? conversation.userID : null,
        groupID: conversation.isGroupChat ? conversation.groupID : null,
        offlinePushInfo: OfflinePushInfo(title: '位置消息', desc: desc),
      );
      messages.insert(0, sent);
    } catch (e) {
      Get.snackbar('发送失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> sendCardMessage(String userID, String nickname, String faceURL) async {
    try {
      final msg = OpenIM.iMManager.messageManager.createCardMessage(
        userID: userID,
        nickname: nickname,
        faceURL: faceURL,
      );
      final sent = await OpenIM.iMManager.messageManager.sendMessage(
        message: msg,
        userID: conversation.isSingleChat ? conversation.userID : null,
        groupID: conversation.isGroupChat ? conversation.groupID : null,
        offlinePushInfo: OfflinePushInfo(title: '名片', desc: nickname),
      );
      messages.insert(0, sent);
    } catch (e) {
      Get.snackbar('发送失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> sendCustomMessage(String data, String ext, String desc) async {
    try {
      final msg = OpenIM.iMManager.messageManager.createCustomMessage(
        data: data,
        extension: ext,
        description: desc,
      );
      final sent = await OpenIM.iMManager.messageManager.sendMessage(
        message: msg,
        userID: conversation.isSingleChat ? conversation.userID : null,
        groupID: conversation.isGroupChat ? conversation.groupID : null,
        offlinePushInfo: OfflinePushInfo(title: '自定义消息', desc: desc),
      );
      messages.insert(0, sent);
    } catch (e) {
      Get.snackbar('发送失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> revokeMessage(Message msg) async {
    try {
      await OpenIM.iMManager.messageManager.revokeMessage(
        conversationID: conversation.conversationID,
        clientMsgID: msg.clientMsgID!,
      );
      messages.removeWhere((m) => m.clientMsgID == msg.clientMsgID);
      Get.snackbar('成功', '消息已撤回', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('撤回失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteMessage(Message msg) async {
    try {
      await OpenIM.iMManager.messageManager.deleteMessageFromLocalStorage(
        conversationID: conversation.conversationID,
        clientMsgID: msg.clientMsgID!,
      );
      messages.removeWhere((m) => m.clientMsgID == msg.clientMsgID);
    } catch (e) {
      Get.snackbar('删除失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void onInputChanged(String text) {
    // Send typing indicator
    try {
      OpenIM.iMManager.conversationManager.changeInputStates(
        conversationID: conversation.conversationID,
        focus: text.isNotEmpty,
      );
    } catch (_) {}
  }

  void _scrollToBottom() {
    if (scrollCtrl.hasClients) {
      scrollCtrl.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  String getMessageContent(Message msg) {
    switch (msg.contentType) {
      case MessageType.text:
        return msg.textElem?.content ?? '';
      case MessageType.atText:
        return msg.atTextElem?.text ?? '';
      case MessageType.picture:
        return '[图片]';
      case MessageType.voice:
        return '[语音] ${msg.soundElem?.duration ?? 0}s';
      case MessageType.video:
        return '[视频]';
      case MessageType.file:
        return '[文件] ${msg.fileElem?.fileName ?? ''}';
      case MessageType.location:
        return '[位置] ${msg.locationElem?.description ?? ''}';
      case MessageType.card:
        return '[名片]';
      case MessageType.merger:
        return '[合并转发]';
      case MessageType.quote:
        return msg.quoteElem?.text ?? '[引用消息]';
      case MessageType.custom:
        return '[自定义消息]';
      case MessageType.customFace:
        return '[表情]';
      case MessageType.oaNotification:
        return _getOANotificationText(msg);
      default:
        if (msg.contentType != null && msg.contentType!.value >= 1000) {
          return msg.notificationElem?.detail ?? '[系统通知]';
        }
        return '[未知消息]';
    }
  }

  /// 解析 OA 通知消息的展示文本
  ///
  /// detail JSON 结构: {"text":"...","mixType":0|1,"notificationName":"...","pictureElem":{...}}
  String _getOANotificationText(Message msg) {
    final detail = msg.notificationElem?.detail;
    if (detail == null || detail.isEmpty) return '[通知]';
    try {
      final map = jsonDecode(detail) as Map<String, dynamic>;
      return map['text'] as String? ?? '[通知]';
    } catch (_) {
      return detail;
    }
  }

  bool isMyMessage(Message msg) => msg.sendID == OpenIM.iMManager.userID;
}
