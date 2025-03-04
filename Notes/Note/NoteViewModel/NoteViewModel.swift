//
//  NoteViewModel.swift
//  Notes
//
//  Created by Андрей on 25.02.2025.
//

import UIKit
import Combine

final class NoteViewModel: ObservableObject, NotePresenting {
    
    var newNoteSubject = PassthroughSubject<NoteConfig, Never>()
    var viewStatePublisher: AnyPublisher<NoteViewState, Never> {
        viewStateSubject.eraseToAnyPublisher()
    }
    private var config: NoteConfig
    private let viewStateSubject = PassthroughSubject<NoteViewState, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(config: NoteConfig) {
        self.config = config
    }
    
    func viewDidLoad() {
        viewStateSubject.send(config.toViewState())
    }
    
    
    func createNote(for text: String) {
        
        let components = text.components(separatedBy: .newlines)
        guard let title = components.first else { return }
        
        config.title = title
        config.textBody = components.dropFirst().joined(separator: "\n")
        newNoteSubject.send(config)
    }
    
}

private extension NoteConfig {
    func toViewState() -> NoteViewState {
        NoteViewState(
            textBody: title == "" ? "" : "\(title)\n\(textBody)",
            dateHeader: DateFormatterHelper.formatDateNote(date))
    }
}
