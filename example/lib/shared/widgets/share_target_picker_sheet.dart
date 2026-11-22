import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';

import 'cached_avatar.dart';

/// 通用目标会话选择器弹窗（用于消息转发与外部 App 分享内容投递）。
///
/// Shared conversation picker sheet for message forwarding and external OS sharing.
class ShareTargetPickerSheet extends StatefulWidget {
  /// 弹窗标题。
  final String title;

  /// 创建目标会话选择器。
  const ShareTargetPickerSheet({super.key, this.title = '选择发送目标会话'});

  /// 弹出选择器并返回用户选中的 [ConversationInfo]。
  static Future<ConversationInfo?> pick(
    BuildContext context, {
    String title = '选择发送目标会话',
  }) {
    return showModalBottomSheet<ConversationInfo>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext _) => ShareTargetPickerSheet(title: title),
    );
  }

  @override
  State<ShareTargetPickerSheet> createState() => _ShareTargetPickerSheetState();
}

class _ShareTargetPickerSheetState extends State<ShareTargetPickerSheet> {
  List<ConversationInfo> _conversations = <ConversationInfo>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<ConversationInfo> list = await OpenIM
        .iMManager
        .conversationManager
        .getAllConversationList();
    if (mounted) {
      setState(() {
        _conversations = list;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 460,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: <Widget>[
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _conversations.isEmpty
                  ? const Center(child: Text('暂无可用会话'))
                  : ListView.separated(
                      itemCount: _conversations.length,
                      separatorBuilder: (BuildContext _, int _) =>
                          const Divider(height: 1, indent: 68),
                      itemBuilder: (BuildContext _, int index) {
                        final ConversationInfo conv = _conversations[index];
                        return ListTile(
                          leading: CachedAvatar(
                            imageUrl: conv.faceURL,
                            fallbackName: conv.showName,
                          ),
                          title: Text(conv.showName ?? conv.conversationID),
                          subtitle: Text(conv.isGroupChat ? '群聊' : '单聊'),
                          onTap: () => Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pop(conv),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
