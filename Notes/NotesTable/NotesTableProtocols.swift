//
//  Protocols.swift
//  Notes
//
//  Created by Андрей on 10.02.2025.
//

import UIKit
import Combine

protocol NotesTablePresentingMethods {
    func didTapOpenNote()
    func subscribeToNewNote(_ noteViewModel: NoteViewModel)
}

protocol NotesTablePresentingPublisher {
    var viewStatePublisher: AnyPublisher<[NotesTableViewState], Never> { get }
    var configPublisher: AnyPublisher<NoteConfig, Never> { get }
}

typealias NotesTablePresenting = NotesTablePresentingMethods & NotesTablePresentingPublisher

protocol NoteModelMethods {
    func createNote(note: Note)
}

protocol NoteModelPublisher {
    var notesPublisher: AnyPublisher<[Note], Never> { get }
}

typealias NoteModelLogic = NoteModelMethods & NoteModelPublisher

protocol NotesRouting {
    func openNote(navigation: UINavigationController, viewModel: NotesTablePresenting, config: NoteConfig)
}
