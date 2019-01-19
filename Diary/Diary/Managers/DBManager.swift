//
//  DBManager.swift
//  Diary
//
//  Created by Byunsangjin on 11/01/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager: NSObject {
    // MARK:- Variables
    var realm: Realm!
    
    
    // MARK:- Constants
    static let shared = DBManager()
    
    
    
    // MARK:- Methods
    override init() {
        super.init()
        
        self.realm = try! Realm()
    }
    
    
    
    // Select
    // 유저 정보 불러오기
    func selectUserDB() -> User {
        print("selectUserDB")
        if let dbUser = self.realm.objects(DBUser.self).first { // DB에 유저가 존재 한다면
            let user = User.init(dbUser: dbUser)
            
            return user
        } else { // DB에 유저가 없다면
            return User.init()
        }
    }
    
    
    
    // 계획 정보 불러오기
    func selectPlanDB() -> Array<Plan> {
        print("selectPlanDB")
        var planArray = Array<Plan>()
        
        let dbPlanArray = self.realm.objects(DBPlan.self)
        for dbPlan in dbPlanArray {
            let plan = Plan.init(dbPlan: dbPlan)
            planArray.append(plan)
        }
        
        return planArray
    }
    
    
    
    // TodoList 불러오기
    func selectTodoDB(withoutCheckedBox: Bool = false) -> Array<Todo> {
        print("selectTodoDB")
        var todoArray = Array<Todo>()
        
        let dbTodoArray: Results<DBTodo>?
        if withoutCheckedBox { // 체크 박스가 체크된 todo 제외할 때
            dbTodoArray = self.realm.objects(DBTodo.self).filter("isSelected = false")
        } else { // 모든 todo
            dbTodoArray = self.realm.objects(DBTodo.self)
        }
        
        for dbTodo in dbTodoArray! {
            let todo = Todo.init(dbTodo: dbTodo)
            todoArray.append(todo)
        }
        
        return todoArray
    }
    
    
    
    // Insert
    // 계획 추가하기
    func addPlanDB(plan: Plan) {
        let dbPlan = DBPlan.init(plan: plan)
        
        try! self.realm.write {
            realm.add(dbPlan)
            
            print("DB : addPlan")
        }
    }
    
    
    
    // Todo 추가하기
    func addTodoDB(todo: Todo) {
        let dbTodo = DBTodo.init(todo: todo)
        
        try! self.realm.write {
            realm.add(dbTodo)
            
            print("DB : addTodo")
        }
    }
    
    
    
    // Update
    // 유저 정보 업데이트
    func updateUserDB(user: User) {
        let dbUser = DBUser.init(user: user)
        
        try! self.realm.write {
            realm.add(dbUser, update: true)
            
            print("DB : updateUserDB")
        }
    }
    
    
    
    // Todo 체크 정보 업데이트
    func updateTodoIsSelectedDB(todo: Todo) {
        let dbTodo = DBTodo.init(todo: todo)
        
        try! self.realm.write {
            realm.add(dbTodo, update: true)
            
            print("DB : updateTodoDB")
        }
    }
}

