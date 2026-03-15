# Changelog

## 1.1.7

### 修复

- **修复朋友圈 API 使用错误的 Token**：`MomentsManager` 的 `_post` 方法从 `HttpClient().token`（imToken）改为 `HttpClient().chatToken`（chatToken），修正请求 chat 服务端时携带错误 token 导致 API 调用失败的问题

## 1.1.6

### 修复

- **修复朋友圈首次加载为空**：`getMomentList()` 本地无数据时现在直接走网络请求返回，而非返回空列表后后台静默缓存

## 1.1.5

### 新增

- **`loginByAccount()`**：新增账号密码登录方式，支持通过 `account` + `password` 登录（后端原生支持 `CredentialAccount` 类型凭据）

## 1.1.4

### 新增

- **`UserManager.register()`**：注册账号（chat 服务端），支持邮箱或手机号注册，返回 `AuthCacheData?`
- **`UserManager.sendVerificationCode()`**：发送验证码（chat 服务端），支持注册、重置密码、登录三种用途

### 优化

- **`loginByEmail` / `loginByPhone` 支持密码或验证码二选一**：`password` 和 `verificationCode` 均改为可选参数，提供其中一个即可登录

### 修复

- **修复 `register()` API 使用错误的 Dio 实例**：`ImApiService.register()` 从 `HttpClient().post()`（IM API）改为 `HttpClient().chatPost()`（Chat API），修正请求发往错误服务端的问题

## 1.1.3

### 修复

- **修复 Web 端退出登录后重新登录卡死**：`logout()` 不再关闭数据库，避免 Web (IndexedDB) 上对已关闭实例操作静默挂起
- **修复 WebSocket 重连标志未重置**：`connect()` 中重置 `_isReconnecting`，防止退出时处于重连状态导致重新登录后无法重连

## 1.1.2

### 新增

- **新增 `LinkInfo` 模型**：链接数据结构（`url`、`title`、`description`、`imageUrl`）
- **`FavoriteItem` 新增 `linkInfo` 属性**：当 `favoriteType == .link` 时自动解析
- **`FavoriteItem.fromLink()` 工厂方法**：快速创建链接收藏
- **`FavoriteManager.addLink()` / `removeLink()`** 便捷方法

### 优化

- **`NoteInfo` 属性改为非空**：`noteID`、`summary`、`content`、`createdAt` 现为 `String`（非 `String?`）
- **`FavoriteType` 枚举补充注释**：每个值添加中文说明

## 1.1.1

### 重构

- **`FavoriteType` 改为枚举类型**（破坏性变更）
  - 从 `sealed class` 字符串常量改为 `enum FavoriteType`，通过 `.value` 获取字符串值
  - 新增 `FavoriteType.fromValue(String?)` 静态方法

- **`FavoriteItem` 增加类型化内容属性**
  - `targetType` 字段替换为 `favoriteType`（`FavoriteType` 枚举），保留 `targetType` getter 兼容
  - 新增可空属性：`message`、`momentInfo`、`momentComment`、`noteInfo`，根据 `favoriteType` 自动从 `data` JSON 解析
  - 新增快速创建工厂：`FavoriteItem.fromMessage()`、`FavoriteItem.fromMoment()`、`FavoriteItem.fromMomentComment()`、`FavoriteItem.fromNote()`

### 新增

- **新增 `NoteInfo` 模型**：笔记数据结构（`noteID`、`summary`、`content`、`createdAt`）
- **`FavoriteManager` 新增辅助方法**
  - `isMessageFavorited(clientMsgID)` — 判断消息是否已收藏
  - `isMomentFavorited(momentID)` — 判断朝友圈动态是否已收藏
  - `addMessage(message:)` 简化为直接传入 `Message` 对象
  - `addMoment(moment:)` 直接传入 `MomentInfo` 对象
  - `addMomentComment(comment:)` 直接传入 `MomentCommentWithUser` 对象
  - `removeMoment(momentID:)` / `removeMomentComment(commentID:)` 便捷删除

## 1.1.0

### 新增

- **新增 `isInitialized` 属性**：用于判断 SDK 是否已完成初始化（`initSDK` 是否已成功调用）

## 1.0.9

### Bug 修复

- **修复会话列表出现自己与自己的会话**
  - 服务端可能创建登录用户自己的单聊会话，同步时现在跳过 `conversationType == 1 && userID == loginUserID` 的会话
  - 登录同步时自动清理本地已存在的自我会话记录

## 1.0.8

### 新增

- **新增 `OpenIMException` 异常类**
  - 消息发送失败（如 errCode=1303 不是好友）时，`sendMessage` 现在抛出 `OpenIMException` 而非静默返回失败消息，前端可通过 `try-catch` 捕获并处理
  - `OpenIMException` 携带服务端返回的 `code` 和 `message`，提供 `sdkErrorCode` getter 可直接匹配 `SDKErrorCode` 枚举

## 1.0.7

### Bug 修复

- **修复 `getGroupMemberList` 返回空列表的问题**
  - 根本原因：登录同步仅同步群组信息，从未同步群成员数据。`getGroupMemberList` 读取本地数据库，但成员只在本地 `createGroup` / `inviteUserToGroup` 时写入，对于已存在的群或其他途径加入的群，本地数据库中没有成员记录
  - 修复：`_syncJoinedGroups`（登录同步 + 通知触发）现在会为每个已加入群组分页拉取全部成员并写入本地数据库（对齐 Go SDK `SyncAllJoinedGroupsAndMembersWithLock` → `IncrSyncJoinGroupMember` 行为）
- **群成员实时通知现在同步写入本地数据库**
  - `memberQuit` (1504) / `memberKicked` (1508)：从本地数据库删除对应成员
  - `memberInvited` (1509) / `memberEnter` (1510)：将新成员写入本地数据库
  - `groupMemberInfoSet` (1516) / `groupMemberMuted` (1512) / `groupMemberSetToAdmin` (1517) 等：更新本地成员信息
  - `groupDismissed` (1511)：清除该群所有本地成员记录

## 1.0.6

### Bug 修复

- **修复初始同步后会话 `latestMsg` 始终为 null 的问题**
  - 对齐 Go SDK `doMsgSyncByReinstalled` 行为：拉取到的消息无论是普通消息还是通知消息，都会参与 `latestMsg` 计算。之前仅普通消息（contentType < 1000）可作为 `latestMsg`，导致会话列表最新消息为空
  - `_processPulledMsgs` 中的通知消息（contentType >= 1000）现已正确路由到 `NotificationDispatcher`，与推送路径保持一致（对齐 Go SDK `triggerNotification`）
  - 新增 `_processPulledNotifications` 方法单独处理 `notificationMsgs` 响应字段（对齐 Go SDK `triggerNotification` 对 `resp.NotificationMsgs` 的处理）
  - 消息同步完成后触发 `conversationChanged` 回调，确保 UI 能获取到最新的 `latestMsg`
- **重装同步优化**：首次安装时跳过 `n_` 通知会话的消息拉取（对齐 Go SDK `compareSeqsAndBatchSync` 中重装分支的行为）
- **缺口同步修复**：`_syncMissingMessages` 不再传递 `num: 0`，改为不限制拉取条数；同步完成后触发会话变更回调
- **类型安全**：`_processPulledMsgs` 中所有 `as int?` 改为 `(as num?)?.toInt()`

## 1.0.5

### Bug 修复

- **修复单个会话未读数始终为 0 的问题**
  - `_syncConversationsAndSeqs` 中 `maxSeq`/`hasReadSeq` 使用 `as int?` 强制转型，若服务端返回 `num`（如 `double`）会导致整个同步方法异常退出，未读数永远无法写入本地数据库；改用 `(as num?)?.toInt()` 安全转换
  - 初始同步完成后缺少 `conversationChanged` 与 `totalUnreadMessageCountChanged` 回调，导致 UI 无法获取到已计算的未读数；现已在写入数据库后触发对应回调（对齐 Go SDK `doUpdateConversation` 行为）
  - `clearAllUnreadCounts()` 缺少 `.allowUpdateAll()`，ToStore 的 `updateInternal` 在无 where 条件时会静默拒绝执行，导致「标记全部已读」实际无效
- **全局类型安全加固**：`_convertConversation`、`getTotalUnreadCount`、`decrConversationUnreadCount`、`getConversationMaxSeq`、`getAllConversationMaxSeqs` 中所有 `as int?` 统一改为 `(as num?)?.toInt()`，避免数据库/JSON 返回 `double` 时崩溃

## 1.0.4

- 修复已知问题

## 1.0.3

- 修复已知问题

## 1.0.2

- 导出 `OpenImUtils` 类

## 1.0.1

- 纠正 MessageType 中 跟原 sdk 命名不一致的变量


## 1.0.0

纯 Dart 实现的 OpenIM SDK 首个正式版，对齐 Go SDK (openim-sdk-core v3.8.0) 核心功能。

### 核心架构

- 基于 WebSocket 的长连接通信，支持 protobuf 编解码、心跳保活、断线自动重连
- 基于 ToStore 的本地数据持久化，按用户隔离存储空间
- GetIt 依赖注入管理服务生命周期
- HTTP REST API 层对接 openim-server 全部接口
- 通知分发器统一处理服务端推送（好友/群组/用户变更）
- 消息同步器处理增量消息拉取与去重

### IMManager — SDK 管理

- `initSDK` / `unInitSDK` — SDK 初始化与销毁
- `login` / `logout` — 用户登录登出，支持自动登录恢复
- `uploadFile` — 分片文件上传（2MB 分片、MD5 秒传、进度回调）
- `getSdkVersion` — 获取 SDK 版本号
- `setAppBackgroundStatus` — 前后台状态切换，通过 WebSocket 通知服务端
- `networkStatusChanged` — 网络状态变更触发重连
- `updateFcmToken` — 更新 FCM 推送 Token
- `setAppBadge` — 设置 App 角标未读数
- Token 过期/无效/踢下线的全局错误拦截与回调

### ConversationManager — 会话管理

- 会话获取：`getAllConversationList`、`getConversationListSplit`（分页）、`getOneConversation`、`getMultipleConversation`
- 会话操作：`pinConversation`（置顶）、`setConversationDraft`（草稿）、`hideConversation`、`setConversation`（免打扰/置顶/私聊阅后即焚等）
- 已读处理：`markConversationMessageAsRead`（会话维度）、`markMessagesAsReadByMsgID`（消息维度）、`markAllConversationMessageAsRead`
- 输入状态：`changeInputStates` / `getInputStates`（对端正在输入通知）
- 清理删除：`deleteConversationAndDeleteAllMsg`、`clearConversationAndDeleteAllMsg`
- 搜索：`searchConversations`
- 未读统计：`getTotalUnreadMsgCount`

### MessageManager — 消息管理

- 24 种消息创建方法：文本、图片、语音、视频、文件、@文本、合并、转发、名片、位置、自定义、引用、表情、高级文本及 URL 变体
- 消息发送：`sendMessage` / `sendMessageNotOss`
- 历史消息：`getAdvancedHistoryMessageList`（正序/倒序）、`findMessageList`（按 ID 精确查找）
- 消息搜索：`searchLocalMessages`（按关键词/类型/时间/会话搜索）
- 消息操作：`revokeMessage`（撤回）、`deleteMessageFromLocalStorage`、`deleteMessageFromLocalAndSvr`、`deleteAllMsgFromLocalAndSvr`
- 本地插入：`insertSingleMessageToLocalStorage`、`insertGroupMessageToLocalStorage`

### GroupManager — 群组管理

- 群组 CRUD：`createGroup`、`setGroupInfo`、`dismissGroup`、`getGroupsInfo`
- 群列表：`getJoinedGroupList`、`getJoinedGroupListPage`、`searchGroups`
- 成员管理：`inviteUserToGroup`、`kickGroupMember`、`transferGroupOwner`、`setGroupMemberInfo`
- 成员查询：`getGroupMemberList`、`getGroupMembersInfo`、`getGroupOwnerAndAdmin`、`searchGroupMembers`、`getGroupMemberListByJoinTime`、`getUsersInGroup`
- 禁言：`changeGroupMute`（全员禁言）、`changeGroupMemberMute`（单人禁言）
- 入群：`joinGroup`、`quitGroup`
- 入群审批：`getGroupApplicationListAsRecipient`、`getGroupApplicationListAsApplicant`、`acceptGroupApplication`、`refuseGroupApplication`、`getGroupApplicationUnhandledCount`

### FriendshipManager — 好友关系

- 好友操作：`addFriend`、`deleteFriend`、`updateFriends`（批量更新备注/扩展）
- 好友查询：`getFriendsInfo`、`getFriendList`、`getFriendListPage`、`searchFriends`、`checkFriend`
- 好友申请：`getFriendApplicationListAsRecipient`、`getFriendApplicationListAsApplicant`、`acceptFriendApplication`、`refuseFriendApplication`、`getFriendApplicationUnhandledCount`
- 黑名单：`addBlacklist`、`getBlacklist`、`removeBlacklist`

### UserManager — 用户管理

- 便捷登录：`loginByEmail`、`loginByPhone`（通过 Chat 服务端）
- 用户信息：`getUsersInfo`（带本地缓存）、`getUsersInfoWithCache`、`getUsersInfoFromSrv`、`getSelfUserInfo`、`setSelfInfo`
- 在线状态：`subscribeUsersStatus`、`unsubscribeUsersStatus`、`getSubscribeUsersStatus`、`getUserStatus`
- 客户端配置：`getUserClientConfig`

### 监听器（10 个）

- `OnConnectListener` — 连接成功/失败/重连/被踢下线/Token 过期
- `OnAdvancedMsgListener` — 新消息/撤回/已读回执/离线消息/在线消息
- `OnConversationListener` — 会话变更/新建/未读数/同步状态/输入状态
- `OnFriendshipListener` — 好友增删/申请/拒绝/黑名单/备注变更
- `OnGroupListener` — 群信息/成员增删/角色/禁言/申请/解散
- `OnUserListener` — 用户信息变更/在线状态变更
- `OnMsgSendProgressListener` — 消息发送进度
- `OnUploadFileListener` — 文件上传全流程进度
- `OnCustomBusinessListener` — 自定义业务消息
- `OnListenerForService` — 后台推送服务监听

### 性能优化

- 枚举 O(1) 静态 Map 查找替代线性遍历
- 批量数据库查询（`whereIn` / `batchUpsert`）替代 N+1 查询
- Timer 资源在 `logout` / `dispose` 时统一清理
- 会话 maxSeq 懒加载，仅在真正需要时查询
- 登录流程中独立操作并行执行
- 好友/黑名单列表使用 Set O(1) 排除已有数据

### 数据模型

- `Message` — 消息（24 种 contentType）
- `ConversationInfo` — 会话
- `UserInfo` / `FriendInfo` / `BlacklistInfo` / `UserStatusInfo` — 用户相关
- `GroupInfo` / `GroupMembersInfo` / `GroupApplicationInfo` — 群组相关
- `FriendApplicationInfo` — 好友申请
- `NotificationInfo` / `SearchInfo` / `InputStatusChangedData` — 辅助模型

### 枚举（17 个）

- `MessageType`、`MessageStatus`、`ConversationType`、`LoginStatus`、`GroupType`、`GroupRoleLevel`、`GroupStatus`、`GroupVerification`、`GroupMemberFilter`、`GroupAtType`、`AllowType`、`JoinSource`、`Relationship`、`ReceiveMessageOpt`、`IMPlatform`、`SDKErrorCode`、`WebSocketStatus`
