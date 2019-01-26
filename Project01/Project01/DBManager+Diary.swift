//
//  DBManager+Diary.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import Foundation

extension DBManager {
    
    // Insert
    func insertDiary(diary:ModelDiary) {
        print("insertDiary")
        let dbDiary = ModelDBDiary.init(diary: diary)
        try! self.database.write {
            self.database.add(dbDiary)
        }
    }
    func insertTodo(todo:ModelTodo) {
        print("insertDiary")
        let dbTodo = ModelDBTodo.init(todo: todo)
        try! self.database.write {
            self.database.add(dbTodo)
        }
    }
    
    // Select
    func selectDiary(date:Date) -> ModelDiary {
        print("selectDiary")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let id = dateFormatter.string(from: date)
        print("id : \(id)")
        if let dbDiary = self.database.objects(ModelDBDiary.self).filter("id = '\(id)'").first {
            print("있음")
            let diary = ModelDiary.init(dbDiary: dbDiary)
            let dbTodoList = self.database.objects(ModelDBTodo.self)
            print("dbTodoList : \(dbTodoList.count)")
            for dbTodo in dbTodoList {
                diary.todoList.append(ModelTodo.init(dbTodo: dbTodo))
            }
            return diary
        }else {
            print("없음")
            
            
            let diary = ModelDiary.init()
            diary.id = id
            self.insertDiary(diary: diary)
            return diary
        }
    }
    func selectTodo(date:Date) -> Array<ModelTodo> {
        var todoList = Array<ModelTodo>()
        let dbTodoList = self.database.objects(ModelDBTodo.self)
        for dbTodo in dbTodoList {
            todoList.append(ModelTodo.init(dbTodo: dbTodo))
        }
        return todoList
    }
    
    
    // Update
    func updateDiary(diary:ModelDiary) {
        print("updateDiary")
        let dbDiary = ModelDBDiary.init(diary: diary)
        try! self.database.write {
            self.database.add(dbDiary, update: true)
        }
    }
    func updateTodo(todo:ModelTodo) {
        let dbTodo = ModelDBTodo.init(todo: todo)
        try! self.database.write {
            self.database.add(dbTodo, update: true)
        }
    }
}
