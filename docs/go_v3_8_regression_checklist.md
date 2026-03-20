# Go v3.8.x Alignment Regression Checklist

This checklist is for black-box verification against Go SDK v3.8.x behavior.

## Environment

- Use two test accounts: `A` and `B`.
- Keep both devices online; one browser tab/device for each account.
- Ensure both run the same server and same SDK build.

## 1. Cold Start Full History Sync

Steps:
- Login with `A` on a fresh client (or clear local DB for `A`).
- Open conversation list and enter several old conversations with long history.

Expected:
- Conversation list shows correct `latestMsg` (not empty).
- History is not limited to latest one message; older ranges can be paged in.
- No persistent seq gap warnings in logs after initial sync settles.

## 2. Push Gap Recovery

Steps:
- Keep `A` online, then disconnect `A` network temporarily.
- Send multiple messages to `A` from `B`.
- Reconnect `A` network.

Expected:
- On reconnect, `A` catches up missing ranges automatically.
- Unread count/maxSeq/latestMsg converge to server state.
- No permanent missing segment between pre-disconnect and latest message.

## 3. Reconnect Triggers Sync

Steps:
- Login `A`, keep app idle.
- Force websocket reconnect (toggle network or call reconnect path).

Expected:
- Reconnect success triggers sync flow again.
- If server has newer seq, local messages/conversations are updated without waiting for next push.

## 4. Foreground Wake-up Sync

Steps:
- Put `A` to background, send messages from `B`.
- Bring `A` foreground.

Expected:
- Foreground transition triggers sync.
- Conversation unread and latest content update promptly.

## 5. Read Receipt Mapping (seq -> clientMsgID)

Steps:
- In single chat, send several messages from `A` to `B`.
- Let `B` read them.

Expected:
- `A` receives C2C read receipt with message ID mapping that UI can match.
- Message read state updates correctly in local DB and UI.

## 6. Self Read Receipt Unread Count

Steps:
- Login `A` on two devices.
- Device-1 leaves messages unread.
- Device-2 marks conversation as read.

Expected:
- Device-1 updates unread as `max(0, maxSeq - hasReadSeq)` behavior.
- No incorrect full-clear in partial-read scenarios.

## 7. Revoke / Delete / Clear Notifications

Steps:
- Revoke one latest message.
- Trigger server delete-msgs notification (`2102`) for selected seqs.
- Trigger clear-conversation notification (`1703`).

Expected:
- Local message status/content reflects revoke/delete/clear.
- Conversation latestMsg recalculates correctly.
- Conversation changed + total unread callbacks are visible at UI layer.

## 8. Restart Sending Recovery (Go behavior)

Steps:
- Start sending media from `A`, kill app before completion.
- Restart and login again.

Expected:
- Sending records are recovered as failed (not auto-resend).
- If failed message is latestMsg, conversation latestMsg status reflects failed.

## 9. Friend/Group Notification Convergence

Steps:
- Trigger friend add/delete/remark and group join/kick/member changes from another client.

Expected:
- Local friend/group/member data converges to server after notification-triggered sync.
- No duplicated group member rows for same `(groupID, userID)`.

## 10. Upload Task Persistence

Steps:
- Start multipart upload, interrupt app, relaunch.

Expected:
- Upload task metadata exists in local upload table during process.
- On successful complete, task record is removed.

## Sign-off

- Run `dart analyze` on changed modules with no new errors.
- Confirm all 10 items pass before release.
