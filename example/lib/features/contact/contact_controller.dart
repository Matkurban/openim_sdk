import 'dart:async';

import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

import '../../core/events/im_conversation_event.dart';
import '../../core/events/im_event_bus.dart';
import '../../core/events/im_group_event.dart';
import '../../core/events/im_relation_event.dart';

/// 联系人通讯录控制器（订阅 [ImEventBus] 同步好友与未处理申请红点）。
///
/// Contacts list controller subscribing to [ImEventBus].
class ContactController extends WireController {
  static final Logger _logger = Logger('ContactController');

  /// 全部好友列表信号。
  late final Signal<List<FriendInfo>> friends = createSignal<List<FriendInfo>>(
    <FriendInfo>[],
  );

  /// 好友申请未处理数量。
  late final Signal<int> unhandledFriendCount = createSignal<int>(0);

  /// 群通知未处理数量。
  late final Signal<int> unhandledGroupCount = createSignal<int>(0);

  /// 加载中状态。
  late final Signal<bool> loading = createSignal<bool>(false);

  StreamSubscription<ImRelationEvent>? _relationSub;
  StreamSubscription<ImGroupEvent>? _groupSub;
  StreamSubscription<ImConversationEvent>? _convSub;

  @override
  void onInit() {
    super.onInit();
    final ImEventBus bus = Wire.find<ImEventBus>();
    _relationSub = bus.relationStream.listen((ImRelationEvent _) {
      unawaited(loadAll());
    });
    _groupSub = bus.groupStream.listen((ImGroupEvent event) {
      if (event.kind.startsWith('application')) {
        unawaited(_refreshApplicationBadges());
      }
    });
    _convSub = bus.conversationStream.listen((ImConversationEvent event) {
      if (event.kind == 'syncFinish') {
        unawaited(loadAll());
      }
    });
    unawaited(loadAll());
  }

  /// 本地优先秒开加载好友列表，未处理申请角标异步刷新不阻塞首屏。
  Future<void> loadAll() async {
    try {
      final List<FriendInfo> list = await OpenIM.iMManager.friendshipManager
          .getFriendList(filterBlack: true);
      friends.value = list;
    } on Object catch (error, stackTrace) {
      _logger.warning('loadAll contacts failed', error, stackTrace);
    } finally {
      loading.value = false;
    }
    unawaited(_refreshApplicationBadges());
  }

  Future<void> _refreshApplicationBadges() async {
    try {
      final List<int> counts = await Future.wait<int>(<Future<int>>[
        OpenIM.iMManager.friendshipManager.getFriendApplicationUnhandledCount(),
        OpenIM.iMManager.groupManager.getGroupApplicationUnhandledCount(
          GetGroupApplicationUnhandledCountReq(),
        ),
      ]);
      unhandledFriendCount.value = counts[0];
      unhandledGroupCount.value = counts[1];
    } on Object catch (error, stackTrace) {
      _logger.fine('refreshApplicationBadges failed', error, stackTrace);
    }
  }

  @override
  void onClose() {
    _relationSub?.cancel();
    _groupSub?.cancel();
    _convSub?.cancel();
    super.onClose();
  }
}
