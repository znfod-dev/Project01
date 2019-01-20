//
//  DBTodo.swift
//  Project01
//
//  Created by Byunsangjin on 20/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift

class DBTodo: Object {
    @objc dynamic var uid: String? // uid
    @objc dynamic var title: String?
    @objc dynamic var isSelected = false
    @objc dynamic var date:String?
    
    convenience init(uid: String, title: String, date: String, isSelected: Bool) {
        self.init()
        
        self.uid = uid
        self.title = title
        self.date = date
        self.isSelected = isSelected        
    }
    
    convenience init(todo: Todo) {
        let uid = todo.uid
        let title = todo.title
        let date = todo.date
        let isSelected = todo.isSelected
        
        self.init(uid: uid!, title: title!, date: date!, isSelected: isSelected!)
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}
