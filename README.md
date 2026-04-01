# OpenIM SDK for Dart/Flutter

**Version: 1.9.0**

A pure Dart implementation of the OpenIM client SDK, compatible with all Flutter platforms (iOS / Android / Web / macOS / Windows / Linux), providing complete instant messaging capabilities.

>
> **⚠️ 警告：**
>
>请注意：此 sdk 为个人使用编写，因此源代码没有开源，因为我对 openim 的 server 和 chat 进行了一些改变所以你在使用过程中有些方法是没有作用的，因为这些功能是需要后端的支持的。如需要可联系于我，但是你必须要遵守 openim 的开源许可。
>
>Please note: This SDK was written for personal use, therefore the source code is not open source. Because I made some changes to the OpenIM server and chat, some methods may not work, as these functions require backend support. Please contact me if needed, but you must comply with the OpenIM open source license.

> matkurban0102@gmail.com

## Features

- **Complete IM capabilities** — Message sending/receiving for one-to-one chat, group chat, and system notifications
- **24 message types** — Text, image, voice, video, file, contact card, location, custom message, and more
- **Conversation management** — Conversation list, pin, do-not-disturb, draft, unread count, read receipts
- **Group management** — Create/dismiss groups, invite/kick members, announcements, mute, role management
- **Friendship management** — Add/delete friends, friend requests, blocklist, friend remarks
- **User management** — User profile, online status subscription, client configuration
- **Real-time communication** — WebSocket long connection, heartbeat, auto-reconnect
- **Local storage** — ToStore-based local persistence with offline message support
- **File upload** — Multipart upload, instant upload by hash, progress callbacks
- **Push support** — FCM token management and app badge updates

## Quick Start

### Installation

Add dependency in `pubspec.yaml`:

```yaml
dependencies:
  openim_sdk: ^1.9.0
```

### Initialization

```dart
import 'package:openim_sdk/openim_sdk.dart';

// 1. Initialize SDK
await OpenIM.iMManager.initSDK(
  apiAddr: 'http://your-server:10002',
  wsAddr: 'ws://your-server:10001',
  chatAddr: 'http://your-server:10008',
  listener: OnConnectListener(
    onConnectSuccess: () => print('Connected successfully'),
    onConnecting: () => print('Connecting...'),
    onConnectFailed: (code, msg) => print('Connection failed: $code $msg'),
    onKickedOffline: () => print('Kicked offline'),
    onUserTokenExpired: () => print('Token expired'),
  ),
);
```

### Registration and Login

The SDK provides three login methods (email / phone / account) and a complete registration flow.

```dart
// ── Send verification code ──
await OpenIM.iMManager.userManager.sendVerificationCode(
  email: 'user@example.com',   // or phoneNumber + areaCode
  usedFor: 1,                  // 1-register  2-reset password  3-login
);

// ── Register ──
final authData = await OpenIM.iMManager.userManager.register(
  nickname: 'Zhang San',
  password: 'your_password',
  email: 'user@example.com',    // register by email
  // phoneNumber: '13800138000', areaCode: '+86',  // or by phone
  // account: 'zhangsan',       // or by account
  verificationCode: '123456',
  deviceID: 'your_device_id',
);

// ── Email login (password or verification code) ──
final userInfo = await OpenIM.iMManager.loginByEmail(
  email: 'user@example.com',
  password: 'your_password',         // password login
  // verificationCode: '123456',     // or verification-code login
);

// ── Phone login (password or verification code) ──
final userInfo = await OpenIM.iMManager.loginByPhone(
  areaCode: '+86',
  phoneNumber: '13800138000',
  password: 'your_password',         // password login
  // verificationCode: '123456',     // or verification-code login
);

// ── Account login (password only) ──
final userInfo = await OpenIM.iMManager.loginByAccount(
  account: 'zhangsan',
  password: 'your_password',
);

// ── Auto login (with cached token) ──
final loginStatus = await OpenIM.iMManager.loadLoginConfig();

// ── Logout ──
await OpenIM.iMManager.logout();
```

> **Note**: `loginByEmail` / `loginByPhone` / `loginByAccount` automatically completes Chat service authentication -> gets imToken -> SDK internal login -> WebSocket connection. Returning `UserInfo` indicates login success.

### Set Listeners

```dart
// Message listener
OpenIM.iMManager.messageManager.setAdvancedMsgListener(
  OnAdvancedMsgListener(
    onRecvNewMessage: (msg) {
      print('Received new message: ${msg.contentType} ${msg.textElem?.content}');
    },
    onNewRecvMessageRevoked: (info) {
      print('Message revoked: ${info.clientMsgID}');
    },
  ),
);

// Conversation listener
OpenIM.iMManager.conversationManager.setConversationListener(
  OnConversationListener(
    onConversationChanged: (list) {
      print('Conversations changed: ${list.length} items');
    },
    onTotalUnreadMessageCountChanged: (count) {
      print('Total unread: $count');
    },
  ),
);

// Friendship listener
OpenIM.iMManager.friendshipManager.setFriendshipListener(
  OnFriendshipListener(
    onFriendAdded: (info) => print('Friend added: ${info.nickname}'),
    onFriendDeleted: (info) => print('Friend deleted: ${info.userID}'),
  ),
);

// Group listener
OpenIM.iMManager.groupManager.setGroupListener(
  OnGroupListener(
    onGroupInfoChanged: (info) => print('Group info changed: ${info.groupName}'),
    onGroupMemberAdded: (member) => print('New member: ${member.nickname}'),
  ),
);
```

### Send Messages

```dart
// Send text
final msg = OpenIM.iMManager.messageManager.createTextMessage(text: 'Hello!');
await OpenIM.iMManager.messageManager.sendMessage(
  message: msg,
  userID: 'receiver_001',  // one-to-one chat
);

// Send image
final imgMsg = OpenIM.iMManager.messageManager.createImageMessageByURL(
  sourcePath: '/path/to/image.jpg',
  sourcePicture: PictureInfo(url: 'https://...', width: 800, height: 600),
  bigPicture: PictureInfo(url: 'https://...', width: 800, height: 600),
  snapshotPicture: PictureInfo(url: 'https://...', width: 200, height: 150),
);
await OpenIM.iMManager.messageManager.sendMessage(
  message: imgMsg,
  groupID: 'group_001',  // group chat
);

// Send @ message
final atMsg = OpenIM.iMManager.messageManager.createTextAtMessage(
  text: '@ZhangSan Meeting time',
  atUserIDList: ['user_zhangsan'],
  atUserInfoList: [AtUserInfo(atUserID: 'user_zhangsan', groupNickname: 'ZhangSan')],
);
```

### Conversation Operations

```dart
// Get conversation list
final conversations = await OpenIM.iMManager.conversationManager.getAllConversationList();

// Mark conversation as read
await OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
  conversationID: 'si_user001_user002',
);

// Mark messages as read by message IDs
await OpenIM.iMManager.conversationManager.markMessagesAsReadByMsgID(
  conversationID: 'si_user001_user002',
  clientMsgIDs: ['msg_001', 'msg_002'],
);

// Get history messages
final history = await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
  conversationID: 'si_user001_user002',
  count: 20,
);
```

### Group Operations

```dart
// Create group
final groupInfo = await OpenIM.iMManager.groupManager.createGroup(
  groupName: 'Tech Discussion Group',
  memberUserIDs: ['user_002', 'user_003'],
);

// Get joined groups
final groups = await OpenIM.iMManager.groupManager.getJoinedGroupList();

// Check whether users are in group
final usersInGroup = await OpenIM.iMManager.groupManager.getUsersInGroup(
  groupID: 'group_001',
  userIDList: ['user_002', 'user_003'],
);
```

### Friendship Operations

```dart
// Add friend
await OpenIM.iMManager.friendshipManager.addFriend(userID: 'user_002', reqMsg: 'Hi');

// Get friend list
final friends = await OpenIM.iMManager.friendshipManager.getFriendList();

// Search friends
final results = await OpenIM.iMManager.friendshipManager.searchFriends(
  keywordList: ['Zhang San'],
  isSearchNickname: true,
);
```

## API Reference

### Core Managers

| Manager               | Access Path                            | Description                                                                     |
|-----------------------|----------------------------------------|---------------------------------------------------------------------------------|
| `IMManager`           | `OpenIM.iMManager`                     | SDK initialization, login/logout, file upload                                   |
| `ConversationManager` | `OpenIM.iMManager.conversationManager` | Conversation list and state management                                          |
| `MessageManager`      | `OpenIM.iMManager.messageManager`      | Message creation, sending, query                                                |
| `GroupManager`        | `OpenIM.iMManager.groupManager`        | Group and member management                                                     |
| `FriendshipManager`   | `OpenIM.iMManager.friendshipManager`   | Friendship and blocklist management                                             |
| `UserManager`         | `OpenIM.iMManager.userManager`         | User info, online status, registration, verification code, chat user management |
| `MomentsManager`      | `OpenIM.iMManager.momentsManager`      | Moments feed, likes, comments                                                   |
| `FavoriteManager`     | `OpenIM.iMManager.favoriteManager`     | Favorites management                                                            |
| `CallManager`         | `OpenIM.iMManager.callManager`         | Audio/video call invite, accept, reject, cancel, hangup                         |
| `RedPacketManager`    | `OpenIM.iMManager.redPacketManager`    | Red packet send/grab, points balance and transactions                           |

### Listeners

| Listener                    | Description                                        |
|-----------------------------|----------------------------------------------------|
| `OnConnectListener`         | Connection status callbacks                        |
| `OnAdvancedMsgListener`     | New messages, revoke, read receipts                |
| `OnConversationListener`    | Conversation changes, unread count, sync status    |
| `OnFriendshipListener`      | Friendship add/remove, requests, blocklist changes |
| `OnGroupListener`           | Group changes, member join/leave, applications     |
| `OnUserListener`            | User info updates                                  |
| `OnMsgSendProgressListener` | Message sending progress                           |
| `OnUploadFileListener`      | File upload progress                               |
| `OnCustomBusinessListener`  | Custom business messages                           |
| `OnListenerForService`      | Background service listener                        |
| `OnMomentsListener`         | Moments feed changes                               |
| `OnFavoriteListener`        | Favorites changes                                  |
| `OnCallListener`            | Call invite/accept/reject/cancel/hangup events     |
| `OnRedPacketListener`       | Red packet expired, points balance changed         |

### Supported Message Types

| Type          | ContentType | Creation Method                                  |
|---------------|-------------|--------------------------------------------------|
| Text          | 101         | `createTextMessage`                              |
| Image         | 102         | `createImageMessage` / `createImageMessageByURL` |
| Voice         | 103         | `createSoundMessage` / `createSoundMessageByURL` |
| Video         | 104         | `createVideoMessage` / `createVideoMessageByURL` |
| File          | 105         | `createFileMessage` / `createFileMessageByURL`   |
| @Text         | 106         | `createTextAtMessage`                            |
| Merged        | 107         | `createMergerMessage`                            |
| Card          | 108         | `createCardMessage`                              |
| Location      | 109         | `createLocationMessage`                          |
| Custom        | 110         | `createCustomMessage`                            |
| Quote         | 114         | `createQuoteMessage`                             |
| Emoji         | 115         | `createFaceMessage`                              |
| Advanced text | 117         | `createAdvancedTextMessage`                      |
| Forward       | —           | `createForwardMessage`                           |

## Platform Support

| Platform | Support |
|----------|---------|
| Android  | ✅       |
| iOS      | ✅       |
| Web      | ✅       |
| macOS    | ✅       |
| Windows  | ✅       |
| Linux    | ✅       |

## Background Isolate (New in 1.9.0)

All SDK Future methods (~160 methods across 10 managers) can now run in a dedicated background Isolate, keeping the UI thread completely free from database I/O, network serialization, and protobuf parsing.

- **Transparent** — All existing API calls work unchanged; the Isolate boundary is handled internally
- **Optional** — Omit `SdkIsolateManager.initialize()` to run entirely on the main thread as before
- **Listener forwarding** — All listener callbacks are serialized across the Isolate boundary and re-dispatched on the main thread

## Requirements

- Dart SDK: `^3.10.0`
- Flutter: 3.x+ (when used in Flutter)

## License

See the [LICENSE](LICENSE) file.
