import 'package:tostore/tostore.dart';

void main() {
  QueryCondition cond = QueryCondition();
  cond.whereEqual('a', 1);
  cond.whereLessThan('b', 2);
  cond.whereLessThanOrEqual('c', 3);
  cond.whereNotEqual('d', 4);
  cond.or();
  cond.and();
  print(cond.toJson());
}
