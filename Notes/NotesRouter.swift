//
//  Router.swift
//  Notes
//
//  Created by Андрей on 02.02.2025.
//

import UIKit

class NotesRouter: NotesRouting {
    func openNote(navigation: UINavigationController, viewModel: NotesTablePresenting, config: NoteConfig) {
        
        let proxy = NoteProxy()
        let noteViewModel = NoteViewModel(config: config)
        noteViewModel.setProxy(proxy)
        viewModel.setProxy(proxy)
       
        let viewController = NoteViewController(viewModel: noteViewModel)
        navigation.pushViewController(viewController, animated: true)
    }
}
