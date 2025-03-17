//
//  NoteModel.swift
//  Notes
//
//  Created by Андрей on 27.01.2025.
//

import Foundation
import Combine

class NoteModel: ObservableObject, NoteModelLogic {
    
    var notes: [Note] = [] {
        didSet {
            notesSubject.send(notes)
        }
    }
    var notesPublisher: AnyPublisher<[Note], Never> {
        notesSubject.eraseToAnyPublisher()
    }
    private let notesSubject = PassthroughSubject<[Note], Never>()
    
    func createNote(note: Note) {
        notes.append(note)
    }
    
    func editNote(for index: Int, note: Note) {
        notes[index] = note
    }
}

