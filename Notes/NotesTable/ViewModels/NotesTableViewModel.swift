//
//  NoteViewModel.swift
//  Notes
//
//  Created by Андрей on 27.01.2025.
//

import Combine
import Foundation

final class NotesTableViewModel: ObservableObject, NotesTablePresenting {
    var viewState: [NotesTableViewSections] = []
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
    
    func didTapOpenNote(for index: Int, section: Int) {
        
        let _index = findIndexNoteInViewState(for: index, section: section)
        
        guard let note = model.notes[safe: _index] else { return }
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
    
    func deleteNote(for index: Int, section: Int) {
        let _index = findIndexNoteInViewState(for: index, section: section)
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
    
    private func toViewState(_ array: [Note]) -> [NotesTableViewSections] {
        var result: [NotesTableViewSections] = []
        
        let viewState = array.map {
            $0.toViewState()
        }
        
        viewState.forEach { body in
            if let index = result.firstIndex(where: { body.dateHeaderCell == $0.header }) {
                result[index].viewState.append(body)
            } else {
                result.append(NotesTableViewSections(header: body.dateHeaderCell, viewState: [body]))
            }
        }
        
        return result
    }
    
    private func findIndexNoteInViewState(for index: Int, section: Int) -> Int {
        var _index = 0
        var _section = 0
        
        while _index < model.notes.count {
            if section == _section {
                _index += index
                break
            }
            
            _index += viewState[_section].viewState.count
            _section += 1
        }
        
        return _index
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

