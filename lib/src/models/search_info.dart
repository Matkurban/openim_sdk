import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openim_sdk/openim_sdk.dart';

part 'search_info.g.dart';

@JsonSerializable()
class SearchResult extends Equatable {
  final int? totalCount;
  final List<SearchResultItems>? searchResultItems;
  final List<SearchResultItems>? findResultItems;

  const SearchResult({this.totalCount, this.searchResultItems, this.findResultItems});

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

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

  @override
  List<Object?> get props => [totalCount, searchResultItems, findResultItems];
}

@JsonSerializable()
class SearchResultItems extends Equatable {
  final String? conversationID;

  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final ConversationType? conversationType;

  final String? showName;
  final String? faceURL;
  final int? messageCount;
  final List<Message>? messageList;

  const SearchResultItems({
    this.conversationID,
    this.conversationType,
    this.showName,
    this.faceURL,
    this.messageCount,
    this.messageList,
  });

  factory SearchResultItems.fromJson(Map<String, dynamic> json) =>
      _$SearchResultItemsFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultItemsToJson(this);

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

  @override
  List<Object?> get props => [
    conversationID,
    conversationType,
    showName,
    faceURL,
    messageCount,
    messageList,
  ];
}

@JsonSerializable()
class SearchParams extends Equatable {
  final String? conversationID;
  final List<String>? clientMsgIDList;

  const SearchParams({this.conversationID, this.clientMsgIDList});

  factory SearchParams.fromJson(Map<String, dynamic> json) => _$SearchParamsFromJson(json);

  Map<String, dynamic> toJson() => _$SearchParamsToJson(this);

  SearchParams copyWith({String? conversationID, List<String>? clientMsgIDList}) {
    return SearchParams(
      conversationID: conversationID ?? this.conversationID,
      clientMsgIDList: clientMsgIDList ?? this.clientMsgIDList,
    );
  }

  @override
  List<Object?> get props => [conversationID, clientMsgIDList];
}

@JsonSerializable()
class SearchFriendsInfo extends FriendInfo {
  final int relationship;

  const SearchFriendsInfo({
    required this.relationship,
    super.ownerUserID,
    super.userID,
    super.nickname,
    super.faceURL,
    super.friendUserID,
    super.remark,
    super.ex,
    super.createTime,
    super.addSource,
    super.operatorUserID,
  });

  factory SearchFriendsInfo.fromJson(Map<String, dynamic> json) =>
      _$SearchFriendsInfoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SearchFriendsInfoToJson(this);

  @override
  SearchFriendsInfo copyWith({
    int? relationship,
    String? ownerUserID,
    String? userID,
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
      userID: userID ?? this.userID,
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

  @override
  List<Object?> get props => [...super.props, relationship];
}
