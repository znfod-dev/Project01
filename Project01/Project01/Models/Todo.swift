//
//  Todo.swift
//  Project01
//
//  Created by Byunsangjin on 20/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class Todo {
    var uid: String?
    var title: String?
    var isSelected: Bool?
    var date: String?
    
    convenience init(uid: String, title: String, date: String, isSelected: Bool = false) {
        self.init()
        self.uid = uid
        self.title = title
        self.date = date
        self.isSelected = isSelected
    }
    
    convenience init(dbTodo: DBTodo) {
        let uid = dbTodo.uid
        let title = dbTodo.title
        let date = dbTodo.date
        let isSelected = dbTodo.isSelected
        
        self.init(uid: uid!, title: title!, date: date!, isSelected: isSelected)
    }
}
