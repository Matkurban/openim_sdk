import 'dart:convert';
import 'package:tostore/tostore.dart';
import 'package:tostore/src/query/query_condition.dart';

void main() async {
  var c1 = QueryCondition()..where('seq', '<', 5);
  var c2 = QueryCondition()..where('seq', '>=', 5);
  c1.orCondition(c2);
  print(jsonEncode(c1.build()));
}
