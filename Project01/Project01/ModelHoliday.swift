//
//  ModelHoliday.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 22..
//  Copyright © 2019년 sama73. All rights reserved.
// 공휴일 정보
// 2015.01 ~ 올해 12월까지 검색 가능

import UIKit

class ModelHoliday: NSObject {

    // 날짜(YYYYMM) 공휴일 API 불렀는지 체크하기 위해서
    @objc dynamic var dateYYYYMM: Int = 0
    // 날짜(YYYYMMDD)
    @objc dynamic var dateYYYYMMDD: Int = 0
    // 공휴일 이름
    @objc dynamic var name: String = ""
    
    
    convenience init(dateYYYYMM: Int,
                     dateYYYYMMDD: Int,
                     name: String) {
        self.init()
        
        self.dateYYYYMM = dateYYYYMM
        self.dateYYYYMMDD = dateYYYYMMDD
        self.name = name
    }
}
