import 'package:tostore/tostore.dart';
import 'package:tostore/src/query/query_condition.dart';

void main() async {
  final count = 20;
  final startTime = 2000;
  final startSeq = 4;
  final startClientMsgID = 'msg_4';

  var query = QueryCondition()
    ..whereEqual('conversationID', 'c1');
    
  if (startTime > 0) {
    var c1 = QueryCondition()..whereLessThan('sendTime', startTime);
    var c2 = QueryCondition()..whereEqual('sendTime', startTime)..whereLessThan('seq', startSeq);
    var c3 = QueryCondition()..whereEqual('sendTime', startTime)..whereEqual('seq', 0)..whereNotEqual('clientMsgID', startClientMsgID);
    
    var subCondition = QueryCondition()
       ..whereCondition(c1)
       ..orCondition(c2)
       ..orCondition(c3);
       
    query.whereCondition(subCondition);
  }
  
  print('compiles successfully!');
}
