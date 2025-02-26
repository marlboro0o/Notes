//
//  Router.swift
//  Notes
//
//  Created by Андрей on 02.02.2025.
//

import UIKit

enum NotesRouter {    
    static func openNote(navigation: UINavigationController, viewModel: NotePresenting) {
        let viewController = NoteViewController(viewModel: viewModel)
        navigation.pushViewController(viewController, animated: true)
    }
}
