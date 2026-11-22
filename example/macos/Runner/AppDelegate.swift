import Cocoa
import FlutterMacOS
import xue_hua_navite_accept_sharing

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    // Keep app alive when hidden to system tray (required by xue_hua_navite_window_manager & system_tray).
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func application(_ application: NSApplication, open urls: [URL]) {
    // Forward Dock drop / Open With / Share Extension URLs to xue_hua_navite_accept_sharing.
    XueHuaNaviteAcceptSharingPlugin.shared.handleOpen(urls)
  }
}
