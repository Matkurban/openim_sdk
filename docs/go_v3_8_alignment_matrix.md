# Go v3.8.x Alignment Matrix

This document tracks behavioral alignment between Dart SDK (`openim_sdk`) and Go SDK (`openim-sdk-core v3.8.x`).

## Lifecycle / Connection

- [x] Logout -> relogin `GetIt` duplicate `loginUser` registration fixed.
- [x] Reconnect success should always trigger post-connect sync (`GetNewestSeq` flow equivalent).
- [x] Handshake error classification should stop reconnect for token-invalid/kicked errors.
- [x] API token/kicked callback should trigger SDK internal logout cleanup.
- [x] Foreground wake-up should trigger light sync.

## Message Sync / Seq

- [x] Non-first install uses full conversation seq pull (not local IDs only).
- [x] Gap sync now uses server max seq range instead of fixed window.
- [x] Push seq continuity logic aligned (`seq=0` not in continuity window).
- [x] History sync queue introduced for range completion (not latest-only).
- [x] Reinstall detection should use persisted install flag (not conversations-empty only).
- [x] Notification seq should be persisted separately (Go `notification_seqs` equivalent).

## Conversation / Message Semantics

- [x] Notification `2102` (delete msgs) local apply and conversation refresh.
- [x] Notification `1703` (clear conversation) local apply and conversation refresh.
- [x] Read receipt should emit clientMsgID list (not seq string list).
- [x] Self-read receipt unread count should be `max(0, maxSeq-hasReadSeq)` instead of clear-all.

## Relation / Group / User Notifications
- [x] Replace full-sync debounce with version-aware incremental sync entrypoints.
- [x] Add group incremental API wrappers (`get_incremental_join_groups`, `get_full_join_group_ids`).
- [x] Reduce direct local patching where Go uses incremental pull to converge.

## Upload / DB Semantics

- [x] Add upload persistence table and resume metadata semantics.
- [x] Align group member uniqueness to `(groupID,userID)` semantics.
- [x] Add owner-scoped friend operations where missing.

## Regression / Docs

- [x] Add regression cases for reconnect-sync, read receipt mapping, delete/clear notifications.
- [x] Update changelog with module-wise alignment deltas.
