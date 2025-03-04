//
//  NoteProtocols.swift
//  Notes
//
//  Created by Андрей on 26.02.2025.
//

import Foundation
import Combine

protocol NotePresentingMethods {
    func viewDidLoad()
    func createNote(for text: String)
}

protocol NotePresentingPublisher {
    var newNoteSubject: PassthroughSubject<NoteConfig, Never> { get }
    var viewStatePublisher: AnyPublisher<NoteViewState, Never> { get }
}

typealias NotePresenting = NotePresentingMethods & NotePresentingPublisher

