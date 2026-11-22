import 'dart:async';

import 'package:logging/logging.dart';
import 'package:openim_sdk/openim_sdk.dart';
import 'package:signal_wire/signal_wire.dart';

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
  late final Signal<bool> loading = createSignal<bool>(true);

  StreamSubscription<ImRelationEvent>? _relationSub;
  StreamSubscription<ImGroupEvent>? _groupSub;

  @override
  void onInit() {
    super.onInit();
    final ImEventBus bus = Wire.find<ImEventBus>();
    _relationSub = bus.relationStream.listen((ImRelationEvent _) {
      unawaited(loadAll());
    });
    _groupSub = bus.groupStream.listen((ImGroupEvent event) {
      if (event.kind.startsWith('application')) {
        unawaited(loadAll());
      }
    });
    unawaited(loadAll());
  }

  /// 加载好友列表及未处理申请数。
  Future<void> loadAll() async {
    try {
      final List<FriendInfo> list = await OpenIM.iMManager.friendshipManager
          .getFriendList(filterBlack: true);
      final int fCount = await OpenIM.iMManager.friendshipManager
          .getFriendApplicationUnhandledCount();
      final int gCount = await OpenIM.iMManager.groupManager
          .getGroupApplicationUnhandledCount(
            GetGroupApplicationUnhandledCountReq(),
          );
      friends.value = list;
      unhandledFriendCount.value = fCount;
      unhandledGroupCount.value = gCount;
    } on Object catch (error, stackTrace) {
      _logger.warning('loadAll contacts failed', error, stackTrace);
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    _relationSub?.cancel();
    _groupSub?.cancel();
    super.onClose();
  }
}
