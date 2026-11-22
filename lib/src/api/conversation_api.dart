import '../config/api_url.dart';
import '../core/base_api_client.dart';
import '../models/api_response.dart';

/// 会话配置与增量同步 API 客户端。
final class ConversationApi extends BaseApiClient {
  /// 创建 `ConversationApi` 实例。
  ///
  /// Creates a `ConversationApi` instance.
  ///
  /// - [httpClient] HTTP客户端 / HTTP client.
  ConversationApi({required super.httpClient}) : super(name: 'ConversationApi');

  /// 获取会话列表。
  ///
  /// Get conversations.
  ///
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [conversationIDs] 会话ID 列表 / Conversation i ds.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getConversations({
    required String ownerUserID,
    required List<String> conversationIDs,
  }) {
    return postIm(
      ImApiUrl.getConversations,
      data: <String, dynamic>{'ownerUserID': ownerUserID, 'conversationIDs': conversationIDs},
    );
  }

  /// 获取全部会话列表。
  ///
  /// Get all conversations.
  ///
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getAllConversations({required String ownerUserID}) {
    return postIm(
      ImApiUrl.getAllConversations,
      data: <String, dynamic>{'ownerUserID': ownerUserID},
    );
  }

  /// 设置会话列表。
  ///
  /// Set conversations.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> setConversations({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.setConversations, data: req);
  }

  /// 获取增量会话。
  ///
  /// Get incremental conversation.
  ///
  /// - [req] 请求参数 / Request.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getIncrementalConversation({required Map<String, dynamic> req}) {
    return postIm(ImApiUrl.getIncrementalConversation, data: req);
  }

  /// 获取全量会话ID 列表。
  ///
  /// Get full conversation i ds.
  ///
  /// - [userID] 用户ID / User ID.
  /// - Returns: `Future<ApiResponse>` 结果 / Resulting `Future<ApiResponse>`.
  Future<ApiResponse> getFullConversationIDs({required String userID}) {
    return postIm(ImApiUrl.getFullConversationIDs, data: <String, dynamic>{'userID': userID});
  }
}
