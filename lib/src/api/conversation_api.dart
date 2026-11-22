import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 会话配置与增量同步 API 客户端。
final class ConversationApi extends BaseApiClient {
  ConversationApi({required super.httpClient}) : super(name: 'ConversationApi');

  Future<ApiResponse> getConversations({
    required String ownerUserID,
    required List<String> conversationIDs,
  }) {
    return postIm(
      ImApiUrl.getConversations,
      data: <String, dynamic>{'ownerUserID': ownerUserID, 'conversationIDs': conversationIDs},
    );
  }

  Future<ApiResponse> getAllConversations({required String ownerUserID}) {
    return postIm(
      ImApiUrl.getAllConversations,
      data: <String, dynamic>{'ownerUserID': ownerUserID},
    );
  }

  Future<ApiResponse> setConversations({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.setConversations, data: req);
  }

  Future<ApiResponse> getIncrementalConversation({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.getIncrementalConversation, data: req);
  }

  Future<ApiResponse> getFullConversationIDs({required String userID}) {
    return postIm(ImApiUrl.getFullConversationIDs, data: <String, dynamic>{'userID': userID});
  }
}
