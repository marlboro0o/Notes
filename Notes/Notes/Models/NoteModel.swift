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
    
    func createNote(text: String) {
        let components = text.components(separatedBy: .newlines)
        let note = Note(date: .now, title: components.first ?? "", content: components.dropFirst().joined(separator: " "))
        notes.append(note)
    }
}

struct Note {
    let date: Date
    let title: String
    let content: String
    
    init(date: Date, title: String, content: String) {
        self.date = date
        self.title = title
        self.content = content
    }
}

struct NoteViewState {
    let title: String
    let content: String
    let dateHeaderCell: String
    let dateCell: String
    let dateNote: String
}
