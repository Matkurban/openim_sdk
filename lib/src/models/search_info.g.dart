// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
  totalCount: (json['totalCount'] as num?)?.toInt(),
  searchResultItems: (json['searchResultItems'] as List<dynamic>?)
      ?.map((e) => SearchResultItems.fromJson(e as Map<String, dynamic>))
      .toList(),
  findResultItems: (json['findResultItems'] as List<dynamic>?)
      ?.map((e) => SearchResultItems.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'searchResultItems': instance.searchResultItems,
      'findResultItems': instance.findResultItems,
    };

SearchResultItems _$SearchResultItemsFromJson(Map<String, dynamic> json) =>
    SearchResultItems(
      conversationID: json['conversationID'] as String?,
      conversationType: $enumDecodeNullable(
        _$ConversationTypeEnumMap,
        json['conversationType'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      showName: json['showName'] as String?,
      faceURL: json['faceURL'] as String?,
      messageCount: (json['messageCount'] as num?)?.toInt(),
      messageList: (json['messageList'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchResultItemsToJson(SearchResultItems instance) =>
    <String, dynamic>{
      'conversationID': instance.conversationID,
      'conversationType': _$ConversationTypeEnumMap[instance.conversationType],
      'showName': instance.showName,
      'faceURL': instance.faceURL,
      'messageCount': instance.messageCount,
      'messageList': instance.messageList,
    };

const _$ConversationTypeEnumMap = {
  ConversationType.single: 1,
  ConversationType.group: 2,
  ConversationType.superGroup: 3,
  ConversationType.notification: 4,
};

SearchParams _$SearchParamsFromJson(Map<String, dynamic> json) => SearchParams(
  conversationID: json['conversationID'] as String?,
  clientMsgIDList: (json['clientMsgIDList'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SearchParamsToJson(SearchParams instance) =>
    <String, dynamic>{
      'conversationID': instance.conversationID,
      'clientMsgIDList': instance.clientMsgIDList,
    };

SearchFriendsInfo _$SearchFriendsInfoFromJson(Map<String, dynamic> json) =>
    SearchFriendsInfo(
      relationship: (json['relationship'] as num).toInt(),
      ownerUserID: json['ownerUserID'] as String?,
      nickname: json['nickname'] as String?,
      faceURL: json['faceURL'] as String?,
      friendUserID: json['friendUserID'] as String?,
      remark: json['remark'] as String?,
      ex: json['ex'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      addSource: (json['addSource'] as num?)?.toInt(),
      operatorUserID: json['operatorUserID'] as String?,
    );

Map<String, dynamic> _$SearchFriendsInfoToJson(SearchFriendsInfo instance) =>
    <String, dynamic>{
      'ownerUserID': instance.ownerUserID,
      'nickname': instance.nickname,
      'faceURL': instance.faceURL,
      'friendUserID': instance.friendUserID,
      'remark': instance.remark,
      'ex': instance.ex,
      'createTime': instance.createTime,
      'addSource': instance.addSource,
      'operatorUserID': instance.operatorUserID,
      'relationship': instance.relationship,
    };
