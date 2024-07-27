import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        // Create the SwiftUI view that provides the window contents.
        let cart = Cart() // Create the Cart instance
        let contentView = FrameContentView().environmentObject(cart)
        
        // Use a UIHostingController as window root view controller.
        window.rootViewController = UIHostingController(rootView: contentView)
        window.makeKeyAndVisible()
        
        return true
    }
}
