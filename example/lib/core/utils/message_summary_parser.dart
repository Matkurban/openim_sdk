import 'dart:convert';

import 'package:openim_sdk/openim_sdk.dart';

/// 全类型消息与会话列表最新消息摘要解析引擎。
///
/// Unified parser for conversation list previews, `@`-mention text resolution,
/// burn-after-reading masking, call signal logs, meeting cards, and 20+ system notifications.
abstract final class MessageSummaryParser {
  /// 解析会话列表单行摘要文本（综合草稿、`@我` 提醒、发送状态、阅后即焚脱敏与全类型消息）。
  static String formatConversationSummary(
    ConversationInfo conversation, {
    required String selfUserId,
  }) {
    final String draft = (conversation.draftText ?? '').trim();
    if (draft.isNotEmpty) {
      return '[草稿] $draft';
    }
    final Message? latest = conversation.latestMsg;
    if (latest == null) {
      return '';
    }

    final bool isBurn = isBurnAfterReading(latest);
    final String body = isBurn
        ? '[阅后即焚] ${_burnTypeLabel(latest)}'
        : summarizeMessage(latest, selfUserId: selfUserId);
    if (body.isEmpty) {
      return '';
    }

    final StringBuffer buffer = StringBuffer();
    final bool isCall = latest.contentType == MessageType.callSignal;
    if (!isCall && latest.status == MessageStatus.failed) {
      buffer.write('[发送失败] ');
    }

    final bool hasAtSelf =
        conversation.groupAtType == GroupAtType.atMe ||
        conversation.groupAtType == GroupAtType.atAllAtMe;
    final bool hasAtAll = conversation.groupAtType == GroupAtType.atAll;
    if (conversation.unreadCount > 0) {
      if (hasAtSelf) {
        buffer.write('[有人@我] ');
      } else if (hasAtAll) {
        buffer.write('[@所有人] ');
      }
    }

    buffer.write(body);
    return buffer.toString();
  }

  /// 判断消息是否为阅后即焚消息。
  static bool isBurnAfterReading(Message message) {
    return message.attachedInfoElem?.isPrivateChat == true;
  }

  /// 将任意类型 [Message] 解析为简洁、人类可读的单行摘要（复用于会话列表、引用回复与搜索）。
  static String summarizeMessage(
    Message message, {
    required String selfUserId,
  }) {
    final MessageType? type = message.contentType;
    switch (type) {
      case MessageType.text:
        return message.textElem?.content ?? '';
      case MessageType.atText:
        return resolveAtText(message.atTextElem);
      case MessageType.advancedText:
        return message.advancedTextElem?.text ?? '[富文本消息]';
      case MessageType.markdownText:
        return message.textElem?.content ??
            message.advancedTextElem?.text ??
            '[Markdown 消息]';
      case MessageType.quote:
        return message.quoteElem?.text ?? '[引用消息]';
      case MessageType.picture:
        return '[图片]';
      case MessageType.voice:
        final int duration = message.soundElem?.duration ?? 0;
        return duration > 0 ? '[语音] $duration"' : '[语音]';
      case MessageType.video:
        return '[视频]';
      case MessageType.file:
        final String name = (message.fileElem?.fileName ?? '').trim();
        return name.isNotEmpty ? '[文件] $name' : '[文件]';
      case MessageType.location:
        final String desc = (message.locationElem?.description ?? '').trim();
        return desc.isNotEmpty ? '[位置] $desc' : '[位置]';
      case MessageType.card:
        final String nick = (message.cardElem?.nickname ?? '').trim();
        return nick.isNotEmpty ? '[名片] $nick' : '[个人名片]';
      case MessageType.merger:
        final String title = (message.mergeElem?.title ?? '').trim();
        return title.isNotEmpty ? '[聊天记录] $title' : '[聊天记录]';
      case MessageType.customFace:
        return '[动画表情]';
      case MessageType.callSignal:
        return formatCallSignal(message, selfUserId: selfUserId);
      case MessageType.redPacket:
        final String greeting = (message.redPacketElem?.greeting ?? '').trim();
        return greeting.isNotEmpty ? '[红包] $greeting' : '[红包] 恭喜发财';
      case MessageType.redPacketGrabNotify:
        return formatRedPacketGrab(message, selfUserId: selfUserId);
      case MessageType.conference:
        return formatConferenceSummary(message);
      case MessageType.meetingReminder:
        return formatMeetingReminderSummary(message);
      case MessageType.meetingScheduleNotify:
        return formatMeetingScheduleSummary(message);
      case MessageType.custom:
      case MessageType.customMsgNotTriggerConversation:
      case MessageType.customMsgOnlineOnly:
        return _formatCustomSummary(message);
      default:
        if ((type?.value ?? 0) >= 1000) {
          return formatNotification(message, selfUserId: selfUserId);
        }
        return message.textElem?.content ?? '[未知消息]';
    }
  }

  /// 将 `@userID` 占位符替换为可读 `@昵称` / `@所有人`。
  static String resolveAtText(AtTextElem? elem) {
    String text = elem?.text ?? '';
    if (text.isEmpty) {
      return '[@消息]';
    }
    final List<AtUserInfo> infos = elem?.atUsersInfo ?? const <AtUserInfo>[];
    for (final AtUserInfo info in infos) {
      final String uid = info.atUserID ?? '';
      if (uid.isEmpty) {
        continue;
      }
      final String replacement = uid == 'atAllTag'
          ? '所有人'
          : ((info.groupNickname ?? '').isNotEmpty ? info.groupNickname! : uid);
      text = text.replaceAll('@$uid', '@$replacement');
    }
    return text.replaceAll('@atAllTag', '@所有人');
  }

  /// 解析音视频通话信令摘要（区分音/视频、主被叫与通话时长）。
  static String formatCallSignal(
    Message message, {
    required String selfUserId,
  }) {
    final CallSignalElem? elem = message.callSignalElem;
    final bool isVideo = elem?.callType == CallType.video;
    final String kind = isVideo ? '视频通话' : '语音通话';
    final bool isSelf = message.sendID == selfUserId;
    final int seconds = elem?.duration ?? 0;

    return switch (elem?.callSignalType) {
      CallSignalType.invite => isSelf ? '发起了$kind' : '邀请你进行$kind',
      CallSignalType.accept => '已接通$kind',
      CallSignalType.reject => isSelf ? '已拒绝$kind' : '对方已拒绝$kind',
      CallSignalType.cancel => isSelf ? '已取消$kind' : '对方已取消$kind',
      CallSignalType.noResponse => isSelf ? '对方无应答' : '未接听$kind',
      CallSignalType.hungup =>
        seconds > 0 ? '$kind时长 ${formatDuration(seconds)}' : '$kind已结束',
      null => '[$kind]',
    };
  }

  /// 解析红包领取提示。
  static String formatRedPacketGrab(
    Message message, {
    required String selfUserId,
  }) {
    final RedPacketGrabNotifyElem? grab = message.redPacketGrabNotifyElem;
    if (grab == null) {
      return '有人领取了红包';
    }
    final String grabber = grab.grabberID == selfUserId
        ? '你'
        : (grab.grabberName.isNotEmpty ? grab.grabberName : grab.grabberID);
    final String sender = grab.senderID == selfUserId
        ? '你'
        : (grab.senderName.isNotEmpty ? grab.senderName : grab.senderID);
    return '$grabber领取了$sender的红包';
  }

  /// 解析会议邀请卡片数据（`contentType == 127`）。
  static Map<String, dynamic> parseStructuredPayload(Message message) {
    final List<String?> candidates = <String?>[
      message.customElem?.data,
      message.notificationElem?.detail,
      message.ex,
    ];
    for (final String? raw in candidates) {
      if (raw == null || raw.trim().isEmpty) {
        continue;
      }
      try {
        final Object? decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } on Object catch (_) {}
    }
    return message.exMap;
  }

  /// 解析会议邀请单行摘要。
  static String formatConferenceSummary(Message message) {
    final Map<String, dynamic> map = parseStructuredPayload(message);
    final String title = _readString(map, <String>['title', 'meetingName']);
    final bool ended = map['isEnded'] == true || map['status'] == 'ended';
    if (title.isNotEmpty) {
      return ended ? '[会议已结束] $title' : '[会议] $title';
    }
    return ended ? '[会议已结束]' : '[会议进行中]';
  }

  /// 解析会议开始提醒单行摘要。
  static String formatMeetingReminderSummary(Message message) {
    final Map<String, dynamic> map = parseStructuredPayload(message);
    final String title = _readString(map, <String>['title', 'meetingName']);
    final int mins = _readInt(map, <String>['remindMinutes', 'minutes']);
    final String name = title.isNotEmpty ? title : '预约会议';
    return mins > 0 ? '[会议提醒] $name 将在 $mins 分钟后开始' : '[会议提醒] $name 即将开始';
  }

  /// 解析会议日程变更通知单行摘要。
  static String formatMeetingScheduleSummary(Message message) {
    final Map<String, dynamic> map = parseStructuredPayload(message);
    final String title = _readString(map, <String>['title', 'meetingName']);
    final String action = _readString(map, <String>['action', 'type']);
    final String label = switch (action) {
      'created' || 'booked' => '预约了会议',
      'updated' || 'rescheduled' => '修改了会议日程',
      'cancelled' || 'canceled' => '取消了会议',
      'removed' => '移出了会议日程',
      _ => '更新了会议日程',
    };
    return title.isNotEmpty ? '[日程通知] $label「$title」' : '[日程通知] $label';
  }

  /// 解析全部 20+ 种系统/群组/好友/OA/撤回通知消息。
  static String formatNotification(
    Message message, {
    required String selfUserId,
  }) {
    final Map<String, dynamic> detail = parseStructuredPayload(message);
    final String opName = _extractUserName(detail['opUser'], selfUserId);

    switch (message.contentType) {
      case MessageType.friendApplicationApprovedNotification:
      case MessageType.friendAddedNotification:
        return '你们已经成为好友，现在可以开始聊天了';
      case MessageType.groupCreatedNotification:
        return opName.isNotEmpty ? '$opName 创建了群聊' : '已创建群聊';
      case MessageType.groupInfoSetNotification:
        return opName.isNotEmpty ? '$opName 修改了群资料' : '群资料已更新';
      case MessageType.groupInfoSetNameNotification:
        final String groupName = _extractGroupField(detail, 'groupName');
        if (groupName.isNotEmpty) {
          return opName.isNotEmpty
              ? '$opName 将群名称修改为「$groupName」'
              : '群名称已修改为「$groupName」';
        }
        return '群名称已修改';
      case MessageType.groupInfoSetAnnouncementNotification:
        final String ann = _extractGroupField(detail, 'notification');
        if (ann.isNotEmpty) {
          return opName.isNotEmpty ? '$opName 更新了群公告：$ann' : '群公告：$ann';
        }
        return '群公告已更新';
      case MessageType.memberQuitNotification:
        final String quitName = _extractUserName(
          detail['quitUser'],
          selfUserId,
        );
        return quitName.isNotEmpty ? '$quitName 退出了群聊' : '有成员退出了群聊';
      case MessageType.groupOwnerTransferredNotification:
        final String newOwner = _extractUserName(
          detail['newGroupOwner'],
          selfUserId,
        );
        if (opName.isNotEmpty && newOwner.isNotEmpty) {
          return '$opName 已将群主转让给 $newOwner';
        }
        return '群主已变更';
      case MessageType.memberKickedNotification:
        final String kicked = _extractUserList(
          detail['kickedUserList'],
          selfUserId,
        );
        if (opName.isNotEmpty && kicked.isNotEmpty) {
          return '$opName 将 $kicked 移出了群聊';
        }
        return '有成员被移出群聊';
      case MessageType.memberInvitedNotification:
        final String invited = _extractUserList(
          detail['invitedUserList'],
          selfUserId,
        );
        if (opName.isNotEmpty && invited.isNotEmpty) {
          return '$opName 邀请 $invited 加入了群聊';
        }
        return '有新成员被邀请入群';
      case MessageType.memberEnterNotification:
        final String entrant = _extractUserName(
          detail['entrantUser'],
          selfUserId,
        );
        return entrant.isNotEmpty ? '$entrant 加入了群聊' : '有新成员加入了群聊';
      case MessageType.dismissGroupNotification:
        return opName.isNotEmpty ? '$opName 解散了群聊' : '群聊已解散';
      case MessageType.groupMemberMutedNotification:
        final String mutedUser = _extractUserName(
          detail['mutedUser'],
          selfUserId,
        );
        final int secs = _readInt(detail, <String>['mutedSeconds']);
        final String dur = secs > 0 ? formatMutedDuration(secs) : '';
        if (mutedUser.isNotEmpty) {
          return '$mutedUser 被${opName.isNotEmpty ? ' $opName ' : ''}禁言$dur';
        }
        return '有成员被禁言';
      case MessageType.groupMemberCancelMutedNotification:
        final String mutedUser = _extractUserName(
          detail['mutedUser'],
          selfUserId,
        );
        return mutedUser.isNotEmpty ? '$mutedUser 已被解除禁言' : '有成员被解除禁言';
      case MessageType.groupMutedNotification:
        return opName.isNotEmpty ? '$opName 开启了全员禁言' : '已开启全员禁言';
      case MessageType.groupCancelMutedNotification:
        return opName.isNotEmpty ? '$opName 关闭了全员禁言' : '已关闭全员禁言';
      case MessageType.groupMemberSetToAdminNotification:
        final String target = _extractUserName(
          detail['changedUser'],
          selfUserId,
        );
        return target.isNotEmpty ? '$target 被设为群管理员' : '群管理员已更新';
      case MessageType.groupMemberSetToOrdinaryUserNotification:
        final String target = _extractUserName(
          detail['changedUser'],
          selfUserId,
        );
        return target.isNotEmpty ? '$target 已被取消群管理员' : '群管理员已更新';
      case MessageType.conversationPrivateChatNotification:
        final bool enabled = detail['isPrivate'] == true;
        return enabled ? '已开启阅后即焚' : '已关闭阅后即焚';
      case MessageType.oaNotification:
        final String oaText = _readString(detail, <String>[
          'text',
          'notificationName',
        ]);
        return oaText.isNotEmpty ? oaText : '[系统通知]';
      case MessageType.revokeMessageNotification:
        final String revokerId = _readString(detail, <String>['revokerID']);
        final String revokerNick = _readString(detail, <String>[
          'revokerNickname',
        ]);
        final String who = revokerId == selfUserId
            ? '你'
            : (revokerNick.isNotEmpty
                  ? revokerNick
                  : (message.senderNickname ?? '对方'));
        return '$who 撤回了一条消息';
      default:
        final String tips = (message.notificationElem?.defaultTips ?? '')
            .trim();
        return tips.isNotEmpty ? tips : '系统通知';
    }
  }

  /// 格式化秒级时长为 `mm:ss`。
  static String formatDuration(int totalSeconds) {
    final int m = totalSeconds ~/ 60;
    final int s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// 格式化禁言时长（天/小时/分钟/秒）。
  static String formatMutedDuration(int seconds) {
    if (seconds >= 86400) {
      return ' ${seconds ~/ 86400} 天';
    }
    if (seconds >= 3600) {
      return ' ${seconds ~/ 3600} 小时';
    }
    if (seconds >= 60) {
      return ' ${seconds ~/ 60} 分钟';
    }
    return ' $seconds 秒';
  }

  static String _burnTypeLabel(Message message) {
    return switch (message.contentType) {
      MessageType.text ||
      MessageType.atText ||
      MessageType.quote ||
      MessageType.advancedText ||
      MessageType.markdownText => '[文本]',
      MessageType.picture => '[图片]',
      MessageType.video => '[视频]',
      MessageType.voice => '[语音]',
      MessageType.file => '[文件]',
      MessageType.location => '[位置]',
      MessageType.card => '[名片]',
      MessageType.merger => '[聊天记录]',
      _ => '[消息]',
    };
  }

  static String _formatCustomSummary(Message message) {
    final String desc = (message.customElem?.description ?? '').trim();
    if (desc.isNotEmpty) {
      return desc;
    }
    final Map<String, dynamic> map = parseStructuredPayload(message);
    final String title = _readString(map, <String>['title', 'text', 'summary']);
    return title.isNotEmpty ? title : '[自定义消息]';
  }

  static String _extractUserName(Object? raw, String selfUserId) {
    if (raw is! Map<String, dynamic>) {
      return '';
    }
    final String uid = (raw['userID'] as String?) ?? '';
    if (uid.isNotEmpty && uid == selfUserId) {
      return '你';
    }
    final String nick = (raw['nickname'] as String?) ?? '';
    return nick.isNotEmpty ? nick : uid;
  }

  static String _extractUserList(Object? raw, String selfUserId) {
    if (raw is! List<dynamic>) {
      return '';
    }
    return raw
        .map((dynamic item) => _extractUserName(item, selfUserId))
        .where((String name) => name.isNotEmpty)
        .join('、');
  }

  static String _extractGroupField(Map<String, dynamic> detail, String field) {
    final Object? group = detail['group'];
    if (group is Map<String, dynamic>) {
      return (group[field] as String?)?.trim() ?? '';
    }
    return '';
  }

  static String _readString(Map<String, dynamic> map, List<String> keys) {
    for (final String k in keys) {
      final Object? v = map[k];
      if (v is String && v.trim().isNotEmpty) {
        return v.trim();
      }
    }
    return '';
  }

  static int _readInt(Map<String, dynamic> map, List<String> keys) {
    for (final String k in keys) {
      final Object? v = map[k];
      if (v is num) {
        return v.toInt();
      }
    }
    return 0;
  }
}
