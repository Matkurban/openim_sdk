import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';
import '../utils/platform_utils.dart';

/// 用户信息、在线状态与 Chat 用户搜索 API 客户端。
final class UserApi extends BaseApiClient {
  UserApi({required super.httpClient}) : super(name: 'UserApi');

  Future<ApiResponse> getUsersInfo({required List<String> userIDs}) {
    return postIm(ImApiUrl.getUsersInfo, data: <String, dynamic>{'userIDs': userIDs});
  }

  Future<ApiResponse> updateUserInfo({required Map<String, dynamic> userInfo}) {
    return postIm(ImApiUrl.updateUserInfo, data: userInfo);
  }

  Future<ApiResponse> updateUserInfoEx({required Map<String, dynamic> userInfo}) {
    return postIm(ImApiUrl.updateUserInfoEx, data: userInfo);
  }

  Future<ApiResponse> getUserClientConfig({required String userID}) {
    return postIm(ImApiUrl.getUserClientConfig, data: <String, dynamic>{'userID': userID});
  }

  Future<ApiResponse> subscribeUsersStatus({
    required String userID,
    required List<String> userIDs,
    required int genre,
  }) {
    return postIm(
      ImApiUrl.subscribeUsersStatus,
      data: <String, dynamic>{'userID': userID, 'userIDs': userIDs, 'genre': genre},
    );
  }

  Future<ApiResponse> getSubscribeUsersStatus({required String userID}) {
    return postIm(ImApiUrl.getSubscribeUsersStatus, data: <String, dynamic>{'userID': userID});
  }

  Future<ApiResponse> getUserStatus({required String userID, required List<String> userIDs}) {
    return postIm(
      ImApiUrl.getUserStatus,
      data: <String, dynamic>{'userID': userID, 'userIDs': userIDs},
    );
  }

  Future<ApiResponse> searchFriend({
    required String keyword,
    int pageNumber = 1,
    int showNumber = 10,
  }) {
    return postChat(
      ChatApiUrl.searchFriend,
      data: <String, dynamic>{
        'keyword': keyword,
        'pagination': <String, int>{'pageNumber': pageNumber, 'showNumber': showNumber},
      },
    );
  }

  Future<ApiResponse> searchUserFullInfo({
    required String keyword,
    int pageNumber = 1,
    int showNumber = 10,
  }) {
    return postChat(
      ChatApiUrl.searchUserFull,
      data: <String, dynamic>{
        'keyword': keyword,
        'pagination': <String, int>{'pageNumber': pageNumber, 'showNumber': showNumber},
      },
    );
  }

  Future<ApiResponse> getUserFullInfo({required List<String> userIDs}) {
    return postChat(
      ChatApiUrl.getUserFull,
      data: <String, dynamic>{
        'pagination': <String, int>{'pageNumber': 1, 'showNumber': userIDs.length},
        'userIDs': userIDs,
        'platform': PlatformUtils.platformID,
      },
    );
  }

  Future<ApiResponse> updateChatUserInfo({
    required String userID,
    String? account,
    String? phoneNumber,
    String? areaCode,
    String? email,
    String? nickname,
    String? faceURL,
    int? gender,
    int? birth,
  }) {
    return postChat(
      ChatApiUrl.updateUser,
      data: <String, dynamic>{
        'userID': userID,
        'platform': PlatformUtils.platformID,
        'account': ?account,
        'phoneNumber': ?phoneNumber,
        'areaCode': ?areaCode,
        'email': ?email,
        'nickname': ?nickname,
        'faceURL': ?faceURL,
        'gender': ?gender,
        'birth': ?birth,
      },
    );
  }

  Future<ApiResponse> getRtcToken({required String roomId, required String userId}) {
    return postChat(
      ChatApiUrl.getRtcToken,
      data: <String, dynamic>{'roomId': roomId, 'userId': userId},
    );
  }
}
