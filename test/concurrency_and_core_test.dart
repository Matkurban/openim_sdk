import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:openim_sdk/src/db/db_schema.dart';
import 'package:openim_sdk/src/db/repositories/conversation_repository.dart';
import 'package:openim_sdk/src/sync/notification_classifier.dart';
import 'package:openim_sdk/src/sync/typing_state_tracker.dart';

void main() {
  group('Concurrency primitives', () {
    test('AsyncSemaphore enforces max concurrency', () async {
      final AsyncSemaphore semaphore = AsyncSemaphore(2);
      int active = 0;
      int peak = 0;

      final List<Future<void>> futures = List<Future<void>>.generate(6, (int index) {
        return semaphore.run<void>(() async {
          active++;
          if (active > peak) {
            peak = active;
          }
          await Future<void>.delayed(const Duration(milliseconds: 20));
          active--;
        });
      });

      await Future.wait<void>(futures);
      expect(peak, lessThanOrEqualTo(2));
      expect(active, equals(0));
    });

    test('SerialTaskQueue executes tasks strictly in FIFO order', () async {
      final SerialTaskQueue queue = SerialTaskQueue();
      final List<int> order = <int>[];

      final Future<int> first = queue.enqueue<int>(() async {
        await Future<void>.delayed(const Duration(milliseconds: 25));
        order.add(1);
        return 1;
      });
      final Future<int> second = queue.enqueue<int>(() async {
        order.add(2);
        return 2;
      });
      final Future<int> third = queue.enqueue<int>(() async {
        order.add(3);
        return 3;
      });

      final List<int> results = await Future.wait<int>(<Future<int>>[first, second, third]);
      expect(results, equals(<int>[1, 2, 3]));
      expect(order, equals(<int>[1, 2, 3]));
    });

    test('KeyedAsyncLock serializes same key and allows different keys concurrently', () async {
      final KeyedAsyncLock lock = KeyedAsyncLock();
      final List<String> events = <String>[];

      final Future<void> a1 = lock.synchronized<void>('conv_a', () async {
        events.add('a1_start');
        await Future<void>.delayed(const Duration(milliseconds: 30));
        events.add('a1_end');
      });
      final Future<void> a2 = lock.synchronized<void>('conv_a', () async {
        events.add('a2_start');
        events.add('a2_end');
      });
      final Future<void> b1 = lock.synchronized<void>('conv_b', () async {
        events.add('b1_start');
        events.add('b1_end');
      });

      await Future.wait<void>(<Future<void>>[a1, a2, b1]);
      expect(events.indexOf('a1_end'), lessThan(events.indexOf('a2_start')));
      expect(events.indexOf('b1_end'), lessThan(events.indexOf('a1_end')));
    });

    test('SdkComputeExecutor computes MD5 and PNG dimensions accurately', () async {
      final Uint8List helloBytes = Uint8List.fromList(utf8.encode('hello'));
      final String digest = await SdkComputeExecutor.computeMd5(helloBytes);
      expect(digest, equals('5d41402abc4b2a76b9719d911017c592'));

      // Minimal valid 24-byte PNG header with 320x240 dimensions.
      final Uint8List pngHeader = Uint8List.fromList(<int>[
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
        0x00, 0x00, 0x01, 0x40, // width = 320
        0x00, 0x00, 0x00, 0xF0, // height = 240
      ]);
      final ImageDimensions? dims = await SdkComputeExecutor.decodeImageDimensions(pngHeader);
      expect(dims, isNotNull);
      expect(dims!.width, equals(320));
      expect(dims.height, equals(240));
    });
  });

  group('MessageType and NotificationClassifier', () {
    test('MessageType supports conference and meeting notification values 127-129', () {
      expect(MessageType.fromValue(127), equals(MessageType.conference));
      expect(MessageType.fromValue(128), equals(MessageType.meetingReminder));
      expect(MessageType.fromValue(129), equals(MessageType.meetingScheduleNotify));
    });

    test('NotificationClassifier separates hidden control vs visible chat tips', () {
      expect(NotificationClassifier.isNotification(101), isFalse);
      expect(NotificationClassifier.isNotification(1201), isTrue);
      expect(NotificationClassifier.isRevokeNotification(2101), isTrue);

      expect(NotificationClassifier.shouldPersistInChatLog(101), isTrue);
      expect(NotificationClassifier.shouldPersistInChatLog(1201), isTrue);
      expect(NotificationClassifier.shouldPersistInChatLog(1501), isTrue);
      expect(NotificationClassifier.shouldPersistInChatLog(1701), isTrue);

      expect(NotificationClassifier.shouldPersistInChatLog(2101), isFalse);
      expect(NotificationClassifier.shouldPersistInChatLog(2102), isFalse);
      expect(NotificationClassifier.shouldPersistInChatLog(2200), isFalse);
      expect(NotificationClassifier.shouldPersistInChatLog(1703), isFalse);
    });
  });

  group('TypingStateTracker, DbSchema & ConversationRepository', () {
    test('TypingStateTracker tracks and clears active platforms per conversation', () {
      final TypingStateTracker tracker = TypingStateTracker();
      final List<int> active = tracker.update(
        conversationID: 'si_a_b',
        userID: 'u1',
        platformID: 2,
        isTyping: true,
      );
      expect(active, equals(<int>[2]));
      expect(tracker.getActivePlatforms('si_a_b', 'u1'), equals(<int>[2]));

      final List<int> cleared = tracker.update(
        conversationID: 'si_a_b',
        userID: 'u1',
        platformID: 2,
        isTyping: false,
      );
      expect(cleared, isEmpty);
      expect(tracker.getActivePlatforms('si_a_b', 'u1'), isEmpty);
    });

    test('DbSchema.compositeKey builds deterministic keys', () {
      expect(DbSchema.compositeKey('g1', 'u1'), equals('g1_u1'));
    });

    test('ConversationRepository.sortConversations pins first then orders by max timestamp', () {
      final List<ConversationInfo> list = <ConversationInfo>[
        const ConversationInfo(conversationID: 'c1', latestMsgSendTime: 100, isPinned: false),
        const ConversationInfo(conversationID: 'c2', latestMsgSendTime: 50, isPinned: true),
        const ConversationInfo(
          conversationID: 'c3',
          latestMsgSendTime: 80,
          draftTextTime: 200,
          isPinned: false,
        ),
      ];
      final List<ConversationInfo> sorted = ConversationRepository.sortConversations(list);
      expect(
        sorted.map<String>((ConversationInfo c) => c.conversationID).toList(),
        equals(<String>['c2', 'c3', 'c1']),
      );
    });
  });
}
