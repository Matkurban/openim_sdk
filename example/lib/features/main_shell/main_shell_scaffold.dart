import 'dart:async';

import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_accept_sharing/xue_hua_navite_accept_sharing.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/auth_session_service.dart';
import '../../core/services/sharing_receive_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/share_target_picker_sheet.dart';
import '../../shared/widgets/unread_badge.dart';
import 'main_shell_controller.dart';

/// 四大 Tab 自适应主壳（移动端底部导航栏 / 桌面端微信风格左侧窄 NavigationRail）。
///
/// Adaptive 4-tab main shell (BottomNavigationBar on mobile, WeChat dark rail on desktop).
class MainShellScaffold extends StatefulWidget {
  /// 自适应路由壳状态。
  final AdaptiveShellState shell;

  /// 当前分支内容区域。
  final Widget child;

  /// 创建主壳组件。
  const MainShellScaffold({
    super.key,
    required this.shell,
    required this.child,
  });

  @override
  State<MainShellScaffold> createState() => _MainShellScaffoldState();
}

class _MainShellScaffoldState extends State<MainShellScaffold>
    with WireStateMixin<MainShellScaffold, MainShellController> {
  EffectCleanup? _shareEffectCleanup;
  EffectCleanup? _callEffectCleanup;

  @override
  MainShellController? wire() => MainShellController();

  @override
  void initState() {
    super.initState();
    final SharingReceiveService sharingService =
        Wire.find<SharingReceiveService>();
    _shareEffectCleanup = effect(() {
      final SharedPayload? payload = sharingService.pendingPayload.value;
      if (payload != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((Duration _) {
          unawaited(_handleIncomingSharedPayload(payload));
        });
      }
    });
    _callEffectCleanup = effect(() {
      final CallSession? session = controller.incomingCall.value;
      if (session != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((Duration _) {
          controller.clearIncomingCall();
          AdaptiveRouter.of(context)
              .pushNamed(AppRoutes.call, arguments: session);
        });
      }
    });
  }

  @override
  void dispose() {
    _shareEffectCleanup?.call();
    _callEffectCleanup?.call();
    super.dispose();
  }

  Future<void> _handleIncomingSharedPayload(SharedPayload payload) async {
    final SharingReceiveService sharingService =
        Wire.find<SharingReceiveService>();
    final ConversationInfo? target = await ShareTargetPickerSheet.pick(
      context,
      title: '发送外部分享内容 (${payload.items.length} 项)',
    );
    if (target == null) {
      await sharingService.clearPending();
      return;
    }
    try {
      for (final SharedMediaItem item in payload.items) {
        final Message msg;
        final bool isFile =
            item.type == SharedItemType.file ||
            item.type == SharedItemType.image ||
            item.type == SharedItemType.video;
        if (isFile && item.content.isNotEmpty) {
          msg = OpenIM.iMManager.messageManager.createFileMessageFromFullPath(
            filePath: item.content,
            fileName: item.fileName ?? item.content.split('/').last,
          );
        } else {
          msg = OpenIM.iMManager.messageManager.createTextMessage(
            text: item.content.isNotEmpty ? item.content : '[外部分享内容]',
          );
        }
        await OpenIM.iMManager.messageManager.sendMessage(
          message: msg,
          userID: target.isSingleChat ? target.userID : null,
          groupID: target.isGroupChat ? target.groupID : null,
          offlinePushInfo: OfflinePushInfo(title: '收到外部分享消息'),
        );
      }
      await FlutterToastPro.success(
        '已发送至 ${target.showName ?? target.conversationID}',
      );
    } on Object catch (error) {
      await FlutterToastPro.error('外部分享发送失败：$error');
    } finally {
      await sharingService.clearPending();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool isWide = width >= 840;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AuthSessionService auth = Wire.find<AuthSessionService>();

    return SignalBuilder(
      builder: (BuildContext _) {
        final int unread = controller.totalUnread.value;
        final int pending = controller.contactPendingCount.value;
        final String banner = controller.connectionBanner.value;
        final UserInfo? self = auth.currentUser.value;
        final int currentIndex = widget.shell.currentIndex;

        if (isWide) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                if (banner.isNotEmpty) _ConnectionBanner(text: banner),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _DesktopNavigationRail(
                        currentIndex: currentIndex,
                        unreadCount: unread,
                        contactPendingCount: pending,
                        user: self,
                        onSelect: (int idx) => widget.shell.goBranch(idx),
                      ),
                      Expanded(child: widget.child),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Column(
            children: <Widget>[
              if (banner.isNotEmpty) _ConnectionBanner(text: banner),
              Expanded(child: widget.child),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (int idx) => widget.shell.goBranch(idx),
            destinations: <NavigationDestination>[
              NavigationDestination(
                icon: _BadgedTabIcon(
                  icon: Icons.chat_bubble_outline,
                  count: unread,
                ),
                selectedIcon: _BadgedTabIcon(
                  icon: Icons.chat_bubble,
                  count: unread,
                  selected: true,
                ),
                label: l10n.tabChats,
              ),
              NavigationDestination(
                icon: _BadgedTabIcon(
                  icon: Icons.contacts_outlined,
                  count: pending,
                ),
                selectedIcon: _BadgedTabIcon(
                  icon: Icons.contacts,
                  count: pending,
                  selected: true,
                ),
                label: l10n.tabContacts,
              ),
              NavigationDestination(
                icon: const Icon(Icons.camera_outlined),
                selectedIcon: const Icon(Icons.camera),
                label: l10n.tabMoments,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: l10n.tabMe,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ConnectionBanner extends StatelessWidget {
  final String text;

  const _ConnectionBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.danger.withValues(alpha: 0.14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: <Widget>[
          const Icon(Icons.wifi_off, size: 16, color: AppColors.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopNavigationRail extends StatelessWidget {
  final int currentIndex;
  final int unreadCount;
  final int contactPendingCount;
  final UserInfo? user;
  final ValueChanged<int> onSelect;

  const _DesktopNavigationRail({
    required this.currentIndex,
    required this.unreadCount,
    required this.contactPendingCount,
    required this.user,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      color: AppColors.desktopRailBackground,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => onSelect(3),
            child: CachedAvatar(
              imageUrl: user?.faceURL,
              fallbackName: user?.nickname ?? user?.userID,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          _RailButton(
            icon: Icons.chat_bubble,
            selected: currentIndex == 0,
            badgeCount: unreadCount,
            tooltip: '消息',
            onTap: () => onSelect(0),
          ),
          const SizedBox(height: 16),
          _RailButton(
            icon: Icons.contacts,
            selected: currentIndex == 1,
            badgeCount: contactPendingCount,
            tooltip: '通讯录',
            onTap: () => onSelect(1),
          ),
          const SizedBox(height: 16),
          _RailButton(
            icon: Icons.camera,
            selected: currentIndex == 2,
            tooltip: '朋友圈',
            onTap: () => onSelect(2),
          ),
          const SizedBox(height: 16),
          _RailButton(
            icon: Icons.person,
            selected: currentIndex == 3,
            tooltip: '我',
            onTap: () => onSelect(3),
          ),
          const Spacer(),
          IconButton(
            tooltip: '通用与安全设置',
            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            onPressed: () {
              onSelect(3);
              AdaptiveRouter.of(context).pushNamedAndRemoveUntil(
                AppRoutes.settings,
                (AdaptiveRouteMatch _) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RailButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final int badgeCount;
  final String tooltip;
  final VoidCallback onTap;

  const _RailButton({
    required this.icon,
    required this.selected,
    required this.tooltip,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 48,
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: selected ? AppColors.primary : Colors.white70,
                size: 24,
              ),
              if (badgeCount > 0)
                Positioned(
                  right: 2,
                  top: 2,
                  child: UnreadBadge(count: badgeCount),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgedTabIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool selected;

  const _BadgedTabIcon({
    required this.icon,
    required this.count,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Icon(icon, color: selected ? AppColors.primary : null),
        if (count > 0)
          Positioned(right: -10, top: -6, child: UnreadBadge(count: count)),
      ],
    );
  }
}
