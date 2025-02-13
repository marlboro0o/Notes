//
//  Protocols.swift
//  Notes
//
//  Created by Андрей on 10.02.2025.
//

import Foundation
import Combine

protocol NotePresenting {
    var viewStatePublisher: AnyPublisher<[NoteViewState], Never> { get }
    func createNote(text: String)
}

protocol NoteBusinessLogic {
    func createNote(text: String)
}
