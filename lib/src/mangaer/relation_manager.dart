import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/services/database_service.dart';

/// 好友关系管理器
/// 对应 open-im-sdk-flutter 中 FriendshipManager。
/// 负责好友管理、好友申请、黑名单等关系链操作。
class FriendshipManager {
  static final Logger _log = Logger('FriendshipManager');

  DatabaseService get _db => GetIt.instance.get<DatabaseService>();

  /// 关系链监听器
  OnFriendshipListener? listener;

  /// 设置好友关系监听器
  void setFriendshipListener(OnFriendshipListener listener) {
    this.listener = listener;
  }

  // ---------------------------------------------------------------------------
  // 好友信息查询
  // ---------------------------------------------------------------------------

  /// 查询好友信息
  /// [userIDList] 用户ID列表
  /// [filterBlack] 是否过滤黑名单用户
  Future<List<FriendInfo>> getFriendsInfo({
    required List<String> userIDList,
    bool filterBlack = false,
  }) async {
    final results = <FriendInfo>[];
    for (final uid in userIDList) {
      final data = await _db.getFriendByUserID(uid);
      if (data != null) {
        results.add(_convertFriendInfo(data));
      }
    }
    if (filterBlack) {
      final blackList = await _db.getBlackList();
      final blackIDs = blackList.map((b) => b['blockUserID'] as String?).toSet();
      results.removeWhere((f) => blackIDs.contains(f.friendUserID));
    }
    return results;
  }

  /// 发送好友请求
  /// [userID] 被邀请的用户ID
  /// [reason] 备注说明
  Future<void> addFriend({required String userID, String? reason}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.upsertFriendRequest({
      'fromUserID': _db.currentUserID,
      'toUserID': userID,
      'reqMsg': reason ?? '',
      'createTime': now,
      'handleResult': 0,
    });
    _log.info('已发送好友申请: toUserID=$userID');

    // TODO: 通过服务器发送好友申请
  }

  /// 获取收到的好友申请列表
  /// [req] 查询参数
  Future<List<FriendApplicationInfo>> getFriendApplicationListAsRecipient({
    GetFriendApplicationListAsRecipientReq? req,
  }) async {
    final offset = req?.offset ?? 0;
    final count = req?.count ?? 40;
    final dataList = await _db.getFriendRequestsAsRecipient(offset: offset, count: count);
    return dataList.map(_convertFriendApplicationInfo).toList();
  }

  /// 获取已发送的好友申请列表
  /// [req] 查询参数
  Future<List<FriendApplicationInfo>> getFriendApplicationListAsApplicant({
    GetFriendApplicationListAsApplicantReq? req,
  }) async {
    final offset = req?.offset ?? 0;
    final count = req?.count ?? 40;
    final dataList = await _db.getFriendRequestsAsApplicant(offset: offset, count: count);
    return dataList.map(_convertFriendApplicationInfo).toList();
  }

  /// 获取好友列表（包含已加入黑名单的好友）
  /// [filterBlack] 是否过滤黑名单用户
  Future<List<FriendInfo>> getFriendList({bool filterBlack = false}) async {
    final dataList = await _db.getAllFriends();
    var list = dataList.map(_convertFriendInfo).toList();
    if (filterBlack) {
      final blackList = await _db.getBlackList();
      final blackIDs = blackList.map((b) => b['blockUserID'] as String?).toSet();
      list.removeWhere((f) => blackIDs.contains(f.friendUserID));
    }
    return list;
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
    final dataList = await _db.getFriendsPage(offset, count);
    var list = dataList.map(_convertFriendInfo).toList();
    if (filterBlack) {
      final blackList = await _db.getBlackList();
      final blackIDs = blackList.map((b) => b['blockUserID'] as String?).toSet();
      list.removeWhere((f) => blackIDs.contains(f.friendUserID));
    }
    return list;
  }

  /// 设置好友备注
  /// [userID] 好友用户ID
  /// [remark] 备注名
  @Deprecated('Use [updateFriends] instead')
  Future<void> setFriendRemark({required String userID, required String remark}) {
    final req = UpdateFriendsReq(friendUserIDs: [userID], remark: remark);
    return updateFriends(updateFriendsReq: req);
  }

  /// 添加到黑名单
  /// [userID] 要拉黑的用户ID
  /// [ex] 扩展信息
  Future<void> addBlacklist({required String userID, String? ex}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.insertBlack({
      'ownerUserID': _db.currentUserID,
      'blockUserID': userID,
      'createTime': now,
      'ex': ex,
    });
    _log.info('已添加黑名单: $userID');

    listener?.blackAdded(
      BlacklistInfo(ownerUserID: _db.currentUserID, blockUserID: userID, createTime: now, ex: ex),
    );

    // TODO: 同步到服务器
  }

  /// 获取黑名单列表
  Future<List<BlacklistInfo>> getBlacklist() async {
    final dataList = await _db.getBlackList();
    return dataList.map(_convertBlacklistInfo).toList();
  }

  /// 从黑名单中移除
  /// [userID] 要解除拉黑的用户ID
  Future<void> removeBlacklist({required String userID}) async {
    await _db.removeBlack(userID);
    _log.info('已移除黑名单: $userID');

    listener?.blackDeleted(BlacklistInfo(ownerUserID: _db.currentUserID, blockUserID: userID));

    // TODO: 同步到服务器
  }

  /// 检查好友关系
  /// [userIDList] 用户ID列表
  Future<List<FriendshipInfo>> checkFriend({required List<String> userIDList}) async {
    final results = <FriendshipInfo>[];
    for (final uid in userIDList) {
      final friend = await _db.getFriendByUserID(uid);
      results.add(
        FriendshipInfo(
          userID: uid,
          result: friend != null ? Relationship.friend.value : Relationship.black.value,
        ),
      );
    }
    return results;
  }

  /// 删除好友
  /// [userID] 用户ID
  Future<void> deleteFriend({required String userID}) async {
    await _db.deleteFriend(userID);
    _log.info('好友已删除: $userID');

    listener?.friendDeleted(FriendInfo(friendUserID: userID));

    // TODO: 同步到服务器
  }

  /// 接受好友申请
  /// [userID] 申请者用户ID
  /// [handleMsg] 处理消息
  Future<void> acceptFriendApplication({required String userID, String? handleMsg}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.upsertFriendRequest({
      'fromUserID': userID,
      'toUserID': _db.currentUserID,
      'handleResult': 1,
      'handleMsg': handleMsg ?? '',
      'handlerUserID': _db.currentUserID,
      'handleTime': now,
    });

    await _db.upsertFriend({
      'ownerUserID': _db.currentUserID,
      'friendUserID': userID,
      'createTime': now,
    });

    _log.info('好友申请已接受: userID=$userID');

    listener?.friendAdded(
      FriendInfo(ownerUserID: _db.currentUserID, friendUserID: userID, createTime: now),
    );

    // TODO: 同步到服务器
  }

  /// 拒绝好友申请
  /// [userID] 申请者用户ID
  /// [handleMsg] 拒绝理由
  Future<void> refuseFriendApplication({required String userID, String? handleMsg}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.upsertFriendRequest({
      'fromUserID': userID,
      'toUserID': _db.currentUserID,
      'handleResult': -1,
      'handleMsg': handleMsg ?? '',
      'handlerUserID': _db.currentUserID,
      'handleTime': now,
    });

    _log.info('好友申请已拒绝: userID=$userID');

    // TODO: 同步到服务器
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
    final keyword = keywordList.isNotEmpty ? keywordList.first : '';
    if (keyword.isEmpty) return [];

    final dataList = await _db.searchFriends(
      keyword,
      searchUserID: isSearchUserID,
      searchNickname: isSearchNickname,
      searchRemark: isSearchRemark,
    );

    return dataList.map((data) {
      final friend = _convertFriendInfo(data);
      return SearchFriendsInfo(
        relationship: Relationship.friend.value,
        ownerUserID: friend.ownerUserID,
        userID: friend.userID,
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
  }

  /// 设置好友扩展信息
  @Deprecated('Use [updateFriends] instead')
  Future<void> setFriendsEx(List<String> friendIDs, {String? ex}) {
    final req = UpdateFriendsReq(friendUserIDs: friendIDs, ex: ex);
    return updateFriends(updateFriendsReq: req);
  }

  /// 更新好友信息（备注、扩展信息等）
  /// [updateFriendsReq] 更新请求
  Future<void> updateFriends({required UpdateFriendsReq updateFriendsReq}) async {
    if (updateFriendsReq.friendUserIDs == null || updateFriendsReq.friendUserIDs!.isEmpty) return;

    for (final friendUserID in updateFriendsReq.friendUserIDs!) {
      final existing = await _db.getFriendByUserID(friendUserID);
      if (existing == null) continue;

      final updateData = <String, dynamic>{
        'friendUserID': friendUserID,
        'ownerUserID': _db.currentUserID,
      };
      if (updateFriendsReq.remark != null) updateData['remark'] = updateFriendsReq.remark;
      if (updateFriendsReq.isPinned != null) updateData['isPinned'] = updateFriendsReq.isPinned;
      if (updateFriendsReq.ex != null) updateData['ex'] = updateFriendsReq.ex;

      await _db.upsertFriend({...existing, ...updateData});

      final updated = await _db.getFriendByUserID(friendUserID);
      if (updated != null) {
        listener?.friendInfoChanged(_convertFriendInfo(updated));
      }
    }

    _log.info('好友信息已更新: ${updateFriendsReq.friendUserIDs}');

    // TODO: 同步到服务器
  }

  /// 获取未处理的好友申请数量
  /// [req] 查询参数
  Future<int> getFriendApplicationUnhandledCount(GetFriendApplicationUnhandledCountReq req) async {
    return _db.getFriendRequestUnhandledCount();
  }

  // ---------------------------------------------------------------------------
  // 内部回调方法（供服务器推送消息处理使用）
  // ---------------------------------------------------------------------------

  /// 处理服务器推送的好友新增通知
  void onFriendAdded(FriendInfo info) {
    listener?.friendAdded(info);
  }

  /// 处理服务器推送的好友删除通知
  void onFriendDeleted(FriendInfo info) {
    listener?.friendDeleted(info);
  }

  /// 处理服务器推送的好友信息变更通知
  void onFriendInfoChanged(FriendInfo info) {
    listener?.friendInfoChanged(info);
  }

  /// 处理服务器推送的好友申请通知
  void onFriendApplicationAdded(FriendApplicationInfo info) {
    listener?.friendApplicationAdded(info);
  }

  /// 处理服务器推送的好友申请已接受通知
  void onFriendApplicationAccepted(FriendApplicationInfo info) {
    listener?.friendApplicationAccepted(info);
  }

  /// 处理服务器推送的好友申请已拒绝通知
  void onFriendApplicationRejected(FriendApplicationInfo info) {
    listener?.friendApplicationRejected(info);
  }

  // ---------------------------------------------------------------------------
  // 私有辅助方法
  // ---------------------------------------------------------------------------

  /// 数据库 Map 转 FriendInfo
  FriendInfo _convertFriendInfo(Map<String, dynamic> data) {
    return FriendInfo(
      ownerUserID: data['ownerUserID'] as String?,
      userID: data['friendUserID'] as String?,
      nickname: data['nickname'] as String?,
      faceURL: data['faceURL'] as String?,
      friendUserID: data['friendUserID'] as String?,
      remark: data['remark'] as String?,
      ex: data['ex'] as String?,
      createTime: data['createTime'] as int?,
      addSource: data['addSource'] as int?,
      operatorUserID: data['operatorUserID'] as String?,
    );
  }

  /// 数据库 Map 转 FriendApplicationInfo
  FriendApplicationInfo _convertFriendApplicationInfo(Map<String, dynamic> data) {
    return FriendApplicationInfo(
      fromUserID: data['fromUserID'] as String?,
      fromNickname: data['fromNickname'] as String?,
      fromFaceURL: data['fromFaceURL'] as String?,
      toUserID: data['toUserID'] as String?,
      toNickname: data['toNickname'] as String?,
      toFaceURL: data['toFaceURL'] as String?,
      handleResult: data['handleResult'] as int?,
      reqMsg: data['reqMsg'] as String?,
      createTime: data['createTime'] as int?,
      handlerUserID: data['handlerUserID'] as String?,
      handleMsg: data['handleMsg'] as String?,
      handleTime: data['handleTime'] as int?,
      ex: data['ex'] as String?,
    );
  }

  /// 数据库 Map 转 BlacklistInfo
  BlacklistInfo _convertBlacklistInfo(Map<String, dynamic> data) {
    return BlacklistInfo(
      ownerUserID: data['ownerUserID'] as String?,
      blockUserID: data['blockUserID'] as String?,
      nickname: data['nickname'] as String?,
      faceURL: data['faceURL'] as String?,
      gender: data['gender'] as int?,
      createTime: data['createTime'] as int?,
      addSource: data['addSource'] as int?,
      operatorUserID: data['operatorUserID'] as String?,
      ex: data['ex'] as String?,
    );
  }
}
