//
//  DBTodo.swift
//  Project01
//
//  Created by Byunsangjin on 20/01/2019.
//  Copyright © 2019 Znfod. All rights reserved.
//

import UIKit
import RealmSwift
import IceCream
import CloudKit
import Foundation

class DBTodo: BaseObject {
    @objc dynamic var uid: String? // uid
    @objc dynamic var title: String?
    @objc dynamic var isSelected = false
    @objc dynamic var date:String?
    
    @objc dynamic var isDeleted = false
    
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
    
    // 프라이머리키 설정했나?
    override class func isPrimaryKey() -> Bool {
        return (primaryKey() != nil)
    }
    
    // 오브젝트 생성
    override class func createObject(_ dicFields: [String: String]) -> DBTodo {
        let this = self.init()
        
        this.SQLParsing(dicFields)
        
        return this
    }
    
    // 오브젝트 복사후 필드값 세팅
    override class func copyObject(object: Object, dicFields: [String: String]) -> DBTodo {
        let newObject: DBTodo = object.copy() as! DBTodo
        newObject.SQLParsing(dicFields)
        
        return newObject
    }
}

// NSCopying copy기능 처리 해줄려고
extension DBTodo: NSCopying {
	// 클래스 복사
	func copy(with zone: NSZone? = nil) -> Any {
		let copy = DBTodo(uid: uid!, title: title!, date: date!, isSelected: isSelected)
		
		return copy
	}
	
    // SQL 파싱
    func SQLParsing(_ dicFields: [String: String]) {
        
        for key in dicFields.keys {
            // 필드 값 세팅
            self.setField(field: key, value: dicFields[key]!)
        }
    }
    
	// 필드 값 세팅
	func setField(field: String, value: String) {
		
		if field == "uid" {
			self.uid = value
		}
		else if field == "title" {
			self.title = value
		}
		else if field == "date" {
			self.date = value
		}
		else if field == "isSelected" {
			self.isSelected = Bool(value) ?? true
		}
	}
}



extension DBTodo: CKRecordConvertible {
    // Yep, leave it blank!
}

extension DBTodo: CKRecordRecoverable {
    // Leave it blank, too.
}
