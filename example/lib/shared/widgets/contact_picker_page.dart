import 'package:contact_list_view/contact_list_view.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../core/utils/pinyin_tag_helper.dart';
import 'cached_avatar.dart';

/// 通用联系人选择器弹窗/页面（基于 `contact_list_view`，复用于建群/邀请/发名片）。
///
/// Reusable contact picker sheet/page powered by `contact_list_view`.
class ContactPickerPage extends StatefulWidget {
  /// 标题。
  final String title;

  /// 是否多选。
  final bool multiSelect;

  /// 需要排除的用户 ID 集合（如已在群内的成员）。
  final Set<String> excludedUserIDs;

  /// 创建联系人选择器。
  const ContactPickerPage({
    super.key,
    this.title = '选择联系人',
    this.multiSelect = true,
    this.excludedUserIDs = const <String>{},
  });

  /// 以全屏模态弹窗方式打开并返回所选好友列表。
  static Future<List<FriendInfo>?> pick(
    BuildContext context, {
    String title = '选择联系人',
    bool multiSelect = true,
    Set<String> excludedUserIDs = const <String>{},
  }) {
    return showDialog<List<FriendInfo>>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext _) => Dialog.fullscreen(
        child: ContactPickerPage(
          title: title,
          multiSelect: multiSelect,
          excludedUserIDs: excludedUserIDs,
        ),
      ),
    );
  }

  @override
  State<ContactPickerPage> createState() => _ContactPickerPageState();
}

class _ContactPickerPageState extends State<ContactPickerPage> {
  late final Signal<List<FriendInfo>> _friends = signal<List<FriendInfo>>(
    <FriendInfo>[],
  );
  late final Signal<Set<String>> _selectedIDs = signal<Set<String>>(<String>{});
  late final Signal<bool> _loading = signal<bool>(true);

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final List<FriendInfo> all = await OpenIM.iMManager.friendshipManager
        .getFriendList(filterBlack: true);
    final List<FriendInfo> filtered = all
        .where(
          (FriendInfo f) =>
              !widget.excludedUserIDs.contains(f.friendUserID ?? ''),
        )
        .toList();
    if (mounted) {
      batch(() {
        _friends.value = filtered;
        _loading.value = false;
      });
    }
  }

  void _toggle(FriendInfo friend) {
    final String uid = friend.friendUserID ?? '';
    if (uid.isEmpty) {
      return;
    }
    if (!widget.multiSelect) {
      AdaptiveRouter.of(context).pop(<FriendInfo>[friend]);
      return;
    }
    final Set<String> next = Set<String>.of(_selectedIDs.value);
    if (!next.remove(uid)) {
      next.add(uid);
    }
    _selectedIDs.value = next;
  }

  void _confirm() {
    final Set<String> selected = _selectedIDs.value;
    final List<FriendInfo> result = _friends.value
        .where((FriendInfo f) => selected.contains(f.friendUserID ?? ''))
        .toList();
    AdaptiveRouter.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (BuildContext _) {
        final List<FriendInfo> friends = _friends.value;
        final Set<String> selectedIDs = _selectedIDs.value;
        final bool loading = _loading.value;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => AdaptiveRouter.of(context).pop(),
            ),
            actions: <Widget>[
              if (widget.multiSelect)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilledButton(
                    onPressed: selectedIDs.isEmpty ? null : _confirm,
                    child: Text('确定(${selectedIDs.length})'),
                  ),
                ),
            ],
          ),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : friends.isEmpty
              ? const Center(child: Text('暂无可选联系人'))
              : ContactListView<FriendInfo>(
                  contactsList: friends,
                  itemExtent: 60,
                  startItemExtent: 0,
                  endItemExtent: 0,
                  tag: (FriendInfo f) =>
                      PinyinTagHelper.resolveTag(f.getShowName()),
                  itemBuilder: (FriendInfo friend) {
                    final bool selected = selectedIDs.contains(
                      friend.friendUserID ?? '',
                    );
                    return ListTile(
                      leading: CachedAvatar(
                        imageUrl: friend.faceURL,
                        fallbackName: friend.getShowName(),
                        size: 40,
                      ),
                      title: Text(friend.getShowName()),
                      trailing: widget.multiSelect
                          ? Checkbox(
                              value: selected,
                              onChanged: (bool? _) => _toggle(friend),
                            )
                          : null,
                      onTap: () => _toggle(friend),
                    );
                  },
                ),
        );
      },
    );
  }
}
