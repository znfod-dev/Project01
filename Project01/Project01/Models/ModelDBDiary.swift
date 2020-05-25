//
//  ModelDBDiary.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift
import CloudKit

class ModelDBDiary: Object {
    // ID 저장 아이디 = 20190101 형식
    @objc dynamic var id = ""
    // date 저장날짜
    @objc dynamic var date = Date()
    // 날짜에 해당하는 todoList
    var todoList = List<ModelDBTodo>()
    // 날짜에 해당하는 일기
    @objc dynamic var diary:String? = nil
    @objc dynamic var isDeleted = false
    
    convenience init(id:String, date:Date, todoList:List<ModelDBTodo>, diary:String) {
        self.init()
        self.id = id
        self.date = date
        self.todoList = todoList
        self.diary = diary
    }
    convenience init(diary:ModelDiary) {
        let id = diary.id
        let date = diary.date
        let list = List<ModelDBTodo>()
        for todo in diary.todoList {
            list.append(ModelDBTodo(todo: todo))
        }
        let diary = diary.diary
        self.init(id: id, date: date, todoList: list, diary: diary)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

