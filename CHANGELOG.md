# Changelog

## [2.0.1](https://github.com/Matkurban/openim_sdk/compare/v2.0.0...v2.0.1) (2026-04-08)


### Bug Fixes

* 修复文档发布 2.0.0版本 ([8536303](https://github.com/Matkurban/openim_sdk/commit/8536303d5f24ffd45150b4450eec12793dcadbfd))

## [2.0.0](https://github.com/Matkurban/openim_sdk/compare/v1.0.0...v2.0.0) (2026-04-08)


### ⚠ BREAKING CHANGES

* 修复文档发布 2.0.0版本呢

### Features

* 修复文档发布 2.0.0版本呢 ([21f1144](https://github.com/Matkurban/openim_sdk/commit/21f1144486087ffcdca0a6cf2dbc1680e31a59f0))

## 1.9.1

- add `updateNote` method in `FavoriteManager` to update note content and refresh favorite item.

## 1.9.0

### 🚀 Background Isolate Architecture

All SDK Future methods (~160 methods across 10 managers) now run in a dedicated background Isolate, keeping the UI thread completely free from database I/O, network serialization, and protobuf parsing.

- **New Isolate infrastructure** — Added 4 core files:
  - `SdkIsolateManager` — Singleton lifecycle manager, gates Isolate vs local execution via `isActive`
  - `SdkIsolateEntry` — Background Isolate entry point, receives `(RootIsolateToken, SendPort)` tuple
  - `SdkMethodDispatcher` — 1400+ line switch-based dispatcher routing all 10 managers' methods
  - `SdkIsolateProtocol` — Request/response envelope types for cross-Isolate communication
- **All 10 managers proxied** — IMManager, ConversationManager, MessageManager, GroupManager, UserManager, FriendshipManager, MomentsManager, FavoriteManager, CallManager, RedPacketManager
- **Listener event forwarding** — All listener callbacks (connect, message, conversation, group, friendship, user, moments, favorite, call, red packet, custom business, upload progress) are serialized across the Isolate boundary and re-dispatched on the main Isolate
- **Transparent activation** — Call `SdkIsolateManager.initialize()` before `initSDK` to enable; omit it to run entirely on the main thread as before

### 🐛 Bug Fixes

- **Fixed `isInitialized` always returning `false` in Isolate mode** — Added `_initialized` field to track state across Isolate boundary
- **Fixed `.toJson()` serialization crashes** — Manually fixed 55 nested `.toJson()` calls across 4 `.g.dart` files where generated code produced incorrect output
- **Fixed `_currentUserID` `LateInitializationError`** — All 5 login paths (`login`, `loginByEmail`, `loginByPhone`, `loginByAccount`, `loadLoginConfig`) now properly initialize `_currentUserID` on every manager via `_setManagersUserID()`
- **Fixed infinite Isolate recursion** — Background Isolate no longer recursively spawns itself when `SdkIsolateManager.isActive` is true inside the Isolate
- **Fixed `BackgroundIsolateBinaryMessenger` crash** — Platform channel calls (path_provider) are resolved on the main Isolate before entering the background Isolate
- **Fixed duplicate `ToStore` registration** — Removed `getDatabaseInstance()` as public API, added KV proxy methods (`getValue`/`setValue`/`removeValue`/`getSpaceInfo`) through the Isolate boundary
- **Fixed video message display issues** — Video messages now show thumbnails and play correctly:
  - Changed `enableHardwareAcceleration` to `true` on non-Linux platforms (fixes mpv software renderer crash)
  - Fixed `createSnapshot` to reliably capture first frame by playing with volume 0 and waiting for stream dimensions
  - Added try-catch to video upload branch in `_handleMediaUploadIfNeeded`
- **Fixed `build.yaml`** — Changed from wildcard `generate_for` to explicit file list to work with analyzer 10.0.0

### 📦 New Models

- `CallSession` — Call session model with `toJson()`/`fromJson()` support
- `MomentCreateReq` — Moment creation request model with `toJson()`/`fromJson()` support
- Added `fromJson` factories to `SendRedPacketRequest`, `RedPacketDetail`, and `PointsTransaction`


## 1.7.7

- add `changePassword` and `resetPassword` method.
- update `tostore` version

## 1.7.6

- **Red packet grab notification refactored: BusinessNotification → real IM custom message**:
  Grab notifications are no longer pushed as BusinessNotification "phantom messages". The backend now sends a real IM custom message (`contentType=110`, `description="redPacketGrabNotify"`) into the conversation after a successful grab, appearing as a visible grab-notification bar in chat history.
- **Added `RedPacketGrabNotifyMessageData` model**:
  Parses the server-sent grab notification message, containing `packetID`, `grabberID`, `grabberName`, `grabberFaceURL`, `senderID`, `senderName`, `amount` fields.
- **Removed `RedPacketGrabbedNotify` model**:
  Previously used for BusinessNotification-based grab events, now replaced by `RedPacketGrabNotifyMessageData`.
- **Simplified `OnRedPacketListener`**:
  Removed `onRedPacketGrabbed` callback; only `onRedPacketExpired` and `onPointsBalanceChanged` remain.
- **Simplified `RedPacketManager.dispatchBusinessNotification`**:
  Removed `red_packet_grabbed` branch; only `red_packet_expired` and `points_adjusted` handling remains.
- **Red packet & points system**: Added `RedPacketManager`, encapsulating send/grab/detail APIs and points balance queries.
- **Model expansion**: `RedPacketGrabInfo` / `RedPacketDetail` / `RedPacketGrabbedNotify` gained `nickname` and `faceURL` fields, including user avatar info in grab records.
- **`IMManager` integration**: `redPacketManager` added as a standard field in `IMManager`, consistent with other managers; `onPointsBalanceChanged` callback fires automatically on balance changes.
- **Refactor**: Removed `OpenIM.redPacketManager` shortcut, unified to `OpenIM.iMManager.redPacketManager`.
- **Offline message pull: N per-message callbacks → 1 batch callback** (`msg_syncer.dart`, `message_manager.dart`, `advanced_msg_listener.dart`):
  Aligned with Go SDK `batchNewMessages` design: `_processPulledMsgs` no longer triggers `onRecvOfflineNewMessage` for each message in the same conversation one by one,
  now fires the new `onRecvOfflineNewMessages(List<Message>)` batch callback in a single call.
- **Empty `senderNickname` in search results** (`notification_dispatcher.dart`, `msg_syncer.dart`, `user_manager.dart`, `database_service.dart`):
  Aligned with Go SDK `UpdateMsgSenderFaceURLAndSenderNickname`: when the user's own info (nickname/avatar) changes, retroactively updates `senderNickname`/`senderFaceUrl` for all messages in the local database.
- **WebSocket push messages not storing `senderFaceUrl`** (`_msgDataToMap` in `msg_syncer.dart`):
  Map key used `'senderFaceURL'` (uppercase L) which mismatched the DB column `senderFaceUrl` (lowercase l), preventing avatar URLs from being written to the database.
  Fix: changed key to `'senderFaceUrl'` to align with DB schema.
- **Incorrect `searchLocalMessages` results** (`_searchFilterWorker` in `sdk_isolate.dart`):
  Original implementation performed fuzzy keyword matching on the entire `content` JSON string, causing number searches to hit image dimensions, file path sequences, and server URL IDs.
  Fixed to search specific fields by `contentType`, aligned with Go SDK `filterMsg` logic:
  - Text (101): search `textElem.content` only
  - @message (106): search `atTextElem.text` only
  - File (105): search `fileElem.fileName` only
  - Merge (107): search `mergeElem.title` only
  - Card (108): search `cardElem.nickname` only
  - Location (109) / Custom (110): search `description` only
  - Quote (114): search `quoteElem.text` only
  - Image (102) / Voice (103) / Video (104): excluded when keyword is present

## 1.6

- When Bug 1 sends an empty string, `draftTextTime` is refreshed to the current time. `simpleSort` uses `max(draftTextTime, latestMsgSendTime)` for sorting, with the new timestamp > the latestMsgSendTime of all older sessions → skipping to the top of the session list.
- Optimize logs and encapsulate logs as separate plug-ins, `aoiwe_logger`.
- Remove `setAppBackgroundStatus` method.
- **Incremental synchronization for Conversations / Friends / Groups (aligned with Go SDK `VersionSynchronizer`)**:
  - `MsgSyncer._syncConversationsAndSeqs()`: switched to `getIncrementalConversation` (version-based increment). Falls back to `_syncConversationsFull()` when `full=true` or on first install/reinstall.
  - `MsgSyncer._syncFriends()`: switched to `getIncrementalFriends`, supporting delete / insert / update paths.
  - `MsgSyncer._syncJoinedGroups()`: switched to `getIncrementalJoinGroup`; only re-fetches member lists for newly inserted groups.
  - All three sync channels persist new version numbers via `setVersionSync` into the `local_version_sync` table.

## 1.5

- Fixed friend sync issues, including incorrect old data returned by friendship listeners.

## 1.4

- **Aligned message/conversation sync logic with Go SDK**:
  - `MsgSyncer._syncConversationsAndSeqs()`: for non-first install, fetches full server conversation `seq` to avoid missing newly added server conversations.
  - `MsgSyncer._syncMessages()`: fixed incorrect skipping of `n_` notification conversations in non-reinstall scenarios; batching now accumulates by estimated message count to `SplitPullMsgNum(100)` before pulling.
  - `MsgSyncer._syncMissingMessages()`: gap sync now first fetches server `maxSeq`, then pulls by actual interval `[local+1, serverMax]`.
  - `MsgSyncer.handlePushMsg()`: push continuity check aligned with Go `pushTriggerAndSync`.
  - `MsgSyncer._syncHistoryByQueue()`: added history sync queue to continuously pull by ranges and advance `seq`.
- **Fixed repeated login failure (duplicate GetIt registration)**:
  - `IMManager.login()`: unregisters old `loginUser` instance before registration.
  - `IMManager.logout()`: unregisters `loginUser` to fix `UserInfo already registered` on relogin.
- **Aligned restart recovery strategy with Go SDK (`sending -> failed`)**:
  `MessageManager.recoverSendingMessages()`: marks sending messages as failed after restart, aligned with Go `handlerSendingMsg`.
- **Aligned post-connect sync trigger timing**:
  `IMManager` triggers `MsgSyncer.doConnectedSync()` on each successful connection and again when app returns to foreground.
- **Completed notification semantics and read receipt handling**:
  `NotificationDispatcher` added handling for `2102` (delete message) and `1703` (clear conversation). `2200` read receipt now maps `seq` back to `clientMsgID`.
- **Completed incremental sync and storage capabilities**:
  `ImApiService` added `getIncrementalJoinGroup()` and `getFullJoinGroupIDs()`.
  `DbSchema` added `local_uploads` and `local_version_sync`; group member unique key aligned to `(groupID, userID)`.
- **Fixed consistency gaps in full-ID sync for friends/groups**:
  Added local set-diff cleanup for friends and groups.
- **Aligned incremental entry points for relationships/groups/conversations**:
  Switched from full pull to version-based incremental sync for friends, groups, and conversations.
- **Completed resumable upload loop**:
  `IMManager.uploadFile()` now supports resuming uploaded parts for the same `uploadID`.
- **Completed independent notification-seq persistence**:
  `DbSchema` added `local_notification_seqs`. Notification processing paths now persist notification seq updates.
- **Fixed Flutter Web crash `MissingPluginException(getApplicationSupportDirectory)`**:
  `OpenImUtils.defaultDbPath()` now uses `kIsWeb` to detect Web and avoids calling `getApplicationSupportDirectory` on Web.
- Fixed group chat info synchronization issues.
- Fixed missing sender base information in messages.
- Fixed failure when removing users from blocklist.
- Optimized file upload performance.
- Fixed startup warning for `getApplicationSupportDirectory`.

## 1.3

- **Fixed missing group names during conversation sync**:
  `NotificationDispatcher._syncConversations()`: server `getAllConversations` does not return `showName`/`faceURL`; client now fills them via `_batchFillShowNameAndFaceURL()`.
  `MsgSyncer._enrichNewConversation()`: added network fallback with caching for group/user names.
- **Fixed `userInfo == null` after Web refresh**:
  `IMManager` now supports calling `loadLoginConfig()` before `runApp` to restore login state from IndexedDB.
- **Web file/image/video upload support**: Added byte-stream upload methods:
  - `MessageManager.createImageMessageFromBytes()`
  - `MessageManager.createVideoMessageFromBytes()`
  - `MessageManager.createFileMessageFromBytes()`
  - `IMManager.uploadFile()` adds optional `fileBytes` parameter
- **`IMManager` changed to singleton mode**: uses `factory` + `_internal` to avoid state loss.
- **Unified all data models with `Equatable`**:
  `Message.props` expanded from `[clientMsgID]` to all 41 fields. Added `Equatable` to 14 additional model classes.
- **Fixed message state becoming failed after switching conversations**:
  Default incoming cloud/push message status to `MessageStatus.succeeded` before insertion.
- **Fixed conversation list not showing latest message content after send**:
  Switched to `DatabaseService.messageToDbMap()` serialization for format compatibility.
- **Fixed latestMsg not updating on message send**:
  Added `clientMsgID` fallback matching for status transitions.
- **Optimized first-install sync performance**:
  Skip notification dispatch in reinstall sync.
- **Fixed incorrect blocklist display**:
  Updated `BlacklistInfo` model to use `blockUserID` instead of `userID`.
- **Fixed empty `latestMsg` in conversation list on first install**:
  Optimized `_syncMessages()` for first install (`reinstalled=true`).
- **Fixed file upload failure (HTTP 500)**:
  Corrected multipart upload URL assembly and response header parsing.
- **Fixed uploaded message loss when switching conversations**:
  Added `recoverSendingMessages()`; sending messages are marked failed on restart.
- **Fixed message sync efficiency issues**:
  Optimized `_syncConversationsAndSeqs()` aligned with Go SDK.

## 1.2

- **Background refresh callback for Moments: `onMomentListUpdated`**:
  `OnMomentsListener` adds `onMomentListUpdated`; `getMomentList()` now uses local-first return, then async network fetch.
- **Fixed messages disappearing after re-entering conversation when send previously failed**:
  Updated `recoverSendingMessages()` to mark sending messages as failed and update `latestMsg` status.
- **Fixed sending messages disappearing when switching conversations**:
  Corrected `getHistoryMessages()` filtering for `startSeq=0`.
- **Fixed inability to pull history messages**:
  Removed blocking check `convMaxSeq > 0` in `getAdvancedHistoryMessageList`.

## 1.1

- **`loginByAccount()`**: added account/password login.
- **`UserManager.register()`**: register account via chat service.
- **`UserManager.sendVerificationCode()`**: send verification code for register/reset-password/login.
- **`loginByEmail` / `loginByPhone` support either password or verification code**.
- **Fixed `register()` using wrong Dio instance**: switched to Chat API.
- **Fixed Web relogin freeze after logout**: `logout()` no longer closes database on Web.
- **Fixed reconnect flag not reset**: `connect()` now resets `_isReconnecting`.
- **Added `LinkInfo` model**, `FavoriteItem.linkInfo`, `FavoriteItem.fromLink()`, `FavoriteManager.addLink()` / `removeLink()`.
- **`NoteInfo` fields changed to non-null**.
- **`FavoriteType` changed to enum** (breaking change).
- **`FavoriteItem` adds typed content fields**: `message`, `momentInfo`, `momentComment`, `noteInfo`.
- Added `NoteInfo` model.
- Added helper methods in `FavoriteManager`: `isMessageFavorited`, `isMomentFavorited`, `addMessage`, `addMoment`, etc.
- Added `isInitialized` property.
- **Fixed WebSocket message decode failure on Web**: detects Web and disables gzip compression.
- **Fixed chat messages failing to load**: removed incorrect filtering for `contentType >= 1000`.
- **Fixed Moments API using wrong token**: switched to `chatToken`.
- **Fixed empty first load in Moments**: directly returns network result when local cache is empty.

## 1.0

First official release of the pure-Dart OpenIM SDK, aligned with Go SDK (openim-sdk-core v3.8.0) core capabilities.

### Core Architecture

- WebSocket long connection with protobuf encoding/decoding, heartbeat, and auto-reconnect.
- ToStore-based local persistence with user-scoped storage isolation.
- Service lifecycle managed with GetIt dependency injection.
- HTTP REST API layer covering all openim-server endpoints.
- Unified notification dispatcher for server push events.
- Message syncer for incremental pulling and deduplication.

### IMManager — SDK Management

- `initSDK` / `unInitSDK`, `login` / `logout`, `uploadFile`, `getSdkVersion`, `setAppBackgroundStatus`, `networkStatusChanged`, `updateFcmToken`, `setAppBadge`.

### ConversationManager — Conversation Management

- Fetch, pin, draft, hide, DND, burn-after-read, mark read, typing, delete/clear, search, unread stats.

### MessageManager — Message Management

- 24 creation methods, send, history, search, revoke, delete, local insert.

### GroupManager — Group Management

- Group CRUD, member management, mute, join/quit, applications.

### FriendshipManager — Friendship

- Add/delete/update, query, applications, blocklist.

### UserManager — User Management

- Login helpers, user profile, online status, client config.

### Listeners (10)

- `OnConnectListener`, `OnAdvancedMsgListener`, `OnConversationListener`, `OnFriendshipListener`, `OnGroupListener`, `OnUserListener`, `OnMsgSendProgressListener`, `OnUploadFileListener`, `OnCustomBusinessListener`, `OnListenerForService`.

### Performance Optimizations

- O(1) enum lookup, batched DB queries, unified timer cleanup, lazy loading, parallelized login, set-based dedup.

### Data Models

- `Message`, `ConversationInfo`, `UserInfo` / `FriendInfo` / `BlacklistInfo` / `UserStatusInfo`, `GroupInfo` / `GroupMembersInfo` / `GroupApplicationInfo`, `FriendApplicationInfo`, `NotificationInfo` / `SearchInfo` / `InputStatusChangedData`.

### Enums (17)

- `MessageType`, `MessageStatus`, `ConversationType`, `LoginStatus`, `GroupType`, `GroupRoleLevel`, `GroupStatus`, `GroupVerification`, `GroupMemberFilter`, `GroupAtType`, `AllowType`, `JoinSource`, `Relationship`, `ReceiveMessageOpt`, `IMPlatform`, `SDKErrorCode`, `WebSocketStatus`.

### Post-release Fixes

- Fixed self-to-self conversations appearing in list.
- Added `OpenIMException` with server error code mapping.
- Fixed `getGroupMemberList` returning empty list; added realtime group-member notification DB updates.
- Fixed conversation `latestMsg` always null after initial sync; reinstall sync optimization; gap sync fix.
- Fixed single conversation unread count always being 0; global type-safety hardening.
- Exported `OpenImUtils` class.
- Corrected names in `MessageType`.
