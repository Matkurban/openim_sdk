/// Stub implementation for non-web platforms.
/// All functions are no-ops — the caller always guards with kIsWeb at runtime,
/// but the conditional import ensures this file is compiled on non-web targets,
/// satisfying the type checker without pulling in dart:js_interop.
library;

void disposeOldWsFromJsGlobal() {}

void registerDisposeInJsGlobal(void Function() disposeCallback) {}
