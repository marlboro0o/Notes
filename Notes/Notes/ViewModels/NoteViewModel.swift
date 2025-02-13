//
//  NoteViewModel.swift
//  Notes
//
//  Created by Андрей on 27.01.2025.
//

import Combine
import Foundation

final class NoteViewModel: ObservableObject, NotePresenting {
    
    private let model = NoteModel()
    private var cancellables = Set<AnyCancellable>()
    private let notesSubject: CurrentValueSubject<[NoteViewState], Never> = .init([])
    
    var viewStatePublisher: AnyPublisher<[NoteViewState], Never> {
        notesSubject.eraseToAnyPublisher()
    }
    
    init() {
        self.bind()
    }
    
    func createNote(text: String) {
        model.createNote(text: text)
    }
    
    private func bind() {
        model.notesPublisher
            .map { notes in
                notes.map { element in NoteViewState(title: element.title, content: element.content, dateHeaderCell: DateFormatterHelper.formatDateHeaderCell(element.date), dateCell: DateFormatterHelper.formatDateCell(element.date), dateNote: DateFormatterHelper.formatDateNote(element.date))
                }
            }
            .sink { [weak self] value in
                self?.notesSubject.send(value)
            }
            .store(in: &cancellables)
    }
}
