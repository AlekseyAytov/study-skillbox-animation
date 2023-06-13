//
//  SceneDelegate.swift
//  M21_Homework
//
//  Created by Maxim NIkolaev on 15.02.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let window = window else { return }
        window.windowScene = windowScene
        window.makeKeyAndVisible()
        
        let startVC = GameViewController()
        
        window.rootViewController = startVC
    }
}

