import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 好友与黑名单 API 客户端。
final class FriendApi extends BaseApiClient {
  FriendApi({required super.httpClient}) : super(name: 'FriendApi');

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

  Future<ApiResponse> deleteFriend({required String ownerUserID, required String friendUserID}) {
    return postIm(
      ImApiUrl.deleteFriend,
      data: <String, dynamic>{'ownerUserID': ownerUserID, 'friendUserID': friendUserID},
    );
  }

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

  Future<ApiResponse> getSelfUnhandledApplyCount({required String userID, int time = 0}) {
    return postIm(
      ImApiUrl.getSelfUnhandledApplyCount,
      data: <String, dynamic>{'userID': userID, 'time': time},
    );
  }

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

  Future<ApiResponse> updateFriends({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.updateFriends, data: req);
  }

  Future<ApiResponse> getFriendList({required String userID, int offset = 0, int count = 100}) {
    return postIm(
      ImApiUrl.getFriendList,
      data: <String, dynamic>{
        'userID': userID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  Future<ApiResponse> getDesignatedFriends({
    required String ownerUserID,
    required List<String> friendUserIDs,
  }) {
    return postIm(
      ImApiUrl.getDesignatedFriends,
      data: <String, dynamic>{'ownerUserID': ownerUserID, 'friendUserIDs': friendUserIDs},
    );
  }

  Future<ApiResponse> getIncrementalFriends({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.getIncrementalFriends, data: req);
  }

  Future<ApiResponse> getFullFriendUserIDs({required String userID}) {
    return postIm(ImApiUrl.getFullFriendUserIDs, data: <String, dynamic>{'userID': userID});
  }

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

  Future<ApiResponse> removeBlack({required String ownerUserID, required String blackUserID}) {
    return postIm(
      ImApiUrl.removeBlack,
      data: <String, dynamic>{'ownerUserID': ownerUserID, 'blackUserID': blackUserID},
    );
  }

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
