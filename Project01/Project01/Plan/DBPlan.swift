//
//  DBPlan.swift
//  Project01
//
//  Created by Byunsangjin on 21/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift

class DBPlan: Object {
    @objc dynamic var uid: String? // uid
    
    @objc dynamic var date: Date? // 계획 추가한 시간
    // 0 ~ 4 순서대로 일, 주, 월, 년, 직접 입력
    @objc dynamic var planType: Int = 0
    @objc dynamic var planTitle: String? // 계획명
    @objc dynamic var startDay: String? // 계획 시작일
    @objc dynamic var endDay: String? // 계획 종료일
    
    convenience init(planType: Int, planTitle: String, startDay: String, endDay: String) {
        self.init()
        
        self.uid = UUID.init().uuidString
        self.date = Date()
        self.planType = planType
        self.planTitle = planTitle
        self.startDay = startDay
        self.endDay = endDay
    }
    
    convenience init(plan: Plan) {
        let planType = plan.planType
        let planTitle = plan.planTitle
        let startDay = plan.startDay
        let endDay = plan.endDay
        
        self.init(planType: planType!, planTitle: planTitle!, startDay: startDay!, endDay: endDay!)
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}
