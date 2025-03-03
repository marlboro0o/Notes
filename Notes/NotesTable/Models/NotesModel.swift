//
//  NoteModel.swift
//  Notes
//
//  Created by Андрей on 27.01.2025.
//

import Foundation
import Combine

class NoteModel: ObservableObject, NoteModelLogic {
    
    private let notesSubject = PassthroughSubject<[Note], Never>()
    private var notes: [Note] = [] {
        didSet {
            notesSubject.send(notes)
        }
    }
    var notesPublisher: AnyPublisher<[Note], Never> {
        notesSubject.eraseToAnyPublisher()
    }
    
    func createNote(note: Note) {
        notes.append(note)
    }
}

