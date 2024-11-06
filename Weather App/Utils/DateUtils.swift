//
//  DateUtils.swift
//  Weather App
//
//  Created by Yoji on 04.02.2024.
//

import Foundation

extension Date {
    var isMidday: Bool {
        self.stringWithTimezone == "12:00"
    }
    
    private var stringWithTimezone: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timezone = TimeInterval(integerLiteral: Int64(TimeZone.current.secondsFromGMT()))
        let dateWithTimezone = self.addingTimeInterval(timezone)
        return dateFormatter.string(from: dateWithTimezone)
    }
    
    func isEqualWithDate(_ date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        return dateFormatter.string(from: self) == dateFormatter.string(from: date)
    }
}

extension Array<Date> {
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter
    }
    
    func uniqueDates() -> [Date] {
        let dates = self
            .compactMap { dateFormatter.string(from: $0) }
            .unique()
            .compactMap { dateFormatter.date(from:$0) }
        
        return dates
    }
    
    func uniqueDatesWithoutCurrent() -> [Date] {
        let currentDate = Date()
        
        let dates = self
            .uniqueDates()
            .compactMap { dateFormatter.string(from: $0) }
            .filter { $0 != dateFormatter.string(from: currentDate) }
            .compactMap { dateFormatter.date(from:$0) }
        
        return dates
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
