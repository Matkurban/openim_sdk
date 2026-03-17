import 'dart:convert';

import 'package:openim_sdk/openim_sdk.dart';

/// 数据库 Map 转 Message 对象
Message convertMessage(Map<String, dynamic> data) {
  final int? contentTypeValue = data['contentType'] as int?;
  final String? content = data['content'] as String?;
  Map<String, dynamic>? contentMap;
  if (content != null && content.isNotEmpty) {
    try {
      contentMap = jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      try {
        contentMap = jsonDecode(utf8.decode(base64Decode(content))) as Map<String, dynamic>;
      } catch (_) {}
    }
  }

  return Message(
    clientMsgID: data['clientMsgID'] as String?,
    serverMsgID: data['serverMsgID'] as String?,
    createTime: data['createTime'] as int?,
    sendTime: data['sendTime'] as int?,
    sessionType: (data['sessionType'] as int?) == null
        ? null
        : ConversationType.fromValue(data['sessionType']),
    sendID: data['sendID'] as String?,
    recvID: data['recvID'] as String?,
    msgFrom: data['msgFrom'] as int?,
    contentType: contentTypeValue == null ? null : MessageType.fromValue(contentTypeValue),
    senderPlatformID: (data['senderPlatformID'] as int?) == null
        ? null
        : IMPlatform.fromValue(data['senderPlatformID']),
    senderNickname: data['senderNickname'] as String?,
    senderFaceUrl: data['senderFaceUrl'] as String?,
    groupID: data['groupID'] as String?,
    localEx: data['localEx'] as String?,
    seq: data['seq'] as int?,
    isRead: data['isRead'] as bool?,
    hasReadTime: data['hasReadTime'] as int?,
    status: (data['status'] as int?) == null ? null : MessageStatus.fromValue(data['status']),
    isReact: data['isReact'] as bool?,
    isExternalExtensions: data['isExternalExtensions'] as bool?,
    attachedInfo: data['attachedInfo'] as String?,
    ex: data['ex'] as String?,
    textElem: contentTypeValue == MessageType.text.value && contentMap != null
        ? TextElem.fromJson(contentMap)
        : null,
    pictureElem: contentTypeValue == MessageType.picture.value && contentMap != null
        ? PictureElem.fromJson(contentMap)
        : null,
    soundElem: contentTypeValue == MessageType.voice.value && contentMap != null
        ? SoundElem.fromJson(contentMap)
        : null,
    videoElem: contentTypeValue == MessageType.video.value && contentMap != null
        ? VideoElem.fromJson(contentMap)
        : null,
    fileElem: contentTypeValue == MessageType.file.value && contentMap != null
        ? FileElem.fromJson(contentMap)
        : null,
    locationElem: contentTypeValue == MessageType.location.value && contentMap != null
        ? LocationElem.fromJson(contentMap)
        : null,
    customElem: contentTypeValue == MessageType.custom.value && contentMap != null
        ? CustomElem.fromJson(contentMap)
        : null,
    quoteElem: contentTypeValue == MessageType.quote.value && contentMap != null
        ? QuoteElem.fromJson(contentMap)
        : null,
    mergeElem: contentTypeValue == MessageType.merger.value && contentMap != null
        ? MergeElem.fromJson(contentMap)
        : null,
    faceElem: contentTypeValue == MessageType.customFace.value && contentMap != null
        ? FaceElem.fromJson(contentMap)
        : null,
    cardElem: contentTypeValue == MessageType.card.value && contentMap != null
        ? CardElem.fromJson(contentMap)
        : null,
    atTextElem: contentTypeValue == MessageType.atText.value && contentMap != null
        ? AtTextElem.fromJson(contentMap)
        : null,
    notificationElem: contentTypeValue != null && contentTypeValue >= 1000 && contentMap != null
        ? _parseNotificationElem(contentMap)
        : null,
  );
}

/// 解析通知消息的 content → NotificationElem
///
/// OA 通知消息 (contentType=1400) 的 content 结构:
/// {"detail": "{\"text\":\"...\",\"pictureElem\":{...},\"mixType\":0,...}"}
/// 提取 detail 字段作为 NotificationElem.detail
NotificationElem _parseNotificationElem(Map<String, dynamic> contentMap) {
  final detailRaw = contentMap['detail'];
  if (detailRaw is String && detailRaw.isNotEmpty) {
    return NotificationElem(detail: detailRaw);
  }
  return NotificationElem(detail: jsonEncode(contentMap));
}
