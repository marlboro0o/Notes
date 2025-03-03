//
//  Router.swift
//  Notes
//
//  Created by Андрей on 02.02.2025.
//

import UIKit

class NotesRouter: NotesRouting {
    func openNote(navigation: UINavigationController, viewModel: NotesTablePresenting, config: NoteConfig) {
        
        navigation.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Заметки", style: .plain, target: nil, action: nil)
        
        let noteViewModel = NoteViewModel(config: config)
        viewModel.subscribeToNewNote(noteViewModel)
       
        let viewController = NoteViewController(viewModel: noteViewModel)
        navigation.pushViewController(viewController, animated: true)
    }
}
