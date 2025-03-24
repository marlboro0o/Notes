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
        return formatDateToString(date: date, format: .ddMMyyyy)
    }
    
    //TODO: - append implementation logic
    static func formatDateNote(_ date: Date) -> String {
        return formatDateToString(date: date, format: .ddMMMMyyyyTTTT)
    }
}

//MARK: - Private methods
extension DateFormatterHelper {
    static private func mapDateToString(date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return Constants.today
        } else if calendar.isDateInYesterday(date) {
            return Constants.yesterday
        } else if dateIsIncludedInRange(date: date, calendar: calendar, now: now, value: -7){
            return Constants.sevenDaysAgo
        } else if dateIsIncludedInRange(date: date, calendar: calendar, now: now, value: -30) {
            return Constants.thirtyDaysAgo
        } else if calendar.isDate(date, equalTo: now, toGranularity: .year) {
            let month = calendar.component(.month, from: date)
            return "\(month)"
        }
        
        let year = calendar.component(.year, from: date)
        return "\(year)"
    }
    
    static private func formatDateToString(date: Date, format: formatDate) -> String {
        let dateFormatter = DateFormatter()
        
        switch format {
        case .ddMMyyyy:
            dateFormatter.dateFormat = "dd.MM.yyyy"
        case .ddMMMMyyyyTTTT:
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "d MMMM yyyy'г. в' HH:mm"
        }
        
        return dateFormatter.string(from: date)
    }
    
    static private func dateIsIncludedInRange(date: Date, calendar: Calendar, now: Date, value: Int) -> Bool {
        guard
            let resultDate = calendar.date(byAdding: .day, value: value, to: now),
             date >= resultDate
        else {
            return false
        }
        return true
    }
}

private enum formatDate {
    case ddMMyyyy
    case ddMMMMyyyyTTTT
}

private enum Constants {
    static let today = "Сегодня"
    static let yesterday = "Вчера"
    static let sevenDaysAgo = "Предыдущие 7 дней"
    static let thirtyDaysAgo = "Предыдущие 30 дней"
}
