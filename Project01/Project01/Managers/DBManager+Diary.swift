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
        if let dbDiary = self.database.objects(ModelDBDiary.self).filter("id = '\(id)'").first {
            let diary = ModelDiary.init(dbDiary: dbDiary)
            let dbTodoList = self.database.objects(ModelDBTodo.self).filter("date = '\(id)'")
            for dbTodo in dbTodoList {
                diary.todoList.append(ModelTodo.init(dbTodo: dbTodo))
            }
            return diary
        }else {
            let diary = ModelDiary.init()
            diary.id = id
            self.insertDiary(diary: diary)
            let dbTodoList = self.database.objects(ModelDBTodo.self).filter("date = '\(id)'")
            for dbTodo in dbTodoList {
                diary.todoList.append(ModelTodo.init(dbTodo: dbTodo))
            }
            return diary
        }
    }
    // 지정된 날짜의 해당 월의 모든 다이어리 리스트 가져오기
    func selectDiary(selectedDate:Date) -> Array<ModelDiary> {
        var diaryArray = Array<ModelDiary>()
        let startDate = Date().startOfMonth(date: selectedDate)
        let endDate = Date().endOfMonth(date: selectedDate)
        
        let list = self.database.objects(ModelDBDiary.self).filter("date BETWEEN {%@, %@}", startDate, endDate)
        if list.count > 0 {
            for dbDiary in list {
                let diary = ModelDiary.init(dbDiary: dbDiary)
                diaryArray.append(diary)
            }
        }
        return diaryArray
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
    
    // Exist
    // 입력한 날짜에 다이어리가 존재하면 true, 아니면 false
    func existDiary(date:Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let id = dateFormatter.string(from: date)
        if let dbDiary = self.database.objects(ModelDBDiary.self).filter("id = '\(id)'").first {
            return true
        }else {
            return false
        }
        
    }
}
