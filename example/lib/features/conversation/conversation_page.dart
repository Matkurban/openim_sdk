import 'package:chat_context_menu/chat_context_menu.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/empty_state_view.dart';
import 'conversation_controller.dart';
import 'widgets/conversation_tile.dart';

/// Tab 1：会话列表页（含顶部搜索栏、AppBar 圆形 `+` 号弹出面板与全功能会话列表）。
///
/// Tab 1: Conversation list page with `+` quick menu and context-menu tiles.
class ConversationPage extends WireView<ConversationController> {
  /// 创建会话列表页。
  const ConversationPage({super.key});

  @override
  ConversationController? wire() => ConversationController();

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    return Scaffold(
      appBar: AppBar(
        title: SignalBuilder(
          builder: (BuildContext _) {
            final int? progress = controller.syncProgress.value;
            return Text(progress != null ? '消息 (同步中 $progress%)' : '消息');
          },
        ),
        actions: <Widget>[
          IconButton(
            tooltip: '全部标为已读',
            icon: const Icon(Icons.done_all),
            onPressed: controller.markAllAsRead,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _PlusQuickActionMenu(
              onAddContact: () => router.pushNamedAndRemoveUntil(
                AppRoutes.addContact,
                (AdaptiveRouteMatch _) => false,
              ),
              onCreateGroup: () => router.pushNamedAndRemoveUntil(
                AppRoutes.createGroup,
                (AdaptiveRouteMatch _) => false,
              ),
              onJoinGroup: () => router.pushNamedAndRemoveUntil(
                AppRoutes.joinGroup,
                (AdaptiveRouteMatch _) => false,
              ),
              onScanQr: () => router.pushNamed(AppRoutes.scanner),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: InkWell(
              onTap: () => router.pushNamedAndRemoveUntil(
                AppRoutes.globalSearch,
                (AdaptiveRouteMatch _) => false,
              ),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      size: 18,
                      color: Theme.of(context).hintColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '搜索联系人、群聊或聊天记录',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SignalBuilder(
              builder: (BuildContext _) {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final List<ConversationInfo> list =
                    controller.conversations.value;
                if (list.isEmpty) {
                  return EmptyStateView(
                    title: '暂无会话',
                    subtitle: '点击右上角 + 号添加好友或发起群聊',
                    actionLabel: '添加联系人',
                    onAction: () => router.pushNamedAndRemoveUntil(
                      AppRoutes.addContact,
                      (AdaptiveRouteMatch _) => false,
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.loadConversations,
                  child: ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (BuildContext _, int _) =>
                        const Divider(height: 1, indent: 74),
                    itemBuilder: (BuildContext _, int index) {
                      final ConversationInfo conv = list[index];
                      return ConversationTile(
                        conversation: conv,
                        onTap: () => router.pushNamedAndRemoveUntil(
                          AppRoutes.chat(conv.conversationID),
                          (AdaptiveRouteMatch _) => false,
                          arguments: conv,
                        ),
                        onTogglePin: () => controller.togglePin(conv),
                        onToggleMute: () => controller.toggleMute(conv),
                        onMarkRead: () => controller.markAsRead(conv),
                        onHide: () => controller.hideConversation(conv),
                        onClearHistory: () => controller.clearHistory(conv),
                        onDelete: () => controller.deleteConversation(conv),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlusQuickActionMenu extends StatelessWidget {
  final VoidCallback onAddContact;
  final VoidCallback onCreateGroup;
  final VoidCallback onJoinGroup;
  final VoidCallback onScanQr;

  const _PlusQuickActionMenu({
    required this.onAddContact,
    required this.onCreateGroup,
    required this.onJoinGroup,
    required this.onScanQr,
  });

  @override
  Widget build(BuildContext context) {
    return ChatContextMenuWrapper(
      barrierColor: Colors.black12,
      widgetBuilder: (BuildContext _, VoidCallback showMenu, VoidCallback _) {
        return InkWell(
          onTap: showMenu,
          customBorder: const CircleBorder(),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface
                    .withValues(alpha: 0.35),
              ),
            ),
            child: const Icon(Icons.add, size: 20),
          ),
        );
      },
      menuBuilder: (BuildContext _, VoidCallback hideMenu) {
        return Material(
          color: const Color(0xFF3A3A3C),
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 156,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _QuickMenuItem(
                  icon: Icons.person_add_alt_1_outlined,
                  label: '添加联系人',
                  onTap: () {
                    hideMenu();
                    onAddContact();
                  },
                ),
                _QuickMenuItem(
                  icon: Icons.group_add_outlined,
                  label: '创建群聊',
                  onTap: () {
                    hideMenu();
                    onCreateGroup();
                  },
                ),
                _QuickMenuItem(
                  icon: Icons.groups_outlined,
                  label: '加入群聊',
                  onTap: () {
                    hideMenu();
                    onJoinGroup();
                  },
                ),
                _QuickMenuItem(
                  icon: Icons.qr_code_scanner,
                  label: '扫一扫',
                  onTap: () {
                    hideMenu();
                    onScanQr();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
