//
//  DateExtension.swift
//  Project01
//
//  Created by Byunsangjin on 21/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//
import UIKit

extension Date {
    // 예) 2019121
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMdd"
        let day = formatter.string(from: self)
        return day
    }
    
    // 예) 2019-01-21 14:11
    func stringAll() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let day = formatter.string(from: self)
        return day
    }
    
    // 전달의 마지막 날
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    // 이번달의 마지막 날
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    // 이번주의 시작 날 (일요일)
    func startOfWeek() -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    // 이번주의 마지막 날 (토요일)
    func endOfWeek() -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 6, to: sunday)!
    }
    
    // 전년도 마지막 날 (12-31)
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .year], from: Calendar.current.startOfDay(for: self)))!
    }
    
    // 이번년도 마지막 날 (12-31)
    func endOfYear() -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: self.startOfYear())!
    }
}
