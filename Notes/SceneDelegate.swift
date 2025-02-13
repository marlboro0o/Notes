//
//  SceneDelegate.swift
//  Notes
//
//  Created by Андрей on 27.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = NotesRouter.createViewController()
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
