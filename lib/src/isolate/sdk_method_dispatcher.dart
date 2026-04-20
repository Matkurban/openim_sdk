/// SDK 方法分发器
///
/// 运行在后台 Isolate 中，接收主线程的方法调用请求，
/// 分发到实际的 Manager 方法，并将结果序列化后返回。
/// 同时设置转发监听器，将 SDK 事件发送回主线程。
library;

import 'dart:typed_data';

import 'package:openim_sdk/openim_sdk.dart';

/// 后台 Isolate 方法分发器
class SdkMethodDispatcher {
  /// 把监听器事件推送回主线程的回调（由上层的通信通道决定实现）。
  final void Function(SdkListenerEvent event) sendEvent;

  SdkMethodDispatcher({required this.sendEvent});

  // SDK 管理器引用（Isolate 内独立实例）
  IMManager get _im => IMManager();

  ConversationManager get _conversation => _im.conversationManager;

  MessageManager get _message => _im.messageManager;

  GroupManager get _group => _im.groupManager;

  UserManager get _user => _im.userManager;

  FriendshipManager get _friendship => _im.friendshipManager;

  MomentsManager get _moments => _im.momentsManager;

  FavoriteManager get _favorite => _im.favoriteManager;

  CallManager get _call => _im.callManager;

  RedPacketManager get _redPacket => _im.redPacketManager;

  // --------------------------------------------------------------------------
  // 主分发入口
  // --------------------------------------------------------------------------

  /// 根据 method 字符串分发到具体的 Manager 方法
  Future<dynamic> dispatch(String method, Map<String, dynamic> args) async {
    final dot = method.indexOf('.');
    if (dot < 0) throw ArgumentError('Invalid method format: $method');
    final manager = method.substring(0, dot);
    final name = method.substring(dot + 1);

    return switch (manager) {
      'im' => _dispatchIM(name, args),
      'conversation' => _dispatchConversation(name, args),
      'message' => _dispatchMessage(name, args),
      'group' => _dispatchGroup(name, args),
      'user' => _dispatchUser(name, args),
      'friendship' => _dispatchFriendship(name, args),
      'moments' => _dispatchMoments(name, args),
      'favorite' => _dispatchFavorite(name, args),
      'call' => _dispatchCall(name, args),
      'redPacket' => _dispatchRedPacket(name, args),
      _ => throw ArgumentError('Unknown manager: $manager'),
    };
  }

  // --------------------------------------------------------------------------
  // 辅助方法
  // --------------------------------------------------------------------------

  void _sendEvent(String listenerType, String method, [dynamic data]) {
    sendEvent(SdkListenerEvent(listenerType: listenerType, method: method, data: data));
  }

  List<Map<String, dynamic>>? _serializeList<T>(List<T>? list) {
    if (list == null) return null;
    return list.map((e) => (e as dynamic).toJson() as Map<String, dynamic>).toList();
  }

  // --------------------------------------------------------------------------
  // 转发监听器设置
  // --------------------------------------------------------------------------

  /// 在 initSDK 成功后调用，为后台 Isolate 的所有 Manager
  /// 注册转发监听器，将事件通过 SendPort 发送到主线程。
  void _setupForwardingListeners() {
    // Conversation
    _conversation.setConversationListener(
      OnConversationListener(
        onConversationChanged: (list) =>
            _sendEvent('conversation', 'onConversationChanged', _serializeList(list)),
        onNewConversation: (list) =>
            _sendEvent('conversation', 'onNewConversation', _serializeList(list)),
        onTotalUnreadMessageCountChanged: (count) =>
            _sendEvent('conversation', 'onTotalUnreadMessageCountChanged', count),
        onSyncServerStart: (reinstalled) =>
            _sendEvent('conversation', 'onSyncServerStart', reinstalled),
        onSyncServerProgress: (progress) =>
            _sendEvent('conversation', 'onSyncServerProgress', progress),
        onSyncServerFinish: (reinstalled) =>
            _sendEvent('conversation', 'onSyncServerFinish', reinstalled),
        onSyncServerFailed: (reinstalled) =>
            _sendEvent('conversation', 'onSyncServerFailed', reinstalled),
        onInputStatusChanged: (data) =>
            _sendEvent('conversation', 'onInputStatusChanged', data.toJson()),
      ),
    );

    // Message
    _message.setAdvancedMsgListener(
      OnAdvancedMsgListener(
        onMsgDeleted: (msg) => _sendEvent('message', 'onMsgDeleted', msg.toJson()),
        onNewRecvMessageRevoked: (info) =>
            _sendEvent('message', 'onNewRecvMessageRevoked', info.toJson()),
        onRecvC2CReadReceipt: (list) =>
            _sendEvent('message', 'onRecvC2CReadReceipt', _serializeList(list)),
        onRecvNewMessage: (msg) => _sendEvent('message', 'onRecvNewMessage', msg.toJson()),
        onRecvOfflineNewMessage: (msg) =>
            _sendEvent('message', 'onRecvOfflineNewMessage', msg.toJson()),
        onRecvOfflineNewMessages: (msgs) =>
            _sendEvent('message', 'onRecvOfflineNewMessages', _serializeList(msgs)),
        onRecvOnlineOnlyMessage: (msg) =>
            _sendEvent('message', 'onRecvOnlineOnlyMessage', msg.toJson()),
        onMessageStatusChanged: (msg) =>
            _sendEvent('message', 'onMessageStatusChanged', msg.toJson()),
      ),
    );

    // Message Send Progress
    _message.setMsgSendProgressListener(
      OnMsgSendProgressListener(
        onProgress: (clientMsgID, progress) => _sendEvent('msgProgress', 'progress', {
          'clientMsgID': clientMsgID,
          'progress': progress,
        }),
        onFailure: (clientMsgID, errMsg) =>
            _sendEvent('msgProgress', 'fail', {'clientMsgID': clientMsgID, 'errMsg': errMsg}),
      ),
    );

    // Friendship
    _friendship.setFriendshipListener(
      OnFriendshipListener(
        onFriendApplicationAccepted: (info) =>
            _sendEvent('friendship', 'onFriendApplicationAccepted', info.toJson()),
        onFriendApplicationAdded: (info) =>
            _sendEvent('friendship', 'onFriendApplicationAdded', info.toJson()),
        onFriendApplicationDeleted: (info) =>
            _sendEvent('friendship', 'onFriendApplicationDeleted', info.toJson()),
        onFriendApplicationRejected: (info) =>
            _sendEvent('friendship', 'onFriendApplicationRejected', info.toJson()),
        onFriendAdded: (info) => _sendEvent('friendship', 'onFriendAdded', info.toJson()),
        onFriendDeleted: (info) => _sendEvent('friendship', 'onFriendDeleted', info.toJson()),
        onFriendInfoChanged: (info) =>
            _sendEvent('friendship', 'onFriendInfoChanged', info.toJson()),
        onBlackAdded: (info) => _sendEvent('friendship', 'onBlackAdded', info.toJson()),
        onBlackDeleted: (info) => _sendEvent('friendship', 'onBlackDeleted', info.toJson()),
      ),
    );

    // Group
    _group.setGroupListener(
      OnGroupListener(
        onGroupApplicationAccepted: (info) =>
            _sendEvent('group', 'onGroupApplicationAccepted', info.toJson()),
        onGroupApplicationAdded: (info) =>
            _sendEvent('group', 'onGroupApplicationAdded', info.toJson()),
        onGroupApplicationDeleted: (info) =>
            _sendEvent('group', 'onGroupApplicationDeleted', info.toJson()),
        onGroupApplicationRejected: (info) =>
            _sendEvent('group', 'onGroupApplicationRejected', info.toJson()),
        onGroupDismissed: (info) => _sendEvent('group', 'onGroupDismissed', info.toJson()),
        onGroupInfoChanged: (info) => _sendEvent('group', 'onGroupInfoChanged', info.toJson()),
        onGroupMemberAdded: (info) => _sendEvent('group', 'onGroupMemberAdded', info.toJson()),
        onGroupMemberDeleted: (info) => _sendEvent('group', 'onGroupMemberDeleted', info.toJson()),
        onGroupMemberInfoChanged: (info) =>
            _sendEvent('group', 'onGroupMemberInfoChanged', info.toJson()),
        onJoinedGroupAdded: (info) => _sendEvent('group', 'onJoinedGroupAdded', info.toJson()),
        onJoinedGroupDeleted: (info) => _sendEvent('group', 'onJoinedGroupDeleted', info.toJson()),
      ),
    );

    // User
    _user.setUserListener(
      OnUserListener(
        onSelfInfoUpdated: (info) => _sendEvent('user', 'onSelfInfoUpdated', info.toJson()),
        onUserStatusChanged: (info) => _sendEvent('user', 'onUserStatusChanged', info.toJson()),
      ),
    );

    // Moments
    _moments.setMomentsListener(
      OnMomentsListener(
        onMomentPublished: (moment) => _sendEvent('moments', 'onMomentPublished', moment.toJson()),
        onMomentDeleted: (id) => _sendEvent('moments', 'onMomentDeleted', id),
        onMomentLiked: (like) => _sendEvent('moments', 'onMomentLiked', like.toJson()),
        onMomentUnliked: (momentID, userID) =>
            _sendEvent('moments', 'onMomentUnliked', {'momentID': momentID, 'userID': userID}),
        onMomentCommented: (comment) =>
            _sendEvent('moments', 'onMomentCommented', comment.toJson()),
        onMomentCommentDeleted: (id) => _sendEvent('moments', 'onMomentCommentDeleted', id),
        onMomentListUpdated: (moments) =>
            _sendEvent('moments', 'onMomentListUpdated', _serializeList(moments)),
      ),
    );

    // Favorite
    _favorite.setFavoriteListener(
      OnFavoriteListener(
        onFavoriteAdded: (item) => _sendEvent('favorite', 'onFavoriteAdded', item.toJson()),
        onFavoriteRemoved: (targetType, targetID) => _sendEvent('favorite', 'onFavoriteRemoved', {
          'targetType': targetType,
          'targetID': targetID,
        }),
      ),
    );

    // Call
    _call.setCallListener(
      OnCallListener(
        onIncomingCall: (session) => _sendEvent('call', 'onIncomingCall', session.toJson()),
        onCallAccepted: (session, userID) =>
            _sendEvent('call', 'onCallAccepted', {'session': session.toJson(), 'userID': userID}),
        onCallRejected: (session, userID) =>
            _sendEvent('call', 'onCallRejected', {'session': session.toJson(), 'userID': userID}),
        onCallCancelled: (session) => _sendEvent('call', 'onCallCancelled', session.toJson()),
        onCallEnded: (session) => _sendEvent('call', 'onCallEnded', session.toJson()),
        onCallTimeout: (session) => _sendEvent('call', 'onCallTimeout', session.toJson()),
        onCallBusy: (session, busyUserID) => _sendEvent('call', 'onCallBusy', {
          'session': session.toJson(),
          'busyUserID': busyUserID,
        }),
        onCallConnected: (session) => _sendEvent('call', 'onCallConnected', session.toJson()),
      ),
    );

    // RedPacket
    _redPacket.setRedPacketListener(
      OnRedPacketListener(
        onRedPacketExpired: (packetID) => _sendEvent('redPacket', 'onRedPacketExpired', packetID),
        onPointsBalanceChanged: (balance) =>
            _sendEvent('redPacket', 'onPointsBalanceChanged', balance),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // IMManager 分发
  // --------------------------------------------------------------------------

  Future<dynamic> _dispatchIM(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'initSDK':
        // 创建转发连接监听器
        final connectListener = OnConnectListener(
          onConnectFailed: (code, errorMsg) =>
              _sendEvent('connect', 'onConnectFailed', {'code': code, 'errorMsg': errorMsg}),
          onConnectSuccess: () => _sendEvent('connect', 'onConnectSuccess'),
          onConnecting: () => _sendEvent('connect', 'onConnecting'),
          onKickedOffline: () => _sendEvent('connect', 'onKickedOffline'),
          onUserTokenExpired: () => _sendEvent('connect', 'onUserTokenExpired'),
          onUserTokenInvalid: () => _sendEvent('connect', 'onUserTokenInvalid'),
        );

        final result = await _im.initSDK(
          platformID: args['platformID'] as int?,
          apiAddr: args['apiAddr'] as String,
          wsAddr: args['wsAddr'] as String,
          authAddr: args['authAddr'] as String,
          dataDir: args['dataDir'] as String?,
          listener: connectListener,
          schemas: args['schemas'] as List<TableSchema>? ?? const [],
        );

        // 设置所有转发监听器
        _setupForwardingListeners();
        return result;

      case 'loadLoginConfig':
        final status = await _im.loadLoginConfig();
        if (status == LoginStatus.logged) {
          return {'status': status.index, 'userInfo': _im.getLoginUserInfo().toJson()};
        }
        return {'status': status.index};

      case 'checkToken':
        return await _im.checkToken(token: args['token'] as String);

      case 'getValue':
        return await _im.getDatabaseInstance().getValue(
          args['key'] as String,
          isGlobal: args['isGlobal'] as bool? ?? false,
        );

      case 'setValue':
        final r = await _im.getDatabaseInstance().setValue(
          args['key'] as String,
          args['value'],
          isGlobal: args['isGlobal'] as bool? ?? false,
        );
        return r.isSuccess;

      case 'removeValue':
        final r = await _im.getDatabaseInstance().removeValue(
          args['key'] as String,
          isGlobal: args['isGlobal'] as bool? ?? false,
        );
        return r.isSuccess;

      case 'getSpaceInfo':
        return (await _im.getDatabaseInstance().getSpaceInfo()).toJson();

      case 'runInDatabase':
        // 在后台 Isolate 内部执行用户回调，只把可序列化结果回传
        final callback = args['callback'];
        final cbArg = args['arg'];
        final db = _im.getDatabaseInstance();
        if (callback is Function) {
          // 支持 (db) => ... 与 (db, arg) => ... 两种签名
          try {
            return await Function.apply(callback, [db, cbArg]);
          } on NoSuchMethodError {
            return await Function.apply(callback, [db]);
          }
        }
        throw ArgumentError('runInDatabase: callback 必须是顶层函数或静态方法');

      case 'unInitSDK':
        await _im.unInitSDK();
        return null;

      case 'login':
        final user = await _im.login(
          userID: args['userID'] as String,
          token: args['token'] as String,
        );
        return user.toJson();

      case 'loginByEmail':
        final user = await _im.loginByEmail(
          email: args['email'] as String,
          password: args['password'] as String?,
          verificationCode: args['verificationCode'] as String?,
        );
        return user.toJson();

      case 'loginByPhone':
        final user = await _im.loginByPhone(
          areaCode: args['areaCode'] as String,
          phoneNumber: args['phoneNumber'] as String,
          password: args['password'] as String?,
          verificationCode: args['verificationCode'] as String?,
        );
        return user.toJson();

      case 'loginByAccount':
        final user = await _im.loginByAccount(
          account: args['account'] as String,
          password: args['password'] as String,
        );
        return user.toJson();

      case 'logout':
        await _im.logout();
        return null;

      case 'triggerWakeupSync':
        await _im.triggerWakeupSync();
        return null;

      case 'uploadFile':
        return await _im.uploadFile(
          id: args['id'] as String,
          filePath: args['filePath'] as String?,
          fileBytes: args['fileBytes'] as dynamic,
          fileName: args['fileName'] as String,
          contentType: args['contentType'] as String?,
          cause: args['cause'] as String?,
        );

      case 'networkStatusChanged':
        await _im.networkStatusChanged();
        return null;

      case 'updateFcmToken':
        await _im.updateFcmToken(
          fcmToken: args['fcmToken'] as String,
          expireTime: args['expireTime'] as int? ?? 0,
        );
        return null;

      default:
        throw ArgumentError('Unknown im method: $name');
    }
  }

  // --------------------------------------------------------------------------
  // ConversationManager 分发
  // --------------------------------------------------------------------------

  Future<dynamic> _dispatchConversation(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'getAllConversationList':
        return _serializeList(await _conversation.getAllConversationList());

      case 'getConversationListSplit':
        return _serializeList(
          await _conversation.getConversationListSplit(
            offset: args['offset'] as int? ?? 0,
            count: args['count'] as int? ?? 20,
          ),
        );

      case 'getOneConversation':
        final c = await _conversation.getOneConversation(
          sourceID: args['sourceID'] as String,
          sessionType: args['sessionType'] as int,
        );
        return c.toJson();

      case 'getMultipleConversation':
        return _serializeList(
          await _conversation.getMultipleConversation(
            conversationIDList: (args['conversationIDList'] as List).cast<String>(),
          ),
        );

      case 'searchConversations':
        return _serializeList(await _conversation.searchConversations(args['name'] as String));

      case 'setConversation':
        await _conversation.setConversation(
          conversationID: args['conversationID'] as String,
          req: ConversationReq.fromJson(args['req'] as Map<String, dynamic>),
        );
        return null;

      case 'pinConversation':
        await _conversation.pinConversation(
          conversationID: args['conversationID'] as String,
          isPinned: args['isPinned'] as bool,
        );
        return null;

      case 'hideConversation':
        await _conversation.hideConversation(conversationID: args['conversationID'] as String);
        return null;

      case 'hideAllConversations':
        await _conversation.hideAllConversations();
        return null;

      case 'setConversationDraft':
        await _conversation.setConversationDraft(
          conversationID: args['conversationID'] as String,
          draftText: args['draftText'] as String,
        );
        return null;

      case 'getTotalUnreadMsgCount':
        return await _conversation.getTotalUnreadMsgCount();

      case 'markConversationMessageAsRead':
        await _conversation.markConversationMessageAsRead(
          conversationID: args['conversationID'] as String,
        );
        return null;

      case 'markAllConversationMessageAsRead':
        await _conversation.markAllConversationMessageAsRead();
        return null;

      case 'markMessagesAsReadByMsgID':
        await _conversation.markMessagesAsReadByMsgID(
          conversationID: args['conversationID'] as String,
          clientMsgIDs: (args['clientMsgIDs'] as List).cast<String>(),
        );
        return null;

      case 'deleteConversationAndDeleteAllMsg':
        await _conversation.deleteConversationAndDeleteAllMsg(
          conversationID: args['conversationID'] as String,
        );
        return null;

      case 'clearConversationAndDeleteAllMsg':
        await _conversation.clearConversationAndDeleteAllMsg(
          conversationID: args['conversationID'] as String,
        );
        return null;

      case 'changeInputStates':
        await _conversation.changeInputStates(
          conversationID: args['conversationID'] as String,
          focus: args['focus'] as bool,
        );
        return null;

      case 'getInputStates':
        return await _conversation.getInputStates(
          args['conversationID'] as String,
          args['userID'] as String,
        );

      default:
        throw ArgumentError('Unknown conversation method: $name');
    }
  }

  // --------------------------------------------------------------------------
  // MessageManager 分发
  // --------------------------------------------------------------------------

  Future<dynamic> _dispatchMessage(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'recoverSendingMessages':
        await _message.recoverSendingMessages();
        return null;

      case 'sendMessage':
        final msg = await _message.sendMessage(
          message: Message.fromJson(args['message'] as Map<String, dynamic>),
          offlinePushInfo: OfflinePushInfo.fromJson(
            args['offlinePushInfo'] as Map<String, dynamic>,
          ),
          userID: args['userID'] as String?,
          groupID: args['groupID'] as String?,
          isOnlineOnly: args['isOnlineOnly'] as bool? ?? false,
          messageOptions: (args['messageOptions'] as Map?)?.cast<String, bool>(),
        );
        return msg.toJson();

      case 'sendMessageNotOss':
        final msg = await _message.sendMessageNotOss(
          message: Message.fromJson(args['message'] as Map<String, dynamic>),
          offlinePushInfo: OfflinePushInfo.fromJson(
            args['offlinePushInfo'] as Map<String, dynamic>,
          ),
          userID: args['userID'] as String?,
          groupID: args['groupID'] as String?,
          isOnlineOnly: args['isOnlineOnly'] as bool? ?? false,
        );
        return msg.toJson();

      case 'getAdvancedHistoryMessageList':
        final result = await _message.getAdvancedHistoryMessageList(
          conversationID: args['conversationID'] as String?,
          startMsg: args['startMsg'] != null
              ? Message.fromJson(Map<String, dynamic>.from(args['startMsg'] as Map))
              : null,
          viewType: GetHistoryViewType.values.firstWhere(
            (e) => e.value == (args['viewType'] as int? ?? 0),
            orElse: () => GetHistoryViewType.history,
          ),
          count: args['count'] as int?,
        );
        return result.toJson();

      case 'getAdvancedHistoryMessageListReverse':
        final result = await _message.getAdvancedHistoryMessageListReverse(
          conversationID: args['conversationID'] as String?,
          startMsg: args['startMsg'] != null
              ? Message.fromJson(Map<String, dynamic>.from(args['startMsg'] as Map))
              : null,
          viewType: GetHistoryViewType.values.firstWhere(
            (e) => e.value == (args['viewType'] as int? ?? 0),
            orElse: () => GetHistoryViewType.history,
          ),
          count: args['count'] as int?,
        );
        return result.toJson();

      case 'findMessageList':
        final result = await _message.findMessageList(
          searchParams: (args['searchParams'] as List)
              .map((e) => SearchParams.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
        return result.toJson();

      case 'searchLocalMessages':
        final result = await _message.searchLocalMessages(
          conversationID: args['conversationID'] as String?,
          keywordList: (args['keywordList'] as List?)?.cast<String>() ?? const [],
          keywordListMatchType: args['keywordListMatchType'] as int? ?? 0,
          senderUserIDList: (args['senderUserIDList'] as List?)?.cast<String>() ?? const [],
          messageTypeList: (args['messageTypeList'] as List?)?.cast<int>() ?? const [],
          searchTimePosition: args['searchTimePosition'] as int? ?? 0,
          searchTimePeriod: args['searchTimePeriod'] as int? ?? 0,
          pageIndex: args['pageIndex'] as int? ?? 1,
          count: args['count'] as int? ?? 40,
        );
        return result.toJson();

      case 'revokeMessage':
        await _message.revokeMessage(
          conversationID: args['conversationID'] as String,
          clientMsgID: args['clientMsgID'] as String,
        );
        return null;

      case 'deleteMessageFromLocalStorage':
        await _message.deleteMessageFromLocalStorage(
          conversationID: args['conversationID'] as String,
          clientMsgID: args['clientMsgID'] as String,
        );
        return null;

      case 'deleteMessageFromLocalAndSvr':
        await _message.deleteMessageFromLocalAndSvr(
          conversationID: args['conversationID'] as String,
          clientMsgID: args['clientMsgID'] as String,
        );
        return null;

      case 'deleteAllMsgFromLocal':
        await _message.deleteAllMsgFromLocal();
        return null;

      case 'deleteAllMsgFromLocalAndSvr':
        await _message.deleteAllMsgFromLocalAndSvr();
        return null;

      case 'setMessageLocalEx':
        await _message.setMessageLocalEx(
          conversationID: args['conversationID'] as String,
          clientMsgID: args['clientMsgID'] as String,
          localEx: args['localEx'] as String,
        );
        return null;

      case 'insertSingleMessageToLocalStorage':
        final msg = await _message.insertSingleMessageToLocalStorage(
          receiverID: args['receiverID'] as String?,
          senderID: args['senderID'] as String?,
          message: args['message'] != null
              ? Message.fromJson(Map<String, dynamic>.from(args['message'] as Map))
              : null,
        );
        return msg.toJson();

      case 'insertGroupMessageToLocalStorage':
        final msg = await _message.insertGroupMessageToLocalStorage(
          groupID: args['groupID'] as String?,
          senderID: args['senderID'] as String?,
          message: args['message'] != null
              ? Message.fromJson(Map<String, dynamic>.from(args['message'] as Map))
              : null,
        );
        return msg.toJson();

      case 'createImageMessageFromFullPath':
        final msg = await _message.createImageMessageFromFullPath(
          imagePath: args['imagePath'] as String,
        );
        return msg.toJson();

      case 'createVideoMessageFromFullPath':
        final msg = await _message.createVideoMessageFromFullPath(
          videoPath: args['videoPath'] as String,
          videoType: args['videoType'] as String,
          duration: args['duration'] as int,
          snapshotPath: args['snapshotPath'] as String,
        );
        return msg.toJson();

      case 'createImageMessageFromBytes':
        final msg = await _message.createImageMessageFromBytes(
          bytes: args['bytes'] as Uint8List,
          fileName: args['fileName'] as String,
        );
        return msg.toJson();

      case 'createVideoMessageFromBytes':
        final msg = await _message.createVideoMessageFromBytes(
          bytes: args['bytes'] as Uint8List,
          fileName: args['fileName'] as String,
          duration: args['duration'] as int,
          videoType: args['videoType'] as String?,
          snapshotBytes: args['snapshotBytes'] as Uint8List?,
        );
        return msg.toJson();

      default:
        throw ArgumentError('Unknown message method: $name');
    }
  }

  // --------------------------------------------------------------------------
  // GroupManager 分发
  // --------------------------------------------------------------------------

  Future<dynamic> _dispatchGroup(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'getGroupsInfo':
        return _serializeList(
          await _group.getGroupsInfo(groupIDList: (args['groupIDList'] as List).cast<String>()),
        );

      case 'getJoinedGroupList':
        return _serializeList(await _group.getJoinedGroupList());

      case 'getJoinedGroupListPage':
        return _serializeList(
          await _group.getJoinedGroupListPage(
            offset: args['offset'] as int? ?? 0,
            count: args['count'] as int? ?? 40,
          ),
        );

      case 'isJoinedGroup':
        return await _group.isJoinedGroup(groupID: args['groupID'] as String);

      case 'createGroup':
        final info = await _group.createGroup(
          groupInfo: GroupInfo.fromJson(args['groupInfo'] as Map<String, dynamic>),
          memberUserIDs: (args['memberUserIDs'] as List?)?.cast<String>() ?? const [],
          adminUserIDs: (args['adminUserIDs'] as List?)?.cast<String>() ?? const [],
          ownerUserID: args['ownerUserID'] as String?,
        );
        return info.toJson();

      case 'setGroupInfo':
        await _group.setGroupInfo(
          groupInfo: GroupInfo.fromJson(args['groupInfo'] as Map<String, dynamic>),
        );
        return null;

      case 'inviteUserToGroup':
        await _group.inviteUserToGroup(
          groupID: args['groupID'] as String,
          userIDList: (args['userIDList'] as List).cast<String>(),
          reason: args['reason'] as String?,
        );
        return null;

      case 'kickGroupMember':
        await _group.kickGroupMember(
          groupID: args['groupID'] as String,
          userIDList: (args['userIDList'] as List).cast<String>(),
          reason: args['reason'] as String?,
        );
        return null;

      case 'getGroupMembersInfo':
        return _serializeList(
          await _group.getGroupMembersInfo(
            groupID: args['groupID'] as String,
            userIDList: (args['userIDList'] as List).cast<String>(),
          ),
        );

      case 'getGroupMemberList':
        return _serializeList(
          await _group.getGroupMemberList(
            groupID: args['groupID'] as String,
            filter: args['filter'] as int? ?? 0,
            offset: args['offset'] as int? ?? 0,
            count: args['count'] as int? ?? 40,
          ),
        );

      case 'getGroupOwnerAndAdmin':
        return _serializeList(
          await _group.getGroupOwnerAndAdmin(groupID: args['groupID'] as String),
        );

      case 'searchGroupMembers':
        return _serializeList(
          await _group.searchGroupMembers(
            groupID: args['groupID'] as String,
            keywordList: (args['keywordList'] as List?)?.cast<String>() ?? const [],
            isSearchUserID: args['isSearchUserID'] as bool? ?? false,
            isSearchMemberNickname: args['isSearchMemberNickname'] as bool? ?? false,
            offset: args['offset'] as int? ?? 0,
            count: args['count'] as int? ?? 40,
          ),
        );

      case 'setGroupMemberInfo':
        await _group.setGroupMemberInfo(
          groupMembersInfo: SetGroupMemberInfo.fromJson(
            args['groupMembersInfo'] as Map<String, dynamic>,
          ),
        );
        return null;

      case 'transferGroupOwner':
        await _group.transferGroupOwner(
          groupID: args['groupID'] as String,
          userID: args['userID'] as String,
        );
        return null;

      case 'joinGroup':
        await _group.joinGroup(
          groupID: args['groupID'] as String,
          reason: args['reason'] as String?,
          joinSource: args['joinSource'] as int? ?? 3,
          ex: args['ex'] as String?,
        );
        return null;

      case 'quitGroup':
        await _group.quitGroup(groupID: args['groupID'] as String);
        return null;

      case 'dismissGroup':
        await _group.dismissGroup(groupID: args['groupID'] as String);
        return null;

      case 'changeGroupMute':
        await _group.changeGroupMute(
          groupID: args['groupID'] as String,
          mute: args['mute'] as bool,
        );
        return null;

      case 'changeGroupMemberMute':
        await _group.changeGroupMemberMute(
          groupID: args['groupID'] as String,
          userID: args['userID'] as String,
          seconds: args['seconds'] as int? ?? 0,
        );
        return null;

      case 'getGroupApplicationListAsRecipient':
        final reqJson = args['req'] as Map<String, dynamic>?;
        return _serializeList(
          await _group.getGroupApplicationListAsRecipient(
            req: reqJson != null ? GetGroupApplicationListAsRecipientReq.fromJson(reqJson) : null,
          ),
        );

      case 'getGroupApplicationListAsApplicant':
        final reqJson = args['req'] as Map<String, dynamic>?;
        return _serializeList(
          await _group.getGroupApplicationListAsApplicant(
            req: reqJson != null ? GetGroupApplicationListAsApplicantReq.fromJson(reqJson) : null,
          ),
        );

      case 'acceptGroupApplication':
        await _group.acceptGroupApplication(
          groupID: args['groupID'] as String,
          userID: args['userID'] as String,
          handleMsg: args['handleMsg'] as String?,
        );
        return null;

      case 'refuseGroupApplication':
        await _group.refuseGroupApplication(
          groupID: args['groupID'] as String,
          userID: args['userID'] as String,
          handleMsg: args['handleMsg'] as String?,
        );
        return null;

      case 'getGroupApplicationUnhandledCount':
        return await _group.getGroupApplicationUnhandledCount(
          GetGroupApplicationUnhandledCountReq.fromJson(args['req'] as Map<String, dynamic>),
        );

      case 'searchGroups':
        return _serializeList(
          await _group.searchGroups(
            keywordList: (args['keywordList'] as List?)?.cast<String>() ?? const [],
            isSearchGroupID: args['isSearchGroupID'] as bool? ?? false,
            isSearchGroupName: args['isSearchGroupName'] as bool? ?? false,
          ),
        );

      case 'getGroupMemberListByJoinTime':
        return _serializeList(
          await _group.getGroupMemberListByJoinTime(
            groupID: args['groupID'] as String,
            offset: args['offset'] as int? ?? 0,
            count: args['count'] as int? ?? 0,
            joinTimeBegin: args['joinTimeBegin'] as int? ?? 0,
            joinTimeEnd: args['joinTimeEnd'] as int? ?? 0,
            filterUserIDList: (args['filterUserIDList'] as List?)?.cast<String>() ?? const [],
          ),
        );

      case 'getUsersInGroup':
        return await _group.getUsersInGroup(
          groupID: args['groupID'] as String,
          userIDList: (args['userIDList'] as List).cast<String>(),
        );

      default:
        throw ArgumentError('Unknown group method: $name');
    }
  }

  // --------------------------------------------------------------------------
  // UserManager 分发
  // --------------------------------------------------------------------------

  Future<dynamic> _dispatchUser(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'getUsersInfo':
        return _serializeList(
          await _user.getUsersInfo(userIDList: (args['userIDList'] as List).cast<String>()),
        );

      case 'getUsersInfoWithCache':
        return _serializeList(
          await _user.getUsersInfoWithCache(
            userIDList: (args['userIDList'] as List).cast<String>(),
          ),
        );

      case 'getUsersInfoFromSrv':
        return _serializeList(
          await _user.getUsersInfoFromSrv(userIDList: (args['userIDList'] as List).cast<String>()),
        );

      case 'getSelfUserInfo':
        final info = await _user.getSelfUserInfo();
        return info?.toJson();

      case 'setSelfInfo':
        await _user.setSelfInfo(
          nickname: args['nickname'] as String?,
          faceURL: args['faceURL'] as String?,
          globalRecvMsgOpt: args['globalRecvMsgOpt'] as int?,
          ex: args['ex'] as String?,
        );
        return null;

      case 'subscribeUsersStatus':
        return _serializeList(
          await _user.subscribeUsersStatus((args['userIDs'] as List).cast<String>()),
        );

      case 'unsubscribeUsersStatus':
        await _user.unsubscribeUsersStatus((args['userIDs'] as List).cast<String>());
        return null;

      case 'getSubscribeUsersStatus':
        return _serializeList(await _user.getSubscribeUsersStatus());

      case 'getUserStatus':
        return _serializeList(await _user.getUserStatus((args['userIDs'] as List).cast<String>()));

      case 'getUserClientConfig':
        return await _user.getUserClientConfig();

      case 'searchFriendInfo':
        return _serializeList(
          await _user.searchFriendInfo(
            args['keyword'] as String,
            pageNumber: args['pageNumber'] as int? ?? 1,
            showNumber: args['showNumber'] as int? ?? 10,
          ),
        );

      case 'searchUserFullInfo':
        return _serializeList(
          await _user.searchUserFullInfo(
            args['keyword'] as String,
            pageNumber: args['pageNumber'] as int? ?? 1,
            showNumber: args['showNumber'] as int? ?? 10,
          ),
        );

      case 'getUserFullInfo':
        final info = await _user.getUserFullInfo(userID: args['userID'] as String);
        return info?.toJson();

      case 'updateChatUserInfo':
        await _user.updateChatUserInfo(
          account: args['account'] as String?,
          phoneNumber: args['phoneNumber'] as String?,
          areaCode: args['areaCode'] as String?,
          email: args['email'] as String?,
          nickname: args['nickname'] as String?,
          faceURL: args['faceURL'] as String?,
          gender: args['gender'] as int?,
          birth: args['birth'] as int?,
        );
        return null;

      case 'getRtcToken':
        return await _user.getRtcToken(
          roomId: args['roomId'] as String,
          userId: args['userId'] as String,
        );

      case 'register':
        final result = await _user.register(
          nickname: args['nickname'] as String,
          password: args['password'] as String,
          faceURL: args['faceURL'] as String?,
          areaCode: args['areaCode'] as String?,
          phoneNumber: args['phoneNumber'] as String?,
          email: args['email'] as String?,
          account: args['account'] as String?,
          birth: args['birth'] as int? ?? 0,
          gender: args['gender'] as int? ?? 1,
          verificationCode: args['verificationCode'] as String,
          invitationCode: args['invitationCode'] as String?,
          autoLogin: args['autoLogin'] as bool? ?? true,
          deviceID: args['deviceID'] as String,
        );
        return result?.toJson();

      case 'sendVerificationCode':
        await _user.sendVerificationCode(
          areaCode: args['areaCode'] as String?,
          phoneNumber: args['phoneNumber'] as String?,
          email: args['email'] as String?,
          usedFor: args['usedFor'] as int,
          invitationCode: args['invitationCode'] as String?,
        );
        return null;

      case 'changePassword':
        await _user.changePassword(
          currentPassword: args['currentPassword'] as String,
          newPassword: args['newPassword'] as String,
        );
        return null;

      case 'resetPassword':
        await _user.resetPassword(
          areaCode: args['areaCode'] as String?,
          phoneNumber: args['phoneNumber'] as String?,
          email: args['email'] as String?,
          verifyCode: args['verifyCode'] as String,
          newPassword: args['newPassword'] as String,
        );
        return null;

      case 'setPaymentPassword':
        await _user.setPaymentPassword(
          paymentPassword: args['paymentPassword'] as String,
          loginPassword: args['loginPassword'] as String,
        );
        return null;

      case 'changePaymentPassword':
        await _user.changePaymentPassword(
          currentPaymentPassword: args['currentPaymentPassword'] as String,
          newPaymentPassword: args['newPaymentPassword'] as String,
        );
        return null;

      case 'verifyPaymentPassword':
        return await _user.verifyPaymentPassword(
          paymentPassword: args['paymentPassword'] as String,
        );

      case 'checkPaymentPasswordSet':
        return await _user.checkPaymentPasswordSet();

      case 'resetPaymentPassword':
        await _user.resetPaymentPassword(
          areaCode: args['areaCode'] as String?,
          phoneNumber: args['phoneNumber'] as String?,
          email: args['email'] as String?,
          verifyCode: args['verifyCode'] as String,
          newPaymentPassword: args['newPaymentPassword'] as String,
        );
        return null;

      default:
        throw ArgumentError('Unknown user method: $name');
    }
  }

  // --------------------------------------------------------------------------
  // FriendshipManager 分发
  // --------------------------------------------------------------------------

  Future<dynamic> _dispatchFriendship(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'getFriendsInfo':
        return _serializeList(
          await _friendship.getFriendsInfo(
            userIDList: (args['userIDList'] as List).cast<String>(),
            filterBlack: args['filterBlack'] as bool? ?? false,
          ),
        );

      case 'addFriend':
        await _friendship.addFriend(
          userID: args['userID'] as String,
          reason: args['reason'] as String?,
        );
        return null;

      case 'getFriendApplicationListAsRecipient':
        final reqJson = args['req'] as Map<String, dynamic>?;
        return _serializeList(
          await _friendship.getFriendApplicationListAsRecipient(
            req: reqJson != null ? GetFriendApplicationListAsRecipientReq.fromJson(reqJson) : null,
          ),
        );

      case 'getFriendApplicationListAsApplicant':
        final reqJson = args['req'] as Map<String, dynamic>?;
        return _serializeList(
          await _friendship.getFriendApplicationListAsApplicant(
            req: reqJson != null ? GetFriendApplicationListAsApplicantReq.fromJson(reqJson) : null,
          ),
        );

      case 'getFriendList':
        return _serializeList(
          await _friendship.getFriendList(filterBlack: args['filterBlack'] as bool? ?? false),
        );

      case 'getFriendListPage':
        return _serializeList(
          await _friendship.getFriendListPage(
            filterBlack: args['filterBlack'] as bool? ?? false,
            offset: args['offset'] as int? ?? 0,
            count: args['count'] as int? ?? 0,
          ),
        );

      case 'addBlacklist':
        await _friendship.addBlacklist(userID: args['userID'] as String, ex: args['ex'] as String?);
        return null;

      case 'getBlacklist':
        return _serializeList(await _friendship.getBlacklist());

      case 'removeBlacklist':
        await _friendship.removeBlacklist(userID: args['userID'] as String);
        return null;

      case 'checkFriend':
        return _serializeList(
          await _friendship.checkFriend(userIDList: (args['userIDList'] as List).cast<String>()),
        );

      case 'deleteFriend':
        await _friendship.deleteFriend(userID: args['userID'] as String);
        return null;

      case 'acceptFriendApplication':
        await _friendship.acceptFriendApplication(
          userID: args['userID'] as String,
          handleMsg: args['handleMsg'] as String?,
        );
        return null;

      case 'refuseFriendApplication':
        await _friendship.refuseFriendApplication(
          userID: args['userID'] as String,
          handleMsg: args['handleMsg'] as String?,
        );
        return null;

      case 'searchFriends':
        return _serializeList(
          await _friendship.searchFriends(
            keywordList: (args['keywordList'] as List?)?.cast<String>() ?? const [],
            isSearchUserID: args['isSearchUserID'] as bool? ?? false,
            isSearchNickname: args['isSearchNickname'] as bool? ?? false,
            isSearchRemark: args['isSearchRemark'] as bool? ?? false,
          ),
        );

      case 'updateFriends':
        await _friendship.updateFriends(
          updateFriendsReq: UpdateFriendsReq.fromJson(
            args['updateFriendsReq'] as Map<String, dynamic>,
          ),
        );
        return null;

      case 'getFriendApplicationUnhandledCount':
        return await _friendship.getFriendApplicationUnhandledCount();

      default:
        throw ArgumentError('Unknown friendship method: $name');
    }
  }

  // --------------------------------------------------------------------------
  // MomentsManager 分发
  // --------------------------------------------------------------------------

  Future<dynamic> _dispatchMoments(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'createMoment':
        final result = await _moments.createMoment(
          request: MomentCreateReq.fromJson(args['request'] as Map<String, dynamic>),
        );
        return result?.toJson();

      case 'deleteMoment':
        return await _moments.deleteMoment(momentID: args['momentID'] as String);

      case 'getMomentList':
        final result = await _moments.getMomentList(
          ownerUserID: args['ownerUserID'] as String?,
          pageNumber: args['pageNumber'] as int? ?? 1,
          showNumber: args['showNumber'] as int? ?? 20,
        );
        return result.toJson();

      case 'fetchMomentListFromServer':
        final result = await _moments.fetchMomentListFromServer(
          ownerUserID: args['ownerUserID'] as String?,
          pageNumber: args['pageNumber'] as int? ?? 1,
          showNumber: args['showNumber'] as int? ?? 20,
        );
        return result.toJson();

      case 'likeMoment':
        return await _moments.likeMoment(
          momentID: args['momentID'] as String,
          ownerUserID: args['ownerUserID'] as String?,
        );

      case 'unlikeMoment':
        return await _moments.unlikeMoment(
          momentID: args['momentID'] as String,
          ownerUserID: args['ownerUserID'] as String?,
        );

      case 'commentMoment':
        final result = await _moments.commentMoment(
          momentID: args['momentID'] as String,
          content: args['content'] as String,
          replyToUserID: args['replyToUserID'] as String?,
          ownerUserID: args['ownerUserID'] as String?,
        );
        return result?.toJson();

      case 'deleteComment':
        return await _moments.deleteComment(
          commentID: args['commentID'] as String,
          momentID: args['momentID'] as String?,
        );

      case 'handleNotification':
        await _moments.handleNotification(
          args['key'] as String,
          Map<String, dynamic>.from(args['data'] as Map),
        );
        return null;

      case 'syncFromServer':
        await _moments.syncFromServer();
        return null;

      default:
        throw ArgumentError('Unknown moments method: $name');
    }
  }

  // --------------------------------------------------------------------------
  // FavoriteManager 分发
  // --------------------------------------------------------------------------

  Future<dynamic> _dispatchFavorite(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'addFavorite':
        final result = await _favorite.addFavorite(
          type: FavoriteType.fromValue(args['type'] as String?),
          targetID: args['targetID'] as String,
          data: args['data'] as String?,
        );
        return result?.toJson();

      case 'removeFavorite':
        return await _favorite.removeFavorite(
          type: FavoriteType.fromValue(args['type'] as String?),
          targetID: args['targetID'] as String,
        );

      case 'getFavoriteList':
        final result = await _favorite.getFavoriteList(
          pageNumber: args['pageNumber'] as int? ?? 1,
          showNumber: args['showNumber'] as int? ?? 20,
        );
        return result.toJson();

      case 'fetchFavoriteListFromServer':
        final result = await _favorite.fetchFavoriteListFromServer(
          pageNumber: args['pageNumber'] as int? ?? 1,
          showNumber: args['showNumber'] as int? ?? 20,
        );
        return result.toJson();

      case 'isFavorited':
        return await _favorite.isFavorited(
          type: FavoriteType.fromValue(args['type'] as String?),
          targetID: args['targetID'] as String,
        );

      case 'isMessageFavorited':
        return await _favorite.isMessageFavorited(args['clientMsgID'] as String);

      case 'isMomentFavorited':
        return await _favorite.isMomentFavorited(args['momentID'] as String);

      case 'addMessage':
        final result = await _favorite.addMessage(
          message: Message.fromJson(args['message'] as Map<String, dynamic>),
        );
        return result?.toJson();

      case 'removeMessage':
        return await _favorite.removeMessage(clientMsgID: args['clientMsgID'] as String);

      case 'addMoment':
        final result = await _favorite.addMoment(
          moment: MomentInfo.fromJson(args['moment'] as Map<String, dynamic>),
        );
        return result?.toJson();

      case 'removeMoment':
        return await _favorite.removeMoment(momentID: args['momentID'] as String);

      case 'addMomentComment':
        final result = await _favorite.addMomentComment(
          comment: MomentCommentWithUser.fromJson(args['comment'] as Map<String, dynamic>),
        );
        return result?.toJson();

      case 'removeMomentComment':
        return await _favorite.removeMomentComment(commentID: args['commentID'] as String);

      case 'addNote':
        final result = await _favorite.addNote(
          title: args['title'] as String,
          content: args['content'] as String,
        );
        return result?.toJson();

      case 'updateFavorite':
        final result = await _favorite.updateFavorite(
          type: FavoriteType.fromValue(args['type'] as String?),
          targetID: args['targetID'] as String,
          data: args['data'] as String,
        );
        return result?.toJson();

      case 'updateNote':
        final result = await _favorite.updateNote(
          targetID: args['targetID'] as String,
          title: args['title'] as String,
          content: args['content'] as String,
        );
        return result?.toJson();

      case 'addLink':
        final result = await _favorite.addLink(
          link: LinkInfo.fromJson(args['link'] as Map<String, dynamic>),
        );
        return result?.toJson();

      case 'removeFavoriteItem':
        return await _favorite.removeFavoriteItem(
          FavoriteItem.fromJson(args['item'] as Map<String, dynamic>),
        );

      case 'handleNotification':
        await _favorite.handleNotification(
          args['key'] as String,
          Map<String, dynamic>.from(args['data'] as Map),
        );
        return null;

      case 'syncFromServer':
        await _favorite.syncFromServer();
        return null;

      default:
        throw ArgumentError('Unknown favorite method: $name');
    }
  }

  // --------------------------------------------------------------------------
  // CallManager 分发
  // --------------------------------------------------------------------------

  Future<dynamic> _dispatchCall(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'invite':
        final session = await _call.invite(
          inviteeUserIDs: (args['inviteeUserIDs'] as List).cast<String>(),
          callType: CallType.fromValue(args['callType'] as String),
          timeout: args['timeout'] as int? ?? 60,
        );
        return session.toJson();

      case 'accept':
        final session = await _call.accept(roomID: args['roomID'] as String);
        return session.toJson();

      case 'reject':
        await _call.reject(roomID: args['roomID'] as String);
        return null;

      case 'cancel':
        await _call.cancel();
        return null;

      case 'hangup':
        await _call.hangup();
        return null;

      default:
        throw ArgumentError('Unknown call method: $name');
    }
  }

  // --------------------------------------------------------------------------
  // RedPacketManager 分发
  // --------------------------------------------------------------------------

  Future<dynamic> _dispatchRedPacket(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'preloadGrabbedStatus':
        await _redPacket.preloadGrabbedStatus((args['packetIDs'] as List).cast<String>());
        return null;

      case 'markGrabbed':
        await _redPacket.markGrabbed(args['packetID'] as String);
        return null;

      case 'sendRedPacket':
        return await _redPacket.sendRedPacket(
          SendRedPacketRequest.fromJson(args['req'] as Map<String, dynamic>),
        );

      case 'grabRedPacket':
        return await _redPacket.grabRedPacket(args['packetID'] as String);

      case 'getRedPacketDetail':
        final detail = await _redPacket.getRedPacketDetail(args['packetID'] as String);
        return detail.toJson();

      case 'getPointsBalance':
        return await _redPacket.getPointsBalance();

      case 'getPointsTransactions':
        final (total, items) = await _redPacket.getPointsTransactions(
          pageNumber: args['pageNumber'] as int? ?? 1,
          showNumber: args['showNumber'] as int? ?? 20,
          txType: args['txType'] as int?,
          startTime: args['startTime'] != null
              ? DateTime.fromMillisecondsSinceEpoch(args['startTime'] as int)
              : null,
          endTime: args['endTime'] != null
              ? DateTime.fromMillisecondsSinceEpoch(args['endTime'] as int)
              : null,
          keyword: args['keyword'] as String?,
        );
        return {'total': total, 'items': _serializeList(items)};

      case 'getIncomeTransactions':
        final (total, items) = await _redPacket.getIncomeTransactions(
          pageNumber: args['pageNumber'] as int? ?? 1,
          showNumber: args['showNumber'] as int? ?? 20,
        );
        return {'total': total, 'items': _serializeList(items)};

      case 'getExpenseTransactions':
        final (total, items) = await _redPacket.getExpenseTransactions(
          pageNumber: args['pageNumber'] as int? ?? 1,
          showNumber: args['showNumber'] as int? ?? 20,
        );
        return {'total': total, 'items': _serializeList(items)};

      default:
        throw ArgumentError('Unknown redPacket method: $name');
    }
  }
}
