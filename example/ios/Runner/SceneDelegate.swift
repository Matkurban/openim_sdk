import Flutter
import UIKit
import xue_hua_navite_accept_sharing

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    let urls = connectionOptions.urlContexts.map { $0.url }
    if !urls.isEmpty {
      XueHuaNaviteAcceptSharingPlugin.shared.handleOpenURLs(urls, isInitial: true)
    }
  }

  override func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    super.scene(scene, openURLContexts: URLContexts)
    let urls = URLContexts.map { $0.url }
    if !urls.isEmpty {
      XueHuaNaviteAcceptSharingPlugin.shared.handleOpenURLs(urls, isInitial: false)
    }
  }
}
