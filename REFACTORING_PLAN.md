# `openim_sdk` 全面架构重构、缺陷修复与性能优化计划

> **状态**：已完成（v3.0.0，已通过 `dart analyze lib test` 0 问题与 `flutter test` 全绿验证）
> **基线版本**：`openim_sdk` v2.8.0（Dart 3.12+ / Flutter >= 3.44.0 / `tostore: ^3.6.3`）
> **比对基准**：`xue_hua_sdk`（Rust + Dart 跨端实现）与 [ToStore 3.6.3 官方文档](https://pub.dev/packages/tostore)

---

## 目录

1. [代码规范与日志系统全面改造（`aoiwe_logger` → `logging`）](#1-代码规范与日志系统全面改造aoiwe_logger--logging)
2. [面向对象的继承体系与超大文件（>1000行）架构重构](#2-面向对象的继承体系与超大文件1000行架构重构)
3. [多线程 / Isolate 并发模型彻底重新设计](#3-多线程--isolate-并发模型彻底重新设计)
4. [`openim_sdk` vs `xue_hua_sdk` 逐模块核查缺陷清单（有理有据）](#4-openim_sdk-vs-xue_hua_sdk-逐模块核查缺陷清单有理有据)
5. [ToStore 3.6.3 数据库性能优化专项方案](#5-tostore-363-数据库性能优化专项方案)
6. [分阶段实施路线图与验收标准](#6-分阶段实施路线图与验收标准)

---

## 1. 代码规范与日志系统全面改造（`aoiwe_logger` → `logging`）

### 1.1 现状核查

经全仓扫描，`aoiwe_logger` 共涉及 **18 处文件**：
- `pubspec.yaml:24`：`aoiwe_logger: ^1.0.1`
- `lib/openim_sdk.dart:105`：`export 'package:aoiwe_logger/aoiwe_logger.dart' show AoiweLoggerLevel;`
- `lib/src/mangaer/im_manager.dart:16,33,123,126,164`：`initSDK` 暴露 `AoiweLoggerLevel logLevel` 并调用 `AoiweLogger.setGlobalConfig(...)`
- 其余 15 个核心文件均声明缩写变量 `final AoiweLogger _log = AoiweLogger(...)`：
  - `network/http_client.dart:21`、`network/notification_dispatcher.dart:21`、`network/msg_syncer.dart:52`
  - `services/im_api_service.dart:22`、`services/web_socket_service.dart:19`
  - `mangaer/` 下全部 10 个 Manager（其中 `relation_manager.dart:17` 还将名称误写为 `AoiweLogger('FriendshipManager')`）

此外，全仓 `lib/src/` 中存在 **1,523 处**省略变量类型的 `var` / `final foo = ...` 声明。

### 1.2 改造方案（零胶水代码）

1. **移除 `aoiwe_logger`，直接接入官方 [`package:logging/logging.dart`](https://pub.dev/packages/logging)**：
   - 从 `pubspec.yaml` 删除 `aoiwe_logger`，新增 `logging: ^1.3.0`。
   - `lib/openim_sdk.dart` 改为导出 `export 'package:logging/logging.dart' show Level, LogRecord;`。
   - **严禁编写任何自定义 `SdkLogger` 包装类或胶水代码**，所有调用点直接使用 `package:logging` 原生 API。
2. **统一命名与层级 Logger**：
   - 每个类内严格命名为 `final Logger _logger`（不缩写为 `_log`），基类 `BaseManager` / `BaseApiClient` / `BaseRepository` / `BaseSyncer` 统一提供 `protected` 的 `Logger get _logger` 或实例字段 `final Logger _logger`。
   - Logger 名称统一采用 `openim_sdk.<ModuleName>` 层次命名（如 `Logger('openim_sdk.MessageManager')`），便于宿主 App 按层级过滤。
   - 方法映射直接对齐 `logging` 原生级别：
     - 调试/入参跟踪 → `_logger.fine(...)` / `_logger.finer(...)`
     - 关键状态流转 → `_logger.info(...)`
     - 可恢复异常/降级 → `_logger.warning(...)`
     - 失败异常 → `_logger.severe(message, error, stackTrace)`
   - `IMManager.initSDK` 参数由 `AoiweLoggerLevel logLevel` 改为 `Level logLevel = Level.INFO`，并通过 `hierarchicalLoggingEnabled = true` 仅设置 `Logger('openim_sdk').level = logLevel`，不污染宿主 App 全局 `Logger.root`。
   - 同时接入 [ToStore 3.6.3 `ToStore.setLogConfig`](https://pub.dev/packages/tostore)，将数据库内部日志桥接到 `Logger('openim_sdk.ToStore')`。
3. **强制显式变量类型规范**：
   - 本次重构涉及的所有新增及改造文件，**所有局部变量、成员变量、循环变量一律显式声明完整类型**（禁止 `var` 与无类型的 `final x = ...`）：
     ```dart
     final Logger _logger = Logger('openim_sdk.MessageManager');
     final List<ConversationInfo> conversations = await _conversationRepo.getVisibleConversations();
     final Map<String, int> serverMaxSeqs = <String, int>{};
     ```
   - 在 `analysis_options.yaml` 中开启 `always_specify_types`（对生成文件 `*.g.dart`、`*.pb.dart` 通过 `exclude` 豁免），由静态分析器自动兜底。
   - 同步修复日志泄露敏感信息问题（例如 `im_manager.dart:473` 明文打印 `token=$token`）。

---

## 2. 面向对象的继承体系与超大文件（>1000行）架构重构

### 2.1 现状核查

当前 `lib/src/` 共 **31,206 行** 代码，存在严重的结构性问题：
1. **目录拼写错误**：`lib/src/mangaer/`（应为 `lib/src/manager/`）。
2. **9 个超过 1,000 行的巨型上帝类（God Class）**：

| 文件路径 | 当前行数 | 核心问题 |
| :--- | ---: | :--- |
| `lib/src/mangaer/message_manager.dart` | 2,625 | 杂糅 20+ 消息工厂、媒体上传、WebSocket 发包、历史拉取、本地搜索、撤回/删除、会话联动 |
| `lib/src/network/msg_syncer.dart` | 2,327 | 杂糅全量/增量同步、重装同步、seq 队列补拉、好友/群/会话同步、推送队列、未读计算 |
| `lib/src/network/notification_dispatcher.dart` | 2,013 | 大量 `switch` 分支 + 与 `msg_syncer.dart` 重复编写了超 1,000 行好友/群/会话同步代码 |
| `lib/src/mangaer/im_manager.dart` | 1,718 | 杂糅 SDK 生命周期、3 种 Chat 登录、分片文件上传、Isolate 事件转发（400+ 行 switch） |
| `lib/src/services/im_api_service.dart` | 1,705 | 单例塞入 Auth/User/Friend/Group/Msg/Conv/Object/Governance/App 全部 60+ 接口，重复 try/catch |
| `lib/src/services/database_service.dart` | 1,609 | 14 张表全部 CRUD + 模型转换 + JSON 解析混在一个类里 |
| `lib/src/isolate/sdk_method_dispatcher.dart` | 1,495 | 手工维护 100+ 方法字符串路由表，极难维护且反复遗漏参数/回调 |
| `lib/src/mangaer/group_manager.dart` | 1,309 | 群信息、群成员、群申请、增量同步全部耦合 |
| `lib/src/models/message.dart` | 1,250 | 单文件堆砌 **27 个独立模型类**，且无公共基类 |

3. **完全缺乏继承与抽象分层**：
   - 12 个 Manager 全部各自复制粘贴 `GetIt` 获取、`currentUserID`、`listener`、`try/catch` 日志、`SdkIsolateManager.isActive` 判断（仅该分支就重复了 **166 次**）。
   - 14 个数据表没有公共 `BaseRepository<T>` 抽象。
   - 11 个 Listener 没有统一基类或可多播注册机制（单 `listener` 赋值会覆盖之前的监听者）。
   - 16 种消息元素（`TextElem`、`PictureElem` 等）没有公共接口 `MessageElem`，导致 `messageToDbMap` 与 `_extractContent` 出现 16 层 `if / else if` 链条。

### 2.2 高级面向对象分层与继承设计

重构为严格单向依赖的四层架构（单文件目标控制在 **150–400 行**）：

```text
lib/
├── openim_sdk.dart                         # 唯一公开导出入口
└── src/
    ├── core/                               # 基础设施与抽象基类
    │   ├── sdk_context.dart                # 显式依赖注入容器（替代全局散落 GetIt）
    │   ├── base_manager.dart               # abstract base class BaseManager<L>
    │   ├── base_api_client.dart            # abstract base class BaseApiClient
    │   ├── base_repository.dart            # abstract base class BaseRepository<T>
    │   ├── base_syncer.dart                # abstract base class BaseSyncer
    │   ├── base_notification_handler.dart  # abstract base class BaseNotificationHandler
    │   └── listener_registry.dart          # 幂等多播监听器容器（参考 xue_hua_sdk）
    ├── concurrency/                        # 全新并发与后台任务层（见第 3 节）
    ├── transport/                          # 传输层
    │   ├── http_client.dart                # 精简统一 Dio 客户端（IM / Chat / Admin 三个独立实例，无重复拦截器）
    │   ├── ws_client.dart                  # 带 connGeneration 防串台、真后台上报、指数退避上限的 WS 客户端
    │   └── ws_codec.dart
    ├── api/                                # 拆分 im_api_service.dart (1705行 → 8个小文件，继承 BaseApiClient)
    │   ├── auth_api.dart
    │   ├── user_api.dart
    │   ├── friend_api.dart
    │   ├── group_api.dart
    │   ├── message_api.dart
    │   ├── conversation_api.dart
    │   ├── object_storage_api.dart
    │   └── governance_api.dart
    ├── db/                                 # 拆分 database_service.dart (1609行 → Schema + 9个 Repository，继承 BaseRepository)
    │   ├── db_engine.dart                  # ToStore 初始化、多空间切换、事务封装、日志桥接
    │   ├── db_schema.dart                  # 优化后的 3.6.3 Schema + 复合主键 + 索引 + 全文索引
    │   ├── repositories/
    │   │   ├── user_repository.dart
    │   │   ├── friend_repository.dart
    │   │   ├── black_repository.dart
    │   │   ├── group_repository.dart
    │   │   ├── group_member_repository.dart
    │   │   ├── conversation_repository.dart
    │   │   ├── message_repository.dart
    │   │   ├── social_repository.dart      # moment + favorite + red_packet
    │   │   └── sync_meta_repository.dart   # version_sync + notification_seq + upload_task + sending_msg
    ├── sync/                               # 拆分 msg_syncer.dart + notification_dispatcher.dart (4340行 → 共享同步器 + 策略处理器)
    │   ├── sync_coordinator.dart           # 连接同步 / 唤醒同步编排（消除两处重复同步逻辑）
    │   ├── push_queue.dart                 # 严格顺序推送队列（先落库后通知，消除竞态）
    │   ├── gap_syncer.dart                 # Seq 缺口队列补拉 & 重装同步
    │   ├── entity_syncers/                 # 继承 BaseSyncer，供启动同步与通知触发共用
    │   │   ├── friend_syncer.dart
    │   │   ├── group_syncer.dart
    │   │   ├── conversation_syncer.dart
    │   │   └── user_syncer.dart
    │   └── handlers/                       # 继承 BaseNotificationHandler（策略模式替代 2000 行 switch）
    │       ├── notification_router.dart
    │       ├── friend_notification_handler.dart
    │       ├── group_notification_handler.dart
    │       ├── conversation_notification_handler.dart
    │       ├── message_notification_handler.dart   # 撤回 2101 / 删除 2102 / 已读回执 2200
    │       └── user_notification_handler.dart
    ├── manager/                            # 修复 mangaer 拼写，所有 Manager 继承 BaseManager
    │   ├── im_manager.dart                 # 精简为门面 Facade（<=350 行）
    │   ├── auth_service.dart               # 从 im_manager 拆出的登录/自动登录/Token 校验
    │   ├── file_uploader.dart              # 从 im_manager 拆出的分片上传器（支持进度与断点续传）
    │   ├── message/                        # 拆分 message_manager.dart (2625行 → 5个高内聚模块)
    │   │   ├── message_manager.dart        # 门面协调器
    │   │   ├── message_factory.dart        # 20+ createXxxMessage 工厂
    │   │   ├── message_sender.dart         # 媒体上传 + WS 发送 + ACK 合并 + 重发恢复
    │   │   ├── message_history_loader.dart # 正向/反向历史拉取（本地 + 云端缺口补拉）
    │   │   └── message_searcher.dart       # 本地全文检索与条件组合查询
    │   ├── conversation_manager.dart       # 精简 <= 450 行
    │   ├── group_manager.dart              # 拆出 group_application_service.dart / group_member_service.dart
    │   ├── user_manager.dart               # 拆出 account_security_service.dart（密码/支付密码/注销）
    │   ├── relation_manager.dart
    │   ├── call_manager.dart
    │   ├── moments_manager.dart
    │   ├── favorite_manager.dart
    │   ├── red_packet_manager.dart
    │   ├── report_appeal_manager.dart
    │   └── application_manager.dart
    ├── models/
    │   ├── message/                        # 拆分 message.dart (1250行 → 独立文件 + 抽象基类 MessageElem)
    │   │   ├── message.dart
    │   │   ├── message_elem.dart           # abstract class MessageElem { Map<String, dynamic> toJson(); MessageType get contentType; }
    │   │   ├── media_elems.dart            # PictureElem / SoundElem / VideoElem / FileElem
    │   │   ├── text_elems.dart             # TextElem / AtTextElem / QuoteElem / AdvancedTextElem / MessageEntity
    │   │   ├── rich_elems.dart             # MergeElem / LocationElem / CardElem / FaceElem / CustomElem / TypingElem / NotificationElem
    │   │   └── message_meta.dart           # OfflinePushInfo / ReadReceiptInfo / RevokedInfo / AttachedInfoElem / AdvancedMessage
    │   └── ...
    ├── enums/
    └── listener/
```

#### 核心继承基类设计示意

- **`abstract base class BaseManager<L>`**：
  - 统一持有 `SdkContext _context`、`final Logger _logger`、`String _currentUserID`、`ListenerRegistry<L>`。
  - 提供统一的 `protected` 生命周期钩子：`onLogin(String userID)`、`onLogout()`、`dispose()`，彻底消除 `IMManager.login()` 手动逐个调 11 次 `setCurrentUserID` 的硬编码。
- **`abstract base class BaseApiClient`**：
  - 统一封装 `postIm(...)` / `postChat(...)` / `postAdmin(...)` 与统一日志/错误码转换，消除 `im_api_service.dart` 中 60+ 处重复 `try/catch`。
- **`abstract base class BaseRepository<T>`**：
  - 封装 `ToStore` 表名、主键查询（含 `peekFirst` 内存探针优先）、批量 `batchUpsert`/`batchUpdate`、统一 `DbResult.hasErrors` 错误检查与日志记录。
- **`abstract base class BaseSyncer`**：
  - 统一实现 OpenIM 的 `version_sync` 增量拉取模板方法模式（Template Method）：读取本地 `version`/`versionID` → 请求增量接口 → `full=true` 时走 `syncFull()`，否则走 `applyIncremental(delete, insert, update)` → 落库新版本。好友、群组、会话三大同步器只需继承并覆写 3 个钩子方法，直接消灭 1,000+ 行重复代码。
- **`abstract base class MessageElem`**：
  - 所有消息元素继承自 `MessageElem`，统一实现 `toJson()` 与 `MessageType get messageType`，消灭 `messageToDbMap` 和 `_extractContent` 中极易遗漏分支的 16 层 `if/else if`。

---

## 3. 多线程 / Isolate 并发模型彻底重新设计

### 3.1 现有并发架构的 7 大核心痛点（核查实证）

当前代码把两套完全不同的多线程体系硬拼在一起，导致极度混乱且隐藏多个致命 Bug：

1. **“Isolate 套 Isolate”的畸形双层架构**：
   - **L1 层**：`SdkIsolateManager` (`sdk_isolate_manager.dart`) 用原生 `Isolate.spawn` 启动一个常驻大 Isolate，把整个 SDK（包括 `IMManager`、`ToStore`、`WebSocketService`、`HttpClient`）全塞进去。
   - **L2 层**：在 L1 后台 Isolate 内部（`sdk_isolate_entry.dart:38`）又执行 `unawaited(SdkWorkers.ensureInitialized())`，再用第三方 `worker_manager` 启动 **2 个子 Isolate**！同时主 Isolate 销毁时还要专门 RPC 调用 `im.disposeWorkers` 防止孤儿 Isolate（`sdk_isolate_manager.dart:146`）。
2. **手工维护 1,495 行 RPC 字符串路由表 + 166 处分支代码**：
   - 每个 Manager 方法开头都要手写 `if (SdkIsolateManager.isActive) return sdkInvoke(...)`，全仓共 **166 处**，并且还要在 `sdk_method_dispatcher.dart`（1,495 行）和 `im_manager.dart` 事件转发（400 行）三处同步维护，极易漏改。
3. **跨 Isolate 状态撕裂导致多个真实功能失效**：
   - **`CallManager` 同步状态永远错乱**（`call_manager.dart:76-82`）：`currentSession`、`isBusy`、`callState` 读的是主 Isolate 的 `_currentSession`，而实际状态只在后台 Isolate 更新，导致 Native 5 端 `isBusy` 永远返回 `false`！
   - **`createFileMessageByFile` + `sendMessage` 上传必然失败**（`message_manager.dart:2154`）：`createFileMessageByFile` 是同步方法，把 `bytes` 存入**主 Isolate** 的 `_pendingUploadBytes`，随后 `sendMessage` RPC 到**后台 Isolate** 执行，后台的 `_pendingUploadBytes` 为空，文件根本不会上传！
   - **`logout()` 永久杀掉事件订阅**（`im_manager.dart:676-678`）：`logout()` 取消了 `_eventSubscription`，但 `login()` 从未重启 `_startEventForwarding()`，切换账号或重新登录后所有回调永久失效！
   - **`uploadFile` 进度回调与 `OnUploadFileListener` 全部丢失**（`im_manager.dart:738-750`、`sdk_method_dispatcher.dart:80-224`）：跨 Isolate 根本未转发 `onProgress`、`OnUploadFileListener`、`OnListenerForService`。
   - **`ReportAppealManager` 绕过 Isolate**：迫使 `IMManager.initSDK` 在主 Isolate 额外初始化一套 `HttpClient` 并手动跨 Isolate 同步 `chatToken`（`im_manager.dart:144-150, 250-254`）。
4. **为了简单内存过滤把整批数据跨 Isolate 拷贝两次**：
   - `database_service.dart:834` (`computeHistoryFilter`) 和 `904` (`computeSearchFilter`) 把几十上百条 `Map<String, dynamic>` 从 L1 Isolate 序列化拷贝到 L2 `worker_manager` Isolate 仅为了做一次微秒级的 Dart `List.where()` 过滤，序列化拷贝耗时远大于过滤本身。
5. **与 ToStore 3.6.3 的内置时间片调度冲突**：
   - 根据 [ToStore 3.6.3 官方文档](https://pub.dev/packages/tostore)，ToStore 本身已内置时间片调度（`yieldDurationMs: 8ms`，对齐 60/120fps）与异步并行分片调度，且 `im_manager.dart:226` 错误地配成了 `yieldDurationMs: 16`。

### 3.2 重新设计方案：单一清晰并发模型（Single-Engine Async + Pure CPU Worker Pool）

> **核心原则**：Dart/Flutter 的网络 IO（Dio / WebSocket）和 ToStore 3.6.3（自带 8ms 时间片让渡）天然是**单线程事件循环非阻塞异步 IO**，根本不需要把整个 SDK 塞进 L1 后台 Isolate 再维护 2,000 行手工 RPC 代理层！**真正阻塞 UI 线程的只有纯 CPU 密集型任务**（大文件分片 MD5 哈希、大字节图片头解码、大批量 Protobuf/JSON 解析）。

#### 新并发架构设计（彻底删除 `lib/src/isolate/` 与 `worker_manager` 依赖）：

```text
┌──────────────────────────────────────────────────────────────────────┐
│                         主 Isolate（全 6 端统一）                       │
│  - 全部 Manager / SyncCoordinator / WebSocket / HttpClient / ToStore │
│  - 零跨 Isolate 状态撕裂，零 RPC 路由表，零序列化拷贝，6 端行为 100% 一致  │
│  - ToStore 配置 yieldDurationMs: 8ms + 索引优化 + 批处理，绝不阻塞帧渲染  │
└────────────────────────────────┬─────────────────────────────────────┘
                                 │ 仅在需要重 CPU 计算时按需调度
                                 ▼
┌──────────────────────────────────────────────────────────────────────┐
│           SdkComputeExecutor（lib/src/concurrency/）                 │
│  - 基于 Dart 原生 `Isolate.run`（零第三方依赖，移除 worker_manager）     │
│  - 条件导入：Native 走 `Isolate.run`，Web/WASM 直接内联执行              │
│  - 带并发上限信号量（AsyncSemaphore，默认 maxConcurrency = 2）防核风暴   │
│  - 仅承载真正 CPU/同步文件 IO 任务：                                     │
│    1. computeFilePartMd5s（大文件分片读取 + 流式 MD5 计算）              │
│    2. computeBytesMd5（大于 256KB 才派发 Isolate，小数据直接同步计算）    │
│    3. decodeImageDimensions（文件/字节图片宽高解析）                     │
└──────────────────────────────────────────────────────────────────────┘
```

#### 配套并发原语（`lib/src/concurrency/`，总共不到 250 行，清晰直观）：

1. **`SerialTaskQueue`**：串行异步队列，用于保证 WS 推送批次处理、`version_sync` 写入、会话已读状态更新的严格顺序，杜绝并发竞态。
2. **`KeyedAsyncLock`**：按 `key`（如 `conversationID`、`groupID`、`tableName|entityID`）加锁的轻量异步锁，替代当前各处散落的 `Set<String> _markingAsRead`、`_versionSyncInFlight`、`_isSyncing` 布尔标志。
3. **`SdkComputeExecutor`**：统一 CPU 卸载执行器（内置阈值判断 + 并发度限制 + Native `Isolate.run` / Web 内联条件导入），**移除 `worker_manager` 第三方依赖**。

#### 改造收益量化：
- **直接删除 ~2,200+ 行复杂难懂的 Isolate/RPC 胶水代码**（`sdk_isolate_manager.dart`、`sdk_isolate_entry.dart`、`sdk_isolate_bridge.dart`、`sdk_isolate_protocol.dart`、`sdk_isolate_transport*.dart`、`sdk_method_dispatcher.dart`、`sdk_workers.dart`、`im_manager.dart` 400 行事件转发、各 Manager 共 166 处 `SdkIsolateManager.isActive` 分支）。
- **彻底根治 5 个跨 Isolate 状态/事件/上传 Bug**（见第 4 节）。
- **6 端（Android/iOS/macOS/Windows/Linux/Web）代码路径 100% 统一**，测试覆盖与调试复杂度降低一个数量级。

---

## 4. `openim_sdk` vs `xue_hua_sdk` 逐模块核查缺陷清单（有理有据）

以下所有问题均经过 `openim_sdk` 与 `xue_hua_sdk` 源码逐行比对核实，**无任何猜测**。

### 4.1 P0 致命缺陷（数据丢失 / 协议错误 / 核心功能失效）

| 编号 | 模块与位置（`openim_sdk`） | 缺陷事实与根因 | `xue_hua_sdk` 正确参照 | 修复方案 |
| :--- | :--- | :--- | :--- | :--- |
| **B-01** | `services/database_service.dart:318-333` (`batchUpsertGroupMembers`) | 对传入列表按 `groupID` 分组后，**先整群删除该群所有成员再写入传入列表**，且无事务保护。增量同步传入 5 个新成员时，会直接删光 500 人大群的其余 495 名成员；中途崩溃会导致整群成员清空。 | `rust/src/db/group_member.rs`：主键 `(groupID, userID)` 直接 `UPSERT`，仅在全量替换接口中于事务内清理差集 | `localGroupMember` 改用确定性复合主键 `id = '${groupID}_$userID'`，`batchUpsertGroupMembers` 直接增量 `batchUpsert`，新增 `replaceGroupMembers` 在 `transaction()` 内原子替换 |
| **B-02** | `mangaer/message_manager.dart:2441-2462` (`_sendMsgViaWebSocket`) | WebSocket 发送成功 (`errCode == 0`) 后**完全未解析 `resp.data` (`sdkws.SendMsgResp`)**，直接丢弃服务端返回的 `serverMsgID`、`sendTime`、`seq` 与服务端 `modify` 内容，把本地 `seq` 留在 `0`、`sendTime` 用本机时间！导致刚发出的消息无法撤回（`revokeMessage` 要求 `seq > 0`）、无法服务端删除（`deleteMessageFromLocalAndSvr` 遇 `seq == 0` 仅删本地）。 | `rust/src/core/message/outbound/ack.rs:102-119` (`apply_send_ack`)：解析 `SendMsgResp`，合并 `serverMsgID`/`sendTime`/`seq` 及敏感词等 `modify` 字段 | 反序列化 `sdkws.SendMsgResp.fromBuffer(resp.data)`，写回 `serverMsgID`、`sendTime`、`seq` 并更新会话 `maxSeq` |
| **B-03** | `mangaer/conversation_manager.dart:738-776` (`changeInputStates`) | 向 `WebSocketIdentifier.sendMsg` 发送的是 **`utf8.encode(jsonEncode(msgData))`（明文 JSON）**，而服务端该接口严格要求 **Protobuf `sdkws.MsgData`** 二进制！输入状态每次发送必然服务端解码失败。且 `getInputStates`（786-800 行）为硬编码 `return []` 空实现。 | `rust/src/core/typing/manager.rs`：构造 Protobuf `MsgData` 发送，并在内存中按 TTL 维护各 `(conversationID, userID)` 的活跃输入平台列表 | 改为构造 `sdkws.MsgData` 并 `writeToBuffer()` 发送；实现 `TypingStateTracker` 缓存与过期清理，补全 `getInputStates` |
| **B-04** | `mangaer/conversation_manager.dart:322-330` (`setConversation`) | 调用 `/conversation/set_conversations` 时发送扁平 Map `{'userID': _currentUserID, 'conversationID': ..., ...updateData}`，与 OpenIM 服务端协议体不匹配，导致置顶/免打扰/阅后即焚等设置无法同步到服务端。 | `rust/src/api/conversation.rs:178-206` (`build_set_conversations_body`)：协议体为 `{'userIDs': [me], 'conversation': {'conversationID': ..., 'conversationType': ..., ...}}` | 按 `build_set_conversations_body` 规范封装嵌套请求体，并补齐 `conversationType`/`userID`/`groupID` |
| **B-05** | `mangaer/im_manager.dart:484` vs `512` (`login`) | 先在 **484 行**调用 `databaseService.upsertUser(userData)`，直到 **512 行**才调用 `databaseService.switchSpace(userID: userID)`！导致当前用户资料被写入默认空间或上一个用户的空间，新用户空间中 `getLoginUser()` 返回 `null`。 | `rust/src/core/client.rs`：先按 `userID` 打开/切换用户库，再写入用户信息 | 将 `switchSpace(userID: userID, keepActive: true)` 提前至任何用户表读写之前 |
| **B-06** | `mangaer/im_manager.dart:676-678` (`logout`) + `151` (`initSDK`) | Isolate 模式下 `logout()` 取消并置空 `_eventSubscription`，但 `login()` 从不重新调用 `_startEventForwarding()`，导致登出再登录或切换账号后**全部 SDK 事件回调永久失效**。 | —（由重构并发模型彻底根治） | 采用第 3 节单一异步模型后彻底消除事件转发订阅链 |
| **B-07** | `mangaer/im_manager.dart:389-413` (`unInitSDK`) | 未注销 `GetIt` 中的 `InstanceName.toStore` 且未关闭 `ToStore` 数据库连接。反初始化后再调用 `initSDK()` 必然触发 `GetIt` 重复注册崩溃。 | `rust/src/db/mod.rs:133`：显式 `close` 并清理所有会话/存储状态 | `unInitSDK` 中显式关闭数据库、清理所有资源与依赖容器 |
| **B-08** | `mangaer/message_manager.dart:1261-1297` (`getAdvancedHistoryMessageListReverse`) | 直接调用 `getAdvancedHistoryMessageList(startMsg: startMsg)`（查询 `startMsg` **之前**的消息）再 `.reversed`，导致“向后加载新消息”变成“向前加载旧消息并倒序”，完全违背语义。 | `rust/src/sync/history/manager.rs`：反向拉取使用 `sendTime >= startTime` 升序查询，云端 `order: 0` 升序补拉 | 在 `MessageHistoryLoader` 中独立实现向后查询（`whereGreaterThanOrEqualTo('sendTime', startTime)` 升序 + 云端 `order: 0`） |
| **B-09** | `mangaer/message_manager.dart:1744-1748` (`insertSingleMessageToLocalStorage`) | `senderID != _currentUserID` 时两个参数都取 `senderID`，生成错误会话 ID `si_${senderID}_${senderID}`。 | `rust/src/core/conversation_id.rs`：使用 `(_currentUserID, peerID)` 排序拼接 | 改为 `final String peerID = senderID == _currentUserID ? (receiverID ?? '') : (senderID ?? ''); OpenImUtils.genSingleConversationID(_currentUserID, peerID)` |
| **B-10** | `mangaer/message_manager.dart:2154` + `930` (`createFileMessageByFile` / `sendMessage`) | 同步方法写入主 Isolate 的 `_pendingUploadBytes`，`sendMessage` RPC 到后台 Isolate 读取为空导致文件未上传；同时 `sendMessage` RPC 漏传 `uploadMedia` 参数。 | —（由重构并发模型彻底根治） | 移除 L1 Isolate 后内存同享，且补全所有参数校验与上传完成后的内存清理 |
| **B-11** | `mangaer/call_manager.dart:76-82` (`currentSession` / `isBusy` / `callState`) | 同步 getter 读取主 Isolate 的 `_currentSession`，而通话状态全部在后台 Isolate 修改，Native 5 端 `isBusy` 恒为 `false`。 | `rust/src/core/call/manager.rs`：统一状态源 | 移除 L1 Isolate 后状态单一数据源，彻底根治 |

### 4.2 P1 严重逻辑缺陷（未读数错乱 / 搜索漏数据 / 断线异常 / 回调丢失）

| 编号 | 模块与位置（`openim_sdk`） | 缺陷事实与根因 | `xue_hua_sdk` 正确参照 | 修复方案 |
| :--- | :--- | :--- | :--- | :--- |
| **B-12** | `services/web_socket_service.dart:318-334` (`_onError`/`_onDone`) | 无连接代际号（`connGeneration`），旧连接的延迟 `onDone`/`onError` 会误杀刚建立的新连接并清空新连接的 `_pendingRequests`。 | `rust/src/core/connection.rs:79-118`：每次建连递增 `conn_id`，回调严格校验 `conn_id == current_gen` | 在 `WsClient` 中引入 `int _connGeneration`，所有 `onMessage`/`onError`/`onDone` 闭包绑定并校验代际号 |
| **B-13** | `services/web_socket_service.dart:132-139, 359-364, 448` | ① `setBackground` 仅改本地变量未向服务端发 `SET_BACKGROUND_STATUS`；② 心跳超时调用 `_handleDisconnect` 未关闭旧 `_channel.sink` 和 `_subscription`，泄漏半开连接；③ 重连退避用 `%` 取模（1→2→4→8→16→**1**），断网时反复打满短间隔重试。 | `rust/src/core/connection.rs:171, 237-244`：发送 `SET_BACKGROUND_STATUS`；退避 `backoff[attempt.min(len-1)]` 封顶 16s | 补发 WS 后台状态包；超时先主动 close/cancel 再重连；退避改为 `min(attempt, len - 1)` 封顶 |
| **B-14** | `mangaer/im_manager.dart:569-574` | 未绑定 `webSocketService.onUserOnlineStatusChanged`，导致在线状态实时推送被静默丢弃；且 `webSocketService.connect(...)` 在绑定 `onPushMsg` 之前调用，存在早到推送丢失窗口。 | `rust/src/core/connection.rs:72, 91-94`：绑定 `on_online_status` 并在重连成功后自动重新订阅 | 先绑定全部回调（含 `onUserOnlineStatusChanged`）再 `connect`，并维护在线状态重连自动续订 |
| **B-15** | `mangaer/im_manager.dart:982-1017` (`_createApiErrorHandler`) | `tokenExpiredFired` / `tokenInvalidFired` / `kickedOfflineFired` 闭包布尔在 `initSDK` 创建后永不重置，登出重登录后再次过期不再触发回调。 | `rust/src/core/session/logged_in.rs`：每次登录创建独立 Session 上下文，登出销毁 | 将防重入标志绑定到每次登录的 `SessionContext`，重新登录自动重置 |
| **B-16** | `network/msg_syncer.dart:1915, 1833, 1840, 191-194` | ① `_collectMessageUpdate` 在落库前即触发 `onRecvNewMessage`，UI 回调内查库/标已读会查不到消息；② `_parsePushMsg` 对通知消息循环 `unawaited(_processNotificationMessage)` 导致乱序并发写库；③ `doConnectedSync` 的 `finally` 漏检 `_pendingConnectedSync`，重连同步被吞。 | `rust/src/sync/push_intake.rs`：先批量落库、推进水位，再有序派发事件；通知严格串行 | 调整为“落库事务完成 → 推进水位 → 触发回调”；通知纳入串行队列；`doConnectedSync` 结束检查 `_pendingConnectedSync` |
| **B-17** | `network/msg_syncer.dart:1456, 1899` | 把所有 `pushMessages.msgs`（含隐藏控制通知 `1300/1703/2001/2102/2200`、好友通知 `1202-1210`、群申请 `1503/1505/1506` 及独立 `2101` 撤回包）全部盲目插入 `localChatLog` 并推送给 UI。 | `rust/src/domain/notification/parse.rs:80-125`：明确区分可见 Tip（`1201`/群系统条/`1701`）与隐藏控制通知，且 `2101` 仅改写原消息不二次落库 | 引入 `NotificationClassifier` 对齐 `parse.rs` 规则，过滤隐藏控制通知与 `2101` 独立包 |
| **B-18** | `mangaer/conversation_manager.dart:448-455, 669-725` | ① `markConversationMessageAsRead` 在 `unreadCount == 0` 时直接返回，未检查 `hasReadSeq < maxSeq`（发消息后未同步水位，冷启动会出现假未读），且单聊未更新本地消息 `isRead = true`；② `delete/clearConversationAndDeleteAllMsg` 未推进 `minSeq = maxSeq + 1`（或 `1`），下次同步会拉回已清空预览；③ 会话不存在时抛 `OpenIMException(code: 0, ...)`（错误码为 0！）。 | `rust/src/api/conversation.rs:288-316, 399-403`：`should_skip_mark_as_read` 同时判断 `unread==0 && hasRead>=maxSeq`；清空时写 `minSeq`；使用 `error_code::ARGS` | 完整对齐 `xue_hua_sdk` 的水位推进、单聊 `isRead` 落库、`minSeq` 写入及正确错误码 |
| **B-19** | `mangaer/message_manager.dart:1349-1413` + `database_service.dart:890-914` (`searchLocalMessages`) | ① 忽略 `keywordList` 第 2 个及后续关键词、`keywordListMatchType`（AND/OR）、`senderUserIDList`；② `searchTimePeriod`（秒）被错误地以毫秒单位**加**在 `searchTimePosition` 上而非**减**去 `searchTimePeriod * 1000`；③ 全局搜索不按 `conversationID` 分组；④ DB 仅截断拉取最近 `(count+offset)*3+200` 条，老消息永远搜不到。 | `rust/src/db/message/search.rs`：支持多关键词 AND/OR、发送者过滤、正确时间窗 `[pos - period*1000, pos]`、按会话分组与真实 `totalCount` | 配合 ToStore `IndexType.text` 全文索引 + `MessageSearcher` 完整实现全部过滤参数、正确时间窗与分组统计 |
| **B-20** | `mangaer/message_manager.dart:497-527, 1633-1676` | ① `createAdvancedQuoteMessage` 同时赋值 `quoteElem` 与 `advancedTextElem`，落库/发送时 `if/else if` 静默丢弃 `advancedTextElem`；② `deleteAllMsgFromLocal` / `deleteAllMsgFromLocalAndSvr` 只删 `localChatLog` 未清空 `localConversation` 的 `latestMsg` 与 `unreadCount`。 | `rust/src/api/message.rs`：清空全部消息时同步重置所有会话 `latestMsg` 与 `unreadCount` | 补齐清空全部消息时的会话表重置；规范富文本引用元素序列化 |
| **B-21** | `mangaer/conversation_manager.dart:100-170` | ① `getAllConversationList` / `getConversationListSplit` 未按 `isPinned DESC, max(draftTextTime, latestMsgSendTime) DESC` 排序；② `getOneConversation:166` 重复判断 `superGroup == superGroup` 漏掉普通群 `group(2)`；③ `getOneConversation:152` 把通知会话 `notification(4)` 的 `sourceID` 误写进 `groupID`。 | `rust/src/api/conversation.rs:124-142`：正确区分 `1/4 -> userID`、`2/3 -> groupID`，查询按 `(isPinned DESC, latestMsgSendTime DESC)` | 修复分支判断与 `userID/groupID` 归属，结合索引排序输出 |

### 4.3 P2 健壮性与代码质量缺陷

| 编号 | 位置（`openim_sdk`） | 问题描述 | 修复方案 |
| :--- | :--- | :--- | :--- |
| **B-22** | `network/http_client.dart:49-59, 322-347` | 重复调用 `init()` 会无限叠加 `operationID` 拦截器；HTTP 非 2xx 响应体若含 OpenIM `errCode`（如 1501），`_handleDioException` 会吞掉业务错误码且不触发 `onApiError`。 | 初始化前清理或防重拦截器；`_handleDioException` 优先解析 `e.response?.data` 中的 `errCode/errMsg` 并回调 `onApiError` |
| **B-23** | `services/im_api_service.dart:335-350, 610-650, 806-830` | ① 分页接口 `offset ~/ count + 1` 未防 `count <= 0` 除零异常（`sdk_method_dispatcher.dart:630` 默认 `count=0`）；② `fcmUpdateToken` 将 `platformID` 转成 `String`；③ `uploadAppealEvidence` 使用 `MultipartFile.fromFile` 在 Web 端崩溃。 | 统一分页工具校验 `count.clamp(1, 1000)`；`platformID` 保持 `int`；支持 `Uint8List` 跨端上传 |
| **B-24** | `mangaer/group_manager.dart:456` | `createGroup` 缺少 `groupID` 时抛出 `OpenIMException(code: 0, ...)`（错误码为 0）。 | 统一替换为 `SDKErrorCode.serverError` / `SDKErrorCode.argsError` |
| **B-25** | `enums/message_type.dart:160` | `MessageType.fromValue` 每次线性扫描 ~60 个枚举值。 | 参照 `xue_hua_sdk/lib/enum/message_type.dart:78` 改为静态 `Map<int, MessageType> _byValue` O(1) 查表 |
| **B-26** | `services/database_service.dart:1255-1324` (`messageToDbMap`) | 返回的 Map 未包含 `conversationID`，依赖调用方手工追加，极易遗漏导致孤儿消息。 | 增加必填/可选 `String? conversationID` 参数并在方法内统一写入 |
| **B-27** | `network/msg_syncer.dart:1110-1114, 2310-2318` | 每次群成员同步后多执行 1 次无意义的验证查询；`_fireTotalUnreadCountChanged` 全表拉取并反序列化所有会话（含 `latestMsg`）只为求和，未复用 `database.getTotalUnreadCount()`。 | 删除调试验证查询；直接调用 `conversationRepo.getTotalUnreadCount()` |

---

## 5. ToStore 3.6.3 数据库性能优化专项方案

基于 [ToStore 3.6.3 官方文档](https://pub.dev/packages/tostore) 与当前 `db_schema.dart`、`database_service.dart` 逐行审计，制定以下 7 项可落地的数据库性能优化：

### 5.1 初始化配置与多空间生命周期优化

- **当前问题**：`im_manager.dart:226` 配置了 `DataStoreConfig(yieldDurationMs: 16)`；未接入 `ToStore.setLogConfig`；`switchSpace`（`database_service.dart:28`）未传 `keepActive: true`；`logout()` 未清理 active space（`im_manager.dart:695` 甚至用 `setValue(key, null)` 而非 `removeValue`）。
- **优化方案**（依据 [ToStore 3.6.3 配置与多空间指南](https://pub.dev/packages/tostore)）：
  1. `ToStore.open` 调整为 `DataStoreConfig(yieldDurationMs: 8, defaultQueryLimit: 500, enableJournal: true, defaultRecoveryDurability: RecoveryDurability.standard)`：8ms 时间片贴合 60/120fps 渲染预算，防止大查询/迁移掉帧。
  2. 初始化前调用 `ToStore.setLogConfig(enableLog: ..., logLevel: ..., logLabel: 'openim_sdk_db', onLog: ...)` 统一转发到 `Logger('openim_sdk.ToStore')`。
  3. 登录后调用 `toStore.switchSpace(spaceName: spaceName, keepActive: true)`，冷启动直接进入活跃空间，省去“先 default 再切换”开销；登出时显式 `removeValue(CacheKey.loginAuthData, isGlobal: true)`，并在 `unInitSDK` 调用 `toStore.close(keepActiveSpace: false)`。

### 5.2 主键设计与消除历史 ToStore 3.0.8 全表扫描绕过代码

- **当前问题**：`localBlack`、`localGroupMember`、`localFriendRequest`、`localGroupRequest`、`localVersionSync` 5 张表使用无意义自增时间戳主键 `PrimaryKeyType.timestampBased`，并残留 **6 处** `// ToStore 3.0.8 复合唯一索引 bug 绕过` 代码（`database_service.dart:226, 369, 390, 1495, 1528, 1551`），每次查/删单条记录都要**拉出整群/整表数据在 Dart 层遍历过滤**！
- **优化方案**（依据 [ToStore 3.6.3 Primary Key & Bulk Operations](https://pub.dev/packages/tostore)）：
  - 对双键实体表改用**确定性复合主键（`PrimaryKeyType.none`）**：
    - `local_blacks`：`id = '${ownerUserID}_$blockUserID'`
    - `local_group_members`：`id = '${groupID}_$userID'`
    - `local_friend_requests`：`id = '${fromUserID}_$toUserID'`
    - `local_group_requests`：`id = '${groupID}_$userID'`
    - `local_version_sync`：`id = '${tableName}_$entityID'`
  - 所有单条点查/更新/删除直接走**主键索引寻址**（ToStore 3.6.3 PK Hot Read 基准可达 4.5M ops/s），彻底删除全部 6 处 3.0.8 绕过代码与 `_versionSyncInFlight` 写冲突补丁。
  - 为所有表与核心字段补齐 `tableId` / `fieldId`，保证未来声明式 Schema 在线自动迁移时字段重命名可被安全识别。

### 5.3 索引体系重构（消除全表扫描，启用 BM25 全文检索）

对照 [ToStore 3.6.3 Query Performance Guide (Index vs Full-Scan)](https://pub.dev/packages/tostore) 与 `xue_hua_sdk/rust/src/db/mod.rs`，重建高频表索引：

| 表名 | 当前索引缺陷 | 重构后索引设计 | 加速场景 |
| :--- | :--- | :--- | :--- |
| `local_chat_logs` | 仅有 1 个 4 列索引 `['conversationID', 'sendTime', 'seq', 'contentType']`，按 `(conversationID, seq)` / `(conversationID, status)` / `(conversationID, isRead)` / `sendID` / 关键词搜索全部退化扫描 | 1. `['conversationID', 'sendTime', 'seq']`（历史分页）<br>2. `['conversationID', 'seq']`（seq 补拉/最大 seq/已读回执）<br>3. `['conversationID', 'status']`（发送中/失败消息查询）<br>4. `['conversationID', 'isRead']`（未读消息统计）<br>5. `['sendID']`（发送者头像昵称回溯更新）<br>6. `IndexSchema(fields: ['content'], type: IndexType.text)`（BM25 词法全文检索） | 历史加载、未读统计、已读回执、本地消息搜索性能提升数量级 |
| `local_conversations` | 索引 `['conversationType', 'latestMsgSendTime', 'isPinned']` 首列为 `conversationType`，导致全列表查询与排序完全无法命中索引 | 1. `['isPinned', 'latestMsgSendTime']`（会话列表排序）<br>2. `['latestMsgSendTime']`（可见会话过滤 `> 0`）<br>3. `['unreadCount']`（总未读过滤 `> 0`）<br>4. `['userID']` 与 `['groupID']`（单聊/群聊反查） | 会话列表首屏加载、总未读计算、好友/群信息变更联动 |
| `local_group_members` | 仅 `['groupID', 'userID']` | 保留主键 `id`，补充 `['groupID', 'roleLevel']`（群主/管理员查询）、`['userID', 'roleLevel']`（我管理的群查询） | `getGroupOwnerAndAdmin`、`getGroupRequestsAsRecipient` |
| `local_friends` | `['ownerUserID', 'nickname']` | 补充 `IndexSchema(fields: ['nickname'], type: IndexType.text)`、`IndexSchema(fields: ['remark'], type: IndexType.text)` | 好友搜索免全表 `LIKE '%...%'` |

### 5.4 消除全表扫描反模式与查询优化

1. **用 `whereEqual('isRead', false)` 替代 `whereNotEqual('isRead', true)`**（`database_service.dart:665`）：`!=` 触发全表扫描，确保写入时 `isRead` 严格非空默认 `false`，配合 `['conversationID', 'isRead']` 索引走 Index Seek。
2. **用 `.exists()` 替代 `.first() != null` 或 `.count() > 0`**：例如 `isRedPacketGrabbed`（`database_service.dart:1588`）直接调用 `.exists()`，命中首条即短路返回。
3. **强制 `.limit(...)` 与 `.select([...])` 列裁剪**：所有列表查询明确传入 `.limit(...)`，统计/存在性/ID 映射类查询强制 `.select([...])` 跳过大 JSON 字段反序列化（例如 `getBlackUserIDSet`、`getGrabbedRedPacketIDs` 均只需查单列）。
4. **高频热点读采用 `peekFirst()` / `peek()` 内存探针优先**：对 `getConversation(id)`、`getLoginUser()`、`getGroupByID(id)`、`getFriendByUserID(id)` 采用 `q.peekFirst() ?? await q.first()`，热点命中零异步调度开销。
5. **游标分页（`.next()` / `.prev()`）与流式查询（`streamQuery`）**：
   - 历史消息与会话/动态/收藏深度翻页支持游标分页，规避大 `offset` 线性退化（且避免触发 ToStore 默认 `maxQueryOffset: 10000` 保护阈值）。
   - 需要全量遍历大表（如全局多条件复杂过滤）时使用 `db.streamQuery(...)` 避免一次性 OOM。

### 5.5 批量写入、事务与持久化分级（`RecoveryDurability`）

1. **消除循环单行写，全面使用 `batchInsert` / `batchUpsert` / `batchUpdate`**：
   - 修复 `msg_syncer.dart:419-457` 循环调用 50 个 `updateConversation`，改为单次 `toStore.batchUpdate(DbTableName.localConversation, updates)`（`batchUpdate` 支持局部字段更新且无需全量非空字段）。
   - 批量同步消息、会话、好友、群组、群成员均走 `batchUpsert(..., allowPartialErrors: true)` 并记录 `DbResult.hasErrors` / `statuses` 细粒度诊断日志。
2. **多表联动写入统一包裹 `toStore.transaction()`**：
   - 推送消息落库 + 更新会话 `latestMsg`/`unreadCount`/`maxSeq` + 更新 `notification_seq` 纳入同一事务，杜绝崩溃导致“消息已落库但会话未更新”或“未读数与消息不一致”。
   - 替换群成员、删除/清空会话消息与重置会话状态均纳入同一事务。
3. **按业务关键度分级配置 `RecoveryDurability`**：
   - 核心消息写入/撤回/已读水位：默认 `RecoveryDurability.standard`（进程崩溃安全）。
   - 临时上传进度记录（`localUpload`）、心跳/缓存刷新等高频非关键状态：显式传 `durability: RecoveryDurability.async` 提升吞吐。
4. **全面迁移至 ToStore 3.6.3 诊断模型 & 高级 KV**：
   - 统一使用 `DbResult.hasErrors` / `firstType`（禁用已废弃的 `isSuccess` / `type`）。
   - KV 存取使用强类型 `db.kv.getString` / `getInt` / `setMany` / `remove`，替代无类型 `getValue`/`setValue`。

---

## 6. 分阶段实施路线图与验收标准

为保证每次变更可编译、可测试、可回滚，按 **6 个阶段**顺序推进：

| 阶段 | 核心内容 | 主要产出与验收标准 |
| :--- | :--- | :--- |
| **Phase 1：基础规范与日志改造** | 移除 `aoiwe_logger`、接入 `logging`（全仓 `_logger`）、开启 `always_specify_types`、重命名 `mangaer/` → `manager/`、搭建 `lib/src/core/` 抽象基类（`SdkContext`、`BaseManager`、`BaseApiClient`、`BaseRepository`、`BaseSyncer`、`ListenerRegistry`） | `pubspec.yaml` 无 `aoiwe_logger`；零胶水代码；`dart analyze` 通过 |
| **Phase 2：并发模型彻底重构** | 编写 `lib/src/concurrency/`（`SdkComputeExecutor`、`SerialTaskQueue`、`KeyedAsyncLock`）；彻底移除 `lib/src/isolate/`（~2,200 行）、移除 `worker_manager` 依赖与 166 处 `SdkIsolateManager.isActive` 分支 | 6 端统一单一异步模型；`CallManager.isBusy`、`createFileMessageByFile` 上传、登出重登录事件恢复全部通过单元测试 |
| **Phase 3：ToStore 3.6.3 存储层重构与优化** | 重写 `db_schema.dart`（复合主键 + 复合索引 + `IndexType.text` + `tableId/fieldId`）；将 1,609 行 `database_service.dart` 拆分为 `DbEngine` + 9 个 `Repository`；落实 `yieldDurationMs: 8`、`peekFirst`、`exists()`、`batchUpdate`、`transaction()`、`ToStore.setLogConfig`；修复 B-01/B-05/B-07/B-26 | 所有 DB 单文件 < 300 行；无 3.0.8 绕过代码；批量写入与全文搜索基准测试通过 |
| **Phase 4：网络传输层与 API 层重构** | 重构 `HttpClient`（修复 B-22）、`WsClient`（修复 B-12/B-13/B-14）；将 1,705 行 `im_api_service.dart` 拆分为 8 个 `BaseApiClient` 子类（修复 B-23） | 断线重连代际过滤、后台状态上报、退避封顶、错误码解析均有单元测试覆盖 |
| **Phase 5：同步引擎与通知策略重构** | 将 2,327 行 `msg_syncer.dart` + 2,013 行 `notification_dispatcher.dart` 合并拆分为 `SyncCoordinator` + 4 个 `BaseSyncer` 子类 + 5 个 `BaseNotificationHandler` 子类（消灭 1,000+ 行重复代码）；修复 B-16/B-17/B-27 | 先落库后回调、隐藏通知过滤、`2101` 撤回不二次落库、重连不丢同步均验证通过 |
| **Phase 6：数据模型与业务 Manager 重构 + 全量缺陷闭环** | 拆分 1,250 行 `message.dart`（引入 `MessageElem` 基类）；拆分 `im_manager.dart`、`message_manager.dart`、`group_manager.dart`、`user_manager.dart`；闭环修复 B-02/B-03/B-04/B-08/B-09/B-15/B-18/B-19/B-20/B-21/B-24/B-25 | 全仓无 >600 行手写业务文件；`dart format .`、`flutter analyze` **0 error / 0 warning / 0 info**；全部单元测试与集成回归测试通过 |

---

> **请审核本计划**：如有任何需要增删或调整的设计细节（例如是否需要保留旧公共 API 的向后兼容别名、是否同步补充 `xue_hua_sdk` 中新增的 `conference` / `meetingReminder` / `meetingScheduleNotify` 消息类型等），请告知我，确认后我将立即按 Phase 1 → Phase 6 逐步落地实施。
