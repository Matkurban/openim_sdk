/// Web implementation — uses dart:js_interop / dart:js_interop_unsafe
/// to read/write window.__openimSdkWsDispose for DDC hot-restart cleanup.
/// Only compiled on web targets via conditional import.
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

@JS()
external JSObject get globalThis;

/// Call and remove any previously registered dispose callback on JS global.
void disposeOldWsFromJsGlobal() {
  try {
    final fn = globalThis.getProperty<JSAny?>('__openimSdkWsDispose'.toJS);
    if (fn != null && fn.isA<JSFunction>()) {
      (fn as JSFunction).callAsFunction(globalThis);
    }
    globalThis.delete('__openimSdkWsDispose'.toJS);
  } catch (_) {}
}

/// Register [disposeCallback] on JS global so the next hot-restart can clean up.
void registerDisposeInJsGlobal(void Function() disposeCallback) {
  try {
    globalThis.setProperty('__openimSdkWsDispose'.toJS, disposeCallback.toJS);
  } catch (_) {}
}
