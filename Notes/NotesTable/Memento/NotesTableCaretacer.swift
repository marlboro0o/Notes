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
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    func save(values: [Note]) {
        do {
            let data = try encoder.encode(values)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func load() -> [Note] {
        var result: [Note] = []
        
        guard
            let data = UserDefaults.standard.data(forKey: key)
        else {
            return result
        }
        
        do {
            result = try decoder.decode([Note].self, from: data)
        } catch {
            print(error)
        }
        
        return result
    }
}
