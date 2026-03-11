import 'package:json_annotation/json_annotation.dart';

/// Message Send Status
enum MessageStatus {
  /// Sending
  @JsonValue(1)
  sending(1),

  /// Successfully sent
  @JsonValue(2)
  succeeded(2),

  /// Send failed
  @JsonValue(3)
  failed(3),

  /// Already deleted
  @JsonValue(4)
  deleted(4);

  const MessageStatus(this.value);

  final int value;
}

enum GetHistoryViewType {
  @JsonValue(0)
  history(0),

  @JsonValue(1)
  search(1);

  const GetHistoryViewType(this.value);

  final int value;
}
