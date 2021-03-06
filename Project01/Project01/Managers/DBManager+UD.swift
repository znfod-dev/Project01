//
//  DBManager+UD.swift
//  Project01
//
//  Created by 박종현 on 20/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//
import Foundation
import UIKit

extension DBManager {
    
    func saveFontInUD(font:UIFont) {
        print("saveFontInUD")
        let fontName = font.fontName
        let fontSize = font.pointSize
        UserDefaults.standard.setValue(fontName, forKey: kFont_FontName)
        UserDefaults.standard.setValue(fontSize, forKey: kFloat_fontSize)
        UserDefaults.standard.synchronize()
        
    }
    func loadFontFromUD() -> UIFont{
        print("loadFontFromUD")
        var fontName = String()
        if let temp = UserDefaults.standard.value(forKey: kFont_FontName) {
            fontName = temp as! String
        }else {
            fontName = "NanumBarunpen"
            UserDefaults.standard.setValue(fontName, forKey: kFont_FontName)
        }
        var fontSize:CGFloat = 16
        if let temp = UserDefaults.standard.value(forKey: kFloat_fontSize) {
            fontSize = temp as! CGFloat
        }else {
            UserDefaults.standard.setValue(fontSize, forKey: kFloat_fontSize)
        }
        let font:UIFont = UIFont.init(name: fontName, size: fontSize)!
        return font
    }
    
    // MARK: - 최소시간
    func saveMinimumDateInUD(minimumDate:Date) {
        print("minimumDate : \(minimumDate.timeIntervalSince1970)")
        UserDefaults.standard.set(minimumDate.timeIntervalSince1970, forKey: kDate_MinimumDate)
        UserDefaults.standard.synchronize()
    }
    func loadMinimumDateFromUD() -> Date {
        let minDateInterval = UserDefaults.standard.double(forKey: kDate_MinimumDate)
        let minDate = Date.init(timeIntervalSince1970: minDateInterval)
        return minDate
    }
    // MARK: - 최대 시간
    func saveMaximumDateInUD(maximumDate:Date) {
        UserDefaults.standard.set(maximumDate.timeIntervalSince1970, forKey: kDate_MaximumDate)
        UserDefaults.standard.synchronize()
    }
    func loadMaximumDateFromUD() -> Date {
        let maxDateInterval = UserDefaults.standard.double(forKey: kDate_MaximumDate)
        let maxDate = Date.init(timeIntervalSince1970: maxDateInterval)
        return maxDate
    }
    
    // MARK: - 알람시간
    func saveAlarmTimeInUD(time:Date) {
        UserDefaults.standard.set(time.timeIntervalSince1970, forKey: kDate_AlarmTime)
        UserDefaults.standard.synchronize()
    }
    func loadAlarmTimeFromUD() -> Date {
        let alarmInterval = UserDefaults.standard.double(forKey: kDate_AlarmTime)
        let alarmTime = Date.init(timeIntervalSince1970: alarmInterval)
        return alarmTime
    }
    // MARK: - 음력
    func saveLunarCalendarInUD(value:Bool) {
        UserDefaults.standard.set(value, forKey: kBool_isLunarCalendar)
        UserDefaults.standard.synchronize()
    }
    func loadLunarCalendarFromUD() -> Bool {
        let value = UserDefaults.standard.bool(forKey: kBool_isLunarCalendar)
        return value
    }
    // MARK: - 페이징선택
    func savePagingNumberInUD(value:Int) {
        UserDefaults.standard.set(value, forKey: kInt_pagingNumber)
        UserDefaults.standard.synchronize()
    }
    func loadPagingNumberFromUD() -> Int {
        let value = UserDefaults.standard.integer(forKey: kInt_pagingNumber)
        return value
    }
}
