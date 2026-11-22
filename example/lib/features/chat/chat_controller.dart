import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
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

  /// 消息列表信号（按发送时间倒序，配合 `reverse: true` 列表渲染）。
  late final Signal<List<Message>> messages = createSignal<List<Message>>(
    <Message>[],
  );

  /// 是否正在加载历史消息。
  late final Signal<bool> loading = createSignal<bool>(true);

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

  StreamSubscription<ImMessageEvent>? _msgSub;
  StreamSubscription<ImConversationEvent>? _convSub;

  /// 创建聊天控制器。
  ChatController({required this.conversationId, ConversationInfo? initial}) {
    if (initial != null) {
      conversation.value = initial;
    }
  }

  /// 是否群聊。
  bool get isGroup => conversation.value?.isGroupChat ?? false;

  /// 单聊目标用户 ID。
  String? get peerUserID => isGroup ? null : conversation.value?.userID;

  /// 群聊目标群 ID。
  String? get groupID => isGroup ? conversation.value?.groupID : null;

  @override
  void onInit() {
    super.onInit();
    final ImEventBus bus = Wire.find<ImEventBus>();
    _msgSub = bus.messageStream.listen(_onMessageEvent);
    _convSub = bus.conversationStream.listen(_onConversationEvent);
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
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
      await OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
        conversationID: conversationId,
      );
    } on Object catch (error, stackTrace) {
      _logger.warning('Chat bootstrap failed', error, stackTrace);
    } finally {
      loading.value = false;
    }
  }

  /// 拉取历史消息。
  Future<void> loadHistory({bool loadMore = false}) async {
    try {
      final Message? startMsg = loadMore && messages.value.isNotEmpty
          ? messages.value.last
          : null;
      final AdvancedMessage res = await OpenIM.iMManager.messageManager
          .getAdvancedHistoryMessageList(
            conversationID: conversationId,
            startMsg: startMsg,
            count: 30,
          );
      final List<Message> fetched = (res.messageList ?? <Message>[]).reversed
          .toList();
      if (loadMore) {
        messages.value = <Message>[...messages.value, ...fetched];
      } else {
        messages.value = fetched;
      }
    } on Object catch (error, stackTrace) {
      _logger.warning('loadHistory failed', error, stackTrace);
    }
  }

  void _onMessageEvent(ImMessageEvent event) {
    if (event.kind == 'newMessage' && event.message != null) {
      final Message msg = event.message!;
      if (_belongsToThisChat(msg)) {
        _upsertMessage(msg);
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

  void _upsertMessage(Message msg) {
    final List<Message> next = List<Message>.from(messages.value);
    final int idx = next.indexWhere(
      (Message m) => m.clientMsgID == msg.clientMsgID,
    );
    if (idx >= 0) {
      next[idx] = msg;
    } else {
      next.insert(0, msg);
    }
    messages.value = next;
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
    _upsertMessage(msg);
    try {
      final Message sent = await OpenIM.iMManager.messageManager.sendMessage(
        message: msg,
        userID: peerUserID,
        groupID: groupID,
        offlinePushInfo: OfflinePushInfo(
          title: OpenIM.iMManager.userInfo.nickname ?? '新消息',
          desc: msg.textElem?.content ?? '[新消息]',
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
    super.onClose();
  }
}
