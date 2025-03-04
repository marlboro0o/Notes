//
//  Protocols.swift
//  Notes
//
//  Created by Андрей on 10.02.2025.
//

import UIKit
import Combine

protocol NotesTablePresentingMethods {
    func didTapOpenNote(for index: Int?)
    func subscribeToNewNote(_ noteViewModel: NoteViewModel)
}

protocol NotesTablePresentingPublisher {
    var viewStatePublisher: AnyPublisher<[NotesTableViewState], Never> { get }
    var configPublisher: AnyPublisher<NoteConfig, Never> { get }
}

typealias NotesTablePresenting = NotesTablePresentingMethods & NotesTablePresentingPublisher

protocol NoteModelMethods {
    func createNote(note: Note)
    func editNote(for index: Int, note: Note)
}

protocol NoteModelPublisher {
    var notesPublisher: AnyPublisher<[Note], Never> { get }
}

typealias NoteModelLogic = NoteModelMethods & NoteModelPublisher

protocol NotesRouting {
    func openNote(navigation: UINavigationController, viewModel: NotesTablePresenting, config: NoteConfig)
}
