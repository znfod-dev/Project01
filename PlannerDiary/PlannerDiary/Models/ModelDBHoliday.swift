//
//  ModelDBHoliday.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 22..
//  Copyright © 2019년 sama73. All rights reserved.
// 공휴일 정보
// 2015.01 ~ 올해 12월까지 검색 가능

import UIKit
import RealmSwift


class ModelDBHoliday: Object {

    // 날짜(YYYYMM) 공휴일 API 불렀는지 체크하기 위해서
    @objc dynamic var dateYYYYMM: Int = 0
    // 날짜(YYYYMMDD)
    @objc dynamic var dateYYYYMMDD: Int = 0
    // 공휴일 이름
    @objc dynamic var name: String = ""

    
    convenience init(dateYYYYMM: Int,
                     dateYYYYMMDD: Int,
                     name: String) {
        self.init()
        
        self.dateYYYYMM = dateYYYYMM
        self.dateYYYYMMDD = dateYYYYMMDD
        self.name = name
    }
}

// NSCopying copy기능 처리 해줄려고
extension ModelDBHoliday: NSCopying {
	// 클래스 복사
	func copy(with zone: NSZone? = nil) -> Any {
		let copy = ModelDBHoliday(dateYYYYMM: dateYYYYMM,
								  dateYYYYMMDD: dateYYYYMMDD,
								  name: name)
		
		return copy
	}
	
	// 딕셔너리 값으로 필드값 세팅해주기
	convenience init(_ dicFields: [String: String]) {
		self.init()
		
		self.SQLParsing(dicFields)
	}
	
	// 필드 값 세팅
	func setField(field: String, value: String) {
		
		if field == "dateYYYYMM" {
			self.dateYYYYMM = Int(value) ?? 0
		}
		if field == "dateYYYYMMDD" {
			self.dateYYYYMMDD = Int(value) ?? 0
		}
		else if field == "name" {
			self.name = value
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
			let newObject = ModelDBHoliday(dicFields!)
			
			// isPrimaryKey는 프라이머리키 설정 했는지 유무
			DBManager.sharedInstance.insertSQL(objs: newObject, isPrimaryKey: false)
		}
		else if command == "UPDATE" {
			// 조건식 검색해서 존재할 경우
			let objects = DBManager.sharedInstance.selectSQL(type: ModelDBHoliday.self, condition: condition ?? "")?.first
			if objects != nil {
				let newObject: ModelDBHoliday = objects?.copy() as! ModelDBHoliday
				
				// 변경된 내용 수정
				newObject.SQLParsing(dicFields!)
				
				// isPrimaryKey는 프라이머리키 설정 했는지 유무
				DBManager.sharedInstance.updateSQL(objs: newObject, isPrimaryKey: false)
			}
		}
		else if command == "DELETE" {
			// 조건식 검색해서 존재할 경우
			let objects = DBManager.sharedInstance.selectSQL(type: ModelDBHoliday.self, condition: condition ?? "")?.first
			if objects != nil {
				DBManager.sharedInstance.deleteSQL(objs: objects!)
			}
		}
		else if command == "SELECT" {
			// 검색 조건이 없을 경우 전체 검색
			if condition == nil {
				return DBManager.sharedInstance.selectSQL(type: ModelDBHoliday.self)
			}
				// 검색 조건이 있을 경우 조건 검색
			else {
				return DBManager.sharedInstance.selectSQL(type: ModelDBHoliday.self, condition: condition ?? "")
			}
		}
		
		return nil
	}
}
