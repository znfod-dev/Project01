//
//  ModelTodo.swift
//  Project01
//
//  Created by 박종현 on 23/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit

class ModelTodo: NSObject {
    // ID 저장 아이디 = UUID().uuidString
    var id = String()
    // todo title
    var title = String()
    
    override init() {
        super.init()
    }
    convenience init(title:String) {
        self.init()
        self.id = UUID().uuidString
        self.title = title
    }
    
    convenience init(id:String, title:String) {
        self.init()
        self.id = id
        self.title = title
    }
    
    convenience init(dbTodo:ModelDBTodo) {
        let id = dbTodo.id
        let title = dbTodo.title
        self.init(id: id, title: title)
        
    }
    
}
