//
//  DBManager.swift
//  Project01ForZn
//
//  Created by 박종현 on 13/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager: NSObject {
    static let shared = DBManager()
    
    let startedKey = "StartedKEY"
    
    let minimumDateKey = "MinimumDateKEY"
    let maximumDateKey = "MaximumDateKEY"
    let alarmTimeKey = "AlarmTimeKEY"
    let savedFontKey = "SavedFontKEY"
    let fontNameKey = "FontNameKEY"
    let fontSizeKey = "FontSizeKEY"
    
    override init() {
        super.init()
    }
    
    // 초기설정
    func firstInit() {
        let font = UIFont.init(name: FontType.nanumBarunpenR.ttf(), size: 20.0)
        saveFontInUD(font: font!)
        
        let minDate = Date().startOfYear()
        DBManager.shared.saveMinimumDateInUD(minimumDate: minDate)
        
        let maxDate = Date().endOfYear()
        DBManager.shared.saveMaximumDateInUD(maximumDate: maxDate)
        
    }
    
    func saveFontInUD(font:UIFont) {
        let fontName = font.fontName
        let fontSize = font.pointSize
        UserDefaults.standard.setValue(fontName, forKey: fontNameKey)
        UserDefaults.standard.setValue(fontSize, forKey: fontSizeKey)
        UserDefaults.standard.synchronize()
        
    }
    func loadFontFromUD() -> UIFont{
        let fontName:String = UserDefaults.standard.value(forKey: fontNameKey) as! String
        let fontSize:CGFloat = UserDefaults.standard.value(forKey: fontSizeKey) as! CGFloat
        let font:UIFont = UIFont.init(name: fontName, size: fontSize)!
        return font
    }
    
    func saveMinimumDateInUD(minimumDate:Date) {
        print("minimumDate : \(minimumDate.timeIntervalSince1970)")
        UserDefaults.standard.set(minimumDate.timeIntervalSince1970, forKey: minimumDateKey)
        UserDefaults.standard.synchronize()
    }
    func loadMinimumDateFromUD() -> Date {
        let minDateInterval = UserDefaults.standard.double(forKey: minimumDateKey)
        let minDate = Date.init(timeIntervalSince1970: minDateInterval)
        return minDate
    }
    
    func saveMaximumDateInUD(maximumDate:Date) {
        UserDefaults.standard.set(maximumDate.timeIntervalSince1970, forKey: maximumDateKey)
        UserDefaults.standard.synchronize()
    }
    func loadMaximumDateFromUD() -> Date {
        let maxDateInterval = UserDefaults.standard.double(forKey: maximumDateKey)
        let maxDate = Date.init(timeIntervalSince1970: maxDateInterval)
        return maxDate
    }
    
    func saveAlarmTimeInUD(time:Date) {
        UserDefaults.standard.set(time.timeIntervalSince1970, forKey: alarmTimeKey)
        UserDefaults.standard.synchronize()
    }
    func loadAlarmTimeFromUD() -> Date {
        let alarmInterval = UserDefaults.standard.double(forKey: alarmTimeKey)
        let alarmTime = Date.init(timeIntervalSince1970: alarmInterval)
        return alarmTime
    }
    
    
}
