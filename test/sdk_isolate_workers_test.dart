import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:openim_sdk/src/isolate/sdk_workers.dart';
import 'package:openim_sdk/src/utils/sdk_isolate_workers_core.dart';
import 'package:test/test.dart';

void main() {
  group('sdk isolate workers (direct)', () {
    test('md5Worker matches crypto.md5', () {
      final bytes = Uint8List.fromList(utf8.encode('hello'));
      expect(md5Worker(bytes), md5.convert(bytes).toString());
    });

    test('combinedMd5Worker hashes joined part hashes', () {
      final parts = ['aaa', 'bbb'];
      final expected = md5.convert(utf8.encode('aaa,bbb')).toString();
      expect(combinedMd5Worker(parts), expected);
    });

    test('decodeImageDimensions reads PNG IHDR size', () {
      final bytes = Uint8List(24);
      bytes[0] = 0x89;
      bytes[1] = 0x50;
      bytes[2] = 0x4E;
      bytes[3] = 0x47;
      bytes[16] = 0;
      bytes[17] = 0;
      bytes[18] = 0;
      bytes[19] = 10;
      bytes[20] = 0;
      bytes[21] = 0;
      bytes[22] = 0;
      bytes[23] = 20;
      expect(decodeImageDimensions(bytes), {'w': 10, 'h': 20});
    });

    test('searchFilterWorker matches keyword in text message', () {
      final data = [
        {
          'contentType': 101,
          'content': jsonEncode({'content': 'hello world'}),
          'sendTime': 100,
        },
        {
          'contentType': 101,
          'content': jsonEncode({'content': 'goodbye'}),
          'sendTime': 200,
        },
      ];
      final result = searchFilterWorker({
        'data': data,
        'keyword': 'hello',
        'messageTypes': null,
        'startTime': null,
        'endTime': null,
        'offset': 0,
        'count': 40,
      });
      expect(result, hasLength(1));
      expect((result.first as Map)['sendTime'], 100);
    });

    test('historyFilterWorker drops messages after the start cursor', () {
      final data = [
        {'sendTime': 10, 'seq': 1, 'clientMsgID': 'a'},
        {'sendTime': 20, 'seq': 2, 'clientMsgID': 'b'},
        {'sendTime': 30, 'seq': 3, 'clientMsgID': 'c'},
      ];
      final result = historyFilterWorker({
        'data': data,
        'startTime': 20,
        'startSeq': 2,
        'startClientMsgID': 'b',
        'count': 10,
      });
      expect(result, hasLength(1));
      expect((result.first as Map)['clientMsgID'], 'a');
    });
  });

  group('SdkWorkers pool', () {
    tearDown(() async {
      await SdkWorkers.dispose();
    });

    test('run executes md5Worker off the current isolate', () async {
      final bytes = Uint8List.fromList(utf8.encode('openim'));
      final hash = await SdkWorkers.run<String>(() => md5Worker(bytes));
      expect(hash, md5.convert(bytes).toString());
    });
  });
}
