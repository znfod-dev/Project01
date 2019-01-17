//
//  Defines.swift
//  Project01ForZn
//
//  Created by 박종현 on 14/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import Foundation


enum Month: Int {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    
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
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
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

enum ProfileTableNo: Int {
    case name = 0
    case surname = 1
    case address = 2
    case phone = 3
    case mobile = 4
    case email = 5
    case workAddress = 6
    case workPhone = 7
    case workEmail = 8
    case favouriteFilm = 9
    case favouriteBook = 10
    case favouriteMusic = 11
    
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


