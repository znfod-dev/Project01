//
//  Plan.swift
//  Project01
//
//  Created by Byunsangjin on 21/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class ModelPlan {
    var uid: String?
    var date: Date?
    var planType: Int?
    var planTitle: String? = ""
    var startDay: String? = ""
    var endDay: String? = ""
    
    var isDeleted = false
    
    convenience init(uid: String, date: Date, planType: Int,planTitle: String, startDay: String, endDay: String, isDeleted: Bool) {
        self.init()
        
        self.uid = uid
        self.date = date
        self.planType = planType
        self.planTitle = planTitle
        self.startDay = startDay
        self.endDay = endDay
        self.isDeleted = isDeleted
    }
    
    convenience init(dbPlan: ModelDBPlan) {
        let uid = dbPlan.uid
        let date = dbPlan.date
        let planType = dbPlan.planType
        let planTitle = dbPlan.planTitle!
        let startDay = dbPlan.startDay!
        let endDay = dbPlan.endDay!
        let isDeleted = dbPlan.isDeleted
        
        self.init(uid: uid!, date: date!, planType: planType ,planTitle: planTitle, startDay: startDay, endDay: endDay, isDeleted: isDeleted)
    }
}
