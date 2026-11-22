import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';
import 'package:xue_hua_navite_clipboard/xue_hua_navite_clipboard.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/widgets/cached_avatar.dart';
import '../../shared/widgets/share_target_picker_sheet.dart';

/// 联系人资料页（发消息、通话、朋友圈、备注、名片推荐、在线状态、黑名单、删除、举报）。
///
/// Contact profile page with messaging, call, moments, remark, blacklist, delete, and report.
class ContactProfilePage extends StatefulWidget {
  /// 目标用户 ID。
  final String userId;

  /// 创建联系人资料页。
  const ContactProfilePage({super.key, required this.userId});

  @override
  State<ContactProfilePage> createState() => _ContactProfilePageState();
}

class _ContactProfilePageState extends State<ContactProfilePage> {
  late final Signal<UserInfo?> _user = signal<UserInfo?>(null);
  late final Signal<FriendInfo?> _friend = signal<FriendInfo?>(null);
  late final Signal<bool> _isFriend = signal<bool>(false);
  late final Signal<bool> _isBlocked = signal<bool>(false);
  late final Signal<bool> _isOnline = signal<bool>(false);
  late final Signal<bool> _loading = signal<bool>(true);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final List<UserInfo> users = await OpenIM.iMManager.userManager
          .getUsersInfoWithCache(userIDList: <String>[widget.userId]);
      final List<FriendInfo> friends = await OpenIM.iMManager.friendshipManager
          .getFriendsInfo(userIDList: <String>[widget.userId]);
      final List<BlacklistInfo> blacks = await OpenIM
          .iMManager
          .friendshipManager
          .getBlacklist();
      bool online = false;
      try {
        final List<UserStatusInfo> statuses = await OpenIM.iMManager.userManager
            .subscribeUsersStatus(<String>[widget.userId]);
        if (statuses.isNotEmpty) {
          online = (statuses.first.status ?? 0) == 1;
        }
      } on Object catch (_) {}

      if (mounted) {
        batch(() {
          _user.value = users.isNotEmpty ? users.first : null;
          _friend.value = friends.isNotEmpty ? friends.first : null;
          _isFriend.value = friends.isNotEmpty;
          _isBlocked.value = blacks.any(
            (BlacklistInfo b) => b.blockUserID == widget.userId,
          );
          _isOnline.value = online;
        });
      }
    } finally {
      if (mounted) {
        _loading.value = false;
      }
    }
  }

  Future<void> _startChat() async {
    final ConversationInfo conv = await OpenIM.iMManager.conversationManager
        .getOneConversation(
          sourceID: widget.userId,
          sessionType: ConversationType.single.value,
        );
    if (mounted) {
      await AdaptiveRouter.of(context)
          .pushNamed(AppRoutes.chat(conv.conversationID), arguments: conv);
    }
  }

  Future<void> _sendFriendRequest() async {
    try {
      await OpenIM.iMManager.friendshipManager.addFriend(
        userID: widget.userId,
        reason:
            '你好，我是 ${OpenIM.iMManager.userInfo.nickname ?? OpenIM.iMManager.userID}',
      );
      await FlutterToastPro.success('好友申请已发送');
    } on Object catch (error) {
      await FlutterToastPro.error('添加失败：$error');
    }
  }

  Future<void> _toggleBlacklist(bool block) async {
    try {
      if (block) {
        await OpenIM.iMManager.friendshipManager.addBlacklist(
          userID: widget.userId,
        );
      } else {
        await OpenIM.iMManager.friendshipManager.removeBlacklist(
          userID: widget.userId,
        );
      }
      if (mounted) {
        _isBlocked.value = block;
      }
      await FlutterToastPro.success(block ? '已加入黑名单' : '已移出黑名单');
    } on Object catch (error) {
      await FlutterToastPro.error('操作失败：$error');
    }
  }

  Future<void> _deleteFriend() async {
    try {
      await OpenIM.iMManager.friendshipManager.deleteFriend(
        userID: widget.userId,
      );
      await FlutterToastPro.success('已删除好友');
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('删除失败：$error');
    }
  }

  Future<void> _recommendCard() async {
    final ConversationInfo? target = await ShareTargetPickerSheet.pick(
      context,
      title: '将该联系人名片推荐给...',
    );
    if (target == null) {
      return;
    }
    final FriendInfo? friend = _friend.value;
    final UserInfo? user = _user.value;
    final Message cardMsg = OpenIM.iMManager.messageManager.createCardMessage(
      userID: widget.userId,
      nickname: friend?.getShowName() ?? user?.nickname ?? widget.userId,
      faceURL: friend?.faceURL ?? user?.faceURL,
    );
    await OpenIM.iMManager.messageManager.sendMessage(
      message: cardMsg,
      userID: target.isSingleChat ? target.userID : null,
      groupID: target.isGroupChat ? target.groupID : null,
      offlinePushInfo: OfflinePushInfo(title: '[个人名片]'),
    );
    await FlutterToastPro.success('已推荐名片');
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('详细资料')),
      body: SignalBuilder(
        builder: (BuildContext _) {
          if (_loading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final FriendInfo? friend = _friend.value;
          final UserInfo? user = _user.value;
          final bool isFriend = _isFriend.value;
          final bool isBlocked = _isBlocked.value;
          final bool isOnline = _isOnline.value;
          final String displayName =
              friend?.getShowName() ?? user?.nickname ?? widget.userId;
          final String? faceURL = friend?.faceURL ?? user?.faceURL;

          return ListView(
            children: <Widget>[
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: <Widget>[
                    CachedAvatar(
                      imageUrl: faceURL,
                      fallbackName: displayName,
                      size: 64,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  displayName,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: isOnline
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () async {
                              await XueHuaNaviteClipboard.instance.writeText(
                                widget.userId,
                              );
                              await FlutterToastPro.success('已复制用户 ID');
                            },
                            child: Text(
                              'ID：${widget.userId}（点击复制）',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (isFriend) ...<Widget>[
                ListTile(
                  tileColor: Theme.of(context).colorScheme.surface,
                  title: const Text('设置备注和标签'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await router.pushNamed(
                      AppRoutes.friendRemark(widget.userId),
                      arguments: friend,
                    );
                    await _load();
                  },
                ),
                const Divider(height: 1),
              ],
              ListTile(
                tileColor: Theme.of(context).colorScheme.surface,
                title: const Text('朋友圈'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    router.pushNamed(AppRoutes.userMoments(widget.userId)),
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: Theme.of(context).colorScheme.surface,
                title: const Text('把 TA 推荐给朋友'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _recommendCard,
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                tileColor: Theme.of(context).colorScheme.surface,
                title: const Text('加入黑名单'),
                value: isBlocked,
                onChanged: _toggleBlacklist,
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: Theme.of(context).colorScheme.surface,
                title: const Text('投诉举报'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => router.pushNamed(
                  AppRoutes.report,
                  arguments: <String, String>{
                    'type': 'user',
                    'targetId': widget.userId,
                  },
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (isFriend) ...<Widget>[
                      FilledButton.icon(
                        onPressed: _startChat,
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('发消息'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            final CallSession session = await OpenIM
                                .iMManager
                                .callManager
                                .invite(
                                  inviteeUserIDs: <String>[widget.userId],
                                  callType: CallType.audio,
                                );
                            if (context.mounted) {
                              await router.pushNamed(
                                AppRoutes.call,
                                arguments: session,
                              );
                            }
                          } on Object catch (error) {
                            await FlutterToastPro.error('发起通话失败：$error');
                          }
                        },
                        icon: const Icon(Icons.call_outlined),
                        label: const Text('音视频通话'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _deleteFriend,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.danger,
                        ),
                        child: const Text('删除好友'),
                      ),
                    ] else
                      FilledButton(
                        onPressed: _sendFriendRequest,
                        child: const Text('添加到通讯录'),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
