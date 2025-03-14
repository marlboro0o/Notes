//
//  NoteViewModel.swift
//  Notes
//
//  Created by Андрей on 25.02.2025.
//

import UIKit
import Combine

final class NoteViewModel: ObservableObject, NotePresenting {
    var viewState: NoteViewState?
    
    var viewStatePublisher: AnyPublisher<NoteViewState?, Never> {
        viewStateSubject.eraseToAnyPublisher()
    }
    private let action: NoteActions
    private let id: UUID
    private let date: Date
    private let viewStateSubject = PassthroughSubject<NoteViewState?, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var proxy: NoteProxy?
    
    init(config: NoteConfig?) {
        
        if let config {
            self.viewState = config.toViewState()
            self.action = config.action
            self.id = config.id
            self.date = config.date
        } else {
            self.action = .add
            self.id = UUID()
            self.date = .now
        }
    }
    
    func viewDidLoad() {
        viewStateSubject.send(viewState)
    }
    
    
    func saveNote(for text: String) {
        let components = text.components(separatedBy: .newlines)
        guard
            let title = components.first,
            let proxy
        else {
            return
        }
        
        let config = NoteConfig(
            id: id,
            title: title,
            textBody: components.dropFirst().joined(separator: "\n"),
            date: date,
            action: action)
        
        switch action {
        case .add:
            proxy.addNote(config: config)
        case .edit:
            proxy.editNote(config: config)
        }
    }
    
    func setProxy(_ proxy: NoteProxy) {
        self.proxy = proxy
    }
}

private extension NoteConfig {
    func toViewState() -> NoteViewState {
        NoteViewState(
            textBody: title.isEmpty ? "" : "\(title)\n\(textBody)",
            dateHeader: DateFormatterHelper.formatDateNote(date))
    }
}


