//
//  NoteProxy.swift
//  Notes
//
//  Created by Андрей on 04.03.2025.
//

import Foundation
import Combine

final class NoteProxy {
    
    var addNotePublisher: AnyPublisher<NoteConfig, Never> {
        addNoteSubject.eraseToAnyPublisher()
    }
    var editNotePublisher: AnyPublisher<NoteConfig, Never> {
        editNoteSubject.eraseToAnyPublisher()
    }

    private let addNoteSubject = PassthroughSubject<NoteConfig, Never>()
    private let editNoteSubject = PassthroughSubject<NoteConfig, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func addNote(config: NoteConfig) {
        addNoteSubject.send(config)
    }
    
    func editNote(config: NoteConfig) {
        editNoteSubject.send(config)
    }
}
