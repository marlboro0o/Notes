//
//  NotesTableConfig.swift
//  Notes
//
//  Created by Андрей on 26.02.2025.
//

import Foundation

struct NoteConfig {
    let id: UUID
    var title: String
    var textBody: String
    let date: Date
    let action: NoteActions
    
    static func addNote() -> NoteConfig {
        NoteConfig(
            id: UUID(),
            title: "",
            textBody: "",
            date: .now,
            action: .add)
    }
}

enum NoteActions {
    case add
    case edit
}
