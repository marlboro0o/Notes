//
//  NoteViewModel.swift
//  Notes
//
//  Created by Андрей on 27.01.2025.
//

import Combine
import UIKit

final class NoteMainViewModel: ObservableObject, NoteMainPresenting {
    
    var viewStatePublisher: AnyPublisher<[NoteMainViewState], Never> {
        notesSubject.eraseToAnyPublisher()
    }
    private let model: NoteModel
    private let notesSubject: CurrentValueSubject<[NoteMainViewState], Never> = .init([])
    private var cancellables = Set<AnyCancellable>()
    
    
    init(model: NoteModel) {
        self.model = model
        self.bind()
    }
    
    func openNote(navigation: UINavigationController) {
        NotesRouter.openNote(navigation: navigation, viewModel: NoteViewModel(model: model))
    }
    
    private func bind() {
        model.notesPublisher
            .sink { [weak self] value in
                guard let self else { return }
                notesSubject.send(toViewState(value))
            }
            .store(in: &cancellables)
    }
    
    private func toViewState(_ array: [Note]) -> [NoteMainViewState] {
        array.map { $0.toViewState() }
    }
}

private extension Note {
    func toViewState() -> NoteMainViewState {
        NoteMainViewState(
            title: title,
            textBody: content,
            dateHeaderCell: DateFormatterHelper.formatDateHeaderCell(date),
            dateCell: DateFormatterHelper.formatDateCell(date))
    }
    
    
}
