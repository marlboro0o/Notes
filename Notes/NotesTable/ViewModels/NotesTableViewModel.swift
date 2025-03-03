//
//  NoteViewModel.swift
//  Notes
//
//  Created by Андрей on 27.01.2025.
//

import Combine

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
    private var cancellables = Set<AnyCancellable>()
    
    
    init(model: NoteModel) {
        self.model = model
        self.bind()
    }
    
    func didTapOpenNote() {
        configSubject.send(
            NoteConfig(
                title: "",
                textBody: "",
                date: .now))
    }
    
    func subscribeToNewNote(_ noteViewModel: NoteViewModel) {
        noteViewModel.newNoteSubject
            .sink { [weak self] config in
                guard let self else { return }
                model.createNote(note: config.toNote())
            }
        .store(in: &cancellables)
    }
    
    private func bind() {
        model.notesPublisher
            .sink { [weak self] value in
                guard let self else { return }
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
            textBody: content,
            dateHeaderCell: DateFormatterHelper.formatDateHeaderCell(date),
            dateCell: DateFormatterHelper.formatDateCell(date))
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
