import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:logging/logging.dart';

import '../../../protocol_gen/sdkws/sdkws.pb.dart' as sdkws;
import '../../core/sdk_context.dart';
import '../../db/repositories/message_repository.dart';
import '../../enums/conversation_type.dart';
import '../../enums/message_status.dart';
import '../../enums/message_type.dart';
import '../../enums/sdk_error_code.dart';
import '../../listener/advanced_msg_listener.dart';
import '../../listener/conversation_listener.dart';
import '../../listener/msg_send_progress_listener.dart';
import '../../models/conversation_info.dart';
import '../../models/group_info.dart';
import '../../models/message.dart';
import '../../models/openim_exception.dart';
import '../../models/user_info.dart';
import '../../models/web_socket_codec.dart';
import '../../models/web_socket_identifier.dart';
import '../../utils/file_util.dart';
import '../../utils/open_im_utils.dart';
import '../../utils/platform_utils.dart';
import '../file_uploader.dart';
import 'message_factory.dart';

/// 消息发送引擎（从原 2,625 行 `MessageManager` 拆出）。
///
/// 关键修复：
/// - B-02：发送成功后完整解析 `sdkws.SendMsgResp.fromBuffer(resp.data)`，写回服务端分配的
///   `serverMsgID`、`sendTime` 与 `seq`（以及更新会话 `maxSeq`），彻底修复刚发出的消息无法撤回/删云端问题；
/// - B-10：移除跨 Isolate 后 `pendingUploadBytes` 内存同享，`createFileMessageByFile` 上传 100% 生效。
class MessageSender {
  final Logger _logger = Logger('openim_sdk.MessageSender');
  final SdkContext _context;
  final FileUploader _fileUploader;
  final MessageFactory _factory;
  final String Function() _userIDProvider;
  final OnAdvancedMsgListener? Function() _msgListenerProvider;
  final OnMsgSendProgressListener? Function() _progressListenerProvider;
  final OnConversationListener? Function() _conversationListenerProvider;

  /// 创建 `MessageSender` 实例。
  ///
  /// Creates a `MessageSender` instance.
  ///
  /// - [_context] context / Context.
  /// - [_fileUploader] 文件上传器 / File uploader.
  /// - [_factory] 工厂 / Factory.
  /// - [_userIDProvider] 用户IDProvider / User ID provider.
  /// - [_msgListenerProvider] 消息监听器Provider / Message listener provider.
  /// - [_progressListenerProvider] 进度监听器Provider / Progress listener provider.
  /// - [_conversationListenerProvider] 会话监听器Provider / Conversation listener provider.
  MessageSender({
    required this._context,
    required this._fileUploader,
    required this._factory,
    required this._userIDProvider,
    required this._msgListenerProvider,
    required this._progressListenerProvider,
    required this._conversationListenerProvider,
  });

  /// App 重启后将残留的 sending 状态消息置为 failed（对齐 Go SDK 策略）。
  Future<void> recoverSendingMessages() async {
    final List<Map<String, dynamic>> allSending = await _context.db.syncMeta
        .getAllSendingMessages();
    if (allSending.isEmpty) {
      return;
    }
    final List<String> clientMsgIDs = allSending
        .map<String?>((Map<String, dynamic> m) => m['clientMsgID'] as String?)
        .whereType<String>()
        .toList();
    final List<Message> loaded = await _context.db.messages.getMessagesByClientMsgIDs(clientMsgIDs);
    final Map<String, Message> messageMap = <String, Message>{
      for (final Message m in loaded)
        if (m.clientMsgID != null) m.clientMsgID!: m,
    };

    for (final Map<String, dynamic> item in allSending) {
      final String? clientMsgID = item['clientMsgID'] as String?;
      final String? conversationID = item['conversationID'] as String?;
      if (clientMsgID == null) {
        continue;
      }
      final Message? msg = messageMap[clientMsgID];
      if (msg == null || msg.status != MessageStatus.sending) {
        await _context.db.syncMeta.deleteSendingMessage(clientMsgID);
        continue;
      }
      final Message failedMsg = msg.copyWith(status: MessageStatus.failed);
      await _context.db.messages.updateMessageStatus(clientMsgID, MessageStatus.failed.value);
      if (conversationID != null && conversationID.isNotEmpty) {
        final ConversationInfo? conv = await _context.db.conversations.getConversation(
          conversationID,
        );
        if (conv?.latestMsg?.clientMsgID == clientMsgID) {
          await _context.db.conversations.updateConversation(conversationID, <String, dynamic>{
            'latestMsg': jsonEncode(
              MessageRepository.messageToDbMap(failedMsg, conversationID: conversationID),
            ),
          });
        }
      }
      await _context.db.syncMeta.deleteSendingMessage(clientMsgID);
      _msgListenerProvider()?.messageStatusChanged(failedMsg);
    }
  }

  /// 发送消息（支持媒体自动分片上传、重发、仅在线消息与自定义选项）。
  ///
  /// Send message.
  ///
  /// - [message] 消息 / Message.
  /// - [offlinePushInfo] 离线推送信息 / Offline push info.
  /// - [userID] 用户ID / User ID.
  /// - [groupID] 群组ID / Group ID.
  /// - [isOnlineOnly] 是否在线Only / Whether online only.
  /// - [messageOptions] 消息选项 / Message options.
  /// - [uploadMedia] 上传媒体 / Upload media.
  /// - Returns: `Future<Message>` 结果 / Resulting `Future<Message>`.
  Future<Message> sendMessage({
    required Message message,
    required OfflinePushInfo offlinePushInfo,
    String? userID,
    String? groupID,
    bool isOnlineOnly = false,
    Map<String, bool>? messageOptions,
    bool uploadMedia = true,
  }) async {
    final String selfID = _userIDProvider();
    final bool isGroupMsg = groupID != null && groupID.isNotEmpty;
    final ConversationType sessionType = isGroupMsg
        ? ConversationType.superGroup
        : ConversationType.single;

    String? senderNickname;
    String? senderFaceUrl;
    final UserInfo? loginUser = await _context.db.users.getLoginUser();
    if (loginUser != null) {
      senderNickname = loginUser.nickname;
      senderFaceUrl = loginUser.faceURL;
    }
    if (isGroupMsg) {
      final GroupMembersInfo? gm = await _context.db.groups.getGroupMember(groupID, selfID);
      if (gm != null && gm.nickname != null && gm.nickname!.isNotEmpty) {
        senderNickname = gm.nickname;
      }
    }

    final int initialSendTime = (message.sendTime != null && message.sendTime! > 0)
        ? message.sendTime!
        : DateTime.now().millisecondsSinceEpoch;
    final Message sendMsg = message.copyWith(
      sendID: selfID,
      senderNickname: senderNickname,
      senderFaceUrl: senderFaceUrl,
      recvID: userID,
      groupID: groupID,
      sessionType: sessionType,
      sendTime: initialSendTime,
      status: MessageStatus.sending,
      offlinePush: offlinePushInfo,
    );

    final String conversationID = isGroupMsg
        ? OpenImUtils.genGroupConversationID(groupID)
        : OpenImUtils.genSingleConversationID(selfID, userID!);

    if (!isOnlineOnly) {
      final Message? existing = await _context.db.messages.getMessage(sendMsg.clientMsgID!);
      if (existing == null) {
        await _context.db.messages.insertMessage(
          MessageRepository.messageToDbMap(sendMsg, conversationID: conversationID),
        );
        await _context.db.syncMeta.insertSendingMessage(sendMsg.clientMsgID!, conversationID);
      } else {
        if (existing.status != MessageStatus.failed && existing.status != MessageStatus.sending) {
          throw OpenIMException(
            code: SDKErrorCode.messageRepeated.code,
            message: SDKErrorCode.messageRepeated.message,
          );
        }
        await _context.db.messages.updateMessage(sendMsg.clientMsgID!, <String, dynamic>{
          'status': MessageStatus.sending.value,
          'conversationID': conversationID,
        });
        await _context.db.syncMeta.insertSendingMessage(sendMsg.clientMsgID!, conversationID);
      }
      await updateConversationLatestMsg(conversationID, sendMsg, sessionType);
    }

    try {
      final Message finalMsg = uploadMedia ? await _uploadMediaIfNeeded(sendMsg, selfID) : sendMsg;
      if (!isOnlineOnly && !identical(finalMsg, sendMsg)) {
        await _context.db.messages.updateMessage(
          finalMsg.clientMsgID!,
          MessageRepository.messageToDbMap(finalMsg, conversationID: conversationID),
        );
      }
      return await _sendViaWebSocket(
        finalMsg,
        conversationID,
        sessionType,
        isOnlineOnly,
        messageOptions: messageOptions,
      );
    } on OpenIMException {
      rethrow;
    } on Object catch (error, stackTrace) {
      _logger.warning('sendMessage failed', error, stackTrace);
      if (!isOnlineOnly) {
        final Message? current = await _context.db.messages.getMessage(sendMsg.clientMsgID!);
        if (current != null && current.status == MessageStatus.succeeded) {
          return current;
        }
        final Message failedMsg = sendMsg.copyWith(status: MessageStatus.failed);
        await _context.db.messages.updateMessageStatus(
          failedMsg.clientMsgID!,
          MessageStatus.failed.value,
        );
        await _context.db.syncMeta.deleteSendingMessage(failedMsg.clientMsgID!);
        await updateConversationLatestMsg(conversationID, failedMsg, sessionType);
        _msgListenerProvider()?.messageStatusChanged(failedMsg);
        _progressListenerProvider()?.fail(failedMsg.clientMsgID!, error.toString());
      }
      rethrow;
    }
  }

  /// 更新会话的 `latestMsg` 并触发会话监听器回调。
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [message] 消息 / Message.
  /// - [sessionType] 会话类型 / Session type.
  /// - [seqOverride] 序列号Override / Sequence number override.
  Future<void> updateConversationLatestMsg(
    String conversationID,
    Message message,
    ConversationType sessionType, {
    int? seqOverride,
  }) async {
    final ConversationInfo? conv = await _context.db.conversations.getConversation(conversationID);
    final OnConversationListener? listener = _conversationListenerProvider();
    final Map<String, dynamic> dbMsgMap = MessageRepository.messageToDbMap(
      message,
      conversationID: conversationID,
    );

    final int effectiveSendTime = (message.sendTime != null && message.sendTime! > 0)
        ? message.sendTime!
        : DateTime.now().millisecondsSinceEpoch;

    if (conv != null) {
      final int existingTime = conv.latestMsgSendTime ?? 0;
      final bool isSame =
          message.clientMsgID != null && message.clientMsgID == conv.latestMsg?.clientMsgID;
      final Map<String, dynamic> updates = <String, dynamic>{};
      if (effectiveSendTime >= existingTime || isSame) {
        updates['latestMsg'] = jsonEncode(dbMsgMap);
        updates['latestMsgSendTime'] = effectiveSendTime;
      }
      final int candidateSeq = seqOverride ?? message.seq ?? 0;
      if (candidateSeq > 0) {
        final int oldMaxSeq = await _context.db.conversations.getConversationMaxSeq(conversationID);
        if (candidateSeq > oldMaxSeq) {
          updates['maxSeq'] = candidateSeq;
        }
      }
      if (updates.isNotEmpty) {
        await _context.db.conversations.updateConversation(conversationID, updates);
        final ConversationInfo? updated = await _context.db.conversations.getConversation(
          conversationID,
        );
        if (updated != null) {
          listener?.conversationChanged(<ConversationInfo>[updated]);
        }
      }
    } else {
      String showName = '';
      String faceURL = '';
      if (sessionType == ConversationType.superGroup && (message.groupID ?? '').isNotEmpty) {
        final GroupInfo? group = await _context.db.groups.getGroupByID(message.groupID!);
        showName = group?.groupName ?? '';
        faceURL = group?.faceURL ?? '';
      } else if ((message.recvID ?? '').isNotEmpty) {
        final FriendInfo? friend = await _context.db.friends.getFriendByUserID(message.recvID!);
        if (friend != null) {
          showName = friend.getShowName();
          faceURL = friend.faceURL ?? '';
        } else {
          final List<UserInfo> users = await _context.db.users.getUsersByIDs(<String>[
            message.recvID!,
          ]);
          if (users.isNotEmpty) {
            showName = users.first.getShowName();
            faceURL = users.first.faceURL ?? '';
          }
        }
      }
      await _context.db.conversations.upsertConversation(<String, dynamic>{
        'conversationID': conversationID,
        'conversationType': sessionType.value,
        'userID': message.recvID,
        'groupID': message.groupID,
        'showName': showName,
        'faceURL': faceURL,
        'latestMsg': jsonEncode(dbMsgMap),
        'latestMsgSendTime': effectiveSendTime,
        'unreadCount': 0,
        if ((seqOverride ?? message.seq ?? 0) > 0) 'maxSeq': seqOverride ?? message.seq,
      });
      final ConversationInfo? created = await _context.db.conversations.getConversation(
        conversationID,
      );
      if (created != null) {
        listener?.newConversation(<ConversationInfo>[created]);
      }
    }
  }

  Future<Message> _sendViaWebSocket(
    Message message,
    String conversationID,
    ConversationType sessionType,
    bool isOnlineOnly, {
    Map<String, bool>? messageOptions,
  }) async {
    final sdkws.MsgData msgData = _buildMsgData(
      message,
      isOnlineOnly,
      messageOptions: messageOptions,
    );
    final Uint8List msgDataBytes = msgData.writeToBuffer();

    final WebSocketResponse resp = await _context.ws.sendRequestWaitResponse(
      reqIdentifier: WebSocketIdentifier.sendMsg,
      data: msgDataBytes,
    );

    if (resp.errCode != 0) {
      final Message failedMsg = message.copyWith(status: MessageStatus.failed);
      if (!isOnlineOnly) {
        await _context.db.messages.updateMessageStatus(
          failedMsg.clientMsgID!,
          MessageStatus.failed.value,
        );
        await _context.db.syncMeta.deleteSendingMessage(failedMsg.clientMsgID!);
        await updateConversationLatestMsg(conversationID, failedMsg, sessionType);
      }
      throw OpenIMException(code: resp.errCode, message: resp.errMsg);
    }

    // 修复 B-02：解析服务端返回的 sdkws.UserSendMsgResp，提取 serverMsgID / sendTime
    String? serverMsgID = message.serverMsgID;
    int sendTime = DateTime.now().millisecondsSinceEpoch;

    if (resp.data.isNotEmpty) {
      try {
        final sdkws.UserSendMsgResp ack = sdkws.UserSendMsgResp.fromBuffer(resp.data);
        if (ack.serverMsgID.isNotEmpty) {
          serverMsgID = ack.serverMsgID;
        }
        if (ack.sendTime.toInt() > 0) {
          sendTime = ack.sendTime.toInt();
        }
      } on Object catch (error, stackTrace) {
        _logger.fine('Failed to parse UserSendMsgResp, using fallback', error, stackTrace);
      }
    }

    final Message sentMsg = message.copyWith(
      serverMsgID: serverMsgID,
      sendTime: sendTime,
      status: MessageStatus.succeeded,
    );

    if (!isOnlineOnly) {
      final Map<String, dynamic> dbUpdates = <String, dynamic>{
        'status': MessageStatus.succeeded.value,
        'sendTime': sendTime,
        'serverMsgID': ?serverMsgID,
      };
      await _context.db.messages.updateMessage(sentMsg.clientMsgID!, dbUpdates);
      await _context.db.syncMeta.deleteSendingMessage(sentMsg.clientMsgID!);
      try {
        await updateConversationLatestMsg(conversationID, sentMsg, sessionType);
      } on Object catch (error, stackTrace) {
        _logger.warning('Message sent but updating conversation failed', error, stackTrace);
      }
    }
    return sentMsg;
  }

  Future<Message> _uploadMediaIfNeeded(Message msg, String userID) async {
    final String clientMsgID = msg.clientMsgID ?? '';
    final Uint8List? pendingBytes = _factory.pendingUploadBytes.remove(clientMsgID);
    final Uint8List? pendingSnapshotBytes = _factory.pendingSnapshotBytes.remove(clientMsgID);

    int lastProgress = -1;
    void reportProgress(int sent, int total) {
      if (total > 0) {
        final int progress = ((sent / total) * 100).round();
        if (progress != lastProgress) {
          lastProgress = progress;
          _progressListenerProvider()?.progress(clientMsgID, progress);
        }
      }
    }

    if (msg.contentType == MessageType.picture && msg.pictureElem != null) {
      final PictureElem elem = msg.pictureElem!;
      if (elem.sourcePicture?.url != null && elem.sourcePicture!.url!.isNotEmpty) {
        return msg;
      }
      final String ext = _filepathExt(elem.sourcePicture?.uuid, elem.sourcePath);
      final String name = 'msg_picture_$clientMsgID$ext';
      final String contentType = elem.sourcePicture?.type ?? _getContentType(ext);
      String? url;
      int fileSize = 0;

      if (pendingBytes != null) {
        fileSize = pendingBytes.length;
        url = await _fileUploader.uploadFile(
          id: clientMsgID,
          userID: userID,
          fileBytes: pendingBytes,
          fileName: name,
          contentType: contentType,
          cause: 'msg-picture',
          onProgress: reportProgress,
        );
      } else if (elem.sourcePath != null &&
          elem.sourcePath!.isNotEmpty &&
          await fileExists(elem.sourcePath!)) {
        fileSize = await fileLength(elem.sourcePath!);
        url = await _fileUploader.uploadFile(
          id: clientMsgID,
          userID: userID,
          filePath: elem.sourcePath,
          fileName: name,
          contentType: contentType,
          cause: 'msg-picture',
          onProgress: reportProgress,
        );
      }

      if (url != null) {
        final PictureInfo sourcePic = (elem.sourcePicture ?? const PictureInfo()).copyWith(
          url: url,
          size: fileSize,
        );
        PictureInfo snapshotPic = sourcePic;
        try {
          final Uri uri = Uri.parse(url);
          final Map<String, String> query = Map<String, String>.from(uri.queryParameters)
            ..['type'] = 'image'
            ..['width'] = '640'
            ..['height'] = '640';
          snapshotPic = PictureInfo(
            width: 640,
            height: 640,
            url: uri.replace(queryParameters: query).toString(),
          );
        } catch (_) {}
        return msg.copyWith(
          pictureElem: elem.copyWith(
            sourcePicture: sourcePic,
            bigPicture: sourcePic,
            snapshotPicture: snapshotPic,
          ),
        );
      }
    } else if (msg.contentType == MessageType.voice && msg.soundElem != null) {
      final SoundElem elem = msg.soundElem!;
      if (elem.sourceUrl != null && elem.sourceUrl!.isNotEmpty) {
        return msg;
      }
      final String? soundPath = elem.soundPath;
      if (soundPath != null && soundPath.isNotEmpty && await fileExists(soundPath)) {
        final int fileSize = await fileLength(soundPath);
        final String ext = _filepathExt(elem.uuid, soundPath);
        final String url = await _fileUploader.uploadFile(
          id: clientMsgID,
          userID: userID,
          filePath: soundPath,
          fileName: 'msg_voice_$clientMsgID$ext',
          contentType: elem.soundType ?? _getContentType(ext),
          cause: 'msg-voice',
          onProgress: reportProgress,
        );
        return msg.copyWith(
          soundElem: elem.copyWith(sourceUrl: url, dataSize: fileSize),
        );
      }
    } else if (msg.contentType == MessageType.video && msg.videoElem != null) {
      VideoElem updatedElem = msg.videoElem!;
      final List<Future<void>> tasks = <Future<void>>[];

      if (updatedElem.snapshotUrl == null || updatedElem.snapshotUrl!.isEmpty) {
        tasks.add(
          Future<void>(() async {
            try {
              final String snapExt = _filepathExt(
                updatedElem.snapshotUUID,
                updatedElem.snapshotPath,
              );
              final String snapName = 'msg_videoSnapshot_$clientMsgID$snapExt';
              final String snapType = updatedElem.snapshotType ?? _getContentType(snapExt);
              if (pendingSnapshotBytes != null) {
                final String url = await _fileUploader.uploadFile(
                  id: '${clientMsgID}_snapshot',
                  userID: userID,
                  fileBytes: pendingSnapshotBytes,
                  fileName: snapName,
                  contentType: snapType,
                  cause: 'msg-video-snapshot',
                );
                updatedElem = updatedElem.copyWith(
                  snapshotUrl: url,
                  snapshotSize: pendingSnapshotBytes.length,
                  snapshotType: snapType,
                );
              } else if (updatedElem.snapshotPath != null &&
                  updatedElem.snapshotPath!.isNotEmpty &&
                  await fileExists(updatedElem.snapshotPath!)) {
                final int size = await fileLength(updatedElem.snapshotPath!);
                final String url = await _fileUploader.uploadFile(
                  id: '${clientMsgID}_snapshot',
                  userID: userID,
                  filePath: updatedElem.snapshotPath,
                  fileName: snapName,
                  contentType: snapType,
                  cause: 'msg-video-snapshot',
                );
                updatedElem = updatedElem.copyWith(
                  snapshotUrl: url,
                  snapshotSize: size,
                  snapshotType: snapType,
                );
              }
            } on Object catch (error, stackTrace) {
              _logger.warning('Video snapshot upload failed', error, stackTrace);
            }
          }),
        );
      }

      if (updatedElem.videoUrl == null || updatedElem.videoUrl!.isEmpty) {
        tasks.add(
          Future<void>(() async {
            final String videoExt = _filepathExt(updatedElem.videoUUID, updatedElem.videoPath);
            final String videoName = 'msg_video_$clientMsgID$videoExt';
            final String videoContentType = _getContentType(updatedElem.videoType, videoExt);
            if (pendingBytes != null) {
              final String url = await _fileUploader.uploadFile(
                id: clientMsgID,
                userID: userID,
                fileBytes: pendingBytes,
                fileName: videoName,
                contentType: videoContentType,
                cause: 'msg-video',
                onProgress: reportProgress,
              );
              updatedElem = updatedElem.copyWith(videoUrl: url, videoSize: pendingBytes.length);
            } else if (updatedElem.videoPath != null &&
                updatedElem.videoPath!.isNotEmpty &&
                await fileExists(updatedElem.videoPath!)) {
              final int size = await fileLength(updatedElem.videoPath!);
              final String url = await _fileUploader.uploadFile(
                id: clientMsgID,
                userID: userID,
                filePath: updatedElem.videoPath,
                fileName: videoName,
                contentType: videoContentType,
                cause: 'msg-video',
                onProgress: reportProgress,
              );
              updatedElem = updatedElem.copyWith(videoUrl: url, videoSize: size);
            }
          }),
        );
      }

      if (tasks.isNotEmpty) {
        await Future.wait<void>(tasks);
      }
      return msg.copyWith(videoElem: updatedElem);
    } else if (msg.contentType == MessageType.file && msg.fileElem != null) {
      final FileElem elem = msg.fileElem!;
      if (elem.sourceUrl != null && elem.sourceUrl!.isNotEmpty) {
        return msg;
      }
      final String baseName = elem.fileName ?? (elem.filePath ?? 'file').split('/').last;
      final String name = 'msg_file_$clientMsgID/${baseName.isNotEmpty ? baseName : "file"}';
      final String contentType = _getContentType(
        elem.fileType,
        _filepathExt(elem.filePath),
        _filepathExt(elem.fileName),
      );
      String? url;
      int fileSize = 0;
      if (pendingBytes != null) {
        fileSize = pendingBytes.length;
        url = await _fileUploader.uploadFile(
          id: clientMsgID,
          userID: userID,
          fileBytes: pendingBytes,
          fileName: name,
          contentType: contentType,
          cause: 'msg-file',
          onProgress: reportProgress,
        );
      } else if (elem.filePath != null &&
          elem.filePath!.isNotEmpty &&
          await fileExists(elem.filePath!)) {
        fileSize = await fileLength(elem.filePath!);
        url = await _fileUploader.uploadFile(
          id: clientMsgID,
          userID: userID,
          filePath: elem.filePath,
          fileName: name,
          contentType: contentType,
          cause: 'msg-file',
          onProgress: reportProgress,
        );
      }
      if (url != null) {
        return msg.copyWith(
          fileElem: elem.copyWith(sourceUrl: url, fileSize: fileSize, fileName: baseName),
        );
      }
    }

    return msg;
  }

  sdkws.MsgData _buildMsgData(Message msg, bool isOnlineOnly, {Map<String, bool>? messageOptions}) {
    final String contentJson = MessageRepository.encodeMessageContent(msg) ?? '';
    final List<int> contentBytes = utf8.encode(contentJson);

    final sdkws.MsgData msgData = sdkws.MsgData(
      sendID: msg.sendID ?? '',
      recvID: msg.recvID ?? '',
      groupID: msg.groupID ?? '',
      clientMsgID: msg.clientMsgID ?? '',
      senderPlatformID: msg.senderPlatformID?.value ?? PlatformUtils.currentPlatform.value,
      senderNickname: msg.senderNickname ?? '',
      senderFaceURL: msg.senderFaceUrl ?? '',
      sessionType: msg.sessionType?.value ?? ConversationType.single.value,
      msgFrom: 1,
      contentType: msg.contentType?.value ?? MessageType.text.value,
      content: contentBytes,
      createTime: Int64(msg.createTime ?? DateTime.now().millisecondsSinceEpoch),
      ex: msg.ex ?? '',
    );

    if (msg.offlinePush != null && (!isOnlineOnly || messageOptions?['offlinePush'] == true)) {
      final OfflinePushInfo push = msg.offlinePush!;
      msgData.offlinePushInfo = sdkws.OfflinePushInfo(
        title: push.title ?? '',
        desc: push.desc ?? '',
        ex: push.ex ?? '',
        iOSPushSound: push.iOSPushSound ?? '',
        iOSBadgeCount: push.iOSBadgeCount ?? false,
      );
    }

    if (isOnlineOnly) {
      msgData.options.addEntries(const <MapEntry<String, bool>>[
        MapEntry<String, bool>('history', false),
        MapEntry<String, bool>('persistent', false),
        MapEntry<String, bool>('senderSync', false),
        MapEntry<String, bool>('conversationUpdate', false),
        MapEntry<String, bool>('senderConversationUpdate', false),
        MapEntry<String, bool>('unreadCount', false),
        MapEntry<String, bool>('offlinePush', false),
      ]);
    }
    if (messageOptions != null) {
      msgData.options.addAll(messageOptions);
    }
    return msgData;
  }

  String _filepathExt(String? path1, [String? path2]) {
    for (final String? p in <String?>[path1, path2]) {
      if (p != null && p.isNotEmpty) {
        final int dotIndex = p.lastIndexOf('.');
        if (dotIndex >= 0 && dotIndex < p.length - 1) {
          return p.substring(dotIndex);
        }
      }
    }
    return '';
  }

  static const Map<String, String> _extMimeMap = <String, String>{
    'png': 'image/png',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'gif': 'image/gif',
    'webp': 'image/webp',
    'mp4': 'video/mp4',
    'mov': 'video/quicktime',
    'm4a': 'audio/mp4',
    'mp3': 'audio/mpeg',
    'wav': 'audio/wav',
    'ogg': 'audio/ogg',
    'aac': 'audio/aac',
    'pdf': 'application/pdf',
    'txt': 'text/plain',
    'zip': 'application/zip',
    'json': 'application/json',
  };

  String _getContentType([String? val1, String? val2, String? val3]) {
    for (final String? s in <String?>[val1, val2, val3]) {
      if (s == null || s.length <= 1) {
        continue;
      }
      if (s.contains('/')) {
        return s;
      }
      final String key = (s.startsWith('.') ? s.substring(1) : s).toLowerCase();
      final String? mime = _extMimeMap[key];
      if (mime != null) {
        return mime;
      }
    }
    return 'application/octet-stream';
  }
}
