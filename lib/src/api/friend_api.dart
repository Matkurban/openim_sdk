import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 好友与黑名单 API 客户端。
final class FriendApi extends BaseApiClient {
  /// 创建 `FriendApi` 实例。
  ///
  /// Creates a `FriendApi` instance.
  ///
  /// - [httpClient] HTTP客户端 / HTTP client.
  FriendApi({required super.httpClient}) : super(name: 'FriendApi');

  /// 添加好友。
  ///
  /// Add friend.
  ///
  /// - [fromUserID] 从用户ID / From user ID.
  /// - [toUserID] 转为用户ID / To user ID.
  /// - [reqMsg] 请求参数消息 / Request message.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> addFriend({
    required String fromUserID,
    required String toUserID,
    String? reqMsg,
    String? ex,
  }) {
    return postIm(
      ImApiUrl.addFriend,
      data: <String, dynamic>{
        'fromUserID': fromUserID,
        'toUserID': toUserID,
        'reqMsg': reqMsg ?? '',
        'ex': ex ?? '',
      },
    );
  }

  /// 删除好友。
  ///
  /// Delete friend.
  ///
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [friendUserID] 好友用户ID / Friend user ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> deleteFriend({required String ownerUserID, required String friendUserID}) {
    return postIm(
      ImApiUrl.deleteFriend,
      data: <String, dynamic>{'ownerUserID': ownerUserID, 'friendUserID': friendUserID},
    );
  }

  /// 获取接收好友申请列表。
  ///
  /// Get receive friend application list.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getRecvFriendApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) {
    return postIm(
      ImApiUrl.getRecvFriendApplicationList,
      data: <String, dynamic>{
        'userID': userID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  /// 获取当前用户好友申请列表。
  ///
  /// Get self user friend application list.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getSelfFriendApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) {
    return postIm(
      ImApiUrl.getSelfFriendApplicationList,
      data: <String, dynamic>{
        'userID': userID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  /// 获取当前用户未处理Apply数量。
  ///
  /// Get self user unhandled apply count.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [time] 时间戳 / Timestamp.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getSelfUnhandledApplyCount({required String userID, int time = 0}) {
    return postIm(
      ImApiUrl.getSelfUnhandledApplyCount,
      data: <String, dynamic>{'userID': userID, 'time': time},
    );
  }

  /// 添加好友响应。
  ///
  /// Add friend response.
  ///
  /// - [fromUserID] 从用户ID / From user ID.
  /// - [toUserID] 转为用户ID / To user ID.
  /// - [handleResult] 处理结果 / Handle result.
  /// - [handleMsg] 处理消息 / Handle message.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> addFriendResponse({
    required String fromUserID,
    required String toUserID,
    required int handleResult,
    String? handleMsg,
  }) {
    return postIm(
      ImApiUrl.addFriendResponse,
      data: <String, dynamic>{
        'fromUserID': fromUserID,
        'toUserID': toUserID,
        'handleResult': handleResult,
        'handleMsg': handleMsg ?? '',
      },
    );
  }

  /// 更新好友列表。
  ///
  /// Update friends.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> updateFriends({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.updateFriends, data: req);
  }

  /// 获取好友列表。
  ///
  /// Get friend list.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getFriendList({required String userID, int offset = 0, int count = 100}) {
    return postIm(
      ImApiUrl.getFriendList,
      data: <String, dynamic>{
        'userID': userID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  /// 获取Designated好友列表。
  ///
  /// Get designated friends.
  ///
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [friendUserIDs] 好友用户ID 列表 / Friend user i ds.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getDesignatedFriends({
    required String ownerUserID,
    required List<String> friendUserIDs,
  }) {
    return postIm(
      ImApiUrl.getDesignatedFriends,
      data: <String, dynamic>{'ownerUserID': ownerUserID, 'friendUserIDs': friendUserIDs},
    );
  }

  /// 获取增量好友列表。
  ///
  /// Get incremental friends.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getIncrementalFriends({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.getIncrementalFriends, data: req);
  }

  /// 获取全量好友用户ID 列表。
  ///
  /// Get full friend user i ds.
  ///
  /// - [userID] 用户ID / User ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getFullFriendUserIDs({required String userID}) {
    return postIm(ImApiUrl.getFullFriendUserIDs, data: <String, dynamic>{'userID': userID});
  }

  /// 添加黑名单。
  ///
  /// Add blacklist.
  ///
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [blackUserID] 黑名单用户ID / Blacklist user ID.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> addBlack({
    required String ownerUserID,
    required String blackUserID,
    String? ex,
  }) {
    return postIm(
      ImApiUrl.addBlack,
      data: <String, dynamic>{
        'ownerUserID': ownerUserID,
        'blackUserID': blackUserID,
        'ex': ex ?? '',
      },
    );
  }

  /// 移除黑名单。
  ///
  /// Remove blacklist.
  ///
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [blackUserID] 黑名单用户ID / Blacklist user ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> removeBlack({required String ownerUserID, required String blackUserID}) {
    return postIm(
      ImApiUrl.removeBlack,
      data: <String, dynamic>{'ownerUserID': ownerUserID, 'blackUserID': blackUserID},
    );
  }

  /// 获取黑名单列表。
  ///
  /// Get blacklist list.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [offset] 偏移量 / Offset.
  /// - [count] 数量 / Count.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getBlackList({required String userID, int offset = 0, int count = 100}) {
    return postIm(
      ImApiUrl.getBlackList,
      data: <String, dynamic>{
        'userID': userID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }
}
