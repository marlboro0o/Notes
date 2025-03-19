//
//  NoteViewModel.swift
//  Notes
//
//  Created by Андрей on 27.01.2025.
//

import Combine
import Foundation

final class NotesTableViewModel: ObservableObject, NotesTablePresenting {
    var viewState: NotesTableViewState = NotesTableViewState(sections: [])
    var viewStatePublisher: AnyPublisher<Bool, Never> {
        viewStateSubject.eraseToAnyPublisher()
    }
    var configPublisher: AnyPublisher<NoteConfig?, Never> {
        configSubject.eraseToAnyPublisher()
    }
    
    private let model: NoteModelLogic
    private let viewStateSubject: CurrentValueSubject<Bool, Never> = .init(false)
    private let configSubject = PassthroughSubject<NoteConfig?, Never>()
    private var cancellables = Set<AnyCancellable>()
    private weak var proxy: NoteProxy?
    
    
    init(model: NoteModel) {
        self.model = model
        self.bind()
    }
    
    func didTapOpenNote(for indexPath: IndexPath) {
        
        let index = findIndexNoteInViewState(for: indexPath)
        
        guard let note = model.notes[safe: index] else { return }
        configSubject.send(note.toConfig())
    }
    
    func didTapAddNote() {
        configSubject.send(nil)
    }
    
    func addNote(config: NoteConfig) {
        model.createNote(note: config.toNote())
    }
    
    func editNote(config: NoteConfig) {
        guard
            let index = model.notes.firstIndex(where: { $0.id == config.id })
        else {
            return
        }
        model.editNote(for: index, note: config.toNote())
    }
    
    func deleteNote(for indexPath: IndexPath) {
        let _index = findIndexNoteInViewState(for: indexPath)
        model.deleteNote(for: _index)
    }
    
    func setProxy(_ proxy: NoteProxy) {
        self.proxy = proxy
        bindToProxy()
    }
    
    private func bind() {
        model.notesPublisher
            .sink { [weak self] value in
                guard let self else { return }
                viewState = toViewState(value)
                viewStateSubject.send(true)
            }
            .store(in: &cancellables)
    }
    
    private func bindToProxy() {
        proxy?.addNotePublisher
            .sink { [weak self] value in
                guard let self else { return }
                addNote(config: value)
            }.store(in: &cancellables)
        
        proxy?.editNotePublisher
            .sink { [weak self] value in
                guard let self else { return }
                editNote(config: value)
            }.store(in: &cancellables)
    }
    
    private func toViewState(_ array: [Note]) -> NotesTableViewState {
        var sections: [NotesTableViewSections] = []
        
        let viewStateRows = array.map {
            $0.toViewState()
        }
        
        viewStateRows.forEach { body in
            if let index = sections.firstIndex(where: { body.dateHeaderCell == $0.header }) {
                sections[index].rows.append(body)
            } else {
                sections.append(NotesTableViewSections(header: body.dateHeaderCell, rows: [body]))
            }
        }
        
        return NotesTableViewState(sections: sections)
    }
    
    private func findIndexNoteInViewState(for indexPath: IndexPath) -> Int {
        var index = 0
        var section = 0
        
        while index < model.notes.count {
            if section == indexPath.section {
                index += indexPath.row
                break
            }
            
            index += viewState.sections[indexPath.section].rows.count
            section += 1
        }
        
        return index
    }
}

private extension Note {
    func toViewState() -> NotesTableViewRow {
        NotesTableViewRow(
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
            date: date,
            action: .edit)
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

