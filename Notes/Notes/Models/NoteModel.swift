//
//  NoteModel.swift
//  Notes
//
//  Created by Андрей on 27.01.2025.
//

import Foundation
import Combine

class NoteModel: ObservableObject, NoteBusinessLogic {
    
    private let notesSubject = PassthroughSubject<[Note], Never>()
    private var notes: [Note] = [] {
        didSet {
            notesSubject.send(notes)
        }
    }
    var notesPublisher: AnyPublisher<[Note], Never> {
        notesSubject.eraseToAnyPublisher()
    }
    
    func createNote(for text: String) {
        let components = text.components(separatedBy: .newlines)
        
        guard let title = components.first else { return }
        
        let note = Note(date: .now, title: title, content: components.dropFirst().joined(separator: " "))
        notes.append(note)
    }
}

