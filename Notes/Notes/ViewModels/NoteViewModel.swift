//
//  NoteViewModel.swift
//  Notes
//
//  Created by Андрей on 25.02.2025.
//

import UIKit
import Combine

final class NoteViewModel: ObservableObject, NotePresenting {
    
    var viewStatePublisher: AnyPublisher<[NoteViewState], Never> {
        notesSubject.eraseToAnyPublisher()
    }
    private let model: NoteModel
    private let notesSubject: CurrentValueSubject<[NoteViewState], Never> = .init([])
    private var cancellables = Set<AnyCancellable>()
    
    
    init(model: NoteModel) {
        self.model = model
        self.bind()
    }
    
    func createNote(for text: String) {
        model.createNote(for: text)
    }
    
    private func bind() {
//        model.notesPublisher
//            .sink { [weak self] value in
//                guard let self else { return }
//                notesSubject.send(toViewState(value))
//            }
//            .store(in: &cancellables)
    }
}
