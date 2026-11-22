import '../network/http_client.dart';
import 'auth_api.dart';
import 'conversation_api.dart';
import 'friend_api.dart';
import 'governance_api.dart';
import 'group_api.dart';
import 'message_api.dart';
import 'object_storage_api.dart';
import 'user_api.dart';

/// 聚合所有领域 API 客户端的统一容器，替代原 1,705 行单文件 `ImApiService`。
class SdkApis {
  /// HTTP客户端。
  ///
  /// HTTP client.
  final HttpClient httpClient;

  /// 认证。
  ///
  /// Authentication.
  final AuthApi auth;

  /// 用户。
  ///
  /// User.
  final UserApi user;

  /// 好友。
  ///
  /// Friend.
  final FriendApi friend;

  /// 群组。
  ///
  /// Group.
  final GroupApi group;

  /// 消息。
  ///
  /// Message.
  final MessageApi message;

  /// 会话。
  ///
  /// Conversation.
  final ConversationApi conversation;

  /// 对象存储。
  ///
  /// Object storage.
  final ObjectStorageApi objectStorage;

  /// 治理/举报申诉。
  ///
  /// Governance.
  final GovernanceApi governance;

  /// 创建 `SdkApis` 实例。
  ///
  /// Creates a `SdkApis` instance.
  ///
  /// - [httpClient] HTTP客户端 / HTTP client.
  SdkApis({required this.httpClient})
    : auth = AuthApi(httpClient: httpClient),
      user = UserApi(httpClient: httpClient),
      friend = FriendApi(httpClient: httpClient),
      group = GroupApi(httpClient: httpClient),
      message = MessageApi(httpClient: httpClient),
      conversation = ConversationApi(httpClient: httpClient),
      objectStorage = ObjectStorageApi(httpClient: httpClient),
      governance = GovernanceApi(httpClient: httpClient);
}
