//
//  ModelDBTodo.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift

class ModelDBTodo: Object {
    // ID 저장 아이디 = 20190101 형식
    @objc dynamic var id = ""
    // todo 제목
    @objc dynamic var title = ""
    
    convenience init(id:String, title:String) {
        self.init()
        self.id = id
        self.title = title
    }
    
    convenience init(todo:ModelTodo) {
        let id = todo.id
        let title = todo.title
        self.init(id: id, title: title)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
