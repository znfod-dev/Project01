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
    var planTitle: String? = ""
    var startDay: String? = ""
    var endDay: String? = ""
    var planMemo: String? = ""
    var viewColor: String? = ""
    
    var isDeleted = false
    
    convenience init(uid: String, date: Date, planTitle: String, planMemo: String, startDay: String, endDay: String, viewColor: String, isDeleted: Bool) {
        self.init()
        
        self.uid = uid
        self.date = date
        self.planTitle = planTitle
        self.planMemo = planMemo
        self.startDay = startDay
        self.endDay = endDay
        self.viewColor = viewColor
        
        self.isDeleted = isDeleted
    }
    
    convenience init(dbPlan: ModelDBPlan) {
        let uid = dbPlan.uid
        let date = dbPlan.date
        let planTitle = dbPlan.planTitle!
        let memo = dbPlan.planMemo!
        let startDay = dbPlan.startDay!
        let endDay = dbPlan.endDay!
        let viewColor = dbPlan.viewColor!
        let isDeleted = dbPlan.isDeleted
        
        self.init(uid: uid!, date: date!, planTitle: planTitle, planMemo: memo, startDay: startDay, endDay: endDay, viewColor: viewColor, isDeleted: isDeleted)
    }
}
