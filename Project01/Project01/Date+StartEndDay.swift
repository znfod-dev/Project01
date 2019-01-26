//
//  Date+StartEndDay.swift
//  Project01ForZn
//
//  Created by 박종현 on 15/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import Foundation
extension Date {
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))!
        return startOfMonth
    }
    func startOfYear() -> Date {
        let calendar = Calendar.current
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: calendar.startOfDay(for: self)))!
        return startOfYear
    }
    
    func endOfMonth() -> Date {
        let calendar = Calendar.current
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
        return endOfMonth
    }
    func endOfYear() -> Date {
        let calendar = Calendar.current
        let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: self.startOfYear())!
        return endOfYear
    }
}
