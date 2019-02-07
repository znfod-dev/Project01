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
import IceCream
import CloudKit

class ModelDBHoliday: BaseObject {
    
	// 날짜(YYYYMM) 공휴일 API 불렀는지 체크하기 위해서
	@objc dynamic var dateYYYYMM: Int = 0
	// 날짜(YYYYMMDD)
	@objc dynamic var dateYYYYMMDD: Int = 0
	// 공휴일 이름
	@objc dynamic var name: String = ""
	
    @objc dynamic var isDeleted = false
	
	convenience init(dateYYYYMM: Int,
					 dateYYYYMMDD: Int,
					 name: String) {	
		self.init()
		
		self.dateYYYYMM = dateYYYYMM
		self.dateYYYYMMDD = dateYYYYMMDD
		self.name = name
	}
	
	override static func primaryKey() -> String? {
		return "dateYYYYMMDD"
	}
	
    // 프라이머리키 설정했나?
    override class func isPrimaryKey() -> Bool {
        return (primaryKey() != nil)
    }
    
    // 오브젝트 생성
    override class func createObject(_ dicFields: [String: String]) -> ModelDBHoliday {
        let this = self.init()
        
        this.SQLParsing(dicFields)
        
        return this
    }
    
    // 오브젝트 복사후 필드값 세팅
    override class func copyObject(object: Object, dicFields: [String: String]) -> ModelDBHoliday {
        let newObject: ModelDBHoliday = object.copy() as! ModelDBHoliday
        newObject.SQLParsing(dicFields)
        
        return newObject
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
	
    // SQL 파싱
    func SQLParsing(_ dicFields: [String: String]) {
        
        for key in dicFields.keys {
            // 필드 값 세팅
            self.setField(field: key, value: dicFields[key]!)
        }
    }
    
	// 필드 값 세팅
	func setField(field: String, value: String) {
		
		if field == "dateYYYYMM" {
			self.dateYYYYMM = Int(value) ?? 0
		}
        else if field == "dateYYYYMMDD" {
			self.dateYYYYMMDD = Int(value) ?? 0
		}
		else if field == "name" {
			self.name = value
		}
	}
}



extension ModelDBHoliday: CKRecordConvertible {
    // Yep, leave it blank!
}

extension ModelDBHoliday: CKRecordRecoverable {
    // Leave it blank, too.
}
