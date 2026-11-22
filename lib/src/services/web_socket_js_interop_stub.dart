/// Stub implementation for non-web platforms.
/// All functions are no-ops — the caller always guards with kIsWeb at runtime,
/// but the conditional import ensures this file is compiled on non-web targets,
/// satisfying the type checker without pulling in dart:js_interop.
library;

/// 释放资源OldWebSocket从Js全局。
///
/// Dispose old WebSocket from js global.
void disposeOldWsFromJsGlobal() {}

/// 注册释放资源InJs全局。
///
/// Register dispose in js global.
///
/// - [disposeCallback] 释放资源回调 / Dispose callback.
void registerDisposeInJsGlobal(void Function() disposeCallback) {}
