//
//  Defines.swift
//  Project01ForZn
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Device Define
// 스크린 크기
let DEF_SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
let DEF_SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height

// 스케일 기준 사이즈
let DEF_SCREEN_375_WIDTH: CGFloat = 375.0
let DEF_SCREEN_375_HEIGHT: CGFloat = 667.0

// 375화면 기준 스케일값
let DEF_WIDTH_375_SCALE: CGFloat = (DEF_SCREEN_WIDTH < DEF_SCREEN_HEIGHT) ? (DEF_SCREEN_WIDTH / DEF_SCREEN_375_WIDTH) : (DEF_SCREEN_HEIGHT / DEF_SCREEN_375_WIDTH)

// 네트워크 타임아웃 인터벌
let DEF_TIMEOUT_INTERVAL: TimeInterval = 10.0


// MARK: - NSUserDefaults Key Define
// 앱 최초 실행했는지
let kBool_isFirstAppRun = "isFirstAppRunKey"
// 음력 키값
let kBool_isLunarCalendar = "isLunarCalendarKey"
// 페이징 키값
// 1
// 2
// 3
let kInt_pagingNumber = "pagingNumberKey"
// 시작날짜
let kDate_MinimumDate = "minimumDateKey"
// 마지막날짜
let kDate_MaximumDate = "maximumDateKey"
// 알람시간 날짜
let kDate_AlarmTime = "alarmTimeKey"
// 저장된 폰트
let kFont_SavedFont = "savedFontKey"
// 저장된 폰트 이름
let kFont_FontName = "fontNameKey"
// 저장된 폰트 사이즈
let kFloat_fontSize = "fontSizeKey"
// 음력 키값
let kBool_isiCloudEnd = "isiCloudEndKey"

// MARK: - enum
enum Month: Int {
    case january = 1
    case february = 2
    case march = 3
    case april = 4
    case may = 5
    case june = 6
    case july = 7
    case august = 8
    case september = 9
    case october = 10
    case november = 11
    case december = 12
    
    func toString() -> String {
        switch self {
        case .january:
            return "1월"
        case .february:
            return "2월"
        case .march:
            return "3월"
        case .april:
            return "4월"
        case .may:
            return "5월"
        case .june:
            return "6월"
        case .july:
            return "7월"
        case .august:
            return "8월"
        case .september:
            return "9월"
        case .october:
            return "10월"
        case .november:
            return "11월"
        case .december:
            return "12월"
        }
    }
}

enum WeekDay: Int {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    func toString() -> String {
        switch self {
        case .monday:
            return "월요일"
        case .tuesday:
            return "화요일"
        case .wednesday:
            return "수요일"
        case .thursday:
            return "목요일"
        case .friday:
            return "금요일"
        case .saturday:
            return "토요일"
        case .sunday:
            return "일요일"
        }
    }
}

enum FontType: String, CaseIterable {
    case nanumBarunpenB = "NanumBarunpen-Bold"
    case nanumBarunpenR = "NanumBarunpen"
    case nanumPen = "NanumPen"
    case nanumBrush = "NanumBrush"
    case nanumBarunGothic = "NanumBarunGothicLight"
    case nanumBarunGothicBold = "NanumBarunGothicBold"
    
    func ttf() -> String {
        switch self {
        case .nanumBarunpenB:
            return "NanumBarunpen-Bold"
        case .nanumBarunpenR:
            return "NanumBarunpen"
        case .nanumPen:
            return "NanumPen"
        case .nanumBrush:
            return "NanumBrush"
        case .nanumBarunGothic:
            return "NanumBarunGothicLight"
        case .nanumBarunGothicBold:
            return "NanumBarunGothicBold"
        }
    }
    func toFontName() -> String {
        switch self {
        case .nanumBarunpenB:
            return "나눔바른펜Bold"
        case .nanumBarunpenR:
            return "나눔바른펜"
        case .nanumPen:
            return "나눔펜"
        case .nanumBrush:
            return "나눔브러쉬"
        case .nanumBarunGothic:
            return "나눔바른고딕"
        case .nanumBarunGothicBold:
            return "나눔바른고딕Bold"
        }
    }
}

enum Profile: Int {
    case name = 0
    case surname = 1
    case address = 2
    case phone = 3
    case mobile = 4
    case email = 5
    case workAddress = 7
    case workPhone = 8
    case workEmail = 9
    case favouriteFilm = 11
    case favouriteBook = 12
    case favouriteMusic = 13
    
    func toString() -> String {
        switch self {
        case .name:
            return "name"
        case .surname:
            return "surname"
        case .address:
            return "address"
        case .phone:
            return "phone"
        case .mobile:
            return "mobile"
        case .email:
            return "email"
        case .workAddress:
            return "workAddress"
        case .workPhone:
            return "workPhone"
        case .workEmail:
            return "workEmail"
        case .favouriteFilm:
            return "favouriteFilm"
        case .favouriteBook:
            return "favouriteBook"
        case .favouriteMusic:
            return "favouriteMusic"
        }
    }
    func section() -> Int {
        switch self {
        case .name:
            return 0
        case .surname:
            return 1
        case .address:
            return 2
        case .phone:
            return 3
        case .mobile:
            return 4
        case .email:
            return 5
        case .workAddress:
            return 6
        case .workPhone:
            return 7
        case .workEmail:
            return 8
        case .favouriteFilm:
            return 9
        case .favouriteBook:
            return 10
        case .favouriteMusic:
            return 11
        }
    }
}

enum ViewColor: Int {
    case one = 0
    case two = 1
    case three = 2
    case four = 3
    case five = 4
    
    func toString() -> String {
        switch self {
        case .one:
            return "CE78DF"
        case .two:
            return "A178DF"
        case .three:
            return "7589E1"
        case .four:
            return "75A7E1"
        case .five:
            return "75D3E1"
        }
    }
}



enum AddConstant: CGFloat {
    case keyboardHeight = 185
    case alertViewHeightWithPicker = 550
    case alertViewHeightWithoutPicker = 400
    case dateConstantWithPicker = 10
    case dateConstantWithoutPicker = 170
}
