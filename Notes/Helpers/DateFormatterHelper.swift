//
//  DateFormatterHelper.swift
//  Notes
//
//  Created by Андрей on 12.02.2025.
//

import Foundation

struct DateFormatterHelper {
    
    static func formatDateHeaderCell(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Сегодня"
        }
        
        if calendar.isDateInYesterday(date) {
            return "Вчера"
        }
        
        if let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: now),
           date >= thirtyDaysAgo {
            return "Предыдущие 30 дней"
        }
        
        if calendar.isDate(date, equalTo: now, toGranularity: .year) {
            let month = calendar.component(.month, from: date)
            return "\(month)"
        }
        
        let year = calendar.component(.year, from: date)
        return "\(year)"
    }
    
    static func formatDateCell(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    //TODO: - append implementation logic
    static func formatDateNote(_ date: Date) -> String {
        return ""
    }
}
