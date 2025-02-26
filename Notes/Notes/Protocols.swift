//
//  Protocols.swift
//  Notes
//
//  Created by Андрей on 10.02.2025.
//

import UIKit
import Combine

protocol NoteMainPresentingMethods {
    func openNote(navigation: UINavigationController)
}

protocol NoteMainPresentingPublisher {
    var viewStatePublisher: AnyPublisher<[NoteMainViewState], Never> { get }
}

typealias NoteMainPresenting = NoteMainPresentingMethods & NoteMainPresentingPublisher

protocol NotePresentingMethods {
    func createNote(for text: String)
}

protocol NotePresentingPublisher {
    var viewStatePublisher: AnyPublisher<[NoteViewState], Never> { get }
}

typealias NotePresenting = NotePresentingMethods & NotePresentingPublisher

protocol NoteBusinessLogic {
    func createNote(for text: String)
}
