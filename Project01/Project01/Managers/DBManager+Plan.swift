//
//  DBManager+Plan.swift
//  Project01
//
//  Created by Byunsangjin on 29/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import Foundation
import RealmSwift

// PlanList DBManager
extension DBManager {
    // Select
    // 계획 정보 불러오기
    func selectPlanDB() -> Array<Plan> {
        print("selectPlanDB")
        var planArray = Array<Plan>()
        
        let dbPlanArray = self.database.objects(DBPlan.self)
        for dbPlan in dbPlanArray {
            let plan = Plan.init(dbPlan: dbPlan)
            planArray.append(plan)
        }
        
        return planArray
    }
    
    
    
    // Insert
    // 계획 추가
    func addPlanDB(plan: Plan) {
        let dbPlan = DBPlan.init(plan: plan)
        
        try! self.database.write {
            self.database.add(dbPlan)
            
            print("DB : addPlan")
        }
    }
    
    
    
    // Delete
    // 계획 삭제
    func deletePlanDB(plan: Plan, completion: (()->Void)? = nil) {
        // DB에서 uid를 가지고 객체 찾기
        guard let planToDelete = self.database.object(ofType: DBPlan.self, forPrimaryKey: plan.uid!) else {
            print("deletePlanDB Fail")
            return
        }
        
        // 찾은 객체 삭제
        try! self.database.write {
            self.database.delete(planToDelete)
            
            completion?()
        }
    }
}