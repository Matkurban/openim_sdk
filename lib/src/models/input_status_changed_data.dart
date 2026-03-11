import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'input_status_changed_data.g.dart';

@JsonSerializable()
class InputStatusChangedData extends Equatable {
  final String userID;
  final String conversationID;
  final List<int>? platformIDs;

  const InputStatusChangedData({
    required this.userID,
    required this.conversationID,
    this.platformIDs,
  });

  factory InputStatusChangedData.fromJson(Map<String, dynamic> json) =>
      _$InputStatusChangedDataFromJson(json);

  Map<String, dynamic> toJson() => _$InputStatusChangedDataToJson(this);

  InputStatusChangedData copyWith({
    String? userID,
    String? conversationID,
    List<int>? platformIDs,
  }) {
    return InputStatusChangedData(
      userID: userID ?? this.userID,
      conversationID: conversationID ?? this.conversationID,
      platformIDs: platformIDs ?? this.platformIDs,
    );
  }

  @override
  List<Object?> get props => [userID, conversationID, platformIDs];
}
