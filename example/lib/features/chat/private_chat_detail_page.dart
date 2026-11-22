import 'package:flutter_toast_pro/flutter_toast_pro.dart';
import 'package:material_ui/material_ui.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:xue_hua_adaptive_sliding_layout/xue_hua_adaptive_sliding_layout.dart';

import '../../app/router/app_routes.dart';
import '../../shared/widgets/cached_avatar.dart';

/// 私聊详情设置页（对方资料、拉TA建群、查记录、画廊、置顶、免打扰、阅后即焚、定时销毁、清空、举报）。
///
/// Private chat detail settings page matching WeChat feature parity.
class PrivateChatDetailPage extends StatefulWidget {
  /// 会话 ID。
  final String conversationId;

  /// 创建私聊详情页。
  const PrivateChatDetailPage({super.key, required this.conversationId});

  @override
  State<PrivateChatDetailPage> createState() => _PrivateChatDetailPageState();
}

class _PrivateChatDetailPageState extends State<PrivateChatDetailPage> {
  ConversationInfo? _conversation;
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
        .getMultipleConversation(
          conversationIDList: <String>[widget.conversationId],
        );
    if (mounted) {
      setState(() {
        _conversation = list.isNotEmpty ? list.first : null;
        _loading = false;
      });
    }
  }

  Future<void> _updateConversation(ConversationReq req) async {
    try {
      await OpenIM.iMManager.conversationManager.setConversation(
        conversationID: widget.conversationId,
        req: req,
      );
      await _load();
    } on Object catch (error) {
      await FlutterToastPro.error('设置失败：$error');
    }
  }

  Future<void> _clearHistory() async {
    try {
      await OpenIM.iMManager.conversationManager
          .clearConversationAndDeleteAllMsg(
            conversationID: widget.conversationId,
          );
      await FlutterToastPro.success('已清空聊天记录');
    } on Object catch (error) {
      await FlutterToastPro.error('清空失败：$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AdaptiveRouter router = AdaptiveRouter.of(context);
    final ThemeData theme = Theme.of(context);
    final String peerId = _conversation?.userID ?? '';
    final bool isPinned = _conversation?.isPinned ?? false;
    final bool isMuted =
        _conversation?.recvMsgOpt == ReceiveMessageOpt.notNotify;
    final bool isBurn = _conversation?.isPrivateChat ?? false;
    final bool isDestruct = _conversation?.isMsgDestruct ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('聊天详情')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Container(
                  color: theme.colorScheme.surface,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: peerId.isEmpty
                            ? null
                            : () => router.pushNamed(
                                AppRoutes.contactProfile(peerId),
                              ),
                        child: Column(
                          children: <Widget>[
                            CachedAvatar(
                              imageUrl: _conversation?.faceURL,
                              fallbackName: _conversation?.showName,
                              size: 52,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _conversation?.showName ?? peerId,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () => router.pushNamed(
                          AppRoutes.createGroup,
                          arguments: peerId.isNotEmpty
                              ? <String>[peerId]
                              : const <String>[],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: theme.dividerColor),
                              ),
                              child: Icon(Icons.add, color: theme.hintColor),
                            ),
                            const SizedBox(height: 6),
                            const Text('发起群聊', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('查找聊天记录'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => router.pushNamed(
                    AppRoutes.chatSearch(widget.conversationId),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('图片与视频'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => router.pushNamed(
                    AppRoutes.chatGallery(widget.conversationId),
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('置顶聊天'),
                  value: isPinned,
                  onChanged: (bool v) async {
                    await OpenIM.iMManager.conversationManager.pinConversation(
                      conversationID: widget.conversationId,
                      isPinned: v,
                    );
                    await _load();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('消息免打扰'),
                  value: isMuted,
                  onChanged: (bool v) => _updateConversation(
                    ConversationReq(
                      recvMsgOpt: v
                          ? ReceiveMessageOpt.notNotify.value
                          : ReceiveMessageOpt.receive.value,
                    ),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('阅后即焚（30 秒）'),
                  value: isBurn,
                  onChanged: (bool v) => _updateConversation(
                    ConversationReq(isPrivateChat: v, burnDuration: v ? 30 : 0),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('消息定时销毁（7 天）'),
                  value: isDestruct,
                  onChanged: (bool v) => _updateConversation(
                    ConversationReq(
                      isMsgDestruct: v,
                      msgDestructTime: v ? 7 * 24 * 3600 : 0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('清空聊天记录'),
                  onTap: _clearHistory,
                ),
                const Divider(height: 1),
                ListTile(
                  tileColor: theme.colorScheme.surface,
                  title: const Text('投诉举报'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => router.pushNamed(
                    AppRoutes.report,
                    arguments: <String, String>{
                      'type': 'user',
                      'targetId': peerId,
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
