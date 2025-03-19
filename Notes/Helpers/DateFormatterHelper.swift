//
//  DateFormatterHelper.swift
//  Notes
//
//  Created by Андрей on 12.02.2025.
//

import Foundation

enum DateFormatterHelper {
    
    static func formatDateHeaderCell(_ date: Date) -> String {
        return mapDateToString(date: date)
    }
    
    static func formatDateCell(_ date: Date) -> String {
        return formatDateToString(date: date, format: "dd.MM.yyyy")
    }
    
    //TODO: - append implementation logic
    static func formatDateNote(_ date: Date) -> String {
        return "\(formatDateToString(date: date, format: "dd.MMMM.yyyy")) в \(formatDateToString(date: date, format: "TTTT"))"
    }
}

//MARK: - Private methods
extension DateFormatterHelper {
    static private func mapDateToString(date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Сегодня"
        } else if calendar.isDateInYesterday(date) {
            return "Вчера"
        } else if let thirtyDaysAgo = calendar.date(byAdding: .day, value: -7, to: now),
                  date >= thirtyDaysAgo {
            return "Предыдущие 7 дней"
        } else if let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: now),
           date >= thirtyDaysAgo {
            return "Предыдущие 30 дней"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .year) {
            let month = calendar.component(.month, from: date)
            return "\(month)"
        }
        
        let year = calendar.component(.year, from: date)
        return "\(year)"
    }
    
    static private func formatDateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}
