import 'dart:io';
import 'package:openim_sdk/src/db/database_service.dart';
import 'package:test/test.dart';

void main() {
  test('unreadCount stored via upsert + SUM', () async {
    final dir = Directory.systemTemp.createTempSync('openim_test_debug_');
    final db = DatabaseService();
    await db.init(userID: 'test_user_001', dataDir: dir.path);

    await db.upsertConversation({'conversationID': 'c1', 'conversationType': 1, 'unreadCount': 3});
    await db.upsertConversation({'conversationID': 'c2', 'conversationType': 1, 'unreadCount': 7});

    final c1 = await db.getConversation('c1');
    print('c1: unreadCount=${c1?['unreadCount']} (type=${c1?['unreadCount']?.runtimeType})');
    final c2 = await db.getConversation('c2');
    print('c2: unreadCount=${c2?['unreadCount']} (type=${c2?['unreadCount']?.runtimeType})');

    final total = await db.getTotalUnreadCount();
    print('SUM: $total');

    expect(c1?['unreadCount'], 3);
    expect(c2?['unreadCount'], 7);
    expect(total, 10);

    await db.close();
    dir.deleteSync(recursive: true);
  });
}
