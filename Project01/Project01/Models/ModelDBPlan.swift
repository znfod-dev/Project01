//
//  DBPlan.swift
//  Project01
//
//  Created by Byunsangjin on 21/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift
import IceCream
import CloudKit

class ModelDBPlan: Object {
    @objc dynamic var uid: String? // uid
    
    @objc dynamic var date: Date? // 계획 추가한 시간
    
    @objc dynamic var planTitle: String? // 계획명
    @objc dynamic var planMemo: String? // 계획명
    @objc dynamic var startDay: String? // 계획 시작일
    @objc dynamic var endDay: String? // 계획 종료일
    
    @objc dynamic var isDeleted = false
    
    convenience init(uid: String, planTitle: String, planMemo: String, startDay: String, endDay: String) {
        self.init()
        
        self.uid = uid
        self.date = Date()
        self.planTitle = planTitle
        self.planMemo = planMemo
        self.startDay = startDay
        self.endDay = endDay
    }
    
    convenience init(plan: ModelPlan) {
        let uid = plan.uid
        let planTitle = plan.planTitle
        let planMemo = plan.planMemo
        let startDay = plan.startDay
        let endDay = plan.endDay
        
        self.init(uid: uid!, planTitle: planTitle!, planMemo: planMemo!, startDay: startDay!, endDay: endDay!)
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}

extension ModelDBPlan: CKRecordConvertible {
    // Yep, leave it blank!
}

extension ModelDBPlan: CKRecordRecoverable {
    // Leave it blank, too.
}
