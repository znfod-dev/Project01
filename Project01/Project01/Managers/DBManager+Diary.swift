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
    func insertTodo(todo:Todo) {
        print("insertDiary")
        let dbTodo = DBTodo.init(todo: todo)
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
        if let dbDiary = self.database.objects(ModelDBDiary.self).filter("id = '\(id)'").first {
            let diary = ModelDiary.init(dbDiary: dbDiary)
            
            return diary
        }else {
            let diary = ModelDiary.init()
            diary.id = id
            self.insertDiary(diary: diary)
            let dbTodoList = self.database.objects(DBTodo.self).filter("date = '\(id)'")
            for dbTodo in dbTodoList {
                diary.todoList.append(Todo.init(dbTodo: dbTodo))
            }
            return diary
        }
    }
    func selectTodo(date:Date) -> Array<Todo> {
        var todoList = Array<Todo>()
        let dbTodoList = self.database.objects(DBTodo.self)
        for dbTodo in dbTodoList {
            todoList.append(Todo.init(dbTodo: dbTodo))
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
    
}
