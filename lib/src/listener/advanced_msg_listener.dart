import 'package:openim_sdk/openim_sdk.dart';

/// Message Listener
class OnAdvancedMsgListener {
  void Function(Message msg)? onMsgDeleted;
  void Function(RevokedInfo info)? onNewRecvMessageRevoked;
  void Function(List<ReadReceiptInfo> list)? onRecvC2CReadReceipt;
  void Function(Message msg)? onRecvNewMessage;
  void Function(Message msg)? onRecvOfflineNewMessage;
  void Function(Message msg)? onRecvOnlineOnlyMessage;
  void Function(Message msg)? onMessageStatusChanged;

  /// Uniquely identifies
  String id;

  OnAdvancedMsgListener({
    this.onMsgDeleted,
    this.onNewRecvMessageRevoked,
    this.onRecvC2CReadReceipt,
    this.onRecvNewMessage,
    this.onRecvOfflineNewMessage,
    this.onRecvOnlineOnlyMessage,
    this.onMessageStatusChanged,
  }) : id = "id_${DateTime.now().microsecondsSinceEpoch}";

  void msgDeleted(Message msg) {
    onMsgDeleted?.call(msg);
  }

  /// Message has been retracted
  void newRecvMessageRevoked(RevokedInfo info) {
    onNewRecvMessageRevoked?.call(info);
  }

  /// C2C Message Read Receipt
  void recvC2CReadReceipt(List<ReadReceiptInfo> list) {
    onRecvC2CReadReceipt?.call(list);
  }

  /// Received a new message
  void recvNewMessage(Message msg) {
    onRecvNewMessage?.call(msg);
  }

  void recvOfflineNewMessage(Message msg) {
    onRecvOfflineNewMessage?.call(msg);
  }

  void recvOnlineOnlyMessage(Message msg) {
    onRecvOnlineOnlyMessage?.call(msg);
  }

  /// Message status changed (e.g., sending -> failed)
  void messageStatusChanged(Message msg) {
    onMessageStatusChanged?.call(msg);
  }
}
