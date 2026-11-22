import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';
import '../utils/platform_utils.dart';

/// 用户信息、在线状态与 Chat 用户搜索 API 客户端。
final class UserApi extends BaseApiClient {
  /// 创建 `UserApi` 实例。
  ///
  /// Creates a `UserApi` instance.
  ///
  /// - [httpClient] HTTP客户端 / HTTP client.
  UserApi({required super.httpClient}) : super(name: 'UserApi');

  /// 获取用户列表信息。
  ///
  /// Get users info.
  ///
  /// - [userIDs] 用户ID 列表 / User i ds.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getUsersInfo({required List<String> userIDs}) {
    return postIm(ImApiUrl.getUsersInfo, data: <String, dynamic>{'userIDs': userIDs});
  }

  /// 更新用户信息。
  ///
  /// Update user info.
  ///
  /// - [userInfo] 用户信息 / User info.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> updateUserInfo({required Map<String, dynamic> userInfo}) {
    return postIm(ImApiUrl.updateUserInfo, data: userInfo);
  }

  /// 更新用户信息扩展字段。
  ///
  /// Update user info extension.
  ///
  /// - [userInfo] 用户信息 / User info.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> updateUserInfoEx({required Map<String, dynamic> userInfo}) {
    return postIm(ImApiUrl.updateUserInfoEx, data: userInfo);
  }

  /// 获取用户客户端配置。
  ///
  /// Get user client configuration.
  ///
  /// - [userID] 用户ID / User ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getUserClientConfig({required String userID}) {
    return postIm(ImApiUrl.getUserClientConfig, data: <String, dynamic>{'userID': userID});
  }

  /// 订阅用户列表状态。
  ///
  /// Subscribe users status.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [userIDs] 用户ID 列表 / User i ds.
  /// - [genre] genre / Genre.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 获取订阅用户列表状态。
  ///
  /// Get subscribe users status.
  ///
  /// - [userID] 用户ID / User ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getSubscribeUsersStatus({required String userID}) {
    return postIm(ImApiUrl.getSubscribeUsersStatus, data: <String, dynamic>{'userID': userID});
  }

  /// 获取用户状态。
  ///
  /// Get user status.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [userIDs] 用户ID 列表 / User i ds.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getUserStatus({required String userID, required List<String> userIDs}) {
    return postIm(
      ImApiUrl.getUserStatus,
      data: <String, dynamic>{'userID': userID, 'userIDs': userIDs},
    );
  }

  /// 搜索好友。
  ///
  /// Search friend.
  ///
  /// - [keyword] 关键词 / Keyword.
  /// - [pageNumber] 分页号码 / Paged number.
  /// - [showNumber] 展示号码 / Display number.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 搜索用户全量信息。
  ///
  /// Search user full info.
  ///
  /// - [keyword] 关键词 / Keyword.
  /// - [pageNumber] 分页号码 / Paged number.
  /// - [showNumber] 展示号码 / Display number.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 获取用户全量信息。
  ///
  /// Get user full info.
  ///
  /// - [userIDs] 用户ID 列表 / User i ds.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 更新聊天用户信息。
  ///
  /// Update chat user info.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [account] 账号 / Account.
  /// - [phoneNumber] 手机号号码 / Phone number number.
  /// - [areaCode] 区号代码 / Area code.
  /// - [email] 邮箱 / Email.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [gender] 性别 / Gender.
  /// - [birth] 生日 / Birth date.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
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

  /// 获取实时音视频令牌。
  ///
  /// Get RTC token.
  ///
  /// - [roomId] 房间ID / Room ID.
  /// - [userId] 用户ID / User ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getRtcToken({required String roomId, required String userId}) {
    return postChat(
      ChatApiUrl.getRtcToken,
      data: <String, dynamic>{'roomId': roomId, 'userId': userId},
    );
  }
}
