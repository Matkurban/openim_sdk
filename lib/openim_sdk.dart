/// OpenIM 纯 Dart 跨平台即时通讯 SDK 统一公开导出入口。
///
/// Unified public library entry point for the cross-platform pure-Dart OpenIM SDK.
library;

export 'src/open_im.dart';

/// 核心抽象基类 / Core Base Classes
export 'src/core/base_manager.dart';

/// 业务管理器 / Managers
export 'src/manager/im_manager.dart';
export 'src/manager/conversation_manager.dart';
export 'src/manager/group_manager.dart';
export 'src/manager/message/message_manager.dart';
export 'src/manager/relation_manager.dart';
export 'src/manager/user_manager.dart';
export 'src/manager/moments_manager.dart';
export 'src/manager/favorite_manager.dart';
export 'src/manager/call_manager.dart';
export 'src/manager/red_packet_manager.dart';
export 'src/manager/report_appeal_manager.dart';
export 'src/manager/application_manager.dart';

/// 并发原语与计算卸载 / Concurrency Utilities
export 'src/concurrency/async_semaphore.dart';
export 'src/concurrency/keyed_async_lock.dart';
export 'src/concurrency/sdk_compute_executor.dart';
export 'src/concurrency/serial_task_queue.dart';

/// 事件监听器 / Listeners
export 'src/listener/advanced_msg_listener.dart';
export 'src/listener/connect_listener.dart';
export 'src/listener/conversation_listener.dart';
export 'src/listener/custom_business_listener.dart';
export 'src/listener/friendship_listener.dart';
export 'src/listener/group_listener.dart';
export 'src/listener/listener_for_service.dart';
export 'src/listener/msg_send_progress_listener.dart';
export 'src/listener/upload_file_listener.dart';
export 'src/listener/user_listener.dart';
export 'src/listener/moments_listener.dart';
export 'src/listener/favorite_listener.dart';
export 'src/listener/call_listener.dart';
export 'src/listener/red_packet_listener.dart';

/// 数据模型 / Models
export 'src/models/api_response.dart';
export 'src/models/conversation_info.dart';
export 'src/models/group_info.dart';
export 'src/models/init_config.dart';
export 'src/models/input_status_changed_data.dart';
export 'src/models/message.dart';
export 'src/models/notification_info.dart';
export 'src/models/openim_exception.dart';
export 'src/models/search_info.dart';
export 'src/models/set_group_member_info.dart';
export 'src/models/update_req.dart';
export 'src/models/user_info.dart';
export 'src/models/moment_media.dart';
export 'src/models/moment_user_info.dart';
export 'src/models/moment_like.dart';
export 'src/models/moment_comment.dart';
export 'src/models/moment_info.dart';
export 'src/models/moment_create_req.dart';
export 'src/models/moment_list_response.dart';
export 'src/models/favorite_item.dart';
export 'src/models/favorite_list_response.dart';
export 'src/models/favorite_type.dart';
export 'src/models/link_info.dart';
export 'src/models/report_info.dart';
export 'src/models/appeal_info.dart';
export 'src/models/note_info.dart';
export 'src/models/application_version_info.dart';
export 'src/models/user_full_info.dart';
export 'src/models/auth_cache_data.dart';
export 'src/models/red_packet.dart';
export 'src/models/call_session.dart';
export 'src/models/call_record.dart';
export 'src/models/call_signal_elem.dart';
export 'src/models/red_packet_elem.dart';
export 'src/models/red_packet_grab_notify_elem.dart';

/// 枚举定义 / Enums
export 'src/enums/allow_type.dart';
export 'src/enums/conversation_type.dart';
export 'src/enums/group_at_type.dart';
export 'src/enums/group_member_filter.dart';
export 'src/enums/group_role_level.dart';
export 'src/enums/group_status.dart';
export 'src/enums/group_type.dart';
export 'src/enums/group_verification.dart';
export 'src/enums/im_platform.dart';
export 'src/enums/join_source.dart';
export 'src/enums/login_status.dart';
export 'src/enums/message_status.dart';
export 'src/enums/message_type.dart';
export 'src/enums/receive_message_opt.dart';
export 'src/enums/relationship.dart';
export 'src/enums/sdk_error_code.dart';
export 'src/enums/visible_type.dart';
export 'src/enums/call_state.dart';
export 'src/enums/call_type.dart';
export 'src/enums/call_signal_type.dart';
export 'src/enums/call_room_type.dart';

/// 工具类与第三方再导出 / Utils & Third-party Re-exports
export 'src/utils/open_im_utils.dart';
export 'package:logging/logging.dart' show Level, LogRecord;
export 'package:tostore/tostore.dart' hide LogRecord;
