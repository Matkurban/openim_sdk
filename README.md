# OpenIM SDK for Dart/Flutter

纯 Dart 实现的 OpenIM 客户端 SDK，兼容 Flutter 全平台（iOS / Android / Web / macOS / Windows / Linux），提供完整的即时通讯能力。

## 功能特性

- **完整的即时通讯能力** — 单聊、群聊、系统通知等消息收发
- **24 种消息类型** — 文本、图片、语音、视频、文件、名片、位置、自定义消息等
- **会话管理** — 会话列表、置顶、免打扰、草稿、未读数、已读回执
- **群组管理** — 创建/解散群、邀请/踢出成员、群公告、禁言、角色管理
- **好友管理** — 添加/删除好友、好友申请、黑名单、好友备注
- **用户管理** — 用户资料、在线状态订阅、客户端配置
- **实时通信** — WebSocket 长连接、心跳保活、断线重连
- **本地存储** — 基于 ToStore 的本地持久化，支持离线消息
- **文件上传** — 分片上传、秒传、进度回调
- **推送支持** — FCM Token 管理、App 角标设置

## 快速开始

### 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  openim_sdk: ^1.0.0
```

### 初始化

```dart
import 'package:openim_sdk/openim_sdk.dart';

// 1. 初始化 SDK
await OpenIM.iMManager.initSDK(
  apiAddr: 'http://your-server:10002',
  wsAddr: 'ws://your-server:10001',
  chatAddr: 'http://your-server:10008',
  listener: OnConnectListener(
    onConnectSuccess: () => print('连接成功'),
    onConnecting: () => print('连接中...'),
    onConnectFailed: (code, msg) => print('连接失败: $code $msg'),
    onKickedOffline: () => print('被踢下线'),
    onUserTokenExpired: () => print('Token 过期'),
  ),
);
```

### 注册与登录

SDK 提供三种登录方式（邮箱 / 手机号 / 账号）和完整的注册流程。

```dart
// ── 发送验证码 ──
await OpenIM.iMManager.userManager.sendVerificationCode(
  email: 'user@example.com',   // 或 phoneNumber + areaCode
  usedFor: 1,                   // 1-注册  2-重置密码  3-登录
);

// ── 注册 ──
final authData = await OpenIM.iMManager.userManager.register(
  nickname: '张三',
  password: 'your_password',
  email: 'user@example.com',    // 邮箱注册
  // phoneNumber: '13800138000', areaCode: '+86',  // 或手机号注册
  // account: 'zhangsan',       // 或账号注册
  verificationCode: '123456',
  deviceID: 'your_device_id',
);

// ── 邮箱登录（密码或验证码二选一）──
final userInfo = await OpenIM.iMManager.loginByEmail(
  email: 'user@example.com',
  password: 'your_password',         // 密码登录
  // verificationCode: '123456',     // 或验证码登录
);

// ── 手机号登录（密码或验证码二选一）──
final userInfo = await OpenIM.iMManager.loginByPhone(
  areaCode: '+86',
  phoneNumber: '13800138000',
  password: 'your_password',         // 密码登录
  // verificationCode: '123456',     // 或验证码登录
);

// ── 账号登录（仅密码）──
final userInfo = await OpenIM.iMManager.loginByAccount(
  account: 'zhangsan',
  password: 'your_password',
);

// ── 自动登录（使用缓存的 token）──
final loginStatus = await OpenIM.iMManager.loadLoginConfig();

// ── 登出 ──
await OpenIM.iMManager.logout();
```

> **说明**：`loginByEmail` / `loginByPhone` / `loginByAccount` 会自动完成 Chat 服务端认证 → 获取 imToken → SDK 内部 login → WebSocket 连接，返回 `UserInfo` 即表示登录成功。

### 设置监听器

```dart
// 消息监听
OpenIM.iMManager.messageManager.setAdvancedMsgListener(
  OnAdvancedMsgListener(
    onRecvNewMessage: (msg) {
      print('收到新消息: ${msg.contentType} ${msg.textElem?.content}');
    },
    onNewRecvMessageRevoked: (info) {
      print('消息被撤回: ${info.clientMsgID}');
    },
  ),
);

// 会话监听
OpenIM.iMManager.conversationManager.setConversationListener(
  OnConversationListener(
    onConversationChanged: (list) {
      print('会话变更: ${list.length} 个');
    },
    onTotalUnreadMessageCountChanged: (count) {
      print('未读总数: $count');
    },
  ),
);

// 好友监听
OpenIM.iMManager.friendshipManager.setFriendshipListener(
  OnFriendshipListener(
    onFriendAdded: (info) => print('新增好友: ${info.nickname}'),
    onFriendDeleted: (info) => print('好友已删除: ${info.userID}'),
  ),
);

// 群组监听
OpenIM.iMManager.groupManager.setGroupListener(
  OnGroupListener(
    onGroupInfoChanged: (info) => print('群信息变更: ${info.groupName}'),
    onGroupMemberAdded: (member) => print('新成员: ${member.nickname}'),
  ),
);
```

### 发送消息

```dart
// 发送文本
final msg = OpenIM.iMManager.messageManager.createTextMessage(text: '你好!');
await OpenIM.iMManager.messageManager.sendMessage(
  message: msg,
  userID: 'receiver_001',  // 单聊
);

// 发送图片
final imgMsg = OpenIM.iMManager.messageManager.createImageMessageByURL(
  sourcePath: '/path/to/image.jpg',
  sourcePicture: PictureInfo(url: 'https://...', width: 800, height: 600),
  bigPicture: PictureInfo(url: 'https://...', width: 800, height: 600),
  snapshotPicture: PictureInfo(url: 'https://...', width: 200, height: 150),
);
await OpenIM.iMManager.messageManager.sendMessage(
  message: imgMsg,
  groupID: 'group_001',  // 群聊
);

// 发送 @消息
final atMsg = OpenIM.iMManager.messageManager.createTextAtMessage(
  text: '@张三 开会了',
  atUserIDList: ['user_zhangsan'],
  atUserInfoList: [AtUserInfo(atUserID: 'user_zhangsan', groupNickname: '张三')],
);
```

### 会话操作

```dart
// 获取会话列表
final conversations = await OpenIM.iMManager.conversationManager.getAllConversationList();

// 标记已读
await OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
  conversationID: 'si_user001_user002',
);

// 按消息 ID 标记已读
await OpenIM.iMManager.conversationManager.markMessagesAsReadByMsgID(
  conversationID: 'si_user001_user002',
  clientMsgIDs: ['msg_001', 'msg_002'],
);

// 获取历史消息
final history = await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
  conversationID: 'si_user001_user002',
  count: 20,
);
```

### 群组操作

```dart
// 创建群组
final groupInfo = await OpenIM.iMManager.groupManager.createGroup(
  groupName: '技术讨论组',
  memberUserIDs: ['user_002', 'user_003'],
);

// 获取已加入的群列表
final groups = await OpenIM.iMManager.groupManager.getJoinedGroupList();

// 检查用户是否在群内
final usersInGroup = await OpenIM.iMManager.groupManager.getUsersInGroup(
  groupID: 'group_001',
  userIDList: ['user_002', 'user_003'],
);
```

### 好友操作

```dart
// 添加好友
await OpenIM.iMManager.friendshipManager.addFriend(userID: 'user_002', reqMsg: '你好');

// 获取好友列表
final friends = await OpenIM.iMManager.friendshipManager.getFriendList();

// 搜索好友
final results = await OpenIM.iMManager.friendshipManager.searchFriends(
  keywordList: ['张三'],
  isSearchNickname: true,
);
```

## API 参考

### 核心管理器

| 管理器 | 访问方式 | 说明 |
|--------|---------|------|
| `IMManager` | `OpenIM.iMManager` | SDK 初始化、登录登出、文件上传 |
| `ConversationManager` | `OpenIM.iMManager.conversationManager` | 会话列表与状态管理 |
| `MessageManager` | `OpenIM.iMManager.messageManager` | 消息创建、发送、查询 |
| `GroupManager` | `OpenIM.iMManager.groupManager` | 群组与群成员管理 |
| `FriendshipManager` | `OpenIM.iMManager.friendshipManager` | 好友与黑名单管理 |
| `UserManager` | `OpenIM.iMManager.userManager` | 用户信息、在线状态、注册、验证码、Chat 用户管理 |
| `MomentsManager` | `OpenIM.iMManager.momentsManager` | 朋友圈动态、点赞、评论 |
| `FavoriteManager` | `OpenIM.iMManager.favoriteManager` | 收藏夹管理 |

### 监听器

| 监听器 | 说明 |
|--------|------|
| `OnConnectListener` | 连接状态回调 |
| `OnAdvancedMsgListener` | 新消息、撤回、已读回执 |
| `OnConversationListener` | 会话变更、未读数、同步状态 |
| `OnFriendshipListener` | 好友增删、申请、黑名单变更 |
| `OnGroupListener` | 群信息变更、成员进出、申请 |
| `OnUserListener` | 用户信息变更 |
| `OnMsgSendProgressListener` | 消息发送进度 |
| `OnUploadFileListener` | 文件上传进度 |
| `OnCustomBusinessListener` | 自定义业务消息 |
| `OnListenerForService` | 后台服务监听 |

### 支持的消息类型

| 类型 | ContentType | 创建方法 |
|------|-------------|---------|
| 文本 | 101 | `createTextMessage` |
| 图片 | 102 | `createImageMessage` / `createImageMessageByURL` |
| 语音 | 103 | `createSoundMessage` / `createSoundMessageByURL` |
| 视频 | 104 | `createVideoMessage` / `createVideoMessageByURL` |
| 文件 | 105 | `createFileMessage` / `createFileMessageByURL` |
| @文本 | 106 | `createTextAtMessage` |
| 合并 | 107 | `createMergerMessage` |
| 名片 | 108 | `createCardMessage` |
| 位置 | 109 | `createLocationMessage` |
| 自定义 | 110 | `createCustomMessage` |
| 引用 | 114 | `createQuoteMessage` |
| 表情 | 115 | `createFaceMessage` |
| 高级文本 | 117 | `createAdvancedTextMessage` |
| 转发 | — | `createForwardMessage` |

## 平台支持

| 平台 | 支持 |
|------|------|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| macOS | ✅ |
| Windows | ✅ |
| Linux | ✅ |

## 环境要求

- Dart SDK: `^3.10.0`
- Flutter: 3.x+（使用 Flutter 时）

## 许可证

见 [LICENSE](LICENSE) 文件。
