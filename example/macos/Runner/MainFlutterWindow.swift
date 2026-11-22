import Cocoa
import FlutterMacOS
import xue_hua_navite_window_manager

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    // Zero-flash startup: conceal window & sync Apple Parchment (#F5F5F7) backing color.
    XueHuaNaviteWindowManagerPlugin.prepareZeroFlashWindow(
      self,
      backgroundColor: NSColor(srgbRed: 0.961, green: 0.961, blue: 0.969, alpha: 1.0)
    )

    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
