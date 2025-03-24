//
//  NotesTableCaretacer.swift
//  Notes
//
//  Created by Андрей on 11.03.2025.
//

import Foundation

struct NotesTableCaretacer {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save(values: [Note]) {
        guard
            let data = try? encoder.encode(values)
        else {
            print("Ошибка при сохранении списка заметок")
            return
        }
        UserDefaults.standard.set(data, forKey: Constants.key)
    }
    
    func load() -> [Note] {
        let result: [Note] = []
        
        guard
            let data = UserDefaults.standard.data(forKey: Constants.key),
            let result = try? decoder.decode([Note].self, from: data)
        else {
            print("Ошибка при загрузке списка заметок")
            return result
        }
        
        return result
    }
}

private enum Constants {
    static let key = "Notes"
}
