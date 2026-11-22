import 'package:contact_list_view/contact_list_view.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/pinyin_tag_helper.dart';
import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/unread_badge.dart';
import 'contact_controller.dart';

/// Tab 2：联系人通讯录页（基于 `contact_list_view`，含仿微信顶部三大固定入口）。
///
/// Tab 2: Contacts page powered by `contact_list_view` with 3 pinned WeChat entries.
class ContactPage extends WireView<ContactController> {
  /// 创建通讯录页。
  const ContactPage({super.key});

  @override
  ContactController? wire() => ContactController();

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('通讯录'),
        actions: <Widget>[
          IconButton(
            tooltip: '添加联系人',
            icon: const Icon(Icons.person_add_alt_1_outlined),
            onPressed: () => router.pushNamedAndRemoveUntil(
              AppRoutes.contactAdd,
              (AdaptiveRouteMatch _) => false,
            ),
          ),
        ],
      ),
      body: SignalBuilder(
        builder: (BuildContext _) {
          if (controller.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<FriendInfo> friends = controller.friends.value;
          final int friendBadge = controller.unhandledFriendCount.value;
          final int groupBadge = controller.unhandledGroupCount.value;

          return ContactListView<FriendInfo>(
            contactsList: friends,
            itemExtent: 60,
            startItemExtent: 60,
            endItemExtent: 48,
            startChildren: <Widget>[
              _FixedContactEntryTile(
                icon: Icons.person_add,
                color: const Color(0xFFFA9D3B),
                title: '新的朋友',
                badgeCount: friendBadge,
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.newFriends,
                  (AdaptiveRouteMatch _) => false,
                ),
              ),
              _FixedContactEntryTile(
                icon: Icons.notifications_active,
                color: const Color(0xFF2782D7),
                title: '群通知',
                badgeCount: groupBadge,
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.groupNotifications,
                  (AdaptiveRouteMatch _) => false,
                ),
              ),
              _FixedContactEntryTile(
                icon: Icons.groups,
                color: AppColors.primary,
                title: '我的群聊',
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.myGroups,
                  (AdaptiveRouteMatch _) => false,
                ),
              ),
            ],
            endChildren: <Widget>[
              Center(
                child: Text(
                  '${friends.length} 位联系人',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            ],
            tag: (FriendInfo f) => PinyinTagHelper.resolveTag(f.getShowName()),
            itemBuilder: (FriendInfo friend) {
              return ListTile(
                leading: CachedAvatar(
                  imageUrl: friend.faceURL,
                  fallbackName: friend.getShowName(),
                  size: 40,
                ),
                title: Text(friend.getShowName()),
                onTap: () => router.pushNamedAndRemoveUntil(
                  AppRoutes.contactProfile(friend.friendUserID ?? ''),
                  (AdaptiveRouteMatch _) => false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _FixedContactEntryTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final int badgeCount;
  final VoidCallback onTap;

  const _FixedContactEntryTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: badgeCount > 0 ? UnreadBadge(count: badgeCount) : null,
      onTap: onTap,
    );
  }
}
