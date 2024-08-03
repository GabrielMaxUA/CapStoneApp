import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // This will be handled in the SceneDelegate for multi-scene apps
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = window?.rootViewController {
            if rootViewController.presentedViewController is CameraViewController || rootViewController.presentedViewController is UIHostingController<FullScreenImageView> {
                return .allButUpsideDown
            }
        }
        return .portrait
    }
}
