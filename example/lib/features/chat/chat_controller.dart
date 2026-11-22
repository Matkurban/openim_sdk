import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_file_operations/xue_hua_file_operations.dart';
import 'package:xue_hua_media_info/xue_hua_media_info.dart' as media_info;
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';
import 'package:xue_hua_navite_drag_drop/xue_hua_navite_drag_drop.dart';
import 'package:xue_hua_navite_share/xue_hua_navite_share.dart';

import '../../core/events/im_conversation_event.dart';
import '../../core/events/im_event_bus.dart';
import '../../core/events/im_message_event.dart';
import '../../core/services/download_service.dart';
import '../../core/services/media_service.dart';

/// 聊天核心控制器：管理消息分页、全类型发送、撤回、多选、引用回复、输入态与桌面拖拽发送。
///
/// Core chat controller managing messages, sending, revoking, multi-select, typing state, and drag-drop.
class ChatController extends WireController {
  static final Logger _logger = Logger('ChatController');

  /// 会话 ID。
  final String conversationId;

  /// 会话详情信号。
  late final Signal<ConversationInfo?> conversation =
      createSignal<ConversationInfo?>(null);

  /// 消息列表信号（按发送时间降序：index 0 为最新消息，配合 `reverse: true` 列表显示在最底部）。
  late final Signal<List<Message>> messages = createSignal<List<Message>>(
    <Message>[],
  );

  /// 首次历史加载状态（不阻断页面交互，仅用于空态判定）。
  late final Signal<bool> loading = createSignal<bool>(true);

  /// 上滑分页拉取更多历史消息状态（用于顶部细进度条）。
  late final Signal<bool> loadingHistory = createSignal<bool>(false);

  /// 浏览历史消息时新到达的未读条数（用于底部回底提示胶囊）。
  late final Signal<int> unreadNewCount = createSignal<int>(0);

  /// 对端是否正在输入。
  late final Signal<bool> peerTyping = createSignal<bool>(false);

  /// 当前引用的消息。
  late final Signal<Message?> quotingMessage = createSignal<Message?>(null);

  /// 是否处于多选模式。
  late final Signal<bool> multiSelectMode = createSignal<bool>(false);

  /// 多选已选中的客户端消息 ID 集合。
  late final Signal<Set<String>> selectedMsgIDs = createSignal<Set<String>>(
    <String>{},
  );

  /// 桌面端拖拽悬停态。
  late final Signal<bool> draggingOver = createSignal<bool>(false);

  /// 聊天列表滚动控制器。
  late final ScrollController scrollController;

  /// `scrollview_observer` 列表观察控制器（对齐 `xue_hua_im`）。
  late final ListObserverController chatListObserver;

  /// `scrollview_observer` 聊天保位与顶对齐控制器。
  late final ChatScrollObserver chatScrollObserver;

  static const int _pageSize = 30;
  double _lastScrollOffset = 0;
  bool _isInitialLoadComplete = false;
  bool _hasMoreHistory = true;
  bool _needIncrementUnread = false;
  Future<void>? _loadMoreInFlight;

  StreamSubscription<ImMessageEvent>? _msgSub;
  StreamSubscription<ImConversationEvent>? _convSub;

  /// 创建聊天控制器。
  ChatController({required this.conversationId, ConversationInfo? initial}) {
    if (initial != null) {
      conversation.value = initial;
    }
    scrollController = ScrollController()..addListener(_onScroll);
    chatListObserver = ListObserverController(controller: scrollController)
      ..cacheJumpIndexOffset = false;
    chatScrollObserver = ChatScrollObserver(chatListObserver)
      ..fixedPositionOffset = 5
      ..toRebuildScrollViewCallback = () {
        messages.value = List<Message>.of(messages.value);
      }
      ..onHandlePositionResultCallback =
          (ChatScrollObserverHandlePositionResultModel result) {
            if (!_needIncrementUnread) {
              return;
            }
            if (result.type ==
                ChatScrollObserverHandlePositionType.keepPosition) {
              unreadNewCount.value += result.changeCount;
            } else {
              _needIncrementUnread = false;
              unreadNewCount.value = 0;
            }
          };
  }

  /// 是否群聊。
  bool get isGroup => conversation.value?.isGroupChat ?? false;

  /// 单聊目标用户 ID。
  String? get peerUserID => isGroup ? null : conversation.value?.userID;

  /// 群聊目标群 ID。
  String? get groupID => isGroup ? conversation.value?.groupID : null;

  bool get _isAtBottom =>
      !scrollController.hasClients || scrollController.offset < 50;

  bool get _isNearTop =>
      scrollController.hasClients &&
      scrollController.offset >= scrollController.position.maxScrollExtent - 40;

  @override
  void onInit() {
    super.onInit();
    final ImEventBus bus = Wire.find<ImEventBus>();
    _msgSub = bus.messageStream.listen(_onMessageEvent);
    _convSub = bus.conversationStream.listen(_onConversationEvent);
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    // 标记已读异步上报，绝不阻塞首屏历史消息秒开（对齐 xue_hua_im）。
    unawaited(
      OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
        conversationID: conversationId,
      ),
    );
    try {
      if (conversation.value == null) {
        final List<ConversationInfo> list = await OpenIM
            .iMManager
            .conversationManager
            .getMultipleConversation(
              conversationIDList: <String>[conversationId],
            );
        if (list.isNotEmpty) {
          conversation.value = list.first;
        }
      }
      await loadHistory();
    } on Object catch (error, stackTrace) {
      _logger.warning('Chat bootstrap failed', error, stackTrace);
    } finally {
      _isInitialLoadComplete = true;
      loading.value = false;
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) {
      return;
    }
    final double offset = scrollController.offset;
    final bool scrollingUp = offset > _lastScrollOffset;
    _lastScrollOffset = offset;

    if (_isInitialLoadComplete &&
        _hasMoreHistory &&
        scrollingUp &&
        _isNearTop &&
        !loadingHistory.value) {
      unawaited(loadHistory(loadMore: true));
    }

    if (_isAtBottom && unreadNewCount.value > 0) {
      _needIncrementUnread = false;
      unreadNewCount.value = 0;
    }
  }

  /// 滚动回最新消息底部并清空新消息提示计数。
  void scrollToBottom({bool animate = false}) {
    _needIncrementUnread = false;
    unreadNewCount.value = 0;
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!scrollController.hasClients) {
        return;
      }
      if (animate) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } else {
        scrollController.jumpTo(0);
      }
    });
  }

  /// 拉取历史消息（SDK 已按 `sendTime DESC, seq DESC` 返回，直接配合 `reverse: true` 渲染）。
  Future<void> loadHistory({bool loadMore = false}) {
    if (loadMore) {
      if (_loadMoreInFlight != null) {
        return _loadMoreInFlight!;
      }
      final Future<void> run = _loadHistoryBody(loadMore: true);
      _loadMoreInFlight = run;
      return run.whenComplete(() {
        if (identical(_loadMoreInFlight, run)) {
          _loadMoreInFlight = null;
        }
      });
    }
    return _loadHistoryBody(loadMore: false);
  }

  Future<void> _loadHistoryBody({required bool loadMore}) async {
    if (loadMore) {
      loadingHistory.value = true;
    }
    try {
      final Message? startMsg = loadMore && messages.value.isNotEmpty
          ? messages.value.last
          : null;
      final AdvancedMessage res = await OpenIM.iMManager.messageManager
          .getAdvancedHistoryMessageList(
            conversationID: conversationId,
            startMsg: startMsg,
            count: _pageSize,
          );
      final List<Message> fetched = res.messageList ?? <Message>[];
      _hasMoreHistory = res.isEnd != true;
      if (loadMore) {
        if (fetched.isEmpty) {
          _hasMoreHistory = false;
          return;
        }
        final Set<String> existingClient = <String>{};
        final Set<String> existingServer = <String>{};
        for (final Message m in messages.value) {
          if ((m.clientMsgID ?? '').isNotEmpty) {
            existingClient.add(m.clientMsgID!);
          }
          if ((m.serverMsgID ?? '').isNotEmpty) {
            existingServer.add(m.serverMsgID!);
          }
        }
        final List<Message> filtered = fetched.where((Message m) {
          final String cid = m.clientMsgID ?? '';
          final String sid = m.serverMsgID ?? '';
          if (cid.isNotEmpty && existingClient.contains(cid)) {
            return false;
          }
          if (sid.isNotEmpty && existingServer.contains(sid)) {
            return false;
          }
          return true;
        }).toList();
        if (filtered.isEmpty) {
          _hasMoreHistory = false;
          return;
        }
        final int lengthBefore = messages.value.length;
        messages.value = <Message>[...messages.value, ...filtered];
        if (lengthBefore < 20 && messages.value.length >= 20) {
          chatListObserver.reattach();
        }
      } else {
        messages.value = fetched;
        chatListObserver.reattach();
        chatScrollObserver.observeSwitchShrinkWrap();
        scrollToBottom();
      }
    } on Object catch (error, stackTrace) {
      _logger.warning('loadHistory failed', error, stackTrace);
    } finally {
      if (loadMore) {
        loadingHistory.value = false;
      }
    }
  }

  void _onMessageEvent(ImMessageEvent event) {
    if (event.kind == 'newMessage' && event.message != null) {
      final Message msg = event.message!;
      if (_belongsToThisChat(msg)) {
        _insertOrUpdateIncoming(msg);
        unawaited(
          OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
            conversationID: conversationId,
          ),
        );
      }
    } else if (event.kind == 'statusChanged' && event.message != null) {
      if (_belongsToThisChat(event.message!)) {
        _upsertMessage(event.message!);
      }
    } else if (event.kind == 'deleted' && event.message != null) {
      messages.value = messages.value
          .where((Message m) => m.clientMsgID != event.message!.clientMsgID)
          .toList();
    } else if (event.kind == 'revoked' && event.revokedInfo != null) {
      unawaited(loadHistory());
    }
  }

  void _onConversationEvent(ImConversationEvent event) {
    if (event.kind == 'inputStatus' && event.inputStatus != null) {
      if (event.inputStatus!.conversationID == conversationId) {
        peerTyping.value =
            (event.inputStatus!.platformIDs ?? const <int>[]).isNotEmpty;
      }
    }
  }

  bool _belongsToThisChat(Message msg) {
    if (isGroup) {
      return msg.groupID == groupID;
    }
    return msg.sendID == peerUserID || msg.recvID == peerUserID;
  }

  void _insertOrUpdateIncoming(Message msg) {
    final List<Message> current = messages.value;
    final int idx = current.indexWhere(
      (Message m) =>
          m.clientMsgID == msg.clientMsgID ||
          ((msg.serverMsgID ?? '').isNotEmpty &&
              m.serverMsgID == msg.serverMsgID),
    );
    if (idx >= 0) {
      final List<Message> next = List<Message>.from(current);
      next[idx] = msg;
      messages.value = next;
      return;
    }
    final bool atBottom = _isAtBottom;
    if (!atBottom) {
      _needIncrementUnread = true;
    }
    chatScrollObserver.standby();
    messages.value = <Message>[msg, ...current];
    if (atBottom) {
      scrollToBottom();
    }
  }

  void _upsertMessage(Message msg, {bool scrollToEnd = false}) {
    final List<Message> next = List<Message>.from(messages.value);
    final int idx = next.indexWhere(
      (Message m) => m.clientMsgID == msg.clientMsgID,
    );
    if (idx >= 0) {
      next[idx] = msg;
      messages.value = next;
    } else {
      chatScrollObserver.standby();
      next.insert(0, msg);
      messages.value = next;
      if (scrollToEnd) {
        scrollToBottom(animate: true);
      }
    }
  }

  /// 发送文本或引用回复消息。
  Future<void> sendText(String rawText) async {
    final String text = rawText.trim();
    if (text.isEmpty) {
      return;
    }
    final Message? quote = quotingMessage.value;
    final Message msg = quote != null
        ? OpenIM.iMManager.messageManager.createQuoteMessage(
            text: text,
            quoteMsg: quote,
          )
        : OpenIM.iMManager.messageManager.createTextMessage(text: text);
    quotingMessage.value = null;
    await _dispatchMessage(msg);
  }

  /// 发送图片（经 `MediaService` 压缩与元信息校验）。
  Future<void> pickAndSendImage({bool fromCamera = false}) async {
    final MediaService media = Wire.find<MediaService>();
    final PlatformFile? file = fromCamera
        ? await media.capturePhoto()
        : await media.pickSingleImage();
    if (file == null) {
      return;
    }
    if ((file.path ?? '').isNotEmpty) {
      final String outPath =
          '/tmp/openim_img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String finalPath = await media.compressImageIfSupported(
        file.path!,
        outPath,
      );
      await media.readImageInfo(finalPath);
      final Message msg = await OpenIM.iMManager.messageManager
          .createImageMessageFromFullPath(imagePath: finalPath);
      await _dispatchMessage(msg);
    } else if (file.bytes != null) {
      final Message msg = await OpenIM.iMManager.messageManager
          .createImageMessageByFile(bytes: file.bytes!, fileName: file.name);
      await _dispatchMessage(msg);
    }
  }

  /// 发送视频（经 `MediaService` 压缩与时长读取）。
  Future<void> pickAndSendVideo() async {
    final MediaService media = Wire.find<MediaService>();
    final PlatformFile? file = await media.pickVideo();
    if (file == null || (file.path ?? '').isEmpty) {
      return;
    }
    final String outPath =
        '/tmp/openim_vid_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final String finalPath = await media.compressVideoIfSupported(
      file.path!,
      outPath,
    );
    final media_info.AvMetadata? av = await media.readAvInfo(finalPath);
    final int durationSecs = (av?.duration?.inSeconds ?? 1).clamp(1, 3600);
    final Message msg = await OpenIM.iMManager.messageManager
        .createVideoMessageFromFullPath(
          videoPath: finalPath,
          videoType: 'mp4',
          duration: durationSecs,
          snapshotPath: '',
        );
    await _dispatchMessage(msg);
  }

  /// 发送语音消息。
  Future<void> sendVoice(String path, int durationSeconds) async {
    final Message msg = OpenIM.iMManager.messageManager
        .createSoundMessageFromFullPath(
          soundPath: path,
          duration: durationSeconds,
        );
    await _dispatchMessage(msg);
  }

  /// 选择并发送任意文件。
  Future<void> pickAndSendFile() async {
    final PlatformFile? file = await Wire.find<MediaService>().pickAnyFile();
    if (file == null) {
      return;
    }
    final Message msg = (file.path ?? '').isNotEmpty
        ? OpenIM.iMManager.messageManager.createFileMessageFromFullPath(
            filePath: file.path!,
            fileName: file.name,
          )
        : OpenIM.iMManager.messageManager.createFileMessageByFile(
            bytes: file.bytes!,
            fileName: file.name,
          );
    await _dispatchMessage(msg);
  }

  /// 处理桌面端拖拽文件发送（`xue_hua_navite_drag_drop`）。
  Future<void> handleDroppedItems(List<DropItem> items) async {
    for (final DropItem item in items) {
      if (item.isDirectory) {
        continue;
      }
      final String? path = item.path;
      if (path != null && path.isNotEmpty) {
        final Message msg = OpenIM.iMManager.messageManager
            .createFileMessageFromFullPath(filePath: path, fileName: item.name);
        await _dispatchMessage(msg);
      }
    }
  }

  /// 发送位置消息。
  Future<void> sendLocation({
    required String description,
    required double latitude,
    required double longitude,
  }) async {
    final Message msg = OpenIM.iMManager.messageManager.createLocationMessage(
      latitude: latitude,
      longitude: longitude,
      description: description,
    );
    await _dispatchMessage(msg);
  }

  /// 发送个人名片消息。
  Future<void> sendContactCard(FriendInfo friend) async {
    final Message msg = OpenIM.iMManager.messageManager.createCardMessage(
      userID: friend.friendUserID ?? '',
      nickname: friend.getShowName(),
      faceURL: friend.faceURL,
    );
    await _dispatchMessage(msg);
  }

  /// 发送 SVG 动效贴纸消息。
  Future<void> sendSvgSticker(String assetPath) async {
    final Message msg = OpenIM.iMManager.messageManager.createFaceMessage(
      index: 0,
      data: assetPath,
    );
    await _dispatchMessage(msg);
  }

  /// 上报正在输入状态。
  void notifyTyping(bool focus) {
    if (!isGroup) {
      unawaited(
        OpenIM.iMManager.conversationManager.changeInputStates(
          conversationID: conversationId,
          focus: focus,
        ),
      );
    }
  }

  /// 复制消息内容到系统剪切板。
  Future<void> copyMessage(Message msg) async {
    final String text =
        msg.textElem?.content ??
        msg.quoteElem?.text ??
        msg.fileElem?.fileName ??
        msg.locationElem?.description ??
        '[${msg.contentType?.name ?? '消息'}]';
    await XueHuaNaviteClipboard.instance.writeText(text);
    await FlutterToastPro.success('已复制到剪切板');
  }

  /// 撤回消息。
  Future<void> revokeMessage(Message msg) async {
    try {
      await OpenIM.iMManager.messageManager.revokeMessage(
        conversationID: conversationId,
        clientMsgID: msg.clientMsgID ?? '',
      );
      await loadHistory();
    } on Object catch (error) {
      await FlutterToastPro.error('撤回失败：$error');
    }
  }

  /// 收藏消息。
  Future<void> favoriteMessage(Message msg) async {
    try {
      await OpenIM.iMManager.favoriteManager.addMessage(message: msg);
      await FlutterToastPro.success('已添加到我的收藏');
    } on Object catch (error) {
      await FlutterToastPro.error('收藏失败：$error');
    }
  }

  /// 删除单条消息。
  Future<void> deleteMessage(Message msg) async {
    try {
      await OpenIM.iMManager.messageManager.deleteMessageFromLocalAndSvr(
        conversationID: conversationId,
        clientMsgID: msg.clientMsgID ?? '',
      );
      messages.value = messages.value
          .where((Message m) => m.clientMsgID != msg.clientMsgID)
          .toList();
    } on Object catch (error) {
      await FlutterToastPro.error('删除失败：$error');
    }
  }

  /// 保存消息附件到本地（后台下载器或相册）。
  Future<void> saveMessageToLocal(Message msg) async {
    final DownloadService downloader = Wire.find<DownloadService>();
    if (msg.contentType == MessageType.file &&
        (msg.fileElem?.sourceUrl ?? '').isNotEmpty) {
      await downloader.enqueue(
        url: msg.fileElem!.sourceUrl!,
        fileName: msg.fileElem!.fileName ?? 'file',
      );
      await FlutterToastPro.success('已加入后台下载队列');
    } else if (msg.contentType == MessageType.picture &&
        (msg.pictureElem?.sourcePicture?.url ?? '').isNotEmpty) {
      await downloader.enqueue(
        url: msg.pictureElem!.sourcePicture!.url!,
        fileName: 'image_${msg.clientMsgID ?? 'img'}.jpg',
      );
      await FlutterToastPro.success('已加入后台下载队列');
    } else {
      await copyMessage(msg);
    }
  }

  /// 调用系统外部分享。
  Future<void> shareMessageExternally(Message msg) async {
    if (msg.contentType == MessageType.file &&
        (msg.fileElem?.sourceUrl ?? '').isNotEmpty) {
      await XueHuaNaviteShare.instance.shareUri(
        Uri.parse(msg.fileElem!.sourceUrl!),
        subject: msg.fileElem!.fileName,
      );
    } else if (msg.contentType == MessageType.picture &&
        (msg.pictureElem?.sourcePicture?.url ?? '').isNotEmpty) {
      await XueHuaNaviteShare.instance.shareUri(
        Uri.parse(msg.pictureElem!.sourcePicture!.url!),
        subject: '图片分享',
      );
    } else {
      await XueHuaNaviteShare.instance.shareText(
        msg.textElem?.content ?? msg.quoteElem?.text ?? '[消息分享]',
      );
    }
  }

  /// 转发单条或合并消息至目标会话。
  Future<void> forwardMessages(
    List<Message> list,
    ConversationInfo target, {
    bool merged = false,
  }) async {
    try {
      if (merged) {
        final Message
        mergeMsg = OpenIM.iMManager.messageManager.createMergeMessage(
          messageList: list,
          title: '${conversation.value?.showName ?? '会话'}的聊天记录',
          summaryList: list
              .take(4)
              .map(
                (Message m) =>
                    '${m.senderNickname ?? ''}: ${m.textElem?.content ?? '[消息]'}',
              )
              .toList(),
        );
        await OpenIM.iMManager.messageManager.sendMessage(
          message: mergeMsg,
          userID: target.isSingleChat ? target.userID : null,
          groupID: target.isGroupChat ? target.groupID : null,
          offlinePushInfo: OfflinePushInfo(title: '[聊天记录]'),
        );
      } else {
        for (final Message m in list) {
          final Message fwd = OpenIM.iMManager.messageManager
              .createForwardMessage(message: m);
          await OpenIM.iMManager.messageManager.sendMessage(
            message: fwd,
            userID: target.isSingleChat ? target.userID : null,
            groupID: target.isGroupChat ? target.groupID : null,
            offlinePushInfo: OfflinePushInfo(title: '[转发消息]'),
          );
        }
      }
      multiSelectMode.value = false;
      selectedMsgIDs.value = <String>{};
      await FlutterToastPro.success('转发成功');
    } on Object catch (error) {
      await FlutterToastPro.error('转发失败：$error');
    }
  }

  /// 切换多选选中状态。
  void toggleSelect(String clientMsgID) {
    final Set<String> next = Set<String>.from(selectedMsgIDs.value);
    if (next.contains(clientMsgID)) {
      next.remove(clientMsgID);
    } else {
      next.add(clientMsgID);
    }
    selectedMsgIDs.value = next;
  }

  /// 获取多选已选消息列表。
  List<Message> getSelectedMessages() {
    final Set<String> ids = selectedMsgIDs.value;
    return messages.value
        .where((Message m) => ids.contains(m.clientMsgID ?? ''))
        .toList();
  }

  Future<void> _dispatchMessage(Message msg) async {
    final Message stamped = (msg.sendTime == null || msg.sendTime == 0)
        ? msg.copyWith(sendTime: DateTime.now().millisecondsSinceEpoch)
        : msg;
    _upsertMessage(stamped, scrollToEnd: true);
    try {
      final Message sent = await OpenIM.iMManager.messageManager.sendMessage(
        message: stamped,
        userID: peerUserID,
        groupID: groupID,
        offlinePushInfo: OfflinePushInfo(
          title: OpenIM.iMManager.userInfo.nickname ?? '新消息',
          desc: stamped.textElem?.content ?? '[新消息]',
        ),
      );
      _upsertMessage(sent);
    } on Object catch (error, stackTrace) {
      _logger.warning('sendMessage failed', error, stackTrace);
      await FlutterToastPro.error('发送失败：$error');
    }
  }

  @override
  void onClose() {
    _msgSub?.cancel();
    _convSub?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
