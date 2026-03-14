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

  /// 当前引用回复的消息
  final quoteMessage = Rxn<Message>();

  Timer? _typingTimer;
  final _subs = <StreamSubscription>[];

  @override
  void onInit() {
    super.onInit();
    conversation = Get.arguments as ConversationInfo;
    _setupListener();
    _loadHistory();

    OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
      conversationID: conversation.conversationID,
    );
  }

  @override
  void onClose() {
    // 退出时保存草稿
    final draft = inputCtrl.text.trim();
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: conversation.conversationID,
      draftText: draft,
    );
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
        final idx = messages.indexWhere(
          (m) => m.clientMsgID == info.clientMsgID,
        );
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

    // 已读回执
    _subs.add(
      svc.recvC2CReadReceipt.stream.listen((list) {
        for (final receipt in list) {
          for (final msgID in receipt.msgIDList ?? <String>[]) {
            final idx = messages.indexWhere((m) => m.clientMsgID == msgID);
            if (idx >= 0) {
              messages[idx] = messages[idx].copyWith(isRead: true);
            }
          }
        }
      }),
    );
  }

  bool _belongsToThisConversation(Message msg) {
    if (conversation.isSingleChat) {
      return msg.sendID == conversation.userID ||
          msg.recvID == conversation.userID;
    }
    if (conversation.isGroupChat) {
      return msg.groupID == conversation.groupID;
    }
    return false;
  }

  // --------------- 历史消息 ---------------

  Future<void> _loadHistory() async {
    if (isLoading.value || !hasMore.value) return;
    isLoading.value = true;

    try {
      final list = await OpenIM.iMManager.messageManager
          .getAdvancedHistoryMessageList(
            conversationID: conversation.conversationID,
            count: 40,
            startMsg: messages.isNotEmpty ? messages.last : null,
          );
      final msgList = list.messageList ?? [];
      if (msgList.isEmpty || list.isEnd == true) {
        hasMore.value = false;
      }
      messages.addAll(msgList);
    } catch (e) {
      Get.snackbar('加载失败', '$e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() => _loadHistory();

  /// 反向加载（从旧到新）
  Future<List<Message>> loadHistoryReverse({
    Message? startMsg,
    int count = 20,
  }) async {
    try {
      final list = await OpenIM.iMManager.messageManager
          .getAdvancedHistoryMessageListReverse(
            conversationID: conversation.conversationID,
            count: count,
            startMsg: startMsg,
          );
      return list.messageList ?? [];
    } catch (_) {
      return [];
    }
  }

  /// 根据 clientMsgID 精确查找消息
  Future<SearchResult> findMessages(List<String> clientMsgIDs) async {
    return OpenIM.iMManager.messageManager.findMessageList(
      searchParams: [
        SearchParams(
          conversationID: conversation.conversationID,
          clientMsgIDList: clientMsgIDs,
        ),
      ],
    );
  }

  // --------------- 发送消息 ---------------

  String? get _userID => conversation.isSingleChat ? conversation.userID : null;
  String? get _groupID =>
      conversation.isGroupChat ? conversation.groupID : null;

  Future<void> _sendMsg(
    Message msg, {
    String pushTitle = '',
    String pushDesc = '',
  }) async {
    isSending.value = true;
    try {
      final sent = await OpenIM.iMManager.messageManager.sendMessage(
        message: msg,
        userID: _userID,
        groupID: _groupID,
        offlinePushInfo: OfflinePushInfo(
          title: pushTitle.isNotEmpty
              ? pushTitle
              : (OpenIM.iMManager.userInfo.nickname ?? ''),
          desc: pushDesc,
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

  /// 文本消息
  Future<void> sendTextMessage() async {
    final text = inputCtrl.text.trim();
    if (text.isEmpty) return;
    inputCtrl.clear();

    // 如果有引用消息，发引用消息
    if (quoteMessage.value != null) {
      final msg = OpenIM.iMManager.messageManager.createQuoteMessage(
        text: text,
        quoteMsg: quoteMessage.value!,
      );
      quoteMessage.value = null;
      await _sendMsg(msg, pushDesc: text);
      return;
    }

    final msg = OpenIM.iMManager.messageManager.createTextMessage(text: text);
    await _sendMsg(msg, pushDesc: text);
  }

  /// @消息（群聊专用）
  Future<void> sendAtMessage({
    required String text,
    required List<String> atUserIDList,
    List<AtUserInfo>? atUserInfoList,
  }) async {
    final msg = OpenIM.iMManager.messageManager.createTextAtMessage(
      text: text,
      atUserIDList: atUserIDList,
      atUserInfoList: atUserInfoList ?? [],
    );
    await _sendMsg(msg, pushDesc: text);
  }

  /// 图片消息（URL 方式）
  Future<void> sendImageMessageByURL({
    required String url,
    int width = 0,
    int height = 0,
  }) async {
    final pic = PictureInfo(url: url, width: width, height: height);
    final msg = OpenIM.iMManager.messageManager.createImageMessageByURL(
      sourcePath: '',
      sourcePicture: pic,
      bigPicture: pic,
      snapshotPicture: pic,
    );
    await _sendMsg(msg, pushDesc: '[图片]');
  }

  /// 语音消息（URL 方式）
  Future<void> sendSoundMessageByURL({
    required String url,
    required int duration,
  }) async {
    final msg = OpenIM.iMManager.messageManager.createSoundMessageByURL(
      soundElem: SoundElem(sourceUrl: url, dataSize: 0, duration: duration),
    );
    await _sendMsg(msg, pushDesc: '[语音]');
  }

  /// 视频消息（URL 方式）
  Future<void> sendVideoMessageByURL({
    required String videoUrl,
    String snapshotUrl = '',
    int duration = 0,
  }) async {
    final msg = OpenIM.iMManager.messageManager.createVideoMessageByURL(
      videoElem: VideoElem(
        videoUrl: videoUrl,
        videoType: 'mp4',
        duration: duration,
        snapshotUrl: snapshotUrl,
      ),
    );
    await _sendMsg(msg, pushDesc: '[视频]');
  }

  /// 文件消息（URL 方式）
  Future<void> sendFileMessageByURL({
    required String fileUrl,
    required String fileName,
    int fileSize = 0,
  }) async {
    final msg = OpenIM.iMManager.messageManager.createFileMessageByURL(
      fileElem: FileElem(
        sourceUrl: fileUrl,
        fileName: fileName,
        fileSize: fileSize,
      ),
    );
    await _sendMsg(msg, pushDesc: '[文件] $fileName');
  }

  /// 位置消息
  Future<void> sendLocationMessage(double lat, double lng, String desc) async {
    final msg = OpenIM.iMManager.messageManager.createLocationMessage(
      latitude: lat,
      longitude: lng,
      description: desc,
    );
    await _sendMsg(msg, pushTitle: '位置消息', pushDesc: desc);
  }

  /// 名片消息
  Future<void> sendCardMessage(
    String userID,
    String nickname,
    String faceURL,
  ) async {
    final msg = OpenIM.iMManager.messageManager.createCardMessage(
      userID: userID,
      nickname: nickname,
      faceURL: faceURL,
    );
    await _sendMsg(msg, pushDesc: '[名片] $nickname');
  }

  /// 表情消息
  Future<void> sendFaceMessage({
    required int index,
    required String data,
  }) async {
    final msg = OpenIM.iMManager.messageManager.createFaceMessage(
      index: index,
      data: data,
    );
    await _sendMsg(msg, pushDesc: '[表情]');
  }

  /// 合并转发消息
  Future<void> sendMergerMessage({
    required List<Message> msgList,
    required String title,
    required List<String> summaryList,
  }) async {
    final msg = OpenIM.iMManager.messageManager.createMergerMessage(
      messageList: msgList,
      title: title,
      summaryList: summaryList,
    );
    await _sendMsg(msg, pushDesc: '[聊天记录]');
  }

  /// 转发消息
  Future<void> forwardMessage(Message originalMsg) async {
    final msg = OpenIM.iMManager.messageManager.createForwardMessage(
      message: originalMsg,
    );
    await _sendMsg(msg, pushDesc: getMessageContent(originalMsg));
  }

  /// 自定义消息
  Future<void> sendCustomMessage(String data, String ext, String desc) async {
    final msg = OpenIM.iMManager.messageManager.createCustomMessage(
      data: data,
      extension: ext,
      description: desc,
    );
    await _sendMsg(msg, pushDesc: desc);
  }

  /// 高级文本消息（富文本）
  Future<void> sendAdvancedTextMessage({
    required String text,
    List<RichMessageInfo>? richList,
  }) async {
    final msg = OpenIM.iMManager.messageManager.createAdvancedTextMessage(
      text: text,
      list: richList ?? [],
    );
    await _sendMsg(msg, pushDesc: text);
  }

  // --------------- 引用回复 ---------------

  void setQuoteMessage(Message msg) {
    quoteMessage.value = msg;
  }

  void clearQuoteMessage() {
    quoteMessage.value = null;
  }

  // --------------- 消息操作 ---------------

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

  /// 仅删除本地
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

  /// 同时删除本地和服务端
  Future<void> deleteMessageFromServer(Message msg) async {
    try {
      await OpenIM.iMManager.messageManager.deleteMessageFromLocalAndSvr(
        conversationID: conversation.conversationID,
        clientMsgID: msg.clientMsgID!,
      );
      messages.removeWhere((m) => m.clientMsgID == msg.clientMsgID);
    } catch (e) {
      Get.snackbar('删除失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 按消息ID标记已读
  Future<void> markSpecificMessagesAsRead(List<String> clientMsgIDs) async {
    try {
      await OpenIM.iMManager.conversationManager.markMessagesAsReadByMsgID(
        conversationID: conversation.conversationID,
        clientMsgIDs: clientMsgIDs,
      );
    } catch (_) {}
  }

  /// 清空会话所有消息
  Future<void> clearAllMessages() async {
    try {
      await OpenIM.iMManager.conversationManager
          .clearConversationAndDeleteAllMsg(
            conversationID: conversation.conversationID,
          );
      messages.clear();
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 删除所有本地和服务端消息
  Future<void> deleteAllMsgFromLocalAndSvr() async {
    try {
      await OpenIM.iMManager.messageManager.deleteAllMsgFromLocalAndSvr();
      messages.clear();
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 搜索本地消息
  Future<SearchResult> searchMessages({
    required String keyword,
    List<int> messageTypeList = const [],
    int pageIndex = 1,
    int count = 20,
  }) async {
    return OpenIM.iMManager.messageManager.searchLocalMessages(
      conversationID: conversation.conversationID,
      keywordList: [keyword],
      messageTypeList: messageTypeList,
      pageIndex: pageIndex,
      count: count,
    );
  }

  /// 插入本地消息（不发送给对方）
  Future<void> insertLocalMessage(String text) async {
    try {
      final msg = OpenIM.iMManager.messageManager.createTextMessage(text: text);
      if (conversation.isSingleChat) {
        await OpenIM.iMManager.messageManager.insertSingleMessageToLocalStorage(
          message: msg,
          receiverID: conversation.userID!,
          senderID: OpenIM.iMManager.userID,
        );
      } else if (conversation.isGroupChat) {
        await OpenIM.iMManager.messageManager.insertGroupMessageToLocalStorage(
          message: msg,
          groupID: conversation.groupID!,
          senderID: OpenIM.iMManager.userID,
        );
      }
      // 刷新列表
      messages.clear();
      hasMore.value = true;
      await _loadHistory();
    } catch (e) {
      Get.snackbar('失败', '$e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // --------------- 输入状态 ---------------

  void onInputChanged(String text) {
    try {
      OpenIM.iMManager.conversationManager.changeInputStates(
        conversationID: conversation.conversationID,
        focus: text.isNotEmpty,
      );
    } catch (_) {}
  }

  /// 获取对端输入状态
  Future<List<int>?> getInputStates() async {
    try {
      return await OpenIM.iMManager.conversationManager.getInputStates(
        conversation.conversationID,
        conversation.userID ?? '',
      );
    } catch (_) {
      return null;
    }
  }

  // --------------- 工具方法 ---------------

  void _scrollToBottom() {
    if (scrollCtrl.hasClients) {
      scrollCtrl.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
      case MessageType.advancedText:
        return msg.textElem?.content ?? '[富文本]';
      case MessageType.oaNotification:
        return _getOANotificationText(msg);
      default:
        if (msg.contentType != null && msg.contentType!.value >= 1000) {
          return msg.notificationElem?.detail ?? '[系统通知]';
        }
        return '[未知消息]';
    }
  }

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
