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
            notes.sort { $0.date > $1.date }
            notesCaretacer.save(values: notes)
            notesSubject.send(notes)
        }
    }
    var notesPublisher: AnyPublisher<[Note], Never> {
        notesSubject.eraseToAnyPublisher()
    }
    private let notesSubject: CurrentValueSubject<[Note], Never> = .init([])
    private let notesCaretacer = NotesTableCaretacer()
    
    init() {
        notes = notesCaretacer.load()
        notesSubject.send(notes)
    }
    
    func createNote(note: Note) {
        notes.append(note)
    }
    
    func editNote(for index: Int, note: Note) {
        notes[index] = note
    }
    
    func deleteNote(for index: Int) {
        notes.remove(at: index)
    }
}

