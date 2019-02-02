//
//  DBManager+Todo.swift
//  Project01
//
//  Created by Byunsangjin on 29/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import Foundation
import RealmSwift

// TodoList DBManager
extension DBManager {
    // Select
    // TodoList 불러오기
    func selectTodoDB(withoutCheckedBox: Bool = false) -> Array<Todo> {
        print("selectTodoDB")
        var todoArray = Array<Todo>()
        
        let dbTodoArray: Results<DBTodo>?
        if withoutCheckedBox { // 체크 박스가 체크된 todo 제외할 때
            dbTodoArray = self.database.objects(DBTodo.self).filter("isSelected = false")
        } else { // 모든 todo
            dbTodoArray = self.database.objects(DBTodo.self)
        }
        
        for dbTodo in dbTodoArray! {
            let todo = Todo.init(dbTodo: dbTodo)
            todoArray.append(todo)
        }
        
        return todoArray
    }
    
    
    
    // Insert
    // Todo 추가하기
    func addTodoDB(todo: Todo) {
        let dbTodo = DBTodo.init(todo: todo)
        
        try! self.database.write {
            database.add(dbTodo, update: true)
            
            print("DB : addTodo")
        }
    }
    
    
    
    // 계획 삭제
    func deleteTodoDB(todo: Todo, completion: (()->Void)? = nil) {
        // DB에서 uid를 가지고 객체 찾기
        guard let todoToDelete = self.database.object(ofType: DBTodo.self, forPrimaryKey: todo.uid!) else {
            print("deletePlanDB Fail")
            return
        }
        
        // 찾은 객체 삭제
        try! self.database.write {
            self.database.delete(todoToDelete)
            
            completion?()
        }
    }
    
    
    
    // Update
    // Todo 체크 정보 업데이트
    func updateTodo(todo: Todo) {
        let dbTodo = DBTodo.init(todo: todo)
        
        try! self.database.write {
            database.add(dbTodo, update: true)
            
            print("DB : updateTodoDB")
        }
    }
}