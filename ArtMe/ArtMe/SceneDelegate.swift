//
//  SceneDelegate.swift
//  ArtMe
//
//  Created by Max Gabriel on 2024-06-21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = ViewController() // Set your ViewController as root
        self.window = window
        window.makeKeyAndVisible()
    }
}
