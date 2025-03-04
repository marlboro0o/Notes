//
//  NoteViewModel.swift
//  Notes
//
//  Created by Андрей on 27.01.2025.
//

import Combine
import Foundation

final class NotesTableViewModel: ObservableObject, NotesTablePresenting {
    
    var viewStatePublisher: AnyPublisher<[NotesTableViewState], Never> {
        notesSubject.eraseToAnyPublisher()
    }
    var configPublisher: AnyPublisher<NoteConfig, Never> {
        configSubject.eraseToAnyPublisher()
    }
    
    private let model: NoteModelLogic
    private let notesSubject: CurrentValueSubject<[NotesTableViewState], Never> = .init([])
    private let configSubject = PassthroughSubject<NoteConfig, Never>()
    private var notes: [Note] = []
    private var cancellables = Set<AnyCancellable>()
    
    
    init(model: NoteModel) {
        self.model = model
        self.bind()
    }
    
    func didTapOpenNote(for index: Int? = nil) {
        
        if let index,
           let note = notes[safe: index] {
            configSubject.send(note.toConfig())
        } else {
            configSubject.send(
                NoteConfig(
                    id: UUID(),
                    title: "",
                    textBody: "",
                    date: .now))
        }
    }
    
    func subscribeToNewNote(_ noteViewModel: NoteViewModel) {
        noteViewModel.newNoteSubject
            .sink { [weak self] config in
                guard let self else { return }
                
                if let index = notes.firstIndex(where: { $0.id == config.id }) {
                    model.editNote(for: index, note: notes[index])
                } else {
                    model.createNote(note: config.toNote())
                }
            }
        .store(in: &cancellables)
    }
    
    private func bind() {
        model.notesPublisher
            .sink { [weak self] value in
                guard let self else { return }
                notes = value
                notesSubject.send(toViewState(value))
            }
            .store(in: &cancellables)
    }
    
    private func toViewState(_ array: [Note]) -> [NotesTableViewState] {
        array.map { $0.toViewState() }
    }
}

private extension Note {
    func toViewState() -> NotesTableViewState {
        NotesTableViewState(
            title: title,
            textBody: content.components(separatedBy: .newlines).joined(separator: " "),
            dateHeaderCell: DateFormatterHelper.formatDateHeaderCell(date),
            dateCell: DateFormatterHelper.formatDateCell(date))
    }
    
    func toConfig() -> NoteConfig {
        NoteConfig(
            id: id,
            title: title,
            textBody: content,
            date: date)
    }
}

private extension NoteConfig {
    func toNote() -> Note {
        Note(
            date: date,
            title: title,
            content: textBody)
    }
}

