part of '../message.dart';

/// @提及文本元素。
///
/// @ Message Content
@JsonSerializable()
class AtTextElem extends Equatable {
  /// 文本。
  ///
  /// Text.
  final String? text;

  /// @提及用户列表。
  ///
  /// @-mention user list.
  final List<String>? atUserList;

  /// 是否@提及当前用户。
  ///
  /// Whether @-mention self user.
  final bool? isAtSelf;

  /// @提及用户列表信息。
  ///
  /// @-mention users info.
  final List<AtUserInfo>? atUsersInfo;

  /// 引用消息。
  ///
  /// Quote message.
  final Message? quoteMessage;

  /// 创建 `AtTextElem` 实例。
  ///
  /// Creates a `AtTextElem` instance.
  ///
  /// - [text] 文本 / Text.
  /// - [atUserList] @提及用户列表 / @-mention user list.
  /// - [isAtSelf] 是否@提及当前用户 / Whether @-mention self user.
  /// - [atUsersInfo] @提及用户列表信息 / @-mention users info.
  /// - [quoteMessage] 引用消息 / Quote message.
  const AtTextElem({
    this.text,
    this.atUserList,
    this.isAtSelf,
    this.atUsersInfo,
    this.quoteMessage,
  });

  /// 从 JSON 字典反序列化实例（`AtTextElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`AtTextElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `AtTextElem` 结果 / Resulting `AtTextElem`.
  factory AtTextElem.fromJson(Map<String, dynamic> json) => _$AtTextElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$AtTextElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [text] 文本 / Text.
  /// - [atUserList] @提及用户列表 / @-mention user list.
  /// - [isAtSelf] 是否@提及当前用户 / Whether @-mention self user.
  /// - [atUsersInfo] @提及用户列表信息 / @-mention users info.
  /// - [quoteMessage] 引用消息 / Quote message.
  /// - Returns: `AtTextElem` 结果 / Resulting `AtTextElem`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[text, atUserList, isAtSelf, atUsersInfo, quoteMessage];
}

/// 地理位置元素。
///
/// Location Message
@JsonSerializable()
class LocationElem extends Equatable {
  /// 描述。
  ///
  /// Description.
  final String? description;

  /// 经度。
  ///
  /// Longitude.
  final double? longitude;

  /// 纬度。
  ///
  /// Latitude.
  final double? latitude;

  /// 创建 `LocationElem` 实例。
  ///
  /// Creates a `LocationElem` instance.
  ///
  /// - [description] 描述 / Description.
  /// - [longitude] 经度 / Longitude.
  /// - [latitude] 纬度 / Latitude.
  const LocationElem({this.description, this.longitude, this.latitude});

  /// 从 JSON 字典反序列化实例（`LocationElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`LocationElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `LocationElem` 结果 / Resulting `LocationElem`.
  factory LocationElem.fromJson(Map<String, dynamic> json) => _$LocationElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$LocationElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [description] 描述 / Description.
  /// - [longitude] 经度 / Longitude.
  /// - [latitude] 纬度 / Latitude.
  /// - Returns: `LocationElem` 结果 / Resulting `LocationElem`.
  LocationElem copyWith({String? description, double? longitude, double? latitude}) {
    return LocationElem(
      description: description ?? this.description,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[description, longitude, latitude];
}

/// 自定义元素。
///
/// Custom Message
@JsonSerializable()
class CustomElem extends Equatable {
  /// 数据。
  ///
  /// Data.
  final String? data;

  /// extension。
  ///
  /// Extension.
  final String? extension;

  /// 描述。
  ///
  /// Description.
  final String? description;

  /// 创建 `CustomElem` 实例。
  ///
  /// Creates a `CustomElem` instance.
  ///
  /// - [data] 数据 / Data.
  /// - [extension] extension / Extension.
  /// - [description] 描述 / Description.
  const CustomElem({this.data, this.extension, this.description});

  /// 从 JSON 字典反序列化实例（`CustomElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CustomElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CustomElem` 结果 / Resulting `CustomElem`.
  factory CustomElem.fromJson(Map<String, dynamic> json) => _$CustomElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$CustomElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [data] 数据 / Data.
  /// - [extension] extension / Extension.
  /// - [description] 描述 / Description.
  /// - Returns: `CustomElem` 结果 / Resulting `CustomElem`.
  CustomElem copyWith({String? data, String? extension, String? description}) {
    return CustomElem(
      data: data ?? this.data,
      extension: extension ?? this.extension,
      description: description ?? this.description,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[data, extension, description];
}

/// 引用元素。
///
/// Quoted Message (Reply to a message)
@JsonSerializable()
class QuoteElem extends Equatable {
  /// 文本。
  ///
  /// Text.
  final String? text;

  /// 引用消息。
  ///
  /// Quote message.
  final Message? quoteMessage;

  /// 创建 `QuoteElem` 实例。
  ///
  /// Creates a `QuoteElem` instance.
  ///
  /// - [text] 文本 / Text.
  /// - [quoteMessage] 引用消息 / Quote message.
  const QuoteElem({this.text, this.quoteMessage});

  /// 从 JSON 字典反序列化实例（`QuoteElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`QuoteElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `QuoteElem` 结果 / Resulting `QuoteElem`.
  factory QuoteElem.fromJson(Map<String, dynamic> json) => _$QuoteElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$QuoteElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [text] 文本 / Text.
  /// - [quoteMessage] 引用消息 / Quote message.
  /// - Returns: `QuoteElem` 结果 / Resulting `QuoteElem`.
  QuoteElem copyWith({String? text, Message? quoteMessage}) {
    return QuoteElem(text: text ?? this.text, quoteMessage: quoteMessage ?? this.quoteMessage);
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[text, quoteMessage];
}

/// 合并元素。
///
/// Merged Message Body
@JsonSerializable()
class MergeElem extends Equatable {
  /// 标题。
  ///
  /// Title.
  final String? title;

  /// abstract列表。
  ///
  /// Abstract list.
  final List<String>? abstractList;

  /// 多个消息。
  ///
  /// Multiple message.
  final List<Message>? multiMessage;

  /// 创建 `MergeElem` 实例。
  ///
  /// Creates a `MergeElem` instance.
  ///
  /// - [title] 标题 / Title.
  /// - [abstractList] abstract列表 / Abstract list.
  /// - [multiMessage] 多个消息 / Multiple message.
  const MergeElem({this.title, this.abstractList, this.multiMessage});

  /// 从 JSON 字典反序列化实例（`MergeElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MergeElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MergeElem` 结果 / Resulting `MergeElem`.
  factory MergeElem.fromJson(Map<String, dynamic> json) => _$MergeElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$MergeElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [title] 标题 / Title.
  /// - [abstractList] abstract列表 / Abstract list.
  /// - [multiMessage] 多个消息 / Multiple message.
  /// - Returns: `MergeElem` 结果 / Resulting `MergeElem`.
  MergeElem copyWith({String? title, List<String>? abstractList, List<Message>? multiMessage}) {
    return MergeElem(
      title: title ?? this.title,
      abstractList: abstractList ?? this.abstractList,
      multiMessage: multiMessage ?? this.multiMessage,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[title, abstractList, multiMessage];
}

/// 通知元素。
///
/// Notification
@JsonSerializable()
class NotificationElem extends Equatable {
  /// 详情。
  ///
  /// Detail.
  final String? detail;

  /// defaultTips。
  ///
  /// Default tips.
  final String? defaultTips;

  /// 创建 `NotificationElem` 实例。
  ///
  /// Creates a `NotificationElem` instance.
  ///
  /// - [detail] 详情 / Detail.
  /// - [defaultTips] defaultTips / Default tips.
  const NotificationElem({this.detail, this.defaultTips});

  /// 从 JSON 字典反序列化实例（`NotificationElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`NotificationElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `NotificationElem` 结果 / Resulting `NotificationElem`.
  factory NotificationElem.fromJson(Map<String, dynamic> json) => _$NotificationElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$NotificationElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [detail] 详情 / Detail.
  /// - [defaultTips] defaultTips / Default tips.
  /// - Returns: `NotificationElem` 结果 / Resulting `NotificationElem`.
  NotificationElem copyWith({String? detail, String? defaultTips}) {
    return NotificationElem(
      detail: detail ?? this.detail,
      defaultTips: defaultTips ?? this.defaultTips,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[detail, defaultTips];
}

/// 头像元素。
///
/// Emoticon
@JsonSerializable()
class FaceElem extends Equatable {
  /// 索引。
  ///
  /// Index.
  final int? index;

  /// 数据。
  ///
  /// Data.
  final String? data;

  /// 创建 `FaceElem` 实例。
  ///
  /// Creates a `FaceElem` instance.
  ///
  /// - [index] 索引 / Index.
  /// - [data] 数据 / Data.
  const FaceElem({this.index, this.data});

  /// 从 JSON 字典反序列化实例（`FaceElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`FaceElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `FaceElem` 结果 / Resulting `FaceElem`.
  factory FaceElem.fromJson(Map<String, dynamic> json) => _$FaceElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$FaceElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [index] 索引 / Index.
  /// - [data] 数据 / Data.
  /// - Returns: `FaceElem` 结果 / Resulting `FaceElem`.
  FaceElem copyWith({int? index, String? data}) {
    return FaceElem(index: index ?? this.index, data: data ?? this.data);
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[index, data];
}

/// 附加信息元素。
///
/// Additional Information
@JsonSerializable()
class AttachedInfoElem extends Equatable {
  /// 群组是否包含读取信息。
  ///
  /// Group whether has read info.
  final GroupHasReadInfo? groupHasReadInfo;

  /// 是否阅后即焚聊天。
  ///
  /// Whether private chat.
  final bool? isPrivateChat;

  /// 是否包含读取时间戳。
  ///
  /// Whether has read timestamp.
  final int? hasReadTime;

  /// 阅后即焚时长。
  ///
  /// Burn-after-read duration.
  final int? burnDuration;

  /// not发送器通知推送。
  ///
  /// Not sender notification push.
  final bool? notSenderNotificationPush;

  /// 上传进度。
  ///
  /// Upload progress.
  final UploadProgress? uploadProgress;

  /// 创建 `AttachedInfoElem` 实例。
  ///
  /// Creates a `AttachedInfoElem` instance.
  ///
  /// - [groupHasReadInfo] 群组是否包含读取信息 / Group whether has read info.
  /// - [isPrivateChat] 是否阅后即焚Chat / Whether private chat.
  /// - [hasReadTime] 是否包含读取时间戳 / Whether has read timestamp.
  /// - [burnDuration] 阅后即焚时长 / Burn-after-read duration.
  /// - [notSenderNotificationPush] not发送器通知推送 / Not sender notification push.
  /// - [uploadProgress] 上传进度 / Upload progress.
  const AttachedInfoElem({
    this.groupHasReadInfo,
    this.isPrivateChat,
    this.hasReadTime,
    this.burnDuration,
    this.notSenderNotificationPush,
    this.uploadProgress,
  });

  /// 从 JSON 字典反序列化实例（`AttachedInfoElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`AttachedInfoElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `AttachedInfoElem` 结果 / Resulting `AttachedInfoElem`.
  factory AttachedInfoElem.fromJson(Map<String, dynamic> json) => _$AttachedInfoElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$AttachedInfoElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [groupHasReadInfo] 群组是否包含读取信息 / Group whether has read info.
  /// - [isPrivateChat] 是否阅后即焚Chat / Whether private chat.
  /// - [hasReadTime] 是否包含读取时间戳 / Whether has read timestamp.
  /// - [burnDuration] 阅后即焚时长 / Burn-after-read duration.
  /// - [notSenderNotificationPush] not发送器通知推送 / Not sender notification push.
  /// - [uploadProgress] 上传进度 / Upload progress.
  /// - Returns: `AttachedInfoElem` 结果 / Resulting `AttachedInfoElem`.
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

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
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

/// 上传进度。
///
/// Upload progress.
@JsonSerializable()
class UploadProgress extends Equatable {
  /// 总计。
  ///
  /// Total.
  final int? total;

  /// 保存。
  ///
  /// Save.
  final int? save;

  /// current。
  ///
  /// Current.
  final int? current;

  /// 上传ID。
  ///
  /// Upload ID.
  final String? uploadID;

  /// 创建 `UploadProgress` 实例。
  ///
  /// Creates a `UploadProgress` instance.
  ///
  /// - [total] 总计 / Total.
  /// - [save] 保存 / Save.
  /// - [current] current / Current.
  /// - [uploadID] 上传ID / Upload ID.
  const UploadProgress({this.total, this.save, this.current, this.uploadID});

  /// 从 JSON 字典反序列化实例（`UploadProgress.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`UploadProgress.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `UploadProgress` 结果 / Resulting `UploadProgress`.
  factory UploadProgress.fromJson(Map<String, dynamic> json) => _$UploadProgressFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$UploadProgressToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [total] 总计 / Total.
  /// - [save] 保存 / Save.
  /// - [current] current / Current.
  /// - [uploadID] 上传ID / Upload ID.
  /// - Returns: `UploadProgress` 结果 / Resulting `UploadProgress`.
  UploadProgress copyWith({int? total, int? save, int? current, String? uploadID}) {
    return UploadProgress(
      total: total ?? this.total,
      save: save ?? this.save,
      current: current ?? this.current,
      uploadID: uploadID ?? this.uploadID,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[total, save, current, uploadID];
}

/// 文本元素。
///
/// Text element.
@JsonSerializable()
class TextElem extends Equatable {
  /// 内容。
  ///
  /// Content.
  final String? content;

  /// 创建 `TextElem` 实例。
  ///
  /// Creates a `TextElem` instance.
  ///
  /// - [content] 内容 / Content.
  const TextElem({this.content});

  /// 从 JSON 字典反序列化实例（`TextElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`TextElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `TextElem` 结果 / Resulting `TextElem`.
  factory TextElem.fromJson(Map<String, dynamic> json) => _$TextElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$TextElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [content] 内容 / Content.
  /// - Returns: `TextElem` 结果 / Resulting `TextElem`.
  TextElem copyWith({String? content}) {
    return TextElem(content: content ?? this.content);
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[content];
}

/// 名片元素。
///
/// Contact card element.
@JsonSerializable()
class CardElem extends Equatable {
  /// 用户ID。
  ///
  /// User ID.
  final String? userID;

  /// 昵称。
  ///
  /// Nickname.
  final String? nickname;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String? faceURL;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 创建 `CardElem` 实例。
  ///
  /// Creates a `CardElem` instance.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [ex] 扩展字段 / Extension.
  const CardElem({this.userID, this.nickname, this.faceURL, this.ex});

  /// 从 JSON 字典反序列化实例（`CardElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`CardElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `CardElem` 结果 / Resulting `CardElem`.
  factory CardElem.fromJson(Map<String, dynamic> json) => _$CardElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$CardElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [userID] 用户ID / User ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `CardElem` 结果 / Resulting `CardElem`.
  CardElem copyWith({String? userID, String? nickname, String? faceURL, String? ex}) {
    return CardElem(
      userID: userID ?? this.userID,
      nickname: nickname ?? this.nickname,
      faceURL: faceURL ?? this.faceURL,
      ex: ex ?? this.ex,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[userID, nickname, faceURL, ex];
}

/// 正在输入元素。
///
/// Typing element.
@JsonSerializable()
class TypingElem extends Equatable {
  /// 消息Tips。
  ///
  /// Message tips.
  final String? msgTips;

  /// 创建 `TypingElem` 实例。
  ///
  /// Creates a `TypingElem` instance.
  ///
  /// - [msgTips] 消息Tips / Message tips.
  const TypingElem({this.msgTips});

  /// 从 JSON 字典反序列化实例（`TypingElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`TypingElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `TypingElem` 结果 / Resulting `TypingElem`.
  factory TypingElem.fromJson(Map<String, dynamic> json) => _$TypingElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$TypingElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [msgTips] 消息Tips / Message tips.
  /// - Returns: `TypingElem` 结果 / Resulting `TypingElem`.
  TypingElem copyWith({String? msgTips}) {
    return TypingElem(msgTips: msgTips ?? this.msgTips);
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[msgTips];
}

/// 高级文本元素。
///
/// Advanced text element.
@JsonSerializable()
class AdvancedTextElem extends Equatable {
  /// 文本。
  ///
  /// Text.
  final String? text;

  /// 消息实体列表。
  ///
  /// Message entity list.
  final List<MessageEntity>? messageEntityList;

  /// 创建 `AdvancedTextElem` 实例。
  ///
  /// Creates a `AdvancedTextElem` instance.
  ///
  /// - [text] 文本 / Text.
  /// - [messageEntityList] 消息实体列表 / Message entity list.
  const AdvancedTextElem({this.text, this.messageEntityList});

  /// 从 JSON 字典反序列化实例（`AdvancedTextElem.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`AdvancedTextElem.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `AdvancedTextElem` 结果 / Resulting `AdvancedTextElem`.
  factory AdvancedTextElem.fromJson(Map<String, dynamic> json) => _$AdvancedTextElemFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$AdvancedTextElemToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [text] 文本 / Text.
  /// - [messageEntityList] 消息实体列表 / Message entity list.
  /// - Returns: `AdvancedTextElem` 结果 / Resulting `AdvancedTextElem`.
  AdvancedTextElem copyWith({String? text, List<MessageEntity>? messageEntityList}) {
    return AdvancedTextElem(
      text: text ?? this.text,
      messageEntityList: messageEntityList ?? this.messageEntityList,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[text, messageEntityList];
}

/// 消息实体。
///
/// Message entity.
@JsonSerializable()
class MessageEntity extends Equatable {
  /// 类型。
  ///
  /// Type.
  final String? type;

  /// 偏移量。
  ///
  /// Offset.
  final int? offset;

  /// length。
  ///
  /// Length.
  final int? length;

  /// URL 地址。
  ///
  /// URL.
  final String? url;

  /// 扩展字段。
  ///
  /// Extension.
  final String? ex;

  /// 创建 `MessageEntity` 实例。
  ///
  /// Creates a `MessageEntity` instance.
  ///
  /// - [type] 类型 / Type.
  /// - [offset] 偏移量 / Offset.
  /// - [length] length / Length.
  /// - [url] URL 地址 / URL.
  /// - [ex] 扩展字段 / Extension.
  const MessageEntity({this.type, this.offset, this.length, this.url, this.ex});

  /// 从 JSON 字典反序列化实例（`MessageEntity.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`MessageEntity.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `MessageEntity` 结果 / Resulting `MessageEntity`.
  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [type] 类型 / Type.
  /// - [offset] 偏移量 / Offset.
  /// - [length] length / Length.
  /// - [url] URL 地址 / URL.
  /// - [ex] 扩展字段 / Extension.
  /// - Returns: `MessageEntity` 结果 / Resulting `MessageEntity`.
  MessageEntity copyWith({String? type, int? offset, int? length, String? url, String? ex}) {
    return MessageEntity(
      type: type ?? this.type,
      offset: offset ?? this.offset,
      length: length ?? this.length,
      url: url ?? this.url,
      ex: ex ?? this.ex,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[type, offset, length, url, ex];
}
