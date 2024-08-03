import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let cart = Cart() // Create the Cart instance
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = FrameContentView().environmentObject(cart)
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func windowScene(_ windowScene: UIWindowScene, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = window?.rootViewController {
            if rootViewController.presentedViewController is CameraViewController || rootViewController.presentedViewController is UIHostingController<FullScreenImageView> {
                return .allButUpsideDown
            }
        }
        return .portrait
    }
}
