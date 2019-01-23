//
//  CalendarLunar.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 23..
//  Copyright © 2019년 sama73. All rights reserved.
// 음력 구하기

import Foundation

class Solar {
    var year: Int
    var month: Int
    var day: Int
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    convenience init() {
        self.init(year: 0, month: 0, day: 0)
    }
    
    func toLunar() throws -> Lunar {
        return try CalendarLunar.lunar(from: self)
    }
}

class Lunar {
    var year: Int
    var month: Int
    var day: Int
    var isLeap: Bool
    
    init(year: Int, month: Int, day: Int, isLeap: Bool) {
        self.year = year
        self.month = month
        self.day = day
        self.isLeap = isLeap
    }
    convenience init() {
        self.init(year: 0, month: 0, day: 0, isLeap: false)
    }
}

struct CalendarLunar {
    
    struct ConvertError: Error {
        let message: String
        
        init(message: String) {
            self.message = message
        }
    }
    
    static let formatter = DateFormatter()
    
    private static let LUNAR_INFO: [Int] = [
        0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2,
        0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977,
        0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970,
        0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950,
        0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557,
        0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5d0, 0x14573, 0x052d0, 0x0a9a8, 0x0e950, 0x06aa0,
        0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0,
        0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6,
        0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,
        0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0,
        0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,
        0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
        0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,
        0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,
        0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0
    ]
    private static let START_DATE: String = "19000130"
    // 최소 선택 년도
    private static let MIN_YEAR: Int = 1900
    // 최대 선택 년도
    private static let MAX_YEAR: Int = 2049

    private static func daysBetween(_ startDate: Date, _ endDate: Date) throws -> Int {
        let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        guard let days = components.day else {
            throw ConvertError(message: "두 날짜 간격 일 오류 계산")
        }
        
        return days
    }
    
    private static func getYearDays(year: Int) -> Int {
        var sum: Int = 29 * 12
        var i = 0x8000
        while i >= 0x8 {
            if (LUNAR_INFO[year - 1900] & 0xfff0 & i) != 0 {
                sum += 1
            }
            i >>= 1
        }
        return sum + getLeapMonthDays(year: year)
    }
    
    private  static func getLeapMonth(year: Int) -> Int {
        return LUNAR_INFO[year - 1900] & 0xf
    }
    
    private static func getLeapMonthDays(year: Int) -> Int {
        if getLeapMonth(year: year) != 0 {
            if (LUNAR_INFO[year - 1900] & 0xf0000) == 0 {
                return 29
            } else {
                return 30
            }
        } else {
            return 0
        }
    }
    
    private static func getMonthDays(lunarYear: Int, month: Int) throws -> Int {
        if lunarYear > 2049 {
            throw ConvertError(message: "틀린 년도")
        }
        
        if month > 12 || month < 1 {
            throw ConvertError(message: "달이 잘못되었습니다!")
        }
        
        let bit = 1 << (16 - month)
        if ((LUNAR_INFO[lunarYear - 1900] & 0x0FFFF) & bit) == 0 {
            return 29
        }
        return 30
    }
    
    private static func checkLunarDate(_ lunarYear: Int, _ lunarMonth: Int, _ lunarDay: Int, leapMonthFlag: Bool) throws {
        if lunarYear < MIN_YEAR || lunarYear > MAX_YEAR {
            throw ConvertError(message: "잘못된 음력 년!")
        }
        
        if lunarMonth < 1 || lunarMonth > 12 {
            throw ConvertError(message: "잘못된 음력 달!")
        }
        
        if lunarDay < 1 || lunarDay > 30 {
            throw ConvertError(message: "잘못된 음력 일!")
        }
        
        let leap = getLeapMonth(year: lunarYear)
        if leapMonthFlag == true && lunarMonth != leap {
            throw ConvertError(message: "잘못된 달!")
        }
    }
    
    static func lunar(from solar: Solar) throws -> Lunar {
        var i: Int = 0
        var temp: Int = 0
        var lunarYear: Int
        // 음력 달
        var lunarMonth: Int
        // 음력의 처음 며칠
        var lunarDay: Int
        var leapMonthFlag: Bool = false
        var isLeapYear: Bool = false
        
        formatter.dateFormat = "yyyyMMdd"
        // 한국
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(identifier: "KST")
        // 원본
//        formatter.locale = Locale(identifier: "zh_Hans_SG")
//        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        
        let solarDateString = String(format: "%04d%02d%02d", solar.year, solar.month, solar.day)
        guard let myDate = formatter.date(from: solarDateString), let startDate = formatter.date(from: START_DATE) else {
            throw ConvertError(message: "그레고리력의 날짜가 잘못되었습니다.")
        }
        
        var offset = try daysBetween(startDate, myDate)
        
        i = MIN_YEAR
        
        while i <= MAX_YEAR {
            temp = getYearDays(year: i)
            if offset - temp < 1 {
                break
            } else {
                offset -= temp
            }
            i += 1
        }
        
        lunarYear = i
        
        let leapMonth = getLeapMonth(year: lunarYear)
        
        if leapMonth > 0 {
            isLeapYear = true
        } else {
            isLeapYear = false
        }
        
        i = 1
        while i <= 12 {
            if i == leapMonth + 1 && isLeapYear {
                temp = getLeapMonthDays(year: lunarYear)
                isLeapYear = false
                leapMonthFlag = true
                i -= 1
            } else {
                temp = try getMonthDays(lunarYear: lunarYear, month: i)
            }
            offset -= temp
            if offset <= 0 {
                break
            }
            i += 1
        }
        
        offset += temp
        lunarMonth = i
        lunarDay = offset
        
        let isLeap = (leapMonthFlag && (lunarMonth == leapMonth))
        let lunar = Lunar(year: lunarYear, month: lunarMonth, day: lunarDay, isLeap: isLeap)
        return lunar
    }
}
