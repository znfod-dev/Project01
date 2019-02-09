//
//  ModelDiary.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class ModelDiary: NSObject {
    // id 저장 아이디 = 20190101 형식
    var id = String()
    // date 저장날짜
    var date = Date()
    // 날짜에 해당하는 todoList
    var todoList = Array<ModelTodo>()
    // 날짜에 해당하는 일기
    var diary = String()
    
    
    override init() {
        super.init()
    }
    
    convenience init(id:String, date:Date, todoList:Array<ModelTodo>, diary:String) {
        self.init()
        self.id = id
        self.date = date
        self.todoList = todoList
        self.diary = diary
    }
    
    convenience init(dbDiary:ModelDBDiary) {
        let id = dbDiary.id
        let date = dbDiary.date
        let list = Array<ModelTodo>()
        /*
        for dbTodo in dbDiary.todoList {
            list.append(Todo(dbTodo: dbTodo))
        }
         */
        let diary = dbDiary.diary
        self.init(id: id, date: date, todoList: list, diary: diary!)
    }
    
}
