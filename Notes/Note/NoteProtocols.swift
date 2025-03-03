//
//  NoteProtocols.swift
//  Notes
//
//  Created by Андрей on 26.02.2025.
//

import Foundation
import Combine

protocol NotePresentingMethods {
    func createNote(for text: String)
}

protocol NotePresentingPublisher {
    var viewStatePublisher: AnyPublisher<[NoteViewState], Never> { get }
}

typealias NotePresenting = NotePresentingMethods & NotePresentingPublisher

