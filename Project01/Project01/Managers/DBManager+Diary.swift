//
//  DBManager+Diary.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import Foundation
import CloudKit

extension DBManager {
    
    // Insert
    func insertDiary(diary:ModelDiary) {
        print("insertDiary???")
        let dbDiary = ModelDBDiary.init(diary: diary)
        try! self.database.write {
            self.database.add(dbDiary, update: .modified)
        }
        print("insertDiary Finish")
    }
    func insertTodo(todo:ModelTodo) {
        print("insertTodo")
        let dbTodo = ModelDBTodo.init(todo: todo)
        try! self.database.write {
            self.database.add(dbTodo)
        }
    }
    
    // Select
    func selectDiary(date:Date) -> ModelDiary! {
        print("selectDiary")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let id = dateFormatter.string(from: date)
        if let dbDiary = self.database.objects(ModelDBDiary.self).filter("id = '\(id)' AND isDeleted = false").first {
            let diary = ModelDiary.init(dbDiary: dbDiary)
            let dbTodoList = self.database.objects(ModelDBTodo.self).filter("date = '\(id)' AND isDeleted = false")
            for dbTodo in dbTodoList {
                diary.todoList.append(ModelTodo.init(dbTodo: dbTodo))
            }
            print("return diary")
            return diary
        }else {
            print("return nil")
            return nil
        }
    }
    // 지정된 날짜의 해당 월의 모든 다이어리 리스트 가져오기
    func selectDiaryList(date:Date) -> Array<ModelDiary> {
        print("selectDiaryList")
        var diaryList = Array<ModelDiary>()
        let startDate = Date().startOfMonth(date: date)
        let endDate = Date().endOfMonth(date: date)
        
        let list = self.database.objects(ModelDBDiary.self).filter("date BETWEEN {%@, %@} AND isDeleted = false", startDate, endDate).sorted(byKeyPath: "id", ascending: true)
        if list.count > 0 {
            for dbDiary in list {
                let diary = ModelDiary.init(dbDiary: dbDiary)
                print("diary : \(diary.id)")
                let todoList = self.database.objects(ModelDBTodo.self).filter("date = '\(diary.id)' AND isDeleted = false")
                for dbTodo in todoList {
                    print("todo : \(dbTodo.date)")
                    diary.todoList.append(ModelTodo.init(dbTodo: dbTodo))
                }
                diaryList.append(diary)
                print("diary Finish : \(diary.id)")
            }
        }
        return diaryList
    }
    // 검색어
    func selectDiaryList(date:Date, diary:String) -> Array<ModelDiary> {
        print("selectDiaryList")
        var diaryList = Array<ModelDiary>()
        let startDate = Date().startOfMonth(date: date)
        let endDate = Date().endOfMonth(date: date)
        
        let list = self.database.objects(ModelDBDiary.self).filter("date BETWEEN {%@, %@} AND diary contains %@ AND isDeleted = false", startDate, endDate, diary).sorted(byKeyPath: "id", ascending: true)
        if list.count > 0 {
            for dbDiary in list {
                let diary = ModelDiary.init(dbDiary: dbDiary)
                print("diary : \(diary.id)")
                let todoList = self.database.objects(ModelDBTodo.self).filter("date = '\(diary.id)' AND isDeleted = false")
                for dbTodo in todoList {
                    print("todo : \(dbTodo.date)")
                    diary.todoList.append(ModelTodo.init(dbTodo: dbTodo))
                }
                diaryList.append(diary)
                print("diary Finish : \(diary.id)")
            }
        }
        return diaryList
    }
 
    
    
    // 날짜에 다이어리 존재 여부 확인
    func selectDiary(id:String) -> Bool {
        if let _ = self.database.objects(ModelDBDiary.self).filter("id = '\(id)' AND isDeleted = false").first {
            print("exist")
            return true
        }else {
             print("not exist")
            return false
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
            self.database.add(dbDiary, update: .modified)
        }
    }
    
    // Exist
    // 입력한 날짜에 다이어리가 존재하면 true, 아니면 false
    func existDiary(date:Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let id = dateFormatter.string(from: date)
        if let dbDiary = self.database.objects(ModelDBDiary.self).filter("id = '\(id)' AND isDeleted = false").first {
            return true
        }else {
            return false
        }
        
    }
    
    // Delete
    func deleteDiary(diary:ModelDiary, completion: (()->Void)? = nil) {
        // DB에서 uid를 가지고 객체 찾기
        guard let diaryToDelete = self.database.object(ofType: ModelDBDiary.self, forPrimaryKey: diary.id) else {
            print("deleteDiary Fail")
            return
        }
        
        // 찾은 객체 삭제
        try! self.database.write {
            print("diaryToDelete : \(diaryToDelete)")
            diaryToDelete.isDeleted = true
            
            completion?()
        }
    }
    
    func deleteAllDiary() {
        print("deleteAllDiary")
        let list = self.database.objects(ModelDBDiary.self)
        try! self.database.write {
            for diary:ModelDBDiary in list {
                print("diary : \(diary.id)")
                diary.isDeleted = true
                
            }
        }
        
    }
}
