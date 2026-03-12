import 'package:tostore/tostore.dart';
import 'package:tostore/src/query/query_condition.dart';

void main() async {
  final query = QueryCondition()
    ..where('conversationID', '=', 'c1')
    ..whereLessThanOrEqualTo('sendTime', 1000)
    ..whereCustom((record) {
      final int sendTime = record['sendTime'];
      final int seq = record['seq'];
      final String clientMsgID = record['clientMsgID'] ?? '';
      
      final int targetSendTime = 1000;
      final int targetSeq = 5;
      final String targetClientMsgID = 'c1';
      
      return sendTime < targetSendTime || 
            (sendTime == targetSendTime && (seq < targetSeq || (seq == 0 && clientMsgID != targetClientMsgID)));
    })
    ..orderByDesc('sendTime')
    ..orderByDesc('seq')
    ..limit(2);

  print('Query structure: ${query}');
}
