import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'search_info.g.dart';

/// 搜索结果。
///
/// Search result.
@JsonSerializable()
class SearchResult extends Equatable {
  /// 总计数量。
  ///
  /// Total count.
  final int? totalCount;

  /// 搜索结果Items。
  ///
  /// Search result items.
  final List<SearchResultItems>? searchResultItems;

  /// 查找结果Items。
  ///
  /// Find result items.
  final List<SearchResultItems>? findResultItems;

  /// 创建 `SearchResult` 实例。
  ///
  /// Creates a `SearchResult` instance.
  ///
  /// - [totalCount] 总计数量 / Total count.
  /// - [searchResultItems] 搜索结果Items / Search result items.
  /// - [findResultItems] 查找结果Items / Find result items.
  const SearchResult({this.totalCount, this.searchResultItems, this.findResultItems});

  /// 从 JSON 字典反序列化实例（`SearchResult.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`SearchResult.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `SearchResult` 结果 / Resulting `SearchResult`.
  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [totalCount] 总计数量 / Total count.
  /// - [searchResultItems] 搜索结果Items / Search result items.
  /// - [findResultItems] 查找结果Items / Find result items.
  /// - Returns: `SearchResult` 结果 / Resulting `SearchResult`.
  SearchResult copyWith({
    int? totalCount,
    List<SearchResultItems>? searchResultItems,
    List<SearchResultItems>? findResultItems,
  }) {
    return SearchResult(
      totalCount: totalCount ?? this.totalCount,
      searchResultItems: searchResultItems ?? this.searchResultItems,
      findResultItems: findResultItems ?? this.findResultItems,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[totalCount, searchResultItems, findResultItems];
}

/// 搜索结果Items。
///
/// Search result items.
@JsonSerializable()
class SearchResultItems extends Equatable {
  /// 会话ID。
  ///
  /// Conversation ID.
  final String? conversationID;

  /// 会话类型。
  ///
  /// Conversation type.
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? conversationType;

  /// 展示名称。
  ///
  /// Display name.
  final String? showName;

  /// 头像URL 地址。
  ///
  /// Avatar URL.
  final String? faceURL;

  /// 消息数量。
  ///
  /// Message count.
  final int? messageCount;

  /// 消息列表。
  ///
  /// Message list.
  final List<Message>? messageList;

  /// 创建 `SearchResultItems` 实例。
  ///
  /// Creates a `SearchResultItems` instance.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [conversationType] 会话类型 / Conversation type.
  /// - [showName] 展示名称 / Display name.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [messageCount] 消息数量 / Message count.
  /// - [messageList] 消息列表 / Message list.
  const SearchResultItems({
    this.conversationID,
    this.conversationType,
    this.showName,
    this.faceURL,
    this.messageCount,
    this.messageList,
  });

  /// 从 JSON 字典反序列化实例（`SearchResultItems.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`SearchResultItems.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `SearchResultItems` 结果 / Resulting `SearchResultItems`.
  factory SearchResultItems.fromJson(Map<String, dynamic> json) =>
      _$SearchResultItemsFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$SearchResultItemsToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [conversationType] 会话类型 / Conversation type.
  /// - [showName] 展示名称 / Display name.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [messageCount] 消息数量 / Message count.
  /// - [messageList] 消息列表 / Message list.
  /// - Returns: `SearchResultItems` 结果 / Resulting `SearchResultItems`.
  SearchResultItems copyWith({
    String? conversationID,
    ConversationType? conversationType,
    String? showName,
    String? faceURL,
    int? messageCount,
    List<Message>? messageList,
  }) {
    return SearchResultItems(
      conversationID: conversationID ?? this.conversationID,
      conversationType: conversationType ?? this.conversationType,
      showName: showName ?? this.showName,
      faceURL: faceURL ?? this.faceURL,
      messageCount: messageCount ?? this.messageCount,
      messageList: messageList ?? this.messageList,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[
    conversationID,
    conversationType,
    showName,
    faceURL,
    messageCount,
    messageList,
  ];
}

/// 搜索Params。
///
/// Search params.
@JsonSerializable()
class SearchParams extends Equatable {
  /// 会话ID。
  ///
  /// Conversation ID.
  final String? conversationID;

  /// 客户端消息ID列表。
  ///
  /// Client message ID list.
  final List<String>? clientMsgIDList;

  /// 创建 `SearchParams` 实例。
  ///
  /// Creates a `SearchParams` instance.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [clientMsgIDList] 客户端消息ID列表 / Client message ID list.
  const SearchParams({this.conversationID, this.clientMsgIDList});

  /// 从 JSON 字典反序列化实例（`SearchParams.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`SearchParams.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `SearchParams` 结果 / Resulting `SearchParams`.
  factory SearchParams.fromJson(Map<String, dynamic> json) => _$SearchParamsFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  Map<String, dynamic> toJson() => _$SearchParamsToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [conversationID] 会话ID / Conversation ID.
  /// - [clientMsgIDList] 客户端消息ID列表 / Client message ID list.
  /// - Returns: `SearchParams` 结果 / Resulting `SearchParams`.
  SearchParams copyWith({String? conversationID, List<String>? clientMsgIDList}) {
    return SearchParams(
      conversationID: conversationID ?? this.conversationID,
      clientMsgIDList: clientMsgIDList ?? this.clientMsgIDList,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[conversationID, clientMsgIDList];
}

/// 搜索好友列表信息。
///
/// Search friends info.
@JsonSerializable()
class SearchFriendsInfo extends FriendInfo {
  /// relationship。
  ///
  /// Relationship.
  final int relationship;

  /// 创建 `SearchFriendsInfo` 实例。
  ///
  /// Creates a `SearchFriendsInfo` instance.
  ///
  /// - [relationship] relationship / Relationship.
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [friendUserID] 好友用户ID / Friend user ID.
  /// - [remark] 备注 / Remark.
  /// - [ex] 扩展字段 / Extension.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [addSource] 添加来源 / Add source.
  /// - [operatorUserID] 操作者用户ID / Operator user ID.
  const SearchFriendsInfo({
    required this.relationship,
    super.ownerUserID,
    super.nickname,
    super.faceURL,
    super.friendUserID,
    super.remark,
    super.ex,
    super.createTime,
    super.addSource,
    super.operatorUserID,
  });

  /// 从 JSON 字典反序列化实例（`SearchFriendsInfo.fromJson`）。
  ///
  /// Deserializes an instance from a JSON map (`SearchFriendsInfo.fromJson`).
  ///
  /// - [json] JSON / JSON.
  /// - Returns: `SearchFriendsInfo` 结果 / Resulting `SearchFriendsInfo`.
  factory SearchFriendsInfo.fromJson(Map<String, dynamic> json) =>
      _$SearchFriendsInfoFromJson(json);

  /// 序列化为 JSON 字典。
  ///
  /// Serializes this object to a JSON map.
  ///
  /// - Returns: `Map<String, dynamic>` 映射结果 / Resulting `Map<String, dynamic>` map.
  @override
  Map<String, dynamic> toJson() => _$SearchFriendsInfoToJson(this);

  /// 复制当前对象并替换指定字段。
  ///
  /// Creates a copy with the specified fields replaced.
  ///
  /// - [relationship] relationship / Relationship.
  /// - [ownerUserID] 群主/拥有者用户ID / Owner user ID.
  /// - [nickname] 昵称 / Nickname.
  /// - [faceURL] 头像URL 地址 / Avatar URL.
  /// - [friendUserID] 好友用户ID / Friend user ID.
  /// - [remark] 备注 / Remark.
  /// - [ex] 扩展字段 / Extension.
  /// - [createTime] 创建时间戳 / Create timestamp.
  /// - [addSource] 添加来源 / Add source.
  /// - [operatorUserID] 操作者用户ID / Operator user ID.
  /// - Returns: `SearchFriendsInfo` 结果 / Resulting `SearchFriendsInfo`.
  @override
  SearchFriendsInfo copyWith({
    int? relationship,
    String? ownerUserID,
    String? nickname,
    String? faceURL,
    String? friendUserID,
    String? remark,
    String? ex,
    int? createTime,
    int? addSource,
    String? operatorUserID,
  }) {
    return SearchFriendsInfo(
      relationship: relationship ?? this.relationship,
      ownerUserID: ownerUserID ?? this.ownerUserID,
      nickname: nickname ?? this.nickname,
      faceURL: faceURL ?? this.faceURL,
      friendUserID: friendUserID ?? this.friendUserID,
      remark: remark ?? this.remark,
      ex: ex ?? this.ex,
      createTime: createTime ?? this.createTime,
      addSource: addSource ?? this.addSource,
      operatorUserID: operatorUserID ?? this.operatorUserID,
    );
  }

  /// 用于 Equatable 相等性比较的属性列表。
  ///
  /// Properties used by Equatable for value equality.
  @override
  List<Object?> get props => <Object?>[...super.props, relationship];
}
