import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 群组与群成员 API 客户端。
final class GroupApi extends BaseApiClient {
  GroupApi({required super.httpClient}) : super(name: 'GroupApi');

  Future<ApiResponse> createGroup({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.createGroup, data: req);
  }

  Future<ApiResponse> setGroupInfoEx({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.setGroupInfoEx, data: req);
  }

  Future<ApiResponse> joinGroup({
    required String groupID,
    String? reqMessage,
    int joinSource = 3,
    String? inviterUserID,
    String? ex,
  }) {
    return postIm(
      ImApiUrl.joinGroup,
      data: <String, dynamic>{
        'groupID': groupID,
        'reqMessage': reqMessage ?? '',
        'joinSource': joinSource,
        'inviterUserID': inviterUserID ?? '',
        'ex': ex ?? '',
      },
    );
  }

  Future<ApiResponse> quitGroup({required String userID, required String groupID}) {
    return postIm(
      ImApiUrl.quitGroup,
      data: <String, dynamic>{'userID': userID, 'groupID': groupID},
    );
  }

  Future<ApiResponse> getGroupsInfo({required List<String> groupIDs}) {
    return postIm(ImApiUrl.getGroupsInfo, data: <String, dynamic>{'groupIDs': groupIDs});
  }

  Future<ApiResponse> getGroupMemberList({
    required String groupID,
    int offset = 0,
    int count = 100,
    int filter = 0,
  }) {
    return postIm(
      ImApiUrl.getGroupMemberList,
      data: <String, dynamic>{
        'groupID': groupID,
        'filter': filter,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  Future<ApiResponse> getGroupMembersInfo({
    required String groupID,
    required List<String> userIDs,
  }) {
    return postIm(
      ImApiUrl.getGroupMembersInfo,
      data: <String, dynamic>{'groupID': groupID, 'userIDs': userIDs},
    );
  }

  Future<ApiResponse> inviteUserToGroup({
    required String groupID,
    required List<String> invitedUserIDs,
    String? reason,
  }) {
    return postIm(
      ImApiUrl.inviteUserToGroup,
      data: <String, dynamic>{
        'groupID': groupID,
        'invitedUserIDs': invitedUserIDs,
        'reason': reason ?? '',
      },
    );
  }

  Future<ApiResponse> getJoinedGroupList({
    required String fromUserID,
    int offset = 0,
    int count = 100,
  }) {
    return postIm(
      ImApiUrl.getJoinedGroupList,
      data: <String, dynamic>{
        'fromUserID': fromUserID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  Future<ApiResponse> getIncrementalJoinGroup({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.getIncrementalJoinGroup, data: req);
  }

  Future<ApiResponse> getFullJoinGroupIDs({required String userID}) {
    return postIm(ImApiUrl.getFullJoinGroupIDs, data: <String, dynamic>{'userID': userID});
  }

  Future<ApiResponse> kickGroupMember({
    required String groupID,
    required List<String> kickedUserIDs,
    String? reason,
  }) {
    return postIm(
      ImApiUrl.kickGroup,
      data: <String, dynamic>{
        'groupID': groupID,
        'kickedUserIDs': kickedUserIDs,
        'reason': reason ?? '',
      },
    );
  }

  Future<ApiResponse> transferGroup({
    required String groupID,
    required String oldOwnerUserID,
    required String newOwnerUserID,
  }) {
    return postIm(
      ImApiUrl.transferGroup,
      data: <String, dynamic>{
        'groupID': groupID,
        'oldOwnerUserID': oldOwnerUserID,
        'newOwnerUserID': newOwnerUserID,
      },
    );
  }

  Future<ApiResponse> getRecvGroupApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) {
    return postIm(
      ImApiUrl.getRecvGroupApplicationList,
      data: <String, dynamic>{
        'fromUserID': userID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  Future<ApiResponse> getSendGroupApplicationList({
    required String userID,
    int offset = 0,
    int count = 100,
  }) {
    return postIm(
      ImApiUrl.getSendGroupApplicationList,
      data: <String, dynamic>{
        'userID': userID,
        'pagination': buildPagination(offset: offset, count: count),
      },
    );
  }

  Future<ApiResponse> getGroupApplicationUnhandledCount({required String userID, int time = 0}) {
    return postIm(
      ImApiUrl.getGroupApplicationUnhandledCount,
      data: <String, dynamic>{'userID': userID, 'time': time},
    );
  }

  Future<ApiResponse> groupApplicationResponse({
    required String groupID,
    required String fromUserID,
    required String handledMsg,
    required int handleResult,
  }) {
    return postIm(
      ImApiUrl.groupApplicationResponse,
      data: <String, dynamic>{
        'groupID': groupID,
        'fromUserID': fromUserID,
        'handledMsg': handledMsg,
        'handleResult': handleResult,
      },
    );
  }

  Future<ApiResponse> dismissGroup({required String groupID}) {
    return postIm(ImApiUrl.dismissGroup, data: <String, dynamic>{'groupID': groupID});
  }

  Future<ApiResponse> muteGroupMember({
    required String groupID,
    required String userID,
    required int mutedSeconds,
  }) {
    return postIm(
      ImApiUrl.muteGroupMember,
      data: <String, dynamic>{'groupID': groupID, 'userID': userID, 'mutedSeconds': mutedSeconds},
    );
  }

  Future<ApiResponse> cancelMuteGroupMember({required String groupID, required String userID}) {
    return postIm(
      ImApiUrl.cancelMuteGroupMember,
      data: <String, dynamic>{'groupID': groupID, 'userID': userID},
    );
  }

  Future<ApiResponse> muteGroup({required String groupID}) {
    return postIm(ImApiUrl.muteGroup, data: <String, dynamic>{'groupID': groupID});
  }

  Future<ApiResponse> cancelMuteGroup({required String groupID}) {
    return postIm(ImApiUrl.cancelMuteGroup, data: <String, dynamic>{'groupID': groupID});
  }

  Future<ApiResponse> setGroupMemberInfo({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.setGroupMemberInfo, data: req);
  }
}
