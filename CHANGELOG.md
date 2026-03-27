# Changelog

## 1.6.6

- When Bug 1 sends an empty string, `draftTextTime` is refreshed to the current time. `simpleSort` uses `max(draftTextTime, latestMsgSendTime)` for sorting, with the new timestamp > the latestMsgSendTime of all older sessions → skipping to the top of the session list.

## 1.6.5

- Optimize logs and encapsulate logs as separate plug-ins ，`aoiwe_logger`

## 1.6.4

- fix snync bugs

## 1.6.3

- remove `setAppBackgroundStatus` method

## 1.6.2

- Bug fixes.

## 1.6.1

### Fixes

- **Incremental synchronization for Conversations / Friends / Groups (aligned with Go SDK `VersionSynchronizer`)**:
  - `MsgSyncer._syncConversationsAndSeqs()`: switched to `getIncrementalConversation` (version-based increment). Falls back to `_syncConversationsFull()` when `full=true` or on first install/reinstall.
    The independent step always refreshes `getConversationsHasReadAndMaxSeq` to keep `_serverMaxSeqs` up to date.
  - `MsgSyncer._syncFriends()`: switched to `getIncrementalFriends`, supporting delete / insert / update paths.
    Falls back to `_syncFriendsFull()` when `full=true` or during initial sync; also syncs single-chat `showName` / `faceURL` when friend data changes.
  - `MsgSyncer._syncJoinedGroups()`: switched to `getIncrementalJoinGroup`; only re-fetches member lists for newly inserted groups to reduce unnecessary HTTP requests.
  - All three sync channels persist new version numbers via `setVersionSync` into the `local_version_sync` table.

## 1.5.0

- Fixed friend sync issues, including incorrect old data returned by friendship listeners.

## 1.4.7

- Fixed group chat info synchronization issues.

## 1.4.6

- Fixed missing sender base information in messages.

## 1.4.5

- Fixed failure when removing users from blocklist.

## 1.4.4

- Optimized file upload performance.

## 1.4.3

- Optimized file upload.

## 1.4.2

- **Fixed Flutter Web crash `MissingPluginException(getApplicationSupportDirectory)`**:
  - `OpenImUtils.defaultDbPath()` now uses `kIsWeb` to detect Web and avoids calling `path_provider.getApplicationSupportDirectory` on Web.
  - Fixed Web detection in platform checks (to avoid `UniversalPlatform.isWeb` misdetection on Web):
    - `PlatformUtils.currentPlatform` now uses `kIsWeb`.
    - `WebSocketService` force-disables compression on Web using `kIsWeb`.

## 1.4.1

- Fixed startup warning for `getApplicationSupportDirectory`.

## 1.4.0

- **Aligned message/conversation sync logic with Go SDK**:
  - `MsgSyncer._syncConversationsAndSeqs()`: for non-first install, fetches full server conversation `seq` to avoid missing newly added server conversations when requesting only by local IDs.
  - `MsgSyncer._syncMessages()`: fixed incorrect skipping of `n_` notification conversations in non-reinstall scenarios; batching now accumulates by estimated message count to `SplitPullMsgNum(100)` before pulling, aligned with Go `syncAndTriggerMsgs`.
  - `MsgSyncer._syncMissingMessages()`: gap sync now first fetches server `maxSeq`, then pulls by actual interval `[local+1, serverMax]`, removing fixed-window gap pulls.
  - `MsgSyncer.handlePushMsg()`: push continuity check aligned with Go `pushTriggerAndSync` (`seq=0` excluded from continuity; uses `lastSeq == local + count`). If gaps are detected, pull first then insert to avoid out-of-order/gap mishandling.
  - `MsgSyncer._syncHistoryByQueue()`: added history sync queue to continuously pull by ranges and advance `seq`, fixing the issue where only `latestMsg` was synchronized.

- **Fixed repeated login failure (duplicate GetIt registration)**:
  - `IMManager.login()`: unregisters old `loginUser` instance before registration.
  - `IMManager.logout()`: unregisters `loginUser` to fix `UserInfo already registered` on relogin.

- **Aligned restart recovery strategy with Go SDK (`sending -> failed`)**:
  - `MessageManager.recoverSendingMessages()`: no longer auto-resends `sending` messages after restart; marks them as failed and updates conversation `latestMsg` status, aligned with Go `handlerSendingMsg`.

- **Aligned post-connect sync trigger timing**:
  - `WebSocketService` added a unified success callback for connection/reconnection success.
  - `IMManager` triggers `MsgSyncer.doConnectedSync()` on each successful connection and again when app returns to foreground.

- **Completed notification semantics and read receipt handling**:
  - `NotificationDispatcher` added handling for `2102` (delete message) and `1703` (clear conversation), refreshing conversation latest/unread.
  - `2200` read receipt now maps `seq` back to `clientMsgID` before invoking `recvC2CReadReceipt`, and computes unread by `maxSeq - hasReadSeq` to avoid incorrect zeroing.

- **Completed incremental sync and storage capabilities (aligned with Go structure)**:
  - `ImApiService` added `getIncrementalJoinGroup()` and `getFullJoinGroupIDs()`.
  - `DbSchema` added `local_uploads` and `local_version_sync`; group member unique key aligned to `(groupID, userID)`.
  - `DatabaseService` added `VersionSync`, upload task, and `seq`-based query/read/delete capabilities.

- **Fixed consistency gaps in full-ID sync for friends/groups**:
  - `NotificationDispatcher._syncFriends()`: added local set-diff cleanup (delete `local - server` friends).
  - `NotificationDispatcher._syncJoinedGroups()`: added local set-diff cleanup (delete `local - server` groups and members, and mark conversation `isNotInGroup=true`).
  - Empty-server-set handling: no longer returns early; performs local cleanup first and updates version sync records to avoid stale data.

- **Aligned incremental entry points (version-aware) for relationships/groups/conversations**:
  - `NotificationDispatcher._syncFriends()`: switched from full pull to `getIncrementalFriends`, advancing by `local_version_sync` and handling delete/insert/update.
  - `NotificationDispatcher._syncJoinedGroups()`: switched from full pull to `getIncrementalJoinGroup`, incrementally converging delete/insert/update and fetching member lists only for changed groups.
  - `NotificationDispatcher._syncConversations()`: switched from full `getAllConversations` to `getIncrementalConversation`, updating conversations incrementally by insert/update/delete.
  - In `NotificationDispatcher`, `memberQuit/memberKicked`: no longer directly call `deleteGroupMember` for non-self changes; handled by incremental sync to reduce local patch conflicts.

- **Regression validation points (aligned with Go SDK behavior)**:
  - Post-reconnect sync must be triggered: verify gaps are filled after successful reconnect.
  - Read-receipt mapping: verify `recvC2CReadReceipt.msgIDList` uses `clientMsgID` (not `seq` strings).
  - Delete/clear conversation notifications: verify local DB delete/clear happens before refreshing latest/unread to avoid timing races.

- **Completed resumable upload loop (aligned with Go `upload_model` semantics)**:
  - `DatabaseService` added `getUploadTaskByHashAndName()` to query historical upload tasks by `hash + name` before upload.
  - `IMManager.uploadFile()` now supports resuming uploaded parts for the same `uploadID` (skip finished parts) and continuously updates `uploadedParts`.
  - Local upload task records are deleted after upload completion to avoid stale state.

- **Completed independent notification-seq persistence (aligned with Go `notification_seqs` semantics)**:
  - `DbSchema` added `local_notification_seqs`.
  - `DatabaseService` added `upsertNotificationSeq()` and `getAllNotificationSeqs()`.
  - `MsgSyncer._loadSeqs()` restores notification seqs to memory at startup.
  - Notification processing paths (push/pull) now persist notification seq updates.
  - In reinstall scenarios, `n_` notification conversations now "advance seq only without pulling notification content", aligned with Go branch semantics.

## 1.3.4

- **Fixed missing group names during conversation sync**:
  - `NotificationDispatcher._syncConversations()`: server `getAllConversations` does not return `showName`/`faceURL`; client now fills them. Added `_batchFillShowNameAndFaceURL()` to batch-fill before DB write (local DB first, network fallback), aligned with Go `batchAddFaceURLAndName`.
  - `MsgSyncer._enrichNewConversation()`: when auto-creating conversation from push messages, it previously only queried local DB for group/user names. If the group was not yet synced locally (e.g. just invited), name remained sender nickname. Added network fallback with caching.

- **Fixed `userInfo == null` after Web refresh**:
  Browser refresh resets in-memory Dart state (`_userInfo`, `_loginStatus`, etc.) while URL is retained (e.g. `/main`), skipping splash auto-login (`loadLoginConfig()`). `IMManager` now supports calling `loadLoginConfig()` before `runApp` to restore login state from IndexedDB.

## 1.3.3

### Added

- **Web file/image/video upload support**: Web cannot use `dart:io File` path reads; added byte-stream upload methods:
  - `MessageManager.createImageMessageFromBytes()`
  - `MessageManager.createVideoMessageFromBytes()`
  - `MessageManager.createFileMessageFromBytes()`
  - `IMManager.uploadFile()` adds optional `fileBytes` parameter for direct byte upload (without `dart:io File` reads)
  - `_handleMediaUploadIfNeeded()` prioritizes in-memory `_pendingUploadBytes`, removing file path dependency on Web

### Optimized

- **`IMManager` changed to singleton mode**: uses `factory` + `_internal` to avoid state loss from repeated instance creation.

- **Unified all data models with `Equatable`**:
  audited and fixed model `props` to include all fields, fixing object equality-dependent scenes like `didUpdateWidget`.
  - `Message.props` expanded from `[clientMsgID]` to all 41 fields (**critical fix**: UI could not detect URL change after image send before this)
  - Added `Equatable` to: `FullUserInfo`, `AuthCacheData`, `LinkInfo`, `NoteInfo`, `MomentInfo`, `MomentCommentWithUser`, `MomentLikeWithUser`, `MomentMedia`, `MomentUserInfo`, `MomentCreateReq`, `MomentListResponse`, `FavoriteItem`, `FavoriteListResponse`

## 1.3.2

- **Fixed message state becoming failed after switching conversations**:
  `getAdvancedHistoryMessageList` upserts cloud messages via `batchInsertMessages`; protobuf `status` defaults to `0`, while `MessageStatus.fromValue(0)` falls back to `failed`, overwriting successful messages.
  Fix: default incoming cloud/push message status to `MessageStatus.succeeded` before insertion (aligned with Go SDK: server-side messages must already be sent successfully).

- **Fixed conversation list not showing latest message content after send**:
  `_updateConversationLatestMsg` serialized latest message with `message.toJson()` (json_serializable format), generating `{textElem: {content: "..."}}`, but `convertMessage()` expects DB flat `content` format like `{content: '{"content":"..."}'}`.
  Fix: switched to `DatabaseService.messageToDbMap()` serialization for format compatibility.

- **Fixed latestMsg not updating on message send**:
  `_updateConversationLatestMsg` only compared `sendTime >= existingTime`; newly created local message has `sendTime=0`, so update might be skipped.
  Fix: aligned with Go `doUpdateConversation > AddConOrUpLatMsg` (notification.go:198) by adding `clientMsgID` fallback matching, so status transitions (sending -> succeeded) always update latestMsg for the same message.

- **Optimized first-install sync performance**:
  on first install, `_processPulledMsgs` dispatched each notification message (`contentType >= 1000`) one by one, causing repeated `_debounceSyncFriends` with large notification volumes.
  Fix: skip notification dispatch in reinstall sync (aligned with Go `doMsgSyncByReinstalled`, where friends/groups are already fully synced by `_syncFriends` / `_syncJoinedGroups`).

## 1.3.1

- **Fixed incorrect blocklist display**:
  `BlacklistInfo.userID` returned as `null` from `getBlacklist()`, causing UI display issues.
  Updated `BlacklistInfo` model to use `blockUserID` instead of `userID`, with correct mapping in `BlacklistInfo.fromJson()`.

## 1.3.0

- **Fixed empty `latestMsg` in conversation list on first install**:
  optimized `_syncMessages()` so messages are pulled even when seq is 0 during first install (`reinstalled=true`), aligned with Go SDK `connectPullNums=1` behavior.

- **Fixed file upload failure (HTTP 500)**:
  corrected multipart upload URL assembly; server `partInfo.url` may be incomplete and now composes `signUrl + uploadId + partNumber`.
  also fixed response header parsing (server returns List instead of Map) and ETag format trimming (S3 returns quoted ETag).

- **Fixed uploaded message loss when switching conversations**:
  added `recoverSendingMessages()`; on app restart/relogin, sending messages are marked failed (not deleted), consistent with Go SDK, so users can resend via long-press.

- **Fixed message sync efficiency issues**:
  optimized `_syncConversationsAndSeqs()` aligned with Go SDK: fetch server seqs first, only fetch full info for new conversations, and update seq only for existing ones.

- **Fixed inability to sync conversations on first install**:
  optimized `_syncConversationsAndSeqs()` so first install (or `reinstalled=true`) directly calls `getAllConversations`, aligned with Go SDK.

## 1.2.1

- **Fixed messages disappearing after re-entering conversation when send previously failed**:
  updated `recoverSendingMessages()` to match Go `handlerSendingMsg`:
  - mark sending messages as failed
  - if it is conversation `latestMsg`, update `latestMsg` status to failed
  - trigger `onMessageStatusChanged` callback for UI update

- **Fixed sending messages disappearing when switching conversations**:
  corrected `getHistoryMessages()` filtering for `startSeq=0`; now includes all `seq<=0` messages except the `startMsgID` itself.

- **Fixed inability to pull history messages**:
  removed blocking check `convMaxSeq > 0` in `getAdvancedHistoryMessageList`; now attempts pull even when `maxSeq=0` for new conversations.

- **Fixed empty `latestMsg` on first install**:
  same alignment with Go SDK `connectPullNums=1` behavior.

- **Fixed file upload failure (500)**:
  same multipart URL/header/ETag fixes as above.

- **Fixed upload message loss on conversation switch**:
  added `recoverSendingMessages()` with Go-consistent behavior.

- **Fixed message sync efficiency issues**:
  optimized `_syncConversationsAndSeqs()` per Go logic.

- **Fixed first-install conversation sync failure**:
  first install or reinstall directly uses `getAllConversations`.

## 1.2.0

- **Background refresh callback for Moments: `onMomentListUpdated`**:
  `OnMomentsListener` adds `onMomentListUpdated`; `getMomentList()` now uses local-first return, then asynchronously fetches network latest and writes DB, then notifies UI via callback.

## 1.1.9

- **Fixed WebSocket message decode failure on Web**:
  Web does not support `dart:io` gzip (`_newZLibInflateFilter`). SDK now detects Web and disables gzip compression, and no longer sends `compression=gzip` to server.

## 1.1.8

- **Fixed chat messages failing to load**:
  removed incorrect filtering for `contentType >= 1000`.
  Go SDK routes by conversation layer (`n_` prefix), not by contentType. `pull_msg_by_seq.msgs` contains normal conversation messages and should all be stored in `chatLog`.
  Fixed in three places: `_processPulledMsgs` (sync), `_collectMessageUpdate` (push), `getAdvancedHistoryMessageList` (history pull).

## 1.1.7

- **Fixed Moments API using wrong token**:
  `MomentsManager._post` switched from `HttpClient().token` (imToken) to `HttpClient().chatToken` (chatToken), fixing chat-server API failures caused by wrong token type.

## 1.1.6

- **Fixed empty first load in Moments**:
  when local cache is empty, `getMomentList()` now directly returns network result instead of returning empty list and silently caching in background.

## 1.1.5

- **`loginByAccount()`**:
  added account/password login, supporting `account + password` (backend native `CredentialAccount`).

## 1.1.4

- **`UserManager.register()`**:
  register account via chat service, supporting email or phone registration, returning `AuthCacheData?`.
- **`UserManager.sendVerificationCode()`**:
  send verification code via chat service for register/reset-password/login scenarios.

- **`loginByEmail` / `loginByPhone` support either password or verification code**:
  both `password` and `verificationCode` are optional; provide either one.

- **Fixed `register()` using wrong Dio instance**:
  `ImApiService.register()` switched from `HttpClient().post()` (IM API) to `HttpClient().chatPost()` (Chat API), fixing requests sent to wrong backend.

## 1.1.3

- **Fixed Web relogin freeze after logout**:
  `logout()` no longer closes database to avoid silent hangs on closed IndexedDB instance.
- **Fixed reconnect flag not reset**:
  `connect()` now resets `_isReconnecting` to avoid reconnect failure after relogin.

## 1.1.2

- Added `LinkInfo` model: link structure (`url`, `title`, `description`, `imageUrl`).
- `FavoriteItem` adds `linkInfo`, auto-parsed when `favoriteType == .link`.
- Added `FavoriteItem.fromLink()` factory.
- Added convenience methods `FavoriteManager.addLink()` / `removeLink()`.

- `NoteInfo` fields changed to non-null: `noteID`, `summary`, `content`, `createdAt` are now `String`.
- Added comments for each `FavoriteType` enum value.

## 1.1.1

### Refactor

- **`FavoriteType` changed to enum** (breaking change):
  - Replaced `sealed class` string constants with `enum FavoriteType`, use `.value` to get string value.
  - Added static `FavoriteType.fromValue(String?)`.

- **`FavoriteItem` adds typed content fields**:
  - Replaced `targetType` with `favoriteType` (`FavoriteType` enum), while keeping `targetType` getter for compatibility.
  - Added nullable fields: `message`, `momentInfo`, `momentComment`, `noteInfo`, auto-parsed from `data` by `favoriteType`.
  - Added quick factories: `FavoriteItem.fromMessage()`, `FavoriteItem.fromMoment()`, `FavoriteItem.fromMomentComment()`, `FavoriteItem.fromNote()`.

- Added `NoteInfo` model: note structure (`noteID`, `summary`, `content`, `createdAt`).
- Added helper methods in `FavoriteManager`:
  - `isMessageFavorited(clientMsgID)`
  - `isMomentFavorited(momentID)`
  - `addMessage(message:)`
  - `addMoment(moment:)`
  - `addMomentComment(comment:)`
  - `removeMoment(momentID:)` / `removeMomentComment(commentID:)`

## 1.1.0

- Added `isInitialized` property to check whether SDK has been initialized successfully.

## 1.0.9

### Bug Fixes

- **Fixed self-to-self conversations appearing in list**:
  - Server may create self single-chat for login user; sync now skips `conversationType == 1 && userID == loginUserID`.
  - Local existing self-conversation records are cleaned automatically during login sync.

## 1.0.8

- Added `OpenIMException`:
  - On message send failure (for example errCode=1303 not-friend), `sendMessage` now throws `OpenIMException` instead of silently returning failed message.
  - `OpenIMException` carries server `code` and `message`, and provides `sdkErrorCode` getter for direct matching with `SDKErrorCode`.

## 1.0.7

- **Fixed `getGroupMemberList` returning empty list**:
  - Root cause: login sync only synced groups, not group members. `getGroupMemberList` reads local DB, but members were only written in local `createGroup` / `inviteUserToGroup` flows.
  - Fix: `_syncJoinedGroups` (login sync + notification-triggered sync) now paginates and pulls all members for each joined group and writes local DB, aligned with Go SDK `SyncAllJoinedGroupsAndMembersWithLock` -> `IncrSyncJoinGroupMember`.

- **Realtime group-member notifications now update local DB**:
  - `memberQuit` (1504) / `memberKicked` (1508): delete member locally.
  - `memberInvited` (1509) / `memberEnter` (1510): insert new member locally.
  - `groupMemberInfoSet` (1516) / `groupMemberMuted` (1512) / `groupMemberSetToAdmin` (1517): update local member info.
  - `groupDismissed` (1511): clear all local members for that group.

## 1.0.6

- **Fixed conversation `latestMsg` always null after initial sync**:
  - Aligned with Go `doMsgSyncByReinstalled`: both normal and notification messages participate in `latestMsg` calculation.
  - Notification messages (`contentType >= 1000`) in `_processPulledMsgs` are correctly routed to `NotificationDispatcher`, aligned with Go `triggerNotification`.
  - Added `_processPulledNotifications` for `notificationMsgs` response field, aligned with Go handling.
  - Triggered `conversationChanged` callback after sync to ensure UI receives latest state.

- **Reinstall sync optimization**: skip pulling `n_` notification conversation messages during first install, aligned with Go reinstall branch in `compareSeqsAndBatchSync`.
- **Gap sync fix**: `_syncMissingMessages` no longer passes `num: 0`; now pulls without count limit and triggers conversation update callback after completion.
- **Type safety**: all `as int?` in `_processPulledMsgs` changed to `(as num?)?.toInt()`.

## 1.0.5

- **Fixed single conversation unread count always being 0**:
  - `_syncConversationsAndSeqs` used `as int?` casts for `maxSeq`/`hasReadSeq`; if server returned `num` (such as `double`), sync could fail and unread counts were never written.
    fixed with safe cast `(as num?)?.toInt()`.
  - Missing `conversationChanged` and `totalUnreadMessageCountChanged` callbacks after initial sync prevented UI from reading computed unread counts; now triggered after DB write.
  - `clearAllUnreadCounts()` lacked `.allowUpdateAll()`, causing silent rejection by ToStore `updateInternal` without where-clause; "mark all as read" effectively failed.

- **Global type-safety hardening**:
  converted all `as int?` to `(as num?)?.toInt()` in `_convertConversation`, `getTotalUnreadCount`, `decrConversationUnreadCount`, `getConversationMaxSeq`, `getAllConversationMaxSeqs`.

## 1.0.4

- Fixed known issues.

## 1.0.3

- Fixed known issues.

## 1.0.2

- Exported `OpenImUtils` class.

## 1.0.1

- Corrected names in `MessageType` that were inconsistent with the original SDK.

## 1.0.0

First official release of the pure-Dart OpenIM SDK, aligned with Go SDK (openim-sdk-core v3.8.0) core capabilities.

### Core Architecture

- WebSocket long connection with protobuf encoding/decoding, heartbeat, and auto-reconnect.
- ToStore-based local persistence with user-scoped storage isolation.
- Service lifecycle managed with GetIt dependency injection.
- HTTP REST API layer covering all openim-server endpoints.
- Unified notification dispatcher for server push events (friend/group/user changes).
- Message syncer for incremental pulling and deduplication.

### IMManager — SDK Management

- `initSDK` / `unInitSDK` — SDK initialization and teardown.
- `login` / `logout` — login/logout with auto-login restore support.
- `uploadFile` — multipart upload (2MB chunks, MD5 instant upload, progress callback).
- `getSdkVersion` — get SDK version.
- `setAppBackgroundStatus` — app foreground/background switch with WebSocket server notification.
- `networkStatusChanged` — trigger reconnect on network state changes.
- `updateFcmToken` — update FCM push token.
- `setAppBadge` — set app badge unread count.
- Global interception and callbacks for token expired/invalid/kicked states.

### ConversationManager — Conversation Management

- Fetch: `getAllConversationList`, `getConversationListSplit` (pagination), `getOneConversation`, `getMultipleConversation`.
- Operations: `pinConversation`, `setConversationDraft`, `hideConversation`, `setConversation` (DND/pin/burn-after-read, etc.).
- Read: `markConversationMessageAsRead`, `markMessagesAsReadByMsgID`, `markAllConversationMessageAsRead`.
- Typing: `changeInputStates` / `getInputStates`.
- Delete/Clear: `deleteConversationAndDeleteAllMsg`, `clearConversationAndDeleteAllMsg`.
- Search: `searchConversations`.
- Unread stats: `getTotalUnreadMsgCount`.

### MessageManager — Message Management

- 24 creation methods: text/image/voice/video/file/@text/merge/forward/card/location/custom/quote/emoji/advanced text and URL variants.
- Send: `sendMessage` / `sendMessageNotOss`.
- History: `getAdvancedHistoryMessageList` (asc/desc), `findMessageList` (exact by IDs).
- Search: `searchLocalMessages` (keyword/type/time/conversation).
- Operations: `revokeMessage`, `deleteMessageFromLocalStorage`, `deleteMessageFromLocalAndSvr`, `deleteAllMsgFromLocalAndSvr`.
- Local insert: `insertSingleMessageToLocalStorage`, `insertGroupMessageToLocalStorage`.

### GroupManager — Group Management

- Group CRUD: `createGroup`, `setGroupInfo`, `dismissGroup`, `getGroupsInfo`.
- Group list: `getJoinedGroupList`, `getJoinedGroupListPage`, `searchGroups`.
- Member management: `inviteUserToGroup`, `kickGroupMember`, `transferGroupOwner`, `setGroupMemberInfo`.
- Member query: `getGroupMemberList`, `getGroupMembersInfo`, `getGroupOwnerAndAdmin`, `searchGroupMembers`, `getGroupMemberListByJoinTime`, `getUsersInGroup`.
- Mute: `changeGroupMute`, `changeGroupMemberMute`.
- Join/Quit: `joinGroup`, `quitGroup`.
- Applications: `getGroupApplicationListAsRecipient`, `getGroupApplicationListAsApplicant`, `acceptGroupApplication`, `refuseGroupApplication`, `getGroupApplicationUnhandledCount`.

### FriendshipManager — Friendship

- Operations: `addFriend`, `deleteFriend`, `updateFriends`.
- Query: `getFriendsInfo`, `getFriendList`, `getFriendListPage`, `searchFriends`, `checkFriend`.
- Applications: `getFriendApplicationListAsRecipient`, `getFriendApplicationListAsApplicant`, `acceptFriendApplication`, `refuseFriendApplication`, `getFriendApplicationUnhandledCount`.
- Blocklist: `addBlacklist`, `getBlacklist`, `removeBlacklist`.

### UserManager — User Management

- Login helpers: `loginByEmail`, `loginByPhone` (via Chat service).
- User profile: `getUsersInfo`, `getUsersInfoWithCache`, `getUsersInfoFromSrv`, `getSelfUserInfo`, `setSelfInfo`.
- Online status: `subscribeUsersStatus`, `unsubscribeUsersStatus`, `getSubscribeUsersStatus`, `getUserStatus`.
- Client config: `getUserClientConfig`.

### Listeners (10)

- `OnConnectListener` — connect success/failure/reconnect/kicked/token expired.
- `OnAdvancedMsgListener` — new message/revoke/read receipt/offline/online message.
- `OnConversationListener` — conversation changes/new conversation/unread/sync state/input state.
- `OnFriendshipListener` — friend add/delete/request/refuse/blocklist/remark changes.
- `OnGroupListener` — group info/member/role/mute/application/dismiss updates.
- `OnUserListener` — user info and online-status changes.
- `OnMsgSendProgressListener` — message send progress.
- `OnUploadFileListener` — full file upload lifecycle progress.
- `OnCustomBusinessListener` — custom business messages.
- `OnListenerForService` — backend push service listener.

### Performance Optimizations

- O(1) static map lookup for enums instead of linear traversal.
- Batched DB queries (`whereIn` / `batchUpsert`) instead of N+1 queries.
- Unified timer cleanup in `logout` / `dispose`.
- Lazy loading of conversation `maxSeq`.
- Parallelized independent operations in login flow.
- O(1) set-based dedup/exclusion for friend/blocklist handling.

### Data Models

- `Message` — message (24 content types).
- `ConversationInfo` — conversation.
- `UserInfo` / `FriendInfo` / `BlacklistInfo` / `UserStatusInfo` — user-related.
- `GroupInfo` / `GroupMembersInfo` / `GroupApplicationInfo` — group-related.
- `FriendApplicationInfo` — friend application.
- `NotificationInfo` / `SearchInfo` / `InputStatusChangedData` — helper models.

### Enums (17)

- `MessageType`, `MessageStatus`, `ConversationType`, `LoginStatus`, `GroupType`, `GroupRoleLevel`, `GroupStatus`, `GroupVerification`, `GroupMemberFilter`, `GroupAtType`, `AllowType`, `JoinSource`, `Relationship`, `ReceiveMessageOpt`, `IMPlatform`, `SDKErrorCode`, `WebSocketStatus`.
