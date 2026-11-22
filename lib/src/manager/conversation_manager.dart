import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import '../../protocol_gen/sdkws/sdkws.pb.dart' as sdkws;
import '../concurrency/keyed_async_lock.dart';
import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../db/repositories/conversation_repository.dart';
import '../enums/conversation_type.dart';
import '../enums/sdk_error_code.dart';
import '../listener/conversation_listener.dart';
import '../models/api_response.dart';
import '../models/conversation_info.dart';
import '../models/group_info.dart';
import '../models/message.dart';
import '../models/openim_exception.dart';
import '../models/update_req.dart';
import '../models/user_info.dart';
import '../models/web_socket_identifier.dart';
import '../sync/typing_state_tracker.dart';
import '../utils/open_im_utils.dart';
import '../utils/platform_utils.dart';

/// 会话管理器（继承 [BaseManager]）。
///
/// 关键修复：
/// - B-03：`changeInputStates` 改用 Protobuf `sdkws.MsgData.writeToBuffer()` 发送，`getInputStates` 接入 [TypingStateTracker]；
/// - B-04：`setConversation` 按 `xue_hua_sdk` 规范封装 `{'userIDs': [me], 'conversation': {...}}`；
/// - B-18：`markConversationMessageAsRead` 检查 `hasReadSeq < maxSeq` 并更新单聊本地消息 `isRead = true`；
///   `delete/clearConversationAndDeleteAllMsg` 推进 `minSeq`；会话不存在抛 `SDKErrorCode.parameterError`；
/// - B-21：`getAllConversationList`/`getConversationListSplit` 有序输出；修复 `getOneConversation` 群/通知类型判断错误。
final class ConversationManager extends BaseManager<OnConversationListener> {
  final SdkContext _context;
  final TypingStateTracker _typingTracker;
  final KeyedAsyncLock _markReadLock = KeyedAsyncLock();

  ConversationManager({required this._context, required this._typingTracker})
    : super('ConversationManager');

  void setConversationListener(OnConversationListener listener) {
    setPrimaryListener(listener);
  }

  String get atAllTag => 'AtAllTag';

  String getConversationIDBySessionType({required String sourceID, required int sessionType}) {
    if (sessionType == ConversationType.single.value) {
      return OpenImUtils.genSingleConversationID(currentUserID, sourceID);
    }
    if (sessionType == 2 || sessionType == ConversationType.superGroup.value) {
      return OpenImUtils.genGroupConversationID(sourceID);
    }
    return OpenImUtils.genNotificationConversationID(currentUserID, sourceID);
  }

  Future<List<ConversationInfo>> getAllConversationList() async {
    try {
      return await _context.db.conversations.getVisibleConversations();
    } on Object catch (error, stackTrace) {
      logger.severe('getAllConversationList failed', error, stackTrace);
      return <ConversationInfo>[];
    }
  }

  Future<List<ConversationInfo>> getConversationListSplit({int offset = 0, int count = 20}) {
    return _context.db.conversations.getConversationsPage(offset, count);
  }

  Future<ConversationInfo> getOneConversation({
    required String sourceID,
    required int sessionType,
  }) async {
    final String conversationID = getConversationIDBySessionType(
      sourceID: sourceID,
      sessionType: sessionType,
    );
    final ConversationInfo? existing = await _context.db.conversations.getConversation(
      conversationID,
    );
    if (existing != null) {
      return existing;
    }

    final bool isGroup = sessionType == 2 || sessionType == ConversationType.superGroup.value;
    final bool isUserOrNotify =
        sessionType == ConversationType.single.value ||
        sessionType == ConversationType.notification.value;

    String showName = '';
    String faceURL = '';
    try {
      if (isGroup) {
        final GroupInfo? group = await _context.db.groups.getGroupByID(sourceID);
        if (group != null) {
          showName = group.groupName ?? '';
          faceURL = group.faceURL ?? '';
        }
      } else if (isUserOrNotify) {
        final FriendInfo? friend = await _context.db.friends.getFriendByUserID(sourceID);
        if (friend != null) {
          showName = friend.getShowName();
          faceURL = friend.faceURL ?? '';
        } else {
          final List<UserInfo> users = await _context.db.users.getUsersByIDs(<String>[sourceID]);
          if (users.isNotEmpty) {
            showName = users.first.getShowName();
            faceURL = users.first.faceURL ?? '';
          }
        }
      }
    } catch (_) {}

    await _context.db.conversations.upsertConversation(<String, dynamic>{
      'conversationID': conversationID,
      'conversationType': sessionType,
      'userID': isUserOrNotify ? sourceID : null,
      'groupID': isGroup ? sourceID : null,
      'showName': showName,
      'faceURL': faceURL,
      'unreadCount': 0,
    });

    final ConversationInfo created =
        (await _context.db.conversations.getConversation(conversationID)) ??
        ConversationInfo(conversationID: conversationID);
    listener?.newConversation(<ConversationInfo>[created]);
    return created;
  }

  Future<List<ConversationInfo>> getMultipleConversation({
    required List<String> conversationIDList,
  }) {
    return _context.db.conversations.getMultipleConversations(conversationIDList);
  }

  Future<List<ConversationInfo>> searchConversations(String name) {
    return _context.db.conversations.searchConversations(name);
  }

  List<ConversationInfo> simpleSort(List<ConversationInfo> list) {
    return ConversationRepository.sortConversations(list);
  }

  /// 设置会话属性（修复 B-04：使用 OpenIM 服务端标准的嵌套 `userIDs` + `conversation` 请求体）。
  Future<void> setConversation({
    required String conversationID,
    required ConversationReq req,
  }) async {
    final ConversationInfo? local = await _context.db.conversations.getConversation(conversationID);
    if (local == null) {
      throw OpenIMException(
        code: SDKErrorCode.parameterError.code,
        message: 'conversation not found: $conversationID',
      );
    }
    final Map<String, dynamic> updateData = req.toJson()
      ..removeWhere((String _, dynamic value) => value == null);
    if (updateData.isNotEmpty) {
      await _context.db.conversations.updateConversation(conversationID, updateData);
    }

    final Map<String, dynamic> convPayload = <String, dynamic>{
      'conversationID': local.conversationID,
      'conversationType': local.conversationType?.value,
      if (local.userID != null && local.userID!.isNotEmpty) 'userID': local.userID,
      if (local.groupID != null && local.groupID!.isNotEmpty) 'groupID': local.groupID,
      ...updateData,
    };
    final ApiResponse resp = await _context.apis.conversation.setConversations(
      req: <String, dynamic>{
        'userIDs': <String>[currentUserID],
        'conversation': convPayload,
      },
    );
    if (resp.errCode != 0) {
      logger.warning('setConversations server sync failed: ${resp.errMsg}');
    }
    await _notifyConversationChanged(<String>[conversationID]);
  }

  Future<void> pinConversation({required String conversationID, required bool isPinned}) {
    return setConversation(
      conversationID: conversationID,
      req: ConversationReq(isPinned: isPinned),
    );
  }

  Future<void> hideConversation({required String conversationID}) async {
    await _context.db.conversations.resetConversation(conversationID);
    await _notifyConversationChanged(<String>[conversationID]);
  }

  Future<void> hideAllConversations() async {
    await _context.db.conversations.resetAllConversations();
    final List<ConversationInfo> allConvs = await _context.db.conversations
        .getVisibleConversations();
    listener?.conversationChanged(allConvs);
    final int total = await getTotalUnreadMsgCount();
    listener?.totalUnreadMessageCountChanged(total);
  }

  Future<void> setConversationDraft({
    required String conversationID,
    required String draftText,
  }) async {
    await _context.db.conversations.setConversationDraft(conversationID, draftText);
    await _notifyConversationChanged(<String>[conversationID]);
  }

  Future<int> getTotalUnreadMsgCount() => _context.db.conversations.getTotalUnreadCount();

  /// 标记会话已读（修复 B-18：检查 `hasReadSeq < maxSeq`，单聊同步标记消息 `isRead = true`）。
  Future<void> markConversationMessageAsRead({required String conversationID}) {
    return _markReadLock.synchronized<void>(conversationID, () async {
      final ConversationInfo? conv = await _context.db.conversations.getConversation(
        conversationID,
      );
      if (conv == null) {
        await _emitTotalUnread();
        return;
      }

      int maxSeq = await _context.db.conversations.getConversationMaxSeq(conversationID);
      if (maxSeq <= 0) {
        maxSeq = await _context.db.messages.getConversationNormalMsgMaxSeq(conversationID);
      }
      final int hasReadSeq = await _context.db.conversations.getConversationHasReadSeq(
        conversationID,
      );

      // 对齐 xue_hua_sdk：只有 unreadCount == 0 且 hasReadSeq >= maxSeq 才跳过
      if (conv.unreadCount == 0 && hasReadSeq >= maxSeq) {
        return;
      }

      List<int>? singleChatSeqs;
      if (conv.conversationType == ConversationType.single && maxSeq > 0) {
        final List<Message> unreadMsgs = await _context.db.messages.getUnreadMessages(
          conversationID,
        );
        final List<String> clientIDs = <String>[];
        final List<int> seqs = <int>[];
        for (final Message m in unreadMsgs) {
          final int seq = m.seq ?? 0;
          if (seq > 0 && m.clientMsgID != null) {
            clientIDs.add(m.clientMsgID!);
            seqs.add(seq);
          }
        }
        singleChatSeqs = seqs;
        if (clientIDs.isNotEmpty) {
          await _context.db.messages.markMessagesAsRead(clientIDs);
        }
      }

      await _context.db.conversations.updateConversation(conversationID, <String, dynamic>{
        'unreadCount': 0,
        if (maxSeq > 0) 'hasReadSeq': maxSeq,
      });
      await _notifyConversationChanged(<String>[conversationID]);

      final ApiResponse resp = await _context.apis.message.markConversationAsRead(
        userID: currentUserID,
        conversationID: conversationID,
        hasReadSeq: maxSeq,
        seqs: singleChatSeqs,
      );
      if (resp.errCode != 0) {
        logger.warning('markConversationAsRead server sync failed: ${resp.errMsg}');
      }
    });
  }

  Future<void> markAllConversationMessageAsRead() async {
    final List<ConversationInfo> allConvs = await _context.db.conversations.getAllConversations();
    final List<ConversationInfo> unreadConvs = allConvs
        .where((ConversationInfo c) => c.unreadCount > 0)
        .toList();
    for (final ConversationInfo conv in unreadConvs) {
      try {
        await markConversationMessageAsRead(conversationID: conv.conversationID);
      } on Object catch (error, stackTrace) {
        logger.warning('markAll read failed for ${conv.conversationID}', error, stackTrace);
      }
    }
    await _emitTotalUnread();
  }

  Future<void> markMessagesAsReadByMsgID({
    required String conversationID,
    required List<String> clientMsgIDs,
  }) async {
    if (clientMsgIDs.isEmpty) {
      return;
    }
    final ConversationInfo? conv = await _context.db.conversations.getConversation(conversationID);
    if (conv == null) {
      return;
    }
    final List<Message> msgs = await _context.db.messages.getMessagesByClientMsgIDs(clientMsgIDs);
    final List<String> asReadIDs = <String>[];
    final List<int> seqs = <int>[];
    for (final Message msg in msgs) {
      if (!(msg.isRead ?? false) && msg.sendID != currentUserID && (msg.seq ?? 0) > 0) {
        asReadIDs.add(msg.clientMsgID!);
        seqs.add(msg.seq!);
      }
    }
    if (seqs.isEmpty) {
      return;
    }
    final ApiResponse resp = await _context.apis.message.markMsgsAsRead(
      userID: currentUserID,
      conversationID: conversationID,
      seqs: seqs,
    );
    if (resp.errCode != 0) {
      logger.warning('markMsgsAsRead server sync failed: ${resp.errMsg}');
    }
    final int decrCount = await _context.db.messages.markMessagesAsRead(asReadIDs);
    await _context.db.conversations.decrConversationUnreadCount(conversationID, decrCount);
    await _notifyConversationChanged(<String>[conversationID]);
  }

  Future<void> deleteConversationAndDeleteAllMsg({required String conversationID}) async {
    await _clearOrDeleteConversation(conversationID: conversationID, resetTimestamp: true);
  }

  Future<void> clearConversationAndDeleteAllMsg({required String conversationID}) async {
    await _clearOrDeleteConversation(conversationID: conversationID, resetTimestamp: false);
  }

  Future<void> _clearOrDeleteConversation({
    required String conversationID,
    required bool resetTimestamp,
  }) async {
    final ConversationInfo? conv = await _context.db.conversations.getConversation(conversationID);
    if (conv == null) {
      throw OpenIMException(
        code: SDKErrorCode.parameterError.code,
        message: 'conversation not found: $conversationID',
      );
    }

    final ApiResponse resp = await _context.apis.message.clearConversationMsg(
      userID: currentUserID,
      conversationIDs: <String>[conversationID],
    );
    if (resp.errCode != 0) {
      logger.warning('clearConversationMsg server failed: ${resp.errMsg}');
    }

    final int maxSeq = await _context.db.conversations.getConversationMaxSeq(conversationID);
    final int minSeq = maxSeq > 0 ? maxSeq + 1 : 1;

    await _context.db.transaction(() async {
      await _context.db.messages.deleteConversationAllMessages(conversationID);
      if (resetTimestamp) {
        await _context.db.conversations.resetConversation(conversationID);
      } else {
        await _context.db.conversations.clearConversation(conversationID);
      }
      await _context.db.conversations.updateConversation(conversationID, <String, dynamic>{
        'minSeq': minSeq,
        if (maxSeq > 0) 'hasReadSeq': maxSeq,
      });
    });

    await _notifyConversationChanged(<String>[conversationID]);
  }

  /// 发送正在输入状态（修复 B-03：严格使用 Protobuf `sdkws.MsgData` 编码）。
  Future<void> changeInputStates({required String conversationID, required bool focus}) async {
    final ConversationInfo? conv = await _context.db.conversations.getConversation(conversationID);
    if (conv == null) {
      return;
    }
    final String typingJson = jsonEncode(<String, String>{'msgTips': focus ? 'yes' : 'no'});
    final sdkws.MsgData msgData = sdkws.MsgData(
      sendID: currentUserID,
      recvID: conv.userID ?? '',
      groupID: conv.groupID ?? '',
      clientMsgID: OpenImUtils.generateClientMsgID(currentUserID),
      sessionType: conv.conversationType?.value ?? ConversationType.single.value,
      msgFrom: 100,
      contentType: 113,
      content: utf8.encode(typingJson),
      senderPlatformID: PlatformUtils.currentPlatform.value,
      createTime: Int64(DateTime.now().millisecondsSinceEpoch),
      sendTime: Int64.ZERO,
    );
    msgData.options.addEntries(const <MapEntry<String, bool>>[
      MapEntry<String, bool>('history', false),
      MapEntry<String, bool>('persistent', false),
      MapEntry<String, bool>('senderSync', false),
      MapEntry<String, bool>('conversationUpdate', false),
      MapEntry<String, bool>('senderConversationUpdate', false),
      MapEntry<String, bool>('unreadCount', false),
      MapEntry<String, bool>('offlinePush', false),
    ]);

    final Uint8List wsData = msgData.writeToBuffer();
    await _context.ws.sendRequestWaitResponse(
      reqIdentifier: WebSocketIdentifier.sendMsg,
      data: wsData,
    );
  }

  /// 获取对端活跃输入平台列表（修复 B-03）。
  Future<List<int>?> getInputStates(String conversationID, String userID) async {
    return _typingTracker.getActivePlatforms(conversationID, userID);
  }

  Future<void> _emitTotalUnread() async {
    final int total = await _context.db.conversations.getTotalUnreadCount();
    listener?.totalUnreadMessageCountChanged(total);
  }

  Future<void> _notifyConversationChanged(List<String> conversationIDs) async {
    final List<ConversationInfo> conversations = await getMultipleConversation(
      conversationIDList: conversationIDs,
    );
    if (conversations.isNotEmpty) {
      listener?.conversationChanged(conversations);
    }
    await _emitTotalUnread();
  }
}
