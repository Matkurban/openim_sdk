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
  final HttpClient httpClient;
  final AuthApi auth;
  final UserApi user;
  final FriendApi friend;
  final GroupApi group;
  final MessageApi message;
  final ConversationApi conversation;
  final ObjectStorageApi objectStorage;
  final GovernanceApi governance;

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
