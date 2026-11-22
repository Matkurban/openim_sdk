import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_drag_drop/xue_hua_navite_drag_drop.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/contact_picker_page.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../../shared/widgets/share_target_picker_sheet.dart';
import 'chat_controller.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble_shell.dart';

/// 聊天核心页（对标微信：全类型气泡、长按/右键菜单、多选转发/合并转发/收藏/删除、桌面拖拽发送）。
///
/// Core WeChat-style chat page with desktop file drag-and-drop and full bubble interactions.
class ChatPage extends StatefulWidget {
  /// 会话 ID。
  final String conversationId;

  /// 初始会话对象（可选）。
  final ConversationInfo? initialConversation;

  /// 创建聊天页。
  const ChatPage({
    super.key,
    required this.conversationId,
    this.initialConversation,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with WireStateMixin<ChatPage, ChatController> {
  final TextEditingController _inputController = TextEditingController();

  @override
  String? get tag => widget.conversationId;

  @override
  ChatController? wire() => ChatController(
    conversationId: widget.conversationId,
    initial: widget.initialConversation,
  );

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _sendLocation() async {
    final Object? picked = await AdaptiveRouter.of(context)
        .pushNamed(AppRoutes.locationPicker);
    if (picked is Map<String, Object>) {
      await controller.sendLocation(
        description: picked['description'] as String? ?? '位置',
        latitude: picked['latitude'] as double? ?? 0,
        longitude: picked['longitude'] as double? ?? 0,
      );
    }
  }

  Future<void> _sendCard() async {
    final List<FriendInfo>? picked = await ContactPickerPage.pick(
      context,
      title: '选择要发送的名片',
      multiSelect: false,
    );
    if (picked != null && picked.isNotEmpty) {
      await controller.sendContactCard(picked.first);
    }
  }

  Future<void> _startCall() async {
    final String? peer = controller.peerUserID;
    if (peer == null || peer.isEmpty) {
      await FlutterToastPro.info('群通话请先选择成员');
      return;
    }
    try {
      final CallSession session = await OpenIM.iMManager.callManager.invite(
        inviteeUserIDs: <String>[peer],
        callType: CallType.video,
      );
      if (mounted) {
        await AdaptiveRouter.of(context)
            .pushNamed(AppRoutes.call, arguments: session);
      }
    } on Object catch (error) {
      await FlutterToastPro.error('发起通话失败：$error');
    }
  }

  Future<void> _forwardBatch({required bool merged}) async {
    final List<Message> selected = controller.getSelectedMessages();
    if (selected.isEmpty) {
      await FlutterToastPro.warning('请先选择消息');
      return;
    }
    final ConversationInfo? target = await ShareTargetPickerSheet.pick(
      context,
      title: merged ? '合并转发至...' : '逐条转发至...',
    );
    if (target != null) {
      await controller.forwardMessages(selected, target, merged: merged);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    return NativeDropRegion(
      onDragEnter: (NativeDragEvent _) {
        if (!controller.isNotification) {
          controller.draggingOver.value = true;
        }
      },
      onDragExit: () => controller.draggingOver.value = false,
      onPerformDrop: (NativeDropEvent event) async {
        controller.draggingOver.value = false;
        if (!controller.isNotification) {
          await controller.handleDroppedItems(event.items);
        }
      },
      child: SignalBuilder(
        builder: (BuildContext _) {
          final ConversationInfo? conv = controller.conversation.value;
          final bool typing = controller.peerTyping.value;
          final bool multiSelect = controller.multiSelectMode.value;
          final Set<String> selectedIDs = controller.selectedMsgIDs.value;
          final List<Message> msgs = controller.messages.value;
          final bool isDragging = controller.draggingOver.value;
          final bool loadingHistory = controller.loadingHistory.value;
          final int unreadNewCount = controller.unreadNewCount.value;
          final ThemeData theme = Theme.of(context);

          return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    conv?.showName ?? widget.conversationId,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (typing)
                    const Text(
                      '对方正在输入...',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
              actions: <Widget>[
                if (multiSelect)
                  TextButton(
                    onPressed: () {
                      controller.multiSelectMode.value = false;
                      controller.selectedMsgIDs.value = <String>{};
                    },
                    child: const Text('取消'),
                  )
                else if (!controller.isNotification)
                  IconButton(
                    tooltip: '聊天详情',
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      final String chatLoc = AppRoutes.chat(
                        widget.conversationId,
                      );
                      router.pushNamedAndRemoveUntil(
                        controller.isGroup
                            ? AppRoutes.groupChatDetail(widget.conversationId)
                            : AppRoutes.privateChatDetail(
                                widget.conversationId,
                              ),
                        (AdaptiveRouteMatch m) => m.matchedLocation == chatLoc,
                      );
                    },
                  ),
              ],
              bottom: loadingHistory
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(2),
                      child: LinearProgressIndicator(minHeight: 2),
                    )
                  : null,
            ),
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          if (msgs.isEmpty && !controller.loading.value)
                            const EmptyStateView(
                              title: '暂无聊天消息',
                              subtitle: '发送文字、语音、媒体或直接拖拽本地文件到此处',
                            )
                          else
                            Align(
                              alignment: Alignment.topCenter,
                              child: ListViewObserver(
                                controller: controller.chatListObserver,
                                child: ListView.builder(
                                  reverse: true,
                                  controller: controller.scrollController,
                                  physics: ChatObserverClampingScrollPhysics(
                                    observer: controller.chatScrollObserver,
                                  ),
                                  shrinkWrap: msgs.length < 20
                                      ? controller
                                            .chatScrollObserver
                                            .isShrinkWrap
                                      : false,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  itemCount: msgs.length,
                                  itemBuilder: (BuildContext _, int index) {
                                    final Message msg = msgs[index];
                                    final String cid = msg.clientMsgID ?? '';
                                    return MessageBubbleShell(
                                      key: ValueKey<String>(
                                        cid.isNotEmpty
                                            ? cid
                                            : '${msg.seq ?? index}',
                                      ),
                                      message: msg,
                                      conversationId: widget.conversationId,
                                      isGroup: controller.isGroup,
                                      multiSelectMode: multiSelect,
                                      selected: selectedIDs.contains(cid),
                                      onToggleSelect: () =>
                                          controller.toggleSelect(cid),
                                      onCopy: () => controller.copyMessage(msg),
                                      onReply: () =>
                                          controller.quotingMessage.value = msg,
                                      onForward: () async {
                                        final ConversationInfo? target =
                                            await ShareTargetPickerSheet.pick(
                                              context,
                                              title: '转发消息给...',
                                            );
                                        if (target != null) {
                                          await controller.forwardMessages(
                                            <Message>[msg],
                                            target,
                                          );
                                        }
                                      },
                                      onRevoke: () =>
                                          controller.revokeMessage(msg),
                                      onFavorite: () =>
                                          controller.favoriteMessage(msg),
                                      onEnterMultiSelect: () {
                                        controller.multiSelectMode.value = true;
                                        controller.toggleSelect(cid);
                                      },
                                      onSaveLocal: () =>
                                          controller.saveMessageToLocal(msg),
                                      onExternalShare: () => controller
                                          .shareMessageExternally(msg),
                                      onDelete: () =>
                                          controller.deleteMessage(msg),
                                    );
                                  },
                                ),
                              ),
                            ),
                          if (unreadNewCount > 0)
                            Positioned(
                              bottom: 14,
                              right: 12,
                              child: GestureDetector(
                                onTap: () =>
                                    controller.scrollToBottom(animate: true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(9999),
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '$unreadNewCount 条新消息',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (multiSelect)
                      _MultiSelectActionBar(
                        selectedCount: selectedIDs.length,
                        onForwardOneByOne: () => _forwardBatch(merged: false),
                        onForwardMerged: () => _forwardBatch(merged: true),
                        onFavoriteAll: () async {
                          for (final Message m
                              in controller.getSelectedMessages()) {
                            await controller.favoriteMessage(m);
                          }
                          controller.multiSelectMode.value = false;
                          controller.selectedMsgIDs.value = <String>{};
                        },
                        onDeleteAll: () async {
                          for (final Message m
                              in controller.getSelectedMessages()) {
                            await controller.deleteMessage(m);
                          }
                          controller.multiSelectMode.value = false;
                          controller.selectedMsgIDs.value = <String>{};
                        },
                      )
                    else if (!controller.isNotification)
                      ChatInputBar(
                        textController: _inputController,
                        quotingMessage: controller.quotingMessage.value,
                        onCancelQuote: () =>
                            controller.quotingMessage.value = null,
                        onTextChanged: (String v) =>
                            controller.notifyTyping(v.isNotEmpty),
                        onSendText: () {
                          final String text = _inputController.text;
                          _inputController.clear();
                          controller.sendText(text);
                        },
                        onSendVoice: controller.sendVoice,
                        onSendSvgSticker: controller.sendSvgSticker,
                        onPickImage: () => controller.pickAndSendImage(),
                        onCapturePhoto: () =>
                            controller.pickAndSendImage(fromCamera: true),
                        onPickVideo: controller.pickAndSendVideo,
                        onPickFile: controller.pickAndSendFile,
                        onPickLocation: _sendLocation,
                        onPickCard: _sendCard,
                        onSendRedPacket: () => router.pushNamedAndRemoveUntil(
                          AppRoutes.sendRedPacket(widget.conversationId),
                          (AdaptiveRouteMatch m) =>
                              m.matchedLocation ==
                              AppRoutes.chat(widget.conversationId),
                          arguments: conv,
                        ),
                        onStartCall: _startCall,
                      ),
                  ],
                ),
                if (isDragging)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        color: Theme.of(context).colorScheme.primary
                            .withValues(alpha: 0.14),
                        alignment: Alignment.center,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const <Widget>[
                                Icon(Icons.file_upload_outlined, size: 28),
                                SizedBox(width: 10),
                                Text('松开鼠标即可发送拖拽文件到当前会话'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MultiSelectActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onForwardOneByOne;
  final VoidCallback onForwardMerged;
  final VoidCallback onFavoriteAll;
  final VoidCallback onDeleteAll;

  const _MultiSelectActionBar({
    required this.selectedCount,
    required this.onForwardOneByOne,
    required this.onForwardMerged,
    required this.onFavoriteAll,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton.icon(
              onPressed: selectedCount > 0 ? onForwardOneByOne : null,
              icon: const Icon(Icons.forward, size: 18),
              label: const Text('逐条转发'),
            ),
            TextButton.icon(
              onPressed: selectedCount > 0 ? onForwardMerged : null,
              icon: const Icon(Icons.layers_outlined, size: 18),
              label: const Text('合并转发'),
            ),
            TextButton.icon(
              onPressed: selectedCount > 0 ? onFavoriteAll : null,
              icon: const Icon(Icons.star_border, size: 18),
              label: const Text('收藏'),
            ),
            TextButton.icon(
              onPressed: selectedCount > 0 ? onDeleteAll : null,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('删除'),
            ),
          ],
        ),
      ),
    );
  }
}
