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

// NSCopying copy기능 처리 해줄려고
extension DBTodo: NSCopying {
	// 클래스 복사
	func copy(with zone: NSZone? = nil) -> Any {
		let copy = DBTodo(uid: uid!, title: title!, date: date!, isSelected: isSelected)
		
		return copy
	}
	
	// 딕셔너리 값으로 필드값 세팅해주기
	convenience init(_ dicFields: [String: String]) {
		self.init()
		
		self.SQLParsing(dicFields)
	}
	
	// 필드 값 세팅
	func setField(field: String, value: String) {
		
		if field == "uid" {
			self.uid = value
		}
		if field == "title" {
			self.title = value
		}
		else if field == "date" {
			self.date = value
		}
		else if field == "isSelected" {
			self.isSelected = Bool(value) ?? true
		}
	}
	
	// SQL 파싱
	func SQLParsing(_ dicFields: [String: String]) {
		
		for key in dicFields.keys {
			// 필드 값 세팅
			self.setField(field: key, value: dicFields[key]!)
		}
	}
	
	// SQL 실행하다.
	@discardableResult  // <- Result of call to 'SQLExcute(sql:)' is unused
	// command : 명령어
	// condition : 조건식
	// dicFields : 필드명 + 필드값
	static func SQLExcute(command: String, condition: String?, dicFields: [String: String]?) -> Results<Object>? {
		
		if command == "INSERT" {
			let newObject = DBTodo(dicFields!)
			
			// isPrimaryKey는 프라이머리키 설정 했는지 유무
			DBManager.sharedInstance.insertSQL(objs: newObject, isPrimaryKey: false)
		}
		else if command == "UPDATE" {
			// 조건식 검색해서 존재할 경우
			let objects = DBManager.sharedInstance.selectSQL(type: DBTodo.self, condition: condition ?? "")?.first
			if objects != nil {
				let newObject: DBTodo = objects?.copy() as! DBTodo
				
				// 변경된 내용 수정
				newObject.SQLParsing(dicFields!)
				
				// isPrimaryKey는 프라이머리키 설정 했는지 유무
				DBManager.sharedInstance.updateSQL(objs: newObject, isPrimaryKey: false)
			}
		}
		else if command == "DELETE" {
			// 조건식 검색해서 존재할 경우
			let objects = DBManager.sharedInstance.selectSQL(type: DBTodo.self, condition: condition ?? "")?.first
			if objects != nil {
				DBManager.sharedInstance.deleteSQL(objs: objects!)
			}
		}
		else if command == "SELECT" {
			// 검색 조건이 없을 경우 전체 검색
			if condition == nil {
				return DBManager.sharedInstance.selectSQL(type: DBTodo.self)
			}
				// 검색 조건이 있을 경우 조건 검색
			else {
				return DBManager.sharedInstance.selectSQL(type: DBTodo.self, condition: condition ?? "")
			}
		}
		
		return nil
	}
}
