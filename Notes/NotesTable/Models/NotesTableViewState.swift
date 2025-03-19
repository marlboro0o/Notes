//
//  NoteViewState.swift
//  Notes
//
//  Created by Андрей on 17.02.2025.
//

import Foundation

struct NotesTableViewState {
    var sections: [NotesTableViewSections]
}

struct NotesTableViewSections {
    let header: String
    var rows: [NotesTableViewRow]
}

struct NotesTableViewRow {
    let title: String
    let textBody: String
    let dateHeaderCell: String
    let dateCell: String
}

