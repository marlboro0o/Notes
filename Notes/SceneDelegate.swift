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
        window.rootViewController = createViewController()
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    private func createViewController() -> UIViewController {
        let model = NoteModel()
        let viewModel = NoteMainViewModel(model: model)
        let viewController = NoteMainViewController(viewModel: viewModel)
    
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
