//
//  Note.swift
//  Notes
//
//  Created by Андрей on 17.02.2025.
//

import Foundation

struct Note: Codable {
    var id: UUID
    let date: Date
    let title: String
    let content: String
    
    init(date: Date, title: String, content: String) {
        self.id = UUID()
        self.date = date
        self.title = title
        self.content = content
    }
}


