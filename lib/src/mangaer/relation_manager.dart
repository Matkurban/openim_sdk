import 'package:get_it/get_it.dart';
import 'package:aoiwe_logger/aoiwe_logger.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';

class FriendshipManager {
  FriendshipManager._internal();

  static final FriendshipManager _instance = FriendshipManager._internal();

  factory FriendshipManager() => _instance;

  static final AoiweLogger _log = AoiweLogger('FriendshipManager');

  final GetIt _getIt = GetIt.instance;

  DatabaseService get _database {
    return _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  ImApiService get _api {
    return _getIt.get<ImApiService>(instanceName: InstanceName.imApiService);
  }

  OnFriendshipListener? listener;

  late String _currentUserID;

  ConversationManager? _conversationManager;

  void setFriendshipListener(OnFriendshipListener listener) {
    this.listener = listener;
  }

  @internal
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
  }

  @internal
  void setConversationManager(ConversationManager conversationManager) {
    _conversationManager = conversationManager;
  }

  /// 查询好友信息
  /// [userIDList] 用户ID列表
  /// [filterBlack] 是否过滤黑名单用户
  Future<List<FriendInfo>> getFriendsInfo({
    required List<String> userIDList,
    bool filterBlack = false,
  }) async {
    _log.info('userIDList=$userIDList, filterBlack=$filterBlack', methodName: 'getFriendsInfo');
    try {
      if (userIDList.isEmpty) return [];
      final results = await _database.getFriendsByUserIDs(userIDList);
      if (filterBlack) {
        final blackIDs = await _database.getBlackUserIDSet();
        results.removeWhere((f) => blackIDs.contains(f.friendUserID));
      }
      return results;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getFriendsInfo');
      rethrow;
    }
  }

  /// 发送好友请求
  /// [userID] 被邀请的用户ID
  /// [reason] 备注说明
  Future<void> addFriend({required String userID, String? reason}) async {
    _log.info('userID=$userID, reason=$reason', methodName: 'addFriend');
    try {
      // API-first: 先请求服务器，与 Go SDK 保持一致
      final resp = await _api.addFriend(
        fromUserID: _currentUserID,
        toUserID: userID,
        reqMsg: reason,
      );
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
      _log.info('已发送好友申请: toUserID=$userID', methodName: 'addFriend');
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addFriend');
      rethrow;
    }
  }

  /// 获取收到的好友申请列表（对齐 Go SDK: 从服务器按需获取）
  /// [req] 查询参数
  Future<List<FriendApplicationInfo>> getFriendApplicationListAsRecipient({
    GetFriendApplicationListAsRecipientReq? req,
  }) async {
    _log.info('req=$req', methodName: 'getFriendApplicationListAsRecipient');
    try {
      final offset = req?.offset ?? 0;
      final count = req?.count ?? 40;
      final resp = await _api.getRecvFriendApplicationList(
        userID: _currentUserID,
        offset: offset,
        count: count,
      );
      if (resp.errCode != 0) return [];
      final list = resp.data?['FriendRequests'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => FriendApplicationInfo.fromJson(e))
          .toList();
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'getFriendApplicationListAsRecipient',
      );
      rethrow;
    }
  }

  /// 获取已发送的好友申请列表（对齐 Go SDK: 从服务器按需获取）
  /// [req] 查询参数
  Future<List<FriendApplicationInfo>> getFriendApplicationListAsApplicant({
    GetFriendApplicationListAsApplicantReq? req,
  }) async {
    _log.info('req=$req', methodName: 'getFriendApplicationListAsApplicant');
    try {
      final offset = req?.offset ?? 0;
      final count = req?.count ?? 40;
      final resp = await _api.getSelfFriendApplicationList(
        userID: _currentUserID,
        offset: offset,
        count: count,
      );
      if (resp.errCode != 0) return [];
      final list = resp.data?['FriendRequests'] as List? ?? [];
      return list
          .whereType<Map<String, dynamic>>()
          .map((e) => FriendApplicationInfo.fromJson(e))
          .toList();
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'getFriendApplicationListAsApplicant',
      );
      rethrow;
    }
  }

  /// 获取好友列表（包含已加入黑名单的好友）
  /// [filterBlack] 是否过滤黑名单用户
  Future<List<FriendInfo>> getFriendList({bool filterBlack = false}) async {
    _log.info('filterBlack=$filterBlack', methodName: 'getFriendList');
    try {
      var list = await _database.getAllFriends();
      if (filterBlack) {
        final blackList = await _database.getBlackList();
        final blackIDs = blackList.map((b) => b.blockUserID).toSet();
        list = list.where((f) => !blackIDs.contains(f.friendUserID)).toList();
      }
      return list;
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getFriendList');
      rethrow;
    }
  }

  /// 分页获取好友列表
  /// [filterBlack] 是否过滤黑名单用户
  /// [offset] 起始索引
  /// [count] 每页数量
  Future<List<FriendInfo>> getFriendListPage({
    bool filterBlack = false,
    int offset = 0,
    int count = 40,
  }) async {
    _log.info(
      'filterBlack=$filterBlack, offset=$offset, count=$count',
      methodName: 'getFriendListPage',
    );
    try {
      if (filterBlack) {
        final blackIDs = await _database.getBlackUserIDSet();
        return _database.getFriendsPageExcluding(offset, count, blackIDs);
      }
      return _database.getFriendsPage(offset, count);
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getFriendListPage');
      rethrow;
    }
  }

  /// 添加到黑名单
  /// [userID] 要拉黑的用户ID
  /// [ex] 扩展信息
  Future<void> addBlacklist({required String userID, String? ex}) async {
    _log.info('userID=$userID, ex=$ex', methodName: 'addBlacklist');
    try {
      // API-first
      final resp = await _api.addBlack(ownerUserID: _currentUserID, blackUserID: userID, ex: ex);
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      await _database.insertBlack({
        'ownerUserID': _currentUserID,
        'blockUserID': userID,
        'createTime': now,
        'ex': ex,
      });
      _log.info('已添加黑名单: $userID', methodName: 'addBlacklist');

      listener?.blackAdded(
        BlacklistInfo(ownerUserID: _currentUserID, blockUserID: userID, createTime: now, ex: ex),
      );
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addBlacklist');
      rethrow;
    }
  }

  /// 获取黑名单列表
  Future<List<BlacklistInfo>> getBlacklist() async {
    _log.info('called', methodName: 'getBlacklist');
    try {
      return await _database.getBlackList();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'getBlacklist');
      rethrow;
    }
  }

  /// 从黑名单中移除
  /// [userID] 要解除拉黑的用户ID
  Future<void> removeBlacklist({required String userID}) async {
    _log.info('userID=$userID', methodName: 'removeBlacklist');
    try {
      // API-first
      final resp = await _api.removeBlack(ownerUserID: _currentUserID, blackUserID: userID);
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      await _database.removeBlack(userID);
      listener?.blackDeleted(BlacklistInfo(ownerUserID: _currentUserID, blockUserID: userID));
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'removeBlacklist');
      rethrow;
    }
  }

  /// 检查好友关系
  /// [userIDList] 用户ID列表
  Future<List<FriendshipInfo>> checkFriend({required List<String> userIDList}) async {
    _log.info('userIDList=$userIDList', methodName: 'checkFriend');
    try {
      if (userIDList.isEmpty) return [];
      final friends = await _database.getFriendsByUserIDs(userIDList);
      final friendSet = {for (final f in friends) f.friendUserID};
      return userIDList.map((uid) {
        return FriendshipInfo(
          userID: uid,
          result: friendSet.contains(uid) ? Relationship.friend.value : Relationship.black.value,
        );
      }).toList();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'checkFriend');
      rethrow;
    }
  }

  /// 删除好友
  /// [userID] 用户ID
  Future<void> deleteFriend({required String userID}) async {
    _log.info('userID=$userID', methodName: 'deleteFriend');
    try {
      await _database.deleteFriend(userID);
      _log.info('好友已删除: $userID', methodName: 'deleteFriend');

      listener?.friendDeleted(FriendInfo(friendUserID: userID));

      // 同步到服务器
      final resp = await _api.deleteFriend(ownerUserID: _currentUserID, friendUserID: userID);
      if (resp.errCode != 0) {
        _log.warning('删除好友同步服务器失败: ${resp.errMsg}');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'deleteFriend');
      rethrow;
    }
  }

  /// 接受好友申请
  /// [userID] 申请者用户ID
  /// [handleMsg] 处理消息
  Future<void> acceptFriendApplication({required String userID, String? handleMsg}) async {
    _log.info('userID=$userID, handleMsg=$handleMsg', methodName: 'acceptFriendApplication');
    try {
      // API-first: 先请求服务器，与 Go SDK 保持一致
      final resp = await _api.addFriendResponse(
        fromUserID: userID,
        toUserID: _currentUserID,
        handleResult: 1,
        handleMsg: handleMsg,
      );
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
      _log.info('好友申请已接受: userID=$userID', methodName: 'acceptFriendApplication');
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'acceptFriendApplication');
      rethrow;
    }
  }

  /// 拒绝好友申请
  /// [userID] 申请者用户ID
  /// [handleMsg] 拒绝理由
  Future<void> refuseFriendApplication({required String userID, String? handleMsg}) async {
    _log.info('userID=$userID, handleMsg=$handleMsg', methodName: 'refuseFriendApplication');
    try {
      // API-first: 先请求服务器，与 Go SDK 保持一致
      final resp = await _api.addFriendResponse(
        fromUserID: userID,
        toUserID: _currentUserID,
        handleResult: -1,
        handleMsg: handleMsg,
      );
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }
      _log.info('好友申请已拒绝: userID=$userID', methodName: 'refuseFriendApplication');
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'refuseFriendApplication');
      rethrow;
    }
  }

  /// 搜索好友
  /// [keywordList] 搜索关键字，当前仅支持一个关键字搜索，不能为空
  /// [isSearchUserID] 是否用关键字搜索好友ID
  /// [isSearchNickname] 是否用关键字搜索昵称
  /// [isSearchRemark] 是否用关键字搜索备注
  Future<List<SearchFriendsInfo>> searchFriends({
    List<String> keywordList = const [],
    bool isSearchUserID = false,
    bool isSearchNickname = false,
    bool isSearchRemark = false,
  }) async {
    _log.info(
      'keywordList=$keywordList, isSearchUserID=$isSearchUserID, isSearchNickname=$isSearchNickname, isSearchRemark=$isSearchRemark',
      methodName: 'searchFriends',
    );
    try {
      final keyword = keywordList.isNotEmpty ? keywordList.first : '';
      if (keyword.isEmpty) return [];

      final dataList = await _database.searchFriends(
        keyword,
        searchUserID: isSearchUserID,
        searchNickname: isSearchNickname,
        searchRemark: isSearchRemark,
      );

      return dataList.map((friend) {
        return SearchFriendsInfo(
          relationship: Relationship.friend.value,
          ownerUserID: friend.ownerUserID,
          nickname: friend.nickname,
          faceURL: friend.faceURL,
          friendUserID: friend.friendUserID,
          remark: friend.remark,
          ex: friend.ex,
          createTime: friend.createTime,
          addSource: friend.addSource,
          operatorUserID: friend.operatorUserID,
        );
      }).toList();
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'searchFriends');
      rethrow;
    }
  }

  /// 更新好友信息（备注、扩展信息等）
  /// [updateFriendsReq] 更新请求
  Future<void> updateFriends({required UpdateFriendsReq updateFriendsReq}) async {
    _log.info(
      'friendUserIDs=${updateFriendsReq.friendUserIDs}, remark=${updateFriendsReq.remark}, isPinned=${updateFriendsReq.isPinned}',
      methodName: 'updateFriends',
    );
    try {
      if (updateFriendsReq.friendUserIDs == null || updateFriendsReq.friendUserIDs!.isEmpty) return;

      final updateData = <String, dynamic>{};
      if (updateFriendsReq.remark != null) updateData['remark'] = updateFriendsReq.remark;
      if (updateFriendsReq.isPinned != null) updateData['isPinned'] = updateFriendsReq.isPinned;
      if (updateFriendsReq.ex != null) updateData['ex'] = updateFriendsReq.ex;
      if (updateData.isEmpty) return;

      // API-first：先同步到服务器
      final reqMap = <String, dynamic>{
        'ownerUserID': _currentUserID,
        'friendUserIDs': updateFriendsReq.friendUserIDs,
      };
      if (updateFriendsReq.remark != null) reqMap['remark'] = updateFriendsReq.remark;
      if (updateFriendsReq.isPinned != null) reqMap['isPinned'] = updateFriendsReq.isPinned;
      if (updateFriendsReq.ex != null) reqMap['ex'] = updateFriendsReq.ex;

      final resp = await _api.updateFriends(req: reqMap);
      if (resp.errCode != 0) {
        throw OpenIMException(code: resp.errCode, message: resp.errMsg);
      }

      // 服务端成功后更新本地
      for (final friendUserID in updateFriendsReq.friendUserIDs!) {
        await _database.updateFriend(friendUserID, updateData);
      }

      final updatedFriends = await _database.getFriendsByUserIDs(updateFriendsReq.friendUserIDs!);
      for (final updated in updatedFriends) {
        listener?.friendInfoChanged(updated);

        // 对齐 Go SDK UpdateConFaceUrlAndNickName：更新对应单聊会话的 showName/faceURL
        final showName = updated.getShowName();
        final convID = OpenImUtils.genSingleConversationID(
          _currentUserID,
          updated.friendUserID ?? '',
        );
        final conv = await _database.getConversation(convID);
        if (conv != null) {
          final convUpdates = <String, dynamic>{'showName': showName};
          if (updated.faceURL != null) convUpdates['faceURL'] = updated.faceURL;
          if (convUpdates.isNotEmpty) {
            await _database.updateConversation(convID, convUpdates);
            final updatedConv = await _database.getConversation(convID);
            if (updatedConv != null) {
              _conversationManager?.listener?.conversationChanged([updatedConv]);
            }
          }
        }

        await _database.updateSingleChatMessageSenderInfo(
          updated.friendUserID ?? '',
          senderNickname: showName,
          senderFaceUrl: updated.faceURL,
        );
      }

      _log.info('好友信息已更新: ${updateFriendsReq.friendUserIDs}', methodName: 'updateFriends');
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'updateFriends');
      rethrow;
    }
  }

  /// 获取未处理的好友申请数量（对齐 Go SDK: 从服务器获取）
  Future<int> getFriendApplicationUnhandledCount() async {
    _log.info('called', methodName: 'getFriendApplicationUnhandledCount');
    try {
      final resp = await _api.getSelfUnhandledApplyCount(userID: _currentUserID);
      if (resp.errCode != 0) return 0;
      return (resp.data?['count'] as num?)?.toInt() ?? 0;
    } catch (e, s) {
      _log.error(
        e.toString(),
        error: e,
        stackTrace: s,
        methodName: 'getFriendApplicationUnhandledCount',
      );
      rethrow;
    }
  }
}
