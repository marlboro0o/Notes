//
//  NoteProtocols.swift
//  Notes
//
//  Created by Андрей on 26.02.2025.
//

import Foundation
import Combine

protocol NotePresentingProperties {
    var viewState: NoteViewState { get }
}

protocol NotePresentingMethods {
    func viewDidLoad()
    func saveNote(for text: String)
    func setProxy(_ proxy: NoteProxy)
}

protocol NotePresentingPublisher {
    var viewStatePublisher: AnyPublisher<NoteViewState, Never> { get }
}

typealias NotePresenting = NotePresentingProperties & NotePresentingMethods & NotePresentingPublisher

