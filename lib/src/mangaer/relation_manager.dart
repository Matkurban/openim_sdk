import 'package:get_it/get_it.dart';
import 'package:openim_sdk/src/logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/config/instance_name.dart';
import 'package:openim_sdk/src/services/database_service.dart';
import 'package:openim_sdk/src/services/im_api_service.dart';

class FriendshipManager {
  static final Logger _log = Logger('FriendshipManager');

  final GetIt _getIt = GetIt.instance;

  DatabaseService get _database {
    return _getIt.get<DatabaseService>(instanceName: InstanceName.databaseService);
  }

  ImApiService get _api {
    return _getIt.get<ImApiService>(instanceName: InstanceName.imApiService);
  }

  OnFriendshipListener? listener;

  late String _currentUserID;

  void setFriendshipListener(OnFriendshipListener listener) {
    this.listener = listener;
  }

  @internal
  void setCurrentUserID(String userID) {
    _currentUserID = userID;
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
      final now = DateTime.now().millisecondsSinceEpoch;
      await _database.upsertFriendRequest({
        'fromUserID': _currentUserID,
        'toUserID': userID,
        'reqMsg': reason ?? '',
        'createTime': now,
        'handleResult': 0,
      });
      _log.info('已发送好友申请: toUserID=$userID', methodName: 'addFriend');

      // 同步到服务器
      final resp = await _api.addFriend(
        fromUserID: _currentUserID,
        toUserID: userID,
        reqMsg: reason,
      );
      if (resp.errCode != 0) {
        _log.warning('发送好友申请同步服务器失败: ${resp.errMsg}');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'addFriend');
      rethrow;
    }
  }

  /// 获取收到的好友申请列表
  /// [req] 查询参数
  Future<List<FriendApplicationInfo>> getFriendApplicationListAsRecipient({
    GetFriendApplicationListAsRecipientReq? req,
  }) async {
    _log.info('req=$req', methodName: 'getFriendApplicationListAsRecipient');
    try {
      final offset = req?.offset ?? 0;
      final count = req?.count ?? 40;
      final dataList = await _database.getFriendRequestsAsRecipient(offset: offset, count: count);
      return dataList;
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

  /// 获取已发送的好友申请列表
  /// [req] 查询参数
  Future<List<FriendApplicationInfo>> getFriendApplicationListAsApplicant({
    GetFriendApplicationListAsApplicantReq? req,
  }) async {
    _log.info('req=$req', methodName: 'getFriendApplicationListAsApplicant');
    try {
      final offset = req?.offset ?? 0;
      final count = req?.count ?? 40;
      final dataList = await _database.getFriendRequestsAsApplicant(offset: offset, count: count);
      return dataList;
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

      // 同步到服务器
      final resp = await _api.addBlack(ownerUserID: _currentUserID, blackUserID: userID, ex: ex);
      if (resp.errCode != 0) {
        _log.warning('添加黑名单同步服务器失败: ${resp.errMsg}');
      }
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
      await _database.removeBlack(userID);
      _log.info('已移除黑名单: $userID', methodName: 'removeBlacklist');

      listener?.blackDeleted(BlacklistInfo(ownerUserID: _currentUserID, blockUserID: userID));

      // 同步到服务器
      final resp = await _api.removeBlack(ownerUserID: _currentUserID, blackUserID: userID);
      if (resp.errCode != 0) {
        _log.warning('移除黑名单同步服务器失败: ${resp.errMsg}');
      }
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
      final now = DateTime.now().millisecondsSinceEpoch;
      await _database.upsertFriendRequest({
        'fromUserID': userID,
        'toUserID': _currentUserID,
        'handleResult': 1,
        'handleMsg': handleMsg ?? '',
        'handlerUserID': _currentUserID,
        'handleTime': now,
      });

      await _database.upsertFriend({
        'ownerUserID': _currentUserID,
        'friendUserID': userID,
        'createTime': now,
      });

      _log.info('好友申请已接受: userID=$userID', methodName: 'acceptFriendApplication');

      listener?.friendAdded(
        FriendInfo(ownerUserID: _currentUserID, friendUserID: userID, createTime: now),
      );

      // 同步到服务器
      final resp = await _api.addFriendResponse(
        fromUserID: userID,
        toUserID: _currentUserID,
        handleResult: 1,
        handleMsg: handleMsg,
      );
      if (resp.errCode != 0) {
        _log.warning('接受好友申请同步服务器失败: ${resp.errMsg}');
      }
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
      final now = DateTime.now().millisecondsSinceEpoch;
      await _database.upsertFriendRequest({
        'fromUserID': userID,
        'toUserID': _currentUserID,
        'handleResult': -1,
        'handleMsg': handleMsg ?? '',
        'handlerUserID': _currentUserID,
        'handleTime': now,
      });

      _log.info('好友申请已拒绝: userID=$userID', methodName: 'refuseFriendApplication');

      listener?.friendApplicationRejected(
        FriendApplicationInfo(
          fromUserID: userID,
          toUserID: _currentUserID,
          handleResult: -1,
          handleMsg: handleMsg,
        ),
      );

      // 同步到服务器
      final resp = await _api.addFriendResponse(
        fromUserID: userID,
        toUserID: _currentUserID,
        handleResult: -1,
        handleMsg: handleMsg,
      );
      if (resp.errCode != 0) {
        _log.warning('拒绝好友申请同步服务器失败: ${resp.errMsg}');
      }
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

      // 批量更新：先统一更新，再批量查询结果
      for (final friendUserID in updateFriendsReq.friendUserIDs!) {
        await _database.updateFriend(friendUserID, updateData);
      }

      // 一次性获取所有更新后的好友信息
      final updatedFriends = await _database.getFriendsByUserIDs(updateFriendsReq.friendUserIDs!);
      for (final updated in updatedFriends) {
        listener?.friendInfoChanged(updated);
      }

      _log.info('好友信息已更新: ${updateFriendsReq.friendUserIDs}', methodName: 'updateFriends');

      // 同步到服务器
      final resp = await _api.updateFriends(
        req: {
          'ownerUserID': _currentUserID,
          'friendUserIDs': updateFriendsReq.friendUserIDs,
          'remark': ?updateFriendsReq.remark,
          'isPinned': ?updateFriendsReq.isPinned,
          'ex': ?updateFriendsReq.ex,
        },
      );
      if (resp.errCode != 0) {
        _log.warning('更新好友信息同步服务器失败: ${resp.errMsg}');
      }
    } catch (e, s) {
      _log.error(e.toString(), error: e, stackTrace: s, methodName: 'updateFriends');
      rethrow;
    }
  }

  /// 获取未处理的好友申请数量
  /// [req] 查询参数
  Future<int> getFriendApplicationUnhandledCount() async {
    _log.info('called', methodName: 'getFriendApplicationUnhandledCount');
    try {
      return await _database.getFriendRequestUnhandledCount();
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
