import '../core/base_manager.dart';
import '../core/sdk_context.dart';
import '../listener/conversation_listener.dart';
import '../listener/friendship_listener.dart';
import '../models/api_response.dart';
import '../models/conversation_info.dart';
import '../models/openim_exception.dart';
import '../models/search_info.dart';
import '../models/update_req.dart';
import '../models/user_info.dart';
import '../utils/open_im_utils.dart';

/// 好友关系与黑名单管理器（继承 [BaseManager]）。
final class FriendshipManager extends BaseManager<OnFriendshipListener> {
  final SdkContext _context;
  final OnConversationListener? Function() _conversationListenerProvider;

  /// 创建 `FriendshipManager` 实例。
  ///
  /// Creates a `FriendshipManager` instance.
  ///
  /// - [_context] context / Context.
  /// - [_conversationListenerProvider] 会话监听器Provider / Conversation listener provider.
  FriendshipManager({required this._context, required this._conversationListenerProvider})
    : super('FriendshipManager');

  /// 设置好友关系监听器。
  ///
  /// Set friendship listener.
  ///
  /// - [listener] 监听器 / Listener.
  void setFriendshipListener(OnFriendshipListener listener) {
    setPrimaryListener(listener);
  }

  /// 获取好友列表信息。
  ///
  /// Get friends info.
  ///
  /// - [userIDList] 用户ID列表 / User ID list.
  /// - [filterBlack] 筛选黑名单 / Filter blacklist.
  /// - Returns: `Future<List<FriendInfo>>` 列表结果 / Resulting `Future<List<FriendInfo>>` list.
  Future<List<FriendInfo>> getFriendsInfo({
    required List<String> userIDList,
    bool filterBlack = false,
  }) async {
    if (userIDList.isEmpty) {
      return <FriendInfo>[];
    }
    List<FriendInfo> list = await _context.db.friends.getFriendsByUserIDs(userIDList);
    if (filterBlack) {
      final Set<String> blacks = await _context.db.friends.getBlackUserIDSet();
      list = list.where((FriendInfo f) => !blacks.contains(f.friendUserID)).toList();
    }
    return list;
  }

  /// 添加好友。
  ///
  /// Add friend.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [reason] 原因 / Reason.
  Future<void> addFriend({required String userID, String? reason}) async {
    final ApiResponse resp = await _context.apis.friend.addFriend(
      fromUserID: currentUserID,
      toUserID: userID,
      reqMsg: reason,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 获取好友申请列表作为接收方。
  ///
  /// Get friend application list as recipient.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<List<FriendApplicationInfo>>` 列表结果 / Resulting `Future<List<FriendApplicationInfo>>` list.
  Future<List<FriendApplicationInfo>> getFriendApplicationListAsRecipient({
    GetFriendApplicationListAsRecipientReq? req,
  }) async {
    final ApiResponse resp = await _context.apis.friend.getRecvFriendApplicationList(
      userID: currentUserID,
      offset: req?.offset ?? 0,
      count: req?.count ?? 100,
    );
    if (resp.errCode != 0) {
      return _context.db.friends.getFriendRequestsAsRecipient(
        offset: req?.offset ?? 0,
        count: req?.count ?? 40,
      );
    }
    final List<dynamic> list = resp.data?['friendRequests'] as List<dynamic>? ?? const <dynamic>[];
    return list
        .whereType<Map<String, dynamic>>()
        .map<FriendApplicationInfo>(FriendApplicationInfo.fromJson)
        .toList();
  }

  /// 获取好友申请列表作为申请方。
  ///
  /// Get friend application list as applicant.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<List<FriendApplicationInfo>>` 列表结果 / Resulting `Future<List<FriendApplicationInfo>>` list.
  Future<List<FriendApplicationInfo>> getFriendApplicationListAsApplicant({
    GetFriendApplicationListAsApplicantReq? req,
  }) async {
    final ApiResponse resp = await _context.apis.friend.getSelfFriendApplicationList(
      userID: currentUserID,
      offset: req?.offset ?? 0,
      count: req?.count ?? 100,
    );
    if (resp.errCode != 0) {
      return _context.db.friends.getFriendRequestsAsApplicant(
        offset: req?.offset ?? 0,
        count: req?.count ?? 40,
      );
    }
    final List<dynamic> list = resp.data?['friendRequests'] as List<dynamic>? ?? const <dynamic>[];
    return list
        .whereType<Map<String, dynamic>>()
        .map<FriendApplicationInfo>(FriendApplicationInfo.fromJson)
        .toList();
  }

  /// 获取好友列表。
  ///
  /// Get friend list.
  ///
  /// - [filterBlack] 筛选黑名单 / Filter blacklist.
  /// - Returns: `Future<List<FriendInfo>>` 列表结果 / Resulting `Future<List<FriendInfo>>` list.
  Future<List<FriendInfo>> getFriendList({bool filterBlack = false}) async {
    List<FriendInfo> friends = await _context.db.friends.getAllFriends();
    if (filterBlack) {
      final Set<String> blacks = await _context.db.friends.getBlackUserIDSet();
      friends = friends.where((FriendInfo f) => !blacks.contains(f.friendUserID)).toList();
    }
    return friends;
  }

  /// 获取好友列表分页。
  ///
  /// Get friend list paged.
  ///
  /// - [filterBlack] 筛选黑名单 / Filter blacklist.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<List<FriendInfo>>` 列表结果 / Resulting `Future<List<FriendInfo>>` list.
  Future<List<FriendInfo>> getFriendListPage({
    bool filterBlack = false,
    int offset = 0,
    int count = 40,
  }) async {
    final int safeCount = count <= 0 ? 40 : count;
    if (filterBlack) {
      final Set<String> blacks = await _context.db.friends.getBlackUserIDSet();
      return _context.db.friends.getFriendsPageExcluding(offset, safeCount, blacks);
    }
    return _context.db.friends.getFriendsPage(offset, safeCount);
  }

  /// 添加黑名单。
  ///
  /// Add blacklist.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [ex] 扩展字段 / Extension.
  Future<void> addBlacklist({required String userID, String? ex}) async {
    final ApiResponse resp = await _context.apis.friend.addBlack(
      ownerUserID: currentUserID,
      blackUserID: userID,
      ex: ex,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    await _context.db.friends.insertBlack(<String, dynamic>{
      'ownerUserID': currentUserID,
      'blockUserID': userID,
      'userID': userID,
      'ex': ex,
      'createTime': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 获取黑名单。
  ///
  /// Get blacklist.
  ///
  /// - Returns: `Future<List<BlacklistInfo>>` 列表结果 / Resulting `Future<List<BlacklistInfo>>` list.
  Future<List<BlacklistInfo>> getBlacklist() => _context.db.friends.getBlackList();

  /// 移除黑名单。
  ///
  /// Remove blacklist.
  ///
  /// - [userID] 用户ID / User ID.
  Future<void> removeBlacklist({required String userID}) async {
    final ApiResponse resp = await _context.apis.friend.removeBlack(
      ownerUserID: currentUserID,
      blackUserID: userID,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    await _context.db.friends.removeBlack(userID);
  }

  /// 检查好友。
  ///
  /// Check friend.
  ///
  /// - [userIDList] 用户ID列表 / User ID list.
  /// - Returns: `Future<List<FriendshipInfo>>` 列表结果 / Resulting `Future<List<FriendshipInfo>>` list.
  Future<List<FriendshipInfo>> checkFriend({required List<String> userIDList}) async {
    if (userIDList.isEmpty) {
      return <FriendshipInfo>[];
    }
    final List<FriendInfo> friends = await _context.db.friends.getFriendsByUserIDs(userIDList);
    final Set<String> friendSet = friends
        .map<String?>((FriendInfo f) => f.friendUserID)
        .whereType<String>()
        .toSet();
    return userIDList
        .map<FriendshipInfo>(
          (String uid) => FriendshipInfo(userID: uid, result: friendSet.contains(uid) ? 1 : 0),
        )
        .toList();
  }

  /// 删除好友。
  ///
  /// Delete friend.
  ///
  /// - [userID] 用户ID / User ID.
  Future<void> deleteFriend({required String userID}) async {
    final ApiResponse resp = await _context.apis.friend.deleteFriend(
      ownerUserID: currentUserID,
      friendUserID: userID,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    await _context.db.friends.deleteFriend(userID);
  }

  /// 接受好友申请。
  ///
  /// Accept friend application.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [handleMsg] 处理消息 / Handle message.
  Future<void> acceptFriendApplication({required String userID, String? handleMsg}) async {
    final ApiResponse resp = await _context.apis.friend.addFriendResponse(
      fromUserID: userID,
      toUserID: currentUserID,
      handleResult: 1,
      handleMsg: handleMsg,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 拒绝好友申请。
  ///
  /// Refuse friend application.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [handleMsg] 处理消息 / Handle message.
  Future<void> refuseFriendApplication({required String userID, String? handleMsg}) async {
    final ApiResponse resp = await _context.apis.friend.addFriendResponse(
      fromUserID: userID,
      toUserID: currentUserID,
      handleResult: -1,
      handleMsg: handleMsg,
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
  }

  /// 搜索好友列表。
  ///
  /// Search friends.
  ///
  /// - [keywordList] 关键词列表 / Keyword list.
  /// - [isSearchUserID] 是否搜索用户ID / Whether search user ID.
  /// - [isSearchNickname] 是否搜索昵称 / Whether search nickname.
  /// - [isSearchRemark] 是否搜索备注 / Whether search remark.
  /// - Returns: `Future<List<SearchFriendsInfo>>` 列表结果 / Resulting `Future<List<SearchFriendsInfo>>` list.
  Future<List<SearchFriendsInfo>> searchFriends({
    List<String> keywordList = const <String>[],
    bool isSearchUserID = false,
    bool isSearchNickname = false,
    bool isSearchRemark = false,
  }) async {
    final String keyword = keywordList.isNotEmpty ? keywordList.first : '';
    if (keyword.isEmpty) {
      return <SearchFriendsInfo>[];
    }
    final List<FriendInfo> matches = await _context.db.friends.searchFriends(
      keyword,
      searchUserID: isSearchUserID,
      searchNickname: isSearchNickname,
      searchRemark: isSearchRemark,
    );
    return matches
        .map<SearchFriendsInfo>(
          (FriendInfo f) => SearchFriendsInfo(
            ownerUserID: f.ownerUserID,
            friendUserID: f.friendUserID,
            remark: f.remark,
            createTime: f.createTime,
            addSource: f.addSource,
            operatorUserID: f.operatorUserID,
            nickname: f.nickname,
            faceURL: f.faceURL,
            ex: f.ex,
            relationship: 1,
          ),
        )
        .toList();
  }

  /// 更新好友列表。
  ///
  /// Update friends.
  ///
  /// - [updateFriendsReq] 更新好友列表请求参数 / Update friends request.
  Future<void> updateFriends({required UpdateFriendsReq updateFriendsReq}) async {
    final ApiResponse resp = await _context.apis.friend.updateFriends(
      req: <String, dynamic>{'ownerUserID': currentUserID, ...updateFriendsReq.toJson()},
    );
    if (resp.errCode != 0) {
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }
    final List<String> ids = updateFriendsReq.friendUserIDs ?? const <String>[];
    for (final String fid in ids) {
      final Map<String, dynamic> updates = <String, dynamic>{
        if (updateFriendsReq.remark != null) 'remark': updateFriendsReq.remark,
        if (updateFriendsReq.isPinned != null) 'isPinned': updateFriendsReq.isPinned,
        if (updateFriendsReq.ex != null) 'ex': updateFriendsReq.ex,
      };
      if (updates.isNotEmpty) {
        await _context.db.friends.updateFriend(fid, updates);
      }
      if (updateFriendsReq.remark != null) {
        final FriendInfo? updated = await _context.db.friends.getFriendByUserID(fid);
        if (updated != null) {
          final String showName = updated.getShowName();
          final String convID = OpenImUtils.genSingleConversationID(currentUserID, fid);
          await _context.db.conversations.updateConversation(convID, <String, dynamic>{
            'showName': showName,
          });
          final ConversationInfo? conv = await _context.db.conversations.getConversation(convID);
          if (conv != null) {
            _conversationListenerProvider()?.conversationChanged(<ConversationInfo>[conv]);
          }
          await _context.db.messages.updateSingleChatMessageSenderInfo(
            fid,
            senderNickname: showName,
            senderFaceUrl: updated.faceURL,
          );
        }
      }
    }
  }

  /// 获取好友申请未处理数量。
  ///
  /// Get friend application unhandled count.
  ///
  /// - Returns: 整数结果 / Integer result.
  Future<int> getFriendApplicationUnhandledCount() async {
    final ApiResponse resp = await _context.apis.friend.getSelfUnhandledApplyCount(
      userID: currentUserID,
    );
    if (resp.errCode == 0) {
      return (resp.data?['count'] as num?)?.toInt() ?? 0;
    }
    return _context.db.friends.getFriendRequestUnhandledCount();
  }
}
