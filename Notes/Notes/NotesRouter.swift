//
//  Router.swift
//  Notes
//
//  Created by Андрей on 02.02.2025.
//

import UIKit

enum NotesRouter {
    static func createViewController() -> UIViewController {
        let viewModel = NoteViewModel()
        let viewController = NoteMainViewController(viewModel: viewModel)
    
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    static func openNote(navigation: UINavigationController?, viewModel: NotePresenting) {
        let viewController = NoteViewController(viewModel: viewModel)
        navigation?.pushViewController(viewController, animated: true)
    }
}
