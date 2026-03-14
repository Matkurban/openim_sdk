// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_status_changed_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputStatusChangedData _$InputStatusChangedDataFromJson(Map<String, dynamic> json) =>
    InputStatusChangedData(
      userID: json['userID'] as String,
      conversationID: json['conversationID'] as String,
      platformIDs: (json['platformIDs'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
    );

Map<String, dynamic> _$InputStatusChangedDataToJson(InputStatusChangedData instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'conversationID': instance.conversationID,
      'platformIDs': instance.platformIDs,
    };
