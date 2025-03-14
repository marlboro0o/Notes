//
//  NoteViewState.swift
//  Notes
//
//  Created by Андрей on 17.02.2025.
//

import Foundation

struct NotesTableViewSections {
    let header: String
    var viewState: [NotesTableViewState]
}

struct NotesTableViewState {
    let title: String
    let textBody: String
    let dateHeaderCell: String
    let dateCell: String
}

