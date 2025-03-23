//
//  Protocols.swift
//  Notes
//
//  Created by Андрей on 10.02.2025.
//

import UIKit
import Combine

protocol NotesTablePresentingProperties: AnyObject {
    var viewState: NotesTableViewState { get }
}

protocol NotesTablePresentingMethods {
    func didTapAddNote()
    func didTapOpenNote(for indexPath: IndexPath)
    func addNote(config: NoteConfig)
    func editNote(config: NoteConfig)
    func deleteNote(for indexPath: IndexPath)
    func setProxy(_ proxy: NoteProxy)
}

protocol NotesTablePresentingPublisher {
    var viewStatePublisher: AnyPublisher<Bool, Never> { get }
    var configPublisher: AnyPublisher<NoteConfig?, Never> { get }
}

typealias NotesTablePresenting = NotesTablePresentingProperties & NotesTablePresentingMethods & NotesTablePresentingPublisher

protocol NotesModelProperties {
    var notes: [Note] { get }
}

protocol NoteModelMethods {
    func createNote(note: Note)
    func editNote(note: Note)
    func deleteNote(for index: Int)
}

protocol NoteModelPublisher {
    var notesPublisher: AnyPublisher<[Note], Never> { get }
}

typealias NoteModelLogic = NotesModelProperties & NoteModelMethods & NoteModelPublisher

protocol NotesRouting {
    func openNote(navigation: UINavigationController, viewModel: NotesTablePresenting, config: NoteConfig?)
}
