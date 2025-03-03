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
    let newNoteSubject = PassthroughSubject<NoteConfig, Never>()

    private let config: NoteConfig
    private let notesSubject: CurrentValueSubject<[NoteViewState], Never> = .init([])
    
    private var cancellables = Set<AnyCancellable>()
    
    init(config: NoteConfig) {
        self.config = config
    }
    
    func createNote(for text: String) {
        if let config = text.toConfig(date: config.date) {
            newNoteSubject.send(config)
        }
    }
    
}

private extension String {
    func toConfig(date: Date) -> NoteConfig? {
        let components = components(separatedBy: .newlines)
        guard let title = components.first else { return nil }
        
        return NoteConfig(
            title: title,
            textBody: components
                .dropFirst()
                .joined(separator: " "),
            date: date)
    }
}
