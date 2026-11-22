part of '../message.dart';

/// @ Message Content
@JsonSerializable()
class AtTextElem extends Equatable {
  final String? text;
  final List<String>? atUserList;
  final bool? isAtSelf;
  final List<AtUserInfo>? atUsersInfo;
  final Message? quoteMessage;

  const AtTextElem({
    this.text,
    this.atUserList,
    this.isAtSelf,
    this.atUsersInfo,
    this.quoteMessage,
  });

  factory AtTextElem.fromJson(Map<String, dynamic> json) => _$AtTextElemFromJson(json);

  Map<String, dynamic> toJson() => _$AtTextElemToJson(this);

  AtTextElem copyWith({
    String? text,
    List<String>? atUserList,
    bool? isAtSelf,
    List<AtUserInfo>? atUsersInfo,
    Message? quoteMessage,
  }) {
    return AtTextElem(
      text: text ?? this.text,
      atUserList: atUserList ?? this.atUserList,
      isAtSelf: isAtSelf ?? this.isAtSelf,
      atUsersInfo: atUsersInfo ?? this.atUsersInfo,
      quoteMessage: quoteMessage ?? this.quoteMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[text, atUserList, isAtSelf, atUsersInfo, quoteMessage];
}

/// Location Message
@JsonSerializable()
class LocationElem extends Equatable {
  final String? description;
  final double? longitude;
  final double? latitude;

  const LocationElem({this.description, this.longitude, this.latitude});

  factory LocationElem.fromJson(Map<String, dynamic> json) => _$LocationElemFromJson(json);

  Map<String, dynamic> toJson() => _$LocationElemToJson(this);

  LocationElem copyWith({String? description, double? longitude, double? latitude}) {
    return LocationElem(
      description: description ?? this.description,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  @override
  List<Object?> get props => <Object?>[description, longitude, latitude];
}

/// Custom Message
@JsonSerializable()
class CustomElem extends Equatable {
  final String? data;
  final String? extension;
  final String? description;

  const CustomElem({this.data, this.extension, this.description});

  factory CustomElem.fromJson(Map<String, dynamic> json) => _$CustomElemFromJson(json);

  Map<String, dynamic> toJson() => _$CustomElemToJson(this);

  CustomElem copyWith({String? data, String? extension, String? description}) {
    return CustomElem(
      data: data ?? this.data,
      extension: extension ?? this.extension,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => <Object?>[data, extension, description];
}

/// Quoted Message (Reply to a message)
@JsonSerializable()
class QuoteElem extends Equatable {
  final String? text;
  final Message? quoteMessage;

  const QuoteElem({this.text, this.quoteMessage});

  factory QuoteElem.fromJson(Map<String, dynamic> json) => _$QuoteElemFromJson(json);

  Map<String, dynamic> toJson() => _$QuoteElemToJson(this);

  QuoteElem copyWith({String? text, Message? quoteMessage}) {
    return QuoteElem(text: text ?? this.text, quoteMessage: quoteMessage ?? this.quoteMessage);
  }

  @override
  List<Object?> get props => <Object?>[text, quoteMessage];
}

/// Merged Message Body
@JsonSerializable()
class MergeElem extends Equatable {
  final String? title;
  final List<String>? abstractList;
  final List<Message>? multiMessage;

  const MergeElem({this.title, this.abstractList, this.multiMessage});

  factory MergeElem.fromJson(Map<String, dynamic> json) => _$MergeElemFromJson(json);

  Map<String, dynamic> toJson() => _$MergeElemToJson(this);

  MergeElem copyWith({String? title, List<String>? abstractList, List<Message>? multiMessage}) {
    return MergeElem(
      title: title ?? this.title,
      abstractList: abstractList ?? this.abstractList,
      multiMessage: multiMessage ?? this.multiMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[title, abstractList, multiMessage];
}

/// Notification
@JsonSerializable()
class NotificationElem extends Equatable {
  final String? detail;
  final String? defaultTips;

  const NotificationElem({this.detail, this.defaultTips});

  factory NotificationElem.fromJson(Map<String, dynamic> json) => _$NotificationElemFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationElemToJson(this);

  NotificationElem copyWith({String? detail, String? defaultTips}) {
    return NotificationElem(
      detail: detail ?? this.detail,
      defaultTips: defaultTips ?? this.defaultTips,
    );
  }

  @override
  List<Object?> get props => <Object?>[detail, defaultTips];
}

/// Emoticon
@JsonSerializable()
class FaceElem extends Equatable {
  final int? index;
  final String? data;

  const FaceElem({this.index, this.data});

  factory FaceElem.fromJson(Map<String, dynamic> json) => _$FaceElemFromJson(json);

  Map<String, dynamic> toJson() => _$FaceElemToJson(this);

  FaceElem copyWith({int? index, String? data}) {
    return FaceElem(index: index ?? this.index, data: data ?? this.data);
  }

  @override
  List<Object?> get props => <Object?>[index, data];
}

/// Additional Information
@JsonSerializable()
class AttachedInfoElem extends Equatable {
  final GroupHasReadInfo? groupHasReadInfo;
  final bool? isPrivateChat;
  final int? hasReadTime;
  final int? burnDuration;
  final bool? notSenderNotificationPush;
  final UploadProgress? uploadProgress;

  const AttachedInfoElem({
    this.groupHasReadInfo,
    this.isPrivateChat,
    this.hasReadTime,
    this.burnDuration,
    this.notSenderNotificationPush,
    this.uploadProgress,
  });

  factory AttachedInfoElem.fromJson(Map<String, dynamic> json) => _$AttachedInfoElemFromJson(json);

  Map<String, dynamic> toJson() => _$AttachedInfoElemToJson(this);

  AttachedInfoElem copyWith({
    GroupHasReadInfo? groupHasReadInfo,
    bool? isPrivateChat,
    int? hasReadTime,
    int? burnDuration,
    bool? notSenderNotificationPush,
    UploadProgress? uploadProgress,
  }) {
    return AttachedInfoElem(
      groupHasReadInfo: groupHasReadInfo ?? this.groupHasReadInfo,
      isPrivateChat: isPrivateChat ?? this.isPrivateChat,
      hasReadTime: hasReadTime ?? this.hasReadTime,
      burnDuration: burnDuration ?? this.burnDuration,
      notSenderNotificationPush: notSenderNotificationPush ?? this.notSenderNotificationPush,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    groupHasReadInfo,
    isPrivateChat,
    hasReadTime,
    burnDuration,
    notSenderNotificationPush,
    uploadProgress,
  ];
}

@JsonSerializable()
class UploadProgress extends Equatable {
  final int? total;
  final int? save;
  final int? current;
  final String? uploadID;

  const UploadProgress({this.total, this.save, this.current, this.uploadID});

  factory UploadProgress.fromJson(Map<String, dynamic> json) => _$UploadProgressFromJson(json);

  Map<String, dynamic> toJson() => _$UploadProgressToJson(this);

  UploadProgress copyWith({int? total, int? save, int? current, String? uploadID}) {
    return UploadProgress(
      total: total ?? this.total,
      save: save ?? this.save,
      current: current ?? this.current,
      uploadID: uploadID ?? this.uploadID,
    );
  }

  @override
  List<Object?> get props => <Object?>[total, save, current, uploadID];
}

@JsonSerializable()
class TextElem extends Equatable {
  final String? content;

  const TextElem({this.content});

  factory TextElem.fromJson(Map<String, dynamic> json) => _$TextElemFromJson(json);

  Map<String, dynamic> toJson() => _$TextElemToJson(this);

  TextElem copyWith({String? content}) {
    return TextElem(content: content ?? this.content);
  }

  @override
  List<Object?> get props => <Object?>[content];
}

@JsonSerializable()
class CardElem extends Equatable {
  final String? userID;
  final String? nickname;
  final String? faceURL;
  final String? ex;

  const CardElem({this.userID, this.nickname, this.faceURL, this.ex});

  factory CardElem.fromJson(Map<String, dynamic> json) => _$CardElemFromJson(json);

  Map<String, dynamic> toJson() => _$CardElemToJson(this);

  CardElem copyWith({String? userID, String? nickname, String? faceURL, String? ex}) {
    return CardElem(
      userID: userID ?? this.userID,
      nickname: nickname ?? this.nickname,
      faceURL: faceURL ?? this.faceURL,
      ex: ex ?? this.ex,
    );
  }

  @override
  List<Object?> get props => <Object?>[userID, nickname, faceURL, ex];
}

@JsonSerializable()
class TypingElem extends Equatable {
  final String? msgTips;

  const TypingElem({this.msgTips});

  factory TypingElem.fromJson(Map<String, dynamic> json) => _$TypingElemFromJson(json);

  Map<String, dynamic> toJson() => _$TypingElemToJson(this);

  TypingElem copyWith({String? msgTips}) {
    return TypingElem(msgTips: msgTips ?? this.msgTips);
  }

  @override
  List<Object?> get props => <Object?>[msgTips];
}

@JsonSerializable()
class AdvancedTextElem extends Equatable {
  final String? text;
  final List<MessageEntity>? messageEntityList;

  const AdvancedTextElem({this.text, this.messageEntityList});

  factory AdvancedTextElem.fromJson(Map<String, dynamic> json) => _$AdvancedTextElemFromJson(json);

  Map<String, dynamic> toJson() => _$AdvancedTextElemToJson(this);

  AdvancedTextElem copyWith({String? text, List<MessageEntity>? messageEntityList}) {
    return AdvancedTextElem(
      text: text ?? this.text,
      messageEntityList: messageEntityList ?? this.messageEntityList,
    );
  }

  @override
  List<Object?> get props => <Object?>[text, messageEntityList];
}

@JsonSerializable()
class MessageEntity extends Equatable {
  final String? type;
  final int? offset;
  final int? length;
  final String? url;
  final String? ex;

  const MessageEntity({this.type, this.offset, this.length, this.url, this.ex});

  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);

  MessageEntity copyWith({String? type, int? offset, int? length, String? url, String? ex}) {
    return MessageEntity(
      type: type ?? this.type,
      offset: offset ?? this.offset,
      length: length ?? this.length,
      url: url ?? this.url,
      ex: ex ?? this.ex,
    );
  }

  @override
  List<Object?> get props => <Object?>[type, offset, length, url, ex];
}
