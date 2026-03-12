import 'dart:io';
import 'package:tostore/tostore.dart';
import 'package:tostore/src/query/query_condition.dart';

// Test imitating getAdvancedHistoryMessageList
void main() async {
  print('=== Running toStore History Pagination Test (Imitating go-sdk) ===');
  final toStore = ToStore();
  final dbPath = 'test_tostore_history';
  await toStore.init(dbPath);
  await toStore.createTable('localChatLog');

  final msgs = [
    // 5 messages all inserted at different sequences, some with EXACT same sendTime
    {'clientMsgID': 'msg_1', 'conversationID': 'c1', 'sendTime': 1000, 'seq': 1},
    {'clientMsgID': 'msg_2', 'conversationID': 'c1', 'sendTime': 1000, 'seq': 2},
    {'clientMsgID': 'msg_3', 'conversationID': 'c1', 'sendTime': 1000, 'seq': 3},
    {'clientMsgID': 'msg_4', 'conversationID': 'c1', 'sendTime': 2000, 'seq': 4},
    {'clientMsgID': 'msg_5', 'conversationID': 'c1', 'sendTime': 2000, 'seq': 5},
  ];

  for (var m in msgs) {
    try {
      await toStore.insert('localChatLog', m);
    } catch (e) {}
  }

  // First fetch step (from very end, simulating latest 2 messages)
  var q1 = toStore.query('localChatLog').whereEqual('conversationID', 'c1');
  var p1 = await q1.orderByDesc('sendTime').orderByDesc('seq').limit(2);

  print('\n[Page 1] (No start time, descending latest 2 messages)');
  List ids1 = p1.data.map((e) => e['clientMsgID']).toList();
  print('Returned Msg IDs: $ids1');
  if (ids1.join(',') == 'msg_5,msg_4') {
    print('✅ Page 1 is SUCCESS (msg_5, msg_4)');
  }

  // Second fetch step, start from Msg_4 (sendTime: 2000, seq: 4)
  print('\n[Page 2] (Start from Msg_4, simulating earlier messages limit 2)');
  var q2 = toStore.query('localChatLog').whereEqual('conversationID', 'c1');

  int startTime = 2000;
  int startSeq = 4;
  String startClientMsgID = 'msg_4';

  q2.whereLessThanOrEqualTo('sendTime', startTime);
  q2.whereCustom((record) {
    final int sendTime = record['sendTime'] ?? 0;
    final int seq = record['seq'] ?? 0;
    final String clientMsgID = record['clientMsgID'] ?? '';

    if (sendTime < startTime) return true;
    if (sendTime == startTime) {
      if (startSeq > 0) return seq < startSeq;
      return seq == 0 && clientMsgID != startClientMsgID;
    }
    return false;
  });

  var p2 = await q2.orderByDesc('sendTime').orderByDesc('seq').limit(2);
  List ids2 = p2.data.map((e) => e['clientMsgID']).toList();
  print('Returned Msg IDs: $ids2');

  if (ids2.join(',') == 'msg_3,msg_2') {
    print('✅ Page 2 is SUCCESS (msg_3, msg_2). Pagination bypassed identical sendTime looping!!');
  } else {
    print('❌ Failed: duplicate loop issue persists!');
  }

  try {
    Directory(dbPath).deleteSync(recursive: true);
  } catch (e) {}
  print('=== Done ===\n');
  exit(0);
}
