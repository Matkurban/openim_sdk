/// Web implementation — uses dart:js_interop / dart:js_interop_unsafe
/// to read/write window.__openimSdkWsDispose for DDC hot-restart cleanup.
/// Only compiled on web targets via conditional import.
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// 全局This。
///
/// Global this.
///
/// - Returns: `JSObject` 结果 / Resulting `JSObject`.
@JS()
external JSObject get globalThis;

/// 释放资源OldWebSocket从Js全局。
///
/// Call and remove any previously registered dispose callback on JS global.
void disposeOldWsFromJsGlobal() {
  try {
    final JSAny? fn = globalThis.getProperty<JSAny?>('__openimSdkWsDispose'.toJS);
    if (fn != null && fn.isA<JSFunction<Function>>()) {
      (fn as JSFunction<Function>).callAsFunction(globalThis);
    }
    globalThis.delete('__openimSdkWsDispose'.toJS);
  } catch (_) {}
}

/// 注册释放资源InJs全局。
///
/// Register [disposeCallback] on JS global so the next hot-restart can clean up.
void registerDisposeInJsGlobal(void Function() disposeCallback) {
  try {
    globalThis.setProperty('__openimSdkWsDispose'.toJS, disposeCallback.toJS);
  } catch (_) {}
}
