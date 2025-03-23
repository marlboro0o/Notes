//
//  NoteViewState.swift
//  Notes
//
//  Created by Андрей on 17.02.2025.
//

import Foundation

struct NotesTableViewState {
    var sections: [NotesTableViewSections]
    
    init() {
        self.sections = []
    }
    
    init(sections: [NotesTableViewSections]) {
        self.sections = sections
    }
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

